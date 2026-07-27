package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.CustomerDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.InventoryCheckDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDAO;
import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.SaleOrderDAO;
import com.quanlymayphatdien.g1.dal.StockCardDAO;
import com.quanlymayphatdien.g1.dal.SupplierDAO;
import com.quanlymayphatdien.g1.dal.TransferDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.GeneratorSummary;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.Role;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.entity.Transfer;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardController", urlPatterns = {"/admin/dashboard"})
public class DashboardController extends HttpServlet {

    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final GeneratorDAO generatorDAO = new GeneratorDAO();
    private final SaleOrderDAO saleOrderDAO = new SaleOrderDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final PermissionDAO permissionDAO = new PermissionDAO();
    private final TransferDAO transferDAO = new TransferDAO();
    private final LiquidationDAO liquidationDAO = new LiquidationDAO();
    private final PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();
    private final InventoryCheckDAO inventoryCheckDAO = new InventoryCheckDAO();
    private final ImportProposalDAO importProposalDAO = new ImportProposalDAO();
    private final StockCardDAO stockCardDAO = new StockCardDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        User loggedUser = (User) session.getAttribute("loggedUser");
        @SuppressWarnings("unchecked")
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");

        Set<String> roleNames = new HashSet<>();
        if (loggedUser.getRoles() != null) {
            for (Role r : loggedUser.getRoles()) {
                roleNames.add(r.getRoleName());
            }
        }
        request.setAttribute("userRoleNames", roleNames);
        request.setAttribute("isSalesStaff", roleNames.contains("sales_staff"));
        request.setAttribute("isSalesManager", roleNames.contains("sales_manager") || roleNames.contains("sale_manager"));
        request.setAttribute("isCeo", roleNames.contains("ceo"));
        request.setAttribute("isAdmin", roleNames.contains("admin"));
        request.setAttribute("isWarehouse", roleNames.contains("warehouse_manager") || roleNames.contains("warehouse_staff"));
        request.setAttribute("isWarehouseManager", roleNames.contains("warehouse_manager"));
        request.setAttribute("isWarehouseStaff", roleNames.contains("warehouse_staff"));

        int userId = loggedUser.getId();
        Integer warehouseId = loggedUser.getWarehouseId();
        LocalDate now = LocalDate.now();
        LocalDate firstOfMonth = now.withDayOfMonth(1);
        LocalDate twelveMonthsAgo = now.minusMonths(11).withDayOfMonth(1);

        // Read time range for charts
        String rangeParam = request.getParameter("range");
        int rangeDays = 14;
        if ("7".equals(rangeParam)) rangeDays = 7;
        else if ("30".equals(rangeParam)) rangeDays = 30;
        else if ("365".equals(rangeParam)) rangeDays = 365;
        request.setAttribute("chartRange", rangeParam != null ? rangeParam : "14");

        request.setAttribute("totalInStock", inventoryDAO.grandTotalInStock());
        request.setAttribute("activeWarehouses", inventoryDAO.countActiveWarehouses());
        request.setAttribute("totalGenerators", generatorDAO.countByStatus("active"));

        loadAdminData(request, perms);
        loadCustomerSupplierData(request, perms);
        loadSalesData(request, perms, roleNames, userId);
        loadWarehouseData(request, perms, roleNames, warehouseId, userId, firstOfMonth, now, twelveMonthsAgo);
        loadCeoData(request, roleNames, userId);
        loadAdminExtendedData(request, roleNames);

        // Fetch detailed model inventory for template table with pagination
        String stockStatus = request.getParameter("stockStatus");
        if (stockStatus == null || stockStatus.isEmpty()) {
            stockStatus = "all";
        }
        int summaryPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                summaryPage = Integer.parseInt(pageParam);
                if (summaryPage < 1) summaryPage = 1;
            } catch (NumberFormatException e) {
                summaryPage = 1;
            }
        }
        int pageSize = 10;

        String effectiveStatus = "all".equals(stockStatus) ? null : stockStatus;
        int totalItems = inventoryDAO.countGeneratorSummary(warehouseId, null, null, effectiveStatus);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (summaryPage > totalPages && totalPages > 0) summaryPage = totalPages;

        List<GeneratorSummary> modelSummaries = inventoryDAO.findGeneratorSummary(
                warehouseId, null, null, effectiveStatus, summaryPage, pageSize);
        request.setAttribute("modelSummaries", modelSummaries);

        int lowStockCount = inventoryDAO.countGeneratorSummary(warehouseId, null, null, "low");
        int outOfStockCount = inventoryDAO.countGeneratorSummary(warehouseId, null, null, "out");
        request.setAttribute("lowStockModelsCount", lowStockCount);
        request.setAttribute("outOfStockModelsCount", outOfStockCount);

        int fromIndex = (summaryPage - 1) * pageSize + 1;
        int toIndex = Math.min(summaryPage * pageSize, totalItems);
        request.setAttribute("currentPage", summaryPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("currentStockStatus", stockStatus);

        Object stockObj = request.getAttribute("totalInStock");
        long grandInStock = (stockObj instanceof Number) ? ((Number) stockObj).longValue() : 0L;
        double estimatedValueBillion = (grandInStock * 150000000.0) / 1000000000.0;
        request.setAttribute("totalStockValue", String.format(java.util.Locale.US, "%.2f tỷ ₫", estimatedValueBillion));

        Object pLiqObj = request.getAttribute("pendingLiquidations");
        Object pTransObj = request.getAttribute("pendingTransfers");
        Object pPosObj = request.getAttribute("pendingPOs");
        int pLiq = (pLiqObj instanceof Number) ? ((Number) pLiqObj).intValue() : 0;
        int pTrans = (pTransObj instanceof Number) ? ((Number) pTransObj).intValue() : 0;
        int pPos = (pPosObj instanceof Number) ? ((Number) pPosObj).intValue() : 0;
        int totalPendingApprovals = pLiq + pTrans + pPos;
        request.setAttribute("pendingApprovalsCount", totalPendingApprovals);

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        request.setAttribute("todayFormattedDate", now.format(dtf));

        // Determine available dashboard roles for this user
        List<String> availableDashboardRoles = new ArrayList<>();
        if (roleNames.contains("ceo")) {
            availableDashboardRoles.add("ceo");
        }
        if (roleNames.contains("admin")) {
            availableDashboardRoles.add("admin");
        }
        if (roleNames.contains("warehouse_manager") || roleNames.contains("warehouse_staff")) {
            availableDashboardRoles.add("warehouse");
        }
        if (roleNames.contains("sales_manager") || roleNames.contains("sale_manager") || roleNames.contains("sales_staff")) {
            availableDashboardRoles.add("sales");
        }
        if (availableDashboardRoles.isEmpty()) {
            availableDashboardRoles.add("sales");
        }

        // Determine active role
        String viewRole = request.getParameter("viewRole");
        String activeRole = null;
        if (viewRole != null && availableDashboardRoles.contains(viewRole)) {
            activeRole = viewRole;
        } else {
            // Priority: ceo > admin > warehouse > sales
            if (availableDashboardRoles.contains("ceo")) {
                activeRole = "ceo";
            } else if (availableDashboardRoles.contains("admin")) {
                activeRole = "admin";
            } else if (availableDashboardRoles.contains("warehouse")) {
                activeRole = "warehouse";
            } else {
                activeRole = "sales";
            }
        }

        request.setAttribute("activeRole", activeRole);
        request.setAttribute("availableDashboardRoles", availableDashboardRoles);

        String targetJsp;
        switch (activeRole) {
            case "ceo":
                targetJsp = "/view/dashboard/ceo-dashboard.jsp";
                break;
            case "admin":
                targetJsp = "/view/dashboard/admin-dashboard.jsp";
                break;
            case "warehouse":
                targetJsp = "/view/dashboard/warehouse-dashboard.jsp";
                break;
            case "sales":
                targetJsp = "/view/dashboard/sales-dashboard.jsp";
                break;
            default:
                targetJsp = "/view/admin/admin-dashboard.jsp";
                break;
        }

        request.getRequestDispatcher(targetJsp).forward(request, response);
    }

    private void loadAdminData(HttpServletRequest request, Set<String> perms) {
        if (perms == null || !perms.contains("users.view")) {
            return;
        }
        try {
            int activeCnt = userDAO.countUsersByStatus("active");
            int lockedCnt = userDAO.countUsersByStatus("locked");
            request.setAttribute("activeUsers", activeCnt);
            request.setAttribute("lockedUsers", lockedCnt);
            request.setAttribute("totalRoles", roleDAO.findAll().size());
            request.setAttribute("totalPermissions", permissionDAO.findAll().size());

            List<User> allUsers = userDAO.findAll();
            request.setAttribute("allUsersList", allUsers != null ? allUsers : new ArrayList<>());

            List<User> recentUsers = new ArrayList<>();
            if (allUsers != null && !allUsers.isEmpty()) {
                recentUsers = allUsers.subList(0, Math.min(6, allUsers.size()));
            }
            request.setAttribute("recentUsers", recentUsers);
        } catch (Exception e) {
            System.err.println("loadAdminData error: " + e.getMessage());
        }
    }

    private void loadCustomerSupplierData(HttpServletRequest request, Set<String> perms) {
        try {
            request.setAttribute("activeCustomers", customerDAO.countByStatus("active"));
            request.setAttribute("activeSuppliers", supplierDAO.countByStatus("active"));
            List<com.quanlymayphatdien.g1.entity.Customer> recentCustomers = customerDAO.searchByKeyword(null);
            if (recentCustomers != null && recentCustomers.size() > 6) {
                recentCustomers = recentCustomers.subList(0, 6);
            }
            request.setAttribute("recentCustomers", recentCustomers);
        } catch (Exception e) {
            request.setAttribute("activeCustomers", 0);
            request.setAttribute("activeSuppliers", 0);
        }
    }

    private void loadSalesData(HttpServletRequest request, Set<String> perms, Set<String> roleNames, int userId) {
        try {
            int today = saleOrderDAO.countTodayOrders();
            request.setAttribute("todayOrders", today);

            int pending = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_PENDING, 0, userId);
            int approved = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_APPROVED, 0, userId);
            int completed = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_COMPLETED, 0, userId);
            int rejected = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_REJECTED, 0, userId);
            int cancelled = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_CANCELLED, 0, userId);

            request.setAttribute("pendingOrders", pending);
            request.setAttribute("approvedOrders", approved);
            request.setAttribute("completedOrders", completed);
            request.setAttribute("rejectedOrders", rejected);
            request.setAttribute("cancelledOrders", cancelled);

            Map<String, Integer> orderStatusMap = new LinkedHashMap<>();
            orderStatusMap.put("PENDING", pending);
            orderStatusMap.put("APPROVED", approved);
            orderStatusMap.put("COMPLETED", completed);
            orderStatusMap.put("REJECTED", rejected);
            orderStatusMap.put("CANCELLED", cancelled);
            request.setAttribute("orderStatusMap", orderStatusMap);

            List<Map<String, Object>> donutSegments = new ArrayList<>();
            int total = pending + approved + completed + rejected + cancelled;
            if (total > 0) {
                double circumference = 2.0 * Math.PI * 80.0;
                String[] statuses = {"PENDING", "APPROVED", "COMPLETED", "REJECTED", "CANCELLED"};
                int[] counts = {pending, approved, completed, rejected, cancelled};
                String[] colors = {"var(--warn)", "var(--info)", "var(--accent)", "var(--danger)", "var(--muted-2)"};
                double cumulative = 0;
                for (int i = 0; i < statuses.length; i++) {
                    if (counts[i] == 0) continue;
                    double dashLen = (counts[i] / (double) total) * circumference;
                    Map<String, Object> seg = new LinkedHashMap<>();
                    seg.put("status", statuses[i]);
                    seg.put("count", counts[i]);
                    seg.put("dashLen", Math.round(dashLen * 100.0) / 100.0);
                    seg.put("gap", Math.round((circumference - dashLen) * 100.0) / 100.0);
                    seg.put("dashOffset", Math.round(-cumulative * 100.0) / 100.0);
                    seg.put("color", colors[i]);
                    donutSegments.add(seg);
                    cumulative += dashLen;
                }
            }
            request.setAttribute("donutSegments", donutSegments);
            request.setAttribute("donutTotal", total);

            int myPending = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_PENDING, userId, userId);
            int myApproved = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_APPROVED, userId, userId);
            int myCompleted = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_COMPLETED, userId, userId);
            int myCancelled = saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_CANCELLED, userId, userId);

            request.setAttribute("myPendingOrders", myPending);
            request.setAttribute("myApprovedOrders", myApproved);
            request.setAttribute("myCompletedOrders", myCompleted);
            request.setAttribute("myCancelledOrders", myCancelled);

            List<Map<String, Object>> myDonutSegments = new ArrayList<>();
            int myTotal = myPending + myApproved + myCompleted + myCancelled;
            if (myTotal > 0) {
                double circ = 2.0 * Math.PI * 78.0;
                String[] sts = {"PENDING", "APPROVED", "COMPLETED", "CANCELLED"};
                int[] cts = {myPending, myApproved, myCompleted, myCancelled};
                String[] cls = {"var(--warn)", "var(--info)", "var(--accent)", "var(--muted-2)"};
                double cum = 0;
                for (int i = 0; i < sts.length; i++) {
                    if (cts[i] == 0) continue;
                    double dl = (cts[i] / (double) myTotal) * circ;
                    Map<String, Object> sg = new LinkedHashMap<>();
                    sg.put("status", sts[i]);
                    sg.put("count", cts[i]);
                    sg.put("dashLen", Math.round(dl * 100.0) / 100.0);
                    sg.put("gap", Math.round((circ - dl) * 100.0) / 100.0);
                    sg.put("dashOffset", Math.round(-cum * 100.0) / 100.0);
                    sg.put("color", cls[i]);
                    myDonutSegments.add(sg);
                    cum += dl;
                }
            }
            request.setAttribute("myDonutSegments", myDonutSegments);
            request.setAttribute("myDonutTotal", myTotal);

            boolean isSalesManagerRole = roleNames != null
                    && (roleNames.contains("sales_manager") || roleNames.contains("sale_manager"));
            boolean isSalesStaffRole = roleNames != null && roleNames.contains("sales_staff");

            if (isSalesManagerRole) {
                request.setAttribute("poPendingCeoCount",
                        purchaseOrderDAO.countByFilters(null, null, 0, GlobalUtils.PO_STATUS_PENDING_CEO));
                request.setAttribute("proposalsPendingApproval",
                        importProposalDAO.countByStatus(GlobalUtils.STATUS_PENDING, null, null, null, userId));
                request.setAttribute("recentProposalsForApproval",
                        importProposalDAO.searchByFilters(
                                GlobalUtils.STATUS_PENDING, null, null, null, null, null, userId, null, 1, 5));
                request.setAttribute("approvedOrdersThisMonth",
                        saleOrderDAO.countOrderByStatus(GlobalUtils.STATUS_APPROVED, 0, userId));
            }

            if (isSalesStaffRole) {
                request.setAttribute("myProposalCount",
                        importProposalDAO.countByStatus(null, userId, null, null, userId));
                request.setAttribute("myRecentProposals",
                        importProposalDAO.searchByFilters(null, null, userId, null, null, null, userId, null, 1, 5));
                List<SaleOrder> myRecentSaleOrders = saleOrderDAO.searchByNameCode(null, null, userId, userId);
                if (myRecentSaleOrders != null && myRecentSaleOrders.size() > 5) {
                    myRecentSaleOrders = myRecentSaleOrders.subList(0, 5);
                }
                request.setAttribute("myRecentSaleOrders",
                        myRecentSaleOrders != null ? myRecentSaleOrders : new ArrayList<>());
                request.setAttribute("myNeedsRevision",
                        importProposalDAO.countByStatus(GlobalUtils.STATUS_NEEDS_REVISION, userId, null, null, userId));
            }
        } catch (Exception e) {
            System.err.println("DashboardController loadSalesData error: " + e.getMessage());
        }
    }

    private void loadWarehouseData(HttpServletRequest request, Set<String> perms, Set<String> roleNames,
            Integer warehouseId, int userId, LocalDate firstOfMonth, LocalDate now, LocalDate twelveMonthsAgo) {
        if (perms == null || (!perms.contains("warehouses.view") && !perms.contains("receipts.view") && !roleNames.contains("ceo"))) {
            return;
        }

        Map<String, Object> importSummary = receiptDAO.getReportSummary(firstOfMonth, now, warehouseId, "IMPORT");
        Map<String, Object> exportSummary = receiptDAO.getReportSummary(firstOfMonth, now, warehouseId, "EXPORT");
        int importCount = importSummary != null ? ((Number) importSummary.getOrDefault("totalReceipts", 0)).intValue() : 0;
        int exportCount = exportSummary != null ? ((Number) exportSummary.getOrDefault("totalReceipts", 0)).intValue() : 0;
        request.setAttribute("importCount", importCount);
        request.setAttribute("exportCount", exportCount);

        List<Map<String, Object>> recentReceipts = receiptDAO.getReportDetailList(
                firstOfMonth.minusMonths(1), now, warehouseId, null, 6, 0);
        request.setAttribute("recentReceipts", recentReceipts);

        List<Map<String, Object>> monthlyImportTrend = receiptDAO.getReportMonthlyTrend(twelveMonthsAgo, now, warehouseId, "IMPORT");
        List<Map<String, Object>> monthlyExportTrend = receiptDAO.getReportMonthlyTrend(twelveMonthsAgo, now, warehouseId, "EXPORT");
        request.setAttribute("monthlyImportTrend", monthlyImportTrend);
        request.setAttribute("monthlyExportTrend", monthlyExportTrend);

        precomputeLineChart(request, monthlyImportTrend, monthlyExportTrend);

        Map<Integer, Integer> stockByWarehouse = inventoryDAO.countInStockByWarehouse();
        request.setAttribute("stockByWarehouse", stockByWarehouse);

        if (roleNames.contains("warehouse_staff") && warehouseId != null) {
            request.setAttribute("stockInMyWarehouse", inventoryDAO.countByWarehouseId(warehouseId));
            request.setAttribute("modelsInMyWarehouse", inventoryDAO.countDistinctGeneratorsInStockByWarehouse(warehouseId));
            request.setAttribute("readyExportCount", transferDAO.findReadyForExport(warehouseId, userId).size());
            request.setAttribute("readyImportCount", transferDAO.findReadyForImport(warehouseId, userId).size());
        }

        if (roleNames.contains("warehouse_manager")) {
            request.setAttribute("pendingProposals", importProposalDAO.countByStatus("PENDING_CEO", null, null, null, userId));
            Map<String, Integer> transferKpis = transferDAO.getKpiCounts(null, warehouseId, userId);
            request.setAttribute("transferKpis", transferKpis);
            request.setAttribute("transferPendingCount", transferKpis != null ? transferKpis.getOrDefault("PENDING_CEO", 0) : 0);
        }

        if (perms.contains("inventory_check.view")) {
            request.setAttribute("doingChecks", inventoryCheckDAO.countByStatus("doing"));
        }
    }

    private void loadCeoData(HttpServletRequest request, Set<String> roleNames, int userId) {
        try {
            Map<String, Integer> liquidationKpis = liquidationDAO.getKpiCounts(null);
            request.setAttribute("pendingLiquidations", liquidationKpis != null ? liquidationKpis.getOrDefault("PENDING_CEO", 0) : 0);

            Map<String, Integer> transferKpis = transferDAO.getKpiCounts(null, null, userId);
            request.setAttribute("pendingTransfers", transferKpis != null ? transferKpis.getOrDefault("PENDING_CEO", 0) : 0);
            request.setAttribute("pendingPOs", purchaseOrderDAO.countByFilters(null, null, 0, "PENDING_CEO"));
        } catch (Exception e) {
            System.err.println("DashboardController loadCeoData error: " + e.getMessage());
        }
    }

    private void loadAdminExtendedData(HttpServletRequest request, Set<String> roleNames) {
        if (roleNames == null || !roleNames.contains("admin")) {
            return;
        }
        try {
            request.setAttribute("activeCategories", categoryDAO.findAll().size());

            List<User> allUsers = userDAO.findUsersWithRoles(null, null, null, 1, 1000);
            Map<String, Integer> userByRole = new LinkedHashMap<>();
            for (User u : allUsers) {
                if (u.getRoles() != null && !u.getRoles().isEmpty()) {
                    String desc = u.getRoles().get(0).getDescription();
                    userByRole.merge(desc, 1, Integer::sum);
                }
            }
            request.setAttribute("userByRole", userByRole);

            List<Map<String, Object>> adminDonutSegments = new ArrayList<>();
            int totalRoleUsers = 0;
            for (int cnt : userByRole.values()) {
                totalRoleUsers += cnt;
            }
            if (totalRoleUsers > 0) {
                double circumference = 2.0 * Math.PI * 80.0;
                String[] colors = {"var(--accent)", "var(--info)", "var(--purple)", "var(--warn)", "var(--danger)"};
                double cumulative = 0;
                int idx = 0;
                for (Map.Entry<String, Integer> entry : userByRole.entrySet()) {
                    int count = entry.getValue();
                    if (count == 0) continue;
                    double dashLen = (count / (double) totalRoleUsers) * circumference;
                    Map<String, Object> seg = new LinkedHashMap<>();
                    seg.put("status", entry.getKey());
                    seg.put("count", count);
                    seg.put("dashLen", Math.round(dashLen * 100.0) / 100.0);
                    seg.put("gap", Math.round((circumference - dashLen) * 100.0) / 100.0);
                    seg.put("dashOffset", Math.round(-cumulative * 100.0) / 100.0);
                    seg.put("color", colors[idx % colors.length]);
                    adminDonutSegments.add(seg);
                    cumulative += dashLen;
                    idx++;
                }
            }
            request.setAttribute("adminDonutSegments", adminDonutSegments);
            request.setAttribute("adminDonutTotal", totalRoleUsers);

            List<User> sorted = new ArrayList<>(allUsers);
            sorted.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
            List<User> recentUsers = sorted.subList(0, Math.min(5, sorted.size()));
            request.setAttribute("recentUsers", recentUsers);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void precomputeLineChart(HttpServletRequest request,
            List<Map<String, Object>> importTrend, List<Map<String, Object>> exportTrend) {
        if (importTrend == null || importTrend.isEmpty()) {
            return;
        }
        int maxVal = 1;
        for (Map<String, Object> item : importTrend) {
            int c = ((Number) item.get("machineCount")).intValue();
            if (c > maxVal) maxVal = c;
        }
        for (Map<String, Object> item : exportTrend) {
            int c = ((Number) item.get("machineCount")).intValue();
            if (c > maxVal) maxVal = c;
        }
        int[] axisVals = {maxVal, Math.max(1, maxVal * 3 / 4), Math.max(0, maxVal / 2), Math.max(0, maxVal / 4), 0};

        StringBuilder importPts = new StringBuilder();
        StringBuilder exportPts = new StringBuilder();
        int lastImportX = 0, lastImportY = 0, lastImportVal = 0;
        int lastExportX = 0, lastExportY = 0, lastExportVal = 0;
        int idx = 0;
        for (Map<String, Object> item : importTrend) {
            int x = 60 + idx * 95;
            int v = ((Number) item.get("machineCount")).intValue();
            int y = 220 - (v * 180 / maxVal);
            importPts.append(x).append(",").append(y).append(" ");
            lastImportX = x; lastImportY = y; lastImportVal = v;
            idx++;
        }
        idx = 0;
        for (Map<String, Object> item : exportTrend) {
            int x = 60 + idx * 95;
            int v = ((Number) item.get("machineCount")).intValue();
            int y = 220 - (v * 180 / maxVal);
            exportPts.append(x).append(",").append(y).append(" ");
            lastExportX = x; lastExportY = y; lastExportVal = v;
            idx++;
        }
        request.setAttribute("lineAxisVals", axisVals);
        request.setAttribute("lineImportPoints", importPts.toString().trim());
        request.setAttribute("lineExportPoints", exportPts.toString().trim());
        request.setAttribute("lineLastImportX", lastImportX);
        request.setAttribute("lineLastImportY", lastImportY);
        request.setAttribute("lineLastImportVal", lastImportVal);
        request.setAttribute("lineLastExportX", lastExportX);
        request.setAttribute("lineLastExportY", lastExportY);
        request.setAttribute("lineLastExportVal", lastExportVal);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
