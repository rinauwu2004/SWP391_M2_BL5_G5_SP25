/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import vn.edu.fpt.dao.CountryDao;
import vn.edu.fpt.dao.RoleDao;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.dao.UserStatusDao;
import vn.edu.fpt.model.Country;
import vn.edu.fpt.model.Role;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.UserStatus;

/**
 *
 * @author ADMIN
 */
public class AdminUserManagementServlet extends HttpServlet {

    private static final int USERS_PER_PAGE = 10;

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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is an admin
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is an admin
        if (!"System Admin".equals(user.getRole().getName())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: list users
            listUsers(request, response);
        } else {
            switch (action) {
                case "view":
                    viewUser(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                case "ban":
                    banUser(request, response);
                    break;
                case "unban":
                    unbanUser(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is an admin
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is an admin
        if (!"System Admin".equals(user.getRole().getName())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: list users
            listUsers(request, response);
        } else {
            switch (action) {
                case "update":
                    updateUser(request, response);
                    break;
                case "create":
                    createUser(request, response);
                    break;
                case "search":
                    searchUsers(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get page number from request parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page number, use default
                page = 1;
            }
        }

        // Calculate offset for pagination
        int offset = (page - 1) * USERS_PER_PAGE;

        // Get users from database (only students and teachers)
        UserDao userDao = new UserDao();
        List<User> users = userDao.getStudentAndTeacherUsers(offset, USERS_PER_PAGE);
        int totalUsers = userDao.countStudentAndTeacherUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / USERS_PER_PAGE);

        // Set attributes for the JSP
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);

        // Forward to the user management JSP
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users ");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get user from database
            UserDao userDao = new UserDao();
            User user = userDao.getUserById(userId);

            if (user == null) {
                // User not found
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Set attributes for the JSP
            request.setAttribute("user", user);

            // Forward to the view user JSP
            request.getRequestDispatcher("/admin/viewUser.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Invalid user ID format
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get user from database
            UserDao userDao = new UserDao();
            User user = userDao.getUserById(userId);

            if (user == null) {
                // User not found
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Get roles, countries, and statuses for dropdown lists
            RoleDao roleDao = new RoleDao();
            CountryDao countryDao = new CountryDao();
            UserStatusDao statusDao = new UserStatusDao();

            // Get all roles but filter to only include Student (2) and Teacher (3)
            List<Role> allRoles = roleDao.getAllRoles();
            List<Role> roles = new java.util.ArrayList<>();
            for (Role role : allRoles) {
                if (role.getId() == 2 || role.getId() == 3) {
                    roles.add(role);
                }
            }

            List<Country> countries = countryDao.getAllCountries();
            List<UserStatus> statuses = statusDao.getAllStatuses();

            // Set attributes for the JSP
            request.setAttribute("user", user);
            request.setAttribute("roles", roles);
            request.setAttribute("countries", countries);
            request.setAttribute("statuses", statuses);

            // Create form data map for preserving values if there's an error
            if (request.getAttribute("formData") == null) {
                Map<String, String> formData = new HashMap<>();
                formData.put("firstName", user.getFirstName());
                formData.put("lastName", user.getLastName());
                // Email is not editable, so no need to include it in formData

                // Format date of birth
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                formData.put("dob", sdf.format(user.getDob()));

                formData.put("phone", user.getPhoneNumber() != null ? user.getPhoneNumber() : "");
                formData.put("address", user.getAddress() != null ? user.getAddress() : "");
                formData.put("roleId", String.valueOf(user.getRole().getId()));
                formData.put("statusId", String.valueOf(user.getStatus().getId()));
                formData.put("countryId", String.valueOf(user.getCountry().getId()));

                request.setAttribute("formData", formData);
            }

            // Forward to the edit user JSP
            request.getRequestDispatcher("/admin/editUser.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Invalid user ID format
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get roles, countries, and statuses for dropdown lists
        RoleDao roleDao = new RoleDao();
        CountryDao countryDao = new CountryDao();
        UserStatusDao statusDao = new UserStatusDao();

        // Get all roles but filter to only include Student (2) and Teacher (3)
        List<Role> allRoles = roleDao.getAllRoles();
        List<Role> roles = new java.util.ArrayList<>();
        for (Role role : allRoles) {
            if (role.getId() != 1) {
                roles.add(role);
            }
        }

        List<Country> countries = countryDao.getAllCountries();
        List<UserStatus> statuses = statusDao.getAllStatuses();

        // Set attributes for the JSP
        request.setAttribute("roles", roles);
        request.setAttribute("countries", countries);
        request.setAttribute("statuses", statuses);

        // Preserve form data if available (for validation errors)
        if (request.getAttribute("formData") != null) {
            request.setAttribute("formData", request.getAttribute("formData"));
        }

        // Forward to the create user JSP
        request.getRequestDispatcher("/admin/createUser.jsp").forward(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get user from database
            UserDao userDao = new UserDao();
            User user = userDao.getUserById(userId);

            if (user == null) {
                // User not found
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Get form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            // Email is not editable, use the existing one
            String email = user.getEmailAddress();
            String dobParam = request.getParameter("dob");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String roleIdParam = request.getParameter("roleId");
            String statusIdParam = request.getParameter("statusId");
            String countryIdParam = request.getParameter("countryId");

            // Create a map to store form data for redisplay in case of validation errors
            Map<String, String> formData = new HashMap<>();
            formData.put("firstName", firstName);
            formData.put("lastName", lastName);
            formData.put("dob", dobParam);
            formData.put("phone", phone);
            formData.put("address", address);
            formData.put("roleId", roleIdParam);
            formData.put("statusId", statusIdParam);
            formData.put("countryId", countryIdParam);

            // Set form data for redisplay
            request.setAttribute("formData", formData);

            // Validate form data
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                dobParam == null || dobParam.trim().isEmpty() ||
                roleIdParam == null || roleIdParam.trim().isEmpty() ||
                statusIdParam == null || statusIdParam.trim().isEmpty() ||
                countryIdParam == null || countryIdParam.trim().isEmpty()) {

                // Invalid form data, show edit form again with error message
                request.setAttribute("error", "All fields marked with * are required.");
                showEditForm(request, response);
                return;
            }

            // Parse IDs
            int roleId = Integer.parseInt(roleIdParam);
            int statusId = Integer.parseInt(statusIdParam);
            int countryId = Integer.parseInt(countryIdParam);

            // Validate role ID (only allow Student (2) or Teacher (3))
            if (roleId != 2 && roleId != 3) {
                request.setAttribute("error", "Invalid role selected. Only Student or Teacher roles are allowed.");
                showEditForm(request, response);
                return;
            }

            // Parse date of birth
            java.sql.Date dob;
            try {
                dob = java.sql.Date.valueOf(dobParam);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
                showEditForm(request, response);
                return;
            }

            // Calculate age
            Calendar dobCal = Calendar.getInstance();
            dobCal.setTime(dob);
            Calendar today = Calendar.getInstance();
            int age = today.get(Calendar.YEAR) - dobCal.get(Calendar.YEAR);
            if (today.get(Calendar.DAY_OF_YEAR) < dobCal.get(Calendar.DAY_OF_YEAR)) {
                age--;
            }

            // Validate age based on role
            if (roleId == 2 && age <= 10) { // Student must be > 10 years old
                request.setAttribute("error", "Students must be older than 10 years.");
                showEditForm(request, response);
                return;
            } else if (roleId == 3 && age <= 20) { // Teacher must be > 20 years old
                request.setAttribute("error", "Teachers must be older than 20 years.");
                showEditForm(request, response);
                return;
            }

            // Get role, status, and country objects
            RoleDao roleDao = new RoleDao();
            UserStatusDao statusDao = new UserStatusDao();
            CountryDao countryDao = new CountryDao();

            Role role = roleDao.get(roleId);
            UserStatus status = statusDao.get(statusId);
            Country country = countryDao.get(countryId);

            // Email is not editable, so no need to check if it's taken

            // Check if phone is already taken by another user
            if (phone != null && !phone.trim().isEmpty() &&
                !phone.equals(user.getPhoneNumber()) && userDao.isPhoneTaken(phone)) {
                request.setAttribute("error", "Phone number is already taken.");
                showEditForm(request, response);
                return;
            }

            // Update user object
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmailAddress(email);
            user.setPhoneNumber(phone);
            user.setAddress(address);
            user.setDob(dob);
            user.setRole(role);
            user.setStatus(status);
            user.setCountry(country);

            // Update user in database
            userDao.updateUser(user);

            // Redirect to user list with success message
            request.getSession().setAttribute("message", "User updated successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            // Invalid ID format
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            // Other error
            request.setAttribute("error", "Error updating user: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dobParam = request.getParameter("dob");
        String roleIdParam = request.getParameter("roleId");
        String statusIdParam = request.getParameter("statusId");
        String countryIdParam = request.getParameter("countryId");

        // Create a map to store form data for redisplay in case of validation errors
        Map<String, String> formData = new HashMap<>();
        formData.put("username", username);
        formData.put("firstName", firstName);
        formData.put("lastName", lastName);
        formData.put("email", email);
        formData.put("phone", phone);
        formData.put("address", address);
        formData.put("dob", dobParam);
        formData.put("roleId", roleIdParam);
        formData.put("statusId", statusIdParam);
        formData.put("countryId", countryIdParam);

        // Set form data for redisplay
        request.setAttribute("formData", formData);

        // Validate form data
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            dobParam == null || dobParam.trim().isEmpty() ||
            roleIdParam == null || roleIdParam.trim().isEmpty() ||
            statusIdParam == null || statusIdParam.trim().isEmpty() ||
            countryIdParam == null || countryIdParam.trim().isEmpty()) {

            // Invalid form data, show create form again with error message
            request.setAttribute("error", "All fields marked with * are required.");
            showCreateForm(request, response);
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            showCreateForm(request, response);
            return;
        }

        try {
            // Parse IDs and date
            int roleId = Integer.parseInt(roleIdParam);
            int statusId = Integer.parseInt(statusIdParam);
            int countryId = Integer.parseInt(countryIdParam);
            java.sql.Date dob = java.sql.Date.valueOf(dobParam);

            // Validate role ID (only allow Student (2) or Teacher (3))
            if (roleId == 1) {
                request.setAttribute("error", "Invalid role selected. Admin cannot created.");
                showCreateForm(request, response);
                return;
            }

            // Calculate age
            Calendar dobCal = Calendar.getInstance();
            dobCal.setTime(dob);
            Calendar today = Calendar.getInstance();
            int age = today.get(Calendar.YEAR) - dobCal.get(Calendar.YEAR);
            if (today.get(Calendar.DAY_OF_YEAR) < dobCal.get(Calendar.DAY_OF_YEAR)) {
                age--;
            }

            // Validate age based on role
            if (roleId == 2 && age <= 10) { // Student must be > 10 years old
                request.setAttribute("error", "Students must be older than 10 years.");
                showCreateForm(request, response);
                return;
            } else if (roleId == 3 && age <= 20) { // Teacher must be > 20 years old
                request.setAttribute("error", "Teachers must be older than 20 years.");
                showCreateForm(request, response);
                return;
            }

            // Get role, status, and country objects
            RoleDao roleDao = new RoleDao();
            UserStatusDao statusDao = new UserStatusDao();
            CountryDao countryDao = new CountryDao();

            Role role = roleDao.get(roleId);
            UserStatus status = statusDao.get(statusId);
            Country country = countryDao.get(countryId);

            // Check if username or email is already taken
            UserDao userDao = new UserDao();
            if (userDao.isUsernameTaken(username)) {
                request.setAttribute("error", "Username is already taken.");
                showCreateForm(request, response);
                return;
            }

            if (userDao.isEmailTaken(email)) {
                request.setAttribute("error", "Email address is already taken.");
                showCreateForm(request, response);
                return;
            }

            if (phone != null && !phone.trim().isEmpty() && userDao.isPhoneTaken(phone)) {
                request.setAttribute("error", "Phone number is already taken.");
                showCreateForm(request, response);
                return;
            }

            // Create user object
            User user = new User();
            user.setUsername(username);

            // Hash password
            String[] passwordHash = vn.edu.fpt.util.PasswordEncryption.hashPassword(password);
            user.setHashPassword(passwordHash[0]);
            user.setSaltPassword(passwordHash[1]);

            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmailAddress(email);
            user.setPhoneNumber(phone);
            user.setAddress(address);
            user.setDob(dob);
            user.setRole(role);
            user.setStatus(status);
            user.setCountry(country);

            // Create user in database
            userDao.addUser(user);

            // Redirect to user list with success message
            request.getSession().setAttribute("message", "User created successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (IllegalArgumentException e) {
            // Invalid date format
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
            showCreateForm(request, response);
        } catch (Exception e) {
            // Other error
            request.setAttribute("error", "Error creating user: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get current user from session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            // Prevent admin from deleting themselves
            if (currentUser.getId() == userId) {
                request.getSession().setAttribute("error", "You cannot delete your own account.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Delete user from database
            UserDao userDao = new UserDao();
            userDao.deleteUser(userId);

            // Redirect to user list with success message
            request.getSession().setAttribute("message", "User deleted successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            // Invalid user ID format
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void banUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get current user from session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            // Prevent admin from banning themselves
            if (currentUser.getId() == userId) {
                request.getSession().setAttribute("error", "You cannot ban your own account.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Deactivate user in database (set status to Inactive)
            UserDao userDao = new UserDao();
            userDao.updateUserStatus(userId, 2); // Status ID 2 is "Inactive"

            // Redirect to user list with success message
            request.getSession().setAttribute("message", "User deactivated successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            // Invalid user ID format
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void unbanUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user ID from request parameter
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Activate user in database
            UserDao userDao = new UserDao();
            userDao.updateUserStatus(userId, 1); // Status ID 1 is "Active"

            // Redirect to user list with success message
            request.getSession().setAttribute("message", "User activated successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            // Invalid user ID format
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get search parameters
        String searchTerm = request.getParameter("searchTerm");
        String searchBy = request.getParameter("searchBy");

        if (searchTerm == null || searchTerm.trim().isEmpty() || searchBy == null || searchBy.trim().isEmpty()) {
            // Invalid search parameters, show all users
            listUsers(request, response);
            return;
        }

        // Get page number from request parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page number, use default
                page = 1;
            }
        }

        // Calculate offset for pagination
        int offset = (page - 1) * USERS_PER_PAGE;

        // Search users in database (only students and teachers)
        UserDao userDao = new UserDao();
        List<User> users = userDao.searchStudentAndTeacherUsers(searchTerm, searchBy, offset, USERS_PER_PAGE);
        int totalUsers = userDao.countStudentAndTeacherSearchResults(searchTerm, searchBy);
        int totalPages = (int) Math.ceil((double) totalUsers / USERS_PER_PAGE);

        // Set attributes for the JSP
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("isSearch", true);

        // Forward to the user management JSP
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin User Management Servlet - Manages users in the admin panel";
    }
}
