package vn.edu.fpt.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.QuestionDao;
import vn.edu.fpt.dao.QuizAttemptDao;
import vn.edu.fpt.dao.QuizAttemptDetailDao;
import vn.edu.fpt.model.Answer;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class QuizResultController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(QuizResultController.class.getName());

    // Cache for recently viewed attempts to reduce database load
    private static final Map<Integer, QuizAttempt> attemptCache = new ConcurrentHashMap<>();
    private static final Map<Integer, Long> attemptCacheTimestamp = new ConcurrentHashMap<>();
    private static final long CACHE_EXPIRY_MS = 5 * 60 * 1000; // 5 minutes

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();

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
        if (attemptIdParam == null || attemptIdParam.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "No attemptId provided in request");
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        int attemptId;
        try {
            attemptId = Integer.parseInt(attemptIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid attemptId format: {0}", attemptIdParam);
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        // Try to get attempt from cache first
        QuizAttempt attempt = getAttemptFromCache(attemptId);

        if (attempt == null) {
            // Get attempt from database with optimized loading
            QuizAttemptDao attemptDao = new QuizAttemptDao();
            attempt = attemptDao.getWithRelatedData(attemptId);

            if (attempt != null) {
                // Store in cache for future requests
                cacheAttempt(attemptId, attempt);
            }
        }

        if (attempt == null) {
            LOGGER.log(Level.WARNING, "Attempt not found with ID: {0}", attemptId);
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        // Check if this attempt belongs to the current user
        if (attempt.getStudent().getId() != user.getId()) {
            LOGGER.log(Level.WARNING, "User {0} attempted to access result for attempt {1} belonging to user {2}",
                    new Object[]{user.getId(), attemptId, attempt.getStudent().getId()});
            request.getSession().setAttribute("error", "You do not have permission to view this result.");
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        // Get questions with answers in a single query if not already loaded
        if (attempt.getQuiz().getQuestions() == null || attempt.getQuiz().getQuestions().isEmpty()) {
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsWithAnswersByQuizId(attempt.getQuiz().getId());
            attempt.getQuiz().setQuestions(questions);
        }

        // Get attempt details with optimized loading
        QuizAttemptDetailDao detailDao = new QuizAttemptDetailDao();

        // Create a map of selected answers by questionId for easy lookup
        Map<Integer, List<Answer>> selectedAnswersMap = new HashMap<>();

        // Batch load all selected answers for all questions in one go
        List<Integer> questionIds = attempt.getQuiz().getQuestions().stream()
                .map(q -> q.getId())
                .toList();

        Map<Integer, List<Answer>> batchSelectedAnswers = detailDao.getSelectedAnswersForQuestions(attemptId, questionIds);
        selectedAnswersMap.putAll(batchSelectedAnswers);

        // Set attributes for JSP
        request.setAttribute("attempt", attempt);
        request.setAttribute("selectedAnswersMap", selectedAnswersMap);

        // Calculate time spent
        long startTimeQuiz = attempt.getStartedTime().getTime();
        long endTimeQuiz = attempt.getSubmittedTime().getTime();
        long timeSpentMillis = endTimeQuiz - startTimeQuiz;

        // Convert to minutes and seconds
        long minutes = (timeSpentMillis / 1000) / 60;
        long seconds = (timeSpentMillis / 1000) % 60;

        request.setAttribute("timeSpent", String.format("%d:%02d", minutes, seconds));

        // Calculate correct answers count
        int totalQuestions = attempt.getQuiz().getQuestions().size();
        int correctAnswersCount = Math.round((attempt.getScore() / 100) * totalQuestions);

        request.setAttribute("correctAnswers", correctAnswersCount);
        request.setAttribute("totalQuestions", totalQuestions);

        // Add performance metrics
        long processingTime = System.currentTimeMillis() - startTime;
        request.setAttribute("processingTime", processingTime);

        // Forward to JSP
        request.getRequestDispatcher("../quizResult.jsp").forward(request, response);
    }

    /**
     * Get attempt from cache if available and not expired
     */
    private QuizAttempt getAttemptFromCache(int attemptId) {
        if (attemptCache.containsKey(attemptId)) {
            Long timestamp = attemptCacheTimestamp.get(attemptId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return attemptCache.get(attemptId);
            } else {
                // Remove expired cache entry
                attemptCache.remove(attemptId);
                attemptCacheTimestamp.remove(attemptId);
            }
        }
        return null;
    }

    /**
     * Store attempt in cache
     */
    private void cacheAttempt(int attemptId, QuizAttempt attempt) {
        attemptCache.put(attemptId, attempt);
        attemptCacheTimestamp.put(attemptId, System.currentTimeMillis());
    }
}
