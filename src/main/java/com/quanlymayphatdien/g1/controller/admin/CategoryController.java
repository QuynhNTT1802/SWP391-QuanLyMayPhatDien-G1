/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.entity.Category;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CategoryController",
        urlPatterns = {"/admin/categories",
            "/admin/category/edit",
            "/admin/category/save"})
public class CategoryController extends HttpServlet {

    private final CategoryDAO cateDAO = new CategoryDAO();

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        try {
            if ("/admin/categories".equals(action)) {
                viewCategoryList(request,response);
            } else if ("/admin/category/edit".equals(action)) {
                viewCategoryEdit(request,response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        try {
            if ("/admin/category/save".equals(action)) {
               saveCategory(request,response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void viewCategoryList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String filterType = request.getParameter("filterType");

        List<Category> list;

        if (search != null && !search.trim().isEmpty()) {
            list = cateDAO.searchByName(search.trim());
        } else {
            list = cateDAO.findAll();
        }

        List<String> types = cateDAO.getDistrictTypes();
        request.setAttribute("categoryList", list);
        request.setAttribute("types", types);
        request.getRequestDispatcher("/view/admin/admin-category.jsp").forward(request, response);
    }

    private void viewCategoryEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id_var = request.getParameter("id");
        if (id_var != null && !id_var.isEmpty()) {
            try {
                int id = Integer.parseInt(id_var);
                for (Category c : cateDAO.findAll()) {
                    if (c.getId() == id) {
                        request.setAttribute("category", c);
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<String> types = cateDAO.getDistrictTypes();
        request.setAttribute("types", types);
        request.getRequestDispatcher("/view/admin/admin-category-edit.jsp").forward(request, response);
    }

    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id_var = request.getParameter("id");
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String desc = request.getParameter("description");
        String status = request.getParameter("status");

        List<String> errors = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errors.add("Tên danh mục không được để trống");
        } else {
            name = name.trim();
            if (name.length() > 100) {
                errors.add("Tên danh mục không được vượt quá 100 ký tự");
            }
        }

        if (type == null || type.trim().isEmpty()) {
            errors.add("Loại danh mục không được để trống");
        }

        if (desc != null && desc.length() > 500) {
            errors.add("Mô tả không được vượt quá 500 ký tự");
        }

        if (status == null) {
            status = "active";
        } else if (!"active".equals(status) && !"inactive".equals(status)) {
            errors.add("Trạng thái không hợp lệ");
        }
        
        if(!errors.isEmpty()) {
            Category c = new Category();
            c.setName(name);
            c.setType(type);
            c.setDescription(desc);
            c.setStatus(status);
            if(id_var != null && !id_var.isEmpty()) {
                c.setId(Integer.parseInt(id_var));
            }
            request.setAttribute("category", c);
            request.setAttribute("errors", errors);
            request.setAttribute("types", cateDAO.getDistrictTypes());
            request.getRequestDispatcher("/view/admin/admin-category-edit.jsp").forward(request, response);
            return;
        }
        
        Category category = new Category();
        category.setName(name);
        category.setType(type);
        category.setDescription(desc);
        category.setStatus(status);
        
        if(id_var != null && ! id_var.isEmpty()){
            category.setId(Integer.parseInt(id_var));
            cateDAO.update(category);
        } else {
            cateDAO.insert(category);
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories?msg=success");
    }
}
