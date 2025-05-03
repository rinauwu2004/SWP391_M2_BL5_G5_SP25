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
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import vn.edu.fpt.dao.CountryDao;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.Country;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class AdminProfileServlet extends HttpServlet {

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
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get countries for dropdown
        CountryDao countryDao = new CountryDao();
        List<Country> countries = countryDao.getAllCountries();
        request.setAttribute("countries", countries);

        // Create form data map for preserving values if there's an error
        if (request.getAttribute("formData") == null) {
            Map<String, String> formData = new HashMap<>();
            formData.put("firstName", user.getFirstName());
            formData.put("lastName", user.getLastName());
            formData.put("email", user.getEmailAddress());

            // Format date of birth
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            formData.put("dob", sdf.format(user.getDob()));

            formData.put("phone", user.getPhoneNumber() != null ? user.getPhoneNumber() : "");
            formData.put("address", user.getAddress() != null ? user.getAddress() : "");
            formData.put("countryId", String.valueOf(user.getCountry().getId()));

            request.setAttribute("formData", formData);
        }

        // Forward to the profile JSP
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
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
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String dobParam = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String countryIdParam = request.getParameter("countryId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Create a map to store form data for redisplay in case of validation errors
        Map<String, String> formData = new HashMap<>();
        formData.put("firstName", firstName);
        formData.put("lastName", lastName);
        formData.put("email", user.getEmailAddress());
        formData.put("dob", dobParam);
        formData.put("phone", phone);
        formData.put("address", address);
        formData.put("countryId", countryIdParam);

        // Set form data for redisplay
        request.setAttribute("formData", formData);

        // Validate form data
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            dobParam == null || dobParam.trim().isEmpty() ||
            countryIdParam == null || countryIdParam.trim().isEmpty()) {

            // Invalid form data, show profile form again with error message
            request.setAttribute("error", "All fields marked with * are required.");
            doGet(request, response);
            return;
        }

        // Parse country ID
        int countryId;
        try {
            countryId = Integer.parseInt(countryIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid country selected.");
            doGet(request, response);
            return;
        }

        // Parse date of birth
        Date dob;
        try {
            dob = Date.valueOf(dobParam);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
            doGet(request, response);
            return;
        }

        // Check if phone is already taken by another user
        UserDao userDao = new UserDao();
        if (phone != null && !phone.trim().isEmpty() &&
            !phone.equals(user.getPhoneNumber()) && userDao.isPhoneTaken(phone)) {
            request.setAttribute("error", "Phone number is already taken.");
            doGet(request, response);
            return;
        }

       
        // Get country object
        CountryDao countryDao = new CountryDao();
        Country country = countryDao.get(countryId);

        // Update user object
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setDob(dob);
        user.setPhoneNumber(phone);
        user.setAddress(address);
        user.setCountry(country);

        // Update user in database
       
            userDao.updateUser(user);
        

        // Update session user
        session.setAttribute("user", user);

        // Redirect to profile with success message
        request.getSession().setAttribute("message", "Profile updated successfully.");
        response.sendRedirect(request.getContextPath() + "/admin/profile");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Profile Servlet - Manages admin profile";
    }
}
