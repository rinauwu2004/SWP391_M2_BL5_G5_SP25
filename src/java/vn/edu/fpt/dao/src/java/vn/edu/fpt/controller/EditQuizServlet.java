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
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class EditQuizServlet extends HttpServlet {

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
            
            // Set quiz as request attribute
            request.setAttribute("quiz", quiz);
            
            // Forward to the edit quiz JSP
            request.getRequestDispatcher("/teachers/editQuiz.jsp").forward(request, response);
            
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is a teacher
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }
        
        // Check if user is a teacher
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
            
            // Get form data
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String timeLimitStr = request.getParameter("timeLimit");
            String status = request.getParameter("status");
            
            // Validate form data
            if (title == null || title.trim().isEmpty() || 
                timeLimitStr == null || timeLimitStr.trim().isEmpty() || 
                status == null || status.trim().isEmpty()) {
                
                request.setAttribute("quiz", quiz);
                request.setAttribute("error", "All fields marked with * are required.");
                request.getRequestDispatcher("/teachers/editQuiz.jsp").forward(request, response);
                return;
            }
            
            // Parse time limit
            int timeLimit;
            try {
                timeLimit = Integer.parseInt(timeLimitStr);
                if (timeLimit <= 0) {
                    request.setAttribute("quiz", quiz);
                    request.setAttribute("error", "Time limit must be a positive number.");
                    request.getRequestDispatcher("/teachers/editQuiz.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("quiz", quiz);
                request.setAttribute("error", "Time limit must be a valid number.");
                request.getRequestDispatcher("/teachers/editQuiz.jsp").forward(request, response);
                return;
            }
            
            // Update quiz object
            quiz.setTitle(title);
            quiz.setDescription(description);
            quiz.setTimeLimit(timeLimit);
            quiz.setStatus(status);
            
            // Update quiz in database
            quizDao.updateQuiz(quiz);
            
            // Redirect to view quiz page with success message
            request.getSession().setAttribute("message", "Quiz updated successfully.");
            response.sendRedirect(request.getContextPath() + "/quiz/view?id=" + quizId);
            
        } catch (NumberFormatException e) {
            // Invalid quiz ID format
            response.sendRedirect(request.getContextPath() + "/teacher/home");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Edit Quiz Servlet - Handles editing of quizzes";
    }
}
