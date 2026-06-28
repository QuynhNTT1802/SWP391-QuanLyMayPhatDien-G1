
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse.receipt;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.OrderDetailDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.SaleOrderDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.OrderDetail;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import com.google.gson.Gson;
import com.quanlymayphatdien.g1.utils.NotificationService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author FPTShop
 */
@WebServlet(name = "ExportReceiptController", urlPatterns = {"/export-receipt"})
public class ExportReceiptController extends HttpServlet {

    private static final String TYPE = "EXPORT";
    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final ReceiptDetailDAO detailDAO = new ReceiptDetailDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();
    private final GeneratorDAO genDAO = new GeneratorDAO();
    private final UserDAO userDAO = new UserDAO();

    private static final int MAX_QUANTITY = 100000;
    private static final int MAX_SERIAL_LENGTH = 100;
    private static final int MAX_NOTE_LENGTH = 500;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) {
            return;
        }
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        try {
            switch (action) {
                case "list":
                    viewList(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "detail":
                    viewDetail(request, response);
                    break;
                case "selectOrder":
                    selectOrder(request, response);
                    break;
                case "loadGenerators":
                    loadGeneratorsJson(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.RECEIPT, "ExportReceiptController.doGet", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) {
            return;
        }
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "save":
                    saveReceipt(request, response);
                    break;
                case "update":
                    updateReceipt(request, response);
                    break;
                case "addScannedSerial":
                    addScannedSerial(request, response);
                    break;
                case "removeScannedSerial":
                    removeScannedSerial(request, response);
                    break;
                case "discardDraft":
                    discardDraft(request, response);
                    break;
                case "cancelPending":
                    cancelPending(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.RECEIPT, "ExportReceiptController.doPost", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private boolean isLoggedIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return false;
        }
        return true;
    }

    private void viewList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        Integer createdByFilter = null;
        if (loggedUser != null && (perms == null || !perms.contains("receipts.approve"))) {
            createdByFilter = loggedUser.getId();
        }

        String statusFilter = request.getParameter("status");
        String whFilter = request.getParameter("warehouse");
        String search = request.getParameter("search");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        int totalItems = receiptDAO.countWithFilters(TYPE, statusFilter, whFilter, search, createdByFilter, loggedUser.getId());
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        List<Receipt> receiptList = receiptDAO.findWithFilters(
                TYPE, statusFilter, whFilter, search, createdByFilter, page, pageSize, loggedUser.getId());
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("receiptList", receiptList);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("whFilter", whFilter);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("canApproveReceipt", false);
        request.setAttribute("canRejectReceipt", false);
        request.getRequestDispatcher("/view/receipt/export/export-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("allSerials", loadAllInStockSerials());
        request.setAttribute("activePage", "export-create");

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            int orderId = parseId(orderIdStr);
            SaleOrder order = new SaleOrderDAO().findById(orderId);
            if (order != null && "APPROVED".equalsIgnoreCase(order.getStatus())) {
                List<OrderDetail> ods = new OrderDetailDAO().findGeneratorById(orderId);
                Receipt prefill = new Receipt();
                prefill.setOrderId(orderId);
                prefill.setReceiptType(TYPE);
                prefill.setNote("Tạo từ đơn " + order.getOrderCode());
                List<Map<String, Object>> orderRowList = new ArrayList<>();
                int expectedRows = 0;
                for (OrderDetail od : ods) {
                    int qty = od.getQuantity() > 0 ? od.getQuantity() : 1;
                    for (int k = 0; k < qty; k++) {
                        Map<String, Object> row = new LinkedHashMap<>();
                        row.put("generatorId", od.getGeneratorId());
                        row.put("generatorModel", od.getGeneratorModel() != null ? od.getGeneratorModel() : "");
                        String brand = lookupGeneratorBrand(od.getGeneratorId());
                        row.put("brandName", brand);
                        row.put("note", od.getNote() != null ? od.getNote() : "");
                        orderRowList.add(row);

                        expectedRows++;
                    }
                }
                prefill.setDetails(new ArrayList<>());
                request.setAttribute("receipt", prefill);
                request.setAttribute("order", order);
                request.setAttribute("fromOrder", Boolean.TRUE);
                request.setAttribute("expectedRows", expectedRows);
                request.setAttribute("orderRowList", orderRowList);

                List<Map<String, Object>> orderRequirements = new ArrayList<>();
                for (OrderDetail od : ods) {
                    Map<String, Object> req = new LinkedHashMap<>();
                    req.put("generatorId", od.getGeneratorId());
                    req.put("generatorModel", od.getGeneratorModel() != null ? od.getGeneratorModel() : "");
                    String brand = lookupGeneratorBrand(od.getGeneratorId());
                    req.put("brandName", brand);
                    req.put("quantity", od.getQuantity() > 0 ? od.getQuantity() : 1);
                    orderRequirements.add(req);
                }
                request.setAttribute("orderRequirements", orderRequirements);

                List<String> stockWarnings = new ArrayList<>();
                List<Integer> shortGenIds = new ArrayList<>();
                for (OrderDetail od : ods) {
                    int genId = od.getGeneratorId();
                    int qty = od.getQuantity() > 0 ? od.getQuantity() : 1;
                    int totalInStock = inventoryDAO.countTotalInStockByGenerator(genId);
                    if (totalInStock < qty) {
                        Generator gen = genDAO.findById(genId);
                        String model = (gen != null && gen.getModel() != null && !gen.getModel().isEmpty())
                                ? gen.getModel() : ("#" + genId);
                        int shortage = qty - totalInStock;
                        stockWarnings.add(model + " cần " + qty + " máy, chỉ còn " + totalInStock + " máy trên tất cả kho. Cần nhập thêm " + shortage + " máy.");
                        shortGenIds.add(genId);
                    }
                }
                request.setAttribute("stockWarnings", stockWarnings);
                request.setAttribute("stockWarningGenIds", shortGenIds);
            }
        }
        request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseId(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }

        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null || receipt.getCreatedBy() != loggedUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!TYPE.equals(receipt.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=edit&id=" + id);
            return;
        }
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(receipt.getStatus());
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(receipt.getStatus());
        if (!isDraft && !isRevision) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("isDraft", isDraft);
        request.setAttribute("receipt", receipt);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("allSerials", loadAllInStockSerials());
        request.setAttribute("activePage", "export-edit");
        request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseId(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }

        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null) {
            request.setAttribute("error", "Không tìm thấy phiếu");
            request.getRequestDispatcher("/view/receipt/export/export-detail.jsp").forward(request, response);
            return;
        }
        if (!TYPE.equals(receipt.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
            return;
        }
        boolean isOwner = receipt.getCreatedBy() == loggedUser.getId();

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
                try { page = Math.max(1, Integer.parseInt(pageStr)); }
                catch (NumberFormatException ignored) { page = 1; }
            }
            List<ActivityLog> logs = activityLogDAO.findByEntityTypeAndId2("receipt", id, logSearch, logAction,
                    dateFrom, dateTo, page, pageSize);
            int totalLogs = activityLogDAO.countByEntityTypeAndId2("receipt", id, logSearch, logAction,
                    dateFrom, dateTo);
            int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
            if (page > totalPages) page = totalPages;
            request.setAttribute("logList", logs);
            request.setAttribute("logPage", page);
            request.setAttribute("logTotalPages", totalPages);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("logSearch", logSearch != null ? logSearch : "");
            request.setAttribute("logAction", logAction != null ? logAction : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        }

        request.setAttribute("receipt", receipt);
        request.setAttribute("isManager", false);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("activePage", "export-detail");
        request.getRequestDispatcher("/view/receipt/export/export-detail.jsp").forward(request, response);
    }

    private void selectOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        SaleOrderDAO soDAO = new SaleOrderDAO();
        int totalItems = soDAO.countApprovedAvailableFiltered(search, fromDate, toDate);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }
        List<SaleOrder> approvedOrders = soDAO.findApprovedAvailableFiltered(search, fromDate, toDate, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("approvedOrders", approvedOrders);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.getRequestDispatcher("/view/receipt/export/export-select-order.jsp").forward(request, response);
    }

    private void loadGeneratorsJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int whId = parseId(request.getParameter("warehouseId"));
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (whId <= 0) {
            response.getWriter().write("[]");
            return;
        }
        List<Generator> generators = genDAO.findInStockByWarehouse(whId);
        List<Map<String, Object>> out = new ArrayList<>();
        for (Generator g : generators) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", g.getId());
            item.put("model", g.getModel());
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) {
                        brand = c.getName();
                        break;
                    }
                }
            }
            item.put("brand", brand);
            int stockQty = inventoryDAO.findInStockByWarehouseAndGenerator(whId, g.getId()).size();
            item.put("stockQty", stockQty);
            out.add(item);
        }
        new Gson().toJson(out, response.getWriter());
    }

    private void saveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        boolean isDraft = "draft".equals(request.getParameter("submitMode"));
        int existingReceiptId = parseId(request.getParameter("receiptId"));

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();

        if (warehouseId <= 0 && !isDraft) {
            errors.add("Vui lòng chọn kho");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                if (!isDraft) {
                    errors.add("Lý do không hợp lệ");
                }
            }
        } else if (!isDraft) {
            errors.add("Vui lòng chọn lý do");
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        Receipt existingReceipt = null;
        if (existingReceiptId > 0) {
            existingReceipt = receiptDAO.findById(existingReceiptId);
            if (existingReceipt == null || !TYPE.equals(existingReceipt.getReceiptType())) {
                response.sendRedirect(request.getContextPath() + "/export-receipt");
                return;
            }
            boolean isDraftStatus = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existingReceipt.getStatus());
            if (existingReceipt.getCreatedBy() != loggedUser.getId() || !isDraftStatus) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        List<ReceiptDetail> details;
        if (isDraft) {
            details = parseDetailsLenient(genIds, serials, detailNotes);
        } else {
            details = parseDetailsStrict(genIds, serials, detailNotes, warehouseId, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
            if (errors.isEmpty() && warehouseId > 0) {
                validateInventoryAvailability(warehouseId, details, errors);
            }
        }

        int orderId = parseId(request.getParameter("orderId"));
        if (orderId > 0) {
            validateOrderCompleteness(orderId, details, errors);
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isDraft ? "Lưu nháp thất bại:" : "Lưu phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            if (existingReceipt != null) {
                request.setAttribute("receipt", existingReceipt);
                request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
            }
            return;
        }

        int receiptId;
        Receipt r;
        if (existingReceipt != null) {
            receiptId = existingReceipt.getReceiptId();
            r = existingReceipt;
        } else {
            r = new Receipt();
            r.setReceiptCode(receiptDAO.generateReceiptCode(TYPE));
            r.setReceiptType(TYPE);
            r.setWarehouseId(warehouseId);
            r.setCreatedBy(loggedUser.getId());
            r.setNote(note);
            r.setReasonId(reasonId);
            String oid = request.getParameter("orderId");
            if (oid != null && !oid.isEmpty()) {
                try {
                    r.setOrderId(Integer.parseInt(oid));
                } catch (NumberFormatException ignored) {
                }
            }
            if (isDraft) {
                r.setStatus(GlobalUtils.RECEIPT_STATUS_DRAFT);
            } else {
                r.setStatus(GlobalUtils.RECEIPT_STATUS_COMPLETED);
                r.setApprovedBy(loggedUser.getId());
                r.setApprovedAt(java.time.LocalDateTime.now());
            }

            receiptId = receiptDAO.insert(r);
            if (receiptId <= 0) {
                request.setAttribute("toastMessage", "Không thể tạo phiếu, vui lòng thử lại");
                request.setAttribute("toastType", "danger");
                request.setAttribute("warehouses", warehouseDAO.findAll());
                request.setAttribute("generators", new ArrayList<>());
                request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
                request.setAttribute("allSerials", loadAllInStockSerials());
                request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
                return;
            }
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);

            if (existingReceipt != null) {
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "UPDATE receipt SET warehouse_id = ?, note = ?, reason_id = ?, "
                                + "status = ?, approved_by = ?, approved_at = ? "
                                + "WHERE receipt_id = ? AND status = ?")) {
                    ps.setInt(1, warehouseId);
                    ps.setString(2, note);
                    if (reasonId != null) ps.setInt(3, reasonId); else ps.setNull(3, java.sql.Types.INTEGER);
                    if (isDraft) {
                        ps.setString(4, GlobalUtils.RECEIPT_STATUS_DRAFT);
                        ps.setNull(5, java.sql.Types.INTEGER);
                        ps.setNull(6, java.sql.Types.TIMESTAMP);
                    } else {
                        ps.setString(4, GlobalUtils.RECEIPT_STATUS_COMPLETED);
                        ps.setInt(5, loggedUser.getId());
                        ps.setTimestamp(6, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
                    }
                    ps.setInt(7, receiptId);
                    ps.setString(8, GlobalUtils.RECEIPT_STATUS_DRAFT);
                    ps.executeUpdate();
                }

                java.util.Set<String> existingSerials = new java.util.HashSet<>();
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "SELECT i.serial_number FROM receipt_detail rd "
                                + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                                + "WHERE rd.receipt_id = ?")) {
                    ps.setInt(1, receiptId);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) existingSerials.add(rs.getString(1));
                    }
                }

                java.util.List<ReceiptDetail> toInsert = new java.util.ArrayList<>();
                for (ReceiptDetail d : details) {
                    if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) continue;
                    String sn = d.getSerialNumber().trim();
                    if (existingSerials.contains(sn)) continue;

                    Inventory inv = inventoryDAO.findBySerialNumber(sn);
                    if (inv == null) {
                        throw new SQLException("Serial \"" + sn + "\" không tồn tại trong hệ thống");
                    }
                    if (!inventoryDAO.isInStockAtWarehouse(inv.getSerialNumber(), warehouseId)) {
                        throw new SQLException("Serial \"" + sn + "\" không ở trạng thái IN_STOCK tại kho này");
                    }
                    if (isDraft) {
                        if (!inventoryDAO.reserveForExport(conn, inv.getInventoryId())) {
                            throw new SQLException("Serial \"" + sn + "\" đã bị reserve bởi phiếu khác");
                        }
                    } else {
                        if (!inventoryDAO.markAsExported(conn, inv.getInventoryId(), InventoryDAO.STATUS_SOLD)) {
                            throw new SQLException("Serial \"" + sn + "\" không ở trạng thái IN_STOCK");
                        }
                    }
                    d.setReceiptId(receiptId);
                    d.setInventoryId(inv.getInventoryId());
                    toInsert.add(d);
                }
                if (!toInsert.isEmpty()) {
                    detailDAO.batchInsert(conn, toInsert);
                }

                if (!isDraft) {
                    java.util.List<Integer> existingInventoryIds = new java.util.ArrayList<>();
                    try (java.sql.PreparedStatement ps = conn.prepareStatement(
                            "SELECT rd.inventory_id FROM receipt_detail rd "
                                    + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                                    + "WHERE rd.receipt_id = ? AND i.status = ?")) {
                        ps.setInt(1, receiptId);
                        ps.setString(2, InventoryDAO.STATUS_RESERVED_EXPORT);
                        try (java.sql.ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) existingInventoryIds.add(rs.getInt(1));
                        }
                    }
                    for (Integer invId : existingInventoryIds) {
                        if (!inventoryDAO.completeExport(conn, invId, InventoryDAO.STATUS_SOLD)) {
                            throw new SQLException("Serial inventory_id=" + invId + " không ở trạng thái RESERVED_EXPORT");
                        }
                    }
                }
            } else {
                for (ReceiptDetail d : details) {
                    if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) {
                        continue;
                    }
                    Inventory inv = inventoryDAO.findBySerialNumber(d.getSerialNumber().trim());
                    if (inv == null) {
                        throw new SQLException("Serial \"" + d.getSerialNumber() + "\" không tồn tại trong hệ thống");
                    }
                    if (!inventoryDAO.isInStockAtWarehouse(inv.getSerialNumber(), warehouseId)) {
                        throw new SQLException("Serial \"" + d.getSerialNumber() + "\" không ở trạng thái IN_STOCK tại kho này");
                    }
                    if (isDraft) {
                        if (!inventoryDAO.reserveForExport(conn, inv.getInventoryId())) {
                            throw new SQLException("Serial \"" + d.getSerialNumber() + "\" đã bị reserve bởi phiếu khác");
                        }
                    } else {
                        if (!inventoryDAO.markAsExported(conn, inv.getInventoryId(), InventoryDAO.STATUS_SOLD)) {
                            throw new SQLException("Serial \"" + d.getSerialNumber() + "\" không ở trạng thái IN_STOCK");
                        }
                    }
                    d.setReceiptId(receiptId);
                    d.setInventoryId(inv.getInventoryId());
                }
                detailDAO.batchInsert(conn, details);
            }

            if (!isDraft) {
                boolean isLiquidation = false;
                Integer liquidationId = null;
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "SELECT liquidation_id, status FROM liquidation WHERE converted_receipt_id = ?")) {
                    ps.setInt(1, receiptId);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            isLiquidation = true;
                            liquidationId = rs.getInt("liquidation_id");
                        }
                    }
                }
                if (isLiquidation && liquidationId != null) {
                    try (java.sql.PreparedStatement ps = conn.prepareStatement(
                            "UPDATE inventory SET status = ? "
                                    + "WHERE status = ? AND inventory_id IN ("
                                    + "SELECT inventory_id FROM receipt_detail WHERE receipt_id = ?)")) {
                        ps.setString(1, InventoryDAO.STATUS_LIQUIDATED);
                        ps.setString(2, InventoryDAO.STATUS_SOLD);
                        ps.setInt(3, receiptId);
                        ps.executeUpdate();
                    }
                }

                java.util.List<ReceiptDetail> allDetails = new java.util.ArrayList<>();
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "SELECT rd.*, i.generator_id, i.serial_number FROM receipt_detail rd "
                                + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                                + "WHERE rd.receipt_id = ?")) {
                    ps.setInt(1, receiptId);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            ReceiptDetail rd = new ReceiptDetail();
                            rd.setReceiptId(rs.getInt("receipt_id"));
                            rd.setInventoryId(rs.getInt("inventory_id"));
                            rd.setGeneratorId(rs.getInt("generator_id"));
                            allDetails.add(rd);
                        }
                    }
                }
                receiptDAO.writeStockCardsForExport(conn, receiptId, r.getReceiptCode(),
                        warehouseId, loggedUser.getId(), allDetails);

                if (isLiquidation && liquidationId != null) {
                    try (java.sql.PreparedStatement ps = conn.prepareStatement(
                            "UPDATE liquidation SET status = ?, updated_at = ? WHERE liquidation_id = ?")) {
                        ps.setString(1, GlobalUtils.STATUS_COMPLETED);
                        ps.setTimestamp(2, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
                        ps.setInt(3, liquidationId);
                        ps.executeUpdate();
                    }
                    ActivityLog liqLog = new ActivityLog();
                    liqLog.setUserId(loggedUser.getId());
                    liqLog.setEntityType("liquidation");
                    liqLog.setAction("EXPORT_APPROVE");
                    liqLog.setEntityId(liquidationId);
                    liqLog.setEntityName(r.getReceiptCode());
                    liqLog.setDetails("Hoàn tất xuất kho cho phiếu thanh lý " + r.getReceiptCode() + ".");
                    activityLogDAO.insert(liqLog);
                }
            }

            conn.commit();
            ok = true;
        } catch (java.sql.SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
            errors.add("Lỗi hệ thống khi lưu phiếu: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
        }
        if (!ok) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Lưu phiếu thất bại:", errors));
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            if (existingReceipt != null) {
                request.setAttribute("receipt", existingReceipt);
                request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
            }
            return;
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        if (existingReceipt != null) {
            log.setAction(isDraft ? "DRAFT_UPDATE" : "SUBMIT_DRAFT");
        } else {
            log.setAction("CREATE");
        }
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails(isDraft ? "Lưu nháp phiếu xuất kho" : "Tạo phiếu xuất kho và cập nhật tồn kho");
        activityLogDAO.insert(log);

        if (isDraft) {
            session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=edit&id=" + receiptId);
        } else {
            session.setAttribute("toastMessage", "Thêm phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=list");
        }
    }

    /**
     * POST /export-receipt?action=addScannedSerial
     * Phuc vu cho o quet barcode tren form tao/sua phieu xuat.
     *
     * Input: warehouseId, serialNumber, receiptId (optional)
     *
     * Tra ve JSON: { success, receiptId, inventoryId, generatorId, generatorModel,
     *                serialNumber, message }
     *
     * Dieu kien:
     *  - Serial phai ton tai trong inventory.
     *  - Serial phai o trang thai IN_STOCK tai dung kho dang chon.
     *  - Neu chua co receiptId thi tu tao phieu DRAFT moi (export).
     */
    private void addScannedSerial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Map<String, Object> body = new LinkedHashMap<>();

        String serial = request.getParameter("serialNumber");
        if (serial != null) serial = serial.trim();
        if (serial == null || serial.isEmpty()) {
            body.put("success", false);
            body.put("message", "Serial trong");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        if (serial.length() > MAX_SERIAL_LENGTH) {
            body.put("success", false);
            body.put("message", "Serial qua dai (toi da " + MAX_SERIAL_LENGTH + " ky tu)");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        int warehouseId = parseId(request.getParameter("warehouseId"));
        if (warehouseId <= 0) {
            body.put("success", false);
            body.put("message", "Vui long chon kho truoc khi quet");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        Inventory inv = inventoryDAO.findBySerialNumber(serial);
        if (inv == null) {
            body.put("success", false);
            body.put("message", "Serial \"" + serial + "\" khong ton tai trong he thong");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        if (!inventoryDAO.isInStockAtWarehouse(serial, warehouseId)) {
            body.put("success", false);
            body.put("message", "Serial \"" + serial + "\" khong co san trong kho dang chon (trang thai: " + inv.getStatus() + ")");
            body.put("currentStatus", inv.getStatus());
            body.put("currentWarehouseId", inv.getWarehouseId());
            body.put("currentWarehouseName", inv.getWarehouseName());
            new Gson().toJson(body, response.getWriter());
            return;
        }

        String mode = request.getParameter("mode");
        if ("validate".equals(mode)) {
            body.put("success", true);
            body.put("generatorId", inv.getGeneratorId());
            body.put("generatorModel", inv.getGeneratorModel());
            body.put("generatorBrand", inv.getGeneratorBrand());
            body.put("serialNumber", serial);
            body.put("message", "Serial hop le");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        int receiptId = parseId(request.getParameter("receiptId"));

        java.sql.Connection conn = null;
        boolean ok = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);

            if (receiptId <= 0) {
                Receipt r = new Receipt();
                r.setReceiptCode(receiptDAO.generateReceiptCode(TYPE));
                r.setReceiptType(TYPE);
                r.setWarehouseId(warehouseId);
                r.setCreatedBy(loggedUser.getId());
                r.setNote("Tao tu quet barcode");
                r.setStatus(GlobalUtils.RECEIPT_STATUS_DRAFT);
                receiptId = receiptDAO.insert(r);
                if (receiptId <= 0) {
                    throw new SQLException("Khong the tao phieu DRAFT");
                }
            } else {
                Receipt existing = receiptDAO.findById(receiptId);
                if (existing == null
                        || !TYPE.equals(existing.getReceiptType())
                        || existing.getCreatedBy() != loggedUser.getId()
                        || !(GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existing.getStatus())
                            || GlobalUtils.RECEIPT_STATUS_REVISION.equals(existing.getStatus()))) {
                    throw new SQLException("Phieu khong hop le de them serial");
                }
            }

            if (!inventoryDAO.reserveForExport(conn, inv.getInventoryId())) {
                throw new SQLException("Serial \"" + serial + "\" da bi dat truoc boi phieu khac");
            }

            ReceiptDetail rd = new ReceiptDetail();
            rd.setReceiptId(receiptId);
            rd.setInventoryId(inv.getInventoryId());
            detailDAO.batchInsert(conn, java.util.Collections.singletonList(rd));

            conn.commit();
            ok = true;

            body.put("success", true);
            body.put("receiptId", receiptId);
            body.put("inventoryId", inv.getInventoryId());
            body.put("generatorId", inv.getGeneratorId());
            body.put("generatorModel", inv.getGeneratorModel());
            body.put("generatorBrand", inv.getGeneratorBrand());
            body.put("serialNumber", serial);
            body.put("message", "Da them serial");
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException e) { e.printStackTrace(); }
            }
            body.put("success", false);
            body.put("message", "Loi: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction("SCAN_EXPORT");
            log.setEntityId(receiptId);
            log.setEntityName("scan:" + serial);
            log.setDetails("Quet barcode xuat serial " + serial);
            activityLogDAO.insert(log);
        }

        new Gson().toJson(body, response.getWriter());
    }


    /**
     * POST /export-receipt?action=removeScannedSerial
     * Phuc vu khi user bam nut xoa 1 dong trong form (create/edit) ma dong do
     * vua duoc quet (hoac da luu) -> giai phong reservation cua inventory do.
     *
     * Input: receiptId, inventoryId
     * Tra JSON: { success, message, emptyReceipt, remaining }
     *
     * Dieu kien:
     *  - Receipt phai ton tai, thuoc loai EXPORT.
     *  - Receipt phai o trang thai DRAFT hoac NEEDS_REVISION.
     *  - User phai la nguoi tao receipt.
     *  - inventoryId phai thuoc receipt do.
     */
    private void removeScannedSerial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Map<String, Object> body = new LinkedHashMap<>();

        int receiptId = parseId(request.getParameter("receiptId"));
        int inventoryId = parseId(request.getParameter("inventoryId"));
        if (receiptId <= 0 || inventoryId <= 0) {
            body.put("success", false);
            body.put("message", "Thieu receiptId hoac inventoryId");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            body.put("success", false);
            body.put("message", "Phieu khong hop le");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existing.getStatus());
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(existing.getStatus());
        if (!isDraft && !isRevision) {
            body.put("success", false);
            body.put("message", "Chi xoa duoc dong o phieu nhap hoac phieu yeu cau chinh sua");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        if (existing.getCreatedBy() != loggedUser.getId()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            body.put("success", false);
            body.put("message", "Ban khong phai nguoi tao phieu nay");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        int remaining = 0;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);

            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM receipt_detail WHERE receipt_id = ? AND inventory_id = ?")) {
                ps.setInt(1, receiptId);
                ps.setInt(2, inventoryId);
                ps.executeUpdate();
            }

            InventoryDAO invDAO = new InventoryDAO();
            invDAO.releaseReservations(conn, java.util.Collections.singletonList(inventoryId));

            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM receipt_detail WHERE receipt_id = ?")) {
                ps.setInt(1, receiptId);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) remaining = rs.getInt(1);
                }
            }

            conn.commit();
            ok = true;
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException e) { e.printStackTrace(); }
            }
            body.put("success", false);
            body.put("message", "Loi: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }

        if (ok) {
            body.put("success", true);
            body.put("remaining", remaining);
            body.put("emptyReceipt", remaining == 0);
            body.put("message", remaining == 0
                    ? "Da giai phong serial. Phieu dang trong, hay bam 'Huy phieu' de xoa phieu."
                    : "Da giai phong serial");

            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction("REMOVE_SCANNED_SERIAL");
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails("Xoa dong serial, giai phong reservation inventory_id=" + inventoryId);
            activityLogDAO.insert(log);
        }

        new Gson().toJson(body, response.getWriter());
    }


    /**
     * POST /export-receipt?action=discardDraft
     * Huy phieu DRAFT: set status CANCELLED, giai phong tat ca reservation,
     * giu nguyen receipt_detail (audit).
     *
     * Quyen: creator cua phieu DRAFT.
     */
    private void discardDraft(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Map<String, Object> body = new LinkedHashMap<>();

        int receiptId = parseId(request.getParameter("receiptId"));
        if (receiptId <= 0) {
            body.put("success", false);
            body.put("message", "Thieu receiptId");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            body.put("success", false);
            body.put("message", "Phieu khong hop le");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        if (!GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existing.getStatus())) {
            body.put("success", false);
            body.put("message", "Chi huy duoc phieu o trang thai BAN_NHAP");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        if (existing.getCreatedBy() != loggedUser.getId()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            body.put("success", false);
            body.put("message", "Ban khong phai nguoi tao phieu");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        int released = 0;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);

            java.util.List<Integer> inventoryIds = inventoryDAO.getInventoryIdsByReceiptId(conn, receiptId);
            if (!inventoryIds.isEmpty()) {
                released = inventoryDAO.releaseReservations(conn, inventoryIds);
            }

            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                    "UPDATE receipt SET status = ?, approved_by = NULL, "
                            + "approved_at = NULL WHERE receipt_id = ?")) {
                ps.setString(1, GlobalUtils.RECEIPT_STATUS_CANCELLED);
                ps.setInt(2, receiptId);
                if (ps.executeUpdate() == 0) {
                    throw new SQLException("Khong the cap nhat trang thai phieu");
                }
            }

            conn.commit();
            ok = true;
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException e) { e.printStackTrace(); }
            }
            body.put("success", false);
            body.put("message", "Loi: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }

        if (ok) {
            body.put("success", true);
            body.put("released", released);
            body.put("message", "Da huy phieu nhap, giai phong " + released + " serial");

            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction("DISCARD_DRAFT");
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails("Huy phieu nhap, giai phong " + released + " reservation");
            activityLogDAO.insert(log);

            if (existing.getCreatedBy() != loggedUser.getId()) {
                session.setAttribute("toastMessage", "Da huy phieu nhap");
                session.setAttribute("toastType", "success");
            }
        }

        new Gson().toJson(body, response.getWriter());
    }


    /**
     * POST /export-receipt?action=cancelPending
     * Rut phieu PENDING do chinh user tao ra: set status CANCELLED,
     * giai phong tat ca reservation.
     *
     * Quyen: creator cua phieu PENDING.
     */
    private void cancelPending(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Map<String, Object> body = new LinkedHashMap<>();

        int receiptId = parseId(request.getParameter("receiptId"));
        if (receiptId <= 0) {
            body.put("success", false);
            body.put("message", "Thieu receiptId");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            body.put("success", false);
            body.put("message", "Phieu khong hop le");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        if (!GlobalUtils.RECEIPT_STATUS_PENDING.equals(existing.getStatus())) {
            body.put("success", false);
            body.put("message", "Chi rut duoc phieu o trang thai CHO_DUYET");
            new Gson().toJson(body, response.getWriter());
            return;
        }
        if (existing.getCreatedBy() != loggedUser.getId()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            body.put("success", false);
            body.put("message", "Chi nguoi tao moi duoc rut phieu");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        int released = 0;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);

            java.util.List<Integer> inventoryIds = inventoryDAO.getInventoryIdsByReceiptId(conn, receiptId);
            if (!inventoryIds.isEmpty()) {
                released = inventoryDAO.releaseReservations(conn, inventoryIds);
            }

            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                    "UPDATE receipt SET status = ?, approved_by = NULL, "
                            + "approved_at = NULL WHERE receipt_id = ? AND status = ?")) {
                ps.setString(1, GlobalUtils.RECEIPT_STATUS_CANCELLED);
                ps.setInt(2, receiptId);
                ps.setString(3, GlobalUtils.RECEIPT_STATUS_PENDING);
                if (ps.executeUpdate() == 0) {
                    throw new SQLException("Phieu khong con o trang thai CHO_DUYET");
                }
            }

            conn.commit();
            ok = true;
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException e) { e.printStackTrace(); }
            }
            body.put("success", false);
            body.put("message", "Loi: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }

        if (ok) {
            body.put("success", true);
            body.put("released", released);
            body.put("message", "Da rut phieu, giai phong " + released + " serial");

            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction("CANCEL_PENDING");
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails("Rut phieu dang cho duyet, giai phong " + released + " reservation");
            activityLogDAO.insert(log);

            List<User> approvers = userDAO.findUsersByPermission("receipts", "approve");
            String link = request.getContextPath() + "/export-receipt?action=detail&id=" + receiptId;
            for (User mgr : approvers) {
                if (mgr.getId() == loggedUser.getId()) continue;
                NotificationService.send(
                        mgr.getId(),
                        "Phiếu xuất kho bị rút",
                        "Nhân viên " + loggedUser.getName() + " đã rút phiếu xuất " + existing.getReceiptCode()
                                + " đang chờ duyệt.",
                        link,
                        "export_receipt",
                        receiptId
                );
            }
        }

        new Gson().toJson(body, response.getWriter());
    }


    private void updateReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int receiptId = parseId(request.getParameter("receiptId"));
        if (receiptId <= 0) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }

        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existing.getStatus());
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(existing.getStatus());
        if (existing.getCreatedBy() != loggedUser.getId() || (!isDraft && !isRevision)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        boolean isSaveDraft = "draft".equals(request.getParameter("submitMode"));

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();
        if (warehouseId <= 0 && !isSaveDraft) {
            errors.add("Vui lòng chọn kho");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                if (!isSaveDraft) {
                    errors.add("Lý do không hợp lệ");
                }
            }
        } else if (!isSaveDraft) {
            errors.add("Vui lòng chọn lý do");
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isSaveDraft) {
            details = parseDetailsLenient(genIds, serials, detailNotes);
        } else {
            details = parseDetailsStrict(genIds, serials, detailNotes, warehouseId, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
            if (errors.isEmpty() && warehouseId > 0) {
                validateInventoryAvailability(warehouseId, details, errors);
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isSaveDraft ? "Lưu nháp thất bại:" : "Cập nhật phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
            return;
        }

        // Reserve new inventory rows (RESERVED_EXPORT) truoc khi updateReceipt
        java.sql.Connection conn = null;
        boolean inventoryReserved = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);
            for (ReceiptDetail d : details) {
                if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) {
                    continue;
                }
                Inventory inv = inventoryDAO.findBySerialNumber(d.getSerialNumber().trim());
                if (inv == null) {
                    throw new SQLException("Serial \"" + d.getSerialNumber() + "\" không tồn tại");
                }
                if (!inventoryDAO.isInStockAtWarehouse(inv.getSerialNumber(), warehouseId)) {
                    throw new SQLException("Serial \"" + d.getSerialNumber() + "\" không IN_STOCK tại kho");
                }
                if (!inventoryDAO.reserveForExport(conn, inv.getInventoryId())) {
                    throw new SQLException("Serial \"" + d.getSerialNumber() + "\" đã bị reserve bởi phiếu khác");
                }
                d.setInventoryId(inv.getInventoryId());
            }
            conn.commit();
            inventoryReserved = true;
        } catch (java.sql.SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
            errors.add("Lỗi khi reserve serial: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
        }
        if (!inventoryReserved) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Cập nhật phiếu thất bại:", errors));
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("allSerials", loadAllInStockSerials());
            request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptId(receiptId);
        r.setWarehouseId(warehouseId);
        r.setNote(note);
        r.setReasonId(reasonId);
        String newStatus = isSaveDraft ? GlobalUtils.RECEIPT_STATUS_DRAFT : GlobalUtils.RECEIPT_STATUS_PENDING;
        boolean ok = isSaveDraft
                ? receiptDAO.updateDraftReceipt(r, details, loggedUser.getId(), newStatus)
                : receiptDAO.updateReceipt(r, details, loggedUser.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction(isSaveDraft ? "DRAFT_UPDATE" : (isDraft ? "SUBMIT_DRAFT" : "UPDATE"));
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails(isSaveDraft ? "Lưu nháp phiếu xuất kho" : (isDraft ? "Gửi phiếu nháp để duyệt" : "Cập nhật phiếu xuất kho"));
            activityLogDAO.insert(log);
            if (!isSaveDraft) {
                String notifLink = request.getContextPath() + "/export-receipt?action=detail&id=" + receiptId;
                List<User> approvers = userDAO.findUsersByPermission("receipts", "approve");
                for (User mgr : approvers) {
                    if (mgr.getId() == loggedUser.getId()) continue;
                    NotificationService.send(
                            mgr.getId(),
                            "Phiếu xuất kho được gửi lại chờ duyệt",
                            "Nhân viên " + loggedUser.getName() + " đã cập nhật phiếu xuất " + existing.getReceiptCode() + " và gửi lại để duyệt.",
                            notifLink,
                            "export_receipt",
                            receiptId
                    );
                }
            }
            if (isSaveDraft) {
                session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/export-receipt?action=edit&id=" + receiptId);
            } else {
                session.setAttribute("toastMessage", "Cập nhật phiếu thành công, đã gửi lại để duyệt");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/export-receipt?action=list");
            }
        } else {
            request.setAttribute("toastMessage", "Không thể cập nhật phiếu");
            request.setAttribute("toastType", "danger");
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
        }
    }

    private int parseId(String s) {
        if (s == null || s.isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private int parsePage(String s) {
        if (s == null || s.isEmpty()) {
            return 1;
        }
        try {
            int p = Integer.parseInt(s);
            return p < 1 ? 1 : p;
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private Map<Integer, String> buildBrandMap(List<Generator> generators) {
        Map<Integer, String> brandMap = new LinkedHashMap<>();
        for (Generator g : generators) {
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) {
                        brand = c.getName();
                        break;
                    }
                }
            }
            brandMap.put(g.getId(), brand);
        }
        return brandMap;
    }

    private List<Inventory> loadAllInStockSerials() {
        return inventoryDAO.findAllInStock();
    }

    private String buildErrorMessage(String prefix, List<String> errors) {
        StringBuilder msg = new StringBuilder(prefix);
        for (String e : errors) {
            msg.append(" ").append(e.replace("Dòng ", "dòng "));
        }
        return msg.toString();
    }

    private List<ReceiptDetail> parseDetailsStrict(String[] genIds, String[] serials,
            String[] detailNotes, int warehouseId, List<String> errors) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) {
            return details;
        }
        java.util.Set<String> seenSerials = new java.util.HashSet<>();
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                    && (serial == null || serial.trim().isEmpty());
            if (rowEmpty) {
                continue;
            }
            int rowNum = i + 1;
            int genId = 0;
            try {
                genId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện");
                continue;
            }
            if (genId <= 0) {
                errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện");
                continue;
            }

            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) {
                    serial = null;
                } else if (serial.length() > MAX_SERIAL_LENGTH) {
                    errors.add("Dòng " + rowNum + ": Số serial không được vượt quá " + MAX_SERIAL_LENGTH + " ký tự");
                    continue;
                } else {
                    if (!seenSerials.add(serial)) {
                        errors.add("Dòng " + rowNum + ": Số serial \"" + serial + "\" bị trùng trong phiếu");
                        continue;
                    }
                }
            }
            if (serial == null) {
                errors.add("Dòng " + rowNum + ": Vui lòng nhập số serial");
                continue;
            }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) {
                errors.add("Dòng " + rowNum + ": Ghi chú không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
                continue;
            }

            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId);
            d.setSerialNumber(serial);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private List<ReceiptDetail> parseDetailsLenient(String[] genIds, String[] serials,
            String[] detailNotes) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) {
            return details;
        }
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                    && (serial == null || serial.trim().isEmpty());
            if (rowEmpty) {
                continue;
            }
            int genId = 0;
            try {
                genId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                continue;
            }
            if (genId <= 0) {
                continue;
            }
            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) {
                    serial = null;
                } else if (serial.length() > MAX_SERIAL_LENGTH) {
                    serial = serial.substring(0, MAX_SERIAL_LENGTH);
                }
            }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) {
                detailNote = detailNote.substring(0, MAX_NOTE_LENGTH);
            }
            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId);
            d.setSerialNumber(serial);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private void validateInventoryAvailability(int warehouseId, List<ReceiptDetail> details, List<String> errors) {
        if (warehouseId <= 0 || details == null || details.isEmpty()) {
            return;
        }
        Map<Integer, Integer> requiredByGen = new LinkedHashMap<>();
        for (ReceiptDetail d : details) {
            if (d.getGeneratorId() <= 0) {
                continue;
            }
            Integer cur = requiredByGen.get(d.getGeneratorId());
            requiredByGen.put(d.getGeneratorId(), (cur == null ? 0 : cur) + 1);
        }
        for (Map.Entry<Integer, Integer> entry : requiredByGen.entrySet()) {
            int genId = entry.getKey();
            int required = entry.getValue();
            int onHand = inventoryDAO.findInStockByWarehouseAndGenerator(warehouseId, genId).size();
            if (onHand < required) {
                Generator gen = genDAO.findById(genId);
                String model = (gen != null && gen.getModel() != null && !gen.getModel().isEmpty())
                        ? gen.getModel() : ("#" + genId);
                int shortage = required - onHand;
                errors.add("Máy " + model + " trong kho không đủ: cần " + required
                        + " máy, chỉ còn " + onHand + " máy. Vui lòng nhập thêm " + shortage + " máy.");
            }
        }
    }

    /**
     * Kiem tra phieu xuat tao tu order da quet dung va du serial theo tung model.
     * Ap dung cho ca draft va gui duyet (theo yeu cau nguoi dung).
     * - Thieu may: so luong quet < quantity trong order
     * - Thua may: so luong quet > quantity trong order
     * - Quet nham: generatorId khong thuoc order
     */
    private void validateOrderCompleteness(int orderId, List<ReceiptDetail> details, List<String> errors) {
        List<OrderDetail> ods = new OrderDetailDAO().findGeneratorById(orderId);
        if (ods == null || ods.isEmpty()) {
            errors.add("Đơn hàng không có chi tiết máy");
            return;
        }

        Map<Integer, Integer> scannedByGen = new HashMap<>();
        if (details != null) {
            for (ReceiptDetail d : details) {
                if (d.getGeneratorId() > 0) {
                    Integer cur = scannedByGen.get(d.getGeneratorId());
                    scannedByGen.put(d.getGeneratorId(), (cur == null ? 0 : cur) + 1);
                }
            }
        }

        Set<Integer> checkedGenIds = new HashSet<>();
        for (OrderDetail od : ods) {
            int genId = od.getGeneratorId();
            int required = od.getQuantity() > 0 ? od.getQuantity() : 1;
            int scanned = scannedByGen.getOrDefault(genId, 0);
            String model = (od.getGeneratorModel() != null && !od.getGeneratorModel().isEmpty())
                    ? od.getGeneratorModel() : ("#" + genId);
            checkedGenIds.add(genId);

            if (scanned < required) {
                errors.add("Thiếu máy " + model + ": đã quét " + scanned + "/" + required);
            } else if (scanned > required) {
                errors.add("Thừa máy " + model + ": đã quét " + scanned + "/" + required);
            }
        }

        for (Map.Entry<Integer, Integer> entry : scannedByGen.entrySet()) {
            if (!checkedGenIds.contains(entry.getKey())) {
                errors.add("Có dòng không thuộc đơn hàng (generatorId=" + entry.getKey()
                        + ", số lượng=" + entry.getValue() + ")");
            }
        }
    }

    private String lookupGeneratorBrand(int generatorId) {
        Generator gen = genDAO.findById(generatorId);
        if (gen == null) return "";
        if (gen.getCategories() != null) {
            for (Category c : gen.getCategories()) {
                if ("brand".equals(c.getType())) {
                    return c.getName() != null ? c.getName() : "";
                }
            }
        }
        return "";
    }
}
