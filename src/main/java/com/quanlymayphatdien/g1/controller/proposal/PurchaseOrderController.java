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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
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
                case "create":
                    showCreateForm(request, response);
                    break;
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
            SystemLogger.error("Quản lý phiếu mua", "PurchaseOrderController.doGet", e.getMessage(), e);
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
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
                case "create":
                    create(request, response);
                    break;
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
            SystemLogger.error("Quản lý phiếu mua", "PurchaseOrderController.doPost", e.getMessage(), e);
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi xử lý: " + e.getMessage());
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

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("message", "Bạn không có quyền tạo phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        String period = request.getParameter("period");
        if (period != null) period = period.replace("-", "");
        if (period == null || period.isEmpty()) {
            period = PeriodUtils.currentPeriod();
        }
        int warehouseId = parseInt(request.getParameter("warehouseId"));

        boolean quarterBlocked = warehouseId > 0
                && new PurchaseOrderDAO().hasRejectedPo(period, warehouseId);

        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("selectedPeriod", period);
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("quarterBlocked", quarterBlocked);
        request.setAttribute("blockedPeriod", period);
        if (warehouseId > 0) {
            request.setAttribute("aggregations",
                    new PurchaseOrderDAO().aggregatePendingProposals(period, warehouseId));
        }
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-create.jsp").forward(request, response);
    }

    private void showReviewCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("message", "Bạn không có quyền tạo phiếu mua");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String[] proposalIdArr = request.getParameterValues("proposalIds");
        if (proposalIdArr == null || proposalIdArr.length == 0) {
            session.setAttribute("message", "Chưa chọn phiếu đề xuất nào");
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
            session.setAttribute("message", "Danh sách phiếu đề xuất không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        ImportProposalDAO ipDao = new ImportProposalDAO();
        List<ImportProposal> proposals = ipDao.findByIdsForReview(proposalIds);
        if (proposals.size() != proposalIds.size()) {
            session.setAttribute("message", "Một số phiếu đề xuất không hợp lệ (đã bị xử lý hoặc không tồn tại)");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String period = proposals.get(0).getPeriod();
        int warehouseId = proposals.get(0).getWarehouseId();
        for (ImportProposal p : proposals) {
            if (!period.equals(p.getPeriod()) || warehouseId != p.getWarehouseId()) {
                session.setAttribute("message", "Tất cả phiếu đề xuất phải cùng kỳ và cùng kho");
                response.sendRedirect(request.getContextPath() + "/proposal?action=list");
                return;
            }
        }
        if (new PurchaseOrderDAO().hasRejectedPo(period, warehouseId)) {
            session.setAttribute("toastMessage",
                    "Tháng " + period + " tại kho này đã bị CEO từ chối PO. Không thể tạo PO mới.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        PurchaseOrderDAO poDao = new PurchaseOrderDAO();
        List<Map<String, Object>> aggregations = poDao.aggregateByProposalIds(proposalIds, warehouseId);
        PurchaseOrder existingPo = poDao.findActivePoByPeriodWarehouse(period, warehouseId);
        boolean quarterBlocked = poDao.hasRejectedPo(period, warehouseId);

        request.setAttribute("proposals", proposals);
        request.setAttribute("aggregations", aggregations);
        request.setAttribute("selectedPeriod", period);
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("existingPo", existingPo);
        request.setAttribute("quarterBlocked", quarterBlocked);
        request.setAttribute("blockedPeriod", period);
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-review-create.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        String period = request.getParameter("period");
        if (period != null) period = period.replace("-", "");
        int warehouseId = parseInt(request.getParameter("warehouseId"));
        String submitType = request.getParameter("submitType");
        String note = request.getParameter("note");

        if (period != null && !period.isEmpty() && warehouseId > 0
                && new PurchaseOrderDAO().hasRejectedPo(period, warehouseId)) {
            session.setAttribute("toastMessage",
                    "Tháng " + period + " tại kho này đã bị CEO từ chối PO. Không thể tạo PO mới.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        String[] genIds = request.getParameterValues("generatorId");
        String[] finalQtys = request.getParameterValues("finalQuantity");
        String[] detailNotes = request.getParameterValues("detailNote");

        if (genIds == null || genIds.length == 0) {
            session.setAttribute("message", "Chưa chọn dòng máy nào");
            response.sendRedirect(request.getContextPath()
                    + "/purchase-order?action=create&period=" + period + "&warehouseId=" + warehouseId);
            return;
        }

        try {
            PurchaseOrderDAO dao = new PurchaseOrderDAO();
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
            List<Integer> genIdList = new ArrayList<>();
            int totalQty = 0;
            for (int i = 0; i < genIds.length; i++) {
                int gid = parseInt(genIds[i]);
                int qty = (finalQtys != null && i < finalQtys.length) ? parseInt(finalQtys[i]) : 0;
                if (gid <= 0 || qty <= 0) continue;
                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                PurchaseOrderDetail d = new PurchaseOrderDetail();
                d.setGeneratorId(gid);
                d.setFinalQuantity(qty);
                d.setNote(dNote);
                details.add(d);
                genIdList.add(gid);
                totalQty += qty;
            }
            po.setTotalQuantity(totalQty);

            int poId = dao.insert(po);
            if (poId <= 0) {
                throw new Exception("Insert PO failed");
            }

            // Lay current_stock + proposed_quantity tu aggregation
            List<Map<String, Object>> aggs = dao.aggregatePendingProposals(period, warehouseId);
            for (int i = 0; i < details.size(); i++) {
                int gid = details.get(i).getGeneratorId();
                int proposed = 0, stock = 0;
                for (Map<String, Object> a : aggs) {
                    if (((Number) a.get("generatorId")).intValue() == gid) {
                        proposed = ((Number) a.get("totalProposed")).intValue();
                        stock = ((Number) a.get("currentStock")).intValue();
                        break;
                    }
                }
                details.get(i).setProposedQuantity(proposed);
                details.get(i).setCurrentStock(stock);
            }
            dao.insertDetails(poId, details);

            int linked = dao.linkProposalsToPo(poId, period, warehouseId, genIdList);
            dao.updateTotalProposals(poId, linked);

            if ("send".equals(submitType)) {
                dao.sendToCeo(poId);
            }

            session.setAttribute("message", "Tạo phiếu mua thành công");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + poId);
        } catch (Exception e) {
            SystemLogger.error("Quản lý phiếu mua", "PurchaseOrderController.create", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("message", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath()
                    + "/purchase-order?action=create&period=" + period + "&warehouseId=" + warehouseId);
        }
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

        if (period != null && !period.isEmpty() && warehouseId > 0
                && new PurchaseOrderDAO().hasRejectedPo(period, warehouseId)) {
            session.setAttribute("toastMessage",
                    "Tháng " + period + " tại kho này đã bị CEO từ chối PO. Không thể tạo PO mới.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        String[] proposalIdArr = request.getParameterValues("proposalIds");
        String[] genIds = request.getParameterValues("generatorId");
        String[] finalQtys = request.getParameterValues("finalQuantity");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<Integer> proposalIds = new ArrayList<>();
        if (proposalIdArr != null) {
            for (String s : proposalIdArr) {
                int id = parseInt(s);
                if (id > 0) {
                    proposalIds.add(id);
                }
            }
        }

        if (genIds == null || genIds.length == 0 || proposalIds.isEmpty()) {
            session.setAttribute("message", "Thiếu dữ liệu đầu vào");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        try {
            PurchaseOrderDAO dao = new PurchaseOrderDAO();

            PurchaseOrder existing = dao.findActivePoByPeriodWarehouse(period, warehouseId);
            if (existing != null) {
                session.setAttribute("message",
                        "Đã tồn tại phiếu mua " + existing.getPoCode()
                        + " (trạng thái " + existing.getStatus() + ") cho kỳ và kho này");
                StringBuilder back = new StringBuilder("/purchase-order?action=reviewCreate");
                for (Integer pid : proposalIds) {
                    back.append("&proposalIds=").append(pid);
                }
                response.sendRedirect(request.getContextPath() + back.toString());
                return;
            }

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
                details.add(d);
                totalQty += qty;
            }
            po.setTotalQuantity(totalQty);

            if (details.isEmpty()) {
                session.setAttribute("message", "Chưa có dòng máy hợp lệ nào");
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

            session.setAttribute("message", "Tạo phiếu mua thành công");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + poId);
        } catch (Exception e) {
            SystemLogger.error("Quản lý phiếu mua", "PurchaseOrderController.submitReviewCreate", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("message", "Lỗi: " + e.getMessage());
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
            session.setAttribute("message", "Không tìm thấy phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        List<ImportProposal> sourceProposals = dao.findProposalsByPo(id);
        request.setAttribute("po", po);
        request.setAttribute("sourceProposals", sourceProposals);
        request.setAttribute("canApprovePo", perms.contains("purchase_orders.approve"));
        request.setAttribute("canCreatePo", perms.contains("purchase_orders.create"));
        request.setAttribute("activePage", "purchase-order");
        request.getRequestDispatcher("/view/purchase/purchase-detail.jsp").forward(request, response);
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
            session.setAttribute("toastMessage", "Bạn không có quyền duyệt phiếu mua.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        int id = parseInt(request.getParameter("id"));
        boolean ok = new PurchaseOrderDAO().approve(id, user.getId());
        if (ok) {
            session.setAttribute("toastMessage", "Đã duyệt phiếu mua");
            session.setAttribute("toastType", "success");
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
        boolean ok = new PurchaseOrderDAO().reject(id, user.getId(), reason.trim());
        if (ok) {
            session.setAttribute("toastMessage", "Đã từ chối phiếu mua");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể từ chối");
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
            session.setAttribute("message", "Bạn không có quyền trả phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        int id = parseInt(request.getParameter("id"));
        String reason = request.getParameter("returnReason");
        if (id <= 0) {
            session.setAttribute("message", "Thiếu mã phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("message", "Vui lòng nhập lý do trả lại");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
            return;
        }

        boolean ok = new PurchaseOrderDAO().returnPo(id, user.getId(), reason.trim());
        session.setAttribute("message", ok ? "Đã trả lại phiếu mua cho bộ phận tạo" : "Không thể trả lại phiếu mua");
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
    }

    private void editReturnedPo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("purchase_orders.create")) {
            session.setAttribute("message", "Bạn không có quyền chỉnh sửa phiếu mua");
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
            session.setAttribute("message", "Không tìm thấy phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }
        if (!GlobalUtils.PO_STATUS_RETURNED.equals(po.getStatus())) {
            session.setAttribute("message", "Phiếu mua không ở trạng thái RETURNED");
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
            session.setAttribute("message", "Thiếu mã phiếu mua");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
            return;
        }

        String note = request.getParameter("note");
        String[] proposalIdArr = request.getParameterValues("proposalIds");
        String[] genIds = request.getParameterValues("generatorId");
        String[] finalQtys = request.getParameterValues("finalQuantity");
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
            session.setAttribute("message", "Chưa có dòng máy nào hợp lệ");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=editReturned&id=" + id);
            return;
        }

        try {
            PurchaseOrderDAO dao = new PurchaseOrderDAO();
            PurchaseOrder existing = dao.findById(id);
            if (existing == null || !GlobalUtils.PO_STATUS_RETURNED.equals(existing.getStatus())) {
                session.setAttribute("message", "Phiếu mua không ở trạng thái RETURNED");
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
                details.add(d);
                totalQty += qty;
            }
            po.setTotalQuantity(totalQty);

            if (details.isEmpty()) {
                session.setAttribute("message", "Chưa có dòng máy hợp lệ nào");
                response.sendRedirect(request.getContextPath() + "/purchase-order?action=editReturned&id=" + id);
                return;
            }

            boolean ok = dao.updateReturnedPo(po, details, proposalIds);
            session.setAttribute("message", ok ? "Đã cập nhật và gửi lại CEO duyệt" : "Không thể cập nhật");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=detail&id=" + id);
        } catch (Exception e) {
            SystemLogger.error("Quản lý phiếu mua", "PurchaseOrderController.submitEditReturnedPo", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("message", "Lỗi: " + e.getMessage());
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
}
