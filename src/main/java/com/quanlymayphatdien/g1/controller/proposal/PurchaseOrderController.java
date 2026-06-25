package com.quanlymayphatdien.g1.controller.proposal;

import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.PurchaseOrderDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.PeriodUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
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
                case "editReturned":
                    editReturnedPo(request, response);
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
                case "sendToCeo":
                    sendToCeo(request, response);
                    break;
                case "approve":
                    approve(request, response);
                    break;
                case "reject":
                    reject(request, response);
                    break;
                case "return":
                    returnPo(request, response);
                    break;
                case "submitEditReturned":
                    submitEditReturnedPo(request, response);
                    break;
                case "cancel":
                    cancel(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.PURCHASE, "PurchaseOrderController.doPost", e.getMessage(), e);
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Lỗi xử lý: " + e.getMessage());
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
        request.setAttribute("canApprove", perms != null && perms.contains("purchase_orders.approve"));
        request.setAttribute("canApprovePo", perms != null && perms.contains("purchase_orders.approve"));
        request.setAttribute("canCreatePo", perms != null && perms.contains("purchase_orders.create"));
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

        PurchaseOrderDAO poDao = new PurchaseOrderDAO();
        List<Map<String, Object>> aggregations = poDao.aggregateByProposalIds(proposalIds, warehouseId);

        request.setAttribute("proposals", proposals);
        request.setAttribute("aggregations", aggregations);
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

        request.setAttribute("canApproveProposal", perms != null && perms.contains("proposals.approve"));
        request.setAttribute("currentUserId", user.getId());
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
        String submitType = request.getParameter("submitType");
        String note = request.getParameter("note");

        String[] genIds = request.getParameterValues("generatorId");
        String[] proposalIdArr = request.getParameterValues("proposalId");
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
            po.setStatus("send".equals(submitType) ? GlobalUtils.PO_STATUS_PENDING_CEO : GlobalUtils.PO_STATUS_DRAFT);
            po.setNote(note);

            List<PurchaseOrderDetail> details = new ArrayList<>();
            int totalQty = 0;
            for (int i = 0; i < genIds.length; i++) {
                int gid = parseInt(genIds[i]);
                int qty = (finalQtys != null && i < finalQtys.length) ? parseInt(finalQtys[i]) : 0;
                if (gid <= 0 || qty <= 0) {
                    continue;
                }
                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                int proposed = 0, stock = 0;
                for (Map<String, Object> a : aggs) {
                    if (((Number) a.get("generatorId")).intValue() == gid) {
                        proposed = ((Number) a.get("totalProposed")).intValue();
                        stock = ((Number) a.get("currentStock")).intValue();
                        break;
                    }
                }
                PurchaseOrderDetail d = new PurchaseOrderDetail();
                d.setGeneratorId(gid);
                d.setProposedQuantity(proposed);
                d.setCurrentStock(stock);
                d.setFinalQuantity(qty);
                d.setNote(dNote);
                if (unitPrices != null && i < unitPrices.length) {
                    String up = unitPrices[i];
                    if (up != null && !up.trim().isEmpty()) {
                        try { d.setUnitPrice(new java.math.BigDecimal(up.trim().replaceAll("[^0-9.]", ""))); } catch (Exception ignored) {}
                    }
                }
                details.add(d);
                totalQty += qty;
            }
            po.setTotalQuantity(totalQty);

            if (details.isEmpty()) {
                session.setAttribute("toastMessage", "Chưa có dòng máy hợp lệ nào");
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

            if ("send".equals(submitType)) {
                dao.sendToCeo(poId);
            }

            session.setAttribute("toastMessage", "Tạo phiếu mua thành công");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + poId);
        } catch (Exception e) {
            SystemLogger.error(LogModule.PURCHASE, "PurchaseOrderController.submitReviewCreate", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi: " + e.getMessage());
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
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        java.math.BigDecimal grandTotal = java.math.BigDecimal.ZERO;
        if (po.getDetails() != null) {
            for (PurchaseOrderDetail d : po.getDetails()) {
                if (d.getUnitPrice() != null) {
                    grandTotal = grandTotal.add(
                        d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getFinalQuantity())));
                }
            }
        }

        String tab = request.getParameter("tab");
        String currentTab = "history".equals(tab) ? "history" : "info";
        request.setAttribute("currentTab", currentTab);

        if ("history".equals(currentTab)) {
            buildHistoryLog(request, po);
        }

        List<ImportProposal> sourceProposals = dao.findProposalsByPo(id);
        request.setAttribute("po", po);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("sourceProposals", sourceProposals);
        request.setAttribute("canApprovePo", perms.contains("purchase_orders.approve"));
        request.setAttribute("canCreatePo", perms.contains("purchase_orders.create"));
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
            session.setAttribute("toastMessage", "Bạn không có quyền từ chối phiếu mua (CEO).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        int id = parseInt(request.getParameter("id"));
        request.setAttribute("po", new PurchaseOrderDAO().findById(id));
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-reject.jsp").forward(request, response);
    }

    private void sendToCeo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền gửi phiếu mua cho CEO duyệt.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        int id = parseInt(request.getParameter("id"));
        boolean ok = new PurchaseOrderDAO().sendToCeo(id);
        if (ok) {
            session.setAttribute("toastMessage", "Đã gửi CEO duyệt");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể gửi");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private void approve(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền duyệt phiếu mua (CEO).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        int id = parseInt(request.getParameter("id"));
        boolean ok = new PurchaseOrderDAO().approve(id, user.getId());
        if (ok) {
            session.setAttribute("toastMessage", "Đã duyệt phiếu mua (CEO)");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể duyệt (CEO)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private void reject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền từ chối phiếu mua (CEO).");
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
        boolean ok = new PurchaseOrderDAO().reject(id, user.getId(), reason.trim());
        if (ok) {
            session.setAttribute("toastMessage", "Đã từ chối phiếu mua (CEO)");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể từ chối (CEO)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private void returnPo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền trả phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        int id = parseInt(request.getParameter("id"));
        String reason = request.getParameter("returnReason");
        if (id <= 0) {
            session.setAttribute("toastMessage", "Thiếu mã phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Vui lòng nhập lý do trả lại");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
            return;
        }

        boolean ok = new PurchaseOrderDAO().returnPo(id, user.getId(), reason.trim());
        session.setAttribute("toastMessage", ok ? "Đã trả lại phiếu mua cho bộ phận tạo" : "Không thể trả lại phiếu mua");
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private void editReturnedPo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền chỉnh sửa phiếu mua");
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
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        if (!GlobalUtils.PO_STATUS_RETURNED.equals(po.getStatus())) {
            session.setAttribute("toastMessage", "Phiếu mua không ở trạng thái RETURNED");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
            return;
        }

        List<ImportProposal> sourceProposals = dao.findProposalsByPo(id);

        request.setAttribute("po", po);
        request.setAttribute("sourceProposals", sourceProposals);
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-edit-returned.jsp").forward(request, response);
    }

    private void submitEditReturnedPo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        int id = parseInt(request.getParameter("id"));
        if (id <= 0) {
            session.setAttribute("toastMessage", "Thiếu mã phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        String note = request.getParameter("note");
        String[] proposalIdArr = request.getParameterValues("proposalIds");
        String[] genIds = request.getParameterValues("generatorId");
        String[] finalQtys = request.getParameterValues("finalQuantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<Integer> proposalIds = new ArrayList<>();
        if (proposalIdArr != null) {
            for (String s : proposalIdArr) {
                int pid = parseInt(s);
                if (pid > 0) {
                    proposalIds.add(pid);
                }
            }
        }

        if (genIds == null || genIds.length == 0) {
            session.setAttribute("toastMessage", "Chưa có dòng máy nào hợp lệ");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=editReturned&id=" + id);
            return;
        }

        try {
            PurchaseOrderDAO dao = new PurchaseOrderDAO();
            PurchaseOrder existing = dao.findById(id);
            if (existing == null || !GlobalUtils.PO_STATUS_RETURNED.equals(existing.getStatus())) {
                session.setAttribute("toastMessage", "Phiếu mua không ở trạng thái RETURNED");
                response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
                return;
            }

            List<Map<String, Object>> aggs = dao.aggregateByProposalIds(proposalIds, existing.getWarehouseId());

            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(id);
            po.setNote(note);

            List<PurchaseOrderDetail> details = new ArrayList<>();
            int totalQty = 0;
            for (int i = 0; i < genIds.length; i++) {
                int gid = parseInt(genIds[i]);
                int qty = (finalQtys != null && i < finalQtys.length) ? parseInt(finalQtys[i]) : 0;
                if (gid <= 0 || qty <= 0) {
                    continue;
                }
                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                int proposed = 0, stock = 0;
                for (Map<String, Object> a : aggs) {
                    if (((Number) a.get("generatorId")).intValue() == gid) {
                        proposed = ((Number) a.get("totalProposed")).intValue();
                        stock = ((Number) a.get("currentStock")).intValue();
                        break;
                    }
                }
                PurchaseOrderDetail d = new PurchaseOrderDetail();
                d.setGeneratorId(gid);
                d.setProposedQuantity(proposed);
                d.setCurrentStock(stock);
                d.setFinalQuantity(qty);
                d.setNote(dNote);
                if (unitPrices != null && i < unitPrices.length) {
                    String up = unitPrices[i];
                    if (up != null && !up.trim().isEmpty()) {
                        try { d.setUnitPrice(new java.math.BigDecimal(up.trim().replaceAll("[^0-9.]", ""))); } catch (Exception ignored) {}
                    }
                }
                details.add(d);
                totalQty += qty;
            }
            po.setTotalQuantity(totalQty);

            if (details.isEmpty()) {
                session.setAttribute("toastMessage", "Chưa có dòng máy hợp lệ nào");
                response.sendRedirect(request.getContextPath() + "/purchase-order?action=editReturned&id=" + id);
                return;
            }

            boolean ok = dao.updateReturnedPo(po, details, proposalIds);
            session.setAttribute("toastMessage", ok ? "Đã cập nhật và gửi lại CEO duyệt" : "Không thể cập nhật");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
        } catch (Exception e) {
            SystemLogger.error(LogModule.PURCHASE, "PurchaseOrderController.submitEditReturnedPo", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=editReturned&id=" + id);
        }
    }

    private void cancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền hủy phiếu mua.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        int id = parseInt(request.getParameter("id"));
        String cancelMode = request.getParameter("cancelMode");
        String cancelReason = request.getParameter("cancelReason");

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        boolean ok;
        String message;
        String toastType;
        if (cancelMode == null || cancelMode.trim().isEmpty()) {
            ok = dao.cancel(id);
            message = ok ? "Đã hủy phiếu mua" : "Không thể hủy";
            toastType = ok ? "success" : "danger";
        } else {
            if (!"REBUILD".equals(cancelMode) && !"KILL".equals(cancelMode)) {
                session.setAttribute("toastMessage", "Chế độ hủy không hợp lệ");
                session.setAttribute("toastType", "danger");
                response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
                return;
            }
            ok = dao.cancelWithMode(id, user.getId(), cancelMode, cancelReason);
            message = ok
                    ? ("REBUILD".equals(cancelMode) ? "Đã hủy và trả đề xuất về chờ duyệt" : "Đã hủy và từ chối các đề xuất")
                    : "Không thể hủy";
            toastType = ok ? "success" : "danger";
        }
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", toastType);
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
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