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
import com.quanlymayphatdien.g1.utils.NotificationService;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.utils.WarehouseAccessUtil;
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
                case "ce_approve":
                    handleCeoApprove(request, response, user);
                    break;
                case "ce_reject":
                    handleCeoReject(request, response, user);
                    break;
                case "dest_accept":
                    handleDestAccept(request, response, user);
                    break;
                case "dest_reject":
                    handleDestReject(request, response, user);
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

        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean isManagerOrCeo = perms != null
                && (perms.contains("transfers.approve_manager") || perms.contains("transfers.approve_ceo"));

        int scopedWarehouseId = com.quanlymayphatdien.g1.utils.WarehouseAccessUtil.getScopedWarehouseId(session);

        Integer filterUserId = (isManagerOrCeo && scopedWarehouseId <= 0) ? null : null;

        int total = transferDAO.countTotal(search, statusFilter, filterUserId, scopedWarehouseId, loggedUser.getId());
        int totalPages = (int) Math.ceil((double) total / limit);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        offset = (page - 1) * limit;

        List<Transfer> list = transferDAO.findWithPagination(limit, offset, search, statusFilter,
                filterUserId, scopedWarehouseId, loggedUser.getId());
        Map<String, Integer> kpis = transferDAO.getKpiCounts(filterUserId, scopedWarehouseId, loggedUser.getId());

        request.setAttribute("transfers", list);
        request.setAttribute("kpiPendingCeo", kpis.getOrDefault("PENDING_CEO", 0));
        request.setAttribute("kpiAwaitingDest", kpis.getOrDefault("AWAITING_DEST_ACCEPT", 0));
        request.setAttribute("kpiCompleted", kpis.getOrDefault("COMPLETED", 0));
        request.setAttribute("kpiRejected", kpis.getOrDefault("REJECTED", 0));
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
        request.setAttribute("allSerials", inventoryDAO.findAllInStock());
        request.setAttribute("activePage", "transfer-create");
        request.getRequestDispatcher("/view/warehouse/transfer/transfer-create.jsp").forward(request, response);
    }

    private void showEditView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Workflow moi khong co DRAFT/NEEDS_REVISION - redirect ve detail.
        int id = parseInt(request.getParameter("id"), 0);
        if (id > 0) {
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
        } else {
            response.sendRedirect(request.getContextPath() + "/transfers");
        }
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
        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        int scopedWarehouseId = com.quanlymayphatdien.g1.utils.WarehouseAccessUtil.getScopedWarehouseId(session);
        boolean isCeo = perms != null && perms.contains("transfers.approve_ceo");
        boolean isDestStaff = perms != null && perms.contains("transfers.approve_dest")
                && scopedWarehouseId == t.getDestWarehouseId();

        if (!isCeo && !isDestStaff && !isOwner) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        boolean canCeApprove = isCeo && "PENDING_CEO".equals(t.getStatus());
        boolean canCeReject = isCeo && "PENDING_CEO".equals(t.getStatus());
        boolean canDestAccept = isDestStaff && "AWAITING_DEST_ACCEPT".equals(t.getStatus());
        boolean canDestReject = isDestStaff && "AWAITING_DEST_ACCEPT".equals(t.getStatus());

        request.setAttribute("canCeApprove", canCeApprove);
        request.setAttribute("canCeReject", canCeReject);
        request.setAttribute("canDestAccept", canDestAccept);
        request.setAttribute("canDestReject", canDestReject);

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
            List<ActivityLog> logs = activityLogDAO.findByEntityTypeAndId2("transfer", id, logSearch, logAction,
                    dateFrom, dateTo, page, pageSize);
            int totalLogs = activityLogDAO.countByEntityTypeAndId2("transfer", id, logSearch, logAction,
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

        request.setAttribute("transfer", t);
        request.setAttribute("isOwner", isOwner);
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
                if (serial == null) {
                    continue;
                }
                serial = serial.trim();
                if (serial.isEmpty()) {
                    continue;
                }

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
        t.setStatus("PENDING_CEO");
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
        log.setDetails("Tao phieu luan chuyen (PENDING_CEO)");
        activityLogDAO.insert(log);

        List<User> ceos = userDAO.findUsersWithRoles("ceo", null, null, 1, 1000);
        for (User ceo : ceos) {
            NotificationService.send(
                    ceo.getId(),
                    "Phieu luan chuyen moi cho duyet",
                    "Nhan vien " + user.getName() + " da tao phieu luan chuyen " + t.getTransferCode() + " can CEO duyet.",
                    request.getContextPath() + "/transfers?action=detail&id=" + newId,
                    "transfer",
                    newId
            );
        }

        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", "Tao phieu thanh cong. Phieu da duoc gui cho CEO duyet.");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + newId);
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
        String note = request.getParameter("ceoNote");
        boolean ok = transferDAO.ceApproveForward(id, user.getId(), note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CE_APPROVE");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO duyet phieu luan chuyen (PENDING_CEO -> AWAITING_DEST_ACCEPT)");
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "CEO da duyet phieu. Kho dich can xac nhan.");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the duyet (trang thai khong hop le)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleCeoReject(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        String note = request.getParameter("ceoNote");
        if (note != null) {
            note = note.trim();
            if (note.isEmpty()) {
                note = null;
            }
        }
        if (note == null) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui long nhap ly do tu choi");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        Transfer t = transferDAO.findById(id);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/transfers");
            return;
        }
        boolean ok = transferDAO.ceReject(id, user.getId(), note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("CE_REJECT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("CEO tu choi: " + note);
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da tu choi phieu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the tu choi (trang thai khong hop le)");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleDestAccept(HttpServletRequest request, HttpServletResponse response, User user)
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
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(request.getSession(false));
        if (scopedWarehouseId != t.getDestWarehouseId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String error = transferDAO.destAccept(id, user.getId());
        if (error == null) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("DEST_ACCEPT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Kho dich chap nhan phieu luan chuyen. Ton kho da duoc dieu chuyen.");
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Chap nhan phieu thanh cong. Ton kho da duoc dieu chuyen.");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", error);
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
    }

    private void handleDestReject(HttpServletRequest request, HttpServletResponse response, User user)
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
        int scopedWarehouseId = WarehouseAccessUtil.getScopedWarehouseId(request.getSession(false));
        if (scopedWarehouseId != t.getDestWarehouseId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String note = request.getParameter("destNote");
        if (note != null) {
            note = note.trim();
            if (note.isEmpty()) {
                note = null;
            }
        }
        if (note == null) {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Vui long nhap ly do tu choi");
            session.setAttribute("toastType", "danger");
            response.sendRedirect(request.getContextPath() + "/transfers?action=detail&id=" + id);
            return;
        }
        boolean ok = transferDAO.destReject(id, user.getId(), note);
        if (ok) {
            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("transfer");
            log.setAction("DEST_REJECT");
            log.setEntityId(id);
            log.setEntityName(t.getTransferCode());
            log.setDetails("Kho dich tu choi: " + note);
            activityLogDAO.insert(log);

            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Da tu choi phieu");
            session.setAttribute("toastType", "success");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("toastMessage", "Khong the tu choi (trang thai khong hop le)");
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
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t")
                .replace("/", "\\/");
    }
}
