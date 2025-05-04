/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.QuestionDao;
import vn.edu.fpt.dao.QuizAttemptDao;
import vn.edu.fpt.dao.QuizAttemptDetailDao;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.QuizAttemptDetail;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class QuizResultController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            request.getSession().setAttribute("error", "You must be signed in to access this page.");
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Get attempt ID from request
        String attemptIdParam = request.getParameter("attemptId");
        if (attemptIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        int attemptId = Integer.parseInt(attemptIdParam);

        // Get attempt from database
        QuizAttemptDao attemptDao = new QuizAttemptDao();
        QuizAttempt attempt = attemptDao.get(attemptId);

        if (attempt == null) {
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        // Check if this attempt belongs to the current user
        if (attempt.getStudent().getId() != user.getId()) {
            request.getSession().setAttribute("error", "You do not have permission to view this result.");
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        // Get attempt details
        QuizAttemptDetailDao detailDao = new QuizAttemptDetailDao();
        List<QuizAttemptDetail> details = detailDao.getByAttempt(attemptId);

        // Load questions for the quiz if they're not already loaded
        if (attempt.getQuiz().getQuestions() == null || attempt.getQuiz().getQuestions().isEmpty()) {
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsByQuizId(attempt.getQuiz().getId());
            attempt.getQuiz().setQuestions(questions);
        }

        // Set attributes for JSP
        request.setAttribute("attempt", attempt);
        request.setAttribute("details", details);

        // Calculate time spent
        long startTime = attempt.getStartedTime().getTime();
        long endTime = attempt.getSubmittedTime().getTime();
        long timeSpentMillis = endTime - startTime;

        // Convert to minutes and seconds
        long minutes = (timeSpentMillis / 1000) / 60;
        long seconds = (timeSpentMillis / 1000) % 60;

        request.setAttribute("timeSpent", String.format("%d:%02d", minutes, seconds));

        // Forward to JSP
        request.getRequestDispatcher("../quizResult.jsp").forward(request, response);
    }
}
