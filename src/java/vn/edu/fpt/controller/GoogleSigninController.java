/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.GoogleAccount;
import vn.edu.fpt.model.User;
import vn.edu.fpt.util.GoogleLogin;

public class GoogleSigninController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        try {
            String accessToken = GoogleLogin.getToken(code);

            GoogleAccount googleAccount = GoogleLogin.getUserInfo(accessToken);

            String email = googleAccount.getEmail();
            String firstName = googleAccount.getFamily_name();
            String lastName = googleAccount.getGiven_name();

            UserDao userDao = new UserDao();
            User user = userDao.getUser(email);

            if (user == null) {
                user = new User();
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setEmailAddress(email);

                request.getSession().setAttribute("tempUser", user);
                response.sendRedirect(request.getContextPath() + "/complete-profile");
                return;
            }

            request.getSession().setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (IOException ex) {
            Logger.getLogger(GoogleSigninController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Login with Google failed.");
            request.getRequestDispatcher("/Signin.jsp").forward(request, response);
        }
    }
}
