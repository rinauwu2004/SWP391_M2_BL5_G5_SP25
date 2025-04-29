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
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.User;
import vn.edu.fpt.util.JavaMail;

/**
 *
 * @author Rinaaaa
 */
public class ForgotPasswordController extends HttpServlet {

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
            out.println("<title>Servlet ForgotPasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPasswordController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
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
        UserDao userDao = new UserDao();
        String input = request.getParameter("input");

        User user = userDao.getUser(input);
        if (user == null) {
            String message = "We cannot find your account. Please try again!!!";
            request.setAttribute("message", message);
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("email", user.getEmailAddress());
            Long lockTime = (Long) session.getAttribute("lockTime");
            long currentTime = System.currentTimeMillis();

            if (lockTime != null && (currentTime - lockTime) < 15 * 60 * 1000) {
                session.setAttribute("error", "Unable to verify your account.");
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            }
            
            String otpPurpose = "forgot-password";
            session.setAttribute("otpPurpose", otpPurpose);
            
            String otp = JavaMail.createOTP();
            JavaMail.sendOTP(user.getEmailAddress(), otp);
            session.setAttribute("otp", otp);
            int timeoutMinutes = 5;
            session.setAttribute("timeout", timeoutMinutes);
            long expiryTimeMillis = System.currentTimeMillis() + (timeoutMinutes * 60 * 1000);
            session.setAttribute("otpExpiryTime", expiryTimeMillis);
            response.sendRedirect(request.getContextPath() + "/verify");
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
