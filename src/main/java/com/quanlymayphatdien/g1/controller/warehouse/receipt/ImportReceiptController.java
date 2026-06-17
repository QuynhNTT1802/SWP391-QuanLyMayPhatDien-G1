
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse.receipt;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.PurchaseOrderDetail;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.NotificationService;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.PeriodUtils;
import com.quanlymayphatdien.g1.utils.ReceiptExcelSupport;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author FPTShop
 */
@WebServlet(name = "ImportReceiptController", urlPatterns = {"/import-receipt"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class ImportReceiptController extends HttpServlet {

    private static final String TYPE = "IMPORT";
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
        if (!isLoggedIn(request, response)) return;
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";
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
                case "loadGenerators":
                    loadGeneratorsJson(request, response);
                    break;
                case "selectPurchase":
                    showSelectPurchaseOrder(request, response);
                    break;
                case "template":
                    downloadTemplate(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.RECEIPT, "ImportReceiptController.doGet", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) return;
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "save":
                    saveReceipt(request, response);
                    break;
                case "update":
                    updateReceipt(request, response);
                    break;
                case "approve":
                    approveReceipt(request, response);
                    break;
                case "reject":
                    rejectReceipt(request, response);
                    break;
                case "requestRevision":
                    requestRevision(request, response);
                    break;
                case "importPreview":
                    importPreview(request, response);
                    break;
                case "importConfirm":
                    importConfirm(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.RECEIPT, "ImportReceiptController.doPost", e.getMessage(), e);
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
        if (page > totalPages) page = totalPages;

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
        request.setAttribute("canApproveReceipt", perms != null && perms.contains("receipts.approve"));
        request.setAttribute("canRejectReceipt", perms != null && perms.contains("receipts.reject"));
        request.getRequestDispatcher("/view/receipt/import/import-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-create");

        String poIdStr = request.getParameter("poId");
        if (poIdStr != null && !poIdStr.isEmpty()) {
            int poId = parseId(poIdStr);
            PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
            if (po != null && "APPROVED".equalsIgnoreCase(po.getStatus())) {
                List<PurchaseOrderDetail> pods = po.getDetails();
                Receipt prefill = new Receipt();
                prefill.setProposalId(poId);
                prefill.setWarehouseId(po.getWarehouseId());
                prefill.setReceiptType(TYPE);
                prefill.setNote("Tạo từ phiếu purchase " + po.getPoCode());
                List<ReceiptDetail> ds = new ArrayList<>();
                if (pods != null) {
                    for (PurchaseOrderDetail pod : pods) {
                        int qty = pod.getFinalQuantity() > 0 ? pod.getFinalQuantity() : (pod.getProposedQuantity() > 0 ? pod.getProposedQuantity() : 1);
                        for (int k = 0; k < qty; k++) {
                            ReceiptDetail rd = new ReceiptDetail();
                            rd.setGeneratorId(pod.getGeneratorId());
                            rd.setNote(pod.getNote());
                            ds.add(rd);
                        }
                    }
                }
                prefill.setDetails(ds);
                request.setAttribute("receipt", prefill);
                request.setAttribute("purchaseOrder", po);
            }
        }

        request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
    }

    private void showSelectPurchaseOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String period = request.getParameter("period");
        int warehouseId = parseId(request.getParameter("warehouseId"));
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        String dateFrom = null;
        String dateTo = null;
        if (period != null && !period.isEmpty()) {
            String cleanPeriod = period.replace("-", "");
            dateFrom = PeriodUtils.startOf(cleanPeriod).toString();
            dateTo = PeriodUtils.endOf(cleanPeriod).toString();
        }

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        int totalItems = dao.countByFilters(dateFrom, dateTo, warehouseId, "APPROVED");
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) page = totalPages;
        List<PurchaseOrder> approvedPOs = dao.findByFilters(dateFrom, dateTo, warehouseId, "APPROVED", page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("approvedPOs", approvedPOs);
        request.setAttribute("period", period);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.getRequestDispatcher("/view/receipt/import/import-select-purchase.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null || receipt.getCreatedBy() != loggedUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!TYPE.equals(receipt.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=edit&id=" + id);
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
        request.setAttribute("activePage", "import-edit");
        request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null) {
            request.setAttribute("error", "Không tìm thấy phiếu");
            request.getRequestDispatcher("/view/receipt/import/import-detail.jsp").forward(request, response);
            return;
        }
        if (!TYPE.equals(receipt.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=detail&id=" + id);
            return;
        }
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean isManager = perms != null && perms.contains("receipts.approve");
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
        request.setAttribute("isManager", isManager);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("activePage", "import-detail");
        request.getRequestDispatcher("/view/receipt/import/import-detail.jsp").forward(request, response);
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
        List<Generator> generators = genDAO.findAllActive();
        List<Map<String, Object>> out = new ArrayList<>();
        for (Generator g : generators) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", g.getId());
            item.put("model", g.getModel());
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) { brand = c.getName(); break; }
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

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();

        if (warehouseId <= 0 && !isDraft) errors.add("Vui lòng chọn kho");
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { if (!isDraft) errors.add("Lý do không hợp lệ"); }
        } else if (!isDraft) errors.add("Vui lòng chọn lý do");

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isDraft) {
            details = parseDetailsLenient(genIds, serials, detailNotes);
        } else {
            details = parseDetailsStrict(genIds, serials, detailNotes, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isDraft ? "Lưu nháp thất bại:" : "Lưu phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptCode(receiptDAO.generateReceiptCode(TYPE));
        r.setReceiptType(TYPE);
        r.setWarehouseId(warehouseId);
        r.setCreatedBy(loggedUser.getId());
        r.setNote(note);
        r.setReasonId(reasonId);
        String pid = request.getParameter("poId");
        if (pid != null && !pid.isEmpty()) {
            try {
                r.setProposalId(Integer.parseInt(pid));
            } catch (NumberFormatException ignored) {}
        }
        r.setStatus(isDraft ? GlobalUtils.RECEIPT_STATUS_DRAFT : GlobalUtils.RECEIPT_STATUS_PENDING);

        int receiptId = receiptDAO.insert(r);
        if (receiptId <= 0) {
            request.setAttribute("toastMessage", "Không thể tạo phiếu, vui lòng thử lại");
            request.setAttribute("toastType", "danger");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);
            for (ReceiptDetail d : details) {
                int invId = inventoryDAO.insertPendingImport(conn, d.getGeneratorId(), d.getSerialNumber(), warehouseId);
                if (invId <= 0) {
                    throw new SQLException("Không thể tạo serial '" + d.getSerialNumber() + "'");
                }
                d.setReceiptId(receiptId);
                d.setInventoryId(invId);
            }
            detailDAO.batchInsert(conn, details);
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
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        log.setAction("CREATE");
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails(isDraft ? "Lưu nháp phiếu nhập kho" : "Tạo phiếu nhập kho");
        activityLogDAO.insert(log);

        if (!isDraft) {
            String notifLink = request.getContextPath() + "/import-receipt?action=detail&id=" + receiptId;
            List<User> approvers = userDAO.findUsersByPermission("receipts", "approve");
            for (User mgr : approvers) {
                if (mgr.getId() == loggedUser.getId()) continue;
                NotificationService.send(
                        mgr.getId(),
                        "Phiếu nhập kho mới chờ duyệt",
                        "Nhân viên " + loggedUser.getName() + " đã tạo phiếu nhập " + r.getReceiptCode() + " cần bạn duyệt.",
                        notifLink,
                        "import_receipt",
                        receiptId
                );
            }
        }

        if (isDraft) {
            session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=edit&id=" + receiptId);
        } else {
            session.setAttribute("toastMessage", "Thêm phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
        }
    }

    private void updateReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int receiptId = parseId(request.getParameter("receiptId"));
        if (receiptId <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/import-receipt");
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
        if (warehouseId <= 0 && !isSaveDraft) errors.add("Vui lòng chọn kho");
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { if (!isSaveDraft) errors.add("Lý do không hợp lệ"); }
        } else if (!isSaveDraft) errors.add("Vui lòng chọn lý do");

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isSaveDraft) {
            details = parseDetailsLenient(genIds, serials, detailNotes);
        } else {
            details = parseDetailsStrict(genIds, serials, detailNotes, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isSaveDraft ? "Lưu nháp thất bại:" : "Cập nhật phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("activePage", "import-edit");
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
            return;
        }

        // Insert new inventory rows (PENDING_IMPORT) truoc khi goi updateReceipt
        // de updateReceipt co the set inventory_id len tung detail
        java.sql.Connection conn = null;
        boolean inventoryCreated = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);
            for (ReceiptDetail d : details) {
                if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) {
                    continue;
                }
                int invId = inventoryDAO.insertPendingImport(conn, d.getGeneratorId(), d.getSerialNumber(), warehouseId);
                if (invId <= 0) {
                    throw new SQLException("Không thể tạo serial '" + d.getSerialNumber() + "'");
                }
                d.setInventoryId(invId);
            }
            conn.commit();
            inventoryCreated = true;
        } catch (java.sql.SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
            errors.add("Lỗi khi tạo serial mới: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
        }
        if (!inventoryCreated) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Cập nhật phiếu thất bại:", errors));
            request.setAttribute("activePage", "import-edit");
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
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
            log.setDetails(isSaveDraft ? "Lưu nháp phiếu nhập kho" : (isDraft ? "Gửi phiếu nháp để duyệt" : "Cập nhật phiếu nhập kho"));
            activityLogDAO.insert(log);
            if (!isSaveDraft) {
                String notifLink = request.getContextPath() + "/import-receipt?action=detail&id=" + receiptId;
                List<User> approvers = userDAO.findUsersByPermission("receipts", "approve");
                for (User mgr : approvers) {
                    if (mgr.getId() == loggedUser.getId()) continue;
                    NotificationService.send(
                            mgr.getId(),
                            "Phiếu nhập kho được gửi lại chờ duyệt",
                            "Nhân viên " + loggedUser.getName() + " đã cập nhật phiếu nhập " + existing.getReceiptCode() + " và gửi lại để duyệt.",
                            notifLink,
                            "import_receipt",
                            receiptId
                    );
                }
            }
            if (isSaveDraft) {
                session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/import-receipt?action=edit&id=" + receiptId);
            } else {
                session.setAttribute("toastMessage", "Cập nhật phiếu thành công, đã gửi lại để duyệt");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
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
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
        }
    }

    private void approveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }
        List<String> errors = receiptDAO.approveReceipt(id, loggedUser.getId());
        if (errors == null || errors.isEmpty()) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("APPROVE");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                log.setDetails("Duyệt phiếu nhập kho, cập nhật tồn kho");
                activityLogDAO.insert(log);
                if (r.getCreatedBy() != loggedUser.getId()) {
                    NotificationService.send(
                            r.getCreatedBy(),
                            "Phiếu nhập kho đã được duyệt",
                            "Phiếu nhập " + r.getReceiptCode() + " đã được " + loggedUser.getName() + " duyệt.",
                            request.getContextPath() + "/import-receipt?action=detail&id=" + id,
                            "import_receipt",
                            id
                    );
                }
            }
            session.setAttribute("toastMessage", "Duyệt phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
        } else {
            StringBuilder msg = new StringBuilder("Không thể duyệt phiếu:");
            for (String e : errors) msg.append(" ").append(e).append(";");
            request.setAttribute("toastMessage", msg.toString());
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private void rejectReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { reasonId = null; }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) reasonNote = null;
        }
        boolean ok = receiptDAO.rejectReceipt(id, loggedUser.getId(), reasonId, reasonNote);
        if (ok) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("REJECT");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                String detail = "Từ chối phiếu";
                if (reasonNote != null) detail += ": " + reasonNote;
                log.setDetails(detail);
                activityLogDAO.insert(log);
                if (r.getCreatedBy() != loggedUser.getId()) {
                    String notifMsg = "Phiếu nhập " + r.getReceiptCode() + " đã bị từ chối bởi " + loggedUser.getName() + ".";
                    if (reasonNote != null) notifMsg += " Lý do: " + reasonNote;
                    NotificationService.send(
                            r.getCreatedBy(),
                            "Phiếu nhập kho bị từ chối",
                            notifMsg,
                            request.getContextPath() + "/import-receipt?action=detail&id=" + id,
                            "import_receipt",
                            id
                    );
                }
            }
            session.setAttribute("toastMessage", "Đã từ chối phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể từ chối phiếu");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private void requestRevision(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { reasonId = null; }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) reasonNote = null;
        }
        boolean ok = receiptDAO.requestRevision(id, loggedUser.getId(), reasonId, reasonNote);
        if (ok) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("REVISION");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                String detail = "Yêu cầu chỉnh sửa";
                if (reasonNote != null) detail += ": " + reasonNote;
                log.setDetails(detail);
                activityLogDAO.insert(log);
                if (r.getCreatedBy() != loggedUser.getId()) {
                    String notifMsg = "Phiếu nhập " + r.getReceiptCode() + " cần chỉnh sửa bởi " + loggedUser.getName() + ".";
                    if (reasonNote != null) notifMsg += " Lý do: " + reasonNote;
                    NotificationService.send(
                            r.getCreatedBy(),
                            "Phiếu nhập kho cần chỉnh sửa",
                            notifMsg,
                            request.getContextPath() + "/import-receipt?action=detail&id=" + id,
                            "import_receipt",
                            id
                    );
                }
            }
            session.setAttribute("toastMessage", "Đã gửi yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private void downloadTemplate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        XSSFWorkbook workbook = ReceiptExcelSupport.createTemplateWorkbook();
        String fileName = "mau-phieu-nhap-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private void importPreview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        int warehouseId = parseId(request.getParameter("warehouseId"));
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException ignored) {
            }
        }
        String note = request.getParameter("note");

        Part filePart = null;
        try {
            filePart = request.getPart("excelFile");
        } catch (Exception e) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Không đọc được file upload: " + e.getMessage());
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("activePage", "import-create");
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Vui lòng chọn file Excel để nhập");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("activePage", "import-create");
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        List<Map<String, String>> rawRows;
        try (InputStream is = filePart.getInputStream()) {
            rawRows = ReceiptExcelSupport.parseFromExcel(is);
        } catch (Exception e) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "File Excel không hợp lệ: " + e.getMessage());
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("activePage", "import-create");
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        List<Generator> allGenerators = genDAO.findAllActive();
        java.util.Map<String, Generator> modelIndex = new java.util.HashMap<>();
        for (Generator g : allGenerators) {
            if (g.getModel() != null) {
                modelIndex.put(g.getModel().trim().toLowerCase(), g);
            }
        }

        List<Map<String, Object>> validRows = new ArrayList<>();
        List<Map<String, Object>> invalidRows = new ArrayList<>();
        java.util.Set<String> seenSerials = new java.util.HashSet<>();

        for (int i = 0; i < rawRows.size(); i++) {
            Map<String, String> raw = rawRows.get(i);
            int rowNum = i + 2;

            String model = raw.getOrDefault(ReceiptExcelSupport.COL_MODEL, "").trim();
            String serial = raw.getOrDefault(ReceiptExcelSupport.COL_SERIAL, "").trim();
            String qtyStr = raw.getOrDefault(ReceiptExcelSupport.COL_QUANTITY, "").trim();
            String detailNote = raw.getOrDefault(ReceiptExcelSupport.COL_NOTE, "").trim();

            Map<String, Object> row = new LinkedHashMap<>();
            row.put("rowNum", rowNum);
            row.put("model", model);
            row.put("serial", serial);
            row.put("quantity", qtyStr.isEmpty() ? "1" : qtyStr);
            row.put("note", detailNote);

            List<String> errors = new ArrayList<>();

            if (model.isEmpty()) {
                errors.add("Thiếu mã máy");
            }
            if (serial.isEmpty()) {
                errors.add("Thiếu số serial");
            } else if (serial.length() > MAX_SERIAL_LENGTH) {
                errors.add("Serial vượt quá " + MAX_SERIAL_LENGTH + " ký tự");
            }

            Generator resolved = null;
            if (!model.isEmpty()) {
                resolved = modelIndex.get(model.toLowerCase());
                if (resolved == null) {
                    try {
                        int gid = Integer.parseInt(model);
                        for (Generator g : allGenerators) {
                            if (g.getId() == gid) {
                                resolved = g;
                                break;
                            }
                        }
                    } catch (NumberFormatException ignored) {
                    }
                }
                if (resolved == null) {
                    errors.add("Không tìm thấy máy \"" + model + "\"");
                } else if (!"active".equalsIgnoreCase(resolved.getStatus())) {
                    errors.add("Máy \"" + model + "\" không hoạt động");
                }
            }

            int qty = 1;
            if (!qtyStr.isEmpty()) {
                try {
                    qty = Integer.parseInt(qtyStr);
                } catch (NumberFormatException e) {
                    errors.add("Số lượng không hợp lệ");
                }
            }
            if (qty <= 0) {
                errors.add("Số lượng phải lớn hơn 0");
            } else if (qty > MAX_QUANTITY) {
                errors.add("Số lượng vượt quá " + MAX_QUANTITY);
            }
            // qty chi hien thi trong preview, KHONG su dung khi insert (moi serial = 1 row)

            if (detailNote.length() > MAX_NOTE_LENGTH) {
                errors.add("Ghi chú vượt quá " + MAX_NOTE_LENGTH + " ký tự");
            }

            if (!serial.isEmpty() && !seenSerials.add(serial)) {
                errors.add("Serial \"" + serial + "\" bị trùng trong file");
            }

            if (resolved != null) {
                row.put("generatorId", resolved.getId());
                row.put("generatorModel", resolved.getModel());
                String brand = "";
                if (resolved.getCategories() != null) {
                    for (Category c : resolved.getCategories()) {
                        if ("brand".equals(c.getType())) {
                            brand = c.getName();
                            break;
                        }
                    }
                }
                row.put("brand", brand);
            }

            if (errors.isEmpty()) {
                validRows.add(row);
            } else {
                row.put("_errors", String.join("; ", errors));
                invalidRows.add(row);
            }
        }

        request.setAttribute("validRows", validRows);
        request.setAttribute("invalidRows", invalidRows);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("reasonId", reasonId);
        request.setAttribute("note", note);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.getRequestDispatcher("/view/receipt/import/import-preview.jsp").forward(request, response);
    }

    private void importConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        int warehouseId = parseId(request.getParameter("warehouseId"));
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException ignored) {
            }
        }
        String note = request.getParameter("note");
        String[] rowIndexes = request.getParameterValues("rowIndex");

        List<String> errors = new ArrayList<>();
        if (warehouseId <= 0) {
            errors.add("Vui lòng chọn kho");
        }
        if (rowIndexes == null || rowIndexes.length == 0) {
            errors.add("Vui lòng chọn ít nhất 1 dòng để nhập");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Không thể tạo phiếu: " + String.join("; ", errors));
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("activePage", "import-create");
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details = new ArrayList<>();
        java.util.Set<String> seen = new java.util.HashSet<>();
        int importedFromFile = 0;
        for (String idx : rowIndexes) {
            int i;
            try {
                i = Integer.parseInt(idx);
            } catch (NumberFormatException e) {
                continue;
            }
            if (genIds == null || i < 0 || i >= genIds.length) {
                continue;
            }
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;

            int genId = 0;
            try {
                genId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                continue;
            }
            if (genId <= 0 || serial == null || serial.trim().isEmpty()) {
                continue;
            }
            serial = serial.trim();
            if (!seen.add(serial)) {
                continue;
            }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) {
                detailNote = detailNote.substring(0, MAX_NOTE_LENGTH);
            }

            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId);
            d.setSerialNumber(serial);
            d.setNote(detailNote);
            details.add(d);
            importedFromFile++;
        }

        if (details.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Không có dòng hợp lệ nào được chọn");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("activePage", "import-create");
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptCode(receiptDAO.generateReceiptCode(TYPE));
        r.setReceiptType(TYPE);
        r.setWarehouseId(warehouseId);
        r.setCreatedBy(loggedUser.getId());
        r.setNote(note);
        r.setReasonId(reasonId);
        r.setStatus(GlobalUtils.RECEIPT_STATUS_DRAFT);

        int receiptId = receiptDAO.insert(r);
        if (receiptId <= 0) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Không thể tạo phiếu, vui lòng thử lại");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);
            for (ReceiptDetail d : details) {
                int invId = inventoryDAO.insertPendingImport(conn, d.getGeneratorId(), d.getSerialNumber(), warehouseId);
                if (invId <= 0) {
                    throw new SQLException("Không thể tạo serial '" + d.getSerialNumber() + "'");
                }
                d.setReceiptId(receiptId);
                d.setInventoryId(invId);
            }
            detailDAO.batchInsert(conn, details);
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
            request.setAttribute("toastMessage", "Không thể tạo phiếu: " + String.join("; ", errors));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        log.setAction("IMPORT_EXCEL");
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails("Nhập " + importedFromFile + " dòng từ Excel → tạo phiếu nháp");
        activityLogDAO.insert(log);

        session.setAttribute("toastMessage", "Đã nhập " + importedFromFile + " dòng từ Excel vào phiếu nháp");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/import-receipt?action=edit&id=" + receiptId);
    }

    private boolean hasApprovePerm(HttpSession session) {
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        return perms != null && perms.contains("receipts.approve");
    }

    private int parseId(String s) {
        if (s == null || s.isEmpty()) return 0;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return 0; }
    }

    private int parsePage(String s) {
        if (s == null || s.isEmpty()) return 1;
        try { int p = Integer.parseInt(s); return p < 1 ? 1 : p; }
        catch (NumberFormatException e) { return 1; }
    }

    private Map<Integer, String> buildBrandMap(List<Generator> generators) {
        Map<Integer, String> brandMap = new LinkedHashMap<>();
        for (Generator g : generators) {
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) { brand = c.getName(); break; }
                }
            }
            brandMap.put(g.getId(), brand);
        }
        return brandMap;
    }

    private String buildErrorMessage(String prefix, List<String> errors) {
        StringBuilder msg = new StringBuilder(prefix);
        for (String e : errors) msg.append(" ").append(e.replace("Dòng ", "dòng "));
        return msg.toString();
    }

    private List<ReceiptDetail> parseDetailsStrict(String[] genIds, String[] serials,
            String[] detailNotes, List<String> errors) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) return details;
        java.util.Set<String> seenSerials = new java.util.HashSet<>();
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                    && (serial == null || serial.trim().isEmpty());
            if (rowEmpty) continue;
            int rowNum = i + 1;
            int genId = 0;
            try { genId = Integer.parseInt(idStr); }
            catch (NumberFormatException e) { errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện"); continue; }
            if (genId <= 0) { errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện"); continue; }

            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) { serial = null; }
                else if (serial.length() > MAX_SERIAL_LENGTH) {
                    errors.add("Dòng " + rowNum + ": Số serial không được vượt quá " + MAX_SERIAL_LENGTH + " ký tự"); continue;
                } else {
                    if (!seenSerials.add(serial)) {
                        errors.add("Dòng " + rowNum + ": Số serial \"" + serial + "\" bị trùng trong phiếu"); continue;
                    }
                }
            }
            if (serial == null) { errors.add("Dòng " + rowNum + ": Vui lòng nhập số serial"); continue; }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) {
                errors.add("Dòng " + rowNum + ": Ghi chú không được vượt quá " + MAX_NOTE_LENGTH + " ký tự"); continue;
            }
            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId); d.setSerialNumber(serial);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private List<ReceiptDetail> parseDetailsLenient(String[] genIds, String[] serials,
            String[] detailNotes) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) return details;
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                    && (serial == null || serial.trim().isEmpty());
            if (rowEmpty) continue;
            int genId = 0;
            try { genId = Integer.parseInt(idStr); } catch (NumberFormatException e) { continue; }
            if (genId <= 0) continue;
            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) serial = null;
                else if (serial.length() > MAX_SERIAL_LENGTH) serial = serial.substring(0, MAX_SERIAL_LENGTH);
            }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) detailNote = detailNote.substring(0, MAX_NOTE_LENGTH);
            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId); d.setSerialNumber(serial);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }
}
