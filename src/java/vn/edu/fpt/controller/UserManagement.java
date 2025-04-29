/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package vn.edu.fpt.controller;

import vn.edu.fpt.dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import vn.edu.fpt.model.Role;
import vn.edu.fpt.model.User;

/**
 * Controller for handling user management operations
 * @author ADMIN
 */
@WebServlet(name="UserManagement", urlPatterns={"/admin/users"})
public class UserManagement extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final int PAGE_SIZE = 10; // Number of users per page
   
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is an admin
        if (currentUser == null || !currentUser.getRole_name().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parameters for pagination, search, and filters
        String pageStr = request.getParameter("page");
        String search = request.getParameter("search");
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Keep default page = 1
            }
        }
        
        // Get users with pagination, search, and filters
        List<User> users = userDAO.getAllUsers(page, PAGE_SIZE, search, roleFilter, statusFilter);
        int totalUsers = userDAO.getTotalUsers(search, roleFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        List<Role> roles = userDAO.getAllRoles();
        
        // Set attributes for the JSP
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("roles", roles);
        
        // Forward to the JSP
        request.getRequestDispatcher("/admin/userManagement.jsp").forward(request, response);
    } 

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is an admin
        if (currentUser == null || !currentUser.getRole_name().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action != null) {
            switch (action) {
                case "toggleStatus":
                    handleToggleStatus(request, response);
                    break;
                default:
                    // For other actions or if no action specified, redirect back to user list
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
            }
        } else {
            // Handle search and filters (from form submission)
            String search = request.getParameter("search");
            String roleFilter = request.getParameter("roleFilter");
            String statusFilter = request.getParameter("statusFilter");
            
            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin/users");
            boolean hasParam = false;
            
            if (search != null && !search.isEmpty()) {
                redirectUrl.append(hasParam ? "&" : "?").append("search=").append(search);
                hasParam = true;
            }
            
            if (roleFilter != null && !roleFilter.isEmpty()) {
                redirectUrl.append(hasParam ? "&" : "?").append("roleFilter=").append(roleFilter);
                hasParam = true;
            }
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                redirectUrl.append(hasParam ? "&" : "?").append("statusFilter=").append(statusFilter);
            }
            
            response.sendRedirect(redirectUrl.toString());
        }
    }
    
    /**
     * Handle toggling a user's status (active/inactive)
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userIdStr = request.getParameter("userId");
        String newStatus = request.getParameter("newStatus");
        String currentPage = request.getParameter("page");
        String search = request.getParameter("search");
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");
        
        if (userIdStr != null && newStatus != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                int statusId = userDAO.getStatusIdByName(newStatus);
                
                boolean success = userDAO.updateUserStatus(userId, statusId);
                
                if (success) {
                    request.getSession().setAttribute("message", "User status updated successfully.");
                } else {
                    request.getSession().setAttribute("error", "Failed to update user status.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid user ID.");
            }
        }
        
        // Redirect back to the user list with the same pagination, search, and filter parameters
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin/users");
        boolean hasParam = false;
        
        if (currentPage != null && !currentPage.isEmpty()) {
            redirectUrl.append("?page=").append(currentPage);
            hasParam = true;
        }
        
        if (search != null && !search.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("search=").append(search);
            hasParam = true;
        }
        
        if (roleFilter != null && !roleFilter.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("roleFilter=").append(roleFilter);
            hasParam = true;
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("statusFilter=").append(statusFilter);
        }
        
        response.sendRedirect(redirectUrl.toString());
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "User Management Servlet";
    }
}
