package com.quanlymayphatdien.g1.controller.proposal;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.PurchaseOrderDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.PeriodUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.utils.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "PurchaseOrderController", urlPatterns = {"/purchase-order"})
public class PurchaseOrderController extends HttpServlet {

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
                case "reviewCreate":
                    showReviewCreate(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "reject":
                    showRejectForm(request, response);
                    break;
                default:
                    list(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.PURCHASE, "PurchaseOrderController.doGet", e.getMessage(), e);
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getSession().setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
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
            action = "";
        }

        try {
            switch (action) {
                case "reviewCreate":
                    showReviewCreate(request, response);
                    break;
                case "submitReviewCreate":
                    submitReviewCreate(request, response);
                    break;
                case "approve":
                    approve(request, response);
                    break;
                case "reject":
                    reject(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.PURCHASE, "PurchaseOrderController.doPost", e.getMessage(), e);
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Lỗi xử lý: " + e.getMessage());
            request.getSession().setAttribute("toastType", "danger");
            String redirect = action != null && (action.startsWith("submitReviewCreate") || action.startsWith("reviewCreate") || action.startsWith("submitEditReturned"))
                    ? "/proposal?action=list"
                    : "/purchase-order?action=list";
            response.sendRedirect(request.getContextPath() + redirect);
        }
    }

    private void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");

        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        int warehouseId = parseInt(request.getParameter("warehouseId"));
        String status = request.getParameter("status");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        int total = dao.countByFilters(dateFrom, dateTo, warehouseId, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<PurchaseOrder> pos = dao.findByFilters(dateFrom, dateTo, warehouseId, status, page, pageSize);

        request.setAttribute("purchaseOrders", pos);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPOs", total);
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("status", status);
        request.setAttribute("activePage", "purchase-order");

        request.getRequestDispatcher("/view/purchase/purchase-list.jsp").forward(request, response);
    }

    private void showReviewCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền tạo phiếu mua");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String[] proposalIdArr = request.getParameterValues("proposalIds");
        if (proposalIdArr == null || proposalIdArr.length == 0) {
            session.setAttribute("toastMessage", "Chưa chọn phiếu đề xuất nào");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        List<Integer> proposalIds = new ArrayList<>();
        for (String s : proposalIdArr) {
            int id = parseInt(s);
            if (id > 0) {
                proposalIds.add(id);
            }
        }
        if (proposalIds.isEmpty()) {
            session.setAttribute("toastMessage", "Danh sách phiếu đề xuất không hợp lệ");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        ImportProposalDAO ipDao = new ImportProposalDAO();
        List<ImportProposal> proposals = ipDao.findByIdsForReview(proposalIds);
        if (proposals.size() != proposalIds.size()) {
            session.setAttribute("toastMessage", "Một số phiếu đề xuất không hợp lệ (đã bị xử lý hoặc không tồn tại)");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String period = proposals.get(0).getPeriod();
        int warehouseId = proposals.get(0).getWarehouseId();
        for (ImportProposal p : proposals) {
            String pPeriod = p.getPeriod();
            if (period == null || pPeriod == null
                    || !period.equals(pPeriod)
                    || warehouseId != p.getWarehouseId()) {
                session.setAttribute("toastMessage",
                        "Tất cả phiếu đề xuất phải cùng kỳ và cùng kho. "
                        + "(kỳ: " + period + " vs " + pPeriod
                        + ", kho: " + warehouseId + " vs " + p.getWarehouseId() + ")");
                session.setAttribute("toastType", "danger");
                response.sendRedirect(request.getContextPath() + "/proposal?action=list");
                return;
            }
        }

        if (period != null && !PeriodUtils.isWithinDeadline(period)) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + period
                            + ". Không thể tổng hợp phiếu mua cho period này.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        PurchaseOrderDAO poDao = new PurchaseOrderDAO();
        List<Map<String, Object>> aggregations = poDao.aggregateByProposalIds(proposalIds, warehouseId);

        java.util.Map<Integer, java.util.Map<String, Object>> aggByGen = new java.util.LinkedHashMap<>();
        for (java.util.Map<String, Object> row : aggregations) {
            int gid = ((Number) row.get("generatorId")).intValue();
            java.util.Map<String, Object> existing = aggByGen.get(gid);
            if (existing == null) {
                java.util.Map<String, Object> newRow = new java.util.LinkedHashMap<>(row);
                newRow.remove("proposalDetailId");
                newRow.remove("proposalId");
                aggByGen.put(gid, newRow);
            } else {
                int sumQty = ((Number) existing.get("totalProposed")).intValue()
                        + ((Number) row.get("totalProposed")).intValue();
                existing.put("totalProposed", sumQty);
                int minStock = Math.min(
                        ((Number) existing.get("currentStock")).intValue(),
                        ((Number) row.get("currentStock")).intValue());
                existing.put("currentStock", minStock);
            }
        }
        List<java.util.Map<String, Object>> aggregatedDisplay = new java.util.ArrayList<>(aggByGen.values());

        request.setAttribute("proposals", proposals);
        request.setAttribute("aggregations", aggregatedDisplay);
        request.setAttribute("selectedPeriod", period);
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("warehouses", new WarehouseDAO().findAll());

        List<Map<String, Object>> creatorGroups = new ArrayList<>();
        String lastCreator = null;
        Map<String, Object> currentGroup = null;
        for (ImportProposal prop : proposals) {
            String creator = prop.getCreatedByName();
            if (creator == null) creator = "(không xác định)";
            if (!creator.equals(lastCreator)) {
                currentGroup = new java.util.LinkedHashMap<>();
                currentGroup.put("creatorName", creator);
                List<ImportProposal> list = new ArrayList<>();
                list.add(prop);
                currentGroup.put("proposals", list);
                creatorGroups.add(currentGroup);
                lastCreator = creator;
            } else {
                ((List<ImportProposal>) currentGroup.get("proposals")).add(prop);
            }
        }
        request.setAttribute("creatorGroups", creatorGroups);

        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-review-create.jsp").forward(request, response);
    }

    private void submitReviewCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        String period = request.getParameter("period");
        if (period != null) period = period.replace("-", "");
        int warehouseId = parseInt(request.getParameter("warehouseId"));
        String note = request.getParameter("note");

        if (period != null && !PeriodUtils.isWithinDeadline(period)) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + period
                            + ". Không thể tạo phiếu mua cho period này.");
            session.setAttribute("toastType", "danger");
            StringBuilder back = new StringBuilder("/purchase-order?action=reviewCreate");
            String[] proposalIdArr = request.getParameterValues("proposalId");
            if (proposalIdArr != null) {
                for (String pid : proposalIdArr) {
                    back.append("&proposalIds=").append(pid);
                }
            }
            response.sendRedirect(request.getContextPath() + back.toString());
            return;
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] proposalIdArr = request.getParameterValues("proposalId");
        String[] proposalDetailIdArr = request.getParameterValues("proposalDetailId");
        String[] finalQtys = request.getParameterValues("finalQuantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        String[] detailNotes = request.getParameterValues("detailNote");

        java.util.Set<Integer> uniqueProposalIds = new java.util.LinkedHashSet<>();
        if (proposalIdArr != null) {
            for (String s : proposalIdArr) {
                int id = parseInt(s);
                if (id > 0) {
                    uniqueProposalIds.add(id);
                }
            }
        }
        List<Integer> proposalIds = new ArrayList<>(uniqueProposalIds);

        if (genIds == null || genIds.length == 0 || proposalIds.isEmpty()) {
            session.setAttribute("toastMessage", "Thiếu dữ liệu đầu vào");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        try {
            PurchaseOrderDAO dao = new PurchaseOrderDAO();

            PurchaseOrderDAO aggDao = new PurchaseOrderDAO();
            List<Map<String, Object>> aggs = aggDao.aggregateByProposalIds(proposalIds, warehouseId);

            PurchaseOrder po = new PurchaseOrder();
            po.setPoCode(dao.generatePoCode(period));
            po.setPeriod(period);
            po.setPeriodStart(PeriodUtils.startOf(period));
            po.setPeriodEnd(PeriodUtils.endOf(period));
            po.setWarehouseId(warehouseId);
            po.setCreatedBy(user.getId());
            po.setStatus(GlobalUtils.PO_STATUS_PENDING_CEO);
            po.setNote(note);

            List<PurchaseOrderDetail> details = new ArrayList<>();
            int totalQty = 0;

            java.util.Map<Integer, int[]> qtyByGen = new java.util.LinkedHashMap<>();
            java.util.Map<Integer, String> noteByGen = new java.util.LinkedHashMap<>();
            java.util.Map<Integer, java.math.BigDecimal> priceByGen = new java.util.LinkedHashMap<>();

            for (int i = 0; i < genIds.length; i++) {
                int gid = parseInt(genIds[i]);
                if (gid <= 0) continue;
                int qty = (finalQtys != null && i < finalQtys.length) ? parseInt(finalQtys[i]) : 0;
                int pdId = (proposalDetailIdArr != null && i < proposalDetailIdArr.length)
                        ? parseInt(proposalDetailIdArr[i]) : 0;
                if (qty <= 0) continue;

                int[] cur = qtyByGen.get(gid);
                if (cur == null) {
                    cur = new int[]{0, pdId};
                    qtyByGen.put(gid, cur);
                }
                cur[0] += qty;
                if (cur[1] <= 0 && pdId > 0) {
                    cur[1] = pdId;
                }

                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                if (dNote != null && !dNote.trim().isEmpty() && !noteByGen.containsKey(gid)) {
                    noteByGen.put(gid, dNote.trim());
                }

                if (unitPrices != null && i < unitPrices.length) {
                    String up = unitPrices[i];
                    if (up != null && !up.trim().isEmpty() && !priceByGen.containsKey(gid)) {
                        try {
                            priceByGen.put(gid, new java.math.BigDecimal(up.trim().replaceAll("[^0-9.]", "")));
                        } catch (Exception ignored) {}
                    }
                }
            }

            for (java.util.Map.Entry<Integer, int[]> entry : qtyByGen.entrySet()) {
                int gid = entry.getKey();
                int qty = entry.getValue()[0];
                int firstPdId = entry.getValue()[1];

                int proposed = 0, stock = 0;
                for (Map<String, Object> a : aggs) {
                    Object genIdObj = a.get("generatorId");
                    if (genIdObj == null || ((Number) genIdObj).intValue() != gid) continue;
                    Object tpObj = a.get("totalProposed");
                    Object csObj = a.get("currentStock");
                    if (tpObj != null) proposed += ((Number) tpObj).intValue();
                    if (csObj != null && stock == 0) stock = ((Number) csObj).intValue();
                }

                PurchaseOrderDetail d = new PurchaseOrderDetail();
                d.setProposalDetailId(firstPdId > 0 ? firstPdId : null);
                d.setGeneratorId(gid);
                d.setProposedQuantity(proposed);
                d.setCurrentStock(stock);
                d.setFinalQuantity(qty);
                d.setNote(noteByGen.get(gid));
                d.setUnitPrice(priceByGen.get(gid));
                details.add(d);
                totalQty += qty;
            }
            po.setTotalQuantity(totalQty);

            if (details.isEmpty()) {
                session.setAttribute("toastMessage", "Chưa có dòng máy hợp lệ nào");
                session.setAttribute("toastType", "danger");
                StringBuilder back = new StringBuilder("/purchase-order?action=reviewCreate");
                for (Integer pid : proposalIds) {
                    back.append("&proposalIds=").append(pid);
                }
                response.sendRedirect(request.getContextPath() + back.toString());
                return;
            }

            int poId = dao.createPoWithDetailsAndLinks(po, details, proposalIds);
            if (poId <= 0) {
                throw new Exception("Tạo phiếu mua thất bại");
            }

            dao.sendToCeo(poId);

            session.setAttribute("toastMessage", "Tạo phiếu mua thành công");
            session.setAttribute("toastType", "success");

            List<User> ceoUsers = userDAO.findUsersByPermission("purchase_orders", "approve_ceo");
            for (User u : ceoUsers) {
                NotificationService.send(
                    u.getId(),
                    "Phiếu mua " + po.getPoCode() + " chờ CEO duyệt",
                    "Nhân viên " + user.getName() + " vừa tạo phiếu mua cần CEO duyệt.",
                    request.getContextPath() + "/purchase-order?action=detail&id=" + poId,
                    "purchase_order",
                    poId
                );
            }

            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + poId);
        } catch (Exception e) {
            SystemLogger.error(LogModule.PURCHASE, "PurchaseOrderController.submitReviewCreate", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi: " + e.getMessage());
            session.setAttribute("toastType", "danger");
            StringBuilder back = new StringBuilder("/purchase-order?action=reviewCreate");
            for (Integer pid : proposalIds) {
                back.append("&proposalIds=").append(pid);
            }
            response.sendRedirect(request.getContextPath() + back.toString());
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.view")) {
            session.setAttribute("toastMessage", "Bạn không có quyền xem phiếu mua.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        int id = parseInt(request.getParameter("id"));
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        PurchaseOrder po = dao.findById(id);
        if (po == null) {
            session.setAttribute("toastMessage", "Không tìm thấy phiếu mua");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        java.math.BigDecimal grandTotal = java.math.BigDecimal.ZERO;
        int totalRows = 0;
        if (po.getDetails() != null) {
            totalRows = po.getDetails().size();
            for (PurchaseOrderDetail d : po.getDetails()) {
                if (d.getUnitPrice() != null) {
                    grandTotal = grandTotal.add(
                        d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getFinalQuantity())));
                }
            }
        }

        String tab = request.getParameter("tab");
        String currentTab = "info";
        if ("history".equals(tab)) currentTab = "history";
        else if ("proposals".equals(tab)) currentTab = "proposals";
        request.setAttribute("currentTab", currentTab);

        if ("history".equals(currentTab)) {
            buildHistoryLog(request, po);
        }

        List<ImportProposal> sourceProposals = dao.findProposalsByPo(id);
        request.setAttribute("po", po);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("totalRows", totalRows);
        request.setAttribute("sourceProposals", sourceProposals);
        request.setAttribute("canApprovePo", perms.contains("purchase_orders.approve"));
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-detail.jsp").forward(request, response);
    }

    private void buildHistoryLog(HttpServletRequest request, PurchaseOrder po) {
        String logSearch = request.getParameter("logSearch");
        String logAction = request.getParameter("logAction");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        List<Map<String, Object>> logList = new ArrayList<>();

        if (po.getCreatedAt() != null) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getCreatedAt()));
            m.put("user", po.getCreatedByName() != null ? po.getCreatedByName() : "—");
            m.put("action", "CREATE");
            m.put("actionLabel", "Tạo phiếu mua");
            m.put("details", "Tạo phiếu mua " + po.getPoCode());
            logList.add(m);
        }

        if (po.getSentToCeoAt() != null
                && (po.getCreatedAt() == null || !po.getSentToCeoAt().isEqual(po.getCreatedAt()))) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getSentToCeoAt()));
            m.put("user", po.getCreatedByName() != null ? po.getCreatedByName() : "—");
            m.put("action", "SEND_TO_CEO");
            m.put("actionLabel", "Gửi CEO duyệt");
            m.put("details", "Gửi phiếu mua " + po.getPoCode() + " cho CEO duyệt");
            logList.add(m);
        }

        if (po.getApprovedBy() != null && po.getApprovedAt() != null) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getApprovedAt()));
            m.put("user", po.getApprovedByName() != null ? po.getApprovedByName() : "—");
            m.put("action", "APPROVE");
            m.put("actionLabel", "Duyệt phiếu mua");
            m.put("details", "Duyệt phiếu mua " + po.getPoCode());
            logList.add(m);
        }

        if ("RETURNED".equals(po.getStatus()) && po.getRejectedAt() != null) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getRejectedAt()));
            m.put("user", po.getRejectedByName() != null ? po.getRejectedByName() : "—");
            m.put("action", "RETURN");
            m.put("actionLabel", "Trả lại chỉnh sửa");
            m.put("details", "Trả lại phiếu mua cho bộ phận tạo"
                    + (po.getRejectReason() != null ? ": " + po.getRejectReason() : ""));
            logList.add(m);
        } else if ("REJECTED".equals(po.getStatus()) && po.getRejectedAt() != null) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getRejectedAt()));
            m.put("user", po.getRejectedByName() != null ? po.getRejectedByName() : "—");
            m.put("action", "REJECT");
            m.put("actionLabel", "Từ chối");
            m.put("details", "Từ chối phiếu mua"
                    + (po.getRejectReason() != null ? ": " + po.getRejectReason() : ""));
            logList.add(m);
        }

        if ("CANCELLED".equals(po.getStatus()) && po.getRejectedAt() != null) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getRejectedAt()));
            m.put("user", po.getRejectedByName() != null ? po.getRejectedByName() : "—");
            String mode = po.getCancelMode();
            String cancelLabel = "REBUILD".equals(mode) ? "Hủy & trả đề xuất về chờ duyệt" : "Hủy & từ chối đề xuất";
            m.put("action", "CANCEL");
            m.put("actionLabel", cancelLabel);
            m.put("details", cancelLabel + " phiếu mua " + po.getPoCode()
                    + (po.getCancelReason() != null ? ": " + po.getCancelReason() : ""));
            logList.add(m);
        }

        if (po.getUpdatedAt() != null && po.getCreatedAt() != null
                && po.getUpdatedAt().isAfter(po.getCreatedAt())
                && !"RETURNED".equals(po.getStatus())
                && !"REJECTED".equals(po.getStatus())
                && !"CANCELLED".equals(po.getStatus())
                && po.getApprovedBy() == null) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("createdAt", toDate(po.getUpdatedAt()));
            m.put("user", po.getCreatedByName() != null ? po.getCreatedByName() : "—");
            m.put("action", "UPDATE");
            m.put("actionLabel", "Cập nhật");
            m.put("details", "Cập nhật nội dung phiếu mua");
            logList.add(m);
        }

        List<Map<String, Object>> filtered = new ArrayList<>();
        for (Map<String, Object> m : logList) {
            if (logAction != null && !logAction.trim().isEmpty()
                    && !logAction.equalsIgnoreCase((String) m.get("action"))) {
                continue;
            }
            if (logSearch != null && !logSearch.trim().isEmpty()) {
                String s = logSearch.trim().toLowerCase();
                boolean match = ((String) m.get("user")).toLowerCase().contains(s)
                        || ((String) m.get("actionLabel")).toLowerCase().contains(s)
                        || ((String) m.get("details")).toLowerCase().contains(s);
                if (!match) {
                    continue;
                }
            }
            Date created = (Date) m.get("createdAt");
            if (dateFrom != null && !dateFrom.trim().isEmpty()) {
                try {
                    Date from = new SimpleDateFormat("yyyy-MM-dd").parse(dateFrom);
                    if (created.before(from)) {
                        continue;
                    }
                } catch (Exception ignored) {
                }
            }
            if (dateTo != null && !dateTo.trim().isEmpty()) {
                try {
                    Date to = new SimpleDateFormat("yyyy-MM-dd").parse(dateTo);
                    Date endOfDay = new Date(to.getTime() + 24L * 60 * 60 * 1000 - 1);
                    if (created.after(endOfDay)) {
                        continue;
                    }
                } catch (Exception ignored) {
                }
            }
            filtered.add(m);
        }

        filtered.sort((a, b) -> {
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
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {
                page = 1;
            }
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

    private void showRejectForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền từ chối phiếu mua.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        int id = parseInt(request.getParameter("id"));
        request.setAttribute("po", new PurchaseOrderDAO().findById(id));
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-reject.jsp").forward(request, response);
    }

    private void approve(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền duyệt phiếu mua.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        int id = parseInt(request.getParameter("id"));
        PurchaseOrderDAO poDao = new PurchaseOrderDAO();
        boolean ok = poDao.approve(id, user.getId());
        if (ok) {
            session.setAttribute("toastMessage", "Đã duyệt phiếu mua");
            session.setAttribute("toastType", "success");

            PurchaseOrder po = poDao.findById(id);
            if (po != null && po.getCreatedBy() > 0) {
                NotificationService.send(
                    po.getCreatedBy(),
                    "Phiếu mua " + po.getPoCode() + " đã được duyệt",
                    "Phiếu mua " + po.getPoCode() + " đã được " + user.getName() + " duyệt.",
                    request.getContextPath() + "/purchase-order?action=detail&id=" + id,
                    "purchase_order",
                    id
                );
            }
        } else {
            session.setAttribute("toastMessage", "Không thể duyệt");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private void reject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền từ chối phiếu mua.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        int id = parseInt(request.getParameter("id"));
        String reason = request.getParameter("rejectReason");
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Vui lòng nhập lý do từ chối");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=reject&id=" + id);
            return;
        }
        PurchaseOrderDAO poDao = new PurchaseOrderDAO();
        boolean ok = poDao.reject(id, user.getId(), reason.trim());
        if (ok) {
            session.setAttribute("toastMessage", "Đã từ chối phiếu mua");
            session.setAttribute("toastType", "success");

            PurchaseOrder po = poDao.findById(id);
            if (po != null && po.getCreatedBy() > 0) {
                NotificationService.send(
                    po.getCreatedBy(),
                    "Phiếu mua " + po.getPoCode() + " bị từ chối",
                    "Phiếu mua " + po.getPoCode() + " bị " + user.getName() + " từ chối (lý do: " + reason.trim() + ").",
                    request.getContextPath() + "/purchase-order?action=detail&id=" + id,
                    "purchase_order",
                    id
                );
            }
        } else {
            session.setAttribute("toastMessage", "Không thể từ chối");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private int parseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return 0;
        }
    }

    private Date toDate(java.time.LocalDateTime ldt) {
        if (ldt == null) return null;
        return Date.from(ldt.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }
}