/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.Question;

/**
 *
 * @author Rinaaaa
 */
public class QuestionDao extends DBContext {
    
    public void create(Question question) {
        String sql = """
                     INSERT INTO [Question] ([quizId], [content]) VALUES (?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, question.getQuiz().getId());
            stm.setNString(2, question.getContent());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public Question get(String input) {
        QuizDao quizDao = new QuizDao();
        Question question = null;
        String sql = """
                     SELECT [id], [quizId], [content]
                     FROM [Question]
                     WHERE [content] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setNString(1, input);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                question = new Question();
                question.setId(rs.getInt("id"));
                question.setQuiz(quizDao.get(rs.getInt("quizId")));
                question.setContent(rs.getNString("content"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return question;
    }
}
