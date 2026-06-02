/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.OrderDetailDAO;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.OrderDetail;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.SaleOrderDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.Role;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.entity.User;
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
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
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
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
    }

    private void viewReceiptList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        int totalItems = receiptDAO.countWithFilters(typeFilter, statusFilter, whFilter, search);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        List<Receipt> receiptList = receiptDAO.findWithFilters(
                typeFilter, statusFilter, whFilter, search, page, pageSize);
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
        boolean isManager = false;
        if (loggedUser.getRoles() != null) {
            for (Role role : loggedUser.getRoles()) {
                if ("warehouse_manager".equals(role.getRoleName())) {
                    isManager = true;
                    break;
                }
            }
        }
        request.setAttribute("receipt", receipt);
        request.setAttribute("isManager", isManager);
        request.getRequestDispatcher("/view/receipt/receipt-detail.jsp").forward(request, response);
    }

    private void saveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        String receiptType = request.getParameter("receiptType");
        String whIdStr = request.getParameter("warehouseId");
        String note = request.getParameter("note");
        int warehouseId = 0;
        List<String> errors = new ArrayList<>();

        if (receiptType == null || receiptType.trim().isEmpty()) {
            errors.add("Vui lòng chọn loại phiếu");
        } else if (!"IMPORT".equals(receiptType) && !"EXPORT".equals(receiptType)) {
            errors.add("Loại phiếu không hợp lệ");
        }
        try {
            warehouseId = Integer.parseInt(whIdStr);
            if (warehouseId <= 0) {
                errors.add("Vui lòng chọn kho");
            }
        } catch (NumberFormatException e) {
            errors.add("Kho không hợp lệ");
        }

        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details = parseAndValidateDetails(
                genIds, serials, detailNotes, receiptType, warehouseId, errors);

        if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
            errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
        }

        if (!errors.isEmpty()) {
            Receipt form = new Receipt();
            form.setReceiptType(receiptType);
            form.setWarehouseId(warehouseId);
            form.setNote(note);
            form.setDetails(details);
            request.setAttribute("receipt", form);
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            GeneratorDAO genDAO = new GeneratorDAO();
            request.setAttribute("generators", genDAO.findAll());
            request.getRequestDispatcher("/view/receipt/receipt-create.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptCode(receiptDAO.generateReceiptCode(receiptType));
        r.setReceiptType(receiptType);
        r.setWarehouseId(warehouseId);
        r.setCreatedBy(loggedUser.getId());
        r.setNote(note);
        String oid = request.getParameter("orderId");
        if (oid != null && !oid.isEmpty()) {
            try {
                r.setOrderId(Integer.parseInt(oid));
            } catch (NumberFormatException ignored) {
            }
        }
        int receiptId = receiptDAO.insert(r);
        if (receiptId <= 0) {
            errors.add("Không thể tạo phiếu, vui lòng thử lại");
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", new ArrayList<>());
            request.getRequestDispatcher("/view/receipt/receipt-create.jsp").forward(request, response);
            return;
        }

        for (ReceiptDetail d : details) {
            d.setReceiptId(receiptId);
            detailDAO.insert(d);
        }

        response.sendRedirect(request.getContextPath() + "/receipt?msg=created");
    }

    private List<ReceiptDetail> parseAndValidateDetails(String[] genIds, String[] serials,
            String[] detailNotes, String receiptType, int warehouseId,
            List<String> errors) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) {
            return details;
        }
        boolean isExport = "EXPORT".equals(receiptType);
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
                if (onHand < 1) {
                    errors.add("Dòng " + rowNum + ": Máy phát này đã hết hàng trong kho");
                    continue;
                }
            }

            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId);
            d.setSerialNumber(serial);
            d.setQuantity(1);
            d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private void approveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        boolean ok = receiptDAO.approveReceipt(id, loggedUser.getId());

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/receipt?action=detail&id=" + id + "&msg=approved");
        } else {
            request.setAttribute("error", "Không thể duyệt phiếu (phiếu không ở trạng thái chờ duyệt)");
            viewDetail(request, response);
        }
    }

    private void rejectReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        String reason = request.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập lý do từ chối phiếu");
            viewDetail(request, response);
            return;
        }
        reason = reason.trim();
        if (reason.length() > MAX_REASON_LENGTH) {
            request.setAttribute("error", "Lý do từ chối không được vượt quá " + MAX_REASON_LENGTH + " ký tự");
            viewDetail(request, response);
            return;
        }
        boolean ok = receiptDAO.rejectReceipt(id, loggedUser.getId(), reason);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/receipt?action=detail&id=" + id + "&msg=rejected");
        } else {
            request.setAttribute("error", "Không thể từ chối phiếu (phiếu không ở trạng thái chờ duyệt)");
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

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receipt");
            return;
        }
        String reason = request.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập lý do yêu cầu chỉnh sửa");
            viewDetail(request, response);
            return;
        }
        reason = reason.trim();
        if (reason.length() > MAX_REASON_LENGTH) {
            request.setAttribute("error", "Lý do yêu cầu chỉnh sửa không được vượt quá " + MAX_REASON_LENGTH + " ký tự");
            viewDetail(request, response);
            return;
        }
        boolean ok = receiptDAO.requestRevision(id, loggedUser.getId(), reason);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/receipt?action=detail&id=" + id + "&msg=revisionRequested");
        } else {
            request.setAttribute("error", "Không thể yêu cầu chỉnh sửa (phiếu không ở trạng thái chờ duyệt)");
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
        if (receipt == null
                || !"NEEDS_REVISION".equals(receipt.getStatus())
                || receipt.getCreatedBy() != loggedUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

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
        if (!"NEEDS_REVISION".equals(existing.getStatus())
                || existing.getCreatedBy() != loggedUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String whIdStr = request.getParameter("warehouseId");
        String note = request.getParameter("note");
        int warehouseId = 0;
        List<String> errors = new ArrayList<>();

        try {
            warehouseId = Integer.parseInt(whIdStr);
            if (warehouseId <= 0) {
                errors.add("Vui lòng chọn kho");
            }
        } catch (NumberFormatException e) {
            errors.add("Kho không hợp lệ");
        }

        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details = parseAndValidateDetails(
                genIds, serials, detailNotes,
                existing.getReceiptType(), warehouseId, errors);

        if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
            errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            showEditForm(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptId(receiptId);
        r.setWarehouseId(warehouseId);
        r.setNote(note);

        boolean ok = receiptDAO.updateReceipt(r, details, loggedUser.getId());
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/receipt?msg=resubmitted");
        } else {
            request.setAttribute("error", "Không thể cập nhật phiếu (phiếu không ở trạng thái cần chỉnh sửa)");
            showEditForm(request, response);
        }
    }
}
