/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.OrderDetailDAO;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.OrderDetail;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.SaleOrderDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author FPTShop
 */
@WebServlet(name = "ReceiptController", urlPatterns = {"/receipt"})
public class ReceiptController extends HttpServlet {

    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final ReceiptDetailDAO detailDAO = new ReceiptDetailDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    private static final int MAX_QUANTITY = 100000;
    private static final int MAX_SERIAL_LENGTH = 100;
    private static final int MAX_NOTE_LENGTH = 500;
    private static final int MAX_REASON_LENGTH = 500;

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
                    viewReceiptList(request, response);
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
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "ReceiptController.doGet", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
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
            SystemLogger.error("Quản lý kho", "ReceiptController.doPost", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private void viewReceiptList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        Integer createdByFilter = null;
        Integer currentUserId = loggedUser != null ? loggedUser.getId() : null;
        if (loggedUser != null && (perms == null || !perms.contains("receipts.approve"))) {
            createdByFilter = loggedUser.getId();
        }

        String typeFilter = request.getParameter("type");
        String statusFilter = request.getParameter("status");
        String whFilter = request.getParameter("warehouse");
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                SystemLogger.warn("Quản lý kho", "ReceiptController.viewReceiptList", "Lỗi định dạng trang: " + e.getMessage());
                page = 1;
            }
        }
        int totalItems = receiptDAO.countWithFilters(typeFilter, statusFilter, whFilter, search, createdByFilter, currentUserId);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        List<Receipt> receiptList = receiptDAO.findWithFilters(
                typeFilter, statusFilter, whFilter, search, createdByFilter, page, pageSize, currentUserId);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);
        request.setAttribute("receiptList", receiptList);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("whFilter", whFilter);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.getRequestDispatcher("/view/receipt/receipt-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("warehouses", warehouseDAO.findAll());

        GeneratorDAO genDAO = new GeneratorDAO();
        List<Generator> generators = genDAO.findAll();
        Map<Integer, String> brandMap = new LinkedHashMap<>();
        for (Generator g : generators) {
            List<Category> cats = genDAO.getCategoriesByGeneratorId(g.getId());
            g.setCategories(cats);
            String brand = "";
            for (Category c : cats) {
                if ("brand".equals(c.getType())) {
                    brand = c.getName();
                    break;
                }
            }
            brandMap.put(g.getId(), brand);
        }
        request.setAttribute("generators", generators);
        request.setAttribute("brandMap", brandMap);

        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("receiptReasons", catDAO.findByType("receipt_reason"));

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            int orderId = Integer.parseInt(orderIdStr);
            SaleOrder order = new SaleOrderDAO().findById(orderId);
            if (order != null && "APPROVED".equalsIgnoreCase(order.getStatus())) {
                List<OrderDetail> ods = new OrderDetailDAO().findByOrderId(orderId);
                Receipt prefill = new Receipt();
                prefill.setOrderId(orderId);
                prefill.setReceiptType("EXPORT");
                prefill.setNote("Tạo từ đơn " + order.getOrderCode());
                List<ReceiptDetail> ds = new ArrayList<>();
                for (OrderDetail od : ods) {
                    ReceiptDetail rd = new ReceiptDetail();
                    rd.setGeneratorId(od.getGeneratorId());
                    rd.setQuantity(od.getQuantity());
                    rd.setNote(od.getNote());
                    ds.add(rd);
                }
                prefill.setDetails(ds);
                request.setAttribute("receipt", prefill);
                request.setAttribute("order", order);
            }
        }
        request.getRequestDispatcher("/view/receipt/receipt-create.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        int id = Integer.parseInt(idStr);
        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null) {
            request.setAttribute("error", "Không tìm thấy phiếu");
            request.getRequestDispatcher("/view/receipt/receipt-detail.jsp").forward(request, response);
            return;
        }
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean isManager = perms != null && perms.contains("receipts.approve");
        boolean isOwner = receipt.getCreatedBy() == loggedUser.getId();
        List<ActivityLog> receiptHistory = activityLogDAO.findByEntityTypeAndId("receipt", id, 1, 100);
        int totalHistory = activityLogDAO.countByEntityTypeAndId("receipt", id);
        request.setAttribute("receipt", receipt);
        request.setAttribute("isManager", isManager);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("receiptHistory", receiptHistory);
        request.setAttribute("totalHistory", totalHistory);
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.getRequestDispatcher("/view/receipt/receipt-detail.jsp").forward(request, response);
    }

    private void saveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        boolean isDraft = "draft".equals(request.getParameter("submitMode"));

        String receiptType = request.getParameter("receiptType");
        String whIdStr = request.getParameter("warehouseId");
        String note = request.getParameter("note");
        int warehouseId = 0;
        List<String> errors = new ArrayList<>();

        if (receiptType == null || receiptType.trim().isEmpty()) {
            if (!isDraft) {
                errors.add("Vui lòng chọn loại phiếu");
            }
        } else if (!"IMPORT".equals(receiptType) && !"EXPORT".equals(receiptType)) {
            if (!isDraft) {
                errors.add("Loại phiếu không hợp lệ");
            }
        }
        try {
            warehouseId = Integer.parseInt(whIdStr);
            if (warehouseId <= 0 && !isDraft) {
                errors.add("Vui lòng chọn kho");
            }
        } catch (NumberFormatException e) {
            if (!isDraft) {
                errors.add("Kho không hợp lệ");
            }
        }

        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }
        Integer reasonId = null;
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
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isDraft) {
            details = parseAndValidateDetailsLenient(
                    genIds, serials, quantities, unitPrices, detailNotes);
        } else {
            details = parseAndValidateDetails(
                    genIds, serials, quantities, unitPrices, detailNotes, receiptType, warehouseId, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            StringBuilder msg = new StringBuilder(isDraft ? "Lưu nháp thất bại:" : "Lưu phiếu thất bại:");
            for (String e : errors) {
                msg.append(" ").append(e.replace("Dòng ", "dòng "));
            }
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", msg.toString());
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            GeneratorDAO genDAO = new GeneratorDAO();
            request.setAttribute("generators", genDAO.findAll());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/receipt-create.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        if (receiptType != null && (receiptType.equals("IMPORT") || receiptType.equals("EXPORT"))) {
            r.setReceiptCode(receiptDAO.generateReceiptCode(receiptType));
        } else {
            r.setReceiptCode(receiptDAO.generateReceiptCode("IMPORT"));
        }
        r.setReceiptType(receiptType);
        r.setWarehouseId(warehouseId);
        r.setCreatedBy(loggedUser.getId());
        r.setNote(note);
        r.setReasonId(reasonId);
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        for (ReceiptDetail d : details) {
            if (d.getUnitPrice() != null) {
                total = total.add(d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getQuantity())));
            }
        }
        r.setTotalAmount(total);
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
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", new ArrayList<>());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/receipt-create.jsp").forward(request, response);
            return;
        }

        for (ReceiptDetail d : details) {
            d.setReceiptId(receiptId);
            detailDAO.insert(d);
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        log.setAction("CREATE");
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails(isDraft
                ? "Lưu nháp phiếu " + ("IMPORT".equals(r.getReceiptType()) ? "nhập" : "xuất") + " kho"
                : "Tạo phiếu " + ("IMPORT".equals(r.getReceiptType()) ? "nhập" : "xuất") + " kho");
        activityLogDAO.insert(log);

        if (isDraft) {
            session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/receipt?action=edit&id=" + receiptId);
        } else {
            session.setAttribute("toastMessage", "Thêm phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/receipt?action=list");
        }
    }

    private List<ReceiptDetail> parseAndValidateDetails(String[] genIds, String[] serials,
            String[] quantities, String[] unitPrices, String[] detailNotes,
            String receiptType, int warehouseId, List<String> errors) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) {
            return details;
        }
        boolean isExport = "EXPORT".equals(receiptType);
        java.util.Set<String> seenSerials = new java.util.HashSet<>();

        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
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

            int qty = 1;
            if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                try {
                    qty = Integer.parseInt(qtyStr.trim());
                } catch (NumberFormatException e) {
                    errors.add("Dòng " + rowNum + ": Số lượng không hợp lệ");
                    continue;
                }
            }
            if (qty <= 0) {
                errors.add("Dòng " + rowNum + ": Số lượng phải lớn hơn 0");
                continue;
            }
            if (qty > MAX_QUANTITY) {
                errors.add("Dòng " + rowNum + ": Số lượng không được vượt quá " + MAX_QUANTITY);
                continue;
            }

            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) {
                    serial = null;
                } else if (serial.length() > MAX_SERIAL_LENGTH) {
                    errors.add("Dòng " + rowNum + ": Số serial không được vượt quá "
                            + MAX_SERIAL_LENGTH + " ký tự");
                    continue;
                } else {
                    String key = genId + "|" + serial;
                    if (!seenSerials.add(key)) {
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

            if (isExport && warehouseId > 0) {
                Inventory inv = inventoryDAO.findByWarehouseAndGenerator(warehouseId, genId);
                int onHand = inv != null ? inv.getQuantity() : 0;
                if (onHand < qty) {
                    errors.add("Dòng " + rowNum + ": Kho chỉ còn " + onHand + " máy, không đủ " + qty);
                    continue;
                }
            }

            java.math.BigDecimal price = null;
            String priceStr = (unitPrices != null && i < unitPrices.length) ? unitPrices[i] : null;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    price = new java.math.BigDecimal(priceStr.trim().replace(",", ""));
                } catch (NumberFormatException e) {
                    errors.add("Dòng " + rowNum + ": Đơn giá không hợp lệ");
                    continue;
                }
            }

            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId);
            d.setSerialNumber(serial);
            d.setQuantity(qty);
            d.setUnitPrice(price);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private List<ReceiptDetail> parseAndValidateDetailsLenient(String[] genIds, String[] serials,
            String[] quantities, String[] unitPrices, String[] detailNotes) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) {
            return details;
        }
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
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

            int qty = 1;
            if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                try {
                    qty = Integer.parseInt(qtyStr.trim());
                } catch (NumberFormatException e) {
                    qty = 1;
                }
            }
            if (qty <= 0) {
                qty = 1;
            } else if (qty > MAX_QUANTITY) {
                qty = MAX_QUANTITY;
            }

            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) {
                    serial = null;
                } else if (serial.length() > MAX_SERIAL_LENGTH) {
                    serial = serial.substring(0, MAX_SERIAL_LENGTH);
                }
            }

            java.math.BigDecimal price = null;
            String priceStr = (unitPrices != null && i < unitPrices.length) ? unitPrices[i] : null;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    price = new java.math.BigDecimal(priceStr.trim().replace(",", ""));
                } catch (NumberFormatException e) {
                    price = null;
                }
            }

            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) {
                detailNote = detailNote.substring(0, MAX_NOTE_LENGTH);
            }

            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId);
            d.setSerialNumber(serial);
            d.setQuantity(qty);
            d.setUnitPrice(price);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private void approveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("receipts.approve")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        boolean ok = receiptDAO.approveReceipt(id, loggedUser.getId());

        if (ok) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("APPROVE");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                log.setDetails("Duyệt phiếu " + ("IMPORT".equals(r.getReceiptType()) ? "nhập" : "xuất") + " kho, cập nhật tồn kho");
                activityLogDAO.insert(log);
            }
            session.setAttribute("toastMessage", "Duyệt phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể duyệt phiếu (phiếu không ở trạng thái chờ duyệt)");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private void rejectReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("receipts.approve")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("toastMessage", "Lý do không hợp lệ");
                request.setAttribute("toastType", "danger");
                request.setAttribute("openRejectModal", "true");
                viewDetail(request, response);
                return;
            }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) {
                reasonNote = null;
            } else if (reasonNote.length() > MAX_REASON_LENGTH) {
                request.setAttribute("toastMessage", "Lý do từ chối không được vượt quá " + MAX_REASON_LENGTH + " ký tự");
                request.setAttribute("toastType", "danger");
                request.setAttribute("openRejectModal", "true");
                viewDetail(request, response);
                return;
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
                if (reasonNote != null) detail += ": " + reasonNote;
                log.setDetails(detail);
                activityLogDAO.insert(log);
            }
            session.setAttribute("toastMessage", "Đã từ chối phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể từ chối phiếu (phiếu không ở trạng thái chờ duyệt)");
            request.setAttribute("toastType", "danger");
            request.setAttribute("openRejectModal", "true");
            viewDetail(request, response);
        }
    }

    private void selectOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                SystemLogger.warn("Quản lý kho", "ReceiptController.selectOrder", "Lỗi định dạng trang: " + e.getMessage());
                page = 1;
            }
        }
        SaleOrderDAO soDAO = new SaleOrderDAO();
        int totalItems = soDAO.countApprovedAvailableFiltered(search, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
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
        request.getRequestDispatcher("/view/receipt/receipt-select-order.jsp").forward(request, response);
    }

    private void requestRevision(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("receipts.approve")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("toastMessage", "Lý do không hợp lệ");
                request.setAttribute("toastType", "danger");
                request.setAttribute("openRevisionModal", "true");
                viewDetail(request, response);
                return;
            }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) {
                reasonNote = null;
            } else if (reasonNote.length() > MAX_REASON_LENGTH) {
                request.setAttribute("toastMessage", "Lý do yêu cầu chỉnh sửa không được vượt quá " + MAX_REASON_LENGTH + " ký tự");
                request.setAttribute("toastType", "danger");
                request.setAttribute("openRevisionModal", "true");
                viewDetail(request, response);
                return;
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
                if (reasonNote != null) detail += ": " + reasonNote;
                log.setDetails(detail);
                activityLogDAO.insert(log);
            }
            session.setAttribute("toastMessage", "Đã gửi yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa (phiếu không ở trạng thái chờ duyệt)");
            request.setAttribute("toastType", "danger");
            request.setAttribute("openRevisionModal", "true");
            viewDetail(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        int id = Integer.parseInt(idStr);
        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null || receipt.getCreatedBy() != loggedUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(receipt.getStatus());
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(receipt.getStatus());
        if (!isRevision && !isDraft) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        request.setAttribute("isDraft", isDraft);

        request.setAttribute("receipt", receipt);
        request.setAttribute("warehouses", warehouseDAO.findAll());

        GeneratorDAO genDAO = new GeneratorDAO();
        List<Generator> generators = genDAO.findAll();
        Map<Integer, String> brandMap = new LinkedHashMap<>();
        for (Generator g : generators) {
            List<Category> cats = genDAO.getCategoriesByGeneratorId(g.getId());
            g.setCategories(cats);
            String brand = "";
            for (Category c : cats) {
                if ("brand".equals(c.getType())) {
                    brand = c.getName();
                    break;
                }
            }
            brandMap.put(g.getId(), brand);
        }
        request.setAttribute("generators", generators);
        request.setAttribute("brandMap", brandMap);
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));

        request.getRequestDispatcher("/view/receipt/receipt-edit.jsp").forward(request, response);
    }

    private void updateReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        int receiptId;
        try {
            receiptId = Integer.parseInt(request.getParameter("receiptId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }

        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existing.getStatus());
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(existing.getStatus());
        if (existing.getCreatedBy() != loggedUser.getId() || (!isDraft && !isRevision)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        boolean isSaveDraft = "draft".equals(request.getParameter("submitMode"));

        String whIdStr = request.getParameter("warehouseId");
        String note = request.getParameter("note");
        int warehouseId = 0;
        List<String> errors = new ArrayList<>();

        try {
            warehouseId = Integer.parseInt(whIdStr);
            if (warehouseId <= 0 && !isSaveDraft) {
                errors.add("Vui lòng chọn kho");
            }
        } catch (NumberFormatException e) {
            if (!isSaveDraft) {
                errors.add("Kho không hợp lệ");
            }
        }

        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        Integer reasonId = null;
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
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isSaveDraft) {
            details = parseAndValidateDetailsLenient(
                    genIds, serials, quantities, unitPrices, detailNotes);
        } else {
            details = parseAndValidateDetails(
                    genIds, serials, quantities, unitPrices, detailNotes,
                    existing.getReceiptType(), warehouseId, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            StringBuilder msg = new StringBuilder(isSaveDraft ? "Lưu nháp thất bại:" : "Cập nhật phiếu thất bại:");
            for (String e : errors) {
                msg.append(" ").append(e.replace("Dòng ", "dòng "));
            }
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", msg.toString());
            request.setAttribute("errors", errors);
            showEditForm(request, response);
            return;
        }

        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        for (ReceiptDetail d : details) {
            if (d.getUnitPrice() != null) {
                total = total.add(d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getQuantity())));
            }
        }

        Receipt r = new Receipt();
        r.setReceiptId(receiptId);
        r.setWarehouseId(warehouseId);
        r.setNote(note);
        r.setReasonId(reasonId);
        r.setTotalAmount(total);

        boolean ok;
        String logAction;
        String logDetails;
        String newStatus;
        if (isSaveDraft) {
            newStatus = GlobalUtils.RECEIPT_STATUS_DRAFT;
        } else if (isDraft) {
            newStatus = GlobalUtils.RECEIPT_STATUS_PENDING;
        } else {
            newStatus = GlobalUtils.RECEIPT_STATUS_PENDING;
        }

        if (isSaveDraft) {
            ok = receiptDAO.updateDraftReceipt(r, details, loggedUser.getId(), newStatus);
            logAction = isRevision ? "DRAFT_UPDATE" : "DRAFT_UPDATE";
            logDetails = isRevision
                    ? "Lưu nháp phiếu đang yêu cầu chỉnh sửa"
                    : "Lưu nháp phiếu";
        } else {
            if (isDraft) {
                ok = receiptDAO.updateDraftReceipt(r, details, loggedUser.getId(), newStatus);
                logAction = "SUBMIT_DRAFT";
                logDetails = "Gửi phiếu nháp để duyệt";
            } else {
                ok = receiptDAO.updateReceipt(r, details, loggedUser.getId());
                logAction = "UPDATE";
                StringBuilder changeDetail = new StringBuilder("Cập nhật phiếu");
                if (existing.getWarehouseId() != warehouseId) {
                    changeDetail.append(", đổi kho");
                }
                List<ReceiptDetail> oldDetails = existing.getDetails();
                int compareLen = Math.min(oldDetails != null ? oldDetails.size() : 0, details.size());
                for (int i = 0; i < compareLen; i++) {
                    ReceiptDetail od = oldDetails.get(i);
                    ReceiptDetail nd = details.get(i);
                    if (od.getQuantity() != nd.getQuantity()) {
                        changeDetail.append(", dòng ").append(i + 1).append(": SL ").append(od.getQuantity()).append("→").append(nd.getQuantity());
                    }
                    if (nd.getUnitPrice() != null && od.getUnitPrice() != null
                            && nd.getUnitPrice().compareTo(od.getUnitPrice()) != 0) {
                        changeDetail.append(", dòng ").append(i + 1).append(": ĐG ").append(od.getUnitPrice()).append("→").append(nd.getUnitPrice());
                    }
                }
                logDetails = changeDetail.toString();
            }
        }
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction(logAction);
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails(logDetails);
            activityLogDAO.insert(log);
            if (isSaveDraft) {
                session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/receipt?action=edit&id=" + receiptId);
            } else {
                session.setAttribute("toastMessage", "Cập nhật phiếu thành công, đã gửi lại để duyệt");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/receipt?action=list");
            }
        } else {
            request.setAttribute("toastMessage", "Không thể cập nhật phiếu (phiếu không ở trạng thái cho phép)");
            request.setAttribute("toastType", "danger");
            showEditForm(request, response);
        }
    }}
