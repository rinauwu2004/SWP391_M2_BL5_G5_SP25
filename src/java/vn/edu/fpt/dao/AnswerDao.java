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
import vn.edu.fpt.model.Answer;

/**
 *
 * @author Rinaaaa
 */
public class AnswerDao extends DBContext {

    public void create(Answer answer) {
        String sql = """
                     INSERT INTO [Answer] ([questionId], [content], [isCorrect]) VALUES (?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, answer.getQuestion().getId());
            stm.setNString(2, answer.getContent());
            stm.setBoolean(3, answer.isIsCorrect());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Answer getAnswerById(int id) {
        QuestionDao questionDao = new QuestionDao();
        Answer answer = null;
        String sql = """
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [id] = ?
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                answer = new Answer();
                answer.setId(rs.getInt("id"));
                answer.setQuestion(questionDao.getQuestionById(rs.getInt("questionId")));
                answer.setContent(rs.getNString("content"));
                answer.setIsCorrect(rs.getBoolean("isCorrect"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answer;
    }

    public List<Answer> getAnswersByQuestionId(int questionId) {
        List<Answer> answers = new ArrayList<>();
        QuestionDao questionDao = new QuestionDao();
        String sql = """
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [questionId] = ?
                 ORDER BY [id]
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Answer answer = new Answer();
                answer.setId(rs.getInt("id"));
                answer.setQuestion(questionDao.getQuestionById(rs.getInt("questionId")));
                answer.setContent(rs.getNString("content"));
                answer.setIsCorrect(rs.getBoolean("isCorrect"));
                answers.add(answer);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answers;
    }

    public List<Answer> getCorrectAnswersByQuestionId(int questionId) {
        List<Answer> answers = new ArrayList<>();
        QuestionDao questionDao = new QuestionDao();
        String sql = """
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [questionId] = ? AND [isCorrect] = 1
                 ORDER BY [id]
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Answer answer = new Answer();
                answer.setId(rs.getInt("id"));
                answer.setQuestion(questionDao.getQuestionById(rs.getInt("questionId")));
                answer.setContent(rs.getNString("content"));
                answer.setIsCorrect(rs.getBoolean("isCorrect"));
                answers.add(answer);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answers;
    }
}
