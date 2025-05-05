package vn.edu.fpt.controller;

import java.io.IOException;
import java.sql.Timestamp;
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
import vn.edu.fpt.dao.AnswerDao;
import vn.edu.fpt.dao.QuestionDao;
import vn.edu.fpt.dao.QuizAttemptDao;
import vn.edu.fpt.dao.QuizAttemptDetailDao;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Answer;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.QuizAttemptDetail;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class DoQuizController extends HttpServlet {

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

        // Check if user is logged in
        if (user == null) {
            request.getSession().setAttribute("error", "You must be signed in to access this page.");
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Get quiz ID from request or session
        int quizId;
        int questionNumber = 1;
        QuizAttempt attempt = (QuizAttempt) session.getAttribute("currentAttempt");

        if (attempt == null) {
            // New attempt - get quiz from request parameter
            String quizIdParam = request.getParameter("quizId");
            if (quizIdParam == null) {
                response.sendRedirect(request.getContextPath() + "/quiz/join");
                return;
            }

            quizId = Integer.parseInt(quizIdParam);
            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.get(quizId);

            if (quiz == null) {
                response.sendRedirect(request.getContextPath() + "/quiz/join");
                return;
            }

            // Create a new attempt
            attempt = new QuizAttempt();
            attempt.setQuiz(quiz);
            attempt.setStudent(user);
            attempt.setStartedTime(new Timestamp(System.currentTimeMillis()));

            QuizAttemptDao attemptDao = new QuizAttemptDao();
            int attemptId = attemptDao.create(attempt);
            attempt.setId(attemptId);

            // Store attempt in session
            session.setAttribute("currentAttempt", attempt);

            // Initialize answered questions map
            Map<Integer, List<Integer>> answeredQuestions = new HashMap<>();
            session.setAttribute("answeredQuestions", answeredQuestions);
            session.setAttribute("currentQuestionNumber", 1);
        } else {
            Integer currentQuestionNumber = (Integer) session.getAttribute("currentQuestionNumber");
            String questionParam = request.getParameter("questionNumber");

            if (questionParam != null) {
                questionNumber = Integer.parseInt(questionParam);
                session.setAttribute("currentQuestionNumber", questionNumber);
            } else if (currentQuestionNumber != null) {
                questionNumber = currentQuestionNumber;
            } else {
                questionNumber = 1;
                session.setAttribute("currentQuestionNumber", questionNumber);
            }

            quizId = attempt.getQuiz().getId();
        }

        // Load questions for this quiz with optimized method
        QuestionDao questionDao = new QuestionDao();
        List<Question> questions = questionDao.getQuestionsWithAnswersByQuizId(quizId);

        if (questions.isEmpty()) {
            request.setAttribute("errorMessage", "No questions found for this quiz.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Store questions in the quiz object for later use
        attempt.getQuiz().setQuestions(questions);

        // Ensure question number is valid
        if (questionNumber > questions.size()) {
            questionNumber = questions.size();
        }

        // Get current question
        Question currentQuestion = questions.get(questionNumber - 1);

        // Get selected answers for current question
        Map<Integer, List<Integer>> answeredQuestions
                = (Map<Integer, List<Integer>>) session.getAttribute("answeredQuestions");
        List<Integer> selectedAnswers = answeredQuestions.getOrDefault(currentQuestion.getId(), new ArrayList<>());

        // Set attributes for JSP
        request.setAttribute("quiz", attempt.getQuiz());
        request.setAttribute("user", user);
        request.setAttribute("currentQuestion", currentQuestion);
        request.setAttribute("questionNumber", questionNumber);
        request.setAttribute("totalQuestions", questions.size());
        request.setAttribute("options", currentQuestion.getAnswers());
        request.setAttribute("selectedAnswers", selectedAnswers);
        request.setAttribute("answeredQuestions", answeredQuestions);

        // Calculate remaining time
        long startTime = attempt.getStartedTime().getTime();
        long currentTime = System.currentTimeMillis();
        long elapsedSeconds = (currentTime - startTime) / 1000;
        long totalSeconds = attempt.getQuiz().getTimeLimit() * 60;
        long remainingSeconds = totalSeconds - elapsedSeconds;

        if (remainingSeconds <= 0) {
            // Time's up, auto-submit
            submitQuiz(request, response);
            return;
        }

        request.setAttribute("remainingSeconds", remainingSeconds);

        // Forward to JSP
        request.getRequestDispatcher("../doQuiz.jsp").forward(request, response);
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
        String action = request.getParameter("action");

        if (null == action) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        } else {
            switch (action) {
                case "saveAnswers" ->
                    saveAnswers(request, response);
                case "submitQuiz" ->
                    submitQuiz(request, response);
                case "getQuestionData" ->
                    getQuestionData(request, response);
                default ->
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        }
    }

    /**
     * Saves the answers for the current question
     */
    private void saveAnswers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get question ID and selected answers
        int questionId;
        try {
            questionId = Integer.parseInt(request.getParameter("questionId"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid question ID");
            return;
        }

        String[] answerIds = request.getParameterValues("answers");

        // Convert to list of integers
        List<Integer> selectedAnswers = new ArrayList<>();
        if (answerIds != null) {
            for (String answerId : answerIds) {
                if (answerId != null && !answerId.trim().isEmpty()) {
                    try {
                        selectedAnswers.add(Integer.parseInt(answerId));
                    } catch (NumberFormatException e) {
                        // Skip invalid answer IDs
                    }
                }
            }
        }

        // Update session with selected answers
        Map<Integer, List<Integer>> answeredQuestions
                = (Map<Integer, List<Integer>>) session.getAttribute("answeredQuestions");
        answeredQuestions.put(questionId, selectedAnswers);

        // Get current attempt
        QuizAttempt attempt = (QuizAttempt) session.getAttribute("currentAttempt");
        if (attempt == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("No active quiz attempt");
            return;
        }

        // Delete existing answers for this question
        QuizAttemptDetailDao detailDao = new QuizAttemptDetailDao();
        detailDao.deleteByAttemptAndQuestion(attempt.getId(), questionId);

        // Save new answers
        if (!selectedAnswers.isEmpty()) {
            // Create Question object
            Question question = new Question();
            question.setId(questionId);

            // Create batch of details to save
            List<QuizAttemptDetail> detailsToSave = new ArrayList<>();
            for (Integer answerId : selectedAnswers) {
                QuizAttemptDetail detail = new QuizAttemptDetail();
                detail.setAttempt(attempt);
                detail.setQuestion(question);

                Answer answer = new Answer();
                answer.setId(answerId);
                detail.setAnswer(answer);

                detailsToSave.add(detail);
            }

            // Save all details in batch
            detailDao.createBatch(detailsToSave);
        }

        // Return success response for AJAX
        response.setContentType("text/plain");
        response.getWriter().write("success");
    }

    /**
     * Submits the quiz and calculates the score
     */
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        QuizAttempt attempt = (QuizAttempt) session.getAttribute("currentAttempt");
        Map<Integer, List<Integer>> answeredQuestions
                = (Map<Integer, List<Integer>>) session.getAttribute("answeredQuestions");

        if (attempt == null) {
            response.sendRedirect(request.getContextPath() + "/quiz/join");
            return;
        }

        // Set submission time
        attempt.setSubmittedTime(new Timestamp(System.currentTimeMillis()));

        // Get all questions for this quiz
        List<Question> allQuestions = attempt.getQuiz().getQuestions();

        // If questions are not loaded yet, load them with answers
        if (allQuestions == null || allQuestions.isEmpty()) {
            QuestionDao questionDao = new QuestionDao();
            allQuestions = questionDao.getQuestionsWithAnswersByQuizId(attempt.getQuiz().getId());
            attempt.getQuiz().setQuestions(allQuestions);
        }

        // Calculate score
        float totalQuestions = allQuestions.size();
        float correctAnswers = 0;

        // Get all correct answers for all questions in one query
        AnswerDao answerDao = new AnswerDao();
        List<Integer> questionIds = allQuestions.stream()
                .map(Question::getId)
                .collect(Collectors.toList());

        Map<Integer, List<Answer>> allCorrectAnswers = new HashMap<>();
        for (Question question : allQuestions) {
            List<Answer> correctAnswersForQuestion = question.getAnswers().stream()
                    .filter(Answer::isIsCorrect)
                    .collect(Collectors.toList());
            allCorrectAnswers.put(question.getId(), correctAnswersForQuestion);
        }

        // Save all answers to database in batch
        QuizAttemptDetailDao detailDao = new QuizAttemptDetailDao();
        List<QuizAttemptDetail> allDetails = new ArrayList<>();

        for (Question question : allQuestions) {
            int questionId = question.getId();
            List<Integer> selectedAnswerIds = answeredQuestions.getOrDefault(questionId, new ArrayList<>());

            // Save each selected answer
            for (Integer answerId : selectedAnswerIds) {
                QuizAttemptDetail detail = new QuizAttemptDetail();
                detail.setAttempt(attempt);
                detail.setQuestion(question);

                Answer answer = new Answer();
                answer.setId(answerId);
                detail.setAnswer(answer);

                allDetails.add(detail);
            }

            // Check if answers are correct
            List<Answer> correctAnswersForQuestion = allCorrectAnswers.get(questionId);
            List<Integer> correctAnswerIds = correctAnswersForQuestion.stream()
                    .map(Answer::getId)
                    .collect(Collectors.toList());

            // Compare selected answers with correct answers
            if (!selectedAnswerIds.isEmpty()
                    && selectedAnswerIds.size() == correctAnswerIds.size()
                    && selectedAnswerIds.containsAll(correctAnswerIds)) {
                correctAnswers++;
            }
        }

        // Save all details in batch
        detailDao.createBatch(allDetails);

        // Calculate score as percentage
        float score = (totalQuestions > 0) ? (correctAnswers / totalQuestions) * 100 : 0;
        attempt.setScore(score);

        // Update attempt with score
        QuizAttemptDao attemptDao = new QuizAttemptDao();
        attemptDao.update(attempt);

        // Clear session attributes
        session.removeAttribute("currentAttempt");
        session.removeAttribute("answeredQuestions");
        session.removeAttribute("currentQuestionNumber");

        // Ensure the redirect URL is correct and properly formed
        String redirectUrl = request.getContextPath() + "/quiz/result?attemptId=" + attempt.getId();

        // Redirect to results page
        response.sendRedirect(redirectUrl);
    }

    private void getQuestionData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        QuizAttempt attempt = (QuizAttempt) session.getAttribute("currentAttempt");

        if (attempt == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("No active quiz attempt");
            return;
        }

        int questionNumber = Integer.parseInt(request.getParameter("questionNumber"));

        // Get questions from the quiz object
        List<Question> questions = attempt.getQuiz().getQuestions();

        // If questions are not loaded yet, load them with answers
        if (questions == null || questions.isEmpty()) {
            QuestionDao questionDao = new QuestionDao();
            questions = questionDao.getQuestionsWithAnswersByQuizId(attempt.getQuiz().getId());
            attempt.getQuiz().setQuestions(questions);
        }

        if (questionNumber > questions.size()) {
            questionNumber = questions.size();
        }

        // Get current question
        Question currentQuestion = questions.get(questionNumber - 1);

        // Get selected answers for current question
        Map<Integer, List<Integer>> answeredQuestions
                = (Map<Integer, List<Integer>>) session.getAttribute("answeredQuestions");
        List<Integer> selectedAnswers = answeredQuestions.getOrDefault(currentQuestion.getId(), new ArrayList<>());

        // Create JSON response
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"questionNumber\":").append(questionNumber).append(",");
        json.append("\"totalQuestions\":").append(questions.size()).append(",");
        json.append("\"questionId\":").append(currentQuestion.getId()).append(",");
        json.append("\"content\":\"").append(escapeJson(currentQuestion.getContent())).append("\",");

        // Add options
        json.append("\"options\":[");
        List<Answer> options = currentQuestion.getAnswers();
        for (int i = 0; i < options.size(); i++) {
            Answer option = options.get(i);
            json.append("{");
            json.append("\"id\":").append(option.getId()).append(",");
            json.append("\"content\":\"").append(escapeJson(option.getContent())).append("\",");
            json.append("\"selected\":").append(selectedAnswers.contains(option.getId()));
            json.append("}");
            if (i < options.size() - 1) {
                json.append(",");
            }
        }
        json.append("],");

        // Add answered questions array - FIXED: Only include questions with actual selected answers
        json.append("\"answeredQuestions\":[");
        int count = 0;
        for (Map.Entry<Integer, List<Integer>> entry : answeredQuestions.entrySet()) {
            // Only include questions that have at least one selected answer
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                if (count > 0) {
                    json.append(",");
                }
                // Get question number from question ID
                for (int i = 0; i < questions.size(); i++) {
                    if (questions.get(i).getId() == entry.getKey()) {
                        json.append(i + 1);
                        count++;
                        break;
                    }
                }
            }
        }
        json.append("]");

        json.append("}");

        response.setContentType("application/json");
        response.getWriter().write(json.toString());
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles quiz taking functionality";
    }
}
