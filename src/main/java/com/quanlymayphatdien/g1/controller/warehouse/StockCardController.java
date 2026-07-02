package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.StockCardDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.StockCard;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StockCardController", urlPatterns = {"/stock-card"})
public class StockCardController extends HttpServlet {

    private final StockCardDAO scDAO = new StockCardDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final GeneratorDAO generatorDAO = new GeneratorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                viewByGenerator(request, response);
                break;
            default:
                listStockCards(request, response);
                break;
        }
    }

    private void listStockCards(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer warehouseId = parseIntOrNull(request.getParameter("warehouseId"));
        Integer generatorId = parseIntOrNull(request.getParameter("generatorId"));
        String typeFilter = request.getParameter("type");
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }
        int totalItems = scDAO.countWithFilters(warehouseId, generatorId, typeFilter, search, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<StockCard> list = scDAO.findWithFilters(warehouseId, generatorId, typeFilter, search, fromDate, toDate, page, pageSize);
        request.setAttribute("stockCards", list);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("generators", generatorDAO.findAll());
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("generatorId", generatorId);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", totalItems == 0 ? 0 : (page - 1) * pageSize + 1);
        request.setAttribute("toIndex", Math.min(page * pageSize, totalItems));
        request.getRequestDispatcher("/view/stock-card/stock-card-list.jsp").forward(request, response);
    }

    private void viewByGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer warehouseId = parseIntOrNull(request.getParameter("warehouseId"));
        Integer generatorId = parseIntOrNull(request.getParameter("generatorId"));
        if (warehouseId == null || generatorId == null) {
            response.sendRedirect(request.getContextPath() + "/stock-card");
            return;
        }
        String typeFilter = request.getParameter("type");
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        // Summary tinh tren toan bo lich su (khong filter) de luon phan anh ton that
        List<StockCard> allForSummary = scDAO.findByWarehouseAndGenerator(warehouseId, generatorId);
        int totalImport = 0;
        int totalExport = 0;
        int currentStock = 0;
        for (StockCard sc : allForSummary) {
            if ("IMPORT".equals(sc.getTransactionType())) {
                totalImport += sc.getQuantityChange();
            } else if ("EXPORT".equals(sc.getTransactionType())) {
                totalExport += Math.abs(sc.getQuantityChange());
            }
        }
        if (!allForSummary.isEmpty()) {
            currentStock = allForSummary.get(0).getQuantityAfter();
        }

        int totalItems = scDAO.countByWarehouseAndGenerator(warehouseId, generatorId, typeFilter, search, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<StockCard> list = scDAO.findByWarehouseAndGeneratorPaged(warehouseId, generatorId, typeFilter, search, fromDate, toDate, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("stockCards", list);
        request.setAttribute("totalImport", totalImport);
        request.setAttribute("totalExport", totalExport);
        request.setAttribute("currentStock", currentStock);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("generatorId", generatorId);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("search", search);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.getRequestDispatcher("/view/stock-card/stock-card-detail.jsp").forward(request, response);
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
