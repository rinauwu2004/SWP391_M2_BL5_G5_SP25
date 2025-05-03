/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.User;
import static vn.edu.fpt.util.PasswordEncryption.checkPassword;

/**
 *
 * @author Rinaaaa
 */
public class SigninController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_username".equals(cookie.getName())) {
                    request.setAttribute("savedUsername", cookie.getValue());
                    break;
                }
            }
        }
        
        request.setAttribute("googleLoginURL", vn.edu.fpt.util.GoogleLogin.getGoogleLoginURL());
        request.getRequestDispatcher("/Signin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        UserDao userDao = new UserDao();
        User user = userDao.getUser(username);
        if (user != null) {
            try {
                boolean matched = checkPassword(password, user.getHashPassword(), user.getSaltPassword());
                if (matched) {
                    request.getSession().setAttribute("user", user);
                    if ("on".equals(remember)) {
                        Cookie usernameCookie = new Cookie("remember_username", username);
                        usernameCookie.setMaxAge(7 * 24 * 60 * 60);
                        response.addCookie(usernameCookie);
                    } else {
                        Cookie usernameCookie = new Cookie("remember_username", "");
                        usernameCookie.setMaxAge(0);
                        response.addCookie(usernameCookie);
                    }

                    // Redirect based on role ID
                    int roleId = user.getRole().getId();
                    switch (roleId) {
                        case 1: // Admin
                            response.sendRedirect(request.getContextPath() + "/admin/home");
                            break;
                        case 2: // Student
                            response.sendRedirect(request.getContextPath() + "/home");
                            break;
                        case 3: // Teacher
                            response.sendRedirect(request.getContextPath() + "/teacher/home");
                            break;
                        default:
                            response.sendRedirect(request.getContextPath() + "/home");
                            break;
                    }
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
