/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class SigninController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Signin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember-me");

        UserDao userDao = new UserDao();
        User user = userDao.getUserByUsername(username);
        if (user != null) {
            try {
                boolean matched = checkPassword(password, user.getHashPassword(), user.getSaltPassword());
                if (matched) {
                    request.getSession().setAttribute("user", user);

                    if ("on".equals(remember)) {
                        Cookie userCookie = new Cookie("remember_username", username);
                        userCookie.setMaxAge(7 * 24 * 60 * 60);
                        response.addCookie(userCookie);
                    }

                    response.sendRedirect(request.getContextPath() + "/index.html");
                } else {
                    request.setAttribute("error", "Invalid username or password.");
                    request.getRequestDispatcher("/Signin.jsp").forward(request, response);
                }
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/Signin.jsp").forward(request, response);
        }
    }

    public static boolean checkPassword(String inputPassword, String storedHashBase64, String storedSaltBase64) throws Exception {
        byte[] salt = Base64.getDecoder().decode(storedSaltBase64);
        byte[] storedHash = Base64.getDecoder().decode(storedHashBase64);

        PBEKeySpec spec = new PBEKeySpec(inputPassword.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] inputHash = factory.generateSecret(spec).getEncoded();

        return java.util.Arrays.equals(inputHash, storedHash);
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
