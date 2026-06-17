
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
import com.quanlymayphatdien.g1.utils.NotificationService;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
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
                case "approve":
                    approveReceipt(request, response);
                    break;
                case "reject":
                    rejectReceipt(request, response);
                    break;
                case "requestRevision":
                    requestRevision(request, response);
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
        request.setAttribute("canApproveReceipt", perms != null && perms.contains("receipts.approve"));
        request.setAttribute("canRejectReceipt", perms != null && perms.contains("receipts.reject"));
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
                List<OrderDetail> ods = new OrderDetailDAO().findByOrderId(orderId);
                Receipt prefill = new Receipt();
                prefill.setOrderId(orderId);
                prefill.setReceiptType(TYPE);
                prefill.setNote("Tạo từ đơn " + order.getOrderCode());
                List<ReceiptDetail> ds = new ArrayList<>();
                for (OrderDetail od : ods) {
                    int qty = od.getQuantity() > 0 ? od.getQuantity() : 1;
                    for (int k = 0; k < qty; k++) {
                        ReceiptDetail rd = new ReceiptDetail();
                        rd.setGeneratorId(od.getGeneratorId());
                        rd.setNote(od.getNote());
                        ds.add(rd);
                    }
                }
                prefill.setDetails(ds);
                request.setAttribute("receipt", prefill);
                request.setAttribute("order", order);
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

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isDraft ? "Lưu nháp thất bại:" : "Lưu phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
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
        r.setStatus(isDraft ? GlobalUtils.RECEIPT_STATUS_DRAFT : GlobalUtils.RECEIPT_STATUS_PENDING);

        int receiptId = receiptDAO.insert(r);
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

        java.sql.Connection conn = null;
        boolean ok = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);
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
                if (!inventoryDAO.reserveForExport(conn, inv.getInventoryId())) {
                    throw new SQLException("Serial \"" + d.getSerialNumber() + "\" đã bị reserve bởi phiếu khác");
                }
                d.setReceiptId(receiptId);
                d.setInventoryId(inv.getInventoryId());
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
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
            return;
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        log.setAction("CREATE");
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails(isDraft ? "Lưu nháp phiếu xuất kho" : "Tạo phiếu xuất kho");
        activityLogDAO.insert(log);

        if (!isDraft) {
            String notifLink = request.getContextPath() + "/export-receipt?action=detail&id=" + receiptId;
            List<User> approvers = userDAO.findUsersByPermission("receipts", "approve");
            for (User mgr : approvers) {
                if (mgr.getId() == loggedUser.getId()) continue;
                NotificationService.send(
                        mgr.getId(),
                        "Phiếu xuất kho mới chờ duyệt",
                        "Nhân viên " + loggedUser.getName() + " đã tạo phiếu xuất " + r.getReceiptCode() + " cần bạn duyệt.",
                        notifLink,
                        "export_receipt",
                        receiptId
                );
            }
        }

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

    private void approveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }
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
                log.setDetails("Duyệt phiếu xuất kho, cập nhật tồn kho");
                activityLogDAO.insert(log);

                if (r.getLiquidationId() != null && r.getLiquidationId() > 0) {
                    com.quanlymayphatdien.g1.dal.LiquidationDAO liqDAO = new com.quanlymayphatdien.g1.dal.LiquidationDAO();
                    liqDAO.updateStatus(r.getLiquidationId(), com.quanlymayphatdien.g1.utils.GlobalUtils.STATUS_COMPLETED, loggedUser.getId(), "warehouse", id);
                    ActivityLog liqLog = new ActivityLog();
                    liqLog.setUserId(loggedUser.getId());
                    liqLog.setEntityType("liquidation");
                    liqLog.setAction("EXPORT_APPROVE");
                    liqLog.setEntityId(r.getLiquidationId());
                    liqLog.setEntityName(r.getLiquidationCode() != null ? r.getLiquidationCode() : "N/A");
                    liqLog.setDetails("Quản lý kho duyệt phiếu xuất kho " + r.getReceiptCode() + ", hoàn tất xuất máy thanh lý.");
                    activityLogDAO.insert(liqLog);
                }

                if (r.getCreatedBy() != loggedUser.getId()) {
                    NotificationService.send(
                            r.getCreatedBy(),
                            "Phiếu xuất kho đã được duyệt",
                            "Phiếu xuất " + r.getReceiptCode() + " đã được " + loggedUser.getName() + " duyệt.",
                            request.getContextPath() + "/export-receipt?action=detail&id=" + id,
                            "export_receipt",
                            id
                    );
                }
            }
            session.setAttribute("toastMessage", "Duyệt phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=detail&id=" + id);
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
        if (!hasApprovePerm(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                reasonId = null;
            }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) {
                reasonNote = null;
            }
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
                if (reasonNote != null) {
                    detail += ": " + reasonNote;
                }
                log.setDetails(detail);
                activityLogDAO.insert(log);

                if (r.getLiquidationId() != null && r.getLiquidationId() > 0) {
                    com.quanlymayphatdien.g1.dal.LiquidationDAO liqDAO = new com.quanlymayphatdien.g1.dal.LiquidationDAO();
                    liqDAO.updateStatus(r.getLiquidationId(), com.quanlymayphatdien.g1.utils.GlobalUtils.STATUS_CANCELLED, loggedUser.getId(), "warehouse", id);

                    com.quanlymayphatdien.g1.dal.InventoryDAO invDAO = new com.quanlymayphatdien.g1.dal.InventoryDAO();
                    if (r.getDetails() != null) {
                        for (com.quanlymayphatdien.g1.entity.ReceiptDetail rd : r.getDetails()) {
                            if (rd.getSerialNumber() != null && !rd.getSerialNumber().trim().isEmpty()) {
                                invDAO.updateStatusBySerial(rd.getSerialNumber().trim(), com.quanlymayphatdien.g1.dal.InventoryDAO.STATUS_IN_STOCK);
                            }
                        }
                    }

                    ActivityLog liqLog = new ActivityLog();
                    liqLog.setUserId(loggedUser.getId());
                    liqLog.setEntityType("liquidation");
                    liqLog.setAction("EXPORT_REJECT");
                    liqLog.setEntityId(r.getLiquidationId());
                    liqLog.setEntityName(r.getLiquidationCode() != null ? r.getLiquidationCode() : "N/A");
                    liqLog.setDetails("Quản lý kho từ chối phiếu xuất kho " + r.getReceiptCode() + " (do bùng kèo hoặc sự cố). Đơn thanh lý đã bị hủy và máy được hoàn trả về kho.");
                    activityLogDAO.insert(liqLog);
                }

                if (r.getCreatedBy() != loggedUser.getId()) {
                    String notifMsg = "Phiếu xuất " + r.getReceiptCode() + " đã bị từ chối bởi " + loggedUser.getName() + ".";
                    if (reasonNote != null) notifMsg += " Lý do: " + reasonNote;
                    NotificationService.send(
                            r.getCreatedBy(),
                            "Phiếu xuất kho bị từ chối",
                            notifMsg,
                            request.getContextPath() + "/export-receipt?action=detail&id=" + id,
                            "export_receipt",
                            id
                    );
                }
            }
            session.setAttribute("toastMessage", "Đã từ chối phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=detail&id=" + id);
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
        if (!hasApprovePerm(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/export-receipt");
            return;
        }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                reasonId = null;
            }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) {
                reasonNote = null;
            }
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
                if (reasonNote != null) {
                    detail += ": " + reasonNote;
                }
                log.setDetails(detail);
                activityLogDAO.insert(log);
                if (r.getCreatedBy() != loggedUser.getId()) {
                    String notifMsg = "Phiếu xuất " + r.getReceiptCode() + " cần chỉnh sửa bởi " + loggedUser.getName() + ".";
                    if (reasonNote != null) notifMsg += " Lý do: " + reasonNote;
                    NotificationService.send(
                            r.getCreatedBy(),
                            "Phiếu xuất kho cần chỉnh sửa",
                            notifMsg,
                            request.getContextPath() + "/export-receipt?action=detail&id=" + id,
                            "export_receipt",
                            id
                    );
                }
            }
            session.setAttribute("toastMessage", "Đã gửi yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private boolean hasApprovePerm(HttpSession session) {
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        return perms != null && perms.contains("receipts.approve");
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
}
