package com.quanlymayphatdien.g1.controller.warehouse.transfer;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.TransferDAO;
import com.quanlymayphatdien.g1.dal.TransferDetailDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Transfer;
import com.quanlymayphatdien.g1.entity.TransferDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.entity.Warehouse;
import com.quanlymayphatdien.g1.service.NotificationService;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
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

@WebServlet(name = "TransferController", urlPatterns = {"/transfers"})
public class TransferController extends HttpServlet {

    private final TransferDAO transferDAO = new TransferDAO();
    private final TransferDetailDAO detailDAO = new TransferDetailDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final GeneratorDAO generatorDAO = new GeneratorDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    private static final int MAX_NOTE_LENGTH = 500;
    private static final int MAX_DETAIL_NOTE_LENGTH = 500;
    private static final int MAX_REJECT_NOTE_LENGTH = 500;
    private static final int MAX_SERIAL_LENGTH = 100;

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
                case "list":
                    showList(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit_view":
                    showEditView(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "get_generator_stock":
                    handleGetGeneratorStock(request, response);
                    break;
                default:
                    showList(request, response);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.TRANSFER, "TransferController.doGet", e.getMessage(), e);
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/transfers");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "create":
                    handleCreate(request, response, user);
                    break;
                case "create_and_submit":
                    handleCreateAndSubmit(request, response, user);
                    break;
                case "edit_submit":
                    handleEditSubmit(request, response, user);
                    break;
                case "submit":
                    handleSubmit(request, response, user);
                    break;
                case "cancel":
                    handleCancel(request, response, user);
                    break;
                case "approve_manager":
                    handleManagerApprove(request, response, user);
                    break;
                case "reject_manager":
                    handleManagerReject(request, response, user);
                    break;
                case "approve_ceo":
                    handleCeoApprove(request, response, user);
                    break;
                case "reject_ceo":
                    handleCeoReject(request, response, user);
                    break;
                case "final_approve":
                    handleFinalApprove(request, response, user);
                    break;
                case "final_reject":
                    handleFinalReject(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.TRANSFER, "TransferController.doPost", e.getMessage(), e);
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/transfers?error=1");
            }
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        int page = parseInt(request.getParameter("page"), 1);
        if (page < 1) {
            page = 1;
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        int total = transferDAO.countTotal(search, statusFilter, null);
        int totalPages = (int) Math.ceil((double) total / limit);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        offset = (page - 1) * limit;

        List<Transfer> list = transferDAO.findWithPagination(limit, offset, search, statusFilter, null);
        Map<String, Integer> kpis = transferDAO.getKpiCounts(null);

        request.setAttribute("transfers", list);
        request.setAttribute("kpiDraft", kpis.getOrDefault("DRAFT", 0));
        request.setAttribute("kpiPendingManager", kpis.getOrDefault("PENDING_MANAGER", 0));
        request.setAttribute("kpiPendingCeo", kpis.getOrDefault("PENDING_CEO", 0));
        request.setAttribute("kpiCompleted", kpis.getOrDefault("COMPLETED", 0));
        request.setAttribute("kpiRejected", kpis.getOrDefault("REJECTED", 0));
        request.setAttribute("kpiCancelled", kpis.getOrDefault("CANCELLED", 0));
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("search", search);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("activePage", "transfer-list");

        request.getRequestDispatcher("/view/warehouse/transfer/transfer-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", generatorDAO.findAllActive());
        request.setAttribute("allSerials", loadAllInStockSerials());
        request.setAttribute("activePage", "transfer-create");
        request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
    }

    private void showEditView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        if (!"DRAFT".equals(t.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        request.setAttribute("transfer", t);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", generatorDAO.findAllActive());
        request.setAttribute("allSerials", loadAllInStockSerials());
        request.setAttribute("activePage", "transfer-edit");
        request.getRequestDispatcher("/view/warehouse/transfer/transfer-edit.jsp").forward(request, response);
    }

    private List<Inventory> loadAllInStockSerials() {
        List<Inventory> all = inventoryDAO.findAll();
        List<Inventory> result = new ArrayList<>();
        for (Inventory inv : all) {
            if ("IN_STOCK".equals(inv.getStatus())) {
                result.add(inv);
            }
        }
        return result;
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            request.setAttribute("error", "Khong tim thay phieu");
            request.getRequestDispatcher("/view/warehouse/transfer/transfer-detail.jsp").forward(request, response);
            return;
        }

        boolean isOwner = (t.getCreatedBy() == user.getId());

        List<ActivityLog> history = activityLogDAO.findByEntityTypeAndId("transfer", id, 1, 100);
        int totalHistory = activityLogDAO.countByEntityTypeAndId("transfer", id);

        request.setAttribute("transfer", t);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("transferHistory", history);
        request.setAttribute("totalHistory", totalHistory);
        request.setAttribute("activePage", "transfer-detail");

        request.getRequestDispatcher("/view/warehouse/transfer/transfer-detail.jsp").forward(request, response);
    }

    private void handleGetGeneratorStock(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Method nay khong con can thiet: serial duoc load san trong JSP.
        // Giu lai de tuong thich URL.
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"generators\":[]}");
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int sourceWh = parseInt(request.getParameter("sourceWarehouseId"), 0);
        int destWh = parseInt(request.getParameter("destWarehouseId"), 0);
        String note = request.getParameter("note");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<String> errors = new ArrayList<>();
        if (sourceWh <= 0) {
            errors.add("Vui long chon kho nguon");
        }
        if (destWh <= 0) {
            errors.add("Vui long chon kho dich");
        }
        if (sourceWh > 0 && destWh > 0 && sourceWh == destWh) {
            errors.add("Kho nguon va kho dich phai khac nhau");
        }
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            errors.add("Ghi chu khong vuot qua " + MAX_NOTE_LENGTH + " ky tu");
        }
        if (serials == null || serials.length == 0) {
            errors.add("Phai co it nhat 1 dong chi tiet");
        }

        // Moi dong = 1 serial (quantity luon = 1)
        // Tranh trung serial trong cung phieu
        java.util.Set<String> seenSerials = new java.util.HashSet<>();
        List<TransferDetail> details = new ArrayList<>();
        if (serials != null) {
            for (int i = 0; i < serials.length; i++) {
                String serial = serials[i];
                if (serial == null) continue;
                serial = serial.trim();
                if (serial.isEmpty()) continue;

                int rowNum = i + 1;
                if (serial.length() > MAX_SERIAL_LENGTH) {
                    errors.add("Dong " + rowNum + ": serial khong vuot qua " + MAX_SERIAL_LENGTH + " ky tu");
                    continue;
                }
                if (!seenSerials.add(serial)) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" bi trung trong phieu");
                    continue;
                }

                // Lay generator_id tu serial bang cach kiem tra trong allSerials
                // (request scope khong co o day, nen query DB)
                Inventory inv = inventoryDAO.findBySerialNumber(serial);
                if (inv == null) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong ton tai trong he thong");
                    continue;
                }
                if (!InventoryDAO.STATUS_IN_STOCK.equals(inv.getStatus())) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong o trang thai IN_STOCK");
                    continue;
                }
                if (sourceWh > 0 && inv.getWarehouseId() != sourceWh) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong thuoc kho nguon");
                    continue;
                }

                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                if (dNote != null && dNote.length() > MAX_DETAIL_NOTE_LENGTH) {
                    errors.add("Dong " + rowNum + ": ghi chu khong vuot qua " + MAX_DETAIL_NOTE_LENGTH + " ky tu");
                    continue;
                }

                TransferDetail d = new TransferDetail();
                d.setGeneratorId(inv.getGeneratorId());
                d.setQuantity(1);
                d.setSerialNumber(serial);
                d.setNote(dNote);
                details.add(d);
            }
        }
        if (details.isEmpty()) {
            errors.add("Phai co it nhat 1 dong chi tiet hop le");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", String.join("; ", errors));
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("allSerials", inventoryDAO.findByFilters(null, null, InventoryDAO.STATUS_IN_STOCK, null, 1, 10000));
            request.setAttribute("activePage", "transfer-create");
            request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
            return;
        }

        Transfer t = new Transfer();
        t.setTransferCode(transferDAO.generateTransferCode());
        t.setSourceWarehouseId(sourceWh);
        t.setDestWarehouseId(destWh);
        t.setStatus("DRAFT");
        t.setCreatedBy(user.getId());
        t.setNote(note);

        int newId = transferDAO.insert(t);
        if (newId <= 0) {
            request.setAttribute("toastMessage", "Khong the tao phieu");
            request.setAttribute("toastType", "danger");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("allSerials", inventoryDAO.findByFilters(null, null, InventoryDAO.STATUS_IN_STOCK, null, 1, 10000));
            request.setAttribute("activePage", "transfer-create");
            request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
            return;
        }
        for (TransferDetail d : details) {
            d.setTransferId(newId);
            detailDAO.insert(d);
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("transfer");
        log.setAction("CREATE");
        log.setEntityId(newId);
        log.setEntityName(t.getTransferCode());
        log.setDetails("Tao phieu luan chuyen (DRAFT)");
        activityLogDAO.insert(log);

        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", "Tao phieu thanh cong. Vui long kiem tra lai va gui duyet.");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/transfers");
    }

    private void handleCreateAndSubmit(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int sourceWh = parseInt(request.getParameter("sourceWarehouseId"), 0);
        int destWh = parseInt(request.getParameter("destWarehouseId"), 0);
        String note = request.getParameter("note");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<String> errors = new ArrayList<>();
        if (sourceWh <= 0) errors.add("Vui long chon kho nguon");
        if (destWh <= 0) errors.add("Vui long chon kho dich");
        if (sourceWh > 0 && destWh > 0 && sourceWh == destWh) errors.add("Kho nguon va kho dich phai khac nhau");
        if (note != null && note.length() > MAX_NOTE_LENGTH) errors.add("Ghi chu khong vuot qua " + MAX_NOTE_LENGTH + " ky tu");
        if (serials == null || serials.length == 0) errors.add("Phai co it nhat 1 dong chi tiet");

        java.util.Set<String> seenSerials = new java.util.HashSet<>();
        List<TransferDetail> details = new ArrayList<>();
        if (serials != null) {
            for (int i = 0; i < serials.length; i++) {
                String serial = serials[i];
                if (serial == null) continue;
                serial = serial.trim();
                if (serial.isEmpty()) continue;

                int rowNum = i + 1;
                if (serial.length() > MAX_SERIAL_LENGTH) {
                    errors.add("Dong " + rowNum + ": serial khong vuot qua " + MAX_SERIAL_LENGTH + " ky tu");
                    continue;
                }
                if (!seenSerials.add(serial)) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" bi trung trong phieu");
                    continue;
                }

                Inventory inv = inventoryDAO.findBySerialNumber(serial);
                if (inv == null) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong ton tai trong he thong");
                    continue;
                }
                if (!InventoryDAO.STATUS_IN_STOCK.equals(inv.getStatus())) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong o trang thai IN_STOCK");
                    continue;
                }
                if (sourceWh > 0 && inv.getWarehouseId() != sourceWh) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong thuoc kho nguon");
                    continue;
                }

                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                if (dNote != null && dNote.length() > MAX_DETAIL_NOTE_LENGTH) {
                    errors.add("Dong " + rowNum + ": ghi chu khong vuot qua " + MAX_DETAIL_NOTE_LENGTH + " ky tu");
                    continue;
                }

                TransferDetail d = new TransferDetail();
                d.setGeneratorId(inv.getGeneratorId());
                d.setQuantity(1);
                d.setSerialNumber(serial);
                d.setNote(dNote);
                details.add(d);
            }
        }
        if (details.isEmpty()) errors.add("Phai co it nhat 1 dong chi tiet hop le");

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", String.join("; ", errors));
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("allSerials", inventoryDAO.findByFilters(null, null, InventoryDAO.STATUS_IN_STOCK, null, 1, 10000));
            request.setAttribute("activePage", "transfer-create");
            request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
            return;
        }

        Transfer t = new Transfer();
        t.setTransferCode(transferDAO.generateTransferCode());
        t.setSourceWarehouseId(sourceWh);
        t.setDestWarehouseId(destWh);
        t.setStatus("DRAFT");
        t.setCreatedBy(user.getId());
        t.setNote(note);

        int newId = transferDAO.insert(t);
        if (newId <= 0) {
            request.setAttribute("toastMessage", "Khong the tao phieu");
            request.setAttribute("toastType", "danger");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("allSerials", inventoryDAO.findByFilters(null, null, InventoryDAO.STATUS_IN_STOCK, null, 1, 10000));
            request.setAttribute("activePage", "transfer-create");
            request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
            return;
        }
        for (TransferDetail d : details) {
            d.setTransferId(newId);
            detailDAO.insert(d);
        }

        ActivityLog createLog = new ActivityLog();
        createLog.setUserId(user.getId());
        createLog.setEntityType("transfer");
        createLog.setAction("CREATE");
        createLog.setEntityId(newId);
        createLog.setEntityName(t.getTransferCode());
        createLog.setDetails("Tao phieu luan chuyen");
        activityLogDAO.insert(createLog);

        boolean ok = transferDAO.submitForReview(newId, user.getId());
        if (ok) {
            ActivityLog submitLog = new ActivityLog();
            submitLog.setUserId(user.getId());
            submitLog.setEntityType("transfer");
            submitLog.setAction("SUBMIT");
            submitLog.setEntityId(newId);
            submitLog.setEntityName(t.getTransferCode());
            submitLog.setDetails("Gui phieu luan chuyen cho Manager duyet");
            activityLogDAO.insert(submitLog);

            List<User> managers = userDAO.findUsersWithRoles("warehouse_manager", null, null, 1, 1000);
            for (User mgr : managers) {
                NotificationService.send(
                        mgr.getId(),
                        "Phieu luan chuyen moi cho duyet",
                        "Nhan vien " + user.getName() + " da tao phieu luan chuyen " + t.getTransferCode() + " can ban duyet.",
                        request.getContextPath() + "/transfers?action=detail&id=" + newId,
                        "transfer",
                        newId
                );
            }

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Tao va gui phieu cho Manager duyet thanh cong");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Tao phieu thanh cong nhung khong the gui (trang thai khong hop le)");
            session.setAttribute("toastType", "warning");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + newId);
    }

    private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer existing = transferDAO.findById(id);
        if (existing == null || !"DRAFT".equals(existing.getStatus()) || existing.getCreatedBy() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }

        int sourceWh = parseInt(request.getParameter("sourceWarehouseId"), 0);
        int destWh = parseInt(request.getParameter("destWarehouseId"), 0);
        String note = request.getParameter("note");
        String[] serials = request.getParameterValues("serialNumber");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<String> errors = new ArrayList<>();
        if (sourceWh <= 0) {
            errors.add("Vui long chon kho nguon");
        }
        if (destWh <= 0) {
            errors.add("Vui long chon kho dich");
        }
        if (sourceWh > 0 && destWh > 0 && sourceWh == destWh) {
            errors.add("Kho nguon va kho dich phai khac nhau");
        }

        java.util.Set<String> seenSerials = new java.util.HashSet<>();
        List<TransferDetail> details = new ArrayList<>();
        if (serials != null) {
            for (int i = 0; i < serials.length; i++) {
                String serial = serials[i];
                if (serial == null) continue;
                serial = serial.trim();
                if (serial.isEmpty()) continue;

                int rowNum = i + 1;
                if (serial.length() > MAX_SERIAL_LENGTH) {
                    continue;
                }
                if (!seenSerials.add(serial)) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" bi trung trong phieu");
                    continue;
                }

                Inventory inv = inventoryDAO.findBySerialNumber(serial);
                if (inv == null) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong ton tai trong he thong");
                    continue;
                }
                if (!InventoryDAO.STATUS_IN_STOCK.equals(inv.getStatus())) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong o trang thai IN_STOCK");
                    continue;
                }
                if (sourceWh > 0 && inv.getWarehouseId() != sourceWh) {
                    errors.add("Dong " + rowNum + ": serial \"" + serial + "\" khong thuoc kho nguon");
                    continue;
                }

                String dNote = (detailNotes != null && i < detailNotes.length) ? detailNotes[i] : null;
                TransferDetail d = new TransferDetail();
                d.setGeneratorId(inv.getGeneratorId());
                d.setQuantity(1);
                d.setSerialNumber(serial);
                d.setNote(dNote);
                details.add(d);
            }
        }
        if (details.isEmpty()) {
            errors.add("Phai co it nhat 1 dong chi tiet hop le");
        }
        if (!errors.isEmpty()) {
            request.setAttribute("toastMessage", String.join("; ", errors));
            request.setAttribute("toastType", "danger");
            showEditView(request, response);
            return;
        }

        Transfer t = new Transfer();
        t.setTransferId(id);
        t.setSourceWarehouseId(sourceWh);
        t.setDestWarehouseId(destWh);
        t.setNote(note);

        boolean headerOk = transferDAO.updateHeader(t);
        if (headerOk) {
            detailDAO.deleteByTransferId(id);
            for (TransferDetail d : details) {
                d.setTransferId(id);
                detailDAO.insert(d);
            }
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("UPDATE");
            log.setEntityId(id);
            log.setEntityName(existing.getTransferCode());
            log.setDetails("Sua phieu luan chuyen (DRAFT)");
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Cap nhat phieu thanh cong");
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
        } else {
            response.sendRedirect(request.getContextPath() + "/transfers");
        }
    }

    private void handleSubmit(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null || t.getCreatedBy() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.submitForReview(id, user.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("SUBMIT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Gui phieu luan chuyen cho Manager duyet");
            activityLogDAO.insert(log);

            List<User> managers = userDAO.findUsersWithRoles("warehouse_manager", null, null, 1, 1000);
            for (User mgr : managers) {
                NotificationService.send(
                        mgr.getId(),
                        "Phieu luan chuyen moi cho duyet",
                        "Nhan vien " + user.getName() + " da tao phieu luan chuyen " + t.getTransferCode() + " can ban duyet.",
                        request.getContextPath() + "/transfers?action=detail&id=" + id,
                        "transfer",
                        id
                );
            }

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da gui phieu cho Manager duyet");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the gui phieu (trang thai khong hop le)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null || t.getCreatedBy() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.staffCancel(id, user.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CANCEL");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Staff tu huy phieu luan chuyen");
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da huy phieu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the huy phieu (trang thai khong hop le hoac khong phai cua ban)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleManagerApprove(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.managerApproveForward(id, user.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("MANAGER_APPROVE");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Manager duyet lan 1, trinh len CEO");
            activityLogDAO.insert(log);

            NotificationService.send(
                    t.getCreatedBy(),
                    "Quan ly da duyet phieu luan chuyen",
                    "Phieu luan chuyen " + t.getTransferCode() + " da duoc Manager " + user.getName() + " duyet va trinh CEO.",
                    request.getContextPath() + "/transfers?action=detail&id=" + id,
                    "transfer",
                    id
            );

            List<User> ceos = userDAO.findUsersWithRoles("ceo", null, null, 1, 100);
            for (User ceo : ceos) {
                NotificationService.send(
                        ceo.getId(),
                        "Phieu luan chuyen cho CEO duyet",
                        "Manager " + user.getName() + " da trinh len phieu luan chuyen " + t.getTransferCode() + " can CEO duyet.",
                        request.getContextPath() + "/transfers?action=detail&id=" + id,
                        "transfer",
                        id
                );
            }

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da duyet phieu va trinh len CEO");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the duyet phieu (trang thai khong hop le)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleManagerReject(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        String note = request.getParameter("managerNote");
        if (note != null) {
            note = note.trim();
        }
        if (note == null || note.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui long nhap ly do tu choi");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        if (note.length() > MAX_REJECT_NOTE_LENGTH) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Ly do qua dai (toi da " + MAX_REJECT_NOTE_LENGTH + " ky tu)");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.reject(id, user.getId(), "manager", note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("MANAGER_REJECT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Manager tu choi: " + note);
            activityLogDAO.insert(log);

            NotificationService.send(
                    t.getCreatedBy(),
                    "Quan ly tu choi phieu luan chuyen",
                    "Phieu " + t.getTransferCode() + " bi Manager tu choi. Ly do: " + note,
                    request.getContextPath() + "/transfers?action=detail&id=" + id,
                    "transfer",
                    id
            );

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da tu choi phieu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the tu choi phieu");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleCeoApprove(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.ceoApproveReturnToManager(id, user.getId());
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CEO_APPROVE");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO duyet, tra ve Manager xac nhan cuoi");
            activityLogDAO.insert(log);

            NotificationService.send(
                    t.getCreatedBy(),
                    "CEO da duyet phieu luan chuyen",
                    "Phieu luan chuyen " + t.getTransferCode() + " da duoc CEO " + user.getName() + " duyet, can Manager xac nhan cuoi de thuc hien.",
                    request.getContextPath() + "/transfers?action=detail&id=" + id,
                    "transfer",
                    id
            );

            List<User> managers = userDAO.findUsersWithRoles("warehouse_manager", null, null, 1, 100);
            for (User mgr : managers) {
                NotificationService.send(
                        mgr.getId(),
                        "Phieu luan chuyen can Manager xac nhan cuoi",
                        "CEO da duyet phieu luan chuyen " + t.getTransferCode() + ", can Manager xac nhan cuoi de thuc hien chuyen kho.",
                        request.getContextPath() + "/transfers?action=detail&id=" + id,
                        "transfer",
                        id
                );
            }

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da duyet phieu, tra ve Manager xac nhan cuoi");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the duyet phieu");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleCeoReject(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        String note = request.getParameter("ceoNote");
        if (note != null) {
            note = note.trim();
        }
        if (note == null || note.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui long nhap ly do tu choi");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        if (note.length() > MAX_REJECT_NOTE_LENGTH) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Ly do qua dai (toi da " + MAX_REJECT_NOTE_LENGTH + " ky tu)");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.reject(id, user.getId(), "ceo", note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CEO_REJECT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO tu choi: " + note);
            activityLogDAO.insert(log);

            NotificationService.send(
                    t.getCreatedBy(),
                    "CEO tu choi phieu luan chuyen",
                    "Phieu " + t.getTransferCode() + " bi CEO tu choi. Ly do: " + note,
                    request.getContextPath() + "/transfers?action=detail&id=" + id,
                    "transfer",
                    id
            );

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da tu choi phieu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the tu choi phieu");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleFinalApprove(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }

        String error = transferDAO.executeTransfer(id, user.getId());
        if (error == null) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("FINAL_APPROVE");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Manager xac nhan cuoi, phieu da duoc chuyen kho tu dong");
            activityLogDAO.insert(log);

            NotificationService.send(
                    t.getCreatedBy(),
                    "Phieu luan chuyen da hoan tat",
                    "Phieu luan chuyen " + t.getTransferCode() + " da duoc Manager " + user.getName() + " xac nhan va chuyen kho thanh cong.",
                    request.getContextPath() + "/transfers?action=detail&id=" + id,
                    "transfer",
                    id
            );

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Phieu da hoan tat, kho da duoc cap nhat");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the hoan tat: " + error);
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleFinalReject(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        String note = request.getParameter("managerNote");
        if (note != null) {
            note = note.trim();
        }
        if (note == null || note.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui long nhap ly do tu choi");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        if (note.length() > MAX_REJECT_NOTE_LENGTH) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Ly do qua dai (toi da " + MAX_REJECT_NOTE_LENGTH + " ky tu)");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.reject(id, user.getId(), "manager", note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("MANAGER_REJECT_R2");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Manager tu choi lan 2: " + note);
            activityLogDAO.insert(log);

            NotificationService.send(
                    t.getCreatedBy(),
                    "Quan ly tu choi phieu luan chuyen (xac nhan cuoi)",
                    "Phieu " + t.getTransferCode() + " bi Manager tu choi o buoc xac nhan cuoi. Ly do: " + note,
                    request.getContextPath() + "/transfers?action=detail&id=" + id,
                    "transfer",
                    id
            );

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da tu choi phieu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the tu choi phieu");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private int parseInt(String s, int def) {
        if (s == null || s.isEmpty()) {
            return def;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t")
                .replace("/", "\\/");
    }
}