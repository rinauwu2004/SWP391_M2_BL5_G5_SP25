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
import vn.edu.fpt.model.User;
import vn.edu.fpt.util.PasswordHash;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="AddUsersControllers", urlPatterns={"/addusers"})
public class AddAccountControllers extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet request
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/users");
    } 

    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet request
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet request
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
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String[] roleIds = request.getParameterValues("roleIds");
        String dobStr = request.getParameter("dateOfBirth");
        String password = request.getParameter("password"); // New parameter for password
        
        try {
            // Validate required fields
            if (firstName == null || lastName == null || email == null || username == null ||
                roleIds == null || roleIds.length == 0 || phone == null || dobStr == null || password == null ||
                firstName.trim().isEmpty() || lastName.trim().isEmpty() || username.trim().isEmpty() ||
                email.trim().isEmpty() || phone.trim().isEmpty() || dobStr.trim().isEmpty() || password.trim().isEmpty()) {
                
                session.setAttribute("error", "Please fill in all required fields.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Validate password length
            if (password.length() < 6) {
                session.setAttribute("error", "Password must be at least 6 characters long.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Parse date of birth from string
            java.sql.Date dob = java.sql.Date.valueOf(dobStr);
            
            // Check if user is at least 18 years old
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.YEAR, -18); // Subtract 18 years from current date
            java.util.Date eighteenYearsAgo = cal.getTime();
            
            if (dob.after(eighteenYearsAgo)) {
                session.setAttribute("error", "User must be at least 18 years old.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Check if email already exists
            if (userDAO.isEmailExists(email)) {
                session.setAttribute("error", "Email address already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Check if username already exists
            if (userDAO.isUsernameExists(username)) {
                session.setAttribute("error", "Username already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Check if phone already exists
            if (userDAO.isPhoneExists(phone)) {
                session.setAttribute("error", "Phone number already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Generate password hash and salt
            String[] hashAndSalt = PasswordHash.generatePasswordHash(password);
            String passwordHash = hashAndSalt[0];
            String passwordSalt = hashAndSalt[1];
            
            // Set status_id to 1 (Active) and current time for created_at
            int statusId = 1; // Default to Active status
            java.sql.Timestamp createdAt = new java.sql.Timestamp(System.currentTimeMillis());
            
            // Create the user
            int userId = userDAO.createUser(username, passwordHash, passwordSalt, firstName, lastName, 
                            dob, phone, email, address, statusId, createdAt);
            
            if (userId > 0) {
                // Assign selected roles to the user
                boolean rolesAssigned = true;
                for (String roleIdStr : roleIds) {
                    int roleId = Integer.parseInt(roleIdStr);
                    // Skip Admin role (role_id = 1)
                    if (roleId == 1) {
                        continue;
                    }
                    boolean success = userDAO.assignRoleToUser(userId, roleId);
                    if (!success) {
                        rolesAssigned = false;
                    }
                }
                
                if (rolesAssigned) {
                    session.setAttribute("message", "Account created successfully.");
                } else {
                    session.setAttribute("message", 
                        "Account created successfully, but there was an issue assigning some roles.");
                }
            } else {
                session.setAttribute("error", "Failed to create account. Please try again.");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Add Account Controller";
    }
}
