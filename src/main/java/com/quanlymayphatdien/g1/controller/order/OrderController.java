package com.quanlymayphatdien.g1.controller.order;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.CustomerDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.OrderDetailDAO;
import com.quanlymayphatdien.g1.dal.SaleOrderDAO;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Customer;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.OrderDetail;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.utils.NotificationService;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Set;

@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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
                    listOrders(request, response);
                    break;
                case "detail":
                    viewDetail(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "reject":
                    showRejectForm(request, response);
                    break;

                default:
                    listOrders(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.ORDER, "OrderController.doGet", e.getMessage(), e);
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            setMsg(request.getSession(), "Lỗi hệ thống: " + e.getMessage(), "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
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

        try {
            switch (action) {
                case "create":
                    createOrder(request, response);
                    break;
                case "update":
                    updateOrder(request, response);
                    break;
                case "reject":
                    rejectOrder(request, response);
                    break;
                case "approve":
                    approveOrder(request, response);
                    break;
                case "cancel":
                    cancelOrder(request, response);
                    break;
                case "requestRevision":
                    requestRevisionOrder(request, response);
                    break;
                case "quickCreateCustomer":
                    quickCreateCustomer(request, response);
                    break;
                case "delete":
                    deleteOrder(request, response);
                    break;
                default:
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.ORDER, "OrderController.doPost", e.getMessage(), e);
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            setMsg(request.getSession(), "Lỗi xử lý dữ liệu: " + e.getMessage(), "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        User user = (User) request.getSession().getAttribute("loggedUser");
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        boolean canViewAllOrders = permissions != null && permissions.contains("orders.approve");
        int userId = canViewAllOrders ? 0 : user.getId();

        int pendding = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_PENDING, userId, user.getId());
        int rejected = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_REJECTED, userId, user.getId());
        int approved = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_APPROVED, userId, user.getId());
        int cancelled = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_CANCELLED, userId, user.getId());
        List<SaleOrder> allOrders = saleorderdao.searchByNameCode(searchFilter, statusFilter, userId, user.getId());

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
                SystemLogger.warn(LogModule.ORDER, "OrderController.listOrders", "Lỗi định dạng trang: " + e.getMessage());
                page = 1;
            }
        }

        int totalOrders = allOrders.size();
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalOrders);

        List<SaleOrder> pagedOrders = allOrders.subList(startIndex, endIndex);

        request.setAttribute("orders", pagedOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.setAttribute("pendingCount", pendding);
        request.setAttribute("approvedCount", approved);
        request.setAttribute("rejectedCount", rejected);
        request.setAttribute("cancelledCount", cancelled);

        Set<String> userPermissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        request.setAttribute("canCreateOrder", userPermissions != null && userPermissions.contains("orders.create"));
        request.setAttribute("canUpdateOrder", userPermissions != null && userPermissions.contains("orders.update"));
        request.setAttribute("canApproveOrder", userPermissions != null && userPermissions.contains("orders.approve"));
        request.setAttribute("canRejectOrder", userPermissions != null && userPermissions.contains("orders.reject"));
        request.setAttribute("canCancelOrder", userPermissions != null && userPermissions.contains("orders.cancel"));

        request.getRequestDispatcher("/view/order/order-list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int id = Integer.parseInt(request.getParameter("id"));
        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        OrderDetailDAO orderdetaildao = new OrderDetailDAO();
        SaleOrder order = saleorderdao.findById(id);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        List<OrderDetail> details = orderdetaildao.findGeneratorById(id);

        String customerTypeName = "";
        if (order.getCustomer() != null && order.getCustomer().getCustomerTypeId() > 0) {
            Category ct = new CategoryDAO().findById(order.getCustomer().getCustomerTypeId());
            if (ct != null) {
                customerTypeName = ct.getName();
            }
        }

        String tab = request.getParameter("tab");
        String currentTab = "history".equals(tab) ? "history" : "info";
        request.setAttribute("currentTab", currentTab);

        if ("history".equals(currentTab)) {
            String logSearch = request.getParameter("logSearch");
            String logAction = request.getParameter("logAction");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");

            List<Map<String, Object>> logList = new ArrayList<>();
            if (order.getCreatedAt() != null) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("createdAt", order.getCreatedAt());
                m.put("user", order.getCreatedByName() != null ? order.getCreatedByName() : "—");
                m.put("action", "CREATE");
                m.put("actionLabel", "Tạo đơn hàng");
                m.put("details", "Tạo đơn hàng " + order.getOrderCode());
                logList.add(m);
            }
            if (order.getUpdatedAt() != null && (order.getCreatedAt() == null || order.getUpdatedAt().after(order.getCreatedAt()))) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("createdAt", order.getUpdatedAt());
                m.put("user", order.getCreatedByName() != null ? order.getCreatedByName() : "—");
                m.put("action", "UPDATE");
                m.put("actionLabel", "Cập nhật");
                m.put("details", "Cập nhật nội dung đơn hàng");
                logList.add(m);
            }
            if ("APPROVED".equals(order.getStatus()) && order.getApprovedAt() != null) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("createdAt", order.getApprovedAt());
                m.put("user", order.getApprovedByName() != null ? order.getApprovedByName() : "—");
                m.put("action", "APPROVE");
                m.put("actionLabel", "Duyệt đơn");
                m.put("details", "Duyệt đơn hàng " + order.getOrderCode());
                logList.add(m);
            }
            if ("REJECTED".equals(order.getStatus())) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("createdAt", order.getUpdatedAt() != null ? order.getUpdatedAt() : new Date());
                m.put("user", order.getRejectedByName() != null ? order.getRejectedByName() : "—");
                m.put("action", "REJECT");
                m.put("actionLabel", "Từ chối");
                m.put("details", "Từ chối đơn hàng" + (order.getRejectReason() != null ? ": " + order.getRejectReason() : ""));
                logList.add(m);
            }
            if ("CANCELLED".equals(order.getStatus()) && order.getCancelledAt() != null) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("createdAt", order.getCancelledAt());
                m.put("user", order.getCancelledByName() != null ? order.getCancelledByName() : "—");
                m.put("action", "CANCEL");
                m.put("actionLabel", "Hủy đơn");
                m.put("details", "Hủy đơn hàng " + order.getOrderCode());
                logList.add(m);
            }

            List<Map<String, Object>> filtered = new ArrayList<>();
            for (Map<String, Object> m : logList) {
                if (logAction != null && !logAction.trim().isEmpty() && !logAction.equalsIgnoreCase((String) m.get("action"))) {
                    continue;
                }
                if (logSearch != null && !logSearch.trim().isEmpty()) {
                    String s = logSearch.trim().toLowerCase();
                    boolean match = ((String) m.get("user")).toLowerCase().contains(s)
                            || ((String) m.get("actionLabel")).toLowerCase().contains(s)
                            || ((String) m.get("details")).toLowerCase().contains(s);
                    if (!match) continue;
                }
                if (dateFrom != null && !dateFrom.trim().isEmpty()) {
                    try {
                        Date from = new SimpleDateFormat("yyyy-MM-dd").parse(dateFrom);
                        Date created = (Date) m.get("createdAt");
                        if (created.before(from)) continue;
                    } catch (Exception ignored) {}
                }
                if (dateTo != null && !dateTo.trim().isEmpty()) {
                    try {
                        Date to = new SimpleDateFormat("yyyy-MM-dd").parse(dateTo);
                        Date endOfDay = new Date(to.getTime() + 24L * 60 * 60 * 1000 - 1);
                        Date created = (Date) m.get("createdAt");
                        if (created.after(endOfDay)) continue;
                    } catch (Exception ignored) {}
                }
                filtered.add(m);
            }
            logList.sort((a, b) -> {
                Date da = (Date) a.get("createdAt");
                Date db = (Date) b.get("createdAt");
                if (da == null && db == null) return 0;
                if (da == null) return 1;
                if (db == null) return -1;
                return db.compareTo(da);
            });

            int pageSize = 20;
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try { page = Math.max(1, Integer.parseInt(pageStr)); }
                catch (NumberFormatException ignored) { page = 1; }
            }
            int totalLogs = filtered.size();
            int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
            if (page > totalPages) page = totalPages;
            int fromIdx = (page - 1) * pageSize;
            int toIdx = Math.min(page * pageSize, totalLogs);
            List<Map<String, Object>> pageList = fromIdx < totalLogs
                    ? filtered.subList(fromIdx, toIdx)
                    : new ArrayList<>();

            request.setAttribute("logList", pageList);
            request.setAttribute("logPage", page);
            request.setAttribute("logTotalPages", totalPages);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("logSearch", logSearch != null ? logSearch : "");
            request.setAttribute("logAction", logAction != null ? logAction : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        }

        User loggedUser = (User) session.getAttribute("loggedUser");
        boolean isOwner = loggedUser != null && order.getCreatedBy() == loggedUser.getId();

        // If deleted and not the creator, redirect
        if (GlobalUtils.STATUS_DELETED.equals(order.getStatus()) && !isOwner) {
            setMsg(session, "Đơn hàng đã bị xoá.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        request.setAttribute("canApproveOrder", perms != null && perms.contains("orders.approve"));
        request.setAttribute("canRejectOrder", perms != null && perms.contains("orders.reject"));
        request.setAttribute("canCancelOrder", perms != null && perms.contains("orders.cancel"));
        request.setAttribute("canUpdateOrder", perms != null && perms.contains("orders.update"));
        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.setAttribute("customerTypeName", customerTypeName);
        request.setAttribute("isOwner", isOwner);

        int totalQty = 0;
        int totalRows = 0;
        if (details != null) {
            totalRows = details.size();
            for (OrderDetail d : details) {
                totalQty += d.getQuantity();
            }
        }
        request.setAttribute("totalQty", totalQty);
        request.setAttribute("totalRows", totalRows);
        request.setAttribute("userPermissions", perms);
        request.getRequestDispatcher("/view/order/order-detail.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String newCustIdStr = request.getParameter("newCustomerId");
        if (newCustIdStr != null && !newCustIdStr.isEmpty()) {
            try {
                int newCustId = Integer.parseInt(newCustIdStr);
                Customer preselect = new CustomerDAO().findById(newCustId);
                request.setAttribute("preselectCustomer", preselect);
            } catch (NumberFormatException ignored) {
            }
        }

        GeneratorDAO generatorDao = new GeneratorDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        CustomerDAO customerDao = new CustomerDAO();

        List<Generator> generators = generatorDao.findAll();
        List<Category> brands = categoryDao.findByType("brand");
        List<Category> fuelTypes = categoryDao.findByType("fuel_type");
        List<Category> phases = categoryDao.findByType("phase");
        List<Category> customerTypes = categoryDao.findByType("customer_type");
        List<Customer> top4Customers = customerDao.findTop4Alphabetical();
        java.util.Map<Integer, Integer> stockMap = generatorDao.getTotalStockMap();

        request.setAttribute("customerTypes", customerTypes);
        request.setAttribute("generators", generators);
        request.setAttribute("brands", brands);
        request.setAttribute("fuelTypes", fuelTypes);
        request.setAttribute("phases", phases);
        request.setAttribute("top4Customers", top4Customers);
        request.setAttribute("stockMap", stockMap);
        request.setAttribute("canCreateCustomer", true);

        request.getRequestDispatcher("/view/order/order-create.jsp").forward(request, response);
    }

    private void quickCreateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.getWriter().write("{\"ok\":false,\"error\":\"no_session\"}");
                return;
            }

            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String companyName = request.getParameter("companyName");
            String typeIdStr = request.getParameter("customerTypeId");

            if (name == null || name.trim().isEmpty()) {
                response.getWriter().write("{\"ok\":false,\"error\":\"Vui lòng nhập tên khách hàng\"}");
                return;
            }
            if (phone == null || phone.trim().isEmpty()) {
                response.getWriter().write("{\"ok\":false,\"error\":\"Vui lòng nhập số điện thoại\"}");
                return;
            }

            CustomerDAO custDAO = new CustomerDAO();
            if (custDAO.isPhoneExists(phone.trim(), null)) {
                Customer existing = custDAO.findByPhone(phone.trim());
                if (existing != null) {
                    response.getWriter().write("{\"ok\":true,\"existing\":true,\"id\":" + existing.getId()
                            + ",\"name\":\"" + escapeJson(existing.getName())
                            + "\",\"phone\":\"" + escapeJson(existing.getPhone())
                            + "\",\"email\":\"" + escapeJson(existing.getEmail())
                            + "\",\"address\":\"" + escapeJson(existing.getAddress())
                            + "\",\"companyName\":\"" + escapeJson(existing.getCompanyName())
                            + "\",\"customerTypeId\":" + existing.getCustomerTypeId() + "}");
                    return;
                }
            }

            Customer c = new Customer();
            c.setName(name.trim());
            c.setPhone(phone.trim());
            c.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
            c.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
            c.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName.trim() : null);
            if (typeIdStr != null && !typeIdStr.trim().isEmpty()) {
                try {
                    c.setCustomerTypeId(Integer.parseInt(typeIdStr.trim()));
                } catch (NumberFormatException ignore) {}
            }
            c.setStatus("active");
            User u = (User) session.getAttribute("loggedUser");
            if (u != null) {
                c.setCreatedBy(u.getId());
            }

            int newId = custDAO.insert(c);
            if (newId <= 0) {
                response.getWriter().write("{\"ok\":false,\"error\":\"Không thể lưu khách hàng\"}");
                return;
            }

            response.getWriter().write("{\"ok\":true,\"existing\":false,\"id\":" + newId
                    + ",\"name\":\"" + escapeJson(name.trim())
                    + "\",\"phone\":\"" + escapeJson(phone.trim())
                    + "\",\"email\":\"" + escapeJson(email != null ? email.trim() : "")
                    + "\",\"address\":\"" + escapeJson(address != null ? address.trim() : "")
                    + "\",\"companyName\":\"" + escapeJson(companyName != null ? companyName.trim() : "")
                    + "\",\"customerTypeId\":" + (typeIdStr != null && !typeIdStr.trim().isEmpty() ? typeIdStr.trim() : "0") + "}");
        } catch (Exception e) {
            SystemLogger.error(LogModule.ORDER, "quickCreateCustomer", e.getMessage(), e);
            response.getWriter().write("{\"ok\":false,\"error\":\"Lỗi hệ thống: " + escapeJson(e.getMessage() != null ? e.getMessage() : "không xác định") + "\"}");
        }
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        boolean ok = saleorderdao.deleteByCreator(id, user.getId());

        if (ok) {
            setMsg(session, "Đã xoá đơn hàng.", "success");
        } else {
            setMsg(session, "Không thể xoá: đơn không ở trạng thái chờ duyệt hoặc không phải người tạo.", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.create")) {
            setMsg(request.getSession(), "Bạn không có quyền tạo đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen");
            return;
        }

        SaleOrder order = new SaleOrder();

        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        OrderDetailDAO orderdetaildao = new OrderDetailDAO();
        GeneratorDAO generatorDao = new GeneratorDAO();
        InventoryDAO inventoryDao = new InventoryDAO();

        String orderCode = request.getParameter("orderCode");
        if (orderCode == null || orderCode.trim().isEmpty()) {
            String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            int todayCount = saleorderdao.countTodayOrders() + 1;
            orderCode = String.format("ORD-%s-%03d", dateStr, todayCount);
        }
        order.setOrderCode(orderCode);
        order.setCreatedBy(user.getId());
        CustomerDAO customerDAO = new CustomerDAO();

        String custName = request.getParameter("customerName");
        String custPhone = request.getParameter("customerPhone");
        String custEmail = request.getParameter("customerEmail");
        String custAddress = request.getParameter("customerAddress");

        String custCompany = request.getParameter("customerCompany");
        String custTypeIdStr = request.getParameter("customerTypeId");
        String custNote = request.getParameter("customerNote");
        Customer customer = null;
        if (custPhone == null || custPhone.trim().isEmpty()) {
            setMsg(session, "Vui lòng nhập số điện thoại khách hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=create");
            return;
        }
        customer = customerDAO.findByPhone(custPhone.trim());
        if (customer == null) {           
            customer = new Customer();
            customer.setName(custName);
            customer.setPhone(custPhone.trim());
            customer.setEmail(custEmail);
            customer.setAddress(custAddress);
            customer.setCompanyName(custCompany);
            if (custTypeIdStr != null && !custTypeIdStr.isEmpty()) {
                try {
                    customer.setCustomerTypeId(Integer.parseInt(custTypeIdStr));
                } catch (NumberFormatException ignored) {
                }
            }
            customer.setStatus("active");
            customer.setCreatedBy(user.getId());
            int newCustId = customerDAO.insert(customer);
            if (newCustId <= 0) {
                setMsg(request.getSession(), "Lỗi tạo khách hàng mới. Vui lòng thử lại.", "danger");
                response.sendRedirect(request.getContextPath() + "/order?action=create");
                return;
            }
            customer.setId(newCustId);
        } else {         
            customer.setName(custName);
            customer.setEmail(custEmail);
            customer.setAddress(custAddress);
            customer.setCompanyName(custCompany);
            if (custTypeIdStr != null && !custTypeIdStr.isEmpty()) {
                try {
                    customer.setCustomerTypeId(Integer.parseInt(custTypeIdStr));
                } catch (NumberFormatException ignored) {
                }
            }
            customer.setUpdatedBy(user.getId());
            customerDAO.update(customer);
        }

        order.setCustomerId(customer.getId());
        order.setCustomerNote(custNote);
        order.setCreatedBy(user.getId());

        order.setStatus("PENDING");
        order.setTotalAmount(0.0);

        order.setOrderDate(new Date());

        String[] genIds = request.getParameterValues("generatorId");
        String[] qtys = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        List<OrderDetail> detailsList = new ArrayList<>();
        double totalAmount = 0;

        if (genIds != null) {
            for (int i = 0; i < genIds.length; i++) {

                if (genIds[i] == null || genIds[i].isEmpty()) {
                    continue;
                }

                int genId = Integer.parseInt(genIds[i]);
                int qty = 1;
                if (qtys != null && i < qtys.length && qtys[i] != null && !qtys[i].isEmpty()) {
                    qty = Integer.parseInt(qtys[i]);
                }
                double inputPrice = 0;
                if (unitPrices != null && i < unitPrices.length && unitPrices[i] != null && !unitPrices[i].isEmpty()) {
                    try {
                        inputPrice = Double.parseDouble(unitPrices[i]);
                    } catch (NumberFormatException ex) {
                        inputPrice = 0;
                    }
                }

                if (inputPrice <= 0) {
                    setMsg(session, "Đơn giá dòng máy thứ " + (i + 1) + " phải lớn hơn 0.", "danger");
                    response.sendRedirect(request.getContextPath() + "/order?action=create");
                    return;
                }

                if (qty <= 0) {
                    setMsg(session, "Số lượng dòng máy thứ " + (i + 1) + " phải lớn hơn 0.", "danger");
                    response.sendRedirect(request.getContextPath() + "/order?action=create");
                    return;
                }

                Generator gen = generatorDao.findById(genId);
                if (gen != null) {
                    int inStock = inventoryDao.countInStockByGenerator(genId);
                    if (qty > inStock) {
                        setMsg(session, "Số lượng dòng máy thứ " + (i + 1)
                                + " (" + qty + ") vượt quá tồn kho (" + inStock + ").", "danger");
                        response.sendRedirect(request.getContextPath() + "/order?action=create");
                        return;
                    }

                    double salePrice = inputPrice;
                    OrderDetail detail = new OrderDetail();
                    detail.setGeneratorId(genId);
                    detail.setQuantity(qty);
                    detail.setUnitPrice(salePrice);
                    detailsList.add(detail);

                    totalAmount += salePrice * qty;
                }
            }
        }

        if (detailsList.isEmpty()) {
            setMsg(session, "Vui lòng chọn ít nhất 1 máy cho đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=create");
            return;
        }

        order.setTotalAmount(totalAmount);
        order.setStatus("PENDING");
        int newId = saleorderdao.insert(order);
        if (newId > 0) {

            for (OrderDetail d : detailsList) {
                d.setOrderId(newId);
                orderdetaildao.insert(d);
            }
            setMsg(session, "Tạo đơn hàng thành công! Mã đơn: " + order.getOrderCode(), "success");

            List<User> approvers = userDAO.findUsersByPermission("orders", "approve");
            for (User u : approvers) {
                NotificationService.send(
                    u.getId(),
                    "Đơn hàng " + order.getOrderCode() + " chờ duyệt",
                    "Nhân viên " + user.getName() + " vừa tạo đơn hàng cần duyệt.",
                    request.getContextPath() + "/order?action=detail&id=" + newId,
                    "order",
                    newId
                );
            }

            response.sendRedirect(request.getContextPath() + "/order?action=list");
        } else {
            setMsg(session, "Tạo đơn hàng thất bại.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=create");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.update")) {
            setMsg(request.getSession(), "Bạn không có quyền sửa đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        SaleOrder order = saleorderdao.findById(id);
        GeneratorDAO generatordao = new GeneratorDAO();
        OrderDetailDAO orderdetaildao = new OrderDetailDAO();

        if (order != null && ("PENDING".equals(order.getStatus()) || "NEEDS_REVISION".equals(order.getStatus()))) {
            List<OrderDetail> existingDetails = orderdetaildao.findGeneratorById(id);

            List<Generator> generator = generatordao.findAll();
            CategoryDAO categoryDao = new CategoryDAO();
            CustomerDAO customerDao = new CustomerDAO();
            List<Category> customerTypes = categoryDao.findByType("customer_type");
            List<Customer> top4Customers = customerDao.findTop4Alphabetical();
            java.util.Map<Integer, Integer> stockMap = generatordao.getTotalStockMap();


            String newCustIdStr = request.getParameter("newCustomerId");
            if (newCustIdStr != null && !newCustIdStr.isEmpty()) {
                try {
                    int newCustId = Integer.parseInt(newCustIdStr);
                    Customer preselect = new CustomerDAO().findById(newCustId);
                    if (preselect != null) {
                        order.setCustomer(preselect);
                        order.setCustomerId(preselect.getId());
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            request.setAttribute("order", order);
            request.setAttribute("existingDetails", existingDetails);
            request.setAttribute("generators", generator);
            request.setAttribute("customerTypes", customerTypes);
            request.setAttribute("top4Customers", top4Customers);
            request.setAttribute("stockMap", stockMap);
            request.getRequestDispatcher("/view/order/order-edit.jsp").forward(request, response);
        } else {
            setMsg(request.getSession(), "Không thể sửa đơn này (đã duyệt/hủy hoặc không tồn tại).", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
        }
    }

    private void updateOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.update")) {
            setMsg(request.getSession(), "Bạn không có quyền sửa đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        OrderDetailDAO orderdetaildao = new OrderDetailDAO();
        GeneratorDAO generatorDao = new GeneratorDAO();

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        User user = (User) request.getSession().getAttribute("loggedUser");
        try {

            String[] genIds = request.getParameterValues("generatorId");
            String[] qtys = request.getParameterValues("quantity");
            String[] unitPrices = request.getParameterValues("unitPrice");
            List<OrderDetail> newDetails = new ArrayList<>();
            double totalAmount = 0;

            if (genIds != null) {
                for (int i = 0; i < genIds.length; i++) {
                    if (genIds[i] == null || genIds[i].isEmpty()) {
                        continue;
                    }
                    int genId = Integer.parseInt(genIds[i]);
                    int qty = 1;
                    if (qtys != null && i < qtys.length && qtys[i] != null && !qtys[i].isEmpty()) {
                        qty = Integer.parseInt(qtys[i]);
                    }
                    double inputPrice = 0;
                    if (unitPrices != null && i < unitPrices.length && unitPrices[i] != null && !unitPrices[i].isEmpty()) {
                        try {
                            inputPrice = Double.parseDouble(unitPrices[i]);
                        } catch (NumberFormatException ex) {
                            inputPrice = 0;
                        }
                    }

                    if (inputPrice <= 0) {
                        setMsg(request.getSession(), "Đơn giá dòng máy thứ " + (i + 1) + " phải lớn hơn 0.", "danger");
                        response.sendRedirect(request.getContextPath() + "/order?action=edit&id=" + orderId);
                        return;
                    }

                    Generator gen = generatorDao.findById(genId);
                    if (gen != null) {
                        double salePrice = inputPrice;
                        OrderDetail detail = new OrderDetail();
                        detail.setOrderId(orderId);
                        detail.setGeneratorId(genId);
                        detail.setQuantity(qty);
                        detail.setUnitPrice(salePrice);
                        newDetails.add(detail);
                        totalAmount += salePrice * qty;
                    }
                }
            }

            if (newDetails.isEmpty()) {
                setMsg(request.getSession(), "Vui lòng chọn ít nhất 1 máy cho đơn hàng.", "danger");
                response.sendRedirect(request.getContextPath() + "/order?action=edit&id=" + orderId);
                return;
            }

            SaleOrder order = saleorderdao.findById(orderId);
            if (order == null) {
                setMsg(request.getSession(), "Không tìm thấy phiếu.", "danger");
                response.sendRedirect(request.getContextPath() + "/order?action=list");
                return;
            }

            CustomerDAO customerDAO = new CustomerDAO();

            String custName = request.getParameter("customerName");
            String custPhone = request.getParameter("customerPhone");
            String custEmail = request.getParameter("customerEmail");
            String custAddress = request.getParameter("customerAddress");
            String custCompany = request.getParameter("customerCompany");
            String custTypeIdStr = request.getParameter("customerTypeId");
            String custNote = request.getParameter("customerNote");

            if (custPhone == null || custPhone.trim().isEmpty()) {
                setMsg(request.getSession(), "Vui lòng nhập số điện thoại khách hàng.", "danger");
                response.sendRedirect(request.getContextPath() + "/order?action=edit&id=" + orderId);
                return;
            }
            Customer customer = customerDAO.findByPhone(custPhone.trim());
            if (customer == null) {
               
                customer = new Customer();
                customer.setName(custName);
                customer.setPhone(custPhone.trim());
                customer.setEmail(custEmail);
                customer.setAddress(custAddress);
                customer.setCompanyName(custCompany);
                if (custTypeIdStr != null && !custTypeIdStr.isEmpty()) {
                    try {
                        customer.setCustomerTypeId(Integer.parseInt(custTypeIdStr));
                    } catch (NumberFormatException ignored) {
                    }
                }
                customer.setStatus("active");
                customer.setCreatedBy(user.getId());
                int newCustId = customerDAO.insert(customer);
                if (newCustId <= 0) {
                    setMsg(request.getSession(), "Lỗi tạo khách hàng mới. Vui lòng thử lại.", "danger");
                    response.sendRedirect(request.getContextPath() + "/order?action=edit&id=" + orderId);
                    return;
                }
                customer.setId(newCustId);
            } else {
               
                customer.setName(custName);
                customer.setEmail(custEmail);
                customer.setAddress(custAddress);
                customer.setCompanyName(custCompany);
                if (custTypeIdStr != null && !custTypeIdStr.isEmpty()) {
                    try {
                        customer.setCustomerTypeId(Integer.parseInt(custTypeIdStr));
                    } catch (NumberFormatException ignored) {
                    }
                }
                customer.setUpdatedBy(user.getId());
                customerDAO.update(customer);
            }

            order.setCustomerId(customer.getId());

            order.setCustomerNote(custNote);

            boolean ok = saleorderdao.updateWithDetails(order, newDetails);

            if (ok) {
                setMsg(request.getSession(), "Cập nhật đơn hàng thành công.", "success");
            } else {
                setMsg(request.getSession(),
                        "Phiếu đã được duyệt hoặc thay đổi trạng thái. Vui lòng tải lại.", "danger");
            }

        } catch (Exception e) {
            SystemLogger.error(LogModule.ORDER, "OrderController.updateOrder", e.getMessage(), e);
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            setMsg(request.getSession(), "Lỗi: " + e.getMessage(), "danger");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void approveOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.approve")) {
            setMsg(request.getSession(), "Bạn không có quyền duyệt đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        User user = (User) request.getSession().getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        OrderDetailDAO orderdetaildao = new OrderDetailDAO();
        GeneratorDAO generatorDao = new GeneratorDAO();

        
        List<OrderDetail> details = orderdetaildao.findGeneratorById(id);
        if (details != null && !details.isEmpty()) {
            java.util.Map<Integer, Integer> stockMap = generatorDao.getTotalStockMap();
            java.util.Map<Integer, Integer> reservedMap = saleorderdao.getApprovedQuantitiesByGeneratorExcept(id);
            for (OrderDetail d : details) {
                int stock = stockMap.get(d.getGeneratorId()) != null ? stockMap.get(d.getGeneratorId()) : 0;
                int reserved = reservedMap.getOrDefault(d.getGeneratorId(), 0);
                int available = stock - reserved;
                if (available < 0) available = 0;
                if (d.getQuantity() > available) {
                    String genName = generatorDao.findById(d.getGeneratorId()) != null
                            ? generatorDao.findById(d.getGeneratorId()).getModel() : ("#" + d.getGeneratorId());
                    setMsg(request.getSession(),
                            "Không thể duyệt: máy \"" + genName + "\" cần " + d.getQuantity()
                                    + " nhưng tồn kho khả dụng chỉ có " + available
                                    + " (đã có " + reserved + " được duyệt ở đơn khác)."
                                    + " Vui lòng giảm số lượng hoặc nhập thêm hàng.", "danger");
                    response.sendRedirect(request.getContextPath() + "/order?action=detail&id=" + id);
                    return;
                }
            }
        }

        SaleOrder order = saleorderdao.findById(id);
        boolean success = saleorderdao.approveOrder(id, user.getId());

        if (success) {
            setMsg(request.getSession(), "Đã duyệt đơn hàng.", "success");

            int creatorId = order != null ? order.getCreatedBy() : 0;
            if (creatorId > 0) {
                NotificationService.send(
                    creatorId,
                    "Đơn hàng " + order.getOrderCode() + " đã được duyệt",
                    "Đơn hàng " + order.getOrderCode() + " đã được " + user.getName() + " duyệt.",
                    request.getContextPath() + "/order?action=detail&id=" + id,
                    "order",
                    id
                );
            }
        } else {
            setMsg(request.getSession(), "Duyệt thất bại (đơn không ở trạng thái chờ).", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void showRejectForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.reject")) {
            setMsg(request.getSession(), "Bạn không có quyền từ chối đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("orderId", id);
        request.getRequestDispatcher("/view/order/order-reject.jsp").forward(request, response);
    }

    private void rejectOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.reject")) {
            setMsg(request.getSession(), "Bạn không có quyền từ chối đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("orderId"));
        String reason = request.getParameter("rejectReason");
        User user = (User) request.getSession().getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        if (reason == null || reason.trim().isEmpty()) {
            setMsg(request.getSession(), "Vui lòng nhập lý do từ chối.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=reject&id=" + id);
            return;
        }

        SaleOrder order = saleorderdao.findById(id);
        boolean success = saleorderdao.rejectOrder(id, user.getId(), reason);

        if (success) {
            setMsg(request.getSession(), "Đã từ chối đơn hàng.", "success");

            int creatorId = order != null ? order.getCreatedBy() : 0;
            if (creatorId > 0) {
                NotificationService.send(
                    creatorId,
                    "Đơn hàng " + order.getOrderCode() + " bị từ chối",
                    "Đơn hàng " + order.getOrderCode() + " bị " + user.getName() + " từ chối (lý do: " + reason + ").",
                    request.getContextPath() + "/order?action=detail&id=" + id,
                    "order",
                    id
                );
            }
        } else {
            setMsg(request.getSession(), "Từ chối thất bại.", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();

        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.cancel")) {
            setMsg(session, "Bạn không có quyền hủy đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        User user = (User) session.getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        int result = saleorderdao.cancelOrder(id, user.getId());

        if (result == 1) {
            setMsg(session, "Đã hủy đơn hàng.", "success");
        } else if (result == -1) {
            setMsg(session, "Không thể hủy: đơn đã xuất kho hoàn tất. Vui lòng tạo phiếu nhập kho hoàn trả.", "danger");
        } else {
            setMsg(session, "Hủy thất bại: chỉ có thể hủy đơn ở trạng thái chờ duyệt hoặc đã duyệt (chưa xuất kho).", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void requestRevisionOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();

        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.approve")) {
            setMsg(session, "Bạn không có quyền yêu cầu chỉnh sửa đơn hàng.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String reason = request.getParameter("reason");
        User user = (User) request.getAttribute("loggedUser") != null
                ? (User) request.getAttribute("loggedUser")
                : (User) session.getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        if (reason == null || reason.trim().isEmpty()) {
            setMsg(session, "Vui lòng nhập lý do yêu cầu chỉnh sửa.", "danger");
            response.sendRedirect(request.getContextPath() + "/order?action=detail&id=" + id);
            return;
        }

        boolean success = saleorderdao.requestRevisionOrder(id, user.getId(), reason);

        if (success) {
            setMsg(session, "Đã gửi yêu cầu chỉnh sửa đơn hàng.", "success");
        } else {
            setMsg(session, "Yêu cầu chỉnh sửa thất bại.", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void setMsg(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
