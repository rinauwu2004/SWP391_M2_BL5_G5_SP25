/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.Quiz;

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
}
