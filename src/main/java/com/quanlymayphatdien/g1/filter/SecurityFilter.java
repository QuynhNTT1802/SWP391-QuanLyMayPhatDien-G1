package com.quanlymayphatdien.g1.filter;

import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/authen", "/", "/home"
    );

    private static final List<String> PUBLIC_PREFIXES = List.of(
            "/assets/", "/css/", "/js/", "/img/", "/images/", "/fonts/", "/webjars/", "/favicon"
    );

    private static final List<String> PUBLIC_VIEW_PREFIXES = List.of(
            "/view/error/", "/view/authen/"
    );

    private static final List<Rule> RULES = List.of(
            Rule.exact("/admin/dashboard", "dashboard.view"),
            Rule.exact("/admin/system-log", "system_log.view"),
            Rule.exact("/admin/forgot-password", "forgot_pw.process"),
            Rule.action("/admin/users",
                    Map.of(
                            "create", "users.create",
                            "edit", "users.update",
                            "update", "users.update",
                            "deactivate", "users.deactivate",
                            "activate", "users.deactivate"),
                    "users.view"),
            Rule.action("/admin/roles",
                    Map.of(
                            "create", "roles.create",
                            "edit", "roles.update",
                            "update", "roles.update",
                            "edit_permissions", "roles.edit_permissions"),
                    "roles.view"),
            Rule.exact("/admin/role/edit", "roles.update"),
            Rule.exact("/admin/role/save", "roles.update"),
            Rule.action("/admin/categories",
                    Map.of(
                            "create", "categories.create",
                            "update", "categories.update",
                            "delete", "categories.delete"),
                    "categories.view"),
            Rule.exact("/admin/category/edit", "categories.update"),
            Rule.exact("/admin/category/save", "categories.update"),
            Rule.exact("/admin/category/delete", "categories.delete"),
            Rule.exact("/admin/category/export", "categories.view"),
            Rule.exact("/admin/category/template", "categories.view"),
            Rule.exact("/admin/category/import-preview", "categories.create"),
            Rule.exact("/admin/category/import-confirm", "categories.create"),
            Rule.action("/warehouse/generators",
                    Map.of(
                            "create", "generators.create",
                            "update", "generators.update",
                            "edit", "generators.update",
                            "deactivate", "generators.update",
                            "activate", "generators.update"),
                    "generators.view"),
            Rule.exact("/warehouse", "warehouses.view"),
            Rule.exact("/inventory", "inventory.view"),
            Rule.exact("/inventory/list", "inventory.view"),
            Rule.exact("/inventory/report", "inventory.view"),
            Rule.exact("/stock-card", "stock_card.view"),
            Rule.exact("/stock-card/report", "stock_card.view"),
            Rule.action("/import-receipt",
                    Map.of(
                            "create", "receipts.create",
                            "edit", "receipts.create",
                            "update", "receipts.create"),
                    "receipts.view"),
            Rule.action("/export-receipt",
                    Map.of(
                            "create", "receipts.create",
                            "edit", "receipts.create",
                            "update", "receipts.create"),
                    "receipts.view"),
            Rule.exact("/receipts/report", "receipts.view"),
            Rule.action("/order",
                    Map.of(
                            "create", "orders.create",
                            "edit", "orders.update",
                            "update", "orders.update",
                            "approve", "orders.approve",
                            "reject", "orders.reject",
                            "cancel", "orders.cancel"),
                    "orders.view"),
            Rule.action("/liquidations",
                    Map.of(
                            "create", "liquidations.create",
                            "edit_submit", "liquidations.create",
                            "create_customer", "liquidations.create",
                            "approve_ceo", "liquidations.approve_ceo",
                            "reject_ceo", "liquidations.approve_ceo",
                            "request_edit_ceo", "liquidations.approve_ceo"),
                    "liquidations.view"),
            Rule.action("/inventory-check",
                    Map.of(
                            "create", "inventory_check.create",
                            "save", "inventory_check.create",
                            "edit", "inventory_check.update",
                            "update", "inventory_check.update",
                            "complete", "inventory_check.complete",
                            "exportReport", "inventory_check.view"),
                    "inventory_check.view"),
            Rule.action("/transfers",
                    Map.of(
                            "create", "transfers.create",
                            "ce_approve", "transfers.approve_ceo",
                            "ce_reject", "transfers.approve_ceo",
                            "ce_request_revision", "transfers.approve_ceo",
                            "edit_submit", "transfers.create",
                            "edit_view", "transfers.create"),
                    "transfers.view")
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String servletPath = req.getServletPath();
        if (servletPath == null) {
            chain.doFilter(req, res);
            return;
        }

        if (isStaticOrPublic(servletPath)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        if (!"active".equalsIgnoreCase(user.getStatus())) {
            res.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }

        int userId = user.getId();

        Object refreshFlag = req.getServletContext().getAttribute("perm_refresh_" + userId);
        if (refreshFlag != null) {
            PermissionDAO perDAO = new PermissionDAO();
            try {
                Set<String> freshPerms = perDAO.getEffectPermissions(userId);
                session.setAttribute("userPermissions", freshPerms);
                req.getServletContext().removeAttribute("perm_refresh_" + userId);
            } catch (SQLException e) {
                com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                        e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
            }
        }

        String action = req.getParameter("action");
        String requiredPer = resolveRequiredPerm(servletPath, action);

        if (requiredPer != null) {
            @SuppressWarnings("unchecked")
            Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
            if (permissions == null || !permissions.contains(requiredPer)) {
                req.setAttribute("requiredPerm", requiredPer);
                request.getRequestDispatcher("/view/error/403.jsp").forward(req, res);
                return;
            }
        }

        chain.doFilter(req, res);
    }

    private boolean isStaticOrPublic(String servletPath) {
        if (PUBLIC_PATHS.contains(servletPath)) {
            return true;
        }
        for (String prefix : PUBLIC_PREFIXES) {
            if (servletPath.startsWith(prefix)) {
                return true;
            }
        }
        for (String prefix : PUBLIC_VIEW_PREFIXES) {
            if (servletPath.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    private String resolveRequiredPerm(String servletPath, String action) {
        for (Rule r : RULES) {
            if (r.path.equals(servletPath)) {
                if (action != null && r.actionMap != null) {
                    String mapped = r.actionMap.get(action);
                    if (mapped != null) {
                        return mapped;
                    }
                }
                return r.defaultPerm;
            }
        }
        return null;
    }

    private static final class Rule {

        final String path;
        final Map<String, String> actionMap;
        final String defaultPerm;

        private Rule(String path, Map<String, String> actionMap, String defaultPerm) {
            this.path = path;
            this.actionMap = actionMap;
            this.defaultPerm = defaultPerm;
        }

        static Rule exact(String path, String perm) {
            return new Rule(path, null, perm);
        }

        static Rule action(String path, Map<String, String> actionMap, String defaultPerm) {
            return new Rule(path, new HashMap<>(actionMap), defaultPerm);
        }
    }
}