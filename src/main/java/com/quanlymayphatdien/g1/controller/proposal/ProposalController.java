package com.quanlymayphatdien.g1.controller.proposal;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@WebServlet(name = "ProposalController", urlPatterns = {"/proposal"})
public class ProposalController extends HttpServlet {

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
            request.setAttribute("activePage", "proposal");
            switch (action) {
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "reject":
                    showRejectForm(request, response);
                    break;
                default:
                    listProposals(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý đề xuất nhập", "ProposalController.doGet", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
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
                case "save":
                    saveProposal(request, response);
                    break;
                case "update":
                    updateProposal(request, response);
                    break;
                case "delete":
                    deleteProposal(request, response);
                    break;
                case "approve":
                    approveProposal(request, response);
                    break;
                case "reject":
                    rejectProposal(request, response);
                    break;
                case "cancel":
                    cancelProposal(request, response);
                    break;
                case "convert":
                    convertToReceipt(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý đề xuất nhập", "ProposalController.doPost", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi: " + e.getMessage());
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
        }
    }

    private void listProposals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean canApprove = perms != null && perms.contains("proposals.approve");
        Integer createdByFilter = canApprove ? null : loggedUser.getId();
        boolean excludeDraftForList = canApprove;
        boolean excludeDraftForTotal = true;

        String statusFilter = request.getParameter("status");
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
                page = 1;
            }
        }

        ImportProposalDAO dao = new ImportProposalDAO();
        int total = dao.countByFilters(statusFilter, search, createdByFilter, excludeDraftForTotal);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<ImportProposal> proposals = dao.searchByFilters(statusFilter, search, createdByFilter, excludeDraftForList, page, pageSize);
        int fromIndex = total == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, total);

        request.setAttribute("proposals", proposals);
        request.setAttribute("totalProposals", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("search", search);

        request.setAttribute("pendingCount",   dao.countByStatus(GlobalUtils.STATUS_PENDING,   createdByFilter, excludeDraftForList));
        request.setAttribute("approvedCount",  dao.countByStatus(GlobalUtils.STATUS_APPROVED,  createdByFilter, excludeDraftForList));
        request.setAttribute("rejectedCount",  dao.countByStatus(GlobalUtils.STATUS_REJECTED,  createdByFilter, excludeDraftForList));
        request.setAttribute("cancelledCount", dao.countByStatus(GlobalUtils.STATUS_CANCELLED, createdByFilter, excludeDraftForList));

        request.getRequestDispatcher("/view/proposal/proposal-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền tạo phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("generators", new GeneratorDAO().findAll());
        request.getRequestDispatcher("/view/proposal/proposal-create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposal p = new ImportProposalDAO().findById(id);
        if (p == null
                || !GlobalUtils.STATUS_DRAFT.equals(p.getStatus())
                || p.getCreatedBy() != currentUserId(request)) {
            session.setAttribute("toastMessage", "Không thể sửa phiếu này (đã gửi duyệt hoặc không phải người tạo).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        request.setAttribute("proposal", p);
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("generators", new GeneratorDAO().findAll());
        request.getRequestDispatcher("/view/proposal/proposal-edit.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposal p = new ImportProposalDAO().findById(id);
        if (p == null) {
            request.getSession().setAttribute("toastMessage", "Không tìm thấy phiếu đề xuất");
            request.getSession().setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ActivityLogDAO logDAO = new ActivityLogDAO();
        List<ActivityLog> history = logDAO.findByEntityTypeAndId("import_proposal", id, 1, 100);
        int totalHistory = logDAO.countByEntityTypeAndId("import_proposal", id);

        request.setAttribute("proposal", p);
        request.setAttribute("history", history);
        request.setAttribute("totalHistory", totalHistory);
        request.getRequestDispatcher("/view/proposal/proposal-detail.jsp").forward(request, response);
    }

    private void showRejectForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.reject")) {
            session.setAttribute("toastMessage", "Bạn không có quyền từ chối phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposal p = new ImportProposalDAO().findById(id);
        if (p == null || !GlobalUtils.STATUS_PENDING.equals(p.getStatus())) {
            session.setAttribute("toastMessage", "Chỉ phiếu đang chờ duyệt mới có thể từ chối.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
        request.setAttribute("proposal", p);
        request.getRequestDispatcher("/view/proposal/proposal-reject.jsp").forward(request, response);
    }

    private void saveProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền tạo phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        String submitType = request.getParameter("submitType");
        ImportProposal p = new ImportProposal();
        p.setWarehouseId(parseInt(request.getParameter("warehouseId")));
        p.setNote(request.getParameter("note"));
        p.setStatus("draft".equals(submitType) ? GlobalUtils.STATUS_DRAFT : GlobalUtils.STATUS_PENDING);
        p.setCreatedBy(user.getId());
        p.setProposalDate(LocalDateTime.now());

        ImportProposalDAO dao = new ImportProposalDAO();
        p.setProposalCode(dao.generateProposalCode());
        int newId = dao.insert(p);
        if (newId <= 0) {
            session.setAttribute("toastMessage", "Không thể tạo phiếu đề xuất, vui lòng thử lại");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        List<ImportProposalDetail> details = parseDetailsFromRequest(request, newId);
        if (!details.isEmpty()) {
            dao.insertDetailsBatch(details);
        }

        logActivity(user.getId(), "import_proposal", "CREATE", newId,
                p.getProposalCode(),
                "draft".equals(submitType) ? "Tạo phiếu đề xuất (nháp)" : "Tạo phiếu đề xuất (gửi duyệt)");

        session.setAttribute("toastMessage", "Tạo phiếu đề xuất thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + newId);
    }

    private void updateProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposalDAO dao = new ImportProposalDAO();
        ImportProposal existing = dao.findById(id);
        if (existing == null
                || !GlobalUtils.STATUS_DRAFT.equals(existing.getStatus())
                || existing.getCreatedBy() != currentUserId(request)) {
            session.setAttribute("toastMessage", "Không thể cập nhật phiếu này (đã gửi duyệt hoặc không phải người tạo).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String submitType = request.getParameter("submitType");
        ImportProposal p = new ImportProposal();
        p.setProposalId(id);
        p.setNote(request.getParameter("note"));
        p.setStatus("draft".equals(submitType) ? GlobalUtils.STATUS_DRAFT : GlobalUtils.STATUS_PENDING);
        dao.update(p);

        dao.deleteDetails(id);
        List<ImportProposalDetail> details = parseDetailsFromRequest(request, id);
        if (!details.isEmpty()) {
            dao.insertDetailsBatch(details);
        }

        logActivity(currentUserId(request), "import_proposal", "UPDATE", id,
                existing.getProposalCode(),
                "draft".equals(submitType) ? "Cập nhật phiếu đề xuất (nháp)" : "Cập nhật và gửi duyệt");

        session.setAttribute("toastMessage", "Cập nhật phiếu đề xuất thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
    }

    private void deleteProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposalDAO dao = new ImportProposalDAO();
        ImportProposal existing = dao.findById(id);
        if (existing == null
                || !GlobalUtils.STATUS_DRAFT.equals(existing.getStatus())
                || existing.getCreatedBy() != currentUserId(request)) {
            session.setAttribute("toastMessage", "Không thể xoá phiếu này (đã gửi duyệt hoặc không phải người tạo).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposal p = new ImportProposal();
        p.setProposalId(id);
        boolean ok = dao.delete(p);
        if (ok) {
            logActivity(currentUserId(request), "import_proposal", "DELETE", id,
                    existing.getProposalCode(), "Xoá phiếu đề xuất nháp");
            session.setAttribute("toastMessage", "Đã xoá phiếu đề xuất");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể xoá phiếu");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/proposal?action=list");
    }

    private void approveProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền duyệt phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposalDAO dao = new ImportProposalDAO();
        boolean ok = dao.approveProposal(id, currentUserId(request));
        if (ok) {
            ImportProposal p = dao.findById(id);
            logActivity(currentUserId(request), "import_proposal", "APPROVE", id,
                    p != null ? p.getProposalCode() : null, "Duyệt phiếu đề xuất");
            session.setAttribute("toastMessage", "Đã duyệt phiếu đề xuất");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể duyệt (phiếu không ở trạng thái chờ duyệt)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
    }

    private void rejectProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.reject")) {
            session.setAttribute("toastMessage", "Bạn không có quyền từ chối phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        String reason = request.getParameter("rejectReason");
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Vui lòng nhập lý do từ chối");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
        ImportProposalDAO dao = new ImportProposalDAO();
        boolean ok = dao.rejectProposal(id, currentUserId(request), reason.trim());
        if (ok) {
            ImportProposal p = dao.findById(id);
            logActivity(currentUserId(request), "import_proposal", "REJECT", id,
                    p != null ? p.getProposalCode() : null, "Từ chối: " + reason.trim());
            session.setAttribute("toastMessage", "Đã từ chối phiếu đề xuất");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể từ chối (phiếu không ở trạng thái chờ duyệt)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
    }

    private void cancelProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.cancel")) {
            session.setAttribute("toastMessage", "Bạn không có quyền huỷ phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposalDAO dao = new ImportProposalDAO();
        boolean ok = dao.cancelProposal(id, currentUserId(request));
        if (ok) {
            ImportProposal p = dao.findById(id);
            logActivity(currentUserId(request), "import_proposal", "CANCEL", id,
                    p != null ? p.getProposalCode() : null, "Huỷ phiếu đề xuất");
            session.setAttribute("toastMessage", "Đã huỷ phiếu đề xuất");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể huỷ (phiếu đã chuyển đổi hoặc đã huỷ)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
    }

    private void convertToReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposal p = new ImportProposalDAO().findById(id);
        if (p == null || !GlobalUtils.STATUS_APPROVED.equals(p.getStatus())) {
            session.setAttribute("toastMessage", "Chỉ phiếu đã duyệt mới tạo được phiếu nhập");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/import-receipt?action=create&proposalId=" + id);
    }

    private int currentUserId(HttpServletRequest request) {
        User u = (User) request.getSession().getAttribute("loggedUser");
        return u != null ? u.getId() : 0;
    }

    private int parseId(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private int parseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private List<ImportProposalDetail> parseDetailsFromRequest(HttpServletRequest request, int proposalId) {
        List<ImportProposalDetail> details = new ArrayList<>();
        String[] genIds = request.getParameterValues("generatorId");
        String[] quantities = request.getParameterValues("quantity");
        String[] detailNotes = request.getParameterValues("detailNote");
        if (genIds == null) {
            return details;
        }
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            if (idStr == null || idStr.trim().isEmpty()) {
                continue;
            }
            int genId = parseInt(idStr);
            if (genId <= 0) {
                continue;
            }
            int qty = 1;
            if (quantities != null && i < quantities.length && quantities[i] != null
                    && !quantities[i].trim().isEmpty()) {
                qty = parseInt(quantities[i]);
                if (qty <= 0) {
                    qty = 1;
                }
            }
            String note = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            ImportProposalDetail d = new ImportProposalDetail();
            d.setProposalId(proposalId);
            d.setGeneratorId(genId);
            d.setQuantity(qty);
            d.setCurrentStock(0);
            d.setNote(note);
            details.add(d);
        }
        return details;
    }

    private void logActivity(int userId, String entityType, String action,
                             int entityId, String entityName, String details) {
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setEntityType(entityType);
        log.setAction(action);
        log.setEntityId(entityId);
        log.setEntityName(entityName);
        log.setDetails(details);
        try {
            new ActivityLogDAO().insert(log);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
