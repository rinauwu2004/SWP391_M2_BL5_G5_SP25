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
import vn.edu.fpt.model.ModuleClass;
import vn.edu.fpt.model.Subject;

public class ModuleDAO extends DBContext {

    public List<ModuleClass> getAllModuleByLessonId(int id) {
        List<ModuleClass> modules = new ArrayList<>();
        String sql = "SELECT id, name, description, url, lesson_id FROM Module WHERE lesson_id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id); // truyền id vào chỗ dấu ? trong câu SQL

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ModuleClass module = new ModuleClass();
                    module.setId(rs.getInt("id"));
                    module.setName(rs.getString("name"));
                    module.setDescription(rs.getString("description"));
                    module.setUrl(rs.getString("url"));

                    LessonDAO lessonDao = new LessonDAO();
                    Lesson lesson = lessonDao.getLessonById(rs.getInt("lesson_id"));
                    module.setLessonId(lesson);

                    modules.add(module);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ModuleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return modules;
    }
    // Lấy danh sách Module theo lessonId, hỗ trợ tìm kiếm và phân trang

    public List<ModuleClass> getModulesByLessonIdWithSearchAndPagination(int lessonId, String search, int offset, int pageSize) {
        List<ModuleClass> modules = new ArrayList<>();
        String sql = "SELECT id, name, description, url, lesson_id "
                + "FROM Module "
                + "WHERE lesson_id = ? AND name LIKE ? "
                + "ORDER BY id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Sử dụng OFFSET và FETCH NEXT trong SQL Server

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set các tham số vào PreparedStatement
            ps.setInt(1, lessonId); // lessonId
            ps.setString(2, "%" + search + "%"); // tìm kiếm theo tên (LIKE)
            ps.setInt(3, offset); // Vị trí bắt đầu (OFFSET)
            ps.setInt(4, pageSize); // Số lượng record trên mỗi trang

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ModuleClass module = new ModuleClass();
                    module.setId(rs.getInt("id"));
                    module.setName(rs.getString("name"));
                    module.setDescription(rs.getString("description"));
                    module.setUrl(rs.getString("url"));

                    // Lấy Lesson từ lesson_id
                    LessonDAO lessonDao = new LessonDAO();
                    Lesson lesson = lessonDao.getLessonById(rs.getInt("lesson_id"));
                    module.setLessonId(lesson);

                    modules.add(module);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ModuleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return modules;
    }

    // Lấy tổng số Module theo lessonId và hỗ trợ tìm kiếm
    public int getTotalModulesByLessonId(int lessonId, String search) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Module "
                + "WHERE lesson_id = ? AND name LIKE ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set các tham số vào PreparedStatement
            ps.setInt(1, lessonId); // lessonId
            ps.setString(2, "%" + search + "%"); // tìm kiếm theo tên (LIKE)

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1); // Lấy kết quả từ COUNT(*)
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ModuleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return total;
    }

// Lấy tên bài học (Lesson Name) theo lessonId
    public String getLessonNameById(int lessonId) {
        String lessonName = null;
        String sql = "SELECT name FROM Lesson WHERE id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set tham số vào PreparedStatement
            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    lessonName = rs.getString("name"); // Lấy tên bài học
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ModuleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return lessonName;
    }

    public ModuleClass getModuleById(int id) {
        ModuleClass module = null;
        String sql = "SELECT id, name, description, url, lesson_id FROM Module WHERE id = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    module = new ModuleClass();
                    module.setId(rs.getInt("id"));
                    module.setName(rs.getString("name"));
                    module.setDescription(rs.getString("description"));
                    module.setUrl(rs.getString("url"));

                    LessonDAO lessonDao = new LessonDAO();
                    Lesson lesson = lessonDao.getLessonById(rs.getInt("lesson_id"));
                    module.setLessonId(lesson);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ModuleDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return module;
    }

    public boolean updateModule(int id, String name, String description, String url) throws SQLException {
        String sql = "UPDATE Module SET name = ?, description = ?, url = ? WHERE id = ?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setString(3, url);
            stmt.setInt(4, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    public boolean createModule(int lessonId, String name, String description, String url) {
        String sql = "INSERT INTO Module (name, description, url, lesson_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setString(3, url);
            stmt.setInt(4, lessonId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteModuleById(int id) {
        String sql = "DELETE FROM Module WHERE id = ?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id); // Truyền id vào chỗ dấu hỏi trong câu lệnh SQL

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // Nếu có bản ghi bị xóa, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Nếu có lỗi xảy ra, trả về false
        }
    }

}
