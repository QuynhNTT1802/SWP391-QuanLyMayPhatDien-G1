
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse.receipt;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDetailDAO;
import com.quanlymayphatdien.g1.dal.OrderDetailDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.SaleOrderDAO;
import com.quanlymayphatdien.g1.dal.StockCardDAO;
import com.quanlymayphatdien.g1.dal.TransferDAO;
import com.quanlymayphatdien.g1.dal.TransferDetailDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Liquidation;
import com.quanlymayphatdien.g1.entity.LiquidationDetail;
import com.quanlymayphatdien.g1.entity.OrderDetail;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.entity.StockCard;
import com.quanlymayphatdien.g1.entity.Transfer;
import com.quanlymayphatdien.g1.entity.TransferDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.utils.WarehouseAccessUtil;
import com.google.gson.Gson;
import com.quanlymayphatdien.g1.utils.NotificationService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
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
                case "detail":
                    viewDetail(request, response);
                    break;
                case "selectOrder":
                    selectOrder(request, response);
                    break;
                case "selectLiquidation":
                    selectLiquidation(request, response);
                    break;
                case "selectTransfer":
                    selectTransfer(request, response);
                    break;
                case "loadGenerators":
                    loadGeneratorsJson(request, response);
                    break;
                case "getOrderDetail":
                    getOrderDetailJson(request, response);
                    break;
                case "getLiquidationDetail":
                    getLiquidationDetailJson(request, response);
                    break;
                case "getTransferDetail":
                    getTransferDetailJson(request, response);
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
                } catch (NumberFormatException ignored) {
                }
            }
            whFilter = String.valueOf(scopedWarehouseId);
        }
        String search = request.getParameter("search");
        String relatedType = request.getParameter("relatedType");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        int totalItems = receiptDAO.countWithFilters(TYPE, statusFilter, whFilter, search, createdByFilter, relatedType, loggedUser.getId());
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        List<Receipt> receiptList = receiptDAO.findWithFilters(
                TYPE, statusFilter, whFilter, search, createdByFilter, relatedType, page, pageSize, loggedUser.getId());
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
        request.setAttribute("relatedType", relatedType);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("canApproveReceipt", false);
        request.setAttribute("canRejectReceipt", false);
        request.getRequestDispatcher("/view/receipt/export/export-list.jsp").forward(request, response);
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
        request.setAttribute("allSerials", loadAllInStockSerials());
        request.setAttribute("activePage", "export-create");

        String transferIdStr = request.getParameter("transferId");
        if (transferIdStr != null && !transferIdStr.isEmpty()) {
            int transferId = parseId(transferIdStr);
            com.quanlymayphatdien.g1.dal.TransferDAO transferDAO = new com.quanlymayphatdien.g1.dal.TransferDAO();
            com.quanlymayphatdien.g1.entity.Transfer transfer = transferDAO.findById(transferId);
            if (transfer != null
                    && com.quanlymayphatdien.g1.utils.GlobalUtils.TRANSFER_STATUS_APPROVED.equals(transfer.getStatus())
                    && transfer.getExportReceiptId() == null) {
                if (scopedWarehouseId > 0 && scopedWarehouseId != transfer.getSourceWarehouseId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                request.setAttribute("transfer", transfer);
                request.setAttribute("transferId", transfer.getTransferId());
                request.setAttribute("transferCode", transfer.getTransferCode());
                request.setAttribute("fromTransfer", Boolean.TRUE);
                request.setAttribute("preselectSourceWarehouseId", transfer.getSourceWarehouseId());
                request.setAttribute("transferDetails", transfer.getDetails());

                Map<Integer, Integer> inStockByGen = new java.util.LinkedHashMap<>();
                if (transfer.getDetails() != null) {
                    for (com.quanlymayphatdien.g1.entity.TransferDetail d : transfer.getDetails()) {
                        int qty = inventoryDAO.findInStockByWarehouseAndGenerator(
                                transfer.getSourceWarehouseId(), d.getGeneratorId()).size();
                        inStockByGen.put(d.getGeneratorId(), qty);
                    }
                }
                request.setAttribute("inStockByGenForTransfer", inStockByGen);

                com.quanlymayphatdien.g1.entity.Warehouse src = warehouseDAO.findById(transfer.getSourceWarehouseId());
                if (src != null) {
                    java.util.List<com.quanlymayphatdien.g1.entity.Warehouse> whList = new java.util.ArrayList<>();
                    whList.add(src);
                    request.setAttribute("warehouses", whList);
                }

                // Pre-fill Receipt with one empty ReceiptDetail per required unit
                // (giống pattern order flow: user sẽ scan serials để fill)
                Receipt prefill = new Receipt();
                prefill.setReceiptType(TYPE);
                prefill.setLinkedTransferId(transferId);
                prefill.setNote("Xuất kho theo phiếu luân chuyển " + transfer.getTransferCode());
                java.util.List<ReceiptDetail> prefillDetails = new java.util.ArrayList<>();
                if (transfer.getDetails() != null) {
                    for (com.quanlymayphatdien.g1.entity.TransferDetail td : transfer.getDetails()) {
                        int qty = td.getQuantity() > 0 ? td.getQuantity() : 1;
                        for (int k = 0; k < qty; k++) {
                            ReceiptDetail rd = new ReceiptDetail();
                            rd.setGeneratorId(td.getGeneratorId());
                            rd.setNote(td.getNote() != null ? td.getNote() : "");
                            prefillDetails.add(rd);
                        }
                    }
                }
                prefill.setDetails(prefillDetails);
                request.setAttribute("receipt", prefill);

                Gson gson = new Gson();
                request.setAttribute("prefillDetailsJson", gson.toJson(prefillDetails));

                // Build expectedRows for the counter banner
                int totalTransferRows = 0;
                if (transfer.getDetails() != null) {
                    for (com.quanlymayphatdien.g1.entity.TransferDetail td : transfer.getDetails()) {
                        totalTransferRows += td.getQuantity() > 0 ? td.getQuantity() : 1;
                    }
                }
                request.setAttribute("expectedTransferRows", totalTransferRows);

                // Build stock warnings for shortage display
                java.util.List<String> stockWarningsTransfer = new java.util.ArrayList<>();
                if (transfer.getDetails() != null) {
                    for (com.quanlymayphatdien.g1.entity.TransferDetail td : transfer.getDetails()) {
                        int reqQty = td.getQuantity() > 0 ? td.getQuantity() : 1;
                        int haveQty = inStockByGen.containsKey(td.getGeneratorId())
                                ? inStockByGen.get(td.getGeneratorId()) : 0;
                        if (haveQty < reqQty) {
                            int shortage = reqQty - haveQty;
                            stockWarningsTransfer.add(td.getGeneratorModel() + " cần " + reqQty
                                    + " máy, chỉ còn " + haveQty + " máy tại kho nguồn. Cần nhập thêm " + shortage + " máy.");
                        }
                    }
                }
                request.setAttribute("stockWarningsTransfer", stockWarningsTransfer);
            }
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            int orderId = parseId(orderIdStr);
            SaleOrder order = new SaleOrderDAO().findById(orderId);
            if (order != null && "APPROVED".equalsIgnoreCase(order.getStatus())) {
                List<OrderDetail> ods = new OrderDetailDAO().findGeneratorById(orderId);
                Receipt prefill = new Receipt();
                prefill.setOrderId(orderId);
                prefill.setReceiptType(TYPE);
                prefill.setNote("Tạo từ đơn " + order.getOrderCode());
                List<Map<String, Object>> orderRowList = new ArrayList<>();
                int expectedRows = 0;
                for (OrderDetail od : ods) {
                    int qty = od.getQuantity() > 0 ? od.getQuantity() : 1;
                    for (int k = 0; k < qty; k++) {
                        Map<String, Object> row = new LinkedHashMap<>();
                        row.put("generatorId", od.getGeneratorId());
                        row.put("generatorModel", od.getGeneratorModel() != null ? od.getGeneratorModel() : "");
                        String brand = lookupGeneratorBrand(od.getGeneratorId());
                        row.put("brandName", brand);
                        row.put("note", od.getNote() != null ? od.getNote() : "");
                        orderRowList.add(row);

                        expectedRows++;
                    }
                }
                prefill.setDetails(new ArrayList<>());
                request.setAttribute("receipt", prefill);
                request.setAttribute("order", order);
                request.setAttribute("fromOrder", Boolean.TRUE);
                request.setAttribute("expectedRows", expectedRows);
                request.setAttribute("orderRowList", orderRowList);

                List<Map<String, Object>> orderRequirements = new ArrayList<>();
                for (OrderDetail od : ods) {
                    Map<String, Object> req = new LinkedHashMap<>();
                    req.put("generatorId", od.getGeneratorId());
                    req.put("generatorModel", od.getGeneratorModel() != null ? od.getGeneratorModel() : "");
                    String brand = lookupGeneratorBrand(od.getGeneratorId());
                    req.put("brandName", brand);
                    req.put("quantity", od.getQuantity() > 0 ? od.getQuantity() : 1);
                    orderRequirements.add(req);
                }
                request.setAttribute("orderRequirements", orderRequirements);

                List<String> stockWarnings = new ArrayList<>();
                List<Integer> shortGenIds = new ArrayList<>();
                for (OrderDetail od : ods) {
                    int genId = od.getGeneratorId();
                    int qty = od.getQuantity() > 0 ? od.getQuantity() : 1;
                    int totalInStock = inventoryDAO.countTotalInStockByGenerator(genId);
                    if (totalInStock < qty) {
                        Generator gen = genDAO.findById(genId);
                        String model = (gen != null && gen.getModel() != null && !gen.getModel().isEmpty())
                                ? gen.getModel() : ("#" + genId);
                        int shortage = qty - totalInStock;
                        stockWarnings.add(model + " cần " + qty + " máy, chỉ còn " + totalInStock + " máy trên tất cả kho. Cần nhập thêm " + shortage + " máy.");
                        shortGenIds.add(genId);
                    }
                }
                request.setAttribute("stockWarnings", stockWarnings);
                request.setAttribute("stockWarningGenIds", shortGenIds);
            }
        }

        String liquidationIdStr = request.getParameter("liquidationId");
        if (liquidationIdStr != null && !liquidationIdStr.isEmpty()) {
            int liqId = parseId(liquidationIdStr);
            LiquidationDAO liqDAO = new LiquidationDAO();
            Liquidation liq = liqDAO.findById(liqId);
            if (liq != null && "APPROVED".equalsIgnoreCase(liq.getStatus())) {
                LiquidationDetailDAO liqDetailDAO = new LiquidationDetailDAO();
                List<LiquidationDetail> liqDetails = liqDetailDAO.findByLiquidationId(liqId);
                Receipt prefill = new Receipt();
                prefill.setLiquidationId(liqId);
                prefill.setReceiptType(TYPE);
                prefill.setWarehouseId(liq.getWarehouseId());
                prefill.setReasonId(liq.getReasonId());
                prefill.setNote("Tạo từ đơn thanh lý " + liq.getLiquidationCode());
                List<Map<String, Object>> orderRowList = new ArrayList<>();
                int expectedRows = 0;
                for (LiquidationDetail ld : liqDetails) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("generatorId", ld.getGeneratorId());
                    row.put("generatorModel", ld.getGeneratorModelName() != null ? ld.getGeneratorModelName() : "");
                    row.put("serialNumber", ld.getSerialNumber());
                    String brand = lookupGeneratorBrand(ld.getGeneratorId());
                    row.put("brandName", brand);
                    row.put("note", "Thanh lý: " + ld.getLiquidationPrice());
                    orderRowList.add(row);
                    expectedRows++;
                }
                prefill.setDetails(new ArrayList<>());
                request.setAttribute("receipt", prefill);
                request.setAttribute("liquidation", liq);
                request.setAttribute("fromLiquidation", Boolean.TRUE);
                request.setAttribute("expectedRows", expectedRows);
                request.setAttribute("orderRowList", orderRowList);
            }
        }

        request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/export-receipt?action=detail&id=" + parseId(request.getParameter("id")));
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
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        if (scopedWarehouseId > 0 && receipt.getWarehouseId() != scopedWarehouseId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
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
                try {
                    page = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException ignored) {
                    page = 1;
                }
            }
            List<ActivityLog> logs = activityLogDAO.findByEntityTypeAndId2("receipt", id, logSearch, logAction,
                    dateFrom, dateTo, page, pageSize);
            int totalLogs = activityLogDAO.countByEntityTypeAndId2("receipt", id, logSearch, logAction,
                    dateFrom, dateTo);
            int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
            if (page > totalPages) {
                page = totalPages;
            }
            request.setAttribute("logList", logs);
            request.setAttribute("logPage", page);
            request.setAttribute("logTotalPages", totalPages);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("logSearch", logSearch != null ? logSearch : "");
            request.setAttribute("logAction", logAction != null ? logAction : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        }

        List<ReceiptDetail> allDetails = receipt.getDetails();
        int totalDetails = allDetails != null ? allDetails.size() : 0;
        int detailPageSize = 10;
        int detailPage = 1;
        String detailPageStr = request.getParameter("detailPage");
        if (detailPageStr != null && !detailPageStr.isEmpty()) {
            try { detailPage = Math.max(1, Integer.parseInt(detailPageStr)); }
            catch (NumberFormatException ignored) { }
        }
        int detailTotalPages = Math.max(1, (int) Math.ceil((double) totalDetails / detailPageSize));
        if (detailPage > detailTotalPages) detailPage = detailTotalPages;
        List<ReceiptDetail> pagedDetails = new ArrayList<>();
        if (allDetails != null && !allDetails.isEmpty()) {
            int fromIndex = (detailPage - 1) * detailPageSize;
            int toIndex = Math.min(fromIndex + detailPageSize, allDetails.size());
            pagedDetails = allDetails.subList(fromIndex, toIndex);
        }
        request.setAttribute("pagedDetails", pagedDetails);
        request.setAttribute("detailPage", detailPage);
        request.setAttribute("detailTotalPages", detailTotalPages);
        request.setAttribute("totalDetails", totalDetails);

        request.setAttribute("receipt", receipt);
        request.setAttribute("isManager", false);
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

    private void selectLiquidation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        LiquidationDAO liqDAO = new LiquidationDAO();
        int totalItems = liqDAO.countApprovedAvailableFiltered(search, fromDate, toDate);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }
        List<Liquidation> approvedLiquidations = liqDAO.findApprovedAvailableFiltered(search, fromDate, toDate, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("approvedLiquidations", approvedLiquidations);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("activePage", "export-select-liquidation");
        request.getRequestDispatcher("/view/receipt/export/export-select-liquidation.jsp").forward(request, response);
    }

    private void selectTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        Integer scopedWarehouseId = (Integer) session.getAttribute("scopedWarehouseId");
        if (scopedWarehouseId == null) scopedWarehouseId = 0;

        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        com.quanlymayphatdien.g1.dal.TransferDAO tDAO = new com.quanlymayphatdien.g1.dal.TransferDAO();
        int totalItems = tDAO.countReadyForExportFiltered(search, fromDate, toDate, scopedWarehouseId, loggedUser.getId());
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }
        java.util.List<com.quanlymayphatdien.g1.entity.Transfer> transfers
                = tDAO.findReadyForExportFiltered(search, fromDate, toDate, page, pageSize, scopedWarehouseId, loggedUser.getId());
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("transfers", transfers);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("activePage", "export-select-transfer");
        request.getRequestDispatcher("/view/receipt/export/export-select-transfer.jsp").forward(request, response);
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

    private void getOrderDetailJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int orderId = parseId(request.getParameter("id"));
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (orderId <= 0) {
            response.getWriter().write("[]");
            return;
        }
        OrderDetailDAO odDAO = new OrderDetailDAO();
        List<OrderDetail> details = odDAO.findGeneratorById(orderId);
        List<Map<String, Object>> out = new ArrayList<>();
        for (OrderDetail d : details) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("generatorModel", d.getGeneratorModel() != null ? d.getGeneratorModel() : "");
            item.put("generatorPower", d.getGeneratorPower() != null ? d.getGeneratorPower() : "");
            item.put("quantity", d.getQuantity());
            item.put("unitPrice", d.getUnitPrice() != null ? d.getUnitPrice() : 0);
            item.put("note", d.getNote() != null ? d.getNote() : "");
            out.add(item);
        }
        new Gson().toJson(out, response.getWriter());
    }

    private void getLiquidationDetailJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int liquidationId = parseId(request.getParameter("id"));
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (liquidationId <= 0) {
            response.getWriter().write("[]");
            return;
        }
        LiquidationDetailDAO ldDAO = new LiquidationDetailDAO();
        List<LiquidationDetail> details = ldDAO.findByLiquidationId(liquidationId);
        List<Map<String, Object>> out = new ArrayList<>();
        for (LiquidationDetail d : details) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("generatorModel", d.getGeneratorModelName() != null ? d.getGeneratorModelName() : "");
            item.put("serialNumber", d.getSerialNumber() != null ? d.getSerialNumber() : "");
            item.put("originalPrice", d.getOriginalPrice() != null ? d.getOriginalPrice() : 0);
            item.put("liquidationPrice", d.getLiquidationPrice() != null ? d.getLiquidationPrice() : 0);
            out.add(item);
        }
        new Gson().toJson(out, response.getWriter());
    }

    private void getTransferDetailJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int transferId = parseId(request.getParameter("id"));
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (transferId <= 0) {
            response.getWriter().write("[]");
            return;
        }
        TransferDetailDAO tdDAO = new TransferDetailDAO();
        List<TransferDetail> details = tdDAO.findByTransferId(transferId);
        List<Map<String, Object>> out = new ArrayList<>();
        for (TransferDetail d : details) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("generatorModel", d.getGeneratorModel() != null ? d.getGeneratorModel() : "");
            item.put("serialNumber", d.getSerialNumber() != null ? d.getSerialNumber() : "");
            item.put("quantity", d.getQuantity());
            item.put("note", d.getNote() != null ? d.getNote() : "");
            out.add(item);
        }
        new Gson().toJson(out, response.getWriter());
    }

    private void saveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(session);
        int existingReceiptId = parseId(request.getParameter("receiptId"));

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();

        if (warehouseId <= 0) {
            errors.add("Vui lòng chọn kho");
        }
        if (scopedWarehouseId > 0 && warehouseId > 0 && warehouseId != scopedWarehouseId) {
            errors.add("Bạn chỉ được phép tạo phiếu xuất cho kho của mình");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");
        }

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try {
                reasonId = Integer.parseInt(reasonIdStr);
            } catch (NumberFormatException e) {
                errors.add("Lý do không hợp lệ");
            }
        } else {
            errors.add("Vui lòng chọn lý do");
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        Receipt existingReceipt = null;
        if (existingReceiptId > 0) {
            existingReceipt = receiptDAO.findById(existingReceiptId);
            if (existingReceipt == null || !TYPE.equals(existingReceipt.getReceiptType())) {
                response.sendRedirect(request.getContextPath() + "/export-receipt");
                return;
            }
            if (existingReceipt.getCreatedBy() != loggedUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        List<ReceiptDetail> details = parseDetailsStrict(genIds, serials, detailNotes, warehouseId, errors);
        if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
            errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
        }
        if (errors.isEmpty() && warehouseId > 0) {
            validateInventoryAvailability(warehouseId, details, errors);
        }

        int orderId = parseId(request.getParameter("orderId"));
        if (orderId > 0) {
            validateOrderCompleteness(orderId, details, errors);
        }

        int liquidationId = parseId(request.getParameter("liquidationId"));
        if (liquidationId > 0) {
            validateLiquidationCompleteness(liquidationId, details, errors);
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage("Lưu phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            if (existingReceipt != null) {
                request.setAttribute("receipt", existingReceipt);
                request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
            }
            return;
        }

        int transferId = parseId(request.getParameter("transferId"));
        com.quanlymayphatdien.g1.entity.Transfer transferForExport = null;
        boolean isTransferExport = false;
        if (transferId > 0) {
            com.quanlymayphatdien.g1.dal.TransferDAO tDAO = new com.quanlymayphatdien.g1.dal.TransferDAO();
            transferForExport = tDAO.findById(transferId);
            if (transferForExport == null
                    || !com.quanlymayphatdien.g1.utils.GlobalUtils.TRANSFER_STATUS_APPROVED.equals(transferForExport.getStatus())
                    || transferForExport.getExportReceiptId() != null) {
                HttpSession s = request.getSession();
                s.setAttribute("toastMessage", "Phiếu đề xuất không hợp lệ hoặc đã có phiếu xuất");
                s.setAttribute("toastType", "danger");
                response.sendRedirect(request.getContextPath()
                        + "/transfers?action=detail&id=" + transferId);
                return;
            }
            if (warehouseId != transferForExport.getSourceWarehouseId()) {
                HttpSession s = request.getSession();
                s.setAttribute("toastMessage", "Kho xuất phải là kho nguồn của phiếu luân chuyển");
                s.setAttribute("toastType", "danger");
                response.sendRedirect(request.getContextPath()
                        + "/transfers?action=detail&id=" + transferId);
                return;
            }
            isTransferExport = true;
        }

        int receiptId;
        Receipt r;
        if (existingReceipt != null) {
            receiptId = existingReceipt.getReceiptId();
            r = existingReceipt;
        } else {
            r = new Receipt();
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
            if (isTransferExport) {
                r.setLinkedTransferId(transferId);
                r.setNote("Xuất kho theo phiếu luân chuyển "
                        + transferForExport.getTransferCode() + (note != null && !note.isEmpty() ? " | " + note : ""));
            }
            if (liquidationId > 0) {
                r.setLiquidationId(liquidationId);
            }
            r.setStatus(GlobalUtils.RECEIPT_STATUS_COMPLETED);
            r.setApprovedBy(loggedUser.getId());
            r.setApprovedAt(java.time.LocalDateTime.now());
            // receiptId sẽ được insert bên trong transaction bên dưới
            receiptId = -1;
        }

        java.sql.Connection conn = null;
        boolean ok = false;
        try {
            conn = receiptDAO.getConnection();
            conn.setAutoCommit(false);

            if (existingReceipt == null) {
                receiptId = receiptDAO.insert(conn, r);
                if (receiptId <= 0) {
                    throw new java.sql.SQLException("Không thể tạo phiếu, vui lòng thử lại");
                }
            }

            if (existingReceipt != null) {
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "UPDATE receipt SET warehouse_id = ?, note = ?, reason_id = ?, "
                        + "status = ?, approved_by = ?, approved_at = ? "
                        + "WHERE receipt_id = ?")) {
                    ps.setInt(1, warehouseId);
                    ps.setString(2, note);
                    if (reasonId != null) {
                        ps.setInt(3, reasonId);
                    } else {
                        ps.setNull(3, java.sql.Types.INTEGER);
                    }
                    ps.setString(4, GlobalUtils.RECEIPT_STATUS_COMPLETED);
                    ps.setInt(5, loggedUser.getId());
                    ps.setTimestamp(6, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
                    ps.setInt(7, receiptId);
                    ps.executeUpdate();
                }

                if (liquidationId > 0) {
                    try (java.sql.PreparedStatement ps = conn.prepareStatement(
                            "UPDATE inventory SET status = ? "
                            + "WHERE inventory_id IN (SELECT inventory_id FROM receipt_detail WHERE receipt_id = ?) "
                            + "AND status = ?")) {
                        ps.setString(1, InventoryDAO.STATUS_SOLD);
                        ps.setInt(2, receiptId);
                        ps.setString(3, InventoryDAO.STATUS_PENDING_LIQUIDATION);
                        ps.executeUpdate();
                    }
                }

                java.util.Set<String> existingSerials = new java.util.HashSet<>();
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "SELECT i.serial_number FROM receipt_detail rd "
                        + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                        + "WHERE rd.receipt_id = ?")) {
                    ps.setInt(1, receiptId);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            existingSerials.add(rs.getString(1));
                        }
                    }
                }

                java.util.List<ReceiptDetail> toInsert = new java.util.ArrayList<>();
                for (ReceiptDetail d : details) {
                    if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) {
                        continue;
                    }
                    String sn = d.getSerialNumber().trim();
                    if (existingSerials.contains(sn)) {
                        continue;
                    }

                    Inventory inv = inventoryDAO.findBySerialNumber(sn);
                    if (inv == null) {
                        throw new SQLException("Số serial \"" + sn + "\" không tồn tại trong hệ thống");
                    }
                    if (liquidationId > 0) {
                        if (!inventoryDAO.isPendingLiquidationAtWarehouse(conn, inv.getSerialNumber(), warehouseId)) {
                            throw new SQLException("Số serial \"" + sn + "\" không ở trạng thái ĐANG THANH LÝ tại kho này");
                        }
                        if (inventoryDAO.markAsExportedFromPendingLiquidation(conn, inv.getInventoryId()) <= 0) {
                            throw new SQLException("Số serial \"" + sn + "\" không ở trạng thái PENDING_LIQUIDATION");
                        }
                    } else {
                        if (!inventoryDAO.isInStockAtWarehouse(inv.getSerialNumber(), warehouseId)) {
                            throw new SQLException("Số serial \"" + sn + "\" không ở trạng thái IN_STOCK tại kho này");
                        }
                        boolean marked = isTransferExport
                                ? inventoryDAO.markAsInTransit(conn, inv.getInventoryId())
                                : inventoryDAO.markAsExported(conn, inv.getInventoryId(), InventoryDAO.STATUS_SOLD);
                        if (!marked) {
                            throw new SQLException("Số serial \"" + sn + "\" không ở trạng thái IN_STOCK");
                        }
                    }
                    d.setReceiptId(receiptId);
                    d.setInventoryId(inv.getInventoryId());
                    toInsert.add(d);
                }
                if (!toInsert.isEmpty()) {
                    detailDAO.batchInsert(conn, toInsert);
                }
            } else {
                for (ReceiptDetail d : details) {
                    if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) {
                        continue;
                    }
                    Inventory inv = inventoryDAO.findBySerialNumber(d.getSerialNumber().trim());
                    if (inv == null) {
                        throw new SQLException("Số serial \"" + d.getSerialNumber() + "\" không tồn tại trong hệ thống");
                    }
                    if (liquidationId > 0) {
                        if (!inventoryDAO.isPendingLiquidationAtWarehouse(conn, inv.getSerialNumber(), warehouseId)) {
                            throw new SQLException("Số serial \"" + d.getSerialNumber() + "\" không ở trạng thái ĐANG THANH LÝ tại kho này");
                        }
                        if (inventoryDAO.markAsExportedFromPendingLiquidation(conn, inv.getInventoryId()) <= 0) {
                            throw new SQLException("Số serial \"" + d.getSerialNumber() + "\" không ở trạng thái PENDING_LIQUIDATION");
                        }
                    } else {
                        if (!inventoryDAO.isInStockAtWarehouse(inv.getSerialNumber(), warehouseId)) {
                            throw new SQLException("Số serial \"" + d.getSerialNumber() + "\" không ở trạng thái IN_STOCK tại kho này");
                        }
                        boolean marked = isTransferExport
                                ? inventoryDAO.markAsInTransit(conn, inv.getInventoryId())
                                : inventoryDAO.markAsExported(conn, inv.getInventoryId(), InventoryDAO.STATUS_SOLD);
                        if (!marked) {
                            throw new SQLException("Số serial \"" + d.getSerialNumber() + "\" không ở trạng thái IN_STOCK");
                        }
                    }
                    d.setReceiptId(receiptId);
                    d.setInventoryId(inv.getInventoryId());
                }

                detailDAO.batchInsert(conn, details);
            }

            if (liquidationId > 0) {
                LiquidationDAO liqDAO = new LiquidationDAO();
                liqDAO.updateStatus(conn, liquidationId, GlobalUtils.STATUS_COMPLETED, loggedUser.getId(), receiptId);
                ActivityLog liqLog = new ActivityLog();
                liqLog.setUserId(loggedUser.getId());
                liqLog.setEntityType("liquidation");
                liqLog.setAction("EXPORT_APPROVE");
                liqLog.setEntityId(liquidationId);
                liqLog.setEntityName(r.getReceiptCode());
                liqLog.setDetails("Hoàn tất xuất kho cho đơn thanh lý " + r.getReceiptCode() + ".");
                activityLogDAO.insert(liqLog);
            }

            java.util.List<ReceiptDetail> allDetails = new java.util.ArrayList<>();
            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                    "SELECT rd.*, i.generator_id, i.serial_number FROM receipt_detail rd "
                    + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                    + "WHERE rd.receipt_id = ?")) {
                ps.setInt(1, receiptId);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        ReceiptDetail rd = new ReceiptDetail();
                        rd.setReceiptId(rs.getInt("receipt_id"));
                        rd.setInventoryId(rs.getInt("inventory_id"));
                        rd.setGeneratorId(rs.getInt("generator_id"));
                        allDetails.add(rd);
                    }
                }
            }
            if (isTransferExport) {
                writeStockCardsForTransfer(conn, receiptId, r.getReceiptCode(),
                        warehouseId, loggedUser.getId(), allDetails);
            } else {
                receiptDAO.writeStockCardsForExport(conn, receiptId, r.getReceiptCode(),
                        warehouseId, loggedUser.getId(), allDetails);
            }

            if (liquidationId > 0) {
                LiquidationDAO liqDAO = new LiquidationDAO();
                liqDAO.updateStatus(conn, liquidationId, GlobalUtils.STATUS_COMPLETED, loggedUser.getId(), receiptId);

                ActivityLog liqLog = new ActivityLog();
                liqLog.setUserId(loggedUser.getId());
                liqLog.setEntityType("liquidation");
                liqLog.setAction("EXPORT_APPROVE");
                liqLog.setEntityId(liquidationId);
                liqLog.setEntityName(r.getReceiptCode());
                liqLog.setDetails("Hoàn tất xuất kho cho phiếu thanh lý " + r.getReceiptCode() + ".");
                activityLogDAO.insert(liqLog);
            }

            conn.commit();
            ok = true;
        } catch (java.sql.SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (java.sql.SQLException e) {
                    e.printStackTrace();
                }
            }
            receiptId = (existingReceipt != null) ? existingReceipt.getReceiptId() : -1;
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
            request.setAttribute("toastMessage", buildErrorMessage("Lưu phiếu thất bại:", errors));
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.setAttribute("allSerials", loadAllInStockSerials());
            if (existingReceipt != null) {
                request.setAttribute("receipt", existingReceipt);
                request.getRequestDispatcher("/view/receipt/export/export-edit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/receipt/export/export-create.jsp").forward(request, response);
            }
            return;
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        log.setAction(existingReceipt != null ? "UPDATE" : "CREATE");
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails(existingReceipt != null ? "Cập nhật phiếu xuất kho" : "Tạo phiếu xuất kho và cập nhật tồn kho");
        activityLogDAO.insert(log);

        if (isTransferExport && transferForExport != null) {
            com.quanlymayphatdien.g1.dal.TransferDAO tDAO = new com.quanlymayphatdien.g1.dal.TransferDAO();
            if (tDAO.markExportReceiptCreated(transferId, receiptId)) {
                ActivityLog transferLog = new ActivityLog();
                transferLog.setUserId(loggedUser.getId());
                transferLog.setEntityType("transfer");
                transferLog.setAction("EXPORT_CREATED");
                transferLog.setEntityId(transferId);
                transferLog.setEntityName(transferForExport.getTransferCode());
                transferLog.setDetails("Phiếu xuất " + r.getReceiptCode()
                        + " đã được tạo từ phiếu luân chuyển (APPROVED -> EXPORTED)");
                activityLogDAO.insert(transferLog);

                notifyDestWarehouseStaff(transferForExport, r, loggedUser, request.getContextPath());
            }
        }

        session.setAttribute("toastMessage", existingReceipt != null ? "Cập nhật phiếu thành công" : "Thêm phiếu thành công");
        session.setAttribute("toastType", "success");
        if (isTransferExport) {
            session.setAttribute("toastMessage",
                    "Tạo phiếu xuất thành công. Kho đích có thể tạo phiếu nhập.");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + transferId);
        } else {
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=list");
        }
    }

    private void writeStockCardsForTransfer(Connection conn, int receiptId, String receiptCode,
            int sourceWarehouseId, int createdBy,
            List<ReceiptDetail> details) throws SQLException {
        if (details == null || details.isEmpty()) {
            return;
        }
        StockCardDAO scDAO = new StockCardDAO();
        Map<Integer, List<ReceiptDetail>> grouped = new LinkedHashMap<>();
        for (ReceiptDetail d : details) {
            if (d.getGeneratorId() > 0) {
                grouped.computeIfAbsent(d.getGeneratorId(), k -> new ArrayList<>()).add(d);
            }
        }
        for (Map.Entry<Integer, List<ReceiptDetail>> entry : grouped.entrySet()) {
            int genId = entry.getKey();
            int totalQty = entry.getValue().size();
            int qtyAfter = 0;
            try (java.sql.PreparedStatement qtyPs = conn.prepareStatement(
                    "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK'")) {
                qtyPs.setInt(1, sourceWarehouseId);
                qtyPs.setInt(2, genId);
                try (java.sql.ResultSet qtyRs = qtyPs.executeQuery()) {
                    if (qtyRs.next()) {
                        qtyAfter = qtyRs.getInt(1);
                    }
                }
            }
            StockCard sc = new StockCard();
            sc.setWarehouseId(sourceWarehouseId);
            sc.setGeneratorId(genId);
            sc.setReceiptId(receiptId);
            sc.setTransactionType("TRANSFER_OUT");
            sc.setQuantityChange(-totalQty);
            sc.setQuantityAfter(qtyAfter);
            sc.setReferenceNote("Phiếu xuất " + receiptCode + " (luân chuyển)");
            sc.setCreatedAt(java.time.LocalDateTime.now());
            sc.setCreatedBy(createdBy);
            scDAO.insert(conn, sc);
        }
    }

    private void notifyDestWarehouseStaff(com.quanlymayphatdien.g1.entity.Transfer transfer,
            Receipt receipt, User sender, String contextPath) {
        List<User> staff = userDAO.findUsersByPermission("receipts", "view");
        if (staff == null) {
            return;
        }
        for (User u : staff) {
            if (u.getId() == sender.getId()) {
                continue;
            }
            Integer scopedWh = null;
            try {
                scopedWh = new com.quanlymayphatdien.g1.dal.UserDAO().getScopedWarehouseId(u.getId());
            } catch (Exception ex) {
                continue;
            }
            if (scopedWh != null && scopedWh == transfer.getDestWarehouseId()) {
                NotificationService.send(
                        u.getId(),
                        "Phiếu xuất mới từ kho nguồn",
                        "Kho nguồn đã tạo phiếu xuất " + receipt.getReceiptCode()
                        + " từ phiếu luân chuyển " + transfer.getTransferCode()
                        + ". Bạn có thể tạo phiếu nhập tại kho đích.",
                        contextPath + "/transfers?action=detail&id=" + transfer.getTransferId(),
                        "transfer",
                        transfer.getTransferId()
                );
            }
        }
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

    /**
     * Kiem tra phieu xuat tao tu order da quet dung va du serial theo tung
     * model. - Thieu may: so luong quet < quantity trong order
     * - Thua may: so luong quet > quantity trong order - Quet nham: generatorId
     * khong thuoc order
     */
    private void validateOrderCompleteness(int orderId, List<ReceiptDetail> details, List<String> errors) {
        List<OrderDetail> ods = new OrderDetailDAO().findGeneratorById(orderId);
        if (ods == null || ods.isEmpty()) {
            errors.add("Đơn hàng không có chi tiết máy");
            return;
        }

        Map<Integer, Integer> scannedByGen = new HashMap<>();
        if (details != null) {
            for (ReceiptDetail d : details) {
                if (d.getGeneratorId() > 0) {
                    Integer cur = scannedByGen.get(d.getGeneratorId());
                    scannedByGen.put(d.getGeneratorId(), (cur == null ? 0 : cur) + 1);
                }
            }
        }

        Set<Integer> checkedGenIds = new HashSet<>();
        for (OrderDetail od : ods) {
            int genId = od.getGeneratorId();
            int required = od.getQuantity() > 0 ? od.getQuantity() : 1;
            int scanned = scannedByGen.getOrDefault(genId, 0);
            String model = (od.getGeneratorModel() != null && !od.getGeneratorModel().isEmpty())
                    ? od.getGeneratorModel() : ("#" + genId);
            checkedGenIds.add(genId);

            if (scanned < required) {
                errors.add("Thiếu máy " + model + ": đã quét " + scanned + "/" + required);
            } else if (scanned > required) {
                errors.add("Thừa máy " + model + ": đã quét " + scanned + "/" + required);
            }
        }

        for (Map.Entry<Integer, Integer> entry : scannedByGen.entrySet()) {
            if (!checkedGenIds.contains(entry.getKey())) {
                errors.add("Có dòng không thuộc đơn hàng (generatorId=" + entry.getKey()
                        + ", số lượng=" + entry.getValue() + ")");
            }
        }
    }

    private void validateLiquidationCompleteness(int liquidationId, List<ReceiptDetail> details, List<String> errors) {
        LiquidationDetailDAO ldDAO = new LiquidationDetailDAO();
        List<LiquidationDetail> liqDetails = ldDAO.findByLiquidationId(liquidationId);
        if (liqDetails == null || liqDetails.isEmpty()) {
            errors.add("Đơn thanh lý không có chi tiết máy");
            return;
        }

        Set<String> liqSerials = new HashSet<>();
        for (LiquidationDetail ld : liqDetails) {
            liqSerials.add(ld.getSerialNumber());
        }
        Set<String> detailSerials = new HashSet<>();
        if (details != null) {
            for (ReceiptDetail d : details) {
                if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                    detailSerials.add(d.getSerialNumber().trim());
                }
            }
        }

        for (LiquidationDetail ld : liqDetails) {
            if (!detailSerials.contains(ld.getSerialNumber())) {
                errors.add("Thiếu số serial " + ld.getSerialNumber() + " (" + ld.getGeneratorModelName() + ") trong phiếu xuất");
            }
        }
        for (String sn : detailSerials) {
            if (!liqSerials.contains(sn)) {
                errors.add("Số serial " + sn + " không thuộc đơn thanh lý này");
            }
        }
    }

    private String lookupGeneratorBrand(int generatorId) {
        Generator gen = genDAO.findById(generatorId);
        if (gen == null) {
            return "";
        }
        if (gen.getCategories() != null) {
            for (Category c : gen.getCategories()) {
                if ("brand".equals(c.getType())) {
                    return c.getName() != null ? c.getName() : "";
                }
            }
        }
        return "";
    }
}