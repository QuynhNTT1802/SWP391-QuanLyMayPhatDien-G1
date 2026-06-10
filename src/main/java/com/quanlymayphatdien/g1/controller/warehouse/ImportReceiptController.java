/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.dal.ImportProposalDetailDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDetailDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author FPTShop
 */
@WebServlet(name = "ImportReceiptController", urlPatterns = {"/import-receipt"})
public class ImportReceiptController extends HttpServlet {

    private static final String TYPE = "IMPORT";
    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final ReceiptDetailDAO detailDAO = new ReceiptDetailDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();
    private final GeneratorDAO genDAO = new GeneratorDAO();

    private static final int MAX_QUANTITY = 100000;
    private static final int MAX_SERIAL_LENGTH = 100;
    private static final int MAX_NOTE_LENGTH = 500;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) return;
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";
        try {
            switch (action) {
                case "list":
                    viewList(request, response);
                    break;
                case "selectProposal":
                    selectProposal(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "detail":
                    viewDetail(request, response);
                    break;
                case "loadGenerators":
                    loadGeneratorsJson(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "ImportReceiptController.doGet", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) return;
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "save":
                    saveReceipt(request, response);
                    break;
                case "update":
                    updateReceipt(request, response);
                    break;
                case "approve":
                    approveReceipt(request, response);
                    break;
                case "reject":
                    rejectReceipt(request, response);
                    break;
                case "requestRevision":
                    requestRevision(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "ImportReceiptController.doPost", e.getMessage(), e);
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

        String statusFilter = request.getParameter("status");
        String whFilter = request.getParameter("warehouse");
        String search = request.getParameter("search");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        int totalItems = receiptDAO.countWithFilters(TYPE, statusFilter, whFilter, search, createdByFilter, loggedUser.getId());
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) page = totalPages;

        List<Receipt> receiptList = receiptDAO.findWithFilters(
                TYPE, statusFilter, whFilter, search, createdByFilter, page, pageSize, loggedUser.getId());
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("receiptList", receiptList);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("whFilter", whFilter);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("canApproveReceipt", perms != null && perms.contains("receipts.approve"));
        request.getRequestDispatcher("/view/receipt/import/import-list.jsp").forward(request, response);
    }

    private void selectProposal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        int page = parsePage(request.getParameter("page"));
        int pageSize = 10;

        ImportProposalDAO ipDAO = new ImportProposalDAO();
        int totalItems = ipDAO.countApprovedAvailableFiltered(search, fromDate, toDate);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }
        List<ImportProposal> approvedProposals = ipDAO.findApprovedAvailableFiltered(search, fromDate, toDate, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("approvedProposals", approvedProposals);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.getRequestDispatcher("/view/receipt/import/import-select-proposal.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-create");

        String proposalIdStr = request.getParameter("proposalId");
        if (proposalIdStr != null && !proposalIdStr.isEmpty()) {
            int proposalId = parseId(proposalIdStr);
            ImportProposal p = new ImportProposalDAO().findById(proposalId);
            if (p != null && GlobalUtils.STATUS_APPROVED.equalsIgnoreCase(p.getStatus())) {
                List<ImportProposalDetail> pds = new ImportProposalDetailDAO().findByProposalId(proposalId);
                Receipt prefill = new Receipt();
                prefill.setProposalId(proposalId);
                prefill.setReceiptType(TYPE);
                prefill.setNote("Tạo từ đề xuất " + p.getProposalCode());
                prefill.setWarehouseId(p.getWarehouseId());
                List<ReceiptDetail> ds = new ArrayList<>();
                for (ImportProposalDetail pd : pds) {
                    ReceiptDetail rd = new ReceiptDetail();
                    rd.setGeneratorId(pd.getGeneratorId());
                    rd.setQuantity(pd.getQuantity());
                    rd.setNote(pd.getNote());
                    ds.add(rd);
                }
                prefill.setDetails(ds);
                request.setAttribute("receipt", prefill);
                request.setAttribute("proposal", p);
            }
        }
        request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null || receipt.getCreatedBy() != loggedUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!TYPE.equals(receipt.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=edit&id=" + id);
            return;
        }
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(receipt.getStatus());
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(receipt.getStatus());
        if (!isDraft && !isRevision) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("isDraft", isDraft);
        request.setAttribute("receipt", receipt);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", genDAO.findAllActive());
        request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
        request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
        request.setAttribute("activePage", "import-edit");
        request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt receipt = receiptDAO.findById(id);
        if (receipt == null) {
            request.setAttribute("error", "Không tìm thấy phiếu");
            request.getRequestDispatcher("/view/receipt/import/import-detail.jsp").forward(request, response);
            return;
        }
        if (!TYPE.equals(receipt.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/export-receipt?action=detail&id=" + id);
            return;
        }
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean isManager = perms != null && perms.contains("receipts.approve");
        boolean isOwner = receipt.getCreatedBy() == loggedUser.getId();
        List<ActivityLog> history = activityLogDAO.findByEntityTypeAndId("receipt", id, 1, 100);
        int totalHistory = activityLogDAO.countByEntityTypeAndId("receipt", id);

        request.setAttribute("receipt", receipt);
        request.setAttribute("isManager", isManager);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("receiptHistory", history);
        request.setAttribute("totalHistory", totalHistory);
        request.setAttribute("activePage", "import-detail");
        request.getRequestDispatcher("/view/receipt/import/import-detail.jsp").forward(request, response);
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
        List<Generator> generators = genDAO.findAllActive();
        List<Map<String, Object>> out = new ArrayList<>();
        for (Generator g : generators) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", g.getId());
            item.put("model", g.getModel());
            item.put("unitPrice", g.getUnitPrice());
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) { brand = c.getName(); break; }
                }
            }
            item.put("brand", brand);
            Inventory inv = inventoryDAO.findByWarehouseAndGenerator(whId, g.getId());
            item.put("stockQty", inv != null ? inv.getQuantity() : 0);
            out.add(item);
        }
        new Gson().toJson(out, response.getWriter());
    }

    private void saveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        boolean isDraft = "draft".equals(request.getParameter("submitMode"));

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();

        if (warehouseId <= 0 && !isDraft) errors.add("Vui lòng chọn kho");
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { if (!isDraft) errors.add("Lý do không hợp lệ"); }
        } else if (!isDraft) errors.add("Vui lòng chọn lý do");

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isDraft) {
            details = parseDetailsLenient(genIds, serials, quantities, unitPrices, detailNotes);
        } else {
            details = parseDetailsStrict(genIds, serials, quantities, unitPrices, detailNotes, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isDraft ? "Lưu nháp thất bại:" : "Lưu phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptCode(receiptDAO.generateReceiptCode(TYPE));
        r.setReceiptType(TYPE);
        r.setWarehouseId(warehouseId);
        r.setCreatedBy(loggedUser.getId());
        r.setNote(note);
        r.setReasonId(reasonId);
        r.setTotalAmount(computeTotal(details));
        r.setStatus(isDraft ? GlobalUtils.RECEIPT_STATUS_DRAFT : GlobalUtils.RECEIPT_STATUS_PENDING);

        String pid = request.getParameter("proposalId");
        if (pid != null && !pid.isEmpty()) {
            try {
                r.setProposalId(Integer.parseInt(pid));
            } catch (NumberFormatException ignored) {
            }
        }

        int receiptId = receiptDAO.insert(r);
        if (receiptId <= 0) {
            request.setAttribute("toastMessage", "Không thể tạo phiếu, vui lòng thử lại");
            request.setAttribute("toastType", "danger");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-create.jsp").forward(request, response);
            return;
        }
        for (ReceiptDetail d : details) { d.setReceiptId(receiptId); detailDAO.insert(d); }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("receipt");
        log.setAction("CREATE");
        log.setEntityId(receiptId);
        log.setEntityName(r.getReceiptCode());
        log.setDetails(isDraft ? "Lưu nháp phiếu nhập kho" : "Tạo phiếu nhập kho");
        activityLogDAO.insert(log);

        if (isDraft) {
            session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=edit&id=" + receiptId);
        } else {
            session.setAttribute("toastMessage", "Thêm phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
        }
    }

    private void updateReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int receiptId = parseId(request.getParameter("receiptId"));
        if (receiptId <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }

        Receipt existing = receiptDAO.findById(receiptId);
        if (existing == null || !TYPE.equals(existing.getReceiptType())) {
            response.sendRedirect(request.getContextPath() + "/import-receipt");
            return;
        }
        boolean isDraft = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(existing.getStatus());
        boolean isRevision = GlobalUtils.RECEIPT_STATUS_REVISION.equals(existing.getStatus());
        if (existing.getCreatedBy() != loggedUser.getId() || (!isDraft && !isRevision)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        boolean isSaveDraft = "draft".equals(request.getParameter("submitMode"));

        int warehouseId = parseId(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        Integer reasonId = null;
        List<String> errors = new ArrayList<>();
        if (warehouseId <= 0 && !isSaveDraft) errors.add("Vui lòng chọn kho");
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chú phiếu không được vượt quá " + MAX_NOTE_LENGTH + " ký tự");

        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { if (!isSaveDraft) errors.add("Lý do không hợp lệ"); }
        } else if (!isSaveDraft) errors.add("Vui lòng chọn lý do");

        String[] genIds = request.getParameterValues("generatorId");
        String[] serials = request.getParameterValues("serialNumber");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<ReceiptDetail> details;
        if (isSaveDraft) {
            details = parseDetailsLenient(genIds, serials, quantities, unitPrices, detailNotes);
        } else {
            details = parseDetailsStrict(genIds, serials, quantities, unitPrices, detailNotes, errors);
            if (details.isEmpty() && errors.stream().noneMatch(s -> s.startsWith("Dòng "))) {
                errors.add("Phải có ít nhất 1 dòng chi tiết hợp lệ");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", buildErrorMessage(isSaveDraft ? "Lưu nháp thất bại:" : "Cập nhật phiếu thất bại:", errors));
            request.setAttribute("errors", errors);
            request.setAttribute("activePage", "import-edit");
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
            return;
        }

        Receipt r = new Receipt();
        r.setReceiptId(receiptId);
        r.setWarehouseId(warehouseId);
        r.setNote(note);
        r.setReasonId(reasonId);
        r.setTotalAmount(computeTotal(details));
        String newStatus = isSaveDraft ? GlobalUtils.RECEIPT_STATUS_DRAFT : GlobalUtils.RECEIPT_STATUS_PENDING;
        boolean ok = isSaveDraft
                ? receiptDAO.updateDraftReceipt(r, details, loggedUser.getId(), newStatus)
                : receiptDAO.updateReceipt(r, details, loggedUser.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("receipt");
            log.setAction(isSaveDraft ? "DRAFT_UPDATE" : (isDraft ? "SUBMIT_DRAFT" : "UPDATE"));
            log.setEntityId(receiptId);
            log.setEntityName(existing.getReceiptCode());
            log.setDetails(isSaveDraft ? "Lưu nháp phiếu nhập kho" : (isDraft ? "Gửi phiếu nháp để duyệt" : "Cập nhật phiếu nhập kho"));
            activityLogDAO.insert(log);
            if (isSaveDraft) {
                session.setAttribute("toastMessage", "Đã lưu nháp phiếu");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/import-receipt?action=edit&id=" + receiptId);
            } else {
                session.setAttribute("toastMessage", "Cập nhật phiếu thành công, đã gửi lại để duyệt");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/import-receipt?action=list");
            }
        } else {
            request.setAttribute("toastMessage", "Không thể cập nhật phiếu");
            request.setAttribute("toastType", "danger");
            request.setAttribute("isDraft", isDraft);
            request.setAttribute("receipt", existing);
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("generators", genDAO.findAllActive());
            request.setAttribute("brandMap", buildBrandMap(genDAO.findAllActive()));
            request.setAttribute("receiptReasons", new CategoryDAO().findByType("receipt_reason"));
            request.getRequestDispatcher("/view/receipt/import/import-edit.jsp").forward(request, response);
        }
    }

    private void approveReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }
        boolean ok = receiptDAO.approveReceipt(id, loggedUser.getId());
        if (ok) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("APPROVE");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                log.setDetails("Duyệt phiếu nhập kho, cập nhật tồn kho");
                activityLogDAO.insert(log);
            }
            session.setAttribute("toastMessage", "Duyệt phiếu thành công");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể duyệt phiếu (phiếu không ở trạng thái chờ duyệt)");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private void rejectReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { reasonId = null; }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) reasonNote = null;
        }
        boolean ok = receiptDAO.rejectReceipt(id, loggedUser.getId(), reasonId, reasonNote);
        if (ok) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("REJECT");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                String detail = "Từ chối phiếu";
                if (reasonNote != null) detail += ": " + reasonNote;
                log.setDetails(detail);
                activityLogDAO.insert(log);
            }
            session.setAttribute("toastMessage", "Đã từ chối phiếu");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể từ chối phiếu");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private void requestRevision(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!hasApprovePerm(session)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendRedirect(request.getContextPath() + "/import-receipt"); return; }
        Integer reasonId = null;
        String reasonIdStr = request.getParameter("reasonId");
        if (reasonIdStr != null && !reasonIdStr.isEmpty()) {
            try { reasonId = Integer.parseInt(reasonIdStr); }
            catch (NumberFormatException e) { reasonId = null; }
        }
        String reasonNote = request.getParameter("reason");
        if (reasonNote != null) {
            reasonNote = reasonNote.trim();
            if (reasonNote.isEmpty()) reasonNote = null;
        }
        boolean ok = receiptDAO.requestRevision(id, loggedUser.getId(), reasonId, reasonNote);
        if (ok) {
            Receipt r = receiptDAO.findById(id);
            if (r != null) {
                ActivityLog log = new ActivityLog();
                log.setUserId(loggedUser.getId());
                log.setEntityType("receipt");
                log.setAction("REVISION");
                log.setEntityId(id);
                log.setEntityName(r.getReceiptCode());
                String detail = "Yêu cầu chỉnh sửa";
                if (reasonNote != null) detail += ": " + reasonNote;
                log.setDetails(detail);
                activityLogDAO.insert(log);
            }
            session.setAttribute("toastMessage", "Đã gửi yêu cầu chỉnh sửa");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/import-receipt?action=detail&id=" + id);
        } else {
            request.setAttribute("toastMessage", "Không thể yêu cầu chỉnh sửa");
            request.setAttribute("toastType", "danger");
            viewDetail(request, response);
        }
    }

    private boolean hasApprovePerm(HttpSession session) {
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        return perms != null && perms.contains("receipts.approve");
    }

    private int parseId(String s) {
        if (s == null || s.isEmpty()) return 0;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return 0; }
    }

    private int parsePage(String s) {
        if (s == null || s.isEmpty()) return 1;
        try { int p = Integer.parseInt(s); return p < 1 ? 1 : p; }
        catch (NumberFormatException e) { return 1; }
    }

    private Map<Integer, String> buildBrandMap(List<Generator> generators) {
        Map<Integer, String> brandMap = new LinkedHashMap<>();
        for (Generator g : generators) {
            String brand = "";
            if (g.getCategories() != null) {
                for (Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) { brand = c.getName(); break; }
                }
            }
            brandMap.put(g.getId(), brand);
        }
        return brandMap;
    }

    private String buildErrorMessage(String prefix, List<String> errors) {
        StringBuilder msg = new StringBuilder(prefix);
        for (String e : errors) msg.append(" ").append(e.replace("Dòng ", "dòng "));
        return msg.toString();
    }

    private java.math.BigDecimal computeTotal(List<ReceiptDetail> details) {
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        for (ReceiptDetail d : details) {
            if (d.getUnitPrice() != null) {
                total = total.add(d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getQuantity())));
            }
        }
        return total;
    }

    private List<ReceiptDetail> parseDetailsStrict(String[] genIds, String[] serials, String[] quantities,
            String[] unitPrices, String[] detailNotes, List<String> errors) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) return details;
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                    && (qtyStr == null || qtyStr.trim().isEmpty());
            if (rowEmpty) continue;
            int rowNum = i + 1;
            int genId = 0;
            try { genId = Integer.parseInt(idStr); }
            catch (NumberFormatException e) { errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện"); continue; }
            if (genId <= 0) { errors.add("Dòng " + rowNum + ": Vui lòng chọn máy phát điện"); continue; }

            int qty = 1;
            if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                try { qty = Integer.parseInt(qtyStr.trim()); }
                catch (NumberFormatException e) { errors.add("Dòng " + rowNum + ": Số lượng không hợp lệ"); continue; }
            }
            if (qty <= 0) { errors.add("Dòng " + rowNum + ": Số lượng phải lớn hơn 0"); continue; }
            if (qty > MAX_QUANTITY) { errors.add("Dòng " + rowNum + ": Số lượng không được vượt quá " + MAX_QUANTITY); continue; }

            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) serial = null;
                else if (serial.length() > MAX_SERIAL_LENGTH) {
                    errors.add("Dòng " + rowNum + ": Số serial không được vượt quá " + MAX_SERIAL_LENGTH + " ký tự"); continue;
                }
            }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) {
                errors.add("Dòng " + rowNum + ": Ghi chú không được vượt quá " + MAX_NOTE_LENGTH + " ký tự"); continue;
            }
            java.math.BigDecimal price = null;
            String priceStr = (unitPrices != null && i < unitPrices.length) ? unitPrices[i] : null;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try { price = new java.math.BigDecimal(priceStr.trim().replace(",", "")); }
                catch (NumberFormatException e) { errors.add("Dòng " + rowNum + ": Đơn giá không hợp lệ"); continue; }
            }
            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId); d.setSerialNumber(serial);
            d.setQuantity(qty); d.setUnitPrice(price); d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }

    private List<ReceiptDetail> parseDetailsLenient(String[] genIds, String[] serials, String[] quantities,
            String[] unitPrices, String[] detailNotes) {
        List<ReceiptDetail> details = new ArrayList<>();
        if (genIds == null) return details;
        for (int i = 0; i < genIds.length; i++) {
            String idStr = genIds[i];
            String serial = (serials != null && i < serials.length) ? serials[i] : null;
            String qtyStr = (quantities != null && i < quantities.length) ? quantities[i] : null;
            String detailNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
            boolean rowEmpty = (idStr == null || idStr.trim().isEmpty())
                    && (qtyStr == null || qtyStr.trim().isEmpty());
            if (rowEmpty) continue;
            int genId = 0;
            try { genId = Integer.parseInt(idStr); } catch (NumberFormatException e) { continue; }
            if (genId <= 0) continue;
            int qty = 1;
            if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                try { qty = Integer.parseInt(qtyStr.trim()); } catch (NumberFormatException e) { qty = 1; }
            }
            if (qty <= 0) qty = 1; else if (qty > MAX_QUANTITY) qty = MAX_QUANTITY;
            if (serial != null) {
                serial = serial.trim();
                if (serial.isEmpty()) serial = null;
                else if (serial.length() > MAX_SERIAL_LENGTH) serial = serial.substring(0, MAX_SERIAL_LENGTH);
            }
            java.math.BigDecimal price = null;
            String priceStr = (unitPrices != null && i < unitPrices.length) ? unitPrices[i] : null;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try { price = new java.math.BigDecimal(priceStr.trim().replace(",", "")); }
                catch (NumberFormatException e) { price = null; }
            }
            if (detailNote != null && detailNote.length() > MAX_NOTE_LENGTH) detailNote = detailNote.substring(0, MAX_NOTE_LENGTH);
            ReceiptDetail d = new ReceiptDetail();
            d.setGeneratorId(genId); d.setSerialNumber(serial);
            d.setQuantity(qty); d.setUnitPrice(price); d.setNote(detailNote);
            details.add(d);
        }
        return details;
    }
}