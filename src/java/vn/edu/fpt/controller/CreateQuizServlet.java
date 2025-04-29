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
import java.sql.Timestamp;
import java.util.Date;
import java.util.Random;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class CreateQuizServlet extends HttpServlet {

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
        
        // Forward to the create quiz JSP
        request.getRequestDispatcher("/teachers/createQuiz.jsp").forward(request, response);
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
        
        // Get form data
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String timeLimitStr = request.getParameter("timeLimit");
        String status = request.getParameter("status");
        
        // Validate form data
        if (title == null || title.trim().isEmpty() || 
            timeLimitStr == null || timeLimitStr.trim().isEmpty() || 
            status == null || status.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields marked with * are required.");
            request.getRequestDispatcher("/teachers/createQuiz.jsp").forward(request, response);
            return;
        }
        
        // Parse time limit
        int timeLimit;
        try {
            timeLimit = Integer.parseInt(timeLimitStr);
            if (timeLimit <= 0) {
                request.setAttribute("error", "Time limit must be a positive number.");
                request.getRequestDispatcher("/teachers/createQuiz.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Time limit must be a valid number.");
            request.getRequestDispatcher("/teachers/createQuiz.jsp").forward(request, response);
            return;
        }
        
        // Generate a unique quiz code (6 alphanumeric characters)
        String quizCode = generateQuizCode();
        
        // Create quiz object
        Quiz quiz = new Quiz();
        quiz.setTeacher(user);
        quiz.setTitle(title);
        quiz.setDescription(description);
        quiz.setTimeLimit(timeLimit);
        quiz.setStatus(status);
        quiz.setCode(quizCode);
        quiz.setCreatedAt(new Timestamp(new Date().getTime()));
        
        // Save quiz to database
        QuizDao quizDao = new QuizDao();
        quizDao.createQuiz(quiz);
        
        // Redirect to view quiz page with success message
        request.getSession().setAttribute("message", "Quiz created successfully. You can now add questions to your quiz.");
        response.sendRedirect(request.getContextPath() + "/quiz/view?id=" + quiz.getId());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Create Quiz Servlet - Handles creation of new quizzes";
    }
    
    /**
     * Generates a random 6-character alphanumeric quiz code
     * 
     * @return A unique quiz code
     */
    private String generateQuizCode() {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder();
        Random random = new Random();
        
        for (int i = 0; i < 6; i++) {
            code.append(characters.charAt(random.nextInt(characters.length())));
        }
        
        return code.toString();
    }
}
