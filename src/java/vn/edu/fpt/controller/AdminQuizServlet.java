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
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class AdminQuizServlet extends HttpServlet {

    private static final int QUIZZES_PER_PAGE = 10;

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
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: list quizzes
            listQuizzes(request, response);
        } else {
            switch (action) {
                case "view":
                    viewQuiz(request, response);
                    break;
                case "search":
                    searchQuizzes(request, response);
                    break;
                default:
                    listQuizzes(request, response);
                    break;
            }
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

        // Check if user is logged in and is an admin
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is an admin
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: list quizzes
            listQuizzes(request, response);
        } else {
            switch (action) {
                case "search":
                    searchQuizzes(request, response);
                    break;
                default:
                    listQuizzes(request, response);
                    break;
            }
        }
    }

    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get page number from request parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page number, use default
                page = 1;
            }
        }

        // Calculate offset for pagination
        int offset = (page - 1) * QUIZZES_PER_PAGE;

        // Get quizzes from database
        QuizDao quizDao = new QuizDao();
        List<Quiz> quizzes = quizDao.getAllQuizzes(offset, QUIZZES_PER_PAGE);
        int totalQuizzes = quizDao.countAllQuizzes();
        int totalPages = (int) Math.ceil((double) totalQuizzes / QUIZZES_PER_PAGE);

        // Set attributes for the JSP
        request.setAttribute("quizzes", quizzes);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalQuizzes", totalQuizzes);

        // Forward to the quiz management JSP
        request.getRequestDispatcher("/admin/quizzes.jsp").forward(request, response);
    }

    private void viewQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get quiz ID from request parameter
        String quizIdParam = request.getParameter("id");
        if (quizIdParam == null || quizIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/quizzes");
            return;
        }

        try {
            int quizId = Integer.parseInt(quizIdParam);

            // Get quiz from database
            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.getQuizById(quizId);

            if (quiz == null) {
                // Quiz not found
                response.sendRedirect(request.getContextPath() + "/admin/quizzes");
                return;
            }
            
            QuestionDao questionDao = new QuestionDao();
            quiz.setQuestions(questionDao.getQuestionsByQuizId(quizId));

            // Get quiz statistics
            int attemptCount = quizDao.countAttemptsByQuizId(quizId);

            // Set attributes for the JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("attemptCount", attemptCount);
            request.setAttribute("questionCount", quizDao.countQuestionsByQuizId(quizId));

            // Forward to the view quiz JSP
            request.getRequestDispatcher("/admin/viewQuiz.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Invalid quiz ID format
            response.sendRedirect(request.getContextPath() + "/admin/quizzes");
        }
    }

    private void searchQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get search parameters
        String searchTerm = request.getParameter("searchTerm");
        String searchBy = request.getParameter("searchBy");

        if (searchTerm == null || searchTerm.trim().isEmpty() || searchBy == null || searchBy.trim().isEmpty()) {
            // Invalid search parameters, show all quizzes
            listQuizzes(request, response);
            return;
        }

        // Get page number from request parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page number, use default
                page = 1;
            }
        }

        // Calculate offset for pagination
        int offset = (page - 1) * QUIZZES_PER_PAGE;

        // Search quizzes in database
        QuizDao quizDao = new QuizDao();
        List<Quiz> quizzes = quizDao.searchQuizzes(searchTerm, searchBy, offset, QUIZZES_PER_PAGE);
        int totalQuizzes = quizDao.countSearchResults(searchTerm, searchBy);
        int totalPages = (int) Math.ceil((double) totalQuizzes / QUIZZES_PER_PAGE);

        // Set attributes for the JSP
        request.setAttribute("quizzes", quizzes);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalQuizzes", totalQuizzes);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("isSearch", true);

        // Forward to the quiz management JSP
        request.getRequestDispatcher("/admin/quizzes.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Quiz Management Servlet - Manages quizzes in the admin panel";
    }
}
