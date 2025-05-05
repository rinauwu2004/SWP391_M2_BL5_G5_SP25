/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.Question;

/**
 *
 * @author Rinaaaa
 */
public class QuizAttemptDao extends DBContext {

    /**
     * Creates a new quiz attempt and returns the generated ID
     *
     * @param attempt The quiz attempt to create
     * @return The ID of the created attempt
     */
    public int create(QuizAttempt attempt) {
        String sql = """
                     INSERT INTO [QuizAttempt] 
                     ([studentId], [quizId], [startedTime]) 
                     VALUES (?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, attempt.getStudent().getId());
            stm.setInt(2, attempt.getQuiz().getId());
            stm.setTimestamp(3, attempt.getStartedTime());
            stm.executeUpdate();

            // Get the generated ID
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Updates an existing quiz attempt
     *
     * @param attempt The quiz attempt to update
     */
    public void update(QuizAttempt attempt) {
        String sql = """
                     UPDATE [QuizAttempt] 
                     SET [submittedTime] = ?, [score] = ? 
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setTimestamp(1, attempt.getSubmittedTime());
            stm.setFloat(2, attempt.getScore());
            stm.setInt(3, attempt.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Gets a quiz attempt by ID
     *
     * @param id The ID of the quiz attempt
     * @return The quiz attempt, or null if not found
     */
    public QuizAttempt get(int id) {
        QuizAttempt attempt = null;
        String sql = """
                     SELECT [id], [studentId], [quizId], [startedTime], 
                     [submittedTime], [score] 
                     FROM [QuizAttempt] 
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    attempt = new QuizAttempt();
                    attempt.setId(rs.getInt("id"));

                    // Load student
                    UserDao userDao = new UserDao();
                    User student = userDao.getUser(rs.getInt("studentId"));
                    attempt.setStudent(student);

                    // Load quiz
                    QuizDao quizDao = new QuizDao();
                    Quiz quiz = quizDao.get(rs.getInt("quizId"));
                    attempt.setQuiz(quiz);

                    attempt.setStartedTime(rs.getTimestamp("startedTime"));
                    attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                    attempt.setScore(rs.getFloat("score"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return attempt;
    }

    /**
     * Gets a quiz attempt by ID with optimized loading of related data Uses a
     * JOIN query to reduce database calls
     *
     * @param id The ID of the quiz attempt
     * @return The quiz attempt with related data, or null if not found
     */
    public QuizAttempt getWithRelatedData(int id) {
        QuizAttempt attempt = null;
        String sql = """
                     SELECT a.[id], a.[studentId], a.[quizId], a.[startedTime], a.[submittedTime], a.[score],
                            s.[id] as student_id, s.[first_name], s.[last_name], s.[email_address],
                            q.[id] as quiz_id, q.[title], q.[code], q.[timeLimit]
                     FROM [QuizAttempt] a
                     JOIN [User] s ON a.[studentId] = s.[id]
                     JOIN [Quiz] q ON a.[quizId] = q.[id]
                     WHERE a.[id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    attempt = new QuizAttempt();
                    attempt.setId(rs.getInt("id"));

                    // Create student object directly from join result
                    User student = new User();
                    student.setId(rs.getInt("student_id"));
                    student.setFirstName(rs.getString("first_name"));
                    student.setLastName(rs.getString("last_name"));
                    student.setEmailAddress(rs.getString("email_address"));
                    attempt.setStudent(student);

                    // Create quiz object directly from join result
                    Quiz quiz = new Quiz();
                    quiz.setId(rs.getInt("quiz_id"));
                    quiz.setTitle(rs.getString("title"));
                    quiz.setCode(rs.getString("code"));
                    quiz.setTimeLimit(rs.getInt("timeLimit"));

                    // Load questions for the quiz in a single query
                    QuestionDao questionDao = new QuestionDao();
                    List<Question> questions = questionDao.getQuestionsByQuizId(quiz.getId());
                    quiz.setQuestions(questions);

                    attempt.setQuiz(quiz);

                    attempt.setStartedTime(rs.getTimestamp("startedTime"));
                    attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                    attempt.setScore(rs.getFloat("score"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return attempt;
    }

    /**
     * Gets all quiz attempts for a student
     *
     * @param studentId The ID of the student
     * @return A list of quiz attempts
     */
    public List<QuizAttempt> getByStudent(int studentId) {
        List<QuizAttempt> attempts = new ArrayList<>();
        String sql = """
                     SELECT [id], [studentId], [quizId], [startedTime], 
                     [submittedTime], [score] 
                     FROM [QuizAttempt] 
                     WHERE [studentId] = ? 
                     ORDER BY [startedTime] DESC
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, studentId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    QuizAttempt attempt = new QuizAttempt();
                    attempt.setId(rs.getInt("id"));

                    // Load student
                    UserDao userDao = new UserDao();
                    User student = userDao.getUser(rs.getInt("studentId"));
                    attempt.setStudent(student);

                    // Load quiz
                    QuizDao quizDao = new QuizDao();
                    Quiz quiz = quizDao.get(rs.getInt("quizId"));
                    attempt.setQuiz(quiz);

                    attempt.setStartedTime(rs.getTimestamp("startedTime"));
                    attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                    attempt.setScore(rs.getFloat("score"));

                    attempts.add(attempt);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return attempts;
    }

    /**
     * Gets all quiz attempts for a quiz
     *
     * @param quizId The ID of the quiz
     * @return A list of quiz attempts
     */
    public List<QuizAttempt> getByQuiz(int quizId) {
        List<QuizAttempt> attempts = new ArrayList<>();
        String sql = """
                     SELECT [id], [studentId], [quizId], [startedTime], 
                     [submittedTime], [score] 
                     FROM [QuizAttempt] 
                     WHERE [quizId] = ? 
                     ORDER BY [startedTime] DESC
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    QuizAttempt attempt = new QuizAttempt();
                    attempt.setId(rs.getInt("id"));

                    // Load student
                    UserDao userDao = new UserDao();
                    User student = userDao.getUser(rs.getInt("studentId"));
                    attempt.setStudent(student);

                    // Load quiz
                    QuizDao quizDao = new QuizDao();
                    Quiz quiz = quizDao.get(rs.getInt("quizId"));
                    attempt.setQuiz(quiz);

                    attempt.setStartedTime(rs.getTimestamp("startedTime"));
                    attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                    attempt.setScore(rs.getFloat("score"));

                    attempts.add(attempt);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return attempts;
    }

    /**
     * Gets the attempt number for a specific quiz attempt This calculates which
     * attempt number this is for the student for this specific quiz
     *
     * @param attemptId The ID of the quiz attempt
     * @return The attempt number (1 for first attempt, 2 for second, etc.)
     */
    public int getAttemptNumber(int attemptId) {
        int attemptNumber = 0;
        String sql = """
                 SELECT COUNT(*) as attempt_number
                 FROM [QuizAttempt] a1
                 JOIN [QuizAttempt] a2 ON a1.[studentId] = a2.[studentId] AND a1.[quizId] = a2.[quizId]
                 WHERE a2.[id] = ? AND (a1.[startedTime] < a2.[startedTime] OR 
                       (a1.[startedTime] = a2.[startedTime] AND a1.[id] <= a2.[id]))
                 """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    attemptNumber = rs.getInt("attempt_number");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return attemptNumber;
    }

    /**
     * Gets a map of attempt numbers for a list of attempt IDs This is more
     * efficient than calling getAttemptNumber multiple times
     *
     * @param studentId The ID of the student
     * @param attemptIds List of attempt IDs to get numbers for
     * @return Map of attempt ID to attempt number
     */
    public Map<Integer, Integer> getAttemptNumbers(int studentId, List<Integer> attemptIds) {
        Map<Integer, Integer> attemptNumbers = new HashMap<>();

        if (attemptIds == null || attemptIds.isEmpty()) {
            return attemptNumbers;
        }

        // Build the IN clause for the SQL query
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < attemptIds.size(); i++) {
            placeholders.append("?");
            if (i < attemptIds.size() - 1) {
                placeholders.append(",");
            }
        }

        String sql = String.format("""
                 WITH AttemptRanking AS (
                     SELECT 
                         a.[id],
                         a.[quizId],
                         ROW_NUMBER() OVER (PARTITION BY a.[quizId] ORDER BY a.[startedTime], a.[id]) as attempt_number
                     FROM [QuizAttempt] a
                     WHERE a.[studentId] = ? AND a.[id] IN (%s)
                 )
                 SELECT [id], [attempt_number]
                 FROM AttemptRanking
                 """, placeholders);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, studentId);

            // Set the attempt IDs in the IN clause
            for (int i = 0; i < attemptIds.size(); i++) {
                stm.setInt(i + 2, attemptIds.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int attemptId = rs.getInt("id");
                    int attemptNumber = rs.getInt("attempt_number");
                    attemptNumbers.put(attemptId, attemptNumber);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return attemptNumbers;
    }
}
