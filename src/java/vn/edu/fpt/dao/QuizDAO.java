/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.model.Quiz;

/**
 *
 * @author ADMIN
 */
public class QuizDAO extends DBContext {
    public List<Quiz> getQuizzes(int page, int pageSize, String search) {
        List<Quiz> quizzes = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM Quiz WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND title LIKE ? ");
        }
        sql.append("ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + search + "%");
            }
            st.setInt(paramIndex++, (page - 1) * pageSize);
            st.setInt(paramIndex, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Quiz q = new Quiz();
                q.setId(rs.getInt("id"));
                q.setTitle(rs.getString("title"));
                q.setSubjectId(rs.getInt("subject_id"));
                q.setDescription(rs.getString("description"));
                q.setDuration(rs.getInt("duration"));
                q.setIsStarted(rs.getBoolean("is_started"));
                quizzes.add(q);
            }
        } catch (SQLException e) {
            System.out.println("Error getting quizzes: " + e.getMessage());
        }
        return quizzes;
    }

    public int getTotalQuizzes(String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Quiz WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND title LIKE ? ");
        }
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex, "%" + search + "%");
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting quizzes: " + e.getMessage());
        }
        return 0;
    }
}
