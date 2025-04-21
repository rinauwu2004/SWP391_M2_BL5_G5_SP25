package vn.edu.fpt.controller.auth;

import vn.edu.fpt.dao.AuthDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "LoginControllers", urlPatterns = {"/login"})
public class LoginControllers extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            // Redirect to appropriate dashboard based on role
            redirectBasedOnRole(response, (User) session.getAttribute("user"));
        } else {
            // Display login page
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if it's a role selection
        String userId = request.getParameter("userId");
        String roleId = request.getParameter("roleId");
        
        if (userId != null && roleId != null) {
            // User is selecting a role after login
            handleRoleSelection(request, response, Integer.parseInt(userId), Integer.parseInt(roleId));
            return;
        }
        
        // Normal login process
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");
        
        // Authenticate user
        AuthDAO authDAO = new AuthDAO();
        User user = authDAO.checkLogin(usernameOrEmail, password);
        
        if (user != null) {
            // Check user status
            if ("Inactive".equals(user.getStatus_name())) {
                request.setAttribute("error", "Your account has been locked by an administrator.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            } else if ("Suspend".equals(user.getStatus_name())) {
                request.setAttribute("error", "Your account has been suspended. Please contact an administrator.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Get user roles
            List<User> userRoles = authDAO.getUserRoles(user.getId());
            
            if (userRoles.isEmpty()) {
                // No roles assigned
                request.setAttribute("error", "Your account has no assigned roles. Please contact an administrator.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            } else if (userRoles.size() == 1) {
                // Only one role, set user with role and redirect
                User userWithRole = authDAO.getUserWithRole(user.getId(), userRoles.get(0).getRole_id());
                HttpSession session = request.getSession();
                session.setAttribute("user", userWithRole);
                redirectBasedOnRole(response, userWithRole);
            } else {
                // Multiple roles, redirect to role selection page
                request.setAttribute("userRoles", userRoles);
                request.setAttribute("userId", user.getId());
                request.getRequestDispatcher("role-select.jsp").forward(request, response);
            }
        } else {
            // Login failed
            request.setAttribute("error", "Invalid username/email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private void handleRoleSelection(HttpServletRequest request, HttpServletResponse response, int userId, int roleId) 
            throws ServletException, IOException {
        AuthDAO authDAO = new AuthDAO();
        User userWithRole = authDAO.getUserWithRole(userId, roleId);
        
        if (userWithRole != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", userWithRole);
            redirectBasedOnRole(response, userWithRole);
        } else {
            // Error retrieving user with role
            request.setAttribute("error", "Error selecting role. Please try logging in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private void redirectBasedOnRole(HttpServletResponse response, User user) throws IOException {
        switch (user.getRole_name()) {
            case "Admin":
                response.sendRedirect("admin/dashboard.jsp");
                break;
            case "Subject Manager":
                response.sendRedirect("subject-manager/dashboard.jsp");
                break;
            case "Teacher":
                response.sendRedirect("teacher/dashboard.jsp");
                break;
            case "Student":
                response.sendRedirect("student/dashboard.jsp");
                break;
            default:
                response.sendRedirect("login");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Login controller for the Online Quiz System";
    }
}
