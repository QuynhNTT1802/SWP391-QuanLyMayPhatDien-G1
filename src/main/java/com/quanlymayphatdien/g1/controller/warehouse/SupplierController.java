package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.SupplierDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.Supplier;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "SupplierController", urlPatterns = {"/warehouse/suppliers"})
public class SupplierController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewDetail(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "update":
                showUpdateForm(request, response);
                break;
            case "activate":
                activateSupplier(request, response);
                break;
            case "deactivate":
                deactivateSupplier(request, response);
                break;
            case "search":
                searchSuppliersJson(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
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
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createSupplier(request, response);
                break;
            case "update":
                updateSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.view")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String typeIdStr = request.getParameter("supplierTypeId");
        Integer supplierTypeId = (typeIdStr != null && !typeIdStr.isEmpty())
                ? Integer.valueOf(typeIdStr) : null;

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
                page = 1;
            }
        }

        SupplierDAO dao = new SupplierDAO();
        List<Supplier> suppliers = dao.findByFilters(search, status, supplierTypeId, page, pageSize);
        int total = dao.getTotalFiltered(search, status, supplierTypeId);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSuppliers", total);
        request.setAttribute("searchFilter", search);
        request.setAttribute("statusFilter", status);
        request.setAttribute("activeCount", dao.countByStatus("active"));
        request.setAttribute("lockedCount", dao.countByStatus("locked"));
        request.setAttribute("supplierTypeFilter", typeIdStr);

        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("supplierTypeList", catDAO.findByType("customer_type"));

        request.getRequestDispatcher("/view/supplier/supplier-list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.view")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            SupplierDAO dao = new SupplierDAO();
            Supplier s = dao.findById(id);
            if (s != null) {
                request.setAttribute("supplier", s);
                DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                request.setAttribute("createdDate", s.getCreatedAt() != null
                        ? s.getCreatedAt().format(df) : "—");
                request.setAttribute("updatedDate", s.getUpdatedAt() != null
                        ? s.getUpdatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "—");

                CategoryDAO catDAO = new CategoryDAO();
                List<Category> types = catDAO.findByType("customer_type");
                String typeName = "—";
                for (Category t : types) {
                    if (t.getId() == s.getSupplierTypeId()) {
                        typeName = t.getName();
                        break;
                    }
                }
                request.setAttribute("supplierTypeName", typeName);

                ActivityLogDAO logDAO = new ActivityLogDAO();
                List<ActivityLog> logs = logDAO.findByEntityTypeAndId("supplier", id, 1, 20);
                DateTimeFormatter logFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                List<String> logDates = new ArrayList<>();
                for (ActivityLog log : logs) {
                    logDates.add(log.getCreatedAt() != null ? log.getCreatedAt().format(logFmt) : "—");
                }
                request.setAttribute("activityLogs", logs);
                request.setAttribute("logDates", logDates);

                PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
                List<PurchaseOrder> purchaseOrders = poDAO.findBySupplierId(id);
                request.setAttribute("purchaseOrders", purchaseOrders);

                request.getRequestDispatcher("/view/supplier/supplier-detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.create")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("supplierTypeList", catDAO.findByType("customer_type"));
        request.setAttribute("prefillName", request.getParameter("prefillName"));
        request.setAttribute("returnUrl", request.getParameter("returnUrl"));
        request.setAttribute("rowGid", request.getParameter("rowGid"));
        request.getRequestDispatcher("/view/supplier/supplier-create.jsp").forward(request, response);
    }

    private void createSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.create")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String companyName = request.getParameter("companyName");
            String typeIdStr = request.getParameter("supplierTypeId");
            String status = request.getParameter("status");
            String note = request.getParameter("note");
            if (status == null || status.isEmpty()) {
                status = "active";
            }

            Map<String, String> errors = validateSupplierForm(name, phone, email, null);
            if (!errors.isEmpty()) {
                saveFormFields(request, name, phone, email, address, companyName,
                        typeIdStr, note);
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=create");
                return;
            }

            Supplier s = new Supplier();
            s.setName(name.trim());
            s.setPhone(phone.trim());
            s.setEmail(email != null ? email.trim() : null);
            s.setAddress(address);
            s.setCompanyName(companyName);
            if (typeIdStr != null && !typeIdStr.isEmpty()) {
                s.setSupplierTypeId(Integer.parseInt(typeIdStr));
            }
            s.setStatus(status);
            s.setCreatedAt(LocalDateTime.now());
            User user = (User) request.getSession().getAttribute("loggedUser");
            s.setCreatedBy(user != null ? user.getId() : null);

            SupplierDAO dao = new SupplierDAO();
            int newId = dao.insert(s);
            if (newId > 0) {
                request.getSession().setAttribute("message", "Thêm nhà cung cấp thành công!");
                logActivity(request, "supplier", newId, name.trim(), "CREATE",
                        "Tạo nhà cung cấp: " + name.trim() + " - " + phone.trim());

                String returnUrl = request.getParameter("returnUrl");
                if (returnUrl != null && !returnUrl.isEmpty()
                        && (returnUrl.contains("/proposal")
                        || returnUrl.contains("importExcel")
                        || returnUrl.contains("assignSupplier"))) {
                    String separator = (returnUrl.contains("?")
                            || returnUrl.contains("%3F")
                            || returnUrl.contains("%3f")) ? "&" : "?";
                    String rowGid = request.getParameter("rowGid");
                    response.sendRedirect(returnUrl + separator
                            + "newSupplierId=" + newId
                            + "&newSupplierName=" + java.net.URLEncoder.encode(name.trim(), "UTF-8")
                            + (rowGid != null && !rowGid.isEmpty() ? "&assignedGid=" + java.net.URLEncoder.encode(rowGid, "UTF-8") : ""));
                    return;
                }
            } else {
                request.getSession().setAttribute("message", "Thêm nhà cung cấp thất bại!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.update")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            SupplierDAO dao = new SupplierDAO();
            Supplier s = dao.findById(id);
            if (s != null) {
                request.setAttribute("supplier", s);
                CategoryDAO catDAO = new CategoryDAO();
                request.setAttribute("supplierTypeList", catDAO.findByType("customer_type"));
                request.getRequestDispatcher("/view/supplier/supplier-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.update")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String companyName = request.getParameter("companyName");
            String typeIdStr = request.getParameter("supplierTypeId");
            String status = request.getParameter("status");

            Map<String, String> errors = validateSupplierForm(name, phone, email, id);
            if (!errors.isEmpty()) {
                saveFormFields(request, name, phone, email, address, companyName,
                        typeIdStr, request.getParameter("note"));
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=update&id=" + id);
                return;
            }

            SupplierDAO dao = new SupplierDAO();
            Supplier s = dao.findById(id);
            if (s != null) {
                s.setName(name.trim());
                s.setPhone(phone.trim());
                s.setEmail(email != null ? email.trim() : null);
                s.setAddress(address);
                s.setCompanyName(companyName);
                if (typeIdStr != null && !typeIdStr.isEmpty()) {
                    s.setSupplierTypeId(Integer.parseInt(typeIdStr));
                }
                s.setStatus(status);
                s.setUpdatedAt(LocalDateTime.now());
                User user = (User) request.getSession().getAttribute("loggedUser");
                s.setUpdatedBy(user != null ? user.getId() : null);

                boolean ok = dao.update(s);
                if (ok) {
                    request.getSession().setAttribute("message", "Cập nhật thành công!");
                    logActivity(request, "supplier", id, name.trim(), "UPDATE",
                            "Cập nhật thông tin nhà cung cấp: " + name.trim());
                } else {
                    request.getSession().setAttribute("message", "Cập nhật thất bại!");
                }
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy nhà cung cấp!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
    }

    private void activateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.deactivate")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            SupplierDAO dao = new SupplierDAO();
            boolean ok = dao.activate(id);
            if (ok) {
                request.getSession().setAttribute("message", "Kích hoạt thành công!");
                Supplier s = dao.findById(id);
                if (s != null) {
                    logActivity(request, "supplier", id, s.getName(), "ACTIVATE",
                            "Kích hoạt nhà cung cấp: " + s.getName());
                }
            } else {
                request.getSession().setAttribute("message", "Kích hoạt thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list&page=" + currentPage);
    }

    private void deactivateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.deactivate")) {
            response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list");
            return;
        }
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            SupplierDAO dao = new SupplierDAO();
            boolean ok = dao.deactivate(id);
            if (ok) {
                request.getSession().setAttribute("message", "Khóa thành công!");
                Supplier s = dao.findById(id);
                if (s != null) {
                    logActivity(request, "supplier", id, s.getName(), "DEACTIVATE",
                            "Khóa nhà cung cấp: " + s.getName());
                }
            } else {
                request.getSession().setAttribute("message", "Khóa thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/suppliers?action=list&page=" + currentPage);
    }

    private Map<String, String> validateSupplierForm(String name, String phone,
            String email, Integer excludeId) {
        Map<String, String> errors = new HashMap<>();

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Tên nhà cung cấp không được để trống");
        } else if (name.trim().length() > 255) {
            errors.put("name", "Tên không được vượt quá 255 ký tự");
        }

        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phone", "Số điện thoại không được để trống");
        } else {
            SupplierDAO dao = new SupplierDAO();
            if (dao.isPhoneExists(phone.trim(), excludeId)) {
                errors.put("phone", "Số điện thoại này đã tồn tại");
            }
        }

        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                errors.put("email", "Email không đúng định dạng");
            }
        }

        return errors;
    }

    private void saveFormFields(HttpServletRequest request, String name, String phone,
            String email, String address, String companyName, String supplierTypeId, String note) {
        request.getSession().setAttribute("fieldName", name);
        request.getSession().setAttribute("fieldPhone", phone);
        request.getSession().setAttribute("fieldEmail", email);
        request.getSession().setAttribute("fieldAddress", address);
        request.getSession().setAttribute("fieldCompanyName", companyName);
        request.getSession().setAttribute("fieldSupplierTypeId", supplierTypeId);
        request.getSession().setAttribute("fieldNote", note);
    }

    private void logActivity(HttpServletRequest request, String entityType,
            int entityId, String entityName, String action, String details) {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setUsername(loggedUser.getUsername());
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setEntityName(entityName);
        log.setAction(action);
        log.setDetails(details);
        log.setCreatedAt(LocalDateTime.now());
        new ActivityLogDAO().insertLog(log);
    }

    private void searchSuppliersJson(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("q");
        List<Supplier> list = new SupplierDAO().searchByKeyword(keyword, 50);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder sb = new StringBuilder();
        sb.append('[');
        for (int i = 0; i < list.size(); i++) {
            Supplier s = list.get(i);
            if (i > 0) sb.append(',');
            sb.append('{')
              .append("\"id\":").append(s.getId()).append(',')
              .append("\"name\":").append(jsonStr(s.getName())).append(',')
              .append("\"phone\":").append(jsonStr(s.getPhone())).append(',')
              .append("\"email\":").append(jsonStr(s.getEmail())).append(',')
              .append("\"address\":").append(jsonStr(s.getAddress())).append(',')
              .append("\"companyName\":").append(jsonStr(s.getCompanyName()))
              .append('}');
        }
        sb.append(']');
        response.getWriter().write(sb.toString());
    }

    private String jsonStr(String s) {
        if (s == null) return "null";
        StringBuilder sb = new StringBuilder("\"");
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            switch (ch) {
                case '\\': sb.append("\\\\"); break;
                case '\"': sb.append("\\\""); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                default:
                    if (ch < 0x20) {
                        sb.append(String.format("\\u%04x", (int) ch));
                    } else {
                        sb.append(ch);
                    }
            }
        }
        sb.append('"');
        return sb.toString();
    }
}