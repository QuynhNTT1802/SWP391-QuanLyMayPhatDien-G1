package com.quanlymayphatdien.g1.controller.proposal;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.PurchaseOrderDAO;
import com.quanlymayphatdien.g1.dal.SupplierDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
import com.quanlymayphatdien.g1.entity.Supplier;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.PeriodUtils;
import com.quanlymayphatdien.g1.utils.ProposalExcelSupport;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
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
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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
                case "searchSupplier":
                    searchSupplierAjax(request, response);
                    return;
                case "searchGenerator":
                    searchGeneratorAjax(request, response);
                    return;
                case "quickCreateGenerator":
                    quickCreateGenerator(request, response);
                    return;
                case "quickCreateSupplier":
                    quickCreateSupplier(request, response);
                    return;
                case "redirectCreateSupplier":
                    redirectCreateSupplier(request, response);
                    return;
                case "redirectCreateGenerator":
                    redirectCreateGenerator(request, response);
                    return;
                case "importConfirm":
                    reShowImportPreview(request, response);
                    return;
                default:
                    listProposals(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.PROPOSAL, "ProposalController.doGet", e.getMessage(), e);
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
                case "revision":
                    requestRevision(request, response);
                    break;
                case "revertReview":
                    revertReviewProposal(request, response);
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
                case "assignSupplier":
                    assignSupplierAjax(request, response);
                    return;
                case "assignGenerator":
                    assignGeneratorAjax(request, response);
                    return;
                case "revalidateImport":
                    revalidateImport(request, response);
                    return;
                case "uploadEditExcel":
                    uploadEditExcel(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.PROPOSAL, "ProposalController.doPost", e.getMessage(), e);
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
        boolean excludeDraft = canApprove;

        String statusFilter = request.getParameter("status");
        String search = request.getParameter("search");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

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
        int total = dao.countByFilters(statusFilter, search, createdByFilter, excludeDraft, poFilter, dateFrom, dateTo);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<ImportProposal> proposals = dao.searchByFilters(statusFilter, search, createdByFilter, excludeDraft, poFilter, dateFrom, dateTo, page, pageSize);

        java.util.Map<String, java.time.LocalDate> periodDeadlines = new java.util.HashMap<>();
        java.util.Set<String> seen = new java.util.HashSet<>();
        for (ImportProposal p : proposals) {
            if (p.getPeriod() != null && seen.add(p.getPeriod())) {
                periodDeadlines.put(p.getPeriod(), PeriodUtils.deadlineOf(p.getPeriod()));
            }
        }
        request.setAttribute("periodDeadlines", periodDeadlines);
        request.setAttribute("currentDate", java.time.LocalDate.now());
        request.setAttribute("currentPeriod", PeriodUtils.currentPeriod());

        request.setAttribute("proposals", proposals);
        request.setAttribute("totalProposals", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("search", search);
        request.setAttribute("poFilter", poFilter);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);

        request.setAttribute("canCreateProposal", perms != null && perms.contains("proposals.create"));
        request.setAttribute("canCreatePo", perms != null && perms.contains("purchase_orders.create"));
        request.setAttribute("canViewPo", perms != null && perms.contains("purchase_orders.view"));
        request.setAttribute("canApproveProposal", canApprove);
        request.setAttribute("canRejectProposal", perms != null && perms.contains("proposals.reject"));
        request.setAttribute("canCancelProposal", perms != null && perms.contains("proposals.cancel"));
        request.setAttribute("currentUserId", loggedUser.getId());
        request.setAttribute("userPermissions", perms);

        request.setAttribute("pendingCount",   dao.countByStatus(GlobalUtils.STATUS_PENDING,   createdByFilter, excludeDraft, dateFrom, dateTo));
        request.setAttribute("approvedCount",  dao.countByStatus(GlobalUtils.STATUS_APPROVED,  createdByFilter, excludeDraft, dateFrom, dateTo));
        request.setAttribute("rejectedCount",  dao.countByStatus(GlobalUtils.STATUS_REJECTED,  createdByFilter, excludeDraft, dateFrom, dateTo));
        request.setAttribute("cancelledCount", dao.countByStatus(GlobalUtils.STATUS_CANCELLED, createdByFilter, excludeDraft, dateFrom, dateTo));
        request.setAttribute("draftCount",     canApprove ? 0 : dao.countByStatus(GlobalUtils.STATUS_DRAFT, loggedUser.getId(), false, dateFrom, dateTo));

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
        loadProposalFormAttributes(request, warehouseId);
        request.getRequestDispatcher("/view/proposal/proposal-create.jsp").forward(request, response);
    }

    private void loadProposalFormAttributes(HttpServletRequest request, int warehouseId) {
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.setAttribute("generators", new GeneratorDAO().findAllActive());
        request.setAttribute("suppliers", new SupplierDAO().findAll());
        request.setAttribute("stockByGen", new InventoryDAO().countInStockMapByWarehouse(warehouseId));

        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("catBrands", catDAO.findByType("brand"));
        request.setAttribute("catOrigins", catDAO.findByType("origin"));
        request.setAttribute("catConditions", catDAO.findByType("condition"));
        request.setAttribute("catFuelTypes", catDAO.findByType("fuel_type"));
        request.setAttribute("catPhases", catDAO.findByType("phase"));
        request.setAttribute("catGenTypes", catDAO.findByType("generator_type"));
        request.setAttribute("supplierTypeList", catDAO.findByType("supplier_type"));

        Set<String> perms = (Set<String>) request.getSession().getAttribute("userPermissions");
        boolean canCreateGenerator = perms != null && perms.contains("generators.create");
        boolean canCreateSupplier = perms != null && perms.contains("suppliers.create");
        request.setAttribute("canCreateGenerator", canCreateGenerator);
        request.setAttribute("canCreateSupplier", canCreateSupplier);
    }

    
    private boolean canEditProposal(ImportProposal p, int currentUserId, boolean canApprove) {
        if (p == null) return false;
        if (!GlobalUtils.STATUS_DRAFT.equals(p.getStatus())
                && !GlobalUtils.STATUS_NEEDS_REVISION.equals(p.getStatus())) {
            return false;
        }
        if (p.getCreatedBy() == currentUserId) return true;
        boolean isCeoRequestedRevision = GlobalUtils.STATUS_NEEDS_REVISION.equals(p.getStatus())
                && GlobalUtils.REVISION_REQUESTER_CEO.equals(p.getRevisionRequestedByRole());
        return isCeoRequestedRevision && canApprove;
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
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean canApprove = perms != null && perms.contains("proposals.approve");
        if (!canEditProposal(p, currentUserId(request), canApprove)) {
            session.setAttribute("toastMessage", "Không thể sửa phiếu này (đã gửi duyệt hoặc không phải người tạo).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
        request.setAttribute("proposal", p);
        loadProposalFormAttributes(request, p.getWarehouseId());
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

        if (GlobalUtils.STATUS_DRAFT.equals(p.getStatus())
                && !canApprove
                && p.getCreatedBy() != loggedUser.getId()) {
            session.setAttribute("toastMessage", "Bạn không thể xem phiếu nháp của nhân viên khác.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String tab = request.getParameter("tab");
        String currentTab = "history".equals(tab) ? "history" : "info";
        request.setAttribute("currentTab", currentTab);

        ActivityLogDAO logDAO = new ActivityLogDAO();
        if ("history".equals(currentTab)) {
            String logSearch = request.getParameter("logSearch");
            String logAction = request.getParameter("logAction");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");

            int pageSize = 20;
            int logPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try { logPage = Math.max(1, Integer.parseInt(pageStr)); }
                catch (NumberFormatException ignored) { logPage = 1; }
            }

            int totalLogs = logDAO.countByEntityTypeAndId2("import_proposal", id, logSearch, logAction, dateFrom, dateTo);
            int logTotalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
            if (logPage > logTotalPages) logPage = logTotalPages;
            List<ActivityLog> logList = logDAO.findByEntityTypeAndId2("import_proposal", id, logSearch, logAction, dateFrom, dateTo, logPage, pageSize);

            request.setAttribute("logList", logList);
            request.setAttribute("logPage", logPage);
            request.setAttribute("logTotalPages", logTotalPages);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("logSearch", logSearch != null ? logSearch : "");
            request.setAttribute("logAction", logAction != null ? logAction : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        } else {
            int totalHistory = logDAO.countByEntityTypeAndId("import_proposal", id);
            request.setAttribute("totalHistory", totalHistory);
        }

        request.setAttribute("proposal", p);

        java.math.BigDecimal grandTotal = java.math.BigDecimal.ZERO;
        int totalQty = 0;
        int totalRows = 0;
        if (p.getDetails() != null) {
            totalRows = p.getDetails().size();
            for (ImportProposalDetail d : p.getDetails()) {
                totalQty += d.getQuantity();
                if (d.getUnitPrice() != null) {
                    grandTotal = grandTotal.add(
                        d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getQuantity())));
                }
            }
        }
        java.time.format.DateTimeFormatter __dateFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
        java.time.format.DateTimeFormatter __dtFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        String proposalDateInput = p.getProposalDate() != null ? p.getProposalDate().toLocalDate().format(__dateFmt) : "";
        String approvedAtInput = p.getApprovedAt() != null ? p.getApprovedAt().format(__dtFmt) : "";
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("totalQty", totalQty);
        request.setAttribute("totalRows", totalRows);
        request.setAttribute("proposalDateInput", proposalDateInput);
        request.setAttribute("approvedAtInput", approvedAtInput);
        request.setAttribute("isOwner", p.getCreatedBy() == loggedUser.getId());
        request.setAttribute("canApprove", canApprove);
        request.setAttribute("canViewPo", perms != null && perms.contains("purchase_orders.view"));
        request.setAttribute("isWithinDeadline",
                p.getPeriod() == null
                        || PeriodUtils.isCurrentPeriod(p.getPeriod())
                        || PeriodUtils.isWithinDeadline(p.getPeriod()));
        request.setAttribute("deadlineDate",
                p.getPeriod() == null ? null : PeriodUtils.deadlineOf(p.getPeriod()));
        request.setAttribute("perms", perms);
        request.setAttribute("activePage", "proposal-detail");
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
        Integer headerSupplierId = parseHeaderSupplierId(request);

        if (warehouseId <= 0) {
            session.setAttribute("toastMessage", "Vui lòng chọn kho nhập");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }
        if (headerSupplierId == null) {
            session.setAttribute("toastMessage", "Vui lòng chọn nhà cung cấp cho cả phiếu");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        ImportProposal p = new ImportProposal();
        p.setWarehouseId(warehouseId);
        p.setSupplierId(headerSupplierId);
        p.setNote(request.getParameter("note"));
        p.setStatus("draft".equals(submitType) ? GlobalUtils.STATUS_DRAFT : GlobalUtils.STATUS_PENDING);
        p.setCreatedBy(user.getId());
        p.setProposalDate(LocalDateTime.now());
        p.setPeriod(PeriodUtils.currentPeriod());

        ImportProposalDAO dao = new ImportProposalDAO();
        p.setProposalCode(dao.generateProposalCode());
        int newId = dao.insert(p);
        if (newId <= 0) {
            session.setAttribute("toastMessage", "Không thể tạo phiếu đề xuất, vui lòng thử lại");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        List<ImportProposalDetail> details = parseDetailsFromRequest(request, newId, headerSupplierId);
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

    private Integer parseHeaderSupplierId(HttpServletRequest request) {
        String raw = request.getParameter("supplierId");
        if (raw == null || raw.trim().isEmpty()) return null;
        int id = parseInt(raw);
        return id > 0 ? id : null;
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
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean canApprove = perms != null && perms.contains("proposals.approve");
        if (!canEditProposal(existing, currentUserId(request), canApprove)) {
            session.setAttribute("toastMessage", "Không thể cập nhật phiếu này (đã gửi duyệt hoặc không phải người tạo).");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }

        String submitType = request.getParameter("submitType");
        boolean hasDetailForm = request.getParameterValues("generatorId") != null;
        if (!"draft".equals(submitType) && existing.getPeriod() != null
                && !PeriodUtils.isCurrentPeriod(existing.getPeriod())
                && !PeriodUtils.isWithinDeadline(existing.getPeriod())) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + existing.getPeriod()
                            + ". Không thể gửi duyệt lại phiếu này.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }

        Integer headerSupplierId = hasDetailForm ? parseHeaderSupplierId(request) : null;
        if (hasDetailForm && headerSupplierId == null) {
            session.setAttribute("toastMessage", "Vui lòng chọn nhà cung cấp cho cả phiếu");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=edit&id=" + id);
            return;
        }

        ImportProposal p = new ImportProposal();
        p.setProposalId(id);
        p.setNote(hasDetailForm ? request.getParameter("note") : existing.getNote());
        p.setSupplierId(hasDetailForm ? headerSupplierId : existing.getSupplierId());
        boolean isRevision = GlobalUtils.STATUS_NEEDS_REVISION.equals(existing.getStatus());
        if ("draft".equals(submitType) && !isRevision) {
            p.setStatus(GlobalUtils.STATUS_DRAFT);
        } else {
            p.setStatus(GlobalUtils.STATUS_PENDING);
        }
        dao.update(p);

        if (hasDetailForm) {
            dao.deleteDetails(id);
            List<ImportProposalDetail> details = parseDetailsFromRequest(request, id, headerSupplierId);
            if (!details.isEmpty()) {
                dao.insertDetailsBatch(details);
            }
        }

        logActivity(currentUserId(request), "import_proposal", "UPDATE", id,
                existing.getProposalCode(),
                "draft".equals(submitType) ? "Cập nhật phiếu đề xuất (nháp)" : "Cập nhật và gửi duyệt");

        session.setAttribute("toastMessage", "Cập nhật phiếu đề xuất thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
    }

    private void uploadEditExcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        ImportProposalDAO dao = new ImportProposalDAO();
        ImportProposal existing = dao.findById(id);
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean canApprove = perms != null && perms.contains("proposals.approve");
        if (!canEditProposal(existing, user.getId(), canApprove)) {
            session.setAttribute("toastMessage", "Không thể thay thế dữ liệu phiếu này.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }

        Part filePart = null;
        try {
            filePart = request.getPart("excelFile");
        } catch (Exception ignored) {}
        if (filePart == null || filePart.getSize() == 0) {
            session.setAttribute("toastMessage", "Vui lòng chọn file Excel.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=edit&id=" + id);
            return;
        }

        List<Map<String, String>> rows;
        try (InputStream is = filePart.getInputStream()) {
            rows = ProposalExcelSupport.parseFromExcel(is);
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Không đọc được file Excel: " + e.getMessage());
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=edit&id=" + id);
            return;
        }

        GeneratorDAO genDAO = new GeneratorDAO();
        SupplierDAO supDAO = new SupplierDAO();
        List<ImportProposalDetail> details = new ArrayList<>();
        int errors = 0;
        for (Map<String, String> row : rows) {
            String model = row.get(ProposalExcelSupport.HEADER_MODEL);
            String qtyStr = row.get(ProposalExcelSupport.HEADER_QUANTITY);
            String lineNote = row.get(ProposalExcelSupport.HEADER_NOTE);
            if (model == null || model.trim().isEmpty()) continue;
            Generator g = genDAO.findByModel(model.trim());
            if (g == null) { errors++; continue; }
            int qty = 1;
            try { qty = Integer.parseInt(qtyStr); if (qty < 1) qty = 1; if (qty > 9999) qty = 9999; } catch (Exception ignored) {}
            ImportProposalDetail d = new ImportProposalDetail();
            d.setProposalId(id);
            d.setGeneratorId(g.getId());
            d.setQuantity(qty);
            d.setCurrentStock(0);
            d.setNote(lineNote != null ? lineNote : "");
            String supplierName = row.get(ProposalExcelSupport.HEADER_SUPPLIER_NAME);
            if (supplierName != null && !supplierName.trim().isEmpty()) {
                java.util.List<Supplier> matched = supDAO.findByNameExact(supplierName.trim());
                if (matched.size() == 1) {
                    d.setSupplierId(matched.get(0).getId());
                }
            }
            String priceStr = row.get(ProposalExcelSupport.HEADER_UNIT_PRICE);
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                String cleaned = priceStr.trim().replaceAll("[^0-9.]", "");
                if (!cleaned.isEmpty()) {
                    try { d.setUnitPrice(new BigDecimal(cleaned)); } catch (Exception ignored) {}
                }
            }
            details.add(d);
        }

        if (details.isEmpty()) {
            session.setAttribute("toastMessage", "Không tìm thấy dòng máy hợp lệ nào trong file Excel.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=edit&id=" + id);
            return;
        }

        boolean ok = dao.replaceDetails(id, details);
        if (!ok) {
            session.setAttribute("toastMessage", "Lỗi khi thay thế dữ liệu.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=edit&id=" + id);
            return;
        }

        String msg = "Thay thế dữ liệu từ Excel (" + details.size() + " dòng)";
        if (errors > 0) msg += ". Bỏ qua " + errors + " dòng không tìm thấy máy.";
        logActivity(user.getId(), "import_proposal", "UPDATE", id, existing.getProposalCode(), msg);

        session.setAttribute("toastMessage", "Đã thay thế dữ liệu từ Excel" + (errors > 0 ? " (" + errors + " dòng bỏ qua)" : ""));
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/proposal?action=edit&id=" + id);
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
        ImportProposal pCheck = dao.findById(id);
        if (pCheck != null && pCheck.getPeriod() != null
                && !PeriodUtils.isCurrentPeriod(pCheck.getPeriod())
                && !PeriodUtils.isWithinDeadline(pCheck.getPeriod())) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + pCheck.getPeriod()
                            + ". Không thể duyệt phiếu.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
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
        ImportProposal pCheck = dao.findById(id);
        if (pCheck != null && pCheck.getPeriod() != null
                && !PeriodUtils.isCurrentPeriod(pCheck.getPeriod())
                && !PeriodUtils.isWithinDeadline(pCheck.getPeriod())) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + pCheck.getPeriod()
                            + ". Không thể từ chối phiếu.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
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

    private void requestRevision(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền yêu cầu chỉnh sửa.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        int id = parseId(request);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        String reason = request.getParameter("revisionReason");
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Vui lòng nhập lý do yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
        ImportProposalDAO dao = new ImportProposalDAO();
        ImportProposal pCheck = dao.findById(id);
        if (pCheck != null && pCheck.getPeriod() != null
                && !PeriodUtils.isCurrentPeriod(pCheck.getPeriod())
                && !PeriodUtils.isWithinDeadline(pCheck.getPeriod())) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + pCheck.getPeriod()
                            + ". Không thể yêu cầu chỉnh sửa.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
        boolean ok = dao.requestRevision(id, currentUserId(request), reason.trim());
        if (ok) {
            ImportProposal p = dao.findById(id);
            logActivity(currentUserId(request), "import_proposal", "REVISION", id,
                    p != null ? p.getProposalCode() : null, "Yêu cầu chỉnh sửa: " + reason.trim());
            session.setAttribute("toastMessage", "Đã yêu cầu chỉnh sửa phiếu đề xuất");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa (phiếu không ở trạng thái chờ duyệt)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
    }

    private void revertReviewProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null || !permissions.contains("proposals.approve")) {
            session.setAttribute("toastMessage", "Bạn không có quyền yêu cầu chỉnh sửa.");
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
        ImportProposal pCheck = dao.findById(id);
        if (pCheck != null && pCheck.getPeriod() != null
                && !PeriodUtils.isCurrentPeriod(pCheck.getPeriod())
                && !PeriodUtils.isWithinDeadline(pCheck.getPeriod())) {
            session.setAttribute("toastMessage",
                    "Đã quá deadline (ngày " + PeriodUtils.getDeadlineDay()
                            + " tháng sau) cho period " + pCheck.getPeriod()
                            + ". Không thể yêu cầu chỉnh sửa.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=detail&id=" + id);
            return;
        }
        String reason = request.getParameter("revertReason");
        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Vui lòng nhập lý do yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
            return;
        }
        boolean ok = dao.revertApprovedToRevision(id, currentUserId(request), reason.trim());
        if (ok) {
            ImportProposal p = dao.findById(id);
            logActivity(currentUserId(request), "import_proposal", "REVERT_REVIEW", id,
                    p != null ? p.getProposalCode() : null, "Yêu cầu chỉnh sửa từ gom đơn: " + reason.trim());
            session.setAttribute("toastMessage", "Đã yêu cầu chỉnh sửa phiếu đề xuất");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa (phiếu không ở trạng thái APPROVED)");
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

        XSSFWorkbook workbook = ProposalExcelSupport.createTemplateWorkbook();

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
        SupplierDAO supDAO = new SupplierDAO();
        List<Map<String, String>> validRows = new ArrayList<>();
        List<Map<String, String>> warningRows = new ArrayList<>();
        List<Map<String, String>> invalidRows = new ArrayList<>();
        List<Map<String, String>> unresolvedSupplierRows = new ArrayList<>();
        List<Map<String, String>> sessionDetailRows = new ArrayList<>();
        List<Map<String, String>> allRows = new ArrayList<>();
        int stt = 1;
        for (Map<String, String> row : rows) {
            String model = row.get(ProposalExcelSupport.HEADER_MODEL);
            String qtyStr = row.get(ProposalExcelSupport.HEADER_QUANTITY);
            String lineNote = row.get(ProposalExcelSupport.HEADER_NOTE);
            String supplierNameRaw = row.get(ProposalExcelSupport.HEADER_SUPPLIER_NAME);
            String unitPriceStr = row.get(ProposalExcelSupport.HEADER_UNIT_PRICE);

            Map<String, String> enriched = new LinkedHashMap<>(row);
            enriched.put("stt", String.valueOf(stt));
            enriched.put("gline", lineNote != null ? lineNote : "");

            List<String> errors = new ArrayList<>();
            List<String> warnings = new ArrayList<>();
            boolean generatorResolved = false;
            boolean supplierResolved = false;
            Integer resolvedSupplierId = null;
            String resolvedSupplierName = null;
            BigDecimal unitPrice = null;

            if (model == null || model.trim().isEmpty()) {
                errors.add("Mã máy phát không được trống");
            } else {
                enriched.put("gmodel", model.trim());
                Generator g = genDAO.findByModel(model.trim());
                if (g != null) {
                    generatorResolved = true;
                    enriched.put("gid", String.valueOf(g.getId()));
                    enriched.put("gname", g.getModel());
                    List<String> specDiffs = compareGeneratorSpecs(g, row);
                    if (!specDiffs.isEmpty()) {
                        errors.add("Thông số kỹ thuật trong Excel khác với máy '"
                                + g.getModel() + "' đã có trong kho: "
                                + String.join("; ", specDiffs)
                                + ". Vui lòng sửa file Excel và tải lại.");
                    }
                } else {
                    enriched.put("gname", model.trim());
                    warnings.add("Máy phát mới chưa có trong hệ thống: " + model.trim() + ".");
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
                    errors.add("Số lượng không được vượt quá 9999");
                }
            }
            enriched.put("gqty", String.valueOf(qty));

            if (unitPriceStr == null || unitPriceStr.trim().isEmpty()) {
                errors.add("Đơn giá đề xuất không được trống");
            } else {
                try {
                    String cleaned = unitPriceStr.trim().replaceAll("[^0-9.]", "");
                    unitPrice = new BigDecimal(cleaned);
                    if (unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                        errors.add("Đơn giá phải lớn hơn 0");
                    }
                } catch (NumberFormatException ex) {
                    errors.add("Đơn giá không hợp lệ");
                }
            }
            enriched.put("gunitPrice", unitPrice != null ? unitPrice.toPlainString() : "");

            String supplierQuery = supplierNameRaw == null ? "" : supplierNameRaw.trim();
            if (supplierQuery.isEmpty()) {
                errors.add("Tên nhà cung cấp không được trống");
            } else {
                enriched.put("supplierQuery", supplierQuery);
                List<Supplier> found = supDAO.findByNameExact(supplierQuery);
                if (found.size() == 1) {
                    resolvedSupplierId = found.get(0).getId();
                    resolvedSupplierName = found.get(0).getName();
                    supplierResolved = true;
                    enriched.put("supplierId", String.valueOf(resolvedSupplierId));
                    enriched.put("supplierNameResolved", resolvedSupplierName);
                } else if (found.size() >= 2) {
                    enriched.put("supplierMultiple", "true");
                    enriched.put("supplierMultipleCount", String.valueOf(found.size()));
                    for (Supplier s : found) {
                        enriched.put("supplier_candidate_" + s.getId(), s.getName());
                    }
                } else {
                    enriched.put("supplierMultiple", "false");
                }
            }

            if (!errors.isEmpty()) {
                enriched.put("gerrors", String.join("; ", errors));
                invalidRows.add(enriched);
            } else if (!supplierResolved) {
                if (!warnings.isEmpty()) {
                    enriched.put("gwarnings", String.join("; ", warnings));
                }
                unresolvedSupplierRows.add(enriched);
            } else if (!warnings.isEmpty()) {
                enriched.put("gwarnings", String.join("; ", warnings));
                warningRows.add(enriched);
            } else {
                validRows.add(enriched);
            }
            allRows.add(enriched);

            if (errors.isEmpty()) {
                ImportProposalDetail d = new ImportProposalDetail();
                if (generatorResolved) {
                    d.setGeneratorId(Integer.parseInt(enriched.get("gid")));
                }
                if (supplierResolved && resolvedSupplierId != null) {
                    d.setSupplierId(resolvedSupplierId);
                }
                d.setQuantity(qty);
                d.setCurrentStock(0);
                d.setUnitPrice(unitPrice);
                d.setNote(lineNote);
                sessionDetailRows.add(enriched);
                enriched.put("__sessionIndex", String.valueOf(sessionDetailRows.size() - 1));
            } else {
                enriched.put("__sessionIndex", "-1");
            }
            stt++;
        }

        HttpSession sessionRef = request.getSession();
        List<Map<String, String>> pendingRows = new ArrayList<>();
        for (Map<String, String> enriched : sessionDetailRows) {
            Map<String, String> r = new LinkedHashMap<>(enriched);
            r.remove("__sessionIndex");
            pendingRows.add(r);
        }
        sessionRef.setAttribute("pendingImportRows", pendingRows);
        sessionRef.setAttribute("pendingImportAllRows", allRows);
        sessionRef.setAttribute("pendingImportWarehouseId", warehouseId);
        sessionRef.setAttribute("pendingImportNote", note);

        request.setAttribute("validRows", validRows);
        request.setAttribute("warningRows", warningRows);
        request.setAttribute("invalidRows", invalidRows);
        request.setAttribute("unresolvedSupplierRows", unresolvedSupplierRows);
        request.setAttribute("currentWarehouseId", warehouseId);
        request.setAttribute("currentNote", note != null ? note : "");
        request.setAttribute("warehouses", new WarehouseDAO().findAll());
        request.getRequestDispatcher("/view/proposal/proposal-import-preview.jsp")
                .forward(request, response);
    }

    private void reShowImportPreview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        @SuppressWarnings("unchecked")
        List<Map<String, String>> pendingRows = (List<Map<String, String>>) session.getAttribute("pendingImportRows");
        if (pendingRows == null || pendingRows.isEmpty()) {
            
            List<Map<String, String>> emptyInvalid = new ArrayList<>();
            @SuppressWarnings("unchecked")
            List<Map<String, String>> allRows = (List<Map<String, String>>) session.getAttribute("pendingImportAllRows");
            if (allRows != null) {
                for (Map<String, String> r : allRows) {
                    String errs = r.get("gerrors");
                    if (errs != null && !errs.isEmpty()) {
                        emptyInvalid.add(r);
                    }
                }
            }
            request.setAttribute("validRows", new ArrayList<>());
            request.setAttribute("warningRows", new ArrayList<>());
            request.setAttribute("invalidRows", emptyInvalid);
            request.setAttribute("unresolvedSupplierRows", new ArrayList<>());
            request.setAttribute("currentWarehouseId", 0);
            request.setAttribute("currentNote", "");
            request.setAttribute("warehouses", new WarehouseDAO().findAll());
            request.setAttribute("sessionExpired", emptyInvalid.isEmpty() ? Boolean.TRUE : Boolean.FALSE);
            request.getRequestDispatcher("/view/proposal/proposal-import-preview.jsp")
                    .forward(request, response);
            return;
        }

        Integer warehouseId = (Integer) session.getAttribute("pendingImportWarehouseId");
        String note = (String) session.getAttribute("pendingImportNote");

        String newGeneratorModel = request.getParameter("newGeneratorModel");
        if (newGeneratorModel != null && !newGeneratorModel.isEmpty()) {
            session.setAttribute("toastMessage",
                    "Đã thêm máy phát '" + newGeneratorModel + "' vào kho. Hệ thống đã tự cập nhật lại các dòng liên quan.");
            session.setAttribute("toastType", "success");
        }

        String newSupplierIdStr = request.getParameter("newSupplierId");
        String assignedGidStr = request.getParameter("assignedGid");
        if (assignedGidStr == null || assignedGidStr.isEmpty()) {
            assignedGidStr = request.getParameter("gid");
        }

       
        if (newSupplierIdStr != null && !newSupplierIdStr.isEmpty()
                && assignedGidStr != null && !assignedGidStr.isEmpty()) {
            try {
                int newId = Integer.parseInt(newSupplierIdStr);
                String targetGid = assignedGidStr;
                Supplier newSup = new SupplierDAO().findById(newId);
                if (newSup != null) {
                for (Map<String, String> p : pendingRows) {
                    if (targetGid.equals(p.get("gid"))) {
                        p.put("supplierId", String.valueOf(newId));
                        p.put("supplierNameResolved", newSup.getName());
                        p.put("supplierQuery", newSup.getName());
                    }
                }
                }
            } catch (NumberFormatException ignored) {
            }
        }

        SupplierDAO supDAO = new SupplierDAO();
        GeneratorDAO genDAO = new GeneratorDAO();
        List<Map<String, String>> validRows = new ArrayList<>();
        List<Map<String, String>> warningRows = new ArrayList<>();
        List<Map<String, String>> invalidRows = new ArrayList<>();
        List<Map<String, String>> unresolvedSupplierRows = new ArrayList<>();

       
        for (Map<String, String> enriched : pendingRows) {
            String gmodel = enriched.get("gmodel");
            String currentGid = enriched.get("gid");
            if ((currentGid == null || currentGid.isEmpty())
                    && gmodel != null && !gmodel.trim().isEmpty()) {
                Generator g = genDAO.findByModel(gmodel.trim());
                if (g != null) {
                    enriched.put("gid", String.valueOf(g.getId()));
                    enriched.put("gname", g.getModel());
                    enriched.remove("gwarnings");
                }
            }
        }

        
        @SuppressWarnings("unchecked")
        List<Map<String, String>> allRowsForSync = (List<Map<String, String>>) session.getAttribute("pendingImportAllRows");
        if (allRowsForSync != null) {
            for (Map<String, String> r : allRowsForSync) {
                String gmodel = r.get("gmodel");
                String currentGid = r.get("gid");
                if ((currentGid == null || currentGid.isEmpty())
                        && gmodel != null && !gmodel.trim().isEmpty()) {
                    Generator g = genDAO.findByModel(gmodel.trim());
                    if (g != null) {
                        r.put("gid", String.valueOf(g.getId()));
                        r.put("gname", g.getModel());
                        r.remove("gwarnings");
                    }
                }
            }
        }

        for (Map<String, String> enriched : pendingRows) {
            String supplierNameRaw = enriched.get(ProposalExcelSupport.HEADER_SUPPLIER_NAME);
            Map<String, String> copy = new LinkedHashMap<>(enriched);
            String supplierQuery = supplierNameRaw == null ? "" : supplierNameRaw.trim();
            copy.put("supplierQuery", supplierQuery);

            Integer resolvedSupplierId = null;
            String resolvedSupplierName = null;
            boolean supplierResolved = false;

            
            String sidStr = copy.get("supplierId");
            if (sidStr != null && !sidStr.isEmpty()) {
                try {
                    resolvedSupplierId = Integer.parseInt(sidStr);
                    resolvedSupplierName = copy.get("supplierNameResolved");
                    if (resolvedSupplierId != null && resolvedSupplierId > 0) {
                        supplierResolved = true;
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            if (!supplierResolved && !supplierQuery.isEmpty()) {
                List<Supplier> found = supDAO.findByNameExact(supplierQuery);
                if (found.size() == 1) {
                    resolvedSupplierId = found.get(0).getId();
                    resolvedSupplierName = found.get(0).getName();
                    supplierResolved = true;
                    copy.put("supplierId", String.valueOf(resolvedSupplierId));
                    copy.put("supplierNameResolved", resolvedSupplierName);
                } else if (found.size() >= 2) {
                    copy.put("supplierMultiple", "true");
                    copy.put("supplierMultipleCount", String.valueOf(found.size()));
                } else {
                    copy.put("supplierMultiple", "false");
                }
            }

            String errors = copy.get("gerrors");
            String warnings = copy.get("gwarnings");
            if (errors != null && !errors.isEmpty()) {
                invalidRows.add(copy);
            } else if (!supplierResolved) {
                unresolvedSupplierRows.add(copy);
            } else if (warnings != null && !warnings.isEmpty()) {
                warningRows.add(copy);
            } else {
                validRows.add(copy);
            }
        }

        
        @SuppressWarnings("unchecked")
        List<Map<String, String>> allRows = (List<Map<String, String>>) session.getAttribute("pendingImportAllRows");
        if (allRows != null) {
            for (Map<String, String> r : allRows) {
                String errs = r.get("gerrors");
                if (errs != null && !errs.isEmpty()) {
                    invalidRows.add(r);
                }
            }
        }

        request.setAttribute("validRows", validRows);
        request.setAttribute("warningRows", warningRows);
        request.setAttribute("invalidRows", invalidRows);
        request.setAttribute("unresolvedSupplierRows", unresolvedSupplierRows);
        request.setAttribute("currentWarehouseId", warehouseId != null ? warehouseId : 0);
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

        String[] generatorIds = request.getParameterValues("generatorId");
        String[] quantities = request.getParameterValues("quantity");
        String[] detailNotes = request.getParameterValues("detailNote");
        String[] supplierIds = request.getParameterValues("supplierId");
        String[] unitPrices = request.getParameterValues("unitPrice");

        if (generatorIds == null || generatorIds.length == 0) {
            session.setAttribute("toastMessage", "Bạn chưa chọn dòng nào để lưu");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }

        for (int i = 0; i < generatorIds.length; i++) {
            if (generatorIds[i] == null || generatorIds[i].trim().isEmpty()) {
                continue;
            }
            if (supplierIds == null || i >= supplierIds.length
                    || supplierIds[i] == null || supplierIds[i].trim().isEmpty()) {
                session.setAttribute("toastMessage", "Có dòng chưa chọn nhà cung cấp, vui lòng kiểm tra lại");
                session.setAttribute("toastType", "danger");
                response.sendRedirect(request.getContextPath() + "/proposal?action=create&warehouseId=" + warehouseId);
                return;
            }
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
            String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
            int qty = 0;
            if (qtyStr == null || qtyStr.trim().isEmpty()) {
                continue;
            }
            qty = parseInt(qtyStr);
            if (qty <= 0) {
                continue;
            }
            if (qty > 9999) {
                continue;
            }
            String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            Integer supId = null;
            if (supplierIds != null && i < supplierIds.length
                    && supplierIds[i] != null && !supplierIds[i].trim().isEmpty()) {
                supId = parseInt(supplierIds[i]);
                if (supId <= 0) {
                    supId = null;
                }
            }
            String upStr = (unitPrices != null && i < unitPrices.length) ? unitPrices[i] : null;
            if (upStr == null || upStr.trim().isEmpty()) {
                continue;
            }
            BigDecimal up;
            try {
                String cleaned = upStr.trim().replaceAll("[^0-9.]", "");
                up = new BigDecimal(cleaned);
                if (up.compareTo(BigDecimal.ZERO) <= 0) {
                    continue;
                }
            } catch (NumberFormatException ex) {
                continue;
            }
            ImportProposalDetail d = new ImportProposalDetail();
            d.setProposalId(newId);
            d.setGeneratorId(genId);
            d.setSupplierId(supId);
            d.setQuantity(qty);
            d.setCurrentStock(0);
            d.setUnitPrice(up);
            d.setNote(dNote);
            details.add(d);
        }
        if (details.isEmpty()) {
            session.setAttribute("toastMessage", "Không có dòng hợp lệ nào sau kiểm tra dữ liệu. Vui lòng kiểm tra lại số lượng > 0 và đơn giá > 0.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=create");
            return;
        }
        dao.insertDetailsBatch(details);

        
        updateGeneratorCategoriesFromImport(session, generatorIds);

        session.removeAttribute("pendingImportRows");
        session.removeAttribute("pendingImportAllRows");
        session.removeAttribute("pendingImportWarehouseId");
        session.removeAttribute("pendingImportNote");

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

    @SuppressWarnings("unchecked")
    private void updateGeneratorCategoriesFromImport(HttpSession session, String[] generatorIds) {
        List<Map<String, String>> pendingRows = (List<Map<String, String>>) session.getAttribute("pendingImportRows");
        if (pendingRows == null || pendingRows.isEmpty() || generatorIds == null) return;
        CategoryDAO catDAO = new CategoryDAO();
        GeneratorDAO genDAO = new GeneratorDAO();
        for (int i = 0; i < generatorIds.length && i < pendingRows.size(); i++) {
            int genId = parseInt(generatorIds[i]);
            if (genId <= 0) continue;
            Map<String, String> row = pendingRows.get(i);
            if (row == null) continue;
            List<Integer> catIds = new ArrayList<>();
            resolveCategory(catDAO, row, "Thương hiệu", "brand", catIds);
            resolveCategory(catDAO, row, "Xuất xứ", "origin", catIds);
            resolveCategory(catDAO, row, "Tình trạng", "condition", catIds);
            resolveCategory(catDAO, row, "Nhiên liệu", "fuel_type", catIds);
            resolveCategory(catDAO, row, "Số pha", "phase", catIds);
            resolveCategory(catDAO, row, "Loại máy phát", "generator_type", catIds);
            if (!catIds.isEmpty()) {
                genDAO.deleteGeneratorCategories(genId);
                genDAO.saveGeneratorCategories(genId, catIds);
            }
        }
    }

    private void resolveCategory(CategoryDAO catDAO, Map<String, String> row, String header, String type, List<Integer> catIds) {
        String name = row.get(header);
        if (name == null || name.trim().isEmpty()) return;
        name = name.trim();
        Category c = catDAO.findByNameAndType(name, type);
        if (c == null) {
            Category newCat = new Category();
            newCat.setName(name);
            newCat.setType(type);
            newCat.setStatus("active");
            int id = catDAO.insert(newCat);
            if (id > 0) {
                catIds.add(id);
            }
        } else {
            catIds.add(c.getId());
        }
    }

    private int currentUserId(HttpServletRequest request) {
        User u = (User) request.getSession().getAttribute("loggedUser");
        return u != null ? u.getId() : 0;
    }

    
    private List<String> compareGeneratorSpecs(Generator g, Map<String, String> row) {
        List<String> diffs = new ArrayList<>();
        if (g == null || row == null) {
            return diffs;
        }
        String excelPower = row.get(ProposalExcelSupport.HEADER_POWER);
        if (excelPower != null && !excelPower.trim().isEmpty() && g.getPowerRating() != null) {
            try {
                BigDecimal ep = new BigDecimal(excelPower.trim().replace(",", ""));
                if (ep.compareTo(g.getPowerRating()) != 0) {
                    diffs.add("Công suất: Excel " + ep.toPlainString()
                            + " kVA vs DB " + g.getPowerRating().toPlainString() + " kVA");
                }
            } catch (NumberFormatException ignored) {
            }
        }
        String excelFreq = row.get(ProposalExcelSupport.HEADER_FREQUENCY);
        if (excelFreq != null && !excelFreq.trim().isEmpty()
                && g.getFrequency() != null && !g.getFrequency().trim().isEmpty()) {
            if (!excelFreq.trim().equalsIgnoreCase(g.getFrequency().trim())) {
                diffs.add("Tần số: Excel " + excelFreq.trim()
                        + " vs DB " + g.getFrequency().trim());
            }
        }
        String excelWeight = row.get(ProposalExcelSupport.HEADER_WEIGHT);
        if (excelWeight != null && !excelWeight.trim().isEmpty() && g.getWeight() != null) {
            try {
                BigDecimal ew = new BigDecimal(excelWeight.trim().replace(",", ""));
                if (ew.compareTo(g.getWeight()) != 0) {
                    diffs.add("Trọng lượng: Excel " + ew.toPlainString()
                            + " kg vs DB " + g.getWeight().toPlainString() + " kg");
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return diffs;
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

    private List<ImportProposalDetail> parseDetailsFromRequest(HttpServletRequest request, int proposalId, Integer headerSupplierId) {
        List<ImportProposalDetail> details = new ArrayList<>();
        String[] genIds = request.getParameterValues("generatorId");
        String[] quantities = request.getParameterValues("quantity");
        String[] detailNotes = request.getParameterValues("detailNote");
        String[] unitPrices = request.getParameterValues("unitPrice");
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
            BigDecimal up = null;
            if (unitPrices != null && i < unitPrices.length
                    && unitPrices[i] != null && !unitPrices[i].trim().isEmpty()) {
                try {
                    String cleaned = unitPrices[i].trim().replaceAll("[^0-9.]", "");
                    up = new BigDecimal(cleaned);
                } catch (NumberFormatException ex) {
                    up = null;
                }
            }
            ImportProposalDetail d = new ImportProposalDetail();
            d.setProposalId(proposalId);
            d.setGeneratorId(genId);
            d.setSupplierId(headerSupplierId);
            d.setQuantity(qty);
            d.setCurrentStock(0);
            d.setUnitPrice(up);
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

    @SuppressWarnings("unchecked")
    private void searchSupplierAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String q = request.getParameter("q");
        List<Supplier> list = new SupplierDAO().searchByKeyword(q, 10);
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (Supplier s : list) {
            if (!first) {
                sb.append(",");
            }
            first = false;
            sb.append("{")
              .append("\"id\":").append(s.getId()).append(",")
              .append("\"name\":\"").append(escapeJson(s.getName())).append("\",")
              .append("\"phone\":\"").append(escapeJson(s.getPhone())).append("\",")
              .append("\"email\":\"").append(escapeJson(s.getEmail())).append("\",")
              .append("\"company\":\"").append(escapeJson(s.getCompanyName())).append("\"")
              .append("}");
        }
        sb.append("]");
        response.getWriter().write(sb.toString());
    }

    private void searchGeneratorAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String q = request.getParameter("q");
        List<Generator> list = new GeneratorDAO().findByModelLike(q, 10);
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (Generator g : list) {
            if (!first) {
                sb.append(",");
            }
            first = false;
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) {
                        brand = c.getName();
                        break;
                    }
                }
            }
            sb.append("{")
              .append("\"id\":").append(g.getId()).append(",")
              .append("\"model\":\"").append(escapeJson(g.getModel())).append("\",")
              .append("\"brand\":\"").append(escapeJson(brand)).append("\",")
              .append("\"powerRating\":\"").append(g.getPowerRating() == null ? "" : g.getPowerRating().toString()).append("\",")
              .append("\"status\":\"").append(escapeJson(g.getStatus())).append("\"")
              .append("}");
        }
        sb.append("]");
        response.getWriter().write(sb.toString());
    }

    @SuppressWarnings("unchecked")
    private void assignSupplierAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_session\"}");
            return;
        }
        String gidStr = request.getParameter("gid");
        String rowIdxStr = request.getParameter("rowIndex");
        if ((gidStr == null || gidStr.isEmpty()) && (rowIdxStr != null && !rowIdxStr.isEmpty())) {
            gidStr = rowIdxStr;
        }
        String supIdStr = request.getParameter("supplierId");
        int supId = parseInt(supIdStr);
        if (gidStr == null || gidStr.isEmpty() || supId <= 0) {
            response.getWriter().write("{\"ok\":false,\"error\":\"bad_params\"}");
            return;
        }
        List<Map<String, String>> rows =
                (List<Map<String, String>>) session.getAttribute("pendingImportRows");
        if (rows == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"row_not_found\"}");
            return;
        }
        Supplier s = new SupplierDAO().findById(supId);
        if (s == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"supplier_not_found\"}");
            return;
        }
        boolean found = false;
        boolean useRowIndex = rowIdxStr != null && !rowIdxStr.isEmpty();
        int rowIdx = useRowIndex ? parseInt(rowIdxStr) : -1;
        for (int i = 0; i < rows.size(); i++) {
            Map<String, String> p = rows.get(i);
            if (gidStr.equals(p.get("gid")) || (useRowIndex && i == rowIdx)) {
                p.put("supplierId", String.valueOf(s.getId()));
                p.put("supplierNameResolved", s.getName());
                p.remove("supplierQuery");
                p.remove("supplierMultiple");
                p.remove("supplierMultipleCount");
                found = true;
            }
        }
        if (!found) {
            response.getWriter().write("{\"ok\":false,\"error\":\"row_not_found\"}");
            return;
        }
        
        List<Map<String, String>> allRows =
                (List<Map<String, String>>) session.getAttribute("pendingImportAllRows");
        if (allRows != null) {
            for (int i = 0; i < allRows.size(); i++) {
                Map<String, String> p = allRows.get(i);
                if (gidStr.equals(p.get("gid")) || (useRowIndex && i == rowIdx)) {
                    p.put("supplierId", String.valueOf(s.getId()));
                    p.put("supplierNameResolved", s.getName());
                    p.remove("supplierQuery");
                    p.remove("supplierMultiple");
                    p.remove("supplierMultipleCount");
                }
            }
        }

        response.getWriter().write("{\"ok\":true,\"supplier\":{\"id\":" + s.getId()
                + ",\"name\":\"" + escapeJson(s.getName()) + "\"}}");
    }

    @SuppressWarnings("unchecked")
    private void assignGeneratorAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_session\"}");
            return;
        }
        String sttStr = request.getParameter("stt");
        String rowIdxStr = request.getParameter("rowIndex");
        if ((sttStr == null || sttStr.isEmpty()) && (rowIdxStr != null && !rowIdxStr.isEmpty())) {
            sttStr = rowIdxStr;
        }
        String genIdStr = request.getParameter("generatorId");
        int genId = parseInt(genIdStr);
        if (sttStr == null || sttStr.isEmpty() || genId <= 0) {
            response.getWriter().write("{\"ok\":false,\"error\":\"bad_params\"}");
            return;
        }
        List<Map<String, String>> rows =
                (List<Map<String, String>>) session.getAttribute("pendingImportRows");
        if (rows == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"row_not_found\"}");
            return;
        }
        Generator g = new GeneratorDAO().findById(genId);
        if (g == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"generator_not_found\"}");
            return;
        }
        boolean found = false;
        for (Map<String, String> p : rows) {
            if (sttStr.equals(p.get("stt"))) {
                p.put("gid", String.valueOf(g.getId()));
                p.put("gname", g.getModel());
                p.remove("gwarnings");
                found = true;
            }
        }
        if (!found) {
            response.getWriter().write("{\"ok\":false,\"error\":\"row_not_found\"}");
            return;
        }
        List<Map<String, String>> allRows =
                (List<Map<String, String>>) session.getAttribute("pendingImportAllRows");
        if (allRows != null) {
            for (Map<String, String> p : allRows) {
                if (sttStr.equals(p.get("stt"))) {
                    p.put("gid", String.valueOf(g.getId()));
                    p.put("gname", g.getModel());
                    p.remove("gwarnings");
                }
            }
        }

        response.getWriter().write("{\"ok\":true,\"generator\":{\"id\":" + g.getId()
                + ",\"model\":\"" + escapeJson(g.getModel()) + "\"}}");
    }

    @SuppressWarnings("unchecked")
    private void revalidateImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_session\"}");
            return;
        }

        List<Map<String, String>> allRows =
                (List<Map<String, String>>) session.getAttribute("pendingImportAllRows");
        if (allRows == null || allRows.isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_data\"}");
            return;
        }

        String[] sttArr = request.getParameterValues("stt");
        String[] modelArr = request.getParameterValues("model");
        String[] qtyArr = request.getParameterValues("qty");
        String[] upArr = request.getParameterValues("unitPrice");
        String[] supArr = request.getParameterValues("supplier");

        if (sttArr == null || sttArr.length == 0) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_edits\"}");
            return;
        }

        GeneratorDAO genDAO = new GeneratorDAO();
        SupplierDAO supDAO = new SupplierDAO();

        Map<String, String> failedMap = new java.util.LinkedHashMap<>();
        List<Integer> fixedList = new ArrayList<>();

        for (int i = 0; i < sttArr.length; i++) {
            String sttStr = sttArr[i];
            int stt = parseInt(sttStr);
            if (stt <= 0) continue;

            
            Map<String, String> targetRow = null;
            for (Map<String, String> r : allRows) {
                if (sttStr.equals(r.get("stt"))) {
                    targetRow = r;
                    break;
                }
            }
            if (targetRow == null) {
                failedMap.put(sttStr, "Không tìm thấy dòng " + sttStr);
                continue;
            }

            
            String newModel = (modelArr != null && i < modelArr.length) ? modelArr[i] : "";
            String newQty = (qtyArr != null && i < qtyArr.length) ? qtyArr[i] : "";
            String newUp = (upArr != null && i < upArr.length) ? upArr[i] : "";
            String newSup = (supArr != null && i < supArr.length) ? supArr[i] : "";

            targetRow.put(ProposalExcelSupport.HEADER_MODEL, newModel);
            targetRow.put(ProposalExcelSupport.HEADER_QUANTITY, newQty);
            targetRow.put(ProposalExcelSupport.HEADER_UNIT_PRICE, newUp);
            targetRow.put(ProposalExcelSupport.HEADER_SUPPLIER_NAME, newSup);

            // Re-validate (mirrors the logic in importProposalPreview)
            List<String> errors = new ArrayList<>();
            boolean generatorResolved = false;
            boolean supplierResolved = false;

            // Model
            if (newModel == null || newModel.trim().isEmpty()) {
                errors.add("Mã máy phát không được trống");
            } else {
                targetRow.put("gmodel", newModel.trim());
                Generator g = genDAO.findByModel(newModel.trim());
                if (g != null) {
                    generatorResolved = true;
                    targetRow.put("gid", String.valueOf(g.getId()));
                    targetRow.put("gname", g.getModel());
                } else {
                    targetRow.put("gname", newModel.trim());
                    targetRow.put("gwarnings", "Máy phát mới chưa có trong hệ thống: " + newModel.trim() + ".");
                }
            }

            
            if (newQty == null || newQty.trim().isEmpty()) {
                errors.add("Số lượng không được trống");
            } else {
                try {
                    int qty = Integer.parseInt(newQty.trim());
                    if (qty <= 0) {
                        errors.add("Số lượng phải lớn hơn 0");
                    }
                    if (qty > 9999) {
                        errors.add("Số lượng không được vượt quá 9.999");
                    }
                    targetRow.put("gqty", String.valueOf(qty));
                } catch (NumberFormatException ex) {
                    errors.add("Số lượng phải là số nguyên");
                    targetRow.put("gqty", "0");
                }
            }

            
            if (newUp == null || newUp.trim().isEmpty()) {
                errors.add("Đơn giá đề xuất không được trống");
            } else {
                try {
                    String cleaned = newUp.trim().replaceAll("[^0-9.]", "");
                    BigDecimal up = new BigDecimal(cleaned);
                    if (up.compareTo(BigDecimal.ZERO) <= 0) {
                        errors.add("Đơn giá phải lớn hơn 0");
                    }
                    targetRow.put("gunitPrice", up.toPlainString());
                } catch (NumberFormatException ex) {
                    errors.add("Đơn giá không hợp lệ");
                }
            }

            // Supplier
            String supplierQuery = newSup == null ? "" : newSup.trim();
            if (supplierQuery.isEmpty()) {
                errors.add("Tên nhà cung cấp không được trống");
            } else {
                targetRow.put("supplierQuery", supplierQuery);
                List<Supplier> found = supDAO.findByNameExact(supplierQuery);
                if (found.size() == 1) {
                    supplierResolved = true;
                    targetRow.put("supplierId", String.valueOf(found.get(0).getId()));
                    targetRow.put("supplierNameResolved", found.get(0).getName());
                    targetRow.remove("supplierMultiple");
                    targetRow.remove("supplierMultipleCount");
                } else if (found.size() >= 2) {
                    targetRow.put("supplierMultiple", "true");
                    targetRow.put("supplierMultipleCount", String.valueOf(found.size()));
                } else {
                    targetRow.put("supplierMultiple", "false");
                }
            }

            if (!errors.isEmpty()) {
                targetRow.put("gerrors", String.join("; ", errors));
                targetRow.put("gid", "");
                targetRow.remove("gwarnings");
                failedMap.put(sttStr, String.join("; ", errors));
            } else {
                targetRow.remove("gerrors");
                fixedList.add(stt);
                if (!supplierResolved) {
                    targetRow.remove("gwarnings");
                    targetRow.put("gwarnings", "Chưa chọn được nhà cung cấp");
                } else if (generatorResolved) {
                    targetRow.remove("gwarnings");
                }
            }
        }

        
        List<Map<String, String>> pendingRows = new ArrayList<>();
        for (Map<String, String> r : allRows) {
            String errs = r.get("gerrors");
            if (errs != null && !errs.isEmpty()) {
                continue;
            }
            Map<String, String> copy = new LinkedHashMap<>(r);
            copy.remove("__sessionIndex");
            pendingRows.add(copy);
        }
        session.setAttribute("pendingImportRows", pendingRows);
        session.setAttribute("pendingImportAllRows", allRows);

        StringBuilder json = new StringBuilder("{");
        json.append("\"ok\":true,");
        json.append("\"fixed\":[");
        boolean first = true;
        for (int stt : fixedList) {
            if (!first) json.append(",");
            first = false;
            json.append(stt);
        }
        json.append("],");
        json.append("\"failed\":{");
        first = true;
        for (Map.Entry<String, String> e : failedMap.entrySet()) {
            if (!first) json.append(",");
            first = false;
            json.append("\"").append(escapeJson(e.getKey())).append("\":\"").append(escapeJson(e.getValue())).append("\"");
        }
        json.append("}}");
        response.getWriter().write(json.toString());
    }

    private void quickCreateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_session\"}");
            return;
        }
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("generators.create")) {
            response.getWriter().write("{\"ok\":false,\"error\":\"forbidden\"}");
            return;
        }

        String model = request.getParameter("model");
        String powerStr = request.getParameter("powerRating");
        String freq = request.getParameter("frequency");
        String weightStr = request.getParameter("weight");
        if (model == null || model.trim().isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Vui lòng nhập mã máy phát\"}");
            return;
        }
        if (powerStr == null || powerStr.trim().isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Vui lòng nhập công suất\"}");
            return;
        }

        GeneratorDAO genDAO = new GeneratorDAO();
        Generator existing = genDAO.findByModel(model.trim());
        if (existing != null) {
            response.getWriter().write("{\"ok\":true,\"existing\":true,\"id\":" + existing.getId()
                    + ",\"model\":\"" + escapeJson(existing.getModel()) + "\"}");
            return;
        }

        Generator g = new Generator();
        g.setModel(model.trim());
        try {
            g.setPowerRating(new BigDecimal(powerStr.trim()));
        } catch (NumberFormatException ex) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Công suất không hợp lệ\"}");
            return;
        }
        g.setFrequency(freq != null && !freq.trim().isEmpty() ? freq.trim() : null);
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            try {
                g.setWeight(new BigDecimal(weightStr.trim()));
            } catch (NumberFormatException ex) {
                g.setWeight(null);
            }
        }
        g.setStatus("active");
        g.setCreatedAt(LocalDateTime.now());
        User u = (User) session.getAttribute("loggedUser");
        if (u != null) {
            g.setCreatedBy(u.getId());
        }

        int newId = genDAO.insert(g);
        if (newId <= 0) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Không thể lưu máy phát\"}");
            return;
        }

        CategoryDAO catDAO = new CategoryDAO();
        List<Integer> catIds = new ArrayList<>();
        addCatIfPresent(catDAO, request.getParameter("brandId"), "brand", catIds);
        addCatIfPresent(catDAO, request.getParameter("originId"), "origin", catIds);
        addCatIfPresent(catDAO, request.getParameter("conditionId"), "condition", catIds);
        addCatIfPresent(catDAO, request.getParameter("fuelTypeId"), "fuel_type", catIds);
        addCatIfPresent(catDAO, request.getParameter("phaseId"), "phase", catIds);
        addCatIfPresent(catDAO, request.getParameter("genTypeId"), "generator_type", catIds);
        if (!catIds.isEmpty()) {
            genDAO.deleteGeneratorCategories(newId);
            genDAO.saveGeneratorCategories(newId, catIds);
        }

        User logU = (User) session.getAttribute("loggedUser");
        logActivity(logU != null ? logU.getId() : 0, "generator", "CREATE", newId,
                model.trim(),
                "Tạo máy phát nhanh từ đề xuất nhập kho: " + model.trim());

        response.getWriter().write("{\"ok\":true,\"existing\":false,\"id\":" + newId
                + ",\"model\":\"" + escapeJson(model.trim()) + "\"}");
    }

    private void addCatIfPresent(CategoryDAO catDAO, String rawId, String type, List<Integer> acc) {
        if (rawId == null || rawId.trim().isEmpty()) return;
        int id = parseInt(rawId);
        if (id <= 0) return;
        Category c = catDAO.findById(id);
        if (c != null) {
            acc.add(id);
        }
    }

    private void quickCreateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"ok\":false,\"error\":\"no_session\"}");
            return;
        }
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("suppliers.create")) {
            response.getWriter().write("{\"ok\":false,\"error\":\"forbidden\"}");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String companyName = request.getParameter("companyName");
        String typeIdStr = request.getParameter("supplierTypeId");

        if (name == null || name.trim().isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Vui lòng nhập tên nhà cung cấp\"}");
            return;
        }
        if (phone == null || phone.trim().isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Vui lòng nhập số điện thoại\"}");
            return;
        }

        SupplierDAO supDAO = new SupplierDAO();
        if (supDAO.isPhoneExists(phone.trim(), null)) {
            Supplier existing = supDAO.findByNameExact(phone.trim()).isEmpty()
                    ? null : supDAO.findByNameExact(phone.trim()).get(0);
            if (existing == null) {
                List<Supplier> byPhone = supDAO.searchByKeyword(phone.trim(), 1);
                existing = byPhone.isEmpty() ? null : byPhone.get(0);
            }
            if (existing != null) {
                response.getWriter().write("{\"ok\":true,\"existing\":true,\"id\":" + existing.getId()
                        + ",\"name\":\"" + escapeJson(existing.getName())
                        + "\",\"phone\":\"" + escapeJson(existing.getPhone()) + "\"}");
                return;
            }
        }

        Supplier s = new Supplier();
        s.setName(name.trim());
        s.setPhone(phone.trim());
        s.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        s.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
        s.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName.trim() : null);
        if (typeIdStr != null && !typeIdStr.trim().isEmpty()) {
            try {
                s.setSupplierTypeId(Integer.parseInt(typeIdStr.trim()));
            } catch (NumberFormatException ignore) {}
        }
        s.setStatus("active");
        User u = (User) session.getAttribute("loggedUser");
        if (u != null) {
            s.setCreatedBy(u.getId());
        }

        int newId = supDAO.insert(s);
        if (newId <= 0) {
            response.getWriter().write("{\"ok\":false,\"error\":\"Không thể lưu nhà cung cấp\"}");
            return;
        }

        logActivity(u != null ? u.getId() : 0, "supplier", "CREATE", newId,
                name.trim(),
                "Tạo NCC nhanh từ đề xuất nhập kho: " + name.trim());

        response.getWriter().write("{\"ok\":true,\"existing\":false,\"id\":" + newId
                + ",\"name\":\"" + escapeJson(name.trim())
                + "\",\"phone\":\"" + escapeJson(phone.trim()) + "\"}");
    }

    private void redirectCreateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String supplierQuery = request.getParameter("supplierQuery");
        String rowGid = request.getParameter("gid");
        String returnUrl = request.getContextPath() + "/proposal?action=importConfirm";
        StringBuilder url = new StringBuilder(request.getContextPath())
                .append("/warehouse/suppliers?action=create")
                .append("&prefillName=").append(urlEncode(supplierQuery))
                .append("&returnUrl=").append(urlEncode(returnUrl))
                .append("&rowGid=").append(urlEncode(rowGid));
        response.sendRedirect(url.toString());
    }

    private void redirectCreateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Set<String> perms = (session != null)
                ? (Set<String>) session.getAttribute("userPermissions") : null;
        if (perms == null || !perms.contains("generators.create")) {
            session.setAttribute("toastMessage", "Bạn không có quyền thêm máy phát điện.");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/proposal?action=importConfirm");
            return;
        }
        String model = request.getParameter("model");
        String stt = request.getParameter("stt");
        String returnUrl = request.getContextPath() + "/proposal?action=importConfirm";
        StringBuilder url = new StringBuilder(request.getContextPath())
                .append("/warehouse/generators?action=create")
                .append("&prefillModel=").append(urlEncode(model))
                .append("&returnUrl=").append(urlEncode(returnUrl))
                .append("&rowStt=").append(urlEncode(stt));
        response.sendRedirect(url.toString());
    }

    private String urlEncode(String s) {
        if (s == null) {
            return "";
        }
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    private String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }
}