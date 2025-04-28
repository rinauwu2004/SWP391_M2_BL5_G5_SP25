/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
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
}
