package vn.edu.fpt.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.QuizAttemptDao;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.User;

public class ViewQuizHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User student = (User) session.getAttribute("user");

        if (student == null) {
            request.getSession().setAttribute("error", "You must be signed in to access this page.");
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Get search parameter
        String searchQuizId = request.getParameter("searchQuizId");

        // Get pagination parameters
        int pageSize = 10; // Number of records per page
        int pageNumber = 1; // Default page number

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1) {
                    pageNumber = 1;
                }
            }
        } catch (NumberFormatException e) {
            // If invalid page number, default to 1
            pageNumber = 1;
        }

        // Calculate pagination offsets
        int offset = (pageNumber - 1) * pageSize;

        // Initialize DAOs
        QuizAttemptDao quizAttemptDao = new QuizAttemptDao();
        QuizDao quizDao = new QuizDao();

        // Get all quiz attempts for the student
        List<QuizAttempt> allAttempts = quizAttemptDao.getByStudent(student.getId());

        // Filter attempts if search parameter is provided
        List<QuizAttempt> filteredAttempts = new ArrayList<>();
        if (searchQuizId != null && !searchQuizId.isEmpty()) {
            for (QuizAttempt attempt : allAttempts) {
                if (attempt.getQuiz().getCode().toLowerCase().contains(searchQuizId.toLowerCase())) {
                    filteredAttempts.add(attempt);
                }
            }
        } else {
            filteredAttempts = allAttempts;
        }

        // Calculate summary statistics
        Map<Integer, Integer> quizAttemptCounts = new HashMap<>();
        int totalQuizzes = 0;
        int totalAttempts = filteredAttempts.size();
        int passedCount = 0;
        int failedCount = 0;
        float totalScore = 0;

        for (QuizAttempt attempt : filteredAttempts) {
            // Count unique quizzes
            if (!quizAttemptCounts.containsKey(attempt.getQuiz().getId())) {
                quizAttemptCounts.put(attempt.getQuiz().getId(), 1);
                totalQuizzes++;
            } else {
                quizAttemptCounts.put(attempt.getQuiz().getId(),
                        quizAttemptCounts.get(attempt.getQuiz().getId()) + 1);
            }

            // Count passed/failed attempts
            if (attempt.getScore() >= 50) { // Assuming 50% is passing score
                passedCount++;
            } else {
                failedCount++;
            }

            // Sum scores for average calculation
            totalScore += attempt.getScore();
        }

        // Calculate average score
        float averageScore = totalAttempts > 0 ? totalScore / totalAttempts : 0;

        // Apply pagination to filtered attempts
        List<QuizAttempt> paginatedAttempts = new ArrayList<>();
        int endIndex = Math.min(offset + pageSize, filteredAttempts.size());
        if (offset < filteredAttempts.size()) {
            paginatedAttempts = filteredAttempts.subList(offset, endIndex);
        }

        // Get attempt numbers for the paginated attempts
        List<Integer> attemptIds = paginatedAttempts.stream()
                .map(QuizAttempt::getId)
                .collect(Collectors.toList());

        Map<Integer, Integer> attemptNumbers = quizAttemptDao.getAttemptNumbers(student.getId(), attemptIds);

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) filteredAttempts.size() / pageSize);

        // Set attributes for the JSP
        request.setAttribute("totalQuizzes", totalQuizzes);
        request.setAttribute("totalAttempts", totalAttempts);
        request.setAttribute("passedCount", passedCount);
        request.setAttribute("failedCount", failedCount);
        request.setAttribute("averageScore", Math.round(averageScore));
        request.setAttribute("quizAttempts", paginatedAttempts);
        request.setAttribute("quizAttemptCounts", quizAttemptCounts);
        request.setAttribute("attemptNumbers", attemptNumbers); // Add the attempt numbers map
        request.setAttribute("currentPage", pageNumber);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuizId", searchQuizId);

        // Forward to the JSP
        request.getRequestDispatcher("../viewQuizHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
