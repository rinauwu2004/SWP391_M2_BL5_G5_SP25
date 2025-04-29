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
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class QuizAttemptDao extends DBContext {
    
    public List<QuizAttempt> getAttemptsByQuizId(int quizId) {
        List<QuizAttempt> attempts = new ArrayList<>();
        QuizDao quizDao = new QuizDao();
        UserDao userDao = new UserDao();
        
        String sql = """
                     SELECT [id], [studentId], [quizId], [startedTime], [submittedTime], [score]
                     FROM [QuizAttempt]
                     WHERE [quizId] = ?
                     ORDER BY [submittedTime] DESC
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {
                QuizAttempt attempt = new QuizAttempt();
                attempt.setId(rs.getInt("id"));
                
                User student = userDao.getUserById(rs.getInt("studentId"));
                attempt.setStudent(student);
                
                Quiz quiz = quizDao.getQuizById(rs.getInt("quizId"));
                attempt.setQuiz(quiz);
                
                attempt.setStartedTime(rs.getTimestamp("startedTime"));
                attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                attempt.setScore(rs.getFloat("score"));
                
                attempts.add(attempt);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return attempts;
    }
    
    public QuizAttempt getAttemptById(int attemptId) {
        QuizAttempt attempt = null;
        QuizDao quizDao = new QuizDao();
        UserDao userDao = new UserDao();
        
        String sql = """
                     SELECT [id], [studentId], [quizId], [startedTime], [submittedTime], [score]
                     FROM [QuizAttempt]
                     WHERE [id] = ?
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                attempt = new QuizAttempt();
                attempt.setId(rs.getInt("id"));
                
                User student = userDao.getUserById(rs.getInt("studentId"));
                attempt.setStudent(student);
                
                Quiz quiz = quizDao.getQuizById(rs.getInt("quizId"));
                attempt.setQuiz(quiz);
                
                attempt.setStartedTime(rs.getTimestamp("startedTime"));
                attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                attempt.setScore(rs.getFloat("score"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return attempt;
    }
    
    public List<QuizAttempt> getAttemptsByStudentId(int studentId) {
        List<QuizAttempt> attempts = new ArrayList<>();
        QuizDao quizDao = new QuizDao();
        UserDao userDao = new UserDao();
        
        String sql = """
                     SELECT [id], [studentId], [quizId], [startedTime], [submittedTime], [score]
                     FROM [QuizAttempt]
                     WHERE [studentId] = ?
                     ORDER BY [submittedTime] DESC
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, studentId);
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {
                QuizAttempt attempt = new QuizAttempt();
                attempt.setId(rs.getInt("id"));
                
                User student = userDao.getUserById(rs.getInt("studentId"));
                attempt.setStudent(student);
                
                Quiz quiz = quizDao.getQuizById(rs.getInt("quizId"));
                attempt.setQuiz(quiz);
                
                attempt.setStartedTime(rs.getTimestamp("startedTime"));
                attempt.setSubmittedTime(rs.getTimestamp("submittedTime"));
                attempt.setScore(rs.getFloat("score"));
                
                attempts.add(attempt);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return attempts;
    }
    
    public double getAverageScoreByQuizId(int quizId) {
        double averageScore = 0;
        
        String sql = """
                     SELECT AVG([score]) AS averageScore
                     FROM [QuizAttempt]
                     WHERE [quizId] = ? AND [submittedTime] IS NOT NULL
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                averageScore = rs.getDouble("averageScore");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return averageScore;
    }
    
    public int getCompletedAttemptsCount(int quizId) {
        int count = 0;
        
        String sql = """
                     SELECT COUNT(*) AS completedCount
                     FROM [QuizAttempt]
                     WHERE [quizId] = ? AND [submittedTime] IS NOT NULL
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("completedCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return count;
    }
    
    public int getInProgressAttemptsCount(int quizId) {
        int count = 0;
        
        String sql = """
                     SELECT COUNT(*) AS inProgressCount
                     FROM [QuizAttempt]
                     WHERE [quizId] = ? AND [submittedTime] IS NULL
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("inProgressCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return count;
    }
    
    public float getHighestScoreByQuizId(int quizId) {
        float highestScore = 0;
        
        String sql = """
                     SELECT MAX([score]) AS highestScore
                     FROM [QuizAttempt]
                     WHERE [quizId] = ? AND [submittedTime] IS NOT NULL
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                highestScore = rs.getFloat("highestScore");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return highestScore;
    }
    
    public float getLowestScoreByQuizId(int quizId) {
        float lowestScore = 0;
        
        String sql = """
                     SELECT MIN([score]) AS lowestScore
                     FROM [QuizAttempt]
                     WHERE [quizId] = ? AND [submittedTime] IS NOT NULL
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next() && rs.getObject("lowestScore") != null) {
                lowestScore = rs.getFloat("lowestScore");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return lowestScore;
    }
}
