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
 * @author Rinaaaa
 */
public class QuizDao extends DBContext {

    public void create(Quiz quiz) {
        String sql = """
                     INSERT INTO [dbo].[Quiz]( 
                        [teacherId] ,[title] ,[description],
                        [code], [timeLimit], [status])
                     VALUES (?, ?, ?, ?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quiz.getTeacher().getId());
            stm.setNString(2, quiz.getTitle());
            stm.setNString(3, quiz.getDescription());
            stm.setString(4, quiz.getCode());
            stm.setInt(5, quiz.getTimeLimit());
            stm.setString(6, quiz.getStatus());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Quiz get(int id) {
        UserDao userDao = new UserDao();
        Quiz quiz = null;
        String sql = """
                     SELECT [id], [teacherId] ,[title],
                            [description], [code], [timeLimit],
                            [status], [createdAt]
                     FROM [Quiz]
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTeacher(userDao.getUser(rs.getInt("teacherId")));
                quiz.setTitle(rs.getNString("title"));
                quiz.setDescription(rs.getNString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                // Không tải questions ở đây để tránh làm chậm
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quiz;
    }

    public Quiz get(String code) {
        UserDao userDao = new UserDao();
        Quiz quiz = null;
        String sql = """
                     SELECT [id], [teacherId] ,[title],
                            [description], [code], [timeLimit],
                            [status], [createdAt]
                     FROM [Quiz]
                     WHERE [code] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, code);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTeacher(userDao.getUser(rs.getInt("teacherId")));
                quiz.setTitle(rs.getNString("title"));
                quiz.setDescription(rs.getNString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                // Không tải questions ở đây để tránh làm chậm
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quiz;
    }

    public List<Quiz> list(int teacherId) {
        UserDao userDao = new UserDao();
        List<Quiz> quizzes = new ArrayList<>();
        String sql = """
                     SELECT [id], [teacherId], [title], [description], 
                     [code], [timeLimit], [status], [createdAt] FROM [dbo].[Quiz]
                     WHERE [teacherId] = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, teacherId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTeacher(userDao.getUser(rs.getInt("teacherId")));
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                // Không tải questions ở đây để tránh làm chậm
                quizzes.add(quiz);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quizzes;
    }

    public boolean isCodeExists(String code) throws SQLException {
        String sql = "SELECT 1 FROM [Quiz] WHERE [code] = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Thêm phương thức mới để tải questions cho một quiz cụ thể khi cần
    public void loadQuestionsForQuiz(Quiz quiz) {
        if (quiz != null) {
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsByQuizId(quiz.getId());
            quiz.setQuestions(questions);
        }
    }
}
