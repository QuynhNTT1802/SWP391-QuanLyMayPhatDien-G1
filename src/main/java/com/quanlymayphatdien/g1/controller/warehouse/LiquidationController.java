package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDetailDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.dal.CustomerDAO;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Customer;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Liquidation;
import com.quanlymayphatdien.g1.entity.LiquidationDetail;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import static java.net.URLEncoder.encode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "LiquidationController", urlPatterns = {"/liquidations"})
@MultipartConfig
public class LiquidationController extends HttpServlet {

    private final LiquidationDAO liquidationDAO = new LiquidationDAO();
    private final LiquidationDetailDAO detailDAO = new LiquidationDetailDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final ReceiptDetailDAO receiptDetailDAO = new ReceiptDetailDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final UserDAO userDAO = new UserDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();
    private final PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("liquidations.view")) {
            request.setAttribute("requiredPerm", "liquidations.view");
            request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create":
                    showCreateView(request, response);
                    break;
                case "edit_view":
                    if (!perms.contains("liquidations.create")) {
                        request.setAttribute("requiredPerm", "liquidations.create");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    showEditView(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "search_customer":
                    searchCustomerJson(request, response);
                    break;
                case "list":
                default:
                    showList(request, response);
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            String act = request.getParameter("action");
            boolean isAjax = "get_serials".equals(act) || "get_serials_all".equals(act) || "search_customer".equals(act);
            if (isAjax && !response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String msg = ex.getMessage() != null ? ex.getMessage() : ex.getClass().getSimpleName();
                response.getWriter().write("{\"error\":\"" + msg.replace("\"", "\\\"") + "\"}");
            }
        }
    }

    // Hiển thị màn tạo đơn: render danh sách máy server-side (JSTL), không dùng AJAX/JSON.
    private void showCreateView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setAttribute("reasons", categoryDAO.findByType("liquidation_reason"));
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("customerTypes", categoryDAO.findByType("customer_type"));

        Integer warehouseId = null;
        String whParam = request.getParameter("warehouseId");
        if (whParam != null && !whParam.trim().isEmpty()) {
            try {
                warehouseId = Integer.parseInt(whParam.trim());
            } catch (NumberFormatException ignore) {
            }
        }
        request.setAttribute("selectedWarehouseId", warehouseId);

        String reasonParam = request.getParameter("reasonId");
        if (reasonParam != null && !reasonParam.trim().isEmpty()) {
            request.setAttribute("selectedReasonId", reasonParam.trim());
        }

        String condFilter = request.getParameter("cond");
        request.setAttribute("condFilter", condFilter != null ? condFilter : "all");

        if (warehouseId != null) {
            List<Inventory> inStock = inventoryDAO.findInStockByWarehouse(warehouseId);
            List<Map<String, Object>> locked = inventoryDAO.findPendingLiquidationSerialsByWarehouse(warehouseId);

            int cGood = 0, cPoor = 0, cDamaged = 0;
            for (Inventory inv : inStock) {
                if ("GOOD".equals(inv.getCondition())) {
                    cGood++;
                } else if ("POOR".equals(inv.getCondition())) {
                    cPoor++;
                } else if ("DAMAGED".equals(inv.getCondition())) {
                    cDamaged++;
                }
            }
            request.setAttribute("condCountGood", cGood);
            request.setAttribute("condCountPoor", cPoor);
            request.setAttribute("condCountDamaged", cDamaged);
            request.setAttribute("condCountAll", inStock.size());

            boolean filtering = condFilter != null && !condFilter.isEmpty() && !"all".equals(condFilter);
            List<Inventory> filtered = new ArrayList<>();
            for (Inventory inv : inStock) {
                if (filtering && !condFilter.equals(inv.getCondition())) {
                    continue;
                }
                filtered.add(inv);
            }

            request.setAttribute("pickRows", buildPickRows(filtered, java.util.Collections.emptySet()));

            List<Map<String, Object>> lockedRows = new ArrayList<>();
            for (Map<String, Object> m : locked) {
                Map<String, Object> r = new HashMap<>();
                r.put("serialNumber", m.get("serialNumber"));
                r.put("model", m.get("generatorModel"));
                r.put("liquidationId", m.get("liquidationId"));
                r.put("liquidationCode", m.get("liquidationCode"));
                lockedRows.add(r);
            }
            request.setAttribute("lockedRows", lockedRows);
        }

        request.getRequestDispatcher("/view/liquidation/liquidation-create.jsp").forward(request, response);
    }

    // Build danh sách máy phẳng để render bảng, giữ nguyên thứ tự của inStock
    // (DAO đã sắp Hỏng->Kém->Tốt). Mỗi row: serialNumber, generatorId, model,
    // unitPrice, condition, createdAtStr, selected.
    private List<Map<String, Object>> buildPickRows(List<Inventory> inStock, Set<String> selectedSerials) {
        java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        Map<Integer, BigDecimal> priceCache = new HashMap<>();
        List<Map<String, Object>> rows = new ArrayList<>();
        for (Inventory inv : inStock) {
            int gid = inv.getGeneratorId();
            BigDecimal price = priceCache.get(gid);
            if (price == null && !priceCache.containsKey(gid)) {
                try {
                    price = purchaseOrderDAO.findApprovedUnitPriceByGenerator(gid);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    price = null;
                }
                priceCache.put(gid, price);
            }
            Map<String, Object> r = new HashMap<>();
            r.put("serialNumber", inv.getSerialNumber());
            r.put("generatorId", gid);
            r.put("model", inv.getGeneratorModel());
            r.put("unitPrice", price != null ? price : BigDecimal.ZERO);
            r.put("condition", inv.getCondition());
            r.put("createdAtStr", inv.getCreatedAt() != null ? inv.getCreatedAt().format(df) : "");
            r.put("selected", selectedSerials.contains(inv.getSerialNumber()));
            rows.add(r);
        }
        return rows;
    }

    

    private void searchCustomerJson(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String q = request.getParameter("q");
        if (q == null) {
            q = "";
        }
        List<Customer> customers = customerDAO.findByFilters(q.trim(), "active", null, 1, 20);

        JsonArray arr = new JsonArray();
        for (Customer c : customers) {
            JsonObject o = new JsonObject();
            o.addProperty("id", c.getId());
            o.addProperty("name", c.getName());
            o.addProperty("phone", c.getPhone());
            o.addProperty("email", c.getEmail() != null ? c.getEmail() : "");
            o.addProperty("address", c.getAddress() != null ? c.getAddress() : "");
            o.addProperty("companyName", c.getCompanyName() != null ? c.getCompanyName() : "");
            arr.add(o);
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(arr));
    }

    private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        int page = 1;
        int limit = 10;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        int offset = (page - 1) * limit;

        HttpSession session = request.getSession(false);
        java.util.Set<String> perms = session != null ? (java.util.Set<String>) session.getAttribute("userPermissions") : null;
        User currentUser = session != null ? (User) session.getAttribute("loggedUser") : null;

        Integer filterUserId = null;
        if (perms != null && !perms.contains("liquidations.approve_manager") && !perms.contains("liquidations.approve_ceo")) {
            if (currentUser != null) {
                filterUserId = currentUser.getId();
            }
        }

        int totalRecords = liquidationDAO.countTotal(search, statusFilter, filterUserId);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        List<Liquidation> list = liquidationDAO.findWithPagination(limit, offset, search, statusFilter, filterUserId);

        java.util.Map<String, Integer> kpis = liquidationDAO.getKpiCounts(filterUserId);
        int kpiPendingCeo = kpis.getOrDefault("PENDING_CEO", 0);
        int kpiApproved = kpis.getOrDefault("APPROVED_BY_CEO", 0);
        int kpiRequestEdit = kpis.getOrDefault("MANAGER_REQUEST_EDIT", 0) + kpis.getOrDefault("CEO_REQUEST_EDIT", 0);
        int kpiRejected = kpis.getOrDefault("REJECTED_BY_MANAGER", 0) + kpis.getOrDefault("REJECTED_BY_CEO", 0);

        request.setAttribute("kpiPendingCeo", kpiPendingCeo);
        request.setAttribute("kpiApproved", kpiApproved);
        request.setAttribute("kpiRequestEdit", kpiRequestEdit);
        request.setAttribute("kpiRejected", kpiRejected);

        request.setAttribute("liquidations", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/view/liquidation/liquidation-list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }

        Liquidation l = liquidationDAO.findById(id);
        request.setAttribute("liquidation", l);

        List<LiquidationDetail> details = detailDAO.findByLiquidationId(id);
        request.setAttribute("details", details);

        List<Category> managerRejectFeedbacks = categoryDAO.findByType("manager_reject_reason");
        List<Category> managerEditFeedbacks = categoryDAO.findByType("manager_request_edit_reason");
        List<Category> ceoRejectFeedbacks = categoryDAO.findByType("ceo_reject_reason");
        List<Category> ceoEditFeedbacks = categoryDAO.findByType("ceo_request_edit_reason");
        request.setAttribute("managerRejectFeedbacks", managerRejectFeedbacks);
        request.setAttribute("managerEditFeedbacks", managerEditFeedbacks);
        request.setAttribute("ceoRejectFeedbacks", ceoRejectFeedbacks);
        request.setAttribute("ceoEditFeedbacks", ceoEditFeedbacks);

        request.setAttribute("customers", customerDAO.findAll());

        HttpSession session = request.getSession(false);
        if (session != null) {
            Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
            boolean isManager = perms != null && perms.contains("liquidations.approve_manager");
            boolean isCeo = perms != null && perms.contains("liquidations.approve_ceo");
            boolean isStaff = perms != null && perms.contains("liquidations.create");
            request.setAttribute("isManager", isManager);
            request.setAttribute("isCeo", isCeo);
            request.setAttribute("isStaff", isStaff);
        }

        List<ActivityLog> history = activityLogDAO.findByEntityTypeAndId("liquidation", id, 1, 100);
        int totalHistory = activityLogDAO.countByEntityTypeAndId("liquidation", id);
        request.setAttribute("liquidationHistory", history);
        request.setAttribute("totalHistory", totalHistory);

        request.setAttribute("customerTypes", categoryDAO.findByType("customer_type"));
        request.getRequestDispatcher("/view/liquidation/liquidation-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        try {
            switch (action) {
                case "create_customer":
                    if (!perms.contains("liquidations.create")) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    handleCreateCustomerAjax(request, response, currentUser);
                    return;
                case "create":
                    if (!perms.contains("liquidations.create")) {
                        request.setAttribute("requiredPerm", "liquidations.create");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleCreate(request, response, currentUser);
                    break;
                case "edit_submit":
                    if (!perms.contains("liquidations.create")) {
                        request.setAttribute("requiredPerm", "liquidations.create");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleEditSubmit(request, response, currentUser);
                    break;
                case "approve_manager":
                    if (!perms.contains("liquidations.approve_manager")) {
                        request.setAttribute("requiredPerm", "liquidations.approve_manager");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleManagerApprove(request, response, currentUser);
                    break;
                case "approve_ceo":
                    if (!perms.contains("liquidations.approve_ceo")) {
                        request.setAttribute("requiredPerm", "liquidations.approve_ceo");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleCEOApprove(request, response, currentUser);
                    break;
                case "reject_manager":
                    if (!perms.contains("liquidations.approve_manager")) {
                        request.setAttribute("requiredPerm", "liquidations.approve_manager");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleManagerReject(request, response, currentUser, true);
                    break;
                case "request_edit_manager":
                    if (!perms.contains("liquidations.approve_manager")) {
                        request.setAttribute("requiredPerm", "liquidations.approve_manager");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleManagerReject(request, response, currentUser, false);
                    break;
                case "reject_ceo":
                    if (!perms.contains("liquidations.approve_ceo")) {
                        request.setAttribute("requiredPerm", "liquidations.approve_ceo");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleCEOReject(request, response, currentUser, true);
                    break;
                case "request_edit_ceo":
                    if (!perms.contains("liquidations.approve_ceo")) {
                        request.setAttribute("requiredPerm", "liquidations.approve_ceo");
                        request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                        return;
                    }
                    handleCEOReject(request, response, currentUser, false);
                    break;

            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/liquidations?error=1");
        }
    }

    private void handleCreateCustomerAjax(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        try {
            String name = request.getParameter("custName");
            String phone = request.getParameter("custPhone");
            String email = request.getParameter("custEmail");
            String address = request.getParameter("custAddress");
            String companyName = request.getParameter("custCompanyName");
            String typeIdStr = request.getParameter("custTypeId");

            if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                JsonObject err = new JsonObject();
                err.addProperty("success", false);
                err.addProperty("error", "Họ tên và SĐT là bắt buộc");
                out.write(gson.toJson(err));
                return;
            }
            if (customerDAO.isPhoneExists(phone.trim(), null)) {
                Customer existing = customerDAO.findByPhone(phone.trim());
                if (existing != null) {
                    out.write(gson.toJson(customerToJson(existing, true)));
                    return;
                }
            }
            Customer c = new Customer();
            c.setName(name.trim());
            c.setPhone(phone.trim());
            c.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
            c.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
            c.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName.trim() : null);
            if (typeIdStr != null && !typeIdStr.isEmpty()) {
                try {
                    c.setCustomerTypeId(Integer.parseInt(typeIdStr));
                } catch (NumberFormatException ignore) {
                }
            }
            c.setStatus("active");
            c.setCreatedBy(user.getId());
            int newId = customerDAO.insert(c);
            if (newId > 0) {
                c.setId(newId);
                out.write(gson.toJson(customerToJson(c, false)));
            } else {
                JsonObject err = new JsonObject();
                err.addProperty("success", false);
                err.addProperty("error", "Không thể lưu khách hàng");
                out.write(gson.toJson(err));
            }
        } catch (Exception e) {
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("error", e.getMessage() != null ? e.getMessage() : "");
            out.write(gson.toJson(err));
        }
    }

    private JsonObject customerToJson(Customer c, boolean existing) {
        JsonObject o = new JsonObject();
        o.addProperty("success", true);
        o.addProperty("existing", existing);
        o.addProperty("id", c.getId());
        o.addProperty("name", c.getName());
        o.addProperty("phone", c.getPhone());
        o.addProperty("email", c.getEmail() != null ? c.getEmail() : "");
        o.addProperty("address", c.getAddress() != null ? c.getAddress() : "");
        o.addProperty("companyName", c.getCompanyName() != null ? c.getCompanyName() : "");
        return o;
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int reasonId = Integer.parseInt(request.getParameter("reasonId"));
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        String[] generatorIds = request.getParameterValues("generatorId");
        String[] serialNumbers = request.getParameterValues("serialNumber");
        String[] liquidationPrices = request.getParameterValues("liquidationPrice");

        if (generatorIds == null || serialNumbers == null || generatorIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/liquidations?error=" + encode("Phải chọn ít nhất 1 máy", "UTF-8"));
            return;
        }

        if (generatorIds.length != serialNumbers.length
                || liquidationPrices == null || liquidationPrices.length != generatorIds.length) {
            response.sendRedirect(request.getContextPath() + "/liquidations?error=" + encode("Dữ liệu không hợp lệ", "UTF-8"));
            return;
        }

        // Parse + validate giá thanh lý từng máy (bắt buộc > 0)
        BigDecimal[] parsedPrices = new BigDecimal[liquidationPrices.length];
        for (int i = 0; i < liquidationPrices.length; i++) {
            String priceStr = liquidationPrices[i] == null ? "" : liquidationPrices[i].replaceAll("[^0-9]", "").trim();
            if (priceStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/liquidations?action=create&error="
                        + encode("Phải nhập giá thanh lý cho tất cả máy đã chọn", "UTF-8"));
                return;
            }
            BigDecimal price = new BigDecimal(priceStr);
            if (price.signum() <= 0) {
                response.sendRedirect(request.getContextPath() + "/liquidations?action=create&error="
                        + encode("Giá thanh lý phải lớn hơn 0", "UTF-8"));
                return;
            }
            parsedPrices[i] = price;
        }

        Set<String> uniqueSerials = new LinkedHashSet<>();
        for (String sn : serialNumbers) {
            uniqueSerials.add(sn);
        }
        if (uniqueSerials.size() != serialNumbers.length) {
            response.sendRedirect(request.getContextPath() + "/liquidations?error=" + encode("Có serial trùng trong phiếu", "UTF-8"));
            return;
        }

        // Resolve/tạo khách hàng — bắt buộc trước khi gửi Sếp duyệt
        Integer resolvedCustomerId = resolveCustomerFromRequest(request, user);
        if (resolvedCustomerId == null) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=create&error="
                    + encode("Phải chọn hoặc nhập Khách hàng (Tên + SĐT) trước khi gửi Sếp duyệt", "UTF-8"));
            return;
        }

        List<String> serialList = new ArrayList<>(uniqueSerials);

        //chỉ thành công khi tất cả serial đang IN_STOCK ở đúng warehouse.
        Connection conn = null;
        try {
            conn = inventoryDAO.getConnection();
            conn.setAutoCommit(false);

            int affected = inventoryDAO.claimInStockBatch(conn, serialList, warehouseId, InventoryDAO.STATUS_PENDING_LIQUIDATION);
            if (affected != serialList.size()) {
                List<String> bad = inventoryDAO.findUnavailableSerials(conn, serialList, warehouseId);
                conn.rollback();
                String msg = "Không tạo được phiếu — các serial sau đã bị giữ chỗ hoặc không thuộc kho này: "
                        + String.join(", ", bad);
                response.sendRedirect(request.getContextPath() + "/liquidations?action=create&error="
                        + java.net.URLEncoder.encode(msg, "UTF-8"));
                return;
            }

            // Quản lý kho tạo đơn đã kèm giá + khách hàng → gửi thẳng CEO duyệt.
            Liquidation l = new Liquidation();
            l.setLiquidationCode("LIQ" + System.currentTimeMillis());
            l.setCreatedBy(user.getId());
            l.setReasonId(reasonId);
            l.setWarehouseId(warehouseId);
            l.setStatus("PENDING_CEO");
            l.setCustomerId(resolvedCustomerId);
            l.setManagerReviewedBy(user.getId());
            l.setManagerReviewedAt(java.time.LocalDateTime.now());

            int insertedId = liquidationDAO.insert(l);
            if (insertedId <= 0) {
                conn.rollback();
                response.sendRedirect(request.getContextPath() + "/liquidations?error=" + java.net.URLEncoder.encode("Không lưu được phiếu thanh lý", "UTF-8"));
                return;
            }

            for (int i = 0; i < generatorIds.length; i++) {
                LiquidationDetail d = new LiquidationDetail();
                d.setLiquidationId(insertedId);
                d.setGeneratorId(Integer.parseInt(generatorIds[i]));
                d.setSerialNumber(serialNumbers[i]);
                BigDecimal poPrice = purchaseOrderDAO.findApprovedUnitPriceByGenerator(d.getGeneratorId());
                d.setOriginalPrice(poPrice != null ? poPrice : BigDecimal.ZERO);
                d.setLiquidationPrice(parsedPrices[i]);
                if (detailDAO.insert(d) <= 0) {
                    throw new Exception("Không lưu được dòng chi tiết cho serial " + serialNumbers[i]);
                }
            }

            conn.commit();

            // Đơn đi thẳng CEO → thông báo các CEO
            List<User> ceos = userDAO.findUsersByPermission("liquidations", "approve_ceo");
            for (User ceo : ceos) {
                NotificationService.send(
                        ceo.getId(),
                        "Đơn thanh lý chờ CEO duyệt",
                        "Quản lý " + user.getName() + " đã tạo và trình lên đơn thanh lý " + l.getLiquidationCode() + " cần CEO duyệt.",
                        request.getContextPath() + "/liquidations?action=detail&id=" + insertedId,
                        "liquidation",
                        insertedId
                );
            }

            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("liquidation");
            log.setAction("CREATE");
            log.setEntityId(insertedId);
            log.setEntityName(l.getLiquidationCode());
            log.setDetails("Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: " + l.getLiquidationCode());
            activityLogDAO.insert(log);

            response.sendRedirect(request.getContextPath() + "/liquidations");
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignored) {
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    // Resolve khách hàng từ request: ưu tiên customerId có sẵn, nếu không thì khớp theo SĐT
    // hoặc tạo mới từ (tên + SĐT + ...). Trả về null nếu không có đủ thông tin.
    private Integer resolveCustomerFromRequest(HttpServletRequest request, User user) throws Exception {
        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr != null && !customerIdStr.trim().isEmpty()) {
            try {
                return Integer.parseInt(customerIdStr.trim());
            } catch (NumberFormatException ignore) {
            }
        }

        String custName = request.getParameter("customerName");
        String custPhone = request.getParameter("customerPhone");
        if (custName == null || custName.trim().isEmpty()
                || custPhone == null || custPhone.trim().isEmpty()) {
            return null;
        }

        if (customerDAO.isPhoneExists(custPhone.trim(), null)) {
            Customer existing = customerDAO.findByPhone(custPhone.trim());
            if (existing != null) {
                return existing.getId();
            }
        }

        Customer c = new Customer();
        c.setName(custName.trim());
        c.setPhone(custPhone.trim());
        String email = request.getParameter("customerEmail");
        String address = request.getParameter("customerAddress");
        String company = request.getParameter("customerCompany");
        String typeIdStr = request.getParameter("customerTypeId");
        c.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        c.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
        c.setCompanyName(company != null && !company.trim().isEmpty() ? company.trim() : null);
        if (typeIdStr != null && !typeIdStr.trim().isEmpty()) {
            try {
                c.setCustomerTypeId(Integer.parseInt(typeIdStr.trim()));
            } catch (NumberFormatException ignore) {
            }
        }
        c.setStatus("active");
        c.setCreatedBy(user.getId());
        int newId = customerDAO.insert(c);
        return newId > 0 ? newId : null;
    }

    private void handleManagerApprove(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        String[] detailIds = request.getParameterValues("detailId");
        String[] liquidationPrices = request.getParameterValues("liquidationPrice");
        String customerIdStr = request.getParameter("customerId");

        if (detailIds != null) {
            if (liquidationPrices == null || liquidationPrices.length != detailIds.length) {
                response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                        + "&error=" + encode("Dữ liệu giá thanh lý không hợp lệ", "UTF-8"));
                return;
            }
            for (int i = 0; i < detailIds.length; i++) {
                String priceStr = liquidationPrices[i] == null ? "" : liquidationPrices[i].trim();
                if (priceStr.isEmpty()) {
                    continue;
                }
                LiquidationDetail d = new LiquidationDetail();
                d.setLiquidationDetailId(Integer.parseInt(detailIds[i]));
                d.setLiquidationPrice(new BigDecimal(priceStr));
                detailDAO.update(d);
            }
        }

        Integer resolvedCustomerId = null;
        if (customerIdStr != null && !customerIdStr.trim().isEmpty()) {
            try {
                resolvedCustomerId = Integer.parseInt(customerIdStr.trim());
            } catch (NumberFormatException ignore) {
            }
        }

        // Nếu chưa chọn KH có sẵn nhưng nhập KH mới (tên + SĐT) → tạo/khớp khách hàng
        if (resolvedCustomerId == null) {
            String custName = request.getParameter("customerName");
            String custPhone = request.getParameter("customerPhone");
            if (custName != null && !custName.trim().isEmpty()
                    && custPhone != null && !custPhone.trim().isEmpty()) {
                if (customerDAO.isPhoneExists(custPhone.trim(), null)) {
                    Customer existing = customerDAO.findByPhone(custPhone.trim());
                    if (existing != null) {
                        resolvedCustomerId = existing.getId();
                    }
                }
                if (resolvedCustomerId == null) {
                    Customer c = new Customer();
                    c.setName(custName.trim());
                    c.setPhone(custPhone.trim());
                    String email = request.getParameter("customerEmail");
                    String address = request.getParameter("customerAddress");
                    String company = request.getParameter("customerCompany");
                    String typeIdStr = request.getParameter("customerTypeId");
                    c.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
                    c.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
                    c.setCompanyName(company != null && !company.trim().isEmpty() ? company.trim() : null);
                    if (typeIdStr != null && !typeIdStr.trim().isEmpty()) {
                        try {
                            c.setCustomerTypeId(Integer.parseInt(typeIdStr.trim()));
                        } catch (NumberFormatException ignore) {
                        }
                    }
                    c.setStatus("active");
                    c.setCreatedBy(user.getId());
                    int newId = customerDAO.insert(c);
                    if (newId > 0) {
                        resolvedCustomerId = newId;
                    }
                }
            }
        }

        if (resolvedCustomerId == null) {
            throw new Exception("Quản lý kho phải chọn hoặc nhập Khách hàng (Tên + SĐT) trước khi gửi Sếp duyệt.");
        }
        liquidationDAO.updateCustomer(liquidationId, resolvedCustomerId);

        liquidationDAO.updateStatus(liquidationId, "PENDING_CEO", user.getId(), "manager", null);

        Liquidation l = liquidationDAO.findById(liquidationId);

        NotificationService.send(
                l.getCreatedBy(),
                "Quản lý đã duyệt đơn thanh lý",
                "Đơn thanh lý " + l.getLiquidationCode() + " đã được quản lý " + user.getName() + " duyệt.",
                request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId,
                "liquidation",
                liquidationId
        );

        List<User> ceos = userDAO.findUsersByPermission("liquidations", "approve_ceo");
        for (User ceo : ceos) {
            NotificationService.send(
                    ceo.getId(),
                    "Đơn thanh lý chờ CEO duyệt",
                    "Quản lý " + user.getName() + " đã trình lên đơn thanh lý " + l.getLiquidationCode() + " cần CEO duyệt.",
                    request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId,
                    "liquidation",
                    liquidationId
            );
        }
        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("liquidation");
        log.setAction("MANAGER_APPROVE");
        log.setEntityId(liquidationId);
        log.setEntityName(l.getLiquidationCode());
        log.setDetails("Quản lý kho cập nhật giá, thêm khách hàng và trình lên CEO");
        activityLogDAO.insert(log);

        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void handleCEOApprove(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        Liquidation l = liquidationDAO.findById(liquidationId);
        if (l == null) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }

        List<LiquidationDetail> details = detailDAO.findByLiquidationId(liquidationId);
        if (details.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                    + "&error=" + encode("Don thanh ly khong co dong chi tiet", "UTF-8"));
            return;
        }

        // Resolve inventory_id cho tung serial truoc khi ghi DB (fail fast neu thieu)
        java.util.LinkedHashMap<Integer, LiquidationDetail> inventoryMap = new java.util.LinkedHashMap<>();
        for (LiquidationDetail d : details) {
            Inventory inv = inventoryDAO.findBySerialNumber(d.getSerialNumber());
            if (inv == null) {
                response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                        + "&error=" + encode("Khong tim thay serial: " + d.getSerialNumber(), "UTF-8"));
                return;
            }
            inventoryMap.put(inv.getInventoryId(), d);
        }

        Receipt r = new Receipt();
        r.setReceiptCode("PX-LIQ-" + System.currentTimeMillis());
        r.setReceiptType("EXPORT");
        r.setWarehouseId(l.getWarehouseId());
        r.setCreatedBy(l.getCreatedBy());
        r.setStatus("PENDING");
        r.setNote("Phieu xuat cho don thanh ly ID: " + liquidationId);
        r.setReasonId(l.getReasonId());

        // Transaction: tao receipt + insert receipt_detail + chuyen inventory PENDING_LIQUIDATION -> RESERVED_EXPORT
        int newReceiptId;
        Connection conn = null;
        try {
            conn = inventoryDAO.getConnection();
            conn.setAutoCommit(false);
            newReceiptId = receiptDAO.insert(conn, r);
            if (newReceiptId <= 0) {
                conn.rollback();
                response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                        + "&error=" + encode("Khong tao duoc phieu xuat", "UTF-8"));
                return;
            }

            List<ReceiptDetail> rdList = new ArrayList<>();
            for (Map.Entry<Integer, LiquidationDetail> e : inventoryMap.entrySet()) {
                LiquidationDetail d = e.getValue();
                ReceiptDetail rd = new ReceiptDetail();
                rd.setReceiptId(newReceiptId);
                rd.setInventoryId(e.getKey());
                rd.setNote("Thanh ly gia: " + d.getLiquidationPrice());
                rdList.add(rd);

                inventoryDAO.updateStatusBySerial(conn, d.getSerialNumber(), InventoryDAO.STATUS_RESERVED_EXPORT);
            }
            receiptDetailDAO.batchInsert(conn, rdList);

            conn.commit();
        } catch (Exception ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            throw ex;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
            }
        }

        liquidationDAO.updateStatus(liquidationId, "APPROVED_BY_CEO", user.getId(), "ceo", newReceiptId);

        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("receipt");
        log.setAction("AUTO_CREATE");
        log.setEntityId(newReceiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails("He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly " + l.getLiquidationCode());
        activityLogDAO.insert(log);

        NotificationService.send(
                l.getCreatedBy(),
                "CEO da duyet don thanh ly",
                "Don thanh ly " + l.getLiquidationCode() + " da duoc CEO duyet va chuyen sang cho xuat kho.",
                request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId,
                "liquidation",
                liquidationId
        );

        ActivityLog liqLog = new ActivityLog();
        liqLog.setUserId(user.getId());
        liqLog.setEntityType("liquidation");
        liqLog.setAction("CEO_APPROVE");
        liqLog.setEntityId(liquidationId);
        liqLog.setEntityName(l.getLiquidationCode());
        liqLog.setDetails("CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: " + r.getReceiptCode());
        activityLogDAO.insert(liqLog);

        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void handleCEOReject(HttpServletRequest request, HttpServletResponse response, User user, boolean isPermanent) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        int feedbackId = Integer.parseInt(request.getParameter("ceoFeedbackId"));

        liquidationDAO.updateCeoReject(liquidationId, user.getId(), feedbackId, isPermanent);

        Liquidation l = liquidationDAO.findById(liquidationId);
        if (l == null) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }
        if (isPermanent) {
            List<LiquidationDetail> details = detailDAO.findByLiquidationId(liquidationId);
            List<String> serials = new ArrayList<>();
            for (LiquidationDetail d : details) {
                serials.add(d.getSerialNumber());
            }
            if (!serials.isEmpty()) {
                Connection conn = null;
                try {
                    conn = inventoryDAO.getConnection();
                    conn.setAutoCommit(false);
                    inventoryDAO.updateStatusBatch(conn, serials, InventoryDAO.STATUS_IN_STOCK);
                    conn.commit();
                } catch (Exception ex) {
                    if (conn != null) try { conn.rollback(); } catch (Exception ignored) {}
                    throw ex;
                } finally {
                    if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
                }
            }
        }

        NotificationService.send(
                l.getCreatedBy(),
                isPermanent ? "CEO từ chối đơn thanh lý" : "CEO yêu cầu sửa đơn thanh lý",
                isPermanent
                        ? "Đơn " + l.getLiquidationCode() + " đã bị CEO từ chối và huỷ."
                        : "Đơn " + l.getLiquidationCode() + " bị CEO yêu cầu sửa lại.",
                request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId,
                "liquidation",
                liquidationId
        );
        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("liquidation");
        log.setAction(isPermanent ? "REJECTED_BY_CEO" : "CEO_REQUEST_EDIT");
        log.setEntityId(liquidationId);
        log.setEntityName(l.getLiquidationCode());
        log.setDetails(isPermanent ? "CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn" : "CEO yêu cầu sửa đơn thanh lý");
        activityLogDAO.insert(log);

        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void handleManagerReject(HttpServletRequest request, HttpServletResponse response, User user, boolean isPermanent) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        int feedbackId = Integer.parseInt(request.getParameter("managerFeedbackId"));

        liquidationDAO.updateManagerReject(liquidationId, user.getId(), feedbackId, isPermanent);

        Liquidation l = liquidationDAO.findById(liquidationId);
        if (l == null) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }
        if (isPermanent) {
            List<LiquidationDetail> details = detailDAO.findByLiquidationId(liquidationId);
            List<String> serials = new ArrayList<>();
            for (LiquidationDetail d : details) {
                serials.add(d.getSerialNumber());
            }
            if (!serials.isEmpty()) {
                Connection conn = null;
                try {
                    conn = inventoryDAO.getConnection();
                    conn.setAutoCommit(false);
                    inventoryDAO.updateStatusBatch(conn, serials, InventoryDAO.STATUS_IN_STOCK);
                    conn.commit();
                } catch (Exception ex) {
                    if (conn != null) try { conn.rollback(); } catch (Exception ignored) {}
                    throw ex;
                } finally {
                    if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
                }
            }
        }

        NotificationService.send(
                l.getCreatedBy(),
                isPermanent ? "Quản lý từ chối đơn thanh lý" : "Quản lý yêu cầu sửa đơn thanh lý",
                isPermanent
                        ? "Đơn " + l.getLiquidationCode() + " đã bị Quản lý kho từ chối và huỷ."
                        : "Đơn " + l.getLiquidationCode() + " bị Quản lý kho yêu cầu sửa lại.",
                request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId,
                "liquidation",
                liquidationId
        );
        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("liquidation");
        log.setAction(isPermanent ? "REJECTED_BY_MANAGER" : "MANAGER_REQUEST_EDIT");
        log.setEntityId(liquidationId);
        log.setEntityName(l.getLiquidationCode());
        log.setDetails(isPermanent ? "Quản lý từ chối và huỷ bỏ đơn thanh lý vĩnh viễn" : "Quản lý yêu cầu sửa đơn thanh lý");
        activityLogDAO.insert(log);

        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void showEditView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }
        Liquidation l = liquidationDAO.findById(id);
        if (l == null) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }

        if (!"MANAGER_REQUEST_EDIT".equals(l.getStatus()) && !"CEO_REQUEST_EDIT".equals(l.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + id);
            return;
        }

        request.setAttribute("liquidation", l);
        List<LiquidationDetail> details = detailDAO.findByLiquidationId(id);
        request.setAttribute("details", details);

        // Cho phép đổi kho: nhận warehouseId qua GET; nếu khác kho gốc thì hiện máy kho mới
        // và KHÔNG giữ lại các máy đã chọn (chúng thuộc kho cũ).
        int orderWhId = l.getWarehouseId();
        Integer paramWh = null;
        String whParam = request.getParameter("warehouseId");
        if (whParam != null && !whParam.trim().isEmpty()) {
            try {
                paramWh = Integer.parseInt(whParam.trim());
            } catch (NumberFormatException ignore) {
            }
        }
        int whId = (paramWh != null) ? paramWh : orderWhId;
        boolean sameWarehouse = (whId == orderWhId);
        request.setAttribute("selectedWarehouseId", whId);

        Set<String> selectedSerials = new LinkedHashSet<>();
        if (sameWarehouse) {
            for (LiquidationDetail d : details) {
                selectedSerials.add(d.getSerialNumber());
            }
        }

        List<Inventory> inStock = inventoryDAO.findInStockByWarehouse(whId);

        // Danh sách máy phẳng (giữ thứ tự DAO đã sắp Hỏng->Kém->Tốt), tick sẵn máy đã có trong đơn
        List<Map<String, Object>> pickRows = buildPickRows(inStock, selectedSerials);

        // Chỉ khi xem đúng kho gốc mới bổ sung các máy đã có trong đơn nhưng không còn IN_STOCK
        // (đang giữ chỗ PENDING_LIQUIDATION cho đơn này).
        if (sameWarehouse) {
            Set<String> inStockSerials = new LinkedHashSet<>();
            for (Inventory inv : inStock) {
                inStockSerials.add(inv.getSerialNumber());
            }
            List<String> missingSerials = new ArrayList<>();
            for (LiquidationDetail d : details) {
                if (!inStockSerials.contains(d.getSerialNumber())) {
                    missingSerials.add(d.getSerialNumber());
                }
            }
            Map<String, String> condBySerial = inventoryDAO.findLatestConditionBySerials(missingSerials);
            for (LiquidationDetail d : details) {
                if (!inStockSerials.contains(d.getSerialNumber())) {
                    BigDecimal price;
                    try {
                        price = purchaseOrderDAO.findApprovedUnitPriceByGenerator(d.getGeneratorId());
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        price = null;
                    }
                    Map<String, Object> r = new HashMap<>();
                    r.put("serialNumber", d.getSerialNumber());
                    r.put("generatorId", d.getGeneratorId());
                    r.put("model", d.getGeneratorModelName());
                    r.put("unitPrice", price != null ? price : BigDecimal.ZERO);
                    r.put("condition", condBySerial.get(d.getSerialNumber()));
                    r.put("createdAtStr", "");
                    r.put("selected", true);
                    pickRows.add(r);
                }
            }
        }
        request.setAttribute("pickRows", pickRows);

        List<Category> reasons = categoryDAO.findByType("liquidation_reason");
        request.setAttribute("reasons", reasons);
        GeneratorDAO genDAO = new GeneratorDAO();
        request.setAttribute("generators", genDAO.findAll());
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("customerTypes", categoryDAO.findByType("customer_type"));

        request.getRequestDispatcher("/view/liquidation/liquidation-edit.jsp").forward(request, response);
    }

    private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        int reasonId = Integer.parseInt(request.getParameter("reasonId"));
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        String[] generatorIds = request.getParameterValues("generatorId");
        String[] serialNumbers = request.getParameterValues("serialNumber");

        Liquidation l = liquidationDAO.findById(liquidationId);
        if (l == null || (!"MANAGER_REQUEST_EDIT".equals(l.getStatus()) && !"CEO_REQUEST_EDIT".equals(l.getStatus()))) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }

        if (generatorIds == null || serialNumbers == null || generatorIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                    + "&error=" + java.net.URLEncoder.encode("Phải chọn ít nhất 1 máy", "UTF-8"));
            return;
        }

        if (generatorIds.length != serialNumbers.length) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                    + "&error=" + java.net.URLEncoder.encode("Dữ liệu không hợp lệ", "UTF-8"));
            return;
        }

        Set<String> uniqueSerials = new LinkedHashSet<>();
        for (String sn : serialNumbers) {
            uniqueSerials.add(sn);
        }
        if (uniqueSerials.size() != serialNumbers.length) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId
                    + "&error=" + java.net.URLEncoder.encode("Có serial trùng trong phiếu", "UTF-8"));
            return;
        }
        List<String> newSerialList = new ArrayList<>(uniqueSerials);

        Connection conn = null;
        try {
            conn = inventoryDAO.getConnection();
            conn.setAutoCommit(false);

            // Trả lại trạng thái cũ (PENDING_LIQUIDATION -> IN_STOCK) cho serials cũ
            List<LiquidationDetail> oldDetails = detailDAO.findByLiquidationId(liquidationId);
            List<String> oldSerials = new ArrayList<>();
            for (LiquidationDetail oldD : oldDetails) {
                oldSerials.add(oldD.getSerialNumber());
            }
            if (!oldSerials.isEmpty()) {
                inventoryDAO.updateStatusBatch(conn, oldSerials, InventoryDAO.STATUS_IN_STOCK);
            }

            int affected = inventoryDAO.claimInStockBatch(conn, newSerialList, warehouseId, InventoryDAO.STATUS_PENDING_LIQUIDATION);
            if (affected != newSerialList.size()) {
                List<String> bad = inventoryDAO.findUnavailableSerials(conn, newSerialList, warehouseId);
                conn.rollback();
                String msg = "Không lưu được — các serial sau đã bị giữ chỗ hoặc không thuộc kho này: "
                        + String.join(", ", bad);
                response.sendRedirect(request.getContextPath() + "/liquidations?action=edit_view&id=" + liquidationId
                        + "&error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                return;
            }

            String targetStatus = "CEO_REQUEST_EDIT".equals(l.getStatus()) ? "PENDING_CEO" : "PENDING_MANAGER";
            boolean updated = liquidationDAO.updateReasonAndStatus(conn, liquidationId, reasonId, targetStatus);
            if (!updated) {
                conn.rollback();
                response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
                return;
            }

            String customerIdStr = request.getParameter("customerId");
            Integer newCustomerId = null;
            if (customerIdStr != null && !customerIdStr.trim().isEmpty()) {
                try {
                    newCustomerId = Integer.parseInt(customerIdStr.trim());
                } catch (NumberFormatException ignore) {
                }
            }
            String updateWarehouseSql = "UPDATE liquidation SET warehouse_id = ?, customer_id = ? WHERE liquidation_id = ?";
            try (PreparedStatement p = conn.prepareStatement(updateWarehouseSql)) {
                p.setInt(1, warehouseId);
                if (newCustomerId != null) {
                    p.setInt(2, newCustomerId);
                } else {
                    p.setNull(2, java.sql.Types.INTEGER);
                }
                p.setInt(3, liquidationId);
                p.executeUpdate();
            }

            detailDAO.deleteByLiquidationId(conn, liquidationId);
            for (int i = 0; i < generatorIds.length; i++) {
                LiquidationDetail d = new LiquidationDetail();
                d.setLiquidationId(liquidationId);
                d.setGeneratorId(Integer.parseInt(generatorIds[i]));
                d.setSerialNumber(serialNumbers[i]);
                BigDecimal poPrice = purchaseOrderDAO.findApprovedUnitPriceByGenerator(d.getGeneratorId());
                d.setOriginalPrice(poPrice != null ? poPrice : BigDecimal.ZERO);
                if (detailDAO.insert(conn, d) <= 0) {
                    throw new Exception("Không lưu được dòng chi tiết cho serial " + serialNumbers[i]);
                }
            }

            conn.commit();

            boolean wasCeoEdit = "CEO_REQUEST_EDIT".equals(l.getStatus());
            String targetAction = wasCeoEdit ? "approve_ceo" : "approve_manager";
            String notifTitle = wasCeoEdit
                    ? "Đơn thanh lý " + l.getLiquidationCode() + " đã được sửa lại — chờ Sếp duyệt"
                    : "Đơn thanh lý " + l.getLiquidationCode() + " đã được sửa lại — chờ Quản lý duyệt";
            String notifMsg = "Nhân viên " + user.getName() + " đã cập nhật lại đơn thanh lý theo yêu cầu sửa.";
            List<User> reviewers = userDAO.findUsersByPermission("liquidations", targetAction);
            for (User rv : reviewers) {
                NotificationService.send(
                        rv.getId(),
                        notifTitle,
                        notifMsg,
                        request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId,
                        "liquidation",
                        liquidationId
                );
            }
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("liquidation");
            log.setAction("EDIT_SUBMIT");
            log.setEntityId(liquidationId);
            log.setEntityName(l.getLiquidationCode());
            log.setDetails("Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu");
            activityLogDAO.insert(log);

            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignored) {
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}