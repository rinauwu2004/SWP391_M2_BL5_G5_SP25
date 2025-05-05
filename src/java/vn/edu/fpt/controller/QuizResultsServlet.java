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
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.dao.QuizAttemptDao;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class QuizResultsServlet extends HttpServlet {

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
        
        // Get quiz ID from request parameter
        String quizIdParam = request.getParameter("id");
        if (quizIdParam == null || quizIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/home");
            return;
        }
        
        try {
            int quizId = Integer.parseInt(quizIdParam);
            
            // Get quiz details
            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.getQuizById(quizId);
            
            // Check if quiz exists and belongs to the current teacher
            if (quiz == null || quiz.getTeacher().getId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/teacher/home");
                return;
            }
            
            // For now, we'll use empty data since the database table might not be ready
            QuizAttemptDao quizAttemptDao = new QuizAttemptDao();
            List<QuizAttempt> attempts = quizAttemptDao.getByQuiz(quizId);
            int questionCount = quizDao.countQuestionsByQuizId(quizId);

            // Set attributes for the JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("attempts", attempts);
            request.setAttribute("attemptCount", attempts.size());
            request.setAttribute("questionCount", questionCount);
            
            // Forward to the quiz results JSP
            request.getRequestDispatcher("/teachers/quizResults.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Invalid quiz ID format
            response.sendRedirect(request.getContextPath() + "/teacher/home");
        }
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
        // POST method not used for viewing results, redirect to GET
        response.sendRedirect(request.getContextPath() + "/quiz/results?id=" + request.getParameter("id"));
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Quiz Results Servlet - Displays results of a specific quiz";
    }
}
