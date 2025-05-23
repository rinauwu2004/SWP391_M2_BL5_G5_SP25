/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.Lesson;
import vn.edu.fpt.model.Subject;

public class LessonDAO extends DBContext {

    public List<Lesson> getAllLesson() {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT id, name, description, subject_id, status, modified_at, created_at FROM Lesson";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Lesson lesson = new Lesson();
                lesson.setId(rs.getInt("id"));
                lesson.setName(rs.getString("name"));
                lesson.setDescription(rs.getString("description"));

                SubjectDAO subjectDao = new SubjectDAO();
                Subject subject = subjectDao.getSubjectById(rs.getInt("subject_id"));
                lesson.setSubjectId(subject);

                lesson.setStatus(rs.getInt("status"));
                lesson.setModifiedAt(rs.getTimestamp("modified_at"));
                lesson.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(lesson);
            }

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public Lesson getLessonById(int id) {
        Lesson lesson = null;
        String sql = "SELECT id, name, description, subject_id, status, modified_at, created_at FROM Lesson WHERE id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("name"));
                    lesson.setDescription(rs.getString("description"));

                    SubjectDAO subjectDao = new SubjectDAO();
                    Subject subject = subjectDao.getSubjectById(rs.getInt("subject_id"));
                    lesson.setSubjectId(subject);

                    lesson.setStatus(rs.getInt("status"));
                    lesson.setModifiedAt(rs.getTimestamp("modified_at"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return lesson;
    }

    public boolean updateLesson(int id, String lessonName, String description, int status) {
        String checkSql = "SELECT COUNT(*) FROM Lesson WHERE name = ? AND id <> ?";
        String updateSql = "UPDATE Lesson SET name = ?, description = ?, status = ?, modified_at = GETDATE() WHERE id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            // Kiểm tra xem tên bài học đã tồn tại chưa (trừ bài học đang sửa)
            checkPs.setString(1, lessonName);
            checkPs.setInt(2, id);

            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Tên bài học đã tồn tại
                System.out.println("Lesson name already exists.");
                return false;
            }

            // Nếu không trùng thì tiến hành cập nhật
            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                updatePs.setString(1, lessonName);
                updatePs.setString(2, description);
                updatePs.setInt(3, status);
                updatePs.setInt(4, id);

                updatePs.executeUpdate();
            }

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        return true;
    }

    public boolean createLesson(String lessonName, String description, int status, int subjectId) {
    String checkSql = "SELECT COUNT(*) FROM Lesson WHERE name = ? AND subject_id = ?";
    String insertSql = "INSERT INTO Lesson (name, description, subject_id, status, created_at, modified_at) "
            + "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

    try (Connection conn = new DBContext().connection;
         PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

        // Kiểm tra trùng tên bài học trong cùng subject
        checkPs.setString(1, lessonName);
        checkPs.setInt(2, subjectId);

        ResultSet rs = checkPs.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            System.out.println("Lesson name already exists in this subject.");
            return false;
        }

        // Nếu không trùng thì tạo mới
        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
            insertPs.setString(1, lessonName);
            insertPs.setString(2, description);
            insertPs.setInt(3, subjectId);
            insertPs.setInt(4, status);

            int rowsAffected = insertPs.executeUpdate();
            return rowsAffected > 0;
        }

    } catch (SQLException ex) {
        Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    }
}

    public List<Lesson> getAllLessonBySubjectId(int subjectId) {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT id, name, description, subject_id, status, modified_at, created_at FROM Lesson WHERE subject_id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("name"));
                    lesson.setDescription(rs.getString("description"));

                    SubjectDAO subjectDao = new SubjectDAO();
                    Subject subject = subjectDao.getSubjectById(rs.getInt("subject_id"));
                    lesson.setSubjectId(subject);

                    lesson.setStatus(rs.getInt("status"));
                    lesson.setModifiedAt(rs.getTimestamp("modified_at"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));

                    list.add(lesson);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public List<Lesson> searchLessonBySubjectId(int subjectId, String search, Integer status) {
        List<Lesson> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, name, description, subject_id, status, modified_at, created_at FROM Lesson WHERE subject_id = ?");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (status != null) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, subjectId);

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null) {
                ps.setInt(paramIndex++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("name"));
                    lesson.setDescription(rs.getString("description"));

                    SubjectDAO subjectDao = new SubjectDAO();
                    Subject subject = subjectDao.getSubjectById(rs.getInt("subject_id"));
                    lesson.setSubjectId(subject);

                    lesson.setStatus(rs.getInt("status"));
                    lesson.setModifiedAt(rs.getTimestamp("modified_at"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));

                    list.add(lesson);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public int countLessonBySubjectId(int subjectId, String search, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Lesson WHERE subject_id = ?");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (status != null) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, subjectId);
            int paramIndex = 2;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null) {
                ps.setInt(paramIndex++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public List<Lesson> searchLessonBySubjectIdWithPagination(int subjectId, String search, Integer status, int offset, int pageSize) {
        List<Lesson> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, name, description, subject_id, status, modified_at, created_at FROM Lesson WHERE subject_id = ?");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (status != null) {
            sql.append(" AND status = ?");
        }
        sql.append(" ORDER BY id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, subjectId);
            int paramIndex = 2;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null) {
                ps.setInt(paramIndex++, status);
            }
            ps.setInt(paramIndex++, offset);    // OFFSET
            ps.setInt(paramIndex, pageSize);    // FETCH NEXT

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("name"));
                    lesson.setDescription(rs.getString("description"));

                    SubjectDAO subjectDao = new SubjectDAO();
                    Subject subject = subjectDao.getSubjectById(rs.getInt("subject_id"));
                    lesson.setSubjectId(subject);

                    lesson.setStatus(rs.getInt("status"));
                    lesson.setModifiedAt(rs.getTimestamp("modified_at"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));

                    list.add(lesson);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public boolean deleteLessonById(int id) {
        String sql = "DELETE FROM Lesson WHERE id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            // Set the id parameter for the DELETE query
            ps.setInt(1, id);

            // Execute the DELETE statement
            int rowsAffected = ps.executeUpdate();

            // Return true if a row was affected (i.e., a lesson was deleted)
            return rowsAffected > 0;

        } catch (SQLException ex) {
            Logger.getLogger(LessonDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false; // Return false if there was an error during deletion
        }
    }

}
