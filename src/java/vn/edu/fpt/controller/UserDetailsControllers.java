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
import vn.edu.fpt.model.Role;
import vn.edu.fpt.util.PasswordHash;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="UserDetailsControllers", urlPatterns={"/admin/users/edit"})
public class UserDetailsControllers extends HttpServlet {
   
    private final UserDAO userDAO = new UserDAO();
    
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
        
        // Get user ID from request parameter
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Invalid user ID.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Get user details
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.setAttribute("error", "User not found.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Get all roles
            List<Role> roles = userDAO.getAllRoles();
            
            // Get user's current roles
            List<Integer> userRoleIds = userDAO.getUserRoleIds(userId);
            
            // Add attributes to request
            request.setAttribute("userDetails", user);
            request.setAttribute("roles", roles);
            request.setAttribute("userRoleIds", userRoleIds);
            
            // Forward to details page
            request.getRequestDispatcher("/admin/userDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid user ID format.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            session.setAttribute("error", "Error retrieving user details: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
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
        
        // Get form parameters
        String userIdStr = request.getParameter("userId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String[] roleIds = request.getParameterValues("roleIds");
        String dobStr = request.getParameter("dateOfBirth");
        String password = request.getParameter("password"); // Optional for update
        String statusId = request.getParameter("statusId");
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Get existing user to check for changes
            User existingUser = userDAO.getUserById(userId);
            if (existingUser == null) {
                session.setAttribute("error", "User not found.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Validate required fields
            if (firstName == null || lastName == null || email == null || username == null ||
                roleIds == null || roleIds.length == 0 || phone == null || dobStr == null ||
                firstName.trim().isEmpty() || lastName.trim().isEmpty() || username.trim().isEmpty() ||
                email.trim().isEmpty() || phone.trim().isEmpty() || dobStr.trim().isEmpty()) {
                
                session.setAttribute("error", "Please fill in all required fields.");
                response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userId);
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
                response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userId);
                return;
            }
            
            // Check if email already exists (skip check if unchanged)
            if (!email.equals(existingUser.getEmail_address()) && userDAO.isEmailExists(email)) {
                session.setAttribute("error", "Email address already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userId);
                return;
            }
            
            // Check if username already exists (skip check if unchanged)
            if (!username.equals(existingUser.getUsername()) && userDAO.isUsernameExists(username)) {
                session.setAttribute("error", "Username already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userId);
                return;
            }
            
            // Check if phone already exists (skip check if unchanged)
            if (!phone.equals(existingUser.getPhone_number()) && userDAO.isPhoneExists(phone)) {
                session.setAttribute("error", "Phone number already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userId);
                return;
            }
            
            // Prepare updated user object
            User updatedUser = new User();
            updatedUser.setId(userId);
            updatedUser.setUsername(username);
            updatedUser.setFirst_name(firstName);
            updatedUser.setLast_name(lastName);
            updatedUser.setDate_of_birth(dob);
            updatedUser.setPhone_number(phone);
            updatedUser.setEmail_address(email);
            updatedUser.setAddress(address);
            updatedUser.setStatus_id(Integer.parseInt(statusId));
            
            // Handle password update if provided
            if (password != null && !password.trim().isEmpty()) {
                // Validate password length
                if (password.length() < 6) {
                    session.setAttribute("error", "Password must be at least 6 characters long.");
                    response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userId);
                    return;
                }
                
                // Generate new password hash and salt
                String[] hashAndSalt = PasswordHash.generatePasswordHash(password);
                updatedUser.setPassword_hash(hashAndSalt[0]);
                updatedUser.setPassword_salt(hashAndSalt[1]);
            } else {
                // Keep existing password
                updatedUser.setPassword_hash(existingUser.getPassword_hash());
                updatedUser.setPassword_salt(existingUser.getPassword_salt());
            }
            
            // Update user
            boolean updateSuccess = userDAO.updateUser(updatedUser);
            
            if (updateSuccess) {
                // Update user roles
                userDAO.clearUserRoles(userId);
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
                    session.setAttribute("message", "User updated successfully.");
                } else {
                    session.setAttribute("message", "User updated successfully, but there was an issue updating some roles.");
                }
            } else {
                session.setAttribute("error", "Failed to update user. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userIdStr);
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + userIdStr);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "User Details Controller";
    }
}
