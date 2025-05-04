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
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.QuizAttempt;
import vn.edu.fpt.model.QuizAttemptDetail;

/**
 *
 * @author Rinaaaa
 */
public class QuizAttemptDetailDao extends DBContext {

    /**
     * Creates a new quiz attempt detail
     *
     * @param detail The quiz attempt detail to create
     */
    public void create(QuizAttemptDetail detail) {
        String sql = """
                     INSERT INTO [QuizAttemptDetail] 
                     ([attemptId], [questionId], [answerId]) 
                     VALUES (?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, detail.getAttempt().getId());
            stm.setInt(2, detail.getQuestion().getId());
            stm.setInt(3, detail.getAnswer().getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Gets all details for a quiz attempt
     *
     * @param attemptId The ID of the quiz attempt
     * @return A list of quiz attempt details
     */
    public List<QuizAttemptDetail> getByAttempt(int attemptId) {
        List<QuizAttemptDetail> details = new ArrayList<>();
        String sql = """
                     SELECT [id], [attemptId], [questionId], [answerId] 
                     FROM [QuizAttemptDetail] 
                     WHERE [attemptId] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    QuizAttemptDetail detail = new QuizAttemptDetail();
                    detail.setId(rs.getInt("id"));

                    // Load attempt
                    QuizAttemptDao attemptDao = new QuizAttemptDao();
                    QuizAttempt attempt = attemptDao.get(rs.getInt("attemptId"));
                    detail.setAttempt(attempt);

                    // Load question
                    QuestionDao questionDao = new QuestionDao();
                    Question question = questionDao.getQuestionById(rs.getInt("questionId"));
                    detail.setQuestion(question);

                    // Load answer
                    AnswerDao answerDao = new AnswerDao();
                    Answer answer = answerDao.getAnswerById(rs.getInt("answerId"));
                    detail.setAnswer(answer);

                    details.add(detail);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return details;
    }

    /**
     * Gets all selected answers for a question in a quiz attempt
     *
     * @param attemptId The ID of the quiz attempt
     * @param questionId The ID of the question
     * @return A list of selected answers
     */
    public List<Answer> getSelectedAnswers(int attemptId, int questionId) {
        List<Answer> answers = new ArrayList<>();
        String sql = """
                     SELECT a.* 
                     FROM [Answer] a 
                     JOIN [QuizAttemptDetail] d ON a.[id] = d.[answerId] 
                     WHERE d.[attemptId] = ? AND d.[questionId] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            stm.setInt(2, questionId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Answer answer = new Answer();
                    answer.setId(rs.getInt("id"));

                    // Load question
                    QuestionDao questionDao = new QuestionDao();
                    Question question = questionDao.getQuestionById(rs.getInt("questionId"));
                    answer.setQuestion(question);

                    answer.setContent(rs.getString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));

                    answers.add(answer);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answers;
    }
}
