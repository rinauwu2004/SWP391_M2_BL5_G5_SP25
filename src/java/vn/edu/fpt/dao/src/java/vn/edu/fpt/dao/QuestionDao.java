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
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.Quiz;

/**
 *
 * @author ADMIN
 */
public class QuestionDao extends DBContext {
    
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> questions = new ArrayList<>();
        QuizDao quizDao = new QuizDao();
        
        String sql = """
                     SELECT [id], [quizId], [content]
                     FROM [Question]
                     WHERE [quizId] = ?
                     ORDER BY [id]
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                
                Quiz quiz = quizDao.getQuizById(rs.getInt("quizId"));
                question.setQuiz(quiz);
                
                question.setContent(rs.getString("content"));
                
                questions.add(question);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return questions;
    }
    
    public Question getQuestionById(int questionId) {
        Question question = null;
        QuizDao quizDao = new QuizDao();
        
        String sql = """
                     SELECT [id], [quizId], [content]
                     FROM [Question]
                     WHERE [id] = ?
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                question = new Question();
                question.setId(rs.getInt("id"));
                
                Quiz quiz = quizDao.getQuizById(rs.getInt("quizId"));
                question.setQuiz(quiz);
                
                question.setContent(rs.getString("content"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return question;
    }
    
    public void createQuestion(Question question) {
        String sql = """
                     INSERT INTO [Question] ([quizId], [content])
                     VALUES (?, ?)
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, question.getQuiz().getId());
            stm.setString(2, question.getContent());
            
            stm.executeUpdate();
            
            // Get the generated ID
            try (ResultSet generatedKeys = stm.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    question.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void updateQuestion(Question question) {
        String sql = """
                     UPDATE [Question]
                     SET [content] = ?
                     WHERE [id] = ?
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, question.getContent());
            stm.setInt(2, question.getId());
            
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void deleteQuestion(int questionId) {
        // First delete all answers associated with this question
        String deleteAnswersSql = "DELETE FROM [Answer] WHERE [questionId] = ?";
        
        try (PreparedStatement stm = connection.prepareStatement(deleteAnswersSql)) {
            stm.setInt(1, questionId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        // Then delete the question
        String deleteQuestionSql = "DELETE FROM [Question] WHERE [id] = ?";
        
        try (PreparedStatement stm = connection.prepareStatement(deleteQuestionSql)) {
            stm.setInt(1, questionId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public int countAnswersByQuestionId(int questionId) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS answerCount FROM [Answer] WHERE [questionId] = ?";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("answerCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return count;
    }
    
    public int countCorrectAnswersByQuestionId(int questionId) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS correctCount FROM [Answer] WHERE [questionId] = ? AND [isCorrect] = 1";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("correctCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return count;
    }
}
