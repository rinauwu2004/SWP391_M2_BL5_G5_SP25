///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package vn.edu.fpt.controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.security.SecureRandom;
//import java.sql.*;
//import java.util.Base64;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//import javax.crypto.SecretKeyFactory;
//import javax.crypto.spec.PBEKeySpec;
//import org.json.JSONObject;
//import vn.edu.fpt.dao.CountryDao;
//import vn.edu.fpt.dao.UserDao;
//import vn.edu.fpt.model.Country;
//import vn.edu.fpt.util.JavaMail;
//
///**
// *
// * @author Rinaaaa
// */
//public class SignupController extends HttpServlet {
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    private void sendJson(HttpServletResponse response, boolean valid, String message) throws IOException {
//        JSONObject json = new JSONObject();
//        json.put("valid", valid);
//        if (!valid) {
//            json.put("message", message);
//        }
//
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//        PrintWriter out = response.getWriter();
//        out.print(json.toString());
//        out.flush();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // Check uniqueness request (AJAX)
//        String check = request.getParameter("check");
//        String value = request.getParameter("value");
//
//        if (check != null && value != null) {
//            UserDao userDao = new UserDao();
//            boolean exists = false;
//            String message = "";
//
//            switch (check) {
//                case "username":
//                    exists = userDao.isUsernameTaken(value);
//                    message = "Username already taken.";
//                    break;
//                case "email":
//                    exists = userDao.isEmailTaken(value);
//                    message = "Email already in use.";
//                    break;
//                case "phone":
//                    exists = userDao.isPhoneTaken(value);
//                    message = "Phone number already registered.";
//                    break;
//                default:
//                    sendJson(response, false, "Invalid check type.");
//                    return;
//            }
//
//            sendJson(response, !exists, exists ? message : "");
//            return;
//        }
//
//        //
//        CountryDao countryDao = new CountryDao();
//        List<Country> countries = countryDao.list();
//        request.setAttribute("countries", countries);
//        request.getRequestDispatcher("/Signup.jsp").forward(request, response);
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        CountryDao countryDao = new CountryDao();
//
//        // Get data from form
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//        String passwordHash = "";
//        String passwordSalt = "";
//        String firstName = request.getParameter("firstName");
//        String lastName = request.getParameter("lastName");
//        Date dob = Date.valueOf(request.getParameter("birthdate"));
//        Country country = countryDao.get(request.getParameter("country"));
//        String phoneNumber = request.getParameter("phone");
//        String emailAddress = request.getParameter("email");
//        String address = request.getParameter("address");
//
//        // Password-Based Key Derivation Function 2
//        try {
//            byte[] salt = generateSalt();
//            int iterations = 10000;
//            int keyLength = 256;
//
//            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keyLength);
//
//            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
//            byte[] hash = factory.generateSecret(spec).getEncoded();
//
//            passwordSalt = Base64.getEncoder().encodeToString(salt);
//            passwordHash = Base64.getEncoder().encodeToString(hash);
//
//        } catch (Exception ex) {
//            Logger.getLogger(SignupController.class.getName()).log(Level.SEVERE, null, ex);
//        }
//
//        HttpSession session = request.getSession();
//        session.setAttribute("username", username);
//        session.setAttribute("passwordHash", passwordHash);
//        session.setAttribute("passwordSalt", passwordSalt);
//        session.setAttribute("firstName", firstName);
//        session.setAttribute("lastName", lastName);
//        session.setAttribute("dob", dob);
//        session.setAttribute("country", country);
//        session.setAttribute("phoneNumber", phoneNumber);
//        session.setAttribute("email", emailAddress);
//        session.setAttribute("address", address);
//
//        String otp = JavaMail.createOTP();
//        JavaMail.sendOTP(emailAddress, otp);
//        session.setAttribute("otp", otp);
//        int timeoutMinutes = 5;
//        session.setAttribute("timeout", timeoutMinutes);
//        long expiryTimeMillis = System.currentTimeMillis() + (timeoutMinutes * 60 * 1000);
//        session.setAttribute("otpExpiryTime", expiryTimeMillis);
//        response.sendRedirect(request.getContextPath() + "/verify");
//    }
//
//    private static byte[] generateSalt() {
//        SecureRandom random = new SecureRandom();
//        byte[] salt = new byte[16];
//        random.nextBytes(salt);
//        return salt;
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
