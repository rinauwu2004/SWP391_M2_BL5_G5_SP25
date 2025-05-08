/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.Subject;

public class SubjectDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(SubjectDAO.class.getName());

    public int getTotalSubjects() {
        int total = 0;
        String query = "SELECT COUNT(*) FROM [Subject]";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().connection;
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting subjects: {0}", e.getMessage());
            throw new RuntimeException("Error counting subjects", e);
        }

        return total;
    }

    public List<Subject> getSubjects(int start, int recordsPerPage) {
        List<Subject> subjects = new ArrayList<>();
        String query = "SELECT [id], [code], [name], [description], [status], [created_at], [modified_at] "
                + "FROM [Subject] "
                + "ORDER BY [id] "
                + // You can change this to any column based on your sorting needs
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // SQL Server pagination

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(query)) {

            // Setting parameters for pagination
            stmt.setInt(1, start); // The OFFSET value
            stmt.setInt(2, recordsPerPage); // The number of records per page

            try (ResultSet rs = stmt.executeQuery()) {
                if (conn == null || conn.isClosed()) {
                    LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                    throw new SQLException("Invalid database connection");
                }

                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setId(rs.getInt("id"));
                    subject.setCode(rs.getString("code"));
                    subject.setName(rs.getString("name"));
                    subject.setDescription(rs.getString("description"));
                    subject.setStatus(rs.getBoolean("status"));
                    subject.setCreatedAt(rs.getTimestamp("created_at"));
                    subject.setModifiedAt(rs.getTimestamp("modified_at"));
                    subjects.add(subject);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving subjects: {0}", e.getMessage());
            throw new RuntimeException("Error retrieving subjects", e);
        }

        return subjects;
    }

    public void insertSubject(Subject subject) {
        String query = "INSERT INTO [Subject] "
                + "([code], [name], [description], [status], [created_at], [modified_at]) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                throw new SQLException("Invalid database connection");
            }

            if (subject == null || subject.getCode() == null || subject.getName() == null || subject.getCreatedAt() == null) {
                LOGGER.log(Level.SEVERE, "Invalid subject data provided for insertion");
                throw new IllegalArgumentException("Subject data is incomplete");
            }

            stmt.setString(1, subject.getCode());
            stmt.setString(2, subject.getName());
            stmt.setString(3, subject.getDescription());
            stmt.setBoolean(4, subject.isStatus());
            stmt.setTimestamp(5, new java.sql.Timestamp(subject.getCreatedAt().getTime()));
            stmt.setTimestamp(6, subject.getModifiedAt() != null
                    ? new java.sql.Timestamp(subject.getModifiedAt().getTime()) : null);

            stmt.executeUpdate();

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting subject: {0}", e.getMessage());
            throw new RuntimeException("Error inserting subject", e);
        }
    }

    public Subject getSubjectById(int id) {
        String query = "SELECT [id], [code], [name], [description], [status], [created_at], [modified_at] "
                + "FROM [Subject] WHERE [id] = ?";
        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(query)) {
            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                throw new SQLException("Invalid database connection");
            }
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Subject subject = new Subject();
                    subject.setId(rs.getInt("id"));
                    subject.setCode(rs.getString("code"));
                    subject.setName(rs.getString("name"));
                    subject.setDescription(rs.getString("description"));
                    subject.setStatus(rs.getBoolean("status"));
                    subject.setCreatedAt(rs.getTimestamp("created_at"));
                    subject.setModifiedAt(rs.getTimestamp("modified_at"));
                    return subject;
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving subject by ID {0}: {1}", new Object[]{id, e.getMessage()});
            throw new RuntimeException("Error retrieving subject", e);
        }
    }

    public boolean addSubject(Subject subject) {
        String checkQuery = "SELECT COUNT(*) FROM [Subject] WHERE [code] = ? OR [name] = ?";
        String insertQuery = "INSERT INTO [Subject] ([code], [name], [description], [status], [created_at], [modified_at]) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().connection) {

            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                throw new SQLException("Invalid database connection");
            }

            if (subject == null || subject.getCode() == null || subject.getName() == null || subject.getCreatedAt() == null
                    || subject.getCode().trim().isEmpty() || subject.getName().trim().isEmpty()) {
                LOGGER.log(Level.SEVERE, "Invalid subject data provided for insertion");
                throw new IllegalArgumentException("Subject data is incomplete or invalid");
            }

            // Check for duplicate code or name
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setString(1, subject.getCode().trim());
                checkStmt.setString(2, subject.getName().trim());

                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    LOGGER.log(Level.WARNING, "Subject with same code or name already exists");
                    return false;
                }
            }

            // Proceed with insert
            try (PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
                stmt.setString(1, subject.getCode().trim());
                stmt.setString(2, subject.getName().trim());
                stmt.setString(3, subject.getDescription());
                stmt.setBoolean(4, subject.isStatus());
                stmt.setTimestamp(5, new java.sql.Timestamp(subject.getCreatedAt().getTime()));
                stmt.setTimestamp(6, subject.getModifiedAt() != null
                        ? new java.sql.Timestamp(subject.getModifiedAt().getTime()) : null);

                stmt.executeUpdate();
                return true;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding subject: {0}", e.getMessage());
            throw new RuntimeException("Error adding subject", e);
        }
    }

    public boolean editSubject(String subjectId, String code, String name, String status, String description) {
        String checkSql = "SELECT COUNT(*) FROM [Subject] WHERE (code = ? OR name = ?) AND id <> ?";
        String updateSql = "UPDATE [Subject] SET [code] = ?, [name] = ?, [description] = ?, [status] = ?, [modified_at] = ? "
                + "WHERE [id] = ?";

        try (Connection conn = new DBContext().connection) {

            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                throw new SQLException("Invalid database connection");
            }

            if (subjectId == null || subjectId.trim().isEmpty()
                    || code == null || code.trim().isEmpty()
                    || name == null || name.trim().isEmpty()) {
                LOGGER.log(Level.SEVERE, "Invalid subject data provided for update: ID, code, or name is null or empty");
                return false;
            }

            int id;
            try {
                id = Integer.parseInt(subjectId);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.SEVERE, "Invalid subject ID format: {0}", subjectId);
                return false;
            }

            // Check for duplicate code or name
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, code.trim());
                checkStmt.setString(2, name.trim());
                checkStmt.setInt(3, id);

                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    LOGGER.log(Level.WARNING, "Subject code or name already exists for another subject.");
                    return false;
                }
            }

            // If no duplicates, perform update
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                boolean statusBool = status != null && status.equalsIgnoreCase("true");

                stmt.setString(1, code.trim());
                stmt.setString(2, name.trim());
                stmt.setString(3, description != null ? description.trim() : null);
                stmt.setBoolean(4, statusBool);
                stmt.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));
                stmt.setInt(6, id);

                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating subject with ID {0}: {1}", new Object[]{subjectId, e.getMessage()});
            return false;
        }
    }

    public int getTotalSubjectsFiltered(String search, Boolean status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Subject WHERE 1=1");

        // Gộp điều kiện tìm kiếm tên hoặc mã
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR code LIKE ?)");
        }
        if (status != null) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(index++, "%" + search + "%");  // name
                stmt.setString(index++, "%" + search + "%");  // code
            }
            if (status != null) {
                stmt.setBoolean(index, status);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi khi đếm số môn học có lọc", e);
        }

        return 0;
    }

    public List<Subject> getSubjectsFiltered(String search, Boolean status, int start, int recordsPerPage) {
        List<Subject> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Subject WHERE 1=1");

        // Sửa lại phần search để truy vấn cả 'name' và 'code'
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR code LIKE ?)");
        }
        if (status != null) {
            sql.append(" AND status = ?");
        }

        sql.append(" ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(index++, "%" + search.trim() + "%");  // Tìm kiếm theo 'name'
                stmt.setString(index++, "%" + search.trim() + "%");  // Tìm kiếm theo 'code'
            }
            if (status != null) {
                stmt.setBoolean(index++, status);
            }

            stmt.setInt(index++, start);  // OFFSET
            stmt.setInt(index, recordsPerPage);  // FETCH NEXT

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("id"));
                subject.setCode(rs.getString("code"));
                subject.setName(rs.getString("name"));
                subject.setDescription(rs.getString("description"));
                subject.setStatus(rs.getBoolean("status"));
                subject.setCreatedAt(rs.getTimestamp("created_at"));
                subject.setModifiedAt(rs.getTimestamp("modified_at"));
                list.add(subject);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi khi lấy danh sách môn học có lọc", e);
        }
        return list;
    }

    public boolean deleteSubjectById(int id) {
        String query = "DELETE FROM [Subject] WHERE [id] = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                throw new SQLException("Invalid database connection");
            }

            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting subject with ID {0}: {1}", new Object[]{id, e.getMessage()});
            throw new RuntimeException("Error deleting subject", e);
        }
    }

    public boolean deactivateSubjectById(int id) {
        String query = "UPDATE [Subject] SET [status] = 0, [modified_at] = GETDATE() WHERE [id] = ?";

        try (Connection conn = new DBContext().connection; PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed");
                throw new SQLException("Invalid database connection");
            }

            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deactivating subject with ID {0}: {1}", new Object[]{id, e.getMessage()});
            throw new RuntimeException("Error deactivating subject", e);
        }
    }

    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        String sql = """
                     SELECT [id], [code], [name], [description], [status], [created_at], [modified_at] 
                     FROM [Subject]
                     ORDER BY [name]
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("id"));
                subject.setCode(rs.getString("code"));
                subject.setName(rs.getString("name"));
                subject.setDescription(rs.getString("description"));
                subject.setStatus(rs.getBoolean("status"));
                subject.setCreatedAt(rs.getTimestamp("created_at"));
                subject.setModifiedAt(rs.getTimestamp("modified_at"));
                subjects.add(subject);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return subjects;
    }

    public int countAllSubjects() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS subjectCount FROM [Subject]";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("subjectCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countActiveSubjects() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS subjectCount FROM [Subject] WHERE [status] = 1";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("subjectCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public List<String> getAllSubjectNames() {
        List<String> subjectNames = new ArrayList<>();
        String sql = "SELECT [name] FROM [Subject] WHERE [status] = 1 ORDER BY [name]";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                subjectNames.add(rs.getString("name"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return subjectNames;
    }

    public List<Subject> getSubjectsWithPagination(int offset, int limit) {
        List<Subject> subjects = new ArrayList<>();
        String sql = """
                     SELECT [id], [code], [name], [description], [status], [created_at], [modified_at]
                     FROM [Subject]
                     ORDER BY [name]
                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, offset);
            stm.setInt(2, limit);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("id"));
                subject.setCode(rs.getString("code"));
                subject.setName(rs.getString("name"));
                subject.setDescription(rs.getString("description"));
                subject.setStatus(rs.getBoolean("status"));
                subject.setCreatedAt(rs.getTimestamp("created_at"));
                subject.setModifiedAt(rs.getTimestamp("modified_at"));
                subjects.add(subject);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return subjects;
    }

    public List<Subject> searchSubjects(String searchTerm, String searchBy, int offset, int limit) {
        List<Subject> subjects = new ArrayList<>();
        String sql;

        switch (searchBy) {
            case "code":
                sql = """
                      SELECT [id], [code], [name], [description], [status], [created_at], [modified_at]
                      FROM [Subject]
                      WHERE [code] LIKE ?
                      ORDER BY [name]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "name":
                sql = """
                      SELECT [id], [code], [name], [description], [status], [created_at], [modified_at]
                      FROM [Subject]
                      WHERE [name] LIKE ?
                      ORDER BY [name]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            default:
                sql = """
                      SELECT [id], [code], [name], [description], [status], [created_at], [modified_at]
                      FROM [Subject]
                      WHERE [code] LIKE ? OR [name] LIKE ? OR [description] LIKE ?
                      ORDER BY [name]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "code":
                case "name":
                    stm.setString(1, searchPattern);
                    stm.setInt(2, offset);
                    stm.setInt(3, limit);
                    break;
                default:
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setString(3, searchPattern);
                    stm.setInt(4, offset);
                    stm.setInt(5, limit);
                    break;
            }

            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("id"));
                subject.setCode(rs.getString("code"));
                subject.setName(rs.getString("name"));
                subject.setDescription(rs.getString("description"));
                subject.setStatus(rs.getBoolean("status"));
                subject.setCreatedAt(rs.getTimestamp("created_at"));
                subject.setModifiedAt(rs.getTimestamp("modified_at"));
                subjects.add(subject);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return subjects;
    }

    public int countSearchResults(String searchTerm, String searchBy) {
        int count = 0;
        String sql;

        switch (searchBy) {
            case "code":
                sql = "SELECT COUNT(*) AS subjectCount FROM [Subject] WHERE [code] LIKE ?";
                break;
            case "name":
                sql = "SELECT COUNT(*) AS subjectCount FROM [Subject] WHERE [name] LIKE ?";
                break;
            default:
                sql = "SELECT COUNT(*) AS subjectCount FROM [Subject] WHERE [code] LIKE ? OR [name] LIKE ? OR [description] LIKE ?";
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "code":
                case "name":
                    stm.setString(1, searchPattern);
                    break;
                default:
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setString(3, searchPattern);
                    break;
            }

            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("subjectCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public void createSubject(Subject subject) {
        String sql = """
                     INSERT INTO [Subject] ([code], [name], [description], [status])
                     VALUES (?, ?, ?, ?)
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, subject.getCode());
            stm.setString(2, subject.getName());
            stm.setString(3, subject.getDescription());
            stm.setBoolean(4, subject.isStatus());

            stm.executeUpdate();

            // Get the generated ID
            try (ResultSet generatedKeys = stm.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    subject.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void updateSubject(Subject subject) {
        String sql = """
                     UPDATE [Subject]
                     SET [code] = ?,
                         [name] = ?,
                         [description] = ?,
                         [status] = ?,
                         [modified_at] = GETDATE()
                     WHERE [id] = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, subject.getCode());
            stm.setString(2, subject.getName());
            stm.setString(3, subject.getDescription());
            stm.setBoolean(4, subject.isStatus());
            stm.setInt(5, subject.getId());

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void deleteSubject(int subjectId) {
        String sql = "DELETE FROM [Subject] WHERE [id] = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, subjectId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

//    public static void main(String[] args) {
//        SubjectDAO sdao = new SubjectDAO();
//        String search = "";
//        Boolean status = null;
//
//        List<Subject> subjects = sdao.getSubjectsFiltered(search, status, 0, 5);
//        for (Subject subject : subjects) {
//            System.out.println(subject.toString());
//        }
//
//    }

