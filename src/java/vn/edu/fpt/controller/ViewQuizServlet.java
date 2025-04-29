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
import vn.edu.fpt.dao.QuestionDao;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class ViewQuizServlet extends HttpServlet {

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
            
            // Get quiz questions
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsByQuizId(quizId);
            
            // Get quiz statistics
            int attemptCount = quizDao.countAttemptsByQuizId(quizId);
            
            // Set attributes for the JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("attemptCount", attemptCount);
            
            // Forward to the view quiz JSP
            request.getRequestDispatcher("/teachers/viewQuiz.jsp").forward(request, response);
            
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
        // POST method not used for viewing, redirect to GET
        response.sendRedirect(request.getContextPath() + "/quiz/view?id=" + request.getParameter("id"));
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "View Quiz Servlet - Displays details of a specific quiz";
    }
}
