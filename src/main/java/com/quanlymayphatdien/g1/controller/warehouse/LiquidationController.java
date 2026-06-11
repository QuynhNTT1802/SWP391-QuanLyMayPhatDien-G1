package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDAO;
import com.quanlymayphatdien.g1.dal.LiquidationDetailDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Liquidation;
import com.quanlymayphatdien.g1.entity.LiquidationDetail;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@WebServlet(name = "LiquidationController", urlPatterns = {"/liquidations"})
public class LiquidationController extends HttpServlet {
    
    private final LiquidationDAO liquidationDAO = new LiquidationDAO();
    private final LiquidationDetailDAO detailDAO = new LiquidationDetailDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final ReceiptDetailDAO receiptDetailDAO = new ReceiptDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        java.util.Set<String> perms = (java.util.Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("liquidations.view")) {
            request.setAttribute("requiredPerm", "liquidations.view");
            request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "create":
                    List<Category> reasons = categoryDAO.findByType("liquidation_reason");
                    request.setAttribute("reasons", reasons);
                    
                    com.quanlymayphatdien.g1.dal.GeneratorDAO genDAO = new com.quanlymayphatdien.g1.dal.GeneratorDAO();
                    request.setAttribute("generators", genDAO.findAll());
                    
                    request.getRequestDispatcher("/view/liquidation/liquidation-create.jsp").forward(request, response);
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
                case "list":
                default:
                    showList(request, response);
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
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
        int kpiPendingManager = kpis.getOrDefault("PENDING_MANAGER", 0);
        int kpiPendingCeo = kpis.getOrDefault("PENDING_CEO", 0);
        int kpiApproved = kpis.getOrDefault("APPROVED_BY_CEO", 0);
        int kpiRequestEdit = kpis.getOrDefault("MANAGER_REQUEST_EDIT", 0) + kpis.getOrDefault("CEO_REQUEST_EDIT", 0);
        int kpiRejected = kpis.getOrDefault("REJECTED_BY_MANAGER", 0) + kpis.getOrDefault("REJECTED_BY_CEO", 0);
        
        request.setAttribute("kpiPendingManager", kpiPendingManager);
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
        int id = Integer.parseInt(request.getParameter("id"));
        
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
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            java.util.Set<String> perms = (java.util.Set<String>) session.getAttribute("userPermissions");
            boolean isManager = perms != null && perms.contains("liquidations.approve_manager");
            boolean isCeo = perms != null && perms.contains("liquidations.approve_ceo");
            boolean isStaff = perms != null && perms.contains("liquidations.create");
            request.setAttribute("isManager", isManager);
            request.setAttribute("isCeo", isCeo);
            request.setAttribute("isStaff", isStaff);
        }
        
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

        java.util.Set<String> perms = (java.util.Set<String>) session.getAttribute("userPermissions");
        if (perms == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        try {
            switch (action) {
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

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int reasonId = Integer.parseInt(request.getParameter("reasonId"));
        String[] generatorIds = request.getParameterValues("generatorId");
        String[] serialNumbers = request.getParameterValues("serialNumber");
        String[] originalPrices = request.getParameterValues("originalPrice");
        
        Liquidation l = new Liquidation();
        l.setLiquidationCode("LIQ" + System.currentTimeMillis());
        l.setCreatedBy(user.getId());
        l.setReasonId(reasonId);
        
        int insertedId = liquidationDAO.insert(l);
        if (insertedId > 0 && generatorIds != null) {
            for (int i = 0; i < generatorIds.length; i++) {
                LiquidationDetail d = new LiquidationDetail();
                d.setLiquidationId(insertedId);
                d.setGeneratorId(Integer.parseInt(generatorIds[i]));
                d.setSerialNumber(serialNumbers[i]);
                d.setOriginalPrice(new BigDecimal(originalPrices[i]));
                detailDAO.insert(d);
            }
        }
        response.sendRedirect(request.getContextPath() + "/liquidations");
    }

    private void handleManagerApprove(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        String[] detailIds = request.getParameterValues("detailId");
        String[] liquidationPrices = request.getParameterValues("liquidationPrice");
        
        if (detailIds != null) {
            for (int i = 0; i < detailIds.length; i++) {
                LiquidationDetail d = new LiquidationDetail();
                d.setLiquidationDetailId(Integer.parseInt(detailIds[i]));
                d.setLiquidationPrice(new BigDecimal(liquidationPrices[i]));
                detailDAO.update(d);
            }
        }
        
        liquidationDAO.updateStatus(liquidationId, "PENDING_CEO", user.getId(), "manager", null);
        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void handleCEOApprove(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        
        Receipt r = new Receipt();
        r.setReceiptCode("PX-LIQ-" + System.currentTimeMillis());
        r.setReceiptType("EXPORT");
        r.setWarehouseId(1);
        r.setCreatedBy(user.getId());
        r.setStatus("COMPLETED"); 
        r.setNote("Phiếu xuất cho đơn thanh lý ID: " + liquidationId);
        
        int newReceiptId = receiptDAO.insert(r);
        
        if (newReceiptId > 0) {
            List<LiquidationDetail> details = detailDAO.findByLiquidationId(liquidationId);
            for (LiquidationDetail d : details) {
                ReceiptDetail rd = new ReceiptDetail();
                rd.setReceiptId(newReceiptId);
                rd.setGeneratorId(d.getGeneratorId());
                rd.setSerialNumber(d.getSerialNumber());
                rd.setQuantity(1);
                rd.setNote("Thanh lý giá: " + d.getLiquidationPrice());
                receiptDetailDAO.insert(rd);
            }
            receiptDAO.approveReceipt(newReceiptId, user.getId());
            liquidationDAO.updateStatus(liquidationId, "APPROVED_BY_CEO", user.getId(), "ceo", newReceiptId);
        }
        
        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void handleCEOReject(HttpServletRequest request, HttpServletResponse response, User user, boolean isPermanent) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        int feedbackId = Integer.parseInt(request.getParameter("ceoFeedbackId"));
        
        liquidationDAO.updateCeoReject(liquidationId, user.getId(), feedbackId, isPermanent);
        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void handleManagerReject(HttpServletRequest request, HttpServletResponse response, User user, boolean isPermanent) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        int feedbackId = Integer.parseInt(request.getParameter("managerFeedbackId"));
        
        liquidationDAO.updateManagerReject(liquidationId, user.getId(), feedbackId, isPermanent);
        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }

    private void showEditView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Liquidation l = liquidationDAO.findById(id);
        
        if (!"MANAGER_REQUEST_EDIT".equals(l.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + id);
            return;
        }

        request.setAttribute("liquidation", l);
        List<LiquidationDetail> details = detailDAO.findByLiquidationId(id);
        request.setAttribute("details", details);

        List<Category> reasons = categoryDAO.findByType("liquidation_reason");
        request.setAttribute("reasons", reasons);
        com.quanlymayphatdien.g1.dal.GeneratorDAO genDAO = new com.quanlymayphatdien.g1.dal.GeneratorDAO();
        request.setAttribute("generators", genDAO.findAll());

        request.getRequestDispatcher("/view/liquidation/liquidation-edit.jsp").forward(request, response);
    }

    private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response, User user) throws Exception {
        int liquidationId = Integer.parseInt(request.getParameter("liquidationId"));
        int reasonId = Integer.parseInt(request.getParameter("reasonId"));
        String[] generatorIds = request.getParameterValues("generatorId");
        String[] serialNumbers = request.getParameterValues("serialNumber");
        String[] originalPrices = request.getParameterValues("originalPrice");

        Liquidation l = liquidationDAO.findById(liquidationId);
        if (l == null || !"MANAGER_REQUEST_EDIT".equals(l.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/liquidations");
            return;
        }

        // Cập nhật reason và reset trạng thái về PENDING_MANAGER
        boolean updated = liquidationDAO.updateReasonAndStatus(liquidationId, reasonId);
        if (updated) {
            // Xóa hết details cũ
            detailDAO.deleteByLiquidationId(liquidationId);

            // Thêm lại details mới
            if (generatorIds != null) {
                for (int i = 0; i < generatorIds.length; i++) {
                    LiquidationDetail d = new LiquidationDetail();
                    d.setLiquidationId(liquidationId);
                    d.setGeneratorId(Integer.parseInt(generatorIds[i]));
                    d.setSerialNumber(serialNumbers[i]);
                    d.setOriginalPrice(new java.math.BigDecimal(originalPrices[i]));
                    detailDAO.insert(d);
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/liquidations?action=detail&id=" + liquidationId);
    }
}
