/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.User;
import java.sql.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.dao.CountryDao;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.Country;
import static vn.edu.fpt.util.Json.sendJson;
import static vn.edu.fpt.util.PasswordEncryption.encodePassword;
import static vn.edu.fpt.util.PasswordEncryption.generateSalt;
import static vn.edu.fpt.util.PasswordEncryption.passwordEncyption;

/**
 *
 * @author Rinaaaa
 */
public class CompleteProfileController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CompleteProfileController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CompleteProfileController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        request.getRequestDispatcher("/CompleteProfile.jsp").forward(request, response);
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
        CountryDao countryDao = new CountryDao();
        HttpSession session = request.getSession();
        User tempUser = (User) session.getAttribute("tempUser");

        if (tempUser == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String passwordHash = "";
        String passwordSalt;
        Date dob = Date.valueOf(request.getParameter("birthdate"));
        Country country = countryDao.get(request.getParameter("country"));
        String phoneNumber = request.getParameter("phone");
        String address = request.getParameter("address");
        
        byte[] salt = generateSalt();
        passwordSalt = encodePassword(salt);
        try {
            passwordHash = passwordEncyption(password, salt);
        } catch (Exception ex) {
            Logger.getLogger(SignupController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        tempUser.setUsername(username);
        tempUser.setHashPassword(passwordHash);
        tempUser.setSaltPassword(passwordSalt);
        tempUser.setDob(dob);
        tempUser.setCountry(country);
        tempUser.setPhoneNumber(phoneNumber);
        tempUser.setAddress(address);

        UserDao userDao = new UserDao();
        
        userDao.addUser(tempUser);

        session.removeAttribute("tempUser");

        session.setAttribute("user", tempUser);

        response.sendRedirect(request.getContextPath() + "/home");
    }
}