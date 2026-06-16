package com.quanlymayphatdien.g1.controller.proposal;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.PeriodUtils;
import com.quanlymayphatdien.g1.utils.ProposalExcelSupport;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "ProposalController", urlPatterns = {"/proposal"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
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
                case "downloadTemplate":
                    downloadProposalTemplate(request, response);
                    break;
                default:
                    listProposals(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý đề xuất nhập", "ProposalController.doGet", e.getMessage(), e);
            e.printStackTrace();
            if (!response.isCommitted()) {
                session.setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
                session.setAttribute("toastType", "danger");
                response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            }
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
                case "importExcel":
                    importProposalPreview(request, response);
                    break;
                case "importConfirm":
                    importProposalConfirm(request, response);
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
        // Sale manager (có quyền approve) xem tất cả phiếu TRỪ DRAFT.
        // Sale staff (không có quyền approve) chỉ xem phiếu của mình, bao gồm DRAFT.
        Integer createdByFilter = canApprove ? null : loggedUser.getId();
        boolean excludeDraft = canApprove;

        String statusFilter = request.getParameter("status");
        String search = request.getParameter("search");
        String periodFilter = request.getParameter("period");

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

        Integer poFilter = null;
        String poFilterStr = request.getParameter("poFilter");
        if (poFilterStr != null && !poFilterStr.isEmpty()) {
            try { poFilter = Integer.parseInt(poFilterStr); } catch (NumberFormatException e) {}
        }

        ImportProposalDAO dao = new ImportProposalDAO();
        int total = dao.countByFilters(statusFilter, search, createdByFilter, excludeDraft, poFilter, periodFilter);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<ImportProposal> proposals = dao.searchByFilters(statusFilter, search, createdByFilter, excludeDraft, poFilter, periodFilter, page, pageSize);

        request.setAttribute("proposals", proposals);
        request.setAttribute("totalProposals", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("search", search);
        request.setAttribute("poFilter", poFilter);
        request.setAttribute("periodFilter", periodFilter);
        request.setAttribute("periods", PeriodUtils.recentQuarters(4));

        request.setAttribute("canCreateProposal", perms != null && perms.contains("proposals.create"));
        request.setAttribute("canCreatePo", perms != null && perms.contains("purchase_orders.create"));
        request.setAttribute("canApproveProposal", canApprove);
        request.setAttribute("userPermissions", perms);

        request.setAttribute("pendingCount",   dao.countByStatus(GlobalUtils.STATUS_PENDING,   createdByFilter, excludeDraft, periodFilter));
        request.setAttribute("approvedCount",  dao.countByStatus(GlobalUtils.STATUS_APPROVED,  createdByFilter, excludeDraft, periodFilter));
        request.setAttribute("rejectedCount",  dao.countByStatus(GlobalUtils.STATUS_REJECTED,  createdByFilter, excludeDraft, periodFilter));
        request.setAttribute("cancelledCount", dao.countByStatus(GlobalUtils.STATUS_CANCELLED, createdByFilter, excludeDraft, periodFilter));
        request.setAttribute("draftCount",     canApprove ? 0 : dao.countByStatus(GlobalUtils.STATUS_DRAFT, loggedUser.getId(), false, periodFilter));

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
        int warehouseId = parseInt(request.getParameter("warehouseId"));
        String currentPeriod = PeriodUtils.currentPeriod();
        boolean quarterBlocked = warehouseId > 0
                && new PurchaseOrderDAO().hasRejectedPo(currentPeriod, warehouseId);
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("generators", new GeneratorDAO().findAll());
        request.setAttribute("quarterBlocked", quarterBlocked);
        request.setAttribute("blockedPeriod", currentPeriod);
        request.setAttribute("blockedWarehouseId", warehouseId);
        request.getRequestDispatcher("/view/proposal/proposal-create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseId(request);
        if (id <= 0) {
            session.setAttribute("toastMessage", "ID phiếu không hợp lệ.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        ImportProposal p = new ImportProposalDAO().findById(id);
        if (p == null
                || !GlobalUtils.STATUS_DRAFT.equals(p.getStatus())
                || p.getCreatedBy() != currentUserId(request)) {
            session.setAttribute("toastMessage", "Không thể sửa phiếu này (đã gửi duyệt hoặc không phải người tạo).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
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
        // Chặn sale manager mở phiếu DRAFT (chỉ chính chủ mới xem được nháp của mình)
        HttpSession session = request.getSession();
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        User loggedUser = (User) session.getAttribute("loggedUser");
        boolean canApprove = perms != null && perms.contains("proposals.approve");
        if (GlobalUtils.STATUS_DRAFT.equals(p.getStatus())
                && canApprove
                && p.getCreatedBy() != loggedUser.getId()) {
            session.setAttribute("toastMessage", "Bạn không thể xem phiếu nháp của nhân viên khác.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        // Chặn sale staff mở DRAFT của người khác
        if (GlobalUtils.STATUS_DRAFT.equals(p.getStatus())
                && !canApprove
                && p.getCreatedBy() != loggedUser.getId()) {
            session.setAttribute("toastMessage", "Bạn không thể xem phiếu nháp của nhân viên khác.");
            session.setAttribute("toastType", "danger");
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
        int warehouseId = parseInt(request.getParameter("warehouseId"));
        String currentPeriod = PeriodUtils.currentPeriod();
        if (warehouseId > 0 && new PurchaseOrderDAO().hasRejectedPo(currentPeriod, warehouseId)) {
            session.setAttribute("toastMessage",
                    "Quý " + currentPeriod + " tại kho này đã bị CEO từ chối PO. Không thể tạo đề xuất mới.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create&warehouseId=" + warehouseId);
            return;
        }

        ImportProposal p = new ImportProposal();
        p.setWarehouseId(warehouseId);
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

    private void downloadProposalTemplate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        List<Generator> samples = new GeneratorDAO().findAllActive();
        XSSFWorkbook workbook = ProposalExcelSupport.createTemplateWorkbook(samples);

        String today = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
        String fileName = "mau-de-xuat-nhap-" + today + ".xlsx";

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private void importProposalPreview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền tạo phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String warehouseIdRaw = request.getParameter("warehouseId");
        String note = request.getParameter("note");
        int warehouseId = parseInt(warehouseIdRaw);
        String currentPeriod = PeriodUtils.currentPeriod();
        if (warehouseId > 0 && new PurchaseOrderDAO().hasRejectedPo(currentPeriod, warehouseId)) {
            session.setAttribute("toastMessage",
                    "Quý " + currentPeriod + " tại kho này đã bị CEO từ chối PO. Không thể tạo đề xuất mới.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create&warehouseId=" + warehouseId);
            return;
        }

        Part filePart = null;
        try {
            filePart = request.getPart("excelFile");
        } catch (Exception ignored) {
        }
        if (filePart == null || filePart.getSize() == 0) {
            session.setAttribute("toastMessage", "Vui lòng chọn file Excel để tải lên");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        List<Map<String, String>> rows;
        try (InputStream is = filePart.getInputStream()) {
            rows = ProposalExcelSupport.parseFromExcel(is);
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Không đọc được file Excel: " + e.getMessage());
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        GeneratorDAO genDAO = new GeneratorDAO();
        List<Map<String, String>> validRows = new ArrayList<>();
        List<Map<String, String>> warningRows = new ArrayList<>();
        List<Map<String, String>> invalidRows = new ArrayList<>();
        int stt = 1;
        for (Map<String, String> row : rows) {
            String model = row.get(ProposalExcelSupport.HEADER_MODEL);
            String qtyStr = row.get(ProposalExcelSupport.HEADER_QUANTITY);
            String lineNote = row.get(ProposalExcelSupport.HEADER_NOTE);

            Map<String, String> enriched = new LinkedHashMap<>(row);
            enriched.put("stt", String.valueOf(stt));
            enriched.put("gline", lineNote != null ? lineNote : "");

            List<String> errors = new ArrayList<>();
            List<String> warnings = new ArrayList<>();
            boolean generatorResolved = false;

            if (model == null || model.trim().isEmpty()) {
                errors.add("Mã máy phát không được trống");
            } else {
                Generator g = genDAO.findByModel(model.trim());
                if (g == null) {
                    errors.add("Mã máy \"" + model.trim() + "\" không tồn tại trong hệ thống");
                } else {
                    enriched.put("gid", String.valueOf(g.getId()));
                    enriched.put("gname", g.getDescription() != null ? g.getDescription() : "");
                    enriched.put("gmodel", g.getModel());
                    generatorResolved = true;
                }
            }

            int qty = 0;
            if (qtyStr == null || qtyStr.trim().isEmpty()) {
                errors.add("Số lượng không được trống");
            } else {
                try {
                    qty = Integer.parseInt(qtyStr.trim());
                } catch (NumberFormatException ex) {
                    errors.add("Số lượng phải là số nguyên");
                }
                if (qty <= 0) {
                    errors.add("Số lượng phải lớn hơn 0");
                }
                if (qty > 9999) {
                    errors.add("Số lượng không được vượt quá 9.999");
                }
            }
            enriched.put("gqty", String.valueOf(qty));

            if (generatorResolved && warehouseId > 0
                    && !genDAO.isInWarehouse(Integer.parseInt(enriched.get("gid")), warehouseId)) {
                warnings.add("Máy chưa có trong kho này, cần báo cáo Sale Manager xét duyệt");
            }

            if (!errors.isEmpty()) {
                enriched.put("gerrors", String.join("; ", errors));
                invalidRows.add(enriched);
            } else if (!warnings.isEmpty()) {
                enriched.put("gwarnings", String.join("; ", warnings));
                warningRows.add(enriched);
            } else {
                validRows.add(enriched);
            }
            stt++;
        }

        request.setAttribute("validRows", validRows);
        request.setAttribute("warningRows", warningRows);
        request.setAttribute("invalidRows", invalidRows);
        request.setAttribute("currentWarehouseId", warehouseId);
        request.setAttribute("currentNote", note != null ? note : "");
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.getRequestDispatcher("/view/proposal/proposal-import-preview.jsp")
                .forward(request, response);
    }

    private void importProposalConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền tạo phiếu đề xuất.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        int warehouseId = parseInt(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        String submitType = request.getParameter("submitType");

        if (warehouseId <= 0) {
            session.setAttribute("toastMessage", "Vui lòng chọn kho nhập");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        String currentPeriod = PeriodUtils.currentPeriod();
        if (new PurchaseOrderDAO().hasRejectedPo(currentPeriod, warehouseId)) {
            session.setAttribute("toastMessage",
                    "Quý " + currentPeriod + " tại kho này đã bị CEO từ chối PO. Không thể tạo đề xuất mới.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create&warehouseId=" + warehouseId);
            return;
        }

        String[] generatorIds = request.getParameterValues("generatorId");
        String[] quantities = request.getParameterValues("quantity");
        String[] detailNotes = request.getParameterValues("detailNote");

        if (generatorIds == null || generatorIds.length == 0) {
            session.setAttribute("toastMessage", "Bạn chưa chọn dòng nào để lưu");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        ImportProposal p = new ImportProposal();
        p.setWarehouseId(warehouseId);
        p.setNote(note);
        String status;
        if ("draft".equals(submitType)) {
            status = GlobalUtils.STATUS_DRAFT;
        } else {
            status = GlobalUtils.STATUS_PENDING;
        }
        p.setStatus(status);
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

        List<ImportProposalDetail> details = new ArrayList<>();
        for (int i = 0; i < generatorIds.length; i++) {
            String idStr = generatorIds[i];
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
            String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            ImportProposalDetail d = new ImportProposalDetail();
            d.setProposalId(newId);
            d.setGeneratorId(genId);
            d.setQuantity(qty);
            d.setCurrentStock(0);
            d.setNote(dNote);
            details.add(d);
        }
        if (!details.isEmpty()) {
            dao.insertDetailsBatch(details);
        }

        logActivity(user.getId(), "import_proposal", "CREATE", newId,
                p.getProposalCode(),
                "draft".equals(submitType)
                        ? "Tạo phiếu đề xuất (nháp) từ Excel — " + details.size() + " dòng"
                        : "Tạo phiếu đề xuất từ Excel (gửi duyệt) — " + details.size() + " dòng");

        session.setAttribute("toastMessage",
                "draft".equals(submitType)
                        ? "Đã lưu nháp phiếu đề xuất (" + details.size() + " dòng)"
                        : "Tạo phiếu đề xuất từ Excel thành công (" + details.size() + " dòng)");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + newId);
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
