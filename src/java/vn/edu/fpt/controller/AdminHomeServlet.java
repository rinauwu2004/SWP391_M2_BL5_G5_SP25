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
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class AdminHomeServlet extends HttpServlet {

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

        // Get statistics for dashboard
        UserDao userDao = new UserDao();
        QuizDao quizDao = new QuizDao();

        int totalUsers = userDao.countAllUsers();
        int totalTeachers = userDao.countUsersByRole("Teacher");
        int totalStudents = userDao.countUsersByRole("Student");
        int totalQuizzes = quizDao.countAllQuizzes();

        // Get current year for user registration trend
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        int[] monthlyRegistrations = userDao.getUserRegistrationsByMonth(currentYear);

        // Convert the array to a JSON string for the chart
        StringBuilder registrationsJson = new StringBuilder("[");
        for (int i = 0; i < monthlyRegistrations.length; i++) {
            registrationsJson.append(monthlyRegistrations[i]);
            if (i < monthlyRegistrations.length - 1) {
                registrationsJson.append(", ");
            }
        }
        registrationsJson.append("]");

        // Set attributes for the JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalTeachers", totalTeachers);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalQuizzes", totalQuizzes);
        request.setAttribute("currentYear", currentYear);
        request.setAttribute("monthlyRegistrations", registrationsJson.toString());

        // Forward to the admin home JSP
        request.getRequestDispatcher("/admin/home.jsp").forward(request, response);
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
        // POST method not used for dashboard, redirect to GET
        response.sendRedirect(request.getContextPath() + "/admin/home");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Home Servlet - Displays admin dashboard";
    }
}
