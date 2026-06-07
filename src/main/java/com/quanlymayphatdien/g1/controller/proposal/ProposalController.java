/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.proposal;

import com.quanlymayphatdien.g1.dal.ImportProposalDAO;
import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Phuong Linh
 */
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
                case "detail":
                    showDetail(request, response);
                    break;
                default:
                    listProposals(request, response);
                    break;
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý đề xuất nhập", "ProposalController.doGet", e.getMessage(), e);
            e.printStackTrace();
            session.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/proposal?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

     private void listProposals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ImportProposalDAO dao = new ImportProposalDAO();
        List<ImportProposal> proposals = dao.findAll();

        int draft     = dao.countByStatus(GlobalUtils.STATUS_DRAFT);
        int pending   = dao.countByStatus(GlobalUtils.STATUS_PENDING);
        int approved  = dao.countByStatus(GlobalUtils.STATUS_APPROVED);
        int rejected  = dao.countByStatus(GlobalUtils.STATUS_REJECTED);
        int converted = dao.countByStatus(GlobalUtils.STATUS_CONVERTED);
        int cancelled = dao.countByStatus(GlobalUtils.STATUS_CANCELLED);

        request.setAttribute("proposals", proposals);
        request.setAttribute("totalProposals", proposals.size());
        request.setAttribute("draftCount",     draft);
        request.setAttribute("pendingCount",   pending);
        request.setAttribute("approvedCount",  approved);
        request.setAttribute("rejectedCount",  rejected);
        request.setAttribute("convertedCount", converted);
        request.setAttribute("cancelledCount", cancelled);

        request.getRequestDispatcher("/view/proposal/proposal-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đợt 2: build form tạo phiếu (lấy kho duy nhất, list máy phát điện, ...)
        // Tạm thời: set message rồi về list
        request.getSession().setAttribute("message",
                "Chức năng tạo phiếu đề xuất đang được phát triển (Đợt 2).");
        response.sendRedirect(request.getContextPath() + "/proposal?action=list");
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đợt 2: load proposal theo id, forward tới detail.jsp
        // Tạm thời: thông báo + về list
        request.getSession().setAttribute("message",
                "Trang chi tiết phiếu đề xuất đang được phát triển (Đợt 2).");
        response.sendRedirect(request.getContextPath() + "/proposal?action=list");
    }

}
