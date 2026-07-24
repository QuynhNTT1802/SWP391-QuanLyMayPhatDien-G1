package com.quanlymayphatdien.g1.controller.warehouse.transfer;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.TransferDAO;
import com.quanlymayphatdien.g1.dal.TransferDetailDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Transfer;
import com.quanlymayphatdien.g1.entity.TransferDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.entity.Warehouse;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.NotificationService;
import com.quanlymayphatdien.g1.utils.WarehouseAccessUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "TransferController", urlPatterns = {"/transfers"})
public class TransferController extends HttpServlet {

    private final TransferDAO transferDAO = new TransferDAO();
    private final TransferDetailDAO detailDAO = new TransferDetailDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final GeneratorDAO generatorDAO = new GeneratorDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    private static final int MAX_NOTE_LENGTH = 500;
    private static final int MAX_DETAIL_NOTE_LENGTH = 500;
    private static final int MAX_QUANTITY = 100000;
    private static final int MAX_GENERATOR_ID = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showList(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit_view":
                    showEditView(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "create_export_receipt":
                    forwardToCreateExport(request, response);
                    break;
                case "create_import_receipt":
                    forwardToCreateImport(request, response);
                    break;
                default:
                    showList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/transfers");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "create":
                    handleCreate(request, response, user);
                    break;
                case "ce_approve":
                    handleCeoApprove(request, response, user);
                    break;
                case "ce_reject":
                    handleCeoReject(request, response, user);
                    break;
                case "ce_request_revision":
                    handleCeoRequestRevision(request, response, user);
                    break;
                case "edit_submit":
                    handleEditSubmit(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/transfers?error=1");
            }
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        int page = parseInt(request.getParameter("page"), 1);
        if (page < 1) {
            page = 1;
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean isCeo = perms != null && perms.contains("transfers.approve_ceo");

        int scopedWarehouseId = com.quanlymayphatdien.g1.utils.WarehouseAccessUtil.getScopedWarehouseId(session);

        Integer filterUserId = (isCeo && scopedWarehouseId <= 0) ? null : loggedUser.getId();

        int total = transferDAO.countTotal(search, statusFilter, filterUserId, scopedWarehouseId, loggedUser.getId());
        int totalPages = (int) Math.ceil((double) total / limit);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        offset = (page - 1) * limit;

        List<Transfer> list = transferDAO.findWithPagination(limit, offset, search, statusFilter,
                filterUserId, scopedWarehouseId, loggedUser.getId());
        Map<String, Integer> kpis = transferDAO.getKpiCounts(filterUserId, scopedWarehouseId, loggedUser.getId());

        request.setAttribute("transfers", list);
        request.setAttribute("kpiPendingCeo", kpis.getOrDefault(GlobalUtils.TRANSFER_STATUS_PENDING_CEO, 0));
        request.setAttribute("kpiApproved", kpis.getOrDefault(GlobalUtils.TRANSFER_STATUS_APPROVED, 0));
        request.setAttribute("kpiExported", kpis.getOrDefault(GlobalUtils.TRANSFER_STATUS_EXPORTED, 0));
        request.setAttribute("kpiCompleted", kpis.getOrDefault(GlobalUtils.TRANSFER_STATUS_COMPLETED, 0));
        request.setAttribute("kpiRejected", kpis.getOrDefault(GlobalUtils.TRANSFER_STATUS_REJECTED, 0));
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("search", search);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("activePage", "transfer-list");

        request.getRequestDispatcher("/view/warehouse/transfer/transfer-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);

        List<Generator> allActive = generatorDAO.findAllActive();
        request.setAttribute("generators", allActive);
        request.setAttribute("activePage", "transfer-create");

        List<Warehouse> allWarehouses = warehouseDAO.findAll();
        request.setAttribute("destWarehouses", allWarehouses);
        List<Warehouse> sourceWarehouses;
        if (scopedWarehouseId > 0) {
            com.quanlymayphatdien.g1.entity.Warehouse scoped = warehouseDAO.findById(scopedWarehouseId);
            request.setAttribute("scopedWarehouseId", scopedWarehouseId);
            if (scoped != null) {
                request.setAttribute("scopedWarehouseName", scoped.getName());
                request.setAttribute("defaultSourceWarehouseId", scoped.getWarehouseId());
            }
            sourceWarehouses = new ArrayList<>();
            if (scoped != null) {
                sourceWarehouses.add(scoped);
            }
        } else {
            request.setAttribute("defaultSourceWarehouseId", null);
            sourceWarehouses = allWarehouses;
        }
        request.setAttribute("warehouses", sourceWarehouses);

        Map<Integer, Integer> inStockByGen = scopedWarehouseId > 0
                ? inventoryDAO.countInStockMapByWarehouse(scopedWarehouseId)
                : new LinkedHashMap<>();
        request.setAttribute("inStockByGen", inStockByGen);

        // Build warehouse -> generator (with stock) JSON for client-side filter
        Map<Integer, List<Map<String, Object>>> warehouseData = new LinkedHashMap<>();
        warehouseData.put(0, new ArrayList<>());
        for (Warehouse w : sourceWarehouses) {
            Map<Integer, Integer> stockByGenerator = inventoryDAO.countInStockMapByWarehouse(w.getWarehouseId());
            List<Map<String, Object>> wsGens = new ArrayList<>();
            for (Generator g : allActive) {
                Map<String, Object> entry = new LinkedHashMap<>();
                entry.put("id", g.getId());
                entry.put("m", g.getModel());
                entry.put("q", stockByGenerator.getOrDefault(g.getId(), 0));
                wsGens.add(entry);
            }
            warehouseData.put(w.getWarehouseId(), wsGens);
        }
        String warehouseDataJson = new com.google.gson.Gson().toJson(warehouseData);
        request.setAttribute("warehouseDataJson", warehouseDataJson);

        request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
    }

    private void showEditView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null
                || t.getCreatedBy() != loggedUser.getId()
                || !GlobalUtils.TRANSFER_STATUS_REQUEST_REVISION.equals(t.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }

        List<Warehouse> allWarehouses = warehouseDAO.findAll();
        request.setAttribute("warehouses", allWarehouses);
        request.setAttribute("transfer", t);
        request.setAttribute("isRevision", true);
        request.setAttribute("activePage", "transfer-edit");

        List<Generator> allActive = generatorDAO.findAllActive();
        request.setAttribute("generators", allActive);

        int sourceWhId = t.getSourceWarehouseId();
        request.setAttribute("defaultSourceWarehouseId", sourceWhId);

        Map<Integer, Integer> inStockByGen = inventoryDAO.countInStockMapByWarehouse(sourceWhId);
        request.setAttribute("inStockByGen", inStockByGen);

        // Build warehouse -> generator (with stock) JSON for client-side filter
        Map<Integer, List<Map<String, Object>>> warehouseData = new LinkedHashMap<>();
        warehouseData.put(0, new ArrayList<>());
        for (Warehouse w : allWarehouses) {
            Map<Integer, Integer> stockByGenerator = inventoryDAO.countInStockMapByWarehouse(w.getWarehouseId());
            List<Map<String, Object>> wsGens = new ArrayList<>();
            for (Generator g : allActive) {
                Map<String, Object> entry = new LinkedHashMap<>();
                entry.put("id", g.getId());
                entry.put("m", g.getModel());
                entry.put("q", stockByGenerator.getOrDefault(g.getId(), 0));
                wsGens.add(entry);
            }
            warehouseData.put(w.getWarehouseId(), wsGens);
        }
        request.setAttribute("warehouseDataJson", new com.google.gson.Gson().toJson(warehouseData));

        // Aggregate transfer details by generatorId to pre-fill quantities
        Map<Integer, Integer> detailQtyMap = new LinkedHashMap<>();
        Map<Integer, String> detailNoteMap = new LinkedHashMap<>();
        if (t.getDetails() != null) {
            for (com.quanlymayphatdien.g1.entity.TransferDetail d : t.getDetails()) {
                int gid = d.getGeneratorId();
                detailQtyMap.put(gid, detailQtyMap.getOrDefault(gid, 0) + 1);
                String existingNote = detailNoteMap.get(gid);
                String dn = d.getNote();
                if (dn != null && !dn.isEmpty()) {
                    if (existingNote == null || existingNote.isEmpty()) {
                        detailNoteMap.put(gid, dn);
                    } else if (!existingNote.contains(dn)) {
                        detailNoteMap.put(gid, existingNote + "; " + dn);
                    }
                }
            }
        }
        request.setAttribute("detailQtyMap", detailQtyMap);
        request.setAttribute("detailNoteMap", detailNoteMap);

        request.getRequestDispatcher("/view/warehouse/transfer/transfer-edit.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            request.setAttribute("error", "Không tìm thấy phiếu");
            request.getRequestDispatcher("/view/warehouse/transfer/transfer-detail.jsp").forward(request, response);
            return;
        }

        boolean isOwner = (t.getCreatedBy() == user.getId());
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        int scopedWarehouseId = com.quanlymayphatdien.g1.utils.WarehouseAccessUtil.getScopedWarehouseId(session);
        boolean isCeo = perms != null && perms.contains("transfers.approve_ceo");
        boolean isUnrestricted = scopedWarehouseId <= 0;
        boolean isSourceStaff = isUnrestricted || (scopedWarehouseId == t.getSourceWarehouseId());
        boolean isDestStaff = isUnrestricted || (scopedWarehouseId == t.getDestWarehouseId());

        boolean canCeApprove = isCeo && GlobalUtils.TRANSFER_STATUS_PENDING_CEO.equals(t.getStatus());
        boolean canCeReject = isCeo && GlobalUtils.TRANSFER_STATUS_PENDING_CEO.equals(t.getStatus());
        boolean canCeRequestRevision = isCeo && GlobalUtils.TRANSFER_STATUS_PENDING_CEO.equals(t.getStatus());
        boolean canEditRevision = isOwner
                && GlobalUtils.TRANSFER_STATUS_REQUEST_REVISION.equals(t.getStatus());
        boolean canCreateExport = isSourceStaff
                && GlobalUtils.TRANSFER_STATUS_APPROVED.equals(t.getStatus())
                && t.getExportReceiptId() == null;
        boolean canCreateImport = isDestStaff
                && GlobalUtils.TRANSFER_STATUS_EXPORTED.equals(t.getStatus())
                && t.getImportReceiptId() == null;

        request.setAttribute("canCeApprove", canCeApprove);
        request.setAttribute("canCeReject", canCeReject);
        request.setAttribute("canCeRequestRevision", canCeRequestRevision);
        request.setAttribute("canEditRevision", canEditRevision);
        request.setAttribute("canCreateExport", canCreateExport);
        request.setAttribute("canCreateImport", canCreateImport);

        String tab = request.getParameter("tab");
        String currentTab = "history".equals(tab) ? "history" : "info";
        request.setAttribute("currentTab", currentTab);

        if ("history".equals(currentTab)) {
            String logSearch = request.getParameter("logSearch");
            String logAction = request.getParameter("logAction");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            int page = 1;
            int pageSize = 20;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException ignored) {
                    page = 1;
                }
            }
            List<ActivityLog> logs = activityLogDAO.findByEntityTypeAndId2("transfer", id, logSearch, logAction,
                    dateFrom, dateTo, page, pageSize);
            int totalLogs = activityLogDAO.countByEntityTypeAndId2("transfer", id, logSearch, logAction,
                    dateFrom, dateTo);
            int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
            if (page > totalPages) {
                page = totalPages;
            }
            request.setAttribute("logList", logs);
            request.setAttribute("logPage", page);
            request.setAttribute("logTotalPages", totalPages);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("logSearch", logSearch != null ? logSearch : "");
            request.setAttribute("logAction", logAction != null ? logAction : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        }

        List<TransferDetail> allDetails = t.getDetails();
        int totalDetails = allDetails != null ? allDetails.size() : 0;
        int detailPageSize = 10;
        int detailPage = 1;
        String detailPageStr = request.getParameter("detailPage");
        if (detailPageStr != null && !detailPageStr.isEmpty()) {
            try { detailPage = Math.max(1, Integer.parseInt(detailPageStr)); }
            catch (NumberFormatException ignored) { }
        }
        int detailTotalPages = Math.max(1, (int) Math.ceil((double) totalDetails / detailPageSize));
        if (detailPage > detailTotalPages) detailPage = detailTotalPages;
        List<TransferDetail> pagedDetails = new ArrayList<>();
        if (allDetails != null && !allDetails.isEmpty()) {
            int fromIndex = (detailPage - 1) * detailPageSize;
            int toIndex = Math.min(fromIndex + detailPageSize, allDetails.size());
            pagedDetails = allDetails.subList(fromIndex, toIndex);
        }
        request.setAttribute("pagedDetails", pagedDetails);
        request.setAttribute("detailPage", detailPage);
        request.setAttribute("detailTotalPages", detailTotalPages);
        request.setAttribute("totalDetails", totalDetails);

        request.setAttribute("transfer", t);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("activePage", "transfer-detail");

        request.getRequestDispatcher("/view/warehouse/transfer/transfer-detail.jsp").forward(request, response);
    }

    private void forwardToCreateExport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int transferId = parseInt(request.getParameter("transferId"), 0);
        if (transferId <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(transferId);
        if (t == null
                || !GlobalUtils.TRANSFER_STATUS_APPROVED.equals(t.getStatus())
                || t.getExportReceiptId() != null) {
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + transferId);
            return;
        }
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(request.getSession(false));
        if (scopedWarehouseId > 0 && scopedWarehouseId != t.getSourceWarehouseId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        response.sendRedirect(request.getContextPath()
                + "/export-receipt?action=create&transferId=" + transferId);
    }

    private void forwardToCreateImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int transferId = parseInt(request.getParameter("transferId"), 0);
        if (transferId <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(transferId);
        if (t == null
                || !GlobalUtils.TRANSFER_STATUS_EXPORTED.equals(t.getStatus())
                || t.getImportReceiptId() != null
                || t.getExportReceiptId() == null) {
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + transferId);
            return;
        }
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(request.getSession(false));
        if (scopedWarehouseId > 0 && scopedWarehouseId != t.getDestWarehouseId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        response.sendRedirect(request.getContextPath()
                + "/import-receipt?action=create&exportReceiptId=" + t.getExportReceiptId());
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int sourceWh = parseInt(request.getParameter("sourceWarehouseId"), 0);
        int destWh = parseInt(request.getParameter("destWarehouseId"), 0);
        String note = request.getParameter("note");

        HttpSession session = request.getSession(false);
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        if (scopedWarehouseId > 0 && sourceWh != scopedWarehouseId) {
            redirectError(request, response, "Bạn chỉ được tạo phiếu luân chuyển từ kho của mình");
            return;
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] quantities = request.getParameterValues("quantity");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<String> errors = new ArrayList<>();
        if (sourceWh <= 0) {
            errors.add("Vui lòng chọn kho nguồn");
        }
        if (destWh <= 0) {
            errors.add("Vui lòng chọn kho đích");
        }
        if (sourceWh > 0 && destWh > 0 && sourceWh == destWh) {
            errors.add("Kho nguồn và kho đích phải khác nhau");
        }
        if (sourceWh > 0 && destWh > 0 && sourceWh != destWh) {
            Transfer active = transferDAO.findActiveByWarehousePair(sourceWh, destWh);
            if (active != null) {
                errors.add("Đã tồn tại phiếu " + active.getTransferCode()
                        + " (" + mapStatusLabel(active.getStatus()) + ") "
                        + "giữa kho nguồn và kho đích đã chọn. "
                        + "Vui lòng xử lý phiếu này trước khi tạo phiếu mới.");
                request.setAttribute("pendingTransferId", active.getTransferId());
                request.setAttribute("pendingTransferCode", active.getTransferCode());
                request.setAttribute("pendingTransferStatus", active.getStatus());
            }
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú không vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        Set<String> seenRows = new HashSet<>();
        List<TransferDetail> details = new ArrayList<>();
        if (genIds != null) {
            for (int i = 0; i < genIds.length; i++) {
                String idStr = genIds[i];
                String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
                String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                        && (qtyStr == null || qtyStr.trim().isEmpty());
                if (rowEmpty) {
                    continue;
                }
                int rowNum = i + 1;
                int genId = 0;
                try {
                    genId = Integer.parseInt(idStr.trim());
                } catch (NumberFormatException e) {
                    errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện");
                    continue;
                }
                if (genId <= 0) {
                    errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện");
                    continue;
                }
                if (!seenRows.add(genId + "_" + rowNum)) {
                    errors.add("Dòng " + rowNum + ": Bị trùng máy phát điện");
                    continue;
                }

                int qty = 1;
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    try {
                        qty = Integer.parseInt(qtyStr.trim());
                    } catch (NumberFormatException e) {
                        errors.add("Dòng " + rowNum + ": Số lượng phải là số nguyên");
                        continue;
                    }
                }
                if (qty <= 0) {
                    errors.add("Dòng " + rowNum + ": Số lượng phải lớn hơn 0");
                    continue;
                }
                if (qty > MAX_QUANTITY) {
                    errors.add("Dòng " + rowNum + ": Số lượng không vượt quá " + MAX_QUANTITY);
                    continue;
                }

                if (detailNote != null && detailNote.length() > MAX_DETAIL_NOTE_LENGTH) {
                    errors.add("Dòng " + rowNum + ": Ghi chú không vượt quá "
                            + MAX_DETAIL_NOTE_LENGTH + " ký tự");
                    continue;
                }

                int availableQty = inventoryDAO.findInStockByWarehouseAndGenerator(sourceWh, genId).size();
                if (qty > availableQty && sourceWh > 0) {
                    Generator g = generatorDAO.findById(genId);
                    String model = (g != null && g.getModel() != null && !g.getModel().isEmpty())
                            ? g.getModel() : ("#" + genId);
                    errors.add("Dòng " + rowNum + ": " + model + " chỉ còn " + availableQty
                            + " máy trong kho nguồn (cần " + qty + ")");
                    continue;
                }

                TransferDetail d = new TransferDetail();
                d.setGeneratorId(genId);
                d.setQuantity(qty);
                d.setNote(detailNote);
                details.add(d);
            }
        }
        if (details.isEmpty()) {
            errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", String.join("; ", errors));
            showCreateForm(request, response);
            return;
        }

        Transfer t = new Transfer();
        t.setTransferCode(transferDAO.generateTransferCode());
        t.setSourceWarehouseId(sourceWh);
        t.setDestWarehouseId(destWh);
        t.setStatus(GlobalUtils.TRANSFER_STATUS_PENDING_CEO);
        t.setCreatedBy(user.getId());
        t.setNote(note);

        int newId = transferDAO.insert(t);
        if (newId == -2) {
            request.setAttribute("toastMessage", "Đã tồn tại phiếu luân chuyển đang chờ xử lý giữa kho nguồn và kho đích đã chọn. Vui lòng đợi xử lý phiếu cũ trước khi tạo phiếu mới.");
            request.setAttribute("toastType", "danger");
            showCreateForm(request, response);
            return;
        }
        if (newId <= 0) {
            request.setAttribute("toastMessage", "Không thể tạo phiếu");
            request.setAttribute("toastType", "danger");
            showCreateForm(request, response);
            return;
        }
        for (TransferDetail d : details) {
            d.setTransferId(newId);
            detailDAO.insert(d);
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("transfer");
        log.setAction("CREATE");
        log.setEntityId(newId);
        log.setEntityName(t.getTransferCode());
        log.setDetails("Tạo phiếu đề xuất luân chuyển (PENDING_CEO)");
        activityLogDAO.insert(log);

        List<User> ceos = userDAO.findUsersWithRoles("ceo", null, null, 1, 1000);
        for (User ceo : ceos) {
            NotificationService.send(
                    ceo.getId(),
                    "Phiếu luân chuyển mới chờ duyệt",
                    "Nhân viên " + user.getName() + " đã tạo phiếu luân chuyển "
                            + t.getTransferCode() + " cần CEO duyệt.",
                    request.getContextPath() + "/transfers?action=detail&id=" + newId,
                    "transfer",
                    newId
            );
        }

        session.setAttribute("toastMessage", "Tạo phiếu thành công. Phiếu đã được gửi cho CEO duyệt.");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + newId);
    }

    private void handleCeoApprove(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        String note = request.getParameter("ceoNote");
        boolean ok = transferDAO.ceApprove(id, user.getId(), note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CE_APPROVE");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO duyệt phiếu luân chuyển (PENDING_CEO -> APPROVED)");
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "CEO đã duyệt phiếu. Kho nguồn có thể tạo phiếu xuất.");
            session.setAttribute("toastType", "success");

            notifySourceWarehouseStaff(t, user, request.getContextPath());
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Không thể duyệt (trạng thái không hợp lệ)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleCeoReject(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        String note = request.getParameter("ceoNote");
        if (note != null) {
            note = note.trim();
            if (note.isEmpty()) {
                note = null;
            }
        }
        if (note == null) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui lòng nhập lý do từ chối");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.ceReject(id, user.getId(), note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CE_REJECT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO từ chối: " + note);
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Đã từ chối phiếu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Không thể từ chối (trạng thái không hợp lệ)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleCeoRequestRevision(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        String note = request.getParameter("ceoNote");
        if (note != null) {
            note = note.trim();
            if (note.isEmpty()) {
                note = null;
            }
        }
        if (note == null) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui lòng nhập lý do yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.ceRequestRevision(id, user.getId(), note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("REQUEST_REVISION");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO yêu cầu chỉnh sửa: " + note);
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Đã yêu cầu chỉnh sửa. Người tạo cần sửa và gửi lại.");
            session.setAttribute("toastType", "success");

            try {
                NotificationService.send(
                        t.getCreatedBy(),
                        "Phiếu luân chuyển yêu cầu chỉnh sửa",
                        "CEO yêu cầu chỉnh sửa phiếu " + t.getTransferCode() + ": " + note,
                        request.getContextPath() + "/transfers?action=detail&id=" + id,
                        "transfer",
                        id
                );
            } catch (Exception ignored) {
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa (trạng thái không hợp lệ)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        if (t.getCreatedBy() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!GlobalUtils.TRANSFER_STATUS_REQUEST_REVISION.equals(t.getStatus())) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Phiếu không ở trạng thái yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }

        int sourceWh = parseInt(request.getParameter("sourceWarehouseId"), 0);
        int destWh = parseInt(request.getParameter("destWarehouseId"), 0);
        String note = request.getParameter("note");

        List<String> errors = new ArrayList<>();
        if (sourceWh <= 0) {
            errors.add("Vui lòng chọn kho nguồn");
        }
        if (destWh <= 0) {
            errors.add("Vui lòng chọn kho đích");
        }
        if (sourceWh > 0 && destWh > 0 && sourceWh == destWh) {
            errors.add("Kho nguồn và kho đích phải khác nhau");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú không vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        List<TransferDetail> details = new ArrayList<>();
        String[] genIds = request.getParameterValues("generatorId");
        String[] quantities = request.getParameterValues("quantity");
        String[] detailNotes = request.getParameterValues("detailNote");
        if (genIds != null) {
            for (int i = 0; i < genIds.length; i++) {
                String idStr = genIds[i];
                String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
                String dn = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                        && (qtyStr == null || qtyStr.trim().isEmpty());
                if (rowEmpty) continue;
                int rowNum = i + 1;
                int genId = 0;
                try {
                    genId = Integer.parseInt(idStr.trim());
                } catch (NumberFormatException e) {
                    errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện");
                    continue;
                }
                if (genId <= 0) {
                    errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện");
                    continue;
                }
                if (dn != null && dn.length() > MAX_DETAIL_NOTE_LENGTH) {
                    errors.add("Dòng " + rowNum + ": Ghi chú không vượt quá " + MAX_DETAIL_NOTE_LENGTH + " ký tự");
                    continue;
                }
                int qty = 1;
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    try {
                        qty = Integer.parseInt(qtyStr.trim());
                    } catch (NumberFormatException e) {
                        errors.add("Dòng " + rowNum + ": Số lượng phải là số nguyên");
                        continue;
                    }
                }
                if (qty <= 0) {
                    errors.add("Dòng " + rowNum + ": Số lượng phải lớn hơn 0");
                    continue;
                }
                if (qty > MAX_QUANTITY) {
                    errors.add("Dòng " + rowNum + ": Số lượng không vượt quá " + MAX_QUANTITY);
                    continue;
                }
                int availableQty = inventoryDAO.findInStockByWarehouseAndGenerator(sourceWh, genId).size();
                if (qty > availableQty && sourceWh > 0) {
                    Generator g = generatorDAO.findById(genId);
                    String model = (g != null && g.getModel() != null && !g.getModel().isEmpty())
                            ? g.getModel() : ("#" + genId);
                    errors.add("Dòng " + rowNum + ": " + model + " chỉ còn " + availableQty
                            + " máy trong kho nguồn (cần " + qty + ")");
                    continue;
                }
                TransferDetail d = new TransferDetail();
                d.setTransferId(id);
                d.setGeneratorId(genId);
                d.setQuantity(qty);
                d.setNote(dn);
                details.add(d);
            }
        }
        if (details.isEmpty()) {
            errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", String.join("; ", errors));
            showEditView(request, response);
            return;
        }

        boolean headerOk = transferDAO.updateHeader(id, sourceWh, destWh, note);
        if (!headerOk) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Không thể cập nhật phiếu");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }

        detailDAO.deleteByTransferId(id);
        for (TransferDetail d : details) {
            detailDAO.insert(d);
        }

        boolean ok = transferDAO.submitRevision(id, user.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("UPDATE");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Người tạo sửa và gửi lại phiếu sau yêu cầu chỉnh sửa");
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Đã lưu chỉnh sửa và gửi lại CEO duyệt");
            session.setAttribute("toastType", "success");

            try {
                List<User> ceos = userDAO.findUsersWithRoles("ceo", null, null, 1, 1000);
                for (User ceo : ceos) {
                    NotificationService.send(
                            ceo.getId(),
                            "Phiếu luân chuyển được sửa và gửi lại",
                            "Nhân viên " + user.getName() + " đã sửa phiếu " + t.getTransferCode()
                                    + " và gửi lại cho CEO duyệt.",
                            request.getContextPath() + "/transfers?action=detail&id=" + id,
                            "transfer",
                            id
                    );
                }
            } catch (Exception ignored) {
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Không thể gửi lại phiếu");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void notifySourceWarehouseStaff(Transfer t, User ceo, String contextPath) {
        List<User> staff = userDAO.findUsersByPermission("receipts", "view");
        if (staff == null) {
            return;
        }
        for (User u : staff) {
            if (u.getId() == ceo.getId()) {
                continue;
            }
            Integer scopedWh = null;
            try {
                scopedWh = new com.quanlymayphatdien.g1.dal.UserDAO().getScopedWarehouseId(u.getId());
            } catch (Exception ex) {
                continue;
            }
            if (scopedWh != null && scopedWh == t.getSourceWarehouseId()) {
                NotificationService.send(
                        u.getId(),
                        "Phiếu luân chuyển đã được CEO duyệt",
                        "CEO đã duyệt phiếu luân chuyển " + t.getTransferCode()
                                + ". Bạn có thể tạo phiếu xuất từ kho nguồn.",
                        contextPath + "/transfers?action=detail&id=" + t.getTransferId(),
                        "transfer",
                        t.getTransferId()
                );
            }
        }
    }

    private void redirectError(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", msg);
        session.setAttribute("toastType", "danger");
        response.sendRedirect(request.getContextPath() + "/transfers?action=create");
    }

    private String mapStatusLabel(String status) {
        if (status == null) {
            return "";
        }
        switch (status) {
            case GlobalUtils.TRANSFER_STATUS_PENDING_CEO:
                return "chờ CEO duyệt";
            case GlobalUtils.TRANSFER_STATUS_REQUEST_REVISION:
                return "yêu cầu chỉnh sửa";
            case GlobalUtils.TRANSFER_STATUS_APPROVED:
                return "đã duyệt";
            case GlobalUtils.TRANSFER_STATUS_EXPORTED:
                return "đã xuất kho";
            case GlobalUtils.TRANSFER_STATUS_COMPLETED:
                return "hoàn thành";
            case GlobalUtils.TRANSFER_STATUS_REJECTED:
                return "đã từ chối";
            default:
                return status;
        }
    }

    private int parseInt(String s, int def) {
        if (s == null || s.isEmpty()) {
            return def;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }
}