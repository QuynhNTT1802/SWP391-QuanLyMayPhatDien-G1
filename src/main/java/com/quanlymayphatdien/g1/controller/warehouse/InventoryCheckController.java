package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.InventoryCheckDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.StockCardDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.InventoryCheck;
import com.quanlymayphatdien.g1.entity.InventoryCheckDetail;
import com.quanlymayphatdien.g1.entity.InventoryCheckSerial;
import com.quanlymayphatdien.g1.entity.StockCard;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.InventoryCheckExcelSupport;
import com.quanlymayphatdien.g1.utils.NotificationService;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "InventoryCheckController", urlPatterns = {"/inventory-check"})
public class InventoryCheckController extends HttpServlet {

    private final InventoryCheckDAO checkDAO = new InventoryCheckDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final StockCardDAO stockCardDAO = new StockCardDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

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
                    viewList(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "detail":
                    viewDetail(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "exportReport":
                    exportReport(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "InventoryCheckController.doGet", e.getMessage(), e);
            e.printStackTrace();
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
        try {
            switch (action) {
                case "save":
                    saveCheck(request, response);
                    break;
                case "update":
                    updateCheck(request, response);
                    break;
                case "complete":
                    completeCheck(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "InventoryCheckController.doPost", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private void viewList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String whParam = request.getParameter("warehouseId");
        Integer warehouseId = (whParam != null && !whParam.isEmpty()) ? Integer.parseInt(whParam) : null;
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

        int totalItems = checkDAO.countWithFilters(search, warehouseId, status);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<InventoryCheck> list = checkDAO.findWithFilters(search, warehouseId, status, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("checkList", list);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("search", search);
        request.setAttribute("selectedWarehouse", warehouseId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("totalChecks", checkDAO.countTotal());
        request.setAttribute("doingCount", checkDAO.countByStatus("doing"));
        request.setAttribute("completedCount", checkDAO.countByStatus("completed"));

        request.getRequestDispatcher("/view/inventory-check/inventory-check-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String warehouseIdParam = request.getParameter("warehouseId");
        Integer warehouseId = null;
        if (warehouseIdParam != null && !warehouseIdParam.isEmpty()) {
            warehouseId = Integer.parseInt(warehouseIdParam);
        }

        request.setAttribute("warehouses", warehouseDAO.findAll());

        if (warehouseId != null) {
            request.setAttribute("selectedWarehouse", warehouseId);

            List<Inventory> listSerials = inventoryDAO.findInStockByWarehouse(warehouseId);

            Map<Integer, List<Inventory>> groupedByGenerator = new HashMap<>();
            for (Inventory serial : listSerials) {
                int generatorId = serial.getGeneratorId();
                List<Inventory> serialList = groupedByGenerator.get(generatorId);
                if (serialList == null) {
                    serialList = new ArrayList<>();
                    groupedByGenerator.put(generatorId, serialList);
                }
                serialList.add(serial);
            }

            List<Inventory> inventoryList = new ArrayList<>();
            Map<Integer, Integer> generatorCountMap = new HashMap<>();

            for (Map.Entry<Integer, List<Inventory>> entry : groupedByGenerator.entrySet()) {
                int generatorId = entry.getKey();
                List<Inventory> serialsOfThisGenerator = entry.getValue();

                inventoryList.add(serialsOfThisGenerator.get(0));
                generatorCountMap.put(generatorId, serialsOfThisGenerator.size());
            }

            request.setAttribute("inventoryList", inventoryList);
            request.setAttribute("generatorCountMap", generatorCountMap);
        }

        request.getRequestDispatcher("/view/inventory-check/inventory-check-create.jsp").forward(request, response);
    }
    
    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        int id = Integer.parseInt(idStr);
        InventoryCheck check = checkDAO.findById(id);
        if (check == null) {
            request.setAttribute("error", "Không tìm thấy phiếu kiểm kê");
            request.getRequestDispatcher("/view/inventory-check/inventory-check-detail.jsp").forward(request, response);
            return;
        }
        List<InventoryCheckDetail> details = checkDAO.findDetailsByCheckId(id);
        List<ActivityLog> logs = activityLogDAO.findByEntityTypeAndId("inventory_check", id, 1, 100);
        int totalLogs = activityLogDAO.countByEntityTypeAndId("inventory_check", id);

        List<InventoryCheckSerial> serials = checkDAO.findSerialsByCheckId(id);
        Map<Integer, List<InventoryCheckSerial>> serialsByDetail = new HashMap<>();
        for (InventoryCheckSerial s : serials) {
            Integer detailId = s.getCheckDetailId();
            List<InventoryCheckSerial> list = serialsByDetail.get(detailId);
            if (list == null) {
                list = new ArrayList<>();
                serialsByDetail.put(detailId, list);
            }
            list.add(s);
        }

        request.setAttribute("check", check);
        request.setAttribute("details", details);
        request.setAttribute("logs", logs);
        request.setAttribute("totalLogs", totalLogs);
        request.setAttribute("serialsByDetail", serialsByDetail);
        request.setAttribute("today", LocalDate.now().toString());

        request.getRequestDispatcher("/view/inventory-check/inventory-check-detail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        int id = Integer.parseInt(idStr);
        InventoryCheck check = checkDAO.findById(id);
        if (check == null) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        if (!"doing".equals(check.getStatus())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        List<InventoryCheckDetail> details = checkDAO.findDetailsByCheckId(id);
        List<InventoryCheckSerial> serials = checkDAO.findSerialsByCheckId(id);
        Map<Integer, List<InventoryCheckSerial>> serialsByDetail = new HashMap<>();
        for (InventoryCheckSerial s : serials) {
            serialsByDetail.computeIfAbsent(s.getCheckDetailId(), k -> new ArrayList<>()).add(s);
        }

        request.setAttribute("check", check);
        request.setAttribute("details", details);
        request.setAttribute("serialsByDetail", serialsByDetail);
        request.setAttribute("warehouses", warehouseDAO.findAll());

        request.getRequestDispatcher("/view/inventory-check/inventory-check-edit.jsp").forward(request, response);
    }

    private void saveCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        String whParam = request.getParameter("warehouseId");
        String notes = request.getParameter("notes");
        String[] genIds = request.getParameterValues("generatorId");

        List<String> errors = new ArrayList<>();

        int warehouseId = 0;
        try {
            warehouseId = Integer.parseInt(whParam);
            if (warehouseId <= 0) errors.add("Vui lòng chọn kho");
        } catch (NumberFormatException e) {
            errors.add("Kho không hợp lệ");
        }

        List<InventoryCheckDetail> details = new ArrayList<>();
        if (genIds != null) {
            for (String gidStr : genIds) {
                int genId = Integer.parseInt(gidStr);
                int sysQty = inventoryDAO.findInStockByWarehouseAndGenerator(warehouseId, genId).size();
                InventoryCheckDetail d = new InventoryCheckDetail();
                d.setGeneratorId(genId);
                d.setSystemQuantity(sysQty);
                details.add(d);
            }
        }

        if (details.isEmpty()) {
            errors.add("Phải chọn ít nhất 1 máy để kiểm kê");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Tạo phiếu thất bại: " + String.join(", ", errors));
            showCreateForm(request, response);
            return;
        }

        InventoryCheck check = new InventoryCheck();
        check.setCheckCode(checkDAO.generateCheckCode());
        check.setWarehouseId(warehouseId);
        check.setNotes(notes);
        check.setCreatedBy(loggedUser.getId());

        int checkId = checkDAO.insert(check);
        if (checkId <= 0) {
            request.setAttribute("toastMessage", "Không thể tạo phiếu kiểm kê");
            request.setAttribute("toastType", "danger");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.getRequestDispatcher("/view/inventory-check/inventory-check-create.jsp").forward(request, response);
            return;
        }

        checkDAO.insertDetailsBatch(checkId, details);

        List<InventoryCheckDetail> savedDetails = checkDAO.findDetailsByCheckId(checkId);
        for (InventoryCheckDetail detail : savedDetails) {
            List<Inventory> serials = inventoryDAO.findInStockByWarehouseAndGenerator(warehouseId, detail.getGeneratorId());
            List<InventoryCheckSerial> serialList = new ArrayList<>();
            for (Inventory inv : serials) {
                InventoryCheckSerial ics = new InventoryCheckSerial();
                ics.setCheckDetailId(detail.getId());
                ics.setSerialNumber(inv.getSerialNumber());
                serialList.add(ics);
            }
            checkDAO.insertSerialsBatch(detail.getId(), serialList);
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("inventory_check");
        log.setAction("CREATE");
        log.setEntityId(checkId);
        log.setEntityName(check.getCheckCode());
        log.setDetails("Tạo phiếu kiểm kê tại kho " + warehouseDAO.findById(warehouseId).getName());
        activityLogDAO.insert(log);

        session.setAttribute("toastMessage", "Tạo phiếu kiểm kê thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
    }

    private void updateCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        int checkId = Integer.parseInt(request.getParameter("checkId"));
        InventoryCheck existing = checkDAO.findById(checkId);
        if (existing == null || !"doing".equals(existing.getStatus())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String[] detailIds = request.getParameterValues("detailId");
        String[] actualQtys = request.getParameterValues("actualQuantity");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<InventoryCheckDetail> details = new ArrayList<>();
        if (detailIds != null) {
            for (int i = 0; i < detailIds.length; i++) {
                InventoryCheckDetail d = new InventoryCheckDetail();
                d.setId(Integer.parseInt(detailIds[i]));
                if (actualQtys != null && i < actualQtys.length && actualQtys[i] != null && !actualQtys[i].trim().isEmpty()) {
                    d.setActualQuantity(Integer.parseInt(actualQtys[i]));
                }
                if (detailNotes != null && i < detailNotes.length) {
                    d.setNotes(detailNotes[i]);
                }
                details.add(d);
            }
        }

        String notes = request.getParameter("notes");
        if (notes != null) {
            existing.setNotes(notes);
            checkDAO.update(existing);
        }

        checkDAO.updateDetailsBatch(checkId, details);

        String[] serialIds = request.getParameterValues("serialId");
        if (serialIds != null) {
            List<InventoryCheckSerial> serials = new ArrayList<>();
            for (String sidStr : serialIds) {
                int sid = Integer.parseInt(sidStr);
                InventoryCheckSerial s = new InventoryCheckSerial();
                s.setId(sid);
                s.setStatus(request.getParameter("serialStatus_" + sid));
                s.setNotes(request.getParameter("serialNote_" + sid));
                serials.add(s);
            }
            boolean serialsOk = checkDAO.updateSerialsBatch(serials);
            if (!serialsOk) {
                session.setAttribute("error", "Có lỗi khi lưu tình trạng serial, vui lòng thử lại");
                response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
                return;
            }
        }

        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setEntityType("inventory_check");
        log.setAction("UPDATE");
        log.setEntityId(checkId);
        log.setEntityName(existing.getCheckCode());
        log.setDetails("Cập nhật số lượng kiểm kê");
        activityLogDAO.insert(log);

        session.setAttribute("toastMessage", "Cập nhật phiếu kiểm kê thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
    }

    private void completeCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");
        int checkId = Integer.parseInt(request.getParameter("id"));

        InventoryCheck existing = checkDAO.findById(checkId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        List<InventoryCheckDetail> details = checkDAO.findDetailsByCheckId(checkId);
        boolean missingQuantity = false;
        for (InventoryCheckDetail d : details) {
            if (d.getActualQuantity() == null) {
                missingQuantity = true;
                break;
            }
        }
        if (missingQuantity) {
            session.setAttribute("error",
                    "Không thể hoàn thành: phiếu còn máy chưa nhập số lượng thực tế");
            response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
            return;
        }

        int nullStatusCount = checkDAO.countNullStatusByCheckId(checkId);
        if (nullStatusCount < 0) {
            session.setAttribute("error",
                    "Không thể hoàn thành: lỗi khi kiểm tra trạng thái serial, vui lòng thử lại");
            response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
            return;
        }
        if (nullStatusCount > 0) {
            session.setAttribute("error",
                    "Không thể hoàn thành: còn " + nullStatusCount + " serial chưa được đánh giá tình trạng (Tốt/Kém/Hỏng)");
            response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
            return;
        }

        boolean ok = checkDAO.complete(checkId);
        if (ok) {
            for (InventoryCheckSerial s : checkDAO.findSerialsByCheckId(checkId)) {
                if (s.getStatus() != null && !s.getStatus().isEmpty()) {
                    boolean updated = inventoryDAO.updateConditionBySerial(s.getSerialNumber(), s.getStatus());
                    if (!updated) {
                        System.out.println("WARNING: Không cập nhật được condition cho serial " + s.getSerialNumber() + " (kiểm kê #" + checkId + ")");
                    }
                }
            }

            ActivityLog log = new ActivityLog();
            log.setUserId(loggedUser.getId());
            log.setEntityType("inventory_check");
            log.setAction("COMPLETE");
            log.setEntityId(checkId);
            log.setEntityName(existing.getCheckCode());
            log.setDetails("Hoàn thành kiểm kê");
            activityLogDAO.insert(log);

            for (InventoryCheckDetail d : details) {
                int diff = d.getSystemQuantity() - (d.getActualQuantity() != null ? d.getActualQuantity() : 0);
                if (diff != 0) {
                    String title = "Chênh lệch kiểm kê - " + existing.getCheckCode();
                    String message = "Phiếu kiểm kê " + existing.getCheckCode()
                            + " tại " + existing.getWarehouseName()
                            + " phát hiện chênh lệch máy " + d.getGeneratorModel()
                            + " (" + (diff > 0 ? "thiếu " + diff : "thừa " + (-diff)) + ")."
                            + " Vui lòng kiểm tra và tạo phiếu nhập/xuất bù.";
                    String link = "/inventory-check?action=detail&id=" + checkId;
                    NotificationService.sendToRole("warehouse_staff", title, message, link,
                            "inventory_check", checkId);
                }
            }

            session.setAttribute("toastMessage", "Hoàn thành kiểm kê");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể hoàn thành phiếu kiểm kê");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
    }

    private void exportReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String detailIdStr = request.getParameter("detailId");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        if (detailIdStr == null || detailIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        int detailId = Integer.parseInt(detailIdStr);

        InventoryCheckDetail detail = null;
        List<InventoryCheckDetail> allDetails = checkDAO.findDetailsByCheckId(
                Integer.parseInt(request.getParameter("checkId")));
        for (InventoryCheckDetail d : allDetails) {
            if (d.getId() == detailId) {
                detail = d;
                break;
            }
        }

        if (detail == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        List<StockCard> stockCards = stockCardDAO.findByWarehouseAndGenerator(
                Integer.parseInt(request.getParameter("warehouseId")),
                detail.getGeneratorId());

        LocalDate fromDate = (fromDateStr != null && !fromDateStr.isEmpty())
                ? LocalDate.parse(fromDateStr) : null;
        LocalDate toDate = (toDateStr != null && !toDateStr.isEmpty())
                ? LocalDate.parse(toDateStr) : null;
        LocalDate today = LocalDate.now();

        if ((fromDate != null && fromDate.isAfter(today))
                || (toDate != null && toDate.isAfter(today))
                || (fromDate != null && toDate != null && fromDate.isAfter(toDate))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ngày không hợp lệ");
            return;
        }

        XSSFWorkbook workbook = InventoryCheckExcelSupport.exportReport(
                detail.getGeneratorModel(),
                request.getParameter("warehouseName"),
                fromDate, toDate, stockCards);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename=BaoCaoKiemKe_" + detail.getGeneratorModel() + ".xlsx");
        try (OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        }
        workbook.close();
    }
}
