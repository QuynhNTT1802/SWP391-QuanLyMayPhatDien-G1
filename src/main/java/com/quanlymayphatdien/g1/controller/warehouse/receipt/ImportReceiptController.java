
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
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.PurchaseOrderDetail;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.ReceiptExcelSupport;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.WarehouseAccessUtil;
import com.google.gson.Gson;
import com.quanlymayphatdien.g1.utils.NotificationService;
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
                    selectPurchase(request, response);
                    break;
                case "template":
                    downloadTemplate(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "ImportReceiptController.doGet", e.getMessage(), e);
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
            SystemLogger.error("Quản lý kho", "ImportReceiptController.doPost", e.getMessage(), e);
            e.printStackTrace();
            if (!response.isCommitted() && isAjaxRequest(request)) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json;charset=UTF-8");
                String msg = "Lỗi hệ thống: " + e.getMessage().replace("\"", "'");
                response.getWriter().write("{\"success\":false,\"message\":\"" + msg + "\"}");
            }
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

        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        String statusFilter = request.getParameter("status");
        String whFilter = request.getParameter("warehouse");
        if (scopedWarehouseId > 0) {
            if (whFilter != null && !whFilter.isEmpty()) {
                try {
                    if (Integer.parseInt(whFilter) != scopedWarehouseId) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            whFilter = String.valueOf(scopedWarehouseId);
        }
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
        if (scopedWarehouseId > 0) {
            com.quanlymayphatdien.g1.entity.Warehouse scoped = warehouseDAO.findById(scopedWarehouseId);
            request.setAttribute("warehouses", scoped != null ? java.util.Collections.singletonList(scoped) : java.util.Collections.emptyList());
            request.setAttribute("scopedWarehouseId", scopedWarehouseId);
            if (scoped != null) {
                request.setAttribute("scopedWarehouseName", scoped.getName());
            }
        } else {
            request.setAttribute("warehouses", warehouseDAO.findAll());
        }
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
        HttpSession session = request.getSession(false);
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);

        if (scopedWarehouseId > 0) {
            com.quanlymayphatdien.g1.entity.Warehouse scoped = warehouseDAO.findById(scopedWarehouseId);
            request.setAttribute("warehouses", scoped != null ? java.util.Collections.singletonList(scoped) : java.util.Collections.emptyList());
            request.setAttribute("scopedWarehouseId", scopedWarehouseId);
            if (scoped != null) {
                request.setAttribute("scopedWarehouseName", scoped.getName());
            }
        } else {
            request.setAttribute("warehouses", warehouseDAO.findAll());
        }
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-create");

        String poIdStr = request.getParameter("poId");
        if (poIdStr != null && !poIdStr.isEmpty()) {
            int poId = parseId(poIdStr);
            PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
            if (po != null && "APPROVED".equalsIgnoreCase(po.getStatus())) {
                if (scopedWarehouseId > 0 && po.getWarehouseId() != scopedWarehouseId) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                applyPoPrefillToRequest(request, po, "Tạo từ phiếu purchase " + po.getPoCode());
            } else if (po != null && scopedWarehouseId > 0 && po.getWarehouseId() != scopedWarehouseId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
    }

    private void selectPurchase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        int totalItems = dao.countApprovedAvailableFiltered(search, fromDate, toDate);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) page = totalPages;
        List<PurchaseOrder> approvedPOs = dao.findApprovedAvailableFiltered(search, fromDate, toDate, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("approvedPOs", approvedPOs);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("activePage", "import-select-purchase");
        request.getRequestDispatcher("/view/receipt/import/import-select-purchase.jsp").forward(request, response);
    }

    private void applyPoPrefillToRequest(HttpServletRequest request, PurchaseOrder po, String note) {
        if (po == null) return;
        request.setAttribute("purchaseOrder", po);
        request.setAttribute("fromPurchaseOrder", Boolean.TRUE);
        Receipt prefill = new Receipt();
        prefill.setPurchaseOrderId(po.getPoId());
        prefill.setWarehouseId(po.getWarehouseId());
        prefill.setReceiptType(TYPE);
        prefill.setNote(note);
        List<PurchaseOrderDetail> pods = po.getDetails();
        List<ReceiptDetail> ds = new ArrayList<>();
        List<Map<String, Object>> poRowList = new ArrayList<>();
        int expectedRows = 0;
        if (pods != null) {
            for (PurchaseOrderDetail pod : pods) {
                int qty = pod.getFinalQuantity() > 0 ? pod.getFinalQuantity()
                         : (pod.getProposedQuantity() > 0 ? pod.getProposedQuantity() : 1);
                for (int k = 0; k < qty; k++) {
                    ReceiptDetail rd = new ReceiptDetail();
                    rd.setGeneratorId(pod.getGeneratorId());
                    rd.setNote(pod.getNote());
                    ds.add(rd);

                    Map<String, Object> poRow = new LinkedHashMap<>();
                    poRow.put("generatorId", pod.getGeneratorId());
                    poRow.put("generatorCode", pod.getGeneratorCode() != null ? pod.getGeneratorCode() : "");
                    poRow.put("generatorName", pod.getGeneratorName() != null ? pod.getGeneratorName() : "");
                    poRow.put("brandName", pod.getBrandName() != null ? pod.getBrandName() : "");
                    poRow.put("note", pod.getNote() != null ? pod.getNote() : "");
                    poRowList.add(poRow);

                    expectedRows++;
                }
            }
        }
        prefill.setDetails(ds);
        request.setAttribute("receipt", prefill);
        request.setAttribute("expectedRows", expectedRows);
        request.setAttribute("poRowList", poRowList);
    }

    private Integer parsePoIdFromRequest(HttpServletRequest request) {
        String poIdStr = request.getParameter("poId");
        if (poIdStr != null && !poIdStr.isEmpty()) {
            try {
                int id = Integer.parseInt(poIdStr.trim());
                return id > 0 ? id : null;
            } catch (NumberFormatException ignored) {
            }
        }
        return null;
    }

    private boolean isPoValid(HttpServletRequest request, int poId) {
        PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
        if (po == null) return false;
        if (!"APPROVED".equalsIgnoreCase(po.getStatus())) return false;
        if (!purchaseOrderBelongsToWarehouse(request, po)) return false;
        request.setAttribute("purchaseOrder", po);
        applyPoPrefillToRequest(request, po, "Tạo từ phiếu purchase " + po.getPoCode());
        return true;
    }

    private boolean purchaseOrderBelongsToWarehouse(HttpServletRequest request, PurchaseOrder po) {
        String whParam = request.getParameter("warehouseId");
        if (whParam == null || whParam.isEmpty()) return true;
        try {
            int whId = Integer.parseInt(whParam.trim());
            return whId <= 0 || whId == po.getWarehouseId();
        } catch (NumberFormatException e) {
            return true;
        }
    }

    /**
     * Xu ly Excel upload trong PO mode:
     *   - Moi dong Excel la 1 serial
     *   - Serial gan theo thu tu PO (khong can cot "Ma may")
     *   - Validate so luong serial khop voi PO
     *   - Validate khong trung serial
     *
     *   Neu la AJAX (X-Requested-With): tra JSON de JS apply thang vao form rows
     *   Neu khong: forward ve create page voi serial attribute
     */
    private void handleImportPreviewForPo(HttpServletRequest request, HttpServletResponse response,
            PurchaseOrder po, List<Map<String, String>> rawRows,
            int warehouseId, Integer reasonId, String note)
            throws ServletException, IOException {
        List<PurchaseOrderDetail> pods = po.getDetails();
        if (pods == null || pods.isEmpty()) {
            forwardBackToCreate(request, response, "PO không có chi tiết máy nào", "danger",
                    warehouseId, reasonId, note);
            return;
        }

        int expectedCount = 0;
        for (PurchaseOrderDetail pod : pods) {
            int qty = pod.getFinalQuantity() > 0 ? pod.getFinalQuantity()
                     : (pod.getProposedQuantity() > 0 ? pod.getProposedQuantity() : 1);
            expectedCount += qty;
        }

        List<String> serialList = new ArrayList<>();
        java.util.Set<String> seen = new java.util.HashSet<>();
        List<String> duplicateSerials = new ArrayList<>();
        List<String> blockedSerials = new ArrayList<>();
        for (int i = 0; i < rawRows.size(); i++) {
            Map<String, String> raw = rawRows.get(i);
            String serial = raw.getOrDefault(ReceiptExcelSupport.COL_SERIAL, "").trim();
            if (serial.isEmpty()) continue;
            if (serial.length() > MAX_SERIAL_LENGTH) {
                serialList.add(serial);
                blockedSerials.add("Dòng " + (i + 2) + ": serial quá " + MAX_SERIAL_LENGTH + " ký tự");
                continue;
            }
            if (!seen.add(serial)) {
                duplicateSerials.add("Dòng " + (i + 2) + ": serial \"" + serial + "\" bị trùng trong file");
                continue;
            }
            if (inventoryDAO.isSerialBlocked(serial)) {
                blockedSerials.add("Dòng " + (i + 2) + ": serial \"" + serial + "\" đã tồn tại trong hệ thống");
            }
            serialList.add(serial);
        }

        boolean isAjax = isAjaxRequest(request);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> body = new LinkedHashMap<>();
            if (serialList.size() != expectedCount) {
                body.put("success", false);
                body.put("message", "Số serial trong file (" + serialList.size()
                        + ") không khớp với PO (yêu cầu " + expectedCount + ")");
                new Gson().toJson(body, response.getWriter());
                return;
            }
            if (!duplicateSerials.isEmpty()) {
                body.put("success", false);
                body.put("message", "Có serial trùng trong file: " + String.join("; ", duplicateSerials));
                new Gson().toJson(body, response.getWriter());
                return;
            }
            if (!blockedSerials.isEmpty()) {
                body.put("success", false);
                body.put("message", "Có serial không hợp lệ: " + String.join("; ", blockedSerials));
                new Gson().toJson(body, response.getWriter());
                return;
            }
            body.put("success", true);
            body.put("serials", serialList);
            body.put("expectedCount", expectedCount);
            body.put("message", "Đã đọc " + serialList.size() + " serial");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        if (serialList.size() != expectedCount) {
            String msg = "Số serial trong file (" + serialList.size() + ") không khớp với PO (yêu cầu " + expectedCount + ")";
            forwardBackToCreate(request, response, msg, "danger", warehouseId, reasonId, note);
            return;
        }
        if (!duplicateSerials.isEmpty()) {
            String msg = "Có serial trùng trong file: " + String.join("; ", duplicateSerials);
            forwardBackToCreate(request, response, msg, "danger", warehouseId, reasonId, note);
            return;
        }
        if (!blockedSerials.isEmpty()) {
            String msg = "Có serial không hợp lệ: " + String.join("; ", blockedSerials);
            forwardBackToCreate(request, response, msg, "danger", warehouseId, reasonId, note);
            return;
        }

        applyPoPrefillToRequest(request, po, note != null ? note : "Tao tu phieu purchase " + po.getPoCode());
        request.setAttribute("poSerialList", serialList);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-create");
        request.setAttribute("toastType", "success");
        request.setAttribute("toastMessage", "Đã đọc " + serialList.size() + " serial từ file Excel. Kiểm tra lại rồi bấm Gửi phiếu.");
        request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String xrw = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xrw)) return true;
        String qs = request.getQueryString();
        if (qs != null && (qs.contains("ajax=1") || qs.contains("ajax=true"))) return true;
        String ajax = request.getParameter("ajax");
        return "1".equals(ajax) || "true".equalsIgnoreCase(ajax);
    }

    /**
     * Validate danh sach details voi purchase order:
     *  - Moi generator_id trong details phai ton tai trong PO
     *  - So luong moi generator_id phai khop voi finalQuantity trong PO
     *  - Khong duoc them generator_id khong co trong PO
     */
    private void validateAgainstPurchaseOrder(Integer poId, List<ReceiptDetail> details, List<String> errors) {
        if (poId == null || details == null || details.isEmpty()) {
            return;
        }
        PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
        if (po == null) {
            errors.add("Khong tim thay phieu purchase " + poId);
            return;
        }
        java.util.Map<Integer, Integer> expectedQty = new java.util.LinkedHashMap<>();
        for (PurchaseOrderDetail pod : po.getDetails()) {
            int qty = pod.getFinalQuantity() > 0 ? pod.getFinalQuantity()
                     : (pod.getProposedQuantity() > 0 ? pod.getProposedQuantity() : 1);
            expectedQty.put(pod.getGeneratorId(), qty);
        }
        java.util.Map<Integer, Integer> actualQty = new java.util.LinkedHashMap<>();
        for (ReceiptDetail d : details) {
            if (d.getGeneratorId() <= 0) continue;
            actualQty.merge(d.getGeneratorId(), 1, Integer::sum);
        }
        for (java.util.Map.Entry<Integer, Integer> e : expectedQty.entrySet()) {
            int expected = e.getValue();
            int actual = actualQty.getOrDefault(e.getKey(), 0);
            if (actual != expected) {
                String label = lookupGeneratorLabel(e.getKey());
                if (actual < expected) {
                    errors.add("Thieu " + (expected - actual) + " serial cho may " + label
                            + " (PO yeu cau " + expected + ", dang co " + actual + ")");
                } else {
                    errors.add("Thua " + (actual - expected) + " serial cho may " + label
                            + " (PO yeu cau " + expected + ", dang co " + actual + ")");
                }
            }
        }
        for (java.util.Map.Entry<Integer, Integer> a : actualQty.entrySet()) {
            if (!expectedQty.containsKey(a.getKey())) {
                String label = lookupGeneratorLabel(a.getKey());
                errors.add("May " + label + " khong co trong PO (khong duoc them)");
            }
        }
    }

    private String lookupGeneratorLabel(int generatorId) {
        Generator g = genDAO.findAllActive().stream()
                .filter(x -> x.getId() == generatorId)
                .findFirst().orElse(null);
        if (g == null) return "#" + generatorId;
        String brand = "";
        if (g.getCategories() != null) {
            for (Category c : g.getCategories()) {
                if ("brand".equals(c.getType())) { brand = c.getName(); break; }
            }
        }
        return brand.isEmpty() ? g.getModel() : (g.getModel() + " (" + brand + ")");
    }

    private void renderCreateWithError(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String whStr = request.getParameter("warehouseId");
        String reasonStr = request.getParameter("reasonId");
        String note = request.getParameter("note");
        int warehouseId = 0;
        Integer reasonId = null;
        try {
            if (whStr != null && !whStr.isEmpty()) warehouseId = Integer.parseInt(whStr);
        } catch (NumberFormatException ignored) {
        }
        try {
            if (reasonStr != null && !reasonStr.isEmpty()) reasonId = Integer.parseInt(reasonStr);
        } catch (NumberFormatException ignored) {
        }

        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-create");

        String[] manualGenIds = request.getParameterValues("manualGeneratorId");
        String[] manualSerials = request.getParameterValues("manualSerialNumber");
        String[] manualNotes = request.getParameterValues("manualDetailNote");
        if (manualGenIds != null) {
            List<Map<String, String>> manualRows = new ArrayList<>();
            for (int i = 0; i < manualGenIds.length; i++) {
                String gid = manualGenIds[i] != null ? manualGenIds[i] : "";
                String sn = (manualSerials != null && i < manualSerials.length) ? manualSerials[i] : "";
                String nt = (manualNotes != null && i < manualNotes.length) ? manualNotes[i] : "";
                if (gid.isEmpty() && sn.isEmpty() && nt.isEmpty()) continue;
                Map<String, String> r = new LinkedHashMap<>();
                r.put("generatorId", gid);
                r.put("serialNumber", sn);
                r.put("detailNote", nt);
                manualRows.add(r);
            }
            if (!manualRows.isEmpty()) {
                request.setAttribute("preservedManualRows", manualRows);
            }
        }
        request.setAttribute("preservedWarehouseId", warehouseId);
        request.setAttribute("preservedReasonId", reasonId);
        request.setAttribute("preservedNote", note);

        Integer poId = parsePoIdFromRequest(request);
        if (poId != null) {
            PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
            if (po != null) {
                applyPoPrefillToRequest(request, po, "Tao tu phieu purchase " + po.getPoCode());
            }
        }

        request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
    }

    private void errorsForPo(HttpServletRequest request, String message) {
        request.setAttribute("toastType", "danger");
        request.setAttribute("toastMessage", message);
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
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        if (scopedWarehouseId > 0 && receipt.getWarehouseId() != scopedWarehouseId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(receipt.getStatus());
        if (!isRevision) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("isDraft", false);
        request.setAttribute("receipt", receipt);
        if (scopedWarehouseId > 0) {
            com.quanlymayphatdien.g1.entity.Warehouse scoped = warehouseDAO.findById(scopedWarehouseId);
            request.setAttribute("warehouses", scoped != null ? java.util.Collections.singletonList(scoped) : java.util.Collections.emptyList());
            request.setAttribute("scopedWarehouseId", scopedWarehouseId);
            if (scoped != null) {
                request.setAttribute("scopedWarehouseName", scoped.getName());
            }
        } else {
            request.setAttribute("warehouses", warehouseDAO.findAll());
        }
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
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        if (scopedWarehouseId > 0 && receipt.getWarehouseId() != scopedWarehouseId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
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
        HttpSession session = request.getSession(false);
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        int whId = parseId(request.getParameter("warehouseId"));
        if (scopedWarehouseId > 0) {
            if (whId > 0 && whId != scopedWarehouseId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            whId = scopedWarehouseId;
        }
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
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);

        Integer poId = parsePoIdFromRequest(request);
        boolean fromPo = poId != null;
        if (fromPo && !isPoValid(request, poId)) {
            errorsForPo(request, "Phiếu mua không hợp lệ hoặc chưa được duyệt");
            renderCreateWithError(request, response);
            return;
        }

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();

        if (warehouseId <= 0) errors.add("Vui lòng chọn kho");
        if (scopedWarehouseId > 0 && warehouseId > 0 && warehouseId != scopedWarehouseId) {
            errors.add("Bạn chỉ được phép tạo phiếu nhập cho kho của mình");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { errors.add("Lý do không hợp lệ"); }
        } else errors.add("Vui lòng chọn lý do");

        String[] genIds = request.getParameterValues("manualGeneratorId");
        String[] serials = request.getParameterValues("manualSerialNumber");
        String[] detailNotes = request.getParameterValues("manualDetailNote");

        List<ReceiptDetail> details;
        if (fromPo) {
            details = parseDetailsStrict(genIds, serials, detailNotes, errors);
            validateAgainstPurchaseOrder(poId, details, errors);
            if (details.isEmpty()) {
                errors.add("Phiếu nhập từ PO phải có ít nhất 1 dòng serial hợp lệ");
            }
        } else {
            details = parseDetailsStrict(genIds, serials, detailNotes, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Lưu phiếu thất bại:", errors));
            request.setAttribute("errors", errors);

            request.setAttribute("preservedWarehouseId", warehouseId);
            request.setAttribute("preservedReasonId", reasonId);
            request.setAttribute("preservedNote", note);

            String[] manualGenIds = request.getParameterValues("manualGeneratorId");
            String[] manualSerials = request.getParameterValues("manualSerialNumber");
            String[] manualNotes = request.getParameterValues("manualDetailNote");
            if (manualGenIds != null && manualGenIds.length > 0) {
                List<Map<String, String>> manualRows = new ArrayList<>();
                for (int i = 0; i < manualGenIds.length; i++) {
                    String gid = manualGenIds[i] != null ? manualGenIds[i] : "";
                    String sn = (manualSerials != null && i < manualSerials.length) ? manualSerials[i] : "";
                    String nt = (manualNotes != null && i < manualNotes.length) ? manualNotes[i] : "";
                    if (gid.isEmpty() && sn.isEmpty() && nt.isEmpty()) continue;
                    Map<String, String> r = new LinkedHashMap<>();
                    r.put("generatorId", gid);
                    r.put("serialNumber", sn);
                    r.put("detailNote", nt);
                    manualRows.add(r);
                }
                if (!manualRows.isEmpty()) {
                    request.setAttribute("preservedManualRows", manualRows);
                }
            }

            Integer poIdErr = parsePoIdFromRequest(request);
            if (poIdErr != null) {
                PurchaseOrder poErr = new PurchaseOrderDAO().findById(poIdErr);
                if (poErr != null && "APPROVED".equalsIgnoreCase(poErr.getStatus())) {
                    applyPoPrefillToRequest(request, poErr, "Tạo từ phiếu purchase " + poErr.getPoCode());
                }
            }

            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("activePage", "import-create");

            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        for (ReceiptDetail d : details) {
            if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                if (inventoryDAO.isSerialBlocked(d.getSerialNumber())) {
                    errors.add("Serial \"" + d.getSerialNumber() + "\" đã tồn tại và đang được sử dụng trong hệ thống");
                }
            }
        }
        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Lưu phiếu thất bại:", errors));
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
                r.setPurchaseOrderId(Integer.parseInt(pid));
            } catch (NumberFormatException ignored) {}
        }
        r.setStatus(GlobalUtils.RECEIPT_STATUS_COMPLETED);
        r.setApprovedBy(loggedUser.getId());
        r.setApprovedAt(java.time.LocalDateTime.now());

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
                int invId = inventoryDAO.insertInStock(conn, d.getGeneratorId(), d.getSerialNumber(), warehouseId);
                if (invId <= 0) {
                    throw new SQLException("Không thể tạo serial '" + d.getSerialNumber() + "'");
                }
                d.setReceiptId(receiptId);
                d.setInventoryId(invId);
            }
            detailDAO.batchInsert(conn, details);
            receiptDAO.writeStockCardsForImport(conn, receiptId, r.getReceiptCode(),
                    warehouseId, loggedUser.getId(), details);
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
        log.setDetails("Tạo phiếu nhập kho và cập nhật tồn kho");
        activityLogDAO.insert(log);

        if (r.getPurchaseOrderId() != null) {
            new PurchaseOrderDAO().markCompleted(r.getPurchaseOrderId());
        }

        session.setAttribute("toastMessage", "Thêm phiếu thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
    }

    private void updateReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int receiptId = parseId(request.getParameter("receiptId"));
        if (receiptId <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/import-receipt");
            return;
        }
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(existing.getStatus());
        if (existing.getCreatedBy() != loggedUser.getId() || !isRevision) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();
        if (warehouseId <= 0) errors.add("Vui lòng chọn kho");
        if (scopedWarehouseId > 0 && warehouseId > 0 && warehouseId != scopedWarehouseId) {
            errors.add("Bạn chỉ được phép cập nhật phiếu nhập cho kho của mình");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { errors.add("Lý do không hợp lệ"); }
        } else errors.add("Vui lòng chọn lý do");

        String[] genIds = request.getParameterValues("manualGeneratorId");
        String[] serials = request.getParameterValues("manualSerialNumber");
        String[] detailNotes = request.getParameterValues("manualDetailNote");

        List<ReceiptDetail> details = parseDetailsStrict(genIds, serials, detailNotes, errors);
        if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
            errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Cập nhật phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("activePage", "import-edit");
            request.setAttribute("isDraft", false);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
            return;
        }

        for (ReceiptDetail d : details) {
            if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                if (inventoryDAO.isSerialBlocked(d.getSerialNumber())) {
                    errors.add("Serial \"" + d.getSerialNumber() + "\" đã tồn tại và đang được sử dụng trong hệ thống");
                }
            }
        }
        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Cập nhật phiếu thất bại:", errors));
            request.setAttribute("activePage", "import-edit");
            request.setAttribute("isDraft", false);
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
            request.setAttribute("isDraft", false);
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
        boolean ok = receiptDAO.updateReceipt(r, details, loggedUser.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction("UPDATE");
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails("Cập nhật phiếu nhập kho");
            activityLogDAO.insert(log);
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
            session.setAttribute("toastMessage", "Cập nhật phiếu thành công, đã gửi lại để duyệt");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
        } else {
            request.setAttribute("toastMessage", "Không thể cập nhật phiếu");
            request.setAttribute("toastType", "danger");
            request.setAttribute("isDraft", false);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
        }
    }

    private void downloadTemplate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String poIdStr = request.getParameter("poId");
        List<PurchaseOrderDetail> poDetails = null;
        if (poIdStr != null && !poIdStr.isEmpty()) {
            int poId = parseId(poIdStr);
            if (poId > 0) {
                PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
                if (po != null && "APPROVED".equalsIgnoreCase(po.getStatus())) {
                    poDetails = po.getDetails();
                }
            }
        }
        XSSFWorkbook workbook = ReceiptExcelSupport.createTemplateWorkbook(poDetails);
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
            forwardBackToCreate(request, response, "Không đọc được file upload: " + e.getMessage(), "danger",
                    warehouseId, reasonId, note);
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            forwardBackToCreate(request, response, "Vui lòng chọn file Excel để nhập", "danger",
                    warehouseId, reasonId, note);
            return;
        }

        List<Map<String, String>> rawRows;
        try (InputStream is = filePart.getInputStream()) {
            rawRows = ReceiptExcelSupport.parseFromExcel(is);
        } catch (Exception e) {
            forwardBackToCreate(request, response, "File Excel không hợp lệ: " + e.getMessage(), "danger",
                    warehouseId, reasonId, note);
            return;
        }

        Integer poId = parsePoIdFromRequest(request);
        if (poId != null) {
            PurchaseOrder po = new PurchaseOrderDAO().findById(poId);
            if (po == null || !"APPROVED".equalsIgnoreCase(po.getStatus())) {
                forwardBackToCreate(request, response, "Phiếu mua không hợp lệ hoặc chưa được duyệt", "danger",
                        warehouseId, reasonId, note);
                return;
            }
            if (po.getWarehouseId() != warehouseId) {
                forwardBackToCreate(request, response,
                        "Kho trong file Excel khác với kho của PO (PO yêu cầu kho "
                                + po.getWarehouseId() + ")", "danger",
                        warehouseId, reasonId, note);
                return;
            }
            handleImportPreviewForPo(request, response, po, rawRows, warehouseId, reasonId, note);
            return;
        }

        if (rawRows.isEmpty()) {
            forwardBackToCreate(request, response,
                    "File Excel trống hoặc không đúng định dạng. Hãy dùng file mẫu (Tải mẫu Excel) với 3 cột: "
                            + ReceiptExcelSupport.COL_MODEL + " | " + ReceiptExcelSupport.COL_SERIAL + " | " + ReceiptExcelSupport.COL_NOTE,
                    "danger", warehouseId, reasonId, note);
            return;
        }

        Map<String, String> firstRow = rawRows.get(0);
        boolean hasModelKey = firstRow.containsKey(ReceiptExcelSupport.COL_MODEL);
        boolean hasSerialKey = firstRow.containsKey(ReceiptExcelSupport.COL_SERIAL);
        if (!hasModelKey || !hasSerialKey) {
            forwardBackToCreate(request, response,
                    "File Excel thiếu cột bắt buộc. Cần có 2 cột: \""
                            + ReceiptExcelSupport.COL_MODEL + "\" và \"" + ReceiptExcelSupport.COL_SERIAL + "\". "
                            + "Có thể dùng tên thay thế: Model/Generator cho mã máy, Serial/SN cho số serial. "
                            + "Hãy tải file mẫu và copy dữ liệu vào.",
                    "danger", warehouseId, reasonId, note);
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
            String detailNote = raw.getOrDefault(ReceiptExcelSupport.COL_NOTE, "").trim();

            Map<String, Object> row = new LinkedHashMap<>();
            row.put("rowNum", rowNum);
            row.put("model", model);
            row.put("serial", serial);
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

            if (detailNote.length() > MAX_NOTE_LENGTH) {
                errors.add("Ghi chú vượt quá " + MAX_NOTE_LENGTH + " ký tự");
            }

            if (!serial.isEmpty() && !seenSerials.add(serial)) {
                errors.add("Serial \"" + serial + "\" bị trùng trong file");
            }

            if (!serial.isEmpty() && inventoryDAO.isSerialBlocked(serial)) {
                errors.add("Serial \"" + serial + "\" đã tồn tại trong hệ thống");
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

        if (!isAjaxRequest(request)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", false);
            body.put("message", "API importPreview chi ho tro AJAX");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        if (validRows.isEmpty() && !invalidRows.isEmpty()) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", false);
            List<String> errorMessages = new ArrayList<>();
            for (Map<String, Object> inv : invalidRows) {
                Object e = inv.get("_errors");
                if (e != null) errorMessages.add("Dòng " + inv.get("rowNum") + ": " + e);
            }
            body.put("message", "File Excel không có dòng hợp lệ nào. "
                    + String.join("; ", errorMessages));
            new Gson().toJson(body, response.getWriter());
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("message", "Đã đọc " + validRows.size() + " dòng từ Excel"
                + (invalidRows.isEmpty() ? "" : " (bỏ qua " + invalidRows.size() + " dòng lỗi)"));
        List<String> serials = new ArrayList<>();
        List<Integer> generatorIds = new ArrayList<>();
        for (Map<String, Object> v : validRows) {
            serials.add((String) v.get("serial"));
            generatorIds.add((Integer) v.get("generatorId"));
        }
        body.put("serials", serials);
        body.put("generatorIds", generatorIds);
        new Gson().toJson(body, response.getWriter());
    }

    /**
     * Forward lai trang import-create.jsp voi toast message, dong thoi bao toan
     * form data (warehouseId, reasonId, note, manual rows) de user khong bi mat du lieu.
     */
    private void forwardBackToCreate(HttpServletRequest request, HttpServletResponse response,
            String toastMessage, String toastType,
            int warehouseId, Integer reasonId, String note)
            throws ServletException, IOException {
        if (isAjaxRequest(request)) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", false);
            body.put("message", toastMessage);
            new Gson().toJson(body, response.getWriter());
            return;
        }
        request.setAttribute("toastType", toastType);
        request.setAttribute("toastMessage", toastMessage);
        preserveFormStateForInlinePreview(request, warehouseId, reasonId, note);
        request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
    }

    /**
     * Luu form state (warehouse, reason, note, manual rows) vao request attribute
     * de JSP co the re-populate form khi forward ve.
     */
    private void preserveFormStateForInlinePreview(HttpServletRequest request,
            int warehouseId, Integer reasonId, String note) {
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-create");

        request.setAttribute("preservedWarehouseId", warehouseId);
        request.setAttribute("preservedReasonId", reasonId);
        request.setAttribute("preservedNote", note);

        String[] manualGenIds = request.getParameterValues("manualGeneratorId");
        String[] manualSerials = request.getParameterValues("manualSerialNumber");
        String[] manualNotes = request.getParameterValues("manualDetailNote");
        if (manualGenIds != null && manualGenIds.length > 0) {
            List<Map<String, String>> manualRows = new ArrayList<>();
            for (int i = 0; i < manualGenIds.length; i++) {
                String gid = manualGenIds[i] != null ? manualGenIds[i] : "";
                String sn = (manualSerials != null && i < manualSerials.length) ? manualSerials[i] : "";
                String nt = (manualNotes != null && i < manualNotes.length) ? manualNotes[i] : "";
                if (gid.isEmpty() && sn.isEmpty() && nt.isEmpty()) {
                    continue;
                }
                Map<String, String> r = new LinkedHashMap<>();
                r.put("generatorId", gid);
                r.put("serialNumber", sn);
                r.put("detailNote", nt);
                manualRows.add(r);
            }
            if (!manualRows.isEmpty()) {
                request.setAttribute("preservedManualRows", manualRows);
            }
        }

        String poIdStr = request.getParameter("poId");
        if (poIdStr != null && !poIdStr.isEmpty()) {
            request.setAttribute("preservedPoId", poIdStr);
        }
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

        String[] manualGenIds = request.getParameterValues("manualGeneratorId");
        String[] manualSerials = request.getParameterValues("manualSerialNumber");
        String[] manualDetailNotes = request.getParameterValues("manualDetailNote");

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

        if (manualGenIds != null) {
            for (int i = 0; i < manualGenIds.length; i++) {
                String idStr = manualGenIds[i];
                String serial = (manualSerials != null && i < manualSerials.length) ? manualSerials[i] : null;
                String detailNote = (manualDetailNotes != null && i < manualDetailNotes.length) ? manualDetailNotes[i] : null;

                int genId = 0;
                try {
                    genId = Integer.parseInt(idStr);
                } catch (NumberFormatException e) {
                    continue;
                }
                if (genId <= 0) {
                    continue;
                }
                if (serial == null || serial.trim().isEmpty()) {
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
            }
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

        for (ReceiptDetail d : details) {
            if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                if (inventoryDAO.isSerialBlocked(d.getSerialNumber())) {
                    errors.add("Serial \"" + d.getSerialNumber() + "\" đã tồn tại và đang được sử dụng trong hệ thống");
                }
            }
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

        Receipt r = new Receipt();
        r.setReceiptCode(receiptDAO.generateReceiptCode(TYPE));
        r.setReceiptType(TYPE);
        r.setWarehouseId(warehouseId);
        r.setCreatedBy(loggedUser.getId());
        r.setNote(note);
        r.setReasonId(reasonId);
        r.setStatus(GlobalUtils.RECEIPT_STATUS_COMPLETED);
        r.setApprovedBy(loggedUser.getId());
        r.setApprovedAt(java.time.LocalDateTime.now());

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
                int invId = inventoryDAO.insertInStock(conn, d.getGeneratorId(), d.getSerialNumber(), warehouseId);
                if (invId <= 0) {
                    throw new SQLException("Không thể tạo serial '" + d.getSerialNumber() + "'");
                }
                d.setReceiptId(receiptId);
                d.setInventoryId(invId);
            }
            detailDAO.batchInsert(conn, details);
            receiptDAO.writeStockCardsForImport(conn, receiptId, r.getReceiptCode(),
                    warehouseId, loggedUser.getId(), details);
            conn.commit();
            ok = true;
        } catch (java.sql.SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (java.sql.SQLException e) { e.printStackTrace(); }
            }
            errors.add("Lỗi hệ thống khi lưu phiếu: " + ex.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (java.sql.SQLException e) {
                    e.printStackTrace();
                }
                try {
                    conn.close();
                } catch (java.sql.SQLException e) {
                    e.printStackTrace();
                }
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
        log.setDetails("Nhập " + importedFromFile + " dòng từ Excel → tạo phiếu nhập kho và cập nhật tồn kho");
        activityLogDAO.insert(log);

        session.setAttribute("toastMessage", "Đã nhập " + importedFromFile + " dòng từ Excel");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
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
}
