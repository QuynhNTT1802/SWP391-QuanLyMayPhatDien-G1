package com.quanlymayphatdien.g1.controller.order;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.CustomerDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Set;

@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

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
            SystemLogger.error("Quản lý phiếu mua bán", "OrderController.doGet", e.getMessage(), e);
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            request.getSession().setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
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
                default:
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý phiếu mua bán", "OrderController.doPost", e.getMessage(), e);
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            request.getSession().setAttribute("message", "Lỗi xử lý dữ liệu: " + e.getMessage());
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

        int pendding = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_PENDING, userId);
        int rejected = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_REJECTED, userId);
        int approved = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_APPROVED, userId);
        int cancelled = saleorderdao.countOrderByStatus(GlobalUtils.STATUS_CANCELLED, userId);
        List<SaleOrder> allOrders = saleorderdao.searchByNameCode(searchFilter, statusFilter, userId);

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
                SystemLogger.warn("Quản lý phiếu mua bán", "OrderController.listOrders", "Lỗi định dạng trang: " + e.getMessage());
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

        request.getRequestDispatcher("/view/order/list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.setAttribute("customerTypeName", customerTypeName);
        request.getRequestDispatcher("/view/order/detail.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GeneratorDAO generatorDao = new GeneratorDAO();
        CategoryDAO categoryDao = new CategoryDAO();

        List<Generator> generators = generatorDao.findAll();
        List<Category> brands = categoryDao.findByType("brand");
        List<Category> fuelTypes = categoryDao.findByType("fuel_type");
        List<Category> phases = categoryDao.findByType("phase");
        List<Category> customerTypes = categoryDao.findByType("customer_type");

        request.setAttribute("customerTypes", customerTypes);
        request.setAttribute("generators", generators);
        request.setAttribute("brands", brands);
        request.setAttribute("fuelTypes", fuelTypes);
        request.setAttribute("phases", phases);

        request.getRequestDispatcher("/view/order/create.jsp").forward(request, response);
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.create")) {
            request.getSession().setAttribute("message", "Bạn không có quyền tạo đơn hàng.");
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

        String orderCode = request.getParameter("orderCode");
        if (orderCode == null || orderCode.trim().isEmpty()) {
            String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
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
        if (custPhone != null && !custPhone.trim().isEmpty()) {
            customer = customerDAO.findByPhone(custPhone);
        }
        if (customer == null) {
            customer = new Customer();
            customer.setName(custName);
            customer.setPhone(custPhone);
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
            if (newCustId > 0) {
                customer.setId(newCustId);
            }
        }

        if (customer != null && customer.getId() > 0) {
            order.setCustomerId(customer.getId());
        }

        order.setCustomerNote(custNote);

        order.setStatus("PENDING");
        order.setTotalAmount(0.0);

        String dateStr = request.getParameter("orderDate");
        if (dateStr != null && !dateStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            order.setOrderDate(sdf.parse(dateStr));
        } else {
            order.setOrderDate(new Date());
        }
        String[] genIds = request.getParameterValues("generatorId");
        String[] qtys = request.getParameterValues("quantity");
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

                Generator gen = generatorDao.findById(genId);
                if (gen != null) {
                    OrderDetail detail = new OrderDetail();
                    detail.setGeneratorId(genId);
                    detail.setQuantity(qty);
                    detail.setUnitPrice(gen.getUnitPrice().doubleValue());
                    detailsList.add(detail);

                    totalAmount += gen.getUnitPrice().doubleValue() * qty;
                }
            }
        }

        order.setTotalAmount(totalAmount);
        order.setStatus("PENDING");
        int newId = saleorderdao.insert(order);
        if (newId > 0) {

            for (OrderDetail d : detailsList) {
                d.setOrderId(newId);
                orderdetaildao.insert(d);
            }
            session.setAttribute("message", "Tạo đơn hàng thành công! Mã đơn: " + order.getOrderCode());
            response.sendRedirect(request.getContextPath() + "/order?action=list");
        } else {
            request.setAttribute("error", "Tạo đơn hàng thất bại.");
            request.getRequestDispatcher("/view/order/create.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.update")) {
            request.getSession().setAttribute("message", "Bạn không có quyền sửa đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        SaleOrderDAO saleorderdao = new SaleOrderDAO();
        SaleOrder order = saleorderdao.findById(id);
        GeneratorDAO generatordao = new GeneratorDAO();
        OrderDetailDAO orderdetaildao = new OrderDetailDAO();

        if (order != null && "PENDING".equals(order.getStatus())) {
            List<OrderDetail> existingDetails = orderdetaildao.findGeneratorById(id);

            List<Generator> generator = generatordao.findAll();
            CategoryDAO categoryDao = new CategoryDAO();
            List<Category> customerTypes = categoryDao.findByType("customer_type");

            request.setAttribute("order", order);
            request.setAttribute("existingDetails", existingDetails);
            request.setAttribute("generators", generator);
            request.setAttribute("customerTypes", customerTypes);
            request.getRequestDispatcher("/view/order/edit.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("message", "Không thể sửa đơn này (đã duyệt/hủy hoặc không tồn tại).");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
        }
    }

    private void updateOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.update")) {
            request.getSession().setAttribute("message", "Bạn không có quyền sửa đơn hàng.");
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

                    Generator gen = generatorDao.findById(genId);
                    if (gen != null) {
                        OrderDetail detail = new OrderDetail();
                        detail.setOrderId(orderId);
                        detail.setGeneratorId(genId);
                        detail.setQuantity(qty);
                        detail.setUnitPrice(gen.getUnitPrice().doubleValue());
                        newDetails.add(detail);
                        totalAmount += gen.getUnitPrice().doubleValue() * qty;
                    }
                }
            }

            SaleOrder order = saleorderdao.findById(orderId);
            if (order == null) {
                request.getSession().setAttribute("message", "Không tìm thấy phiếu.");
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

            Customer customer = null;
            if (custPhone != null && !custPhone.trim().isEmpty()) {
                customer = customerDAO.findByPhone(custPhone);
            }

            if (customer == null) {
                customer = new Customer();
            }

            customer.setName(custName);
            customer.setPhone(custPhone);
            customer.setEmail(custEmail);
            customer.setAddress(custAddress);
            customer.setCompanyName(custCompany);

            if (custTypeIdStr != null && !custTypeIdStr.isEmpty()) {
                try {
                    customer.setCustomerTypeId(Integer.parseInt(custTypeIdStr));
                } catch (NumberFormatException ignored) {
                }
            }

            if (customer.getId() > 0) {

                customer.setUpdatedBy(user.getId());
                customerDAO.update(customer);
            } else {

                customer.setStatus("active");
                customer.setCreatedBy(user.getId());
                int newCustId = customerDAO.insert(customer);
                customer.setId(newCustId);
            }

            if (customer != null) {
                order.setCustomerId(customer.getId());
            }

            order.setCustomerNote(custNote);

            boolean ok = saleorderdao.updateWithDetails(order, newDetails);

            if (ok) {
                request.getSession().setAttribute("message", "Cập nhật đơn hàng thành công.");
            } else {
                request.getSession().setAttribute("message",
                        "Phiếu đã được duyệt hoặc thay đổi trạng thái. Vui lòng tải lại.");
            }

        } catch (Exception e) {
            SystemLogger.error("Quản lý phiếu mua bán", "OrderController.updateOrder", e.getMessage(), e);
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void approveOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.approve")) {
            request.getSession().setAttribute("message", "Bạn không có quyền duyệt đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        User user = (User) request.getSession().getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        boolean success = saleorderdao.approveOrder(id, user.getId());

        if (success) {
            request.getSession().setAttribute("message", "Đã duyệt đơn hàng.");
        } else {
            request.getSession().setAttribute("message", "Duyệt thất bại (đơn không ở trạng thái chờ).");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void showRejectForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.reject")) {
            request.getSession().setAttribute("message", "Bạn không có quyền từ chối đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("orderId", id);
        request.getRequestDispatcher("/view/order/reject.jsp").forward(request, response);
    }

    private void rejectOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Set<String> permissions = (Set<String>) request.getSession().getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.reject")) {
            request.getSession().setAttribute("message", "Bạn không có quyền từ chối đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }
        int id = Integer.parseInt(request.getParameter("orderId"));
        String reason = request.getParameter("rejectReason");
        User user = (User) request.getSession().getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        if (reason == null || reason.trim().isEmpty()) {
            request.getSession().setAttribute("message", "Vui lòng nhập lý do từ chối.");
            response.sendRedirect(request.getContextPath() + "/order?action=reject&id=" + id);
            return;
        }

        boolean success = saleorderdao.rejectOrder(id, user.getId(), reason);

        if (success) {
            request.getSession().setAttribute("message", "Đã từ chối đơn hàng.");
        } else {
            request.getSession().setAttribute("message", "Từ chối thất bại.");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();

        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("orders.cancel")) {
            session.setAttribute("message", "Bạn không có quyền hủy đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/order?action=list");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        User user = (User) session.getAttribute("loggedUser");
        SaleOrderDAO saleorderdao = new SaleOrderDAO();

        int result = saleorderdao.cancelOrder(id, user.getId());

        if (result == 1) {
            session.setAttribute("message", "Đã hủy đơn hàng.");
        } else if (result == -1) {
            session.setAttribute("message", "Không thể hủy: đơn đã xuất kho hoàn tất. Vui lòng tạo phiếu nhập kho hoàn trả.");
        } else {
            session.setAttribute("message", "Hủy thất bại: đơn không ở trạng thái PENDING hoặc APPROVED.");
        }
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }
}
