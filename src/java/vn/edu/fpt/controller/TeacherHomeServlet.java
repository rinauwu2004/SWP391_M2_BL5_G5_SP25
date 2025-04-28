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
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class TeacherHomeServlet extends HttpServlet {

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
        
        // Check if user is logged in and is a teacher
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }
        
        // Check if user is a teacher (assuming role name is "teacher")
        if (!"teacher".equalsIgnoreCase(user.getRole().getName())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Get all quizzes created by this teacher
        QuizDao quizDao = new QuizDao();
        List<Quiz> quizzes = quizDao.getQuizzesByTeacher(user.getId());
        
        // Add quiz count information
        for (Quiz quiz : quizzes) {
            int questionCount = quizDao.countQuestionsByQuizId(quiz.getId());
            int attemptCount = quizDao.countAttemptsByQuizId(quiz.getId());
            request.setAttribute("questionCount_" + quiz.getId(), questionCount);
            request.setAttribute("attemptCount_" + quiz.getId(), attemptCount);
        }
        
        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("/teachers/home.jsp").forward(request, response);
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
        // Not used for now, might be used for filtering or searching quizzes
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Teacher Home Servlet - Displays teacher's quizzes";
    }
}
