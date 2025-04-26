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
import java.sql.*;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.dao.CountryDao;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.Country;
import vn.edu.fpt.util.JavaMail;
import static vn.edu.fpt.util.PasswordEncryption.encodePassword;
import static vn.edu.fpt.util.PasswordEncryption.generateSalt;
import static vn.edu.fpt.util.PasswordEncryption.passwordEncyption;
import static vn.edu.fpt.util.Json.sendJson;

/**
 *
 * @author Rinaaaa
 */
public class SignupController extends HttpServlet {

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
        String check = request.getParameter("check");
        String value = request.getParameter("value");

        if (check != null && value != null) {
            UserDao userDao = new UserDao();
            boolean exists;
            String message;

            switch (check) {
                case "username" -> {
                    exists = userDao.isUsernameTaken(value);
                    message = "Username already taken.";
                }
                case "email" -> {
                    exists = userDao.isEmailTaken(value);
                    message = "Email already in use.";
                }
                case "phone" -> {
                    exists = userDao.isPhoneTaken(value);
                    message = "Phone number already registered.";
                }
                default -> {
                    sendJson(response, false, "Invalid check type.");
                    return;
                }
            }

            sendJson(response, !exists, exists ? message : "");
            return;
        }

        //
        CountryDao countryDao = new CountryDao();
        List<Country> countries = countryDao.list();
        request.setAttribute("countries", countries);
        request.getRequestDispatcher("/Signup.jsp").forward(request, response);
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
        Long lockTime = (Long) session.getAttribute("lockTime");
        long currentTime = System.currentTimeMillis();

        if (lockTime != null && (currentTime - lockTime) < 15 * 60 * 1000) {
            session.setAttribute("error", "Unable to verify your account.");
            response.sendRedirect(request.getContextPath() + "/signup");
            return;
        }

        CountryDao countryDao = new CountryDao();

        // Get data from form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String passwordHash = "";
        String passwordSalt;
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        Date dob = Date.valueOf(request.getParameter("birthdate"));
        Country country = countryDao.get(request.getParameter("country"));
        String phoneNumber = request.getParameter("phone");
        String emailAddress = request.getParameter("email");
        String address = request.getParameter("address");

        // Password-Based Key Derivation Function 2
        byte[] salt = generateSalt();
        passwordSalt = encodePassword(salt);
        try {
            passwordHash = passwordEncyption(password, salt);
        } catch (Exception ex) {
            Logger.getLogger(SignupController.class.getName()).log(Level.SEVERE, null, ex);
        }

        session.setAttribute("username", username);
        session.setAttribute("passwordHash", passwordHash);
        session.setAttribute("passwordSalt", passwordSalt);
        session.setAttribute("firstName", firstName);
        session.setAttribute("lastName", lastName);
        session.setAttribute("dob", dob);
        session.setAttribute("country", country);
        session.setAttribute("phoneNumber", phoneNumber);
        session.setAttribute("email", emailAddress);
        session.setAttribute("address", address);
        
        String otpPurpose = "signin";
        session.setAttribute("otpPurpose", otpPurpose);

        String otp = JavaMail.createOTP();
        JavaMail.sendOTP(emailAddress, otp);
        session.setAttribute("otp", otp);
        int timeoutMinutes = 5;
        session.setAttribute("timeout", timeoutMinutes);
        long expiryTimeMillis = System.currentTimeMillis() + (timeoutMinutes * 60 * 1000);
        session.setAttribute("otpExpiryTime", expiryTimeMillis);
        response.sendRedirect(request.getContextPath() + "/verify");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
