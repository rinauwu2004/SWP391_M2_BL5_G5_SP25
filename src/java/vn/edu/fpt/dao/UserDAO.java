/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.model.Role;
import vn.edu.fpt.model.User;

/**
 * Data Access Object for User-related database operations
 * @author ADMIN
 */
public class UserDAO extends DBContext {
    
    /**
     * Get all roles for a specific user to display in UI
     * @param userId User ID
     * @return Comma-separated string of role names
     */
    public String getUserRolesAsString(int userId) {
        StringBuilder roles = new StringBuilder();
        String sql = "SELECT r.name FROM [UserRole] ur "
                + "JOIN [Role] r ON ur.role_id = r.id "
                + "WHERE ur.user_id = ? "
                + "ORDER BY r.name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    roles.append(", ");
                }
                roles.append(rs.getString("name"));
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error getting user roles as string: " + e.getMessage());
        }
        return roles.toString();
    }

    /**
     * Get all users with pagination and filtering
     * @param page Current page number
     * @param pageSize Number of records per page
     * @param searchKeyword Search term for name or email
     * @param roleFilter Filter by role ID
     * @param statusFilter Filter by status name
     * @return List of User objects
     */
    public List<User> getAllUsers(int page, int pageSize, String searchKeyword, String roleFilter, String statusFilter) {
        List<User> users = new ArrayList<>();
        
        // Use a subquery with ROW_NUMBER() instead of DISTINCT with TEXT columns
        StringBuilder sql = new StringBuilder();
        sql.append("WITH UserCTE AS ( ");
        sql.append("    SELECT u.id, u.username, u.password_hash, u.password_salt, ");
        sql.append("           u.first_name, u.last_name, u.date_of_birth, u.phone_number, ");
        sql.append("           u.email_address, u.address, u.status_id, u.created_at, ");
        sql.append("           s.name as status_name, r.id as role_id, r.name as role_name, ");
        sql.append("           ROW_NUMBER() OVER(PARTITION BY u.id ORDER BY u.id) as RowNum ");
        sql.append("    FROM [User] u ");
        sql.append("    JOIN [UserStatus] s ON u.status_id = s.id ");
        sql.append("    JOIN [UserRole] ur ON u.id = ur.user_id ");
        sql.append("    JOIN [Role] r ON ur.role_id = r.id ");
        // Only show users who have at least one role that's not role_id 1
        sql.append("    WHERE u.id IN (SELECT user_id FROM [UserRole] WHERE role_id != 1) ");
        
        // Role filter applies to any role the user has (not just their primary role)
        if (roleFilter != null && !roleFilter.trim().isEmpty()) {
            sql.append("AND u.id IN (SELECT user_id FROM [UserRole] WHERE role_id = ?) ");
        }
        
        // Add search condition
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (u.first_name + ' ' + u.last_name LIKE ? OR u.email_address LIKE ? OR u.username LIKE ?) ");
        }
        
        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("AND s.name = ? ");
        }
        
        sql.append(") ");
        sql.append("SELECT * FROM UserCTE WHERE RowNum = 1 ");
        sql.append("ORDER BY id ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            // Set role filter parameter
            if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(roleFilter));
            }
            
            // Set search parameters
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
            }
            
            // Set status filter parameter
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                st.setString(paramIndex++, statusFilter);
            }
            
            // Set pagination parameters
            st.setInt(paramIndex++, (page - 1) * pageSize);
            st.setInt(paramIndex, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword_hash(rs.getString("password_hash"));
                user.setPassword_salt(rs.getString("password_salt"));
                user.setFirst_name(rs.getString("first_name"));
                user.setLast_name(rs.getString("last_name"));
                user.setDate_of_birth(rs.getDate("date_of_birth"));
                user.setPhone_number(rs.getString("phone_number"));
                user.setEmail_address(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus_id(rs.getInt("status_id"));
                user.setStatus_name(rs.getString("status_name"));
                user.setCreated_at(rs.getDate("created_at"));
                user.setRole_id(rs.getInt("role_id"));  // This will be just one role
                user.setRole_name(rs.getString("role_name"));
                
                // Get all roles for this user as a string
                String allRoles = getUserRolesAsString(user.getId());
                if (!allRoles.isEmpty()) {
                    user.setRole_name(allRoles);  // Override with all roles
                }
                
                users.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error getting users: " + e.getMessage());
        }
        return users;
    }
    
    /**
     * Count total number of users matching the filter criteria
     * @param searchKeyword Search term for name or email
     * @param roleFilter Filter by role ID
     * @param statusFilter Filter by status name
     * @return Total count of matching users
     */
    public int getTotalUsers(String searchKeyword, String roleFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT u.id) FROM [User] u ");
        sql.append("JOIN [UserStatus] s ON u.status_id = s.id ");
        sql.append("JOIN [UserRole] ur ON u.id = ur.user_id ");
        sql.append("JOIN [Role] r ON ur.role_id = r.id ");
        // Only count users who have at least one role that's not role_id 1
        sql.append("WHERE u.id IN (SELECT user_id FROM [UserRole] WHERE role_id != 1) ");
        
        // Role filter now applies to any role the user has
        if (roleFilter != null && !roleFilter.trim().isEmpty()) {
            sql.append("AND u.id IN (SELECT user_id FROM [UserRole] WHERE role_id = ?) ");
        }
        
        // Add search condition
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (u.first_name + ' ' + u.last_name LIKE ? OR u.email_address LIKE ? OR u.username LIKE ?) ");
        }
        
        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("AND s.name = ? ");
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            // Set role filter parameter
            if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(roleFilter));
            }
            
            // Set search parameters
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
            }
            
            // Set status filter parameter
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                st.setString(paramIndex++, statusFilter);
            }
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting users: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Get all available roles for filtering and assignment
     * @return List of Role objects
     */
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM [Role]";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                roles.add(role);
            }
        } catch (SQLException e) {
            System.out.println("Error getting roles: " + e.getMessage());
        }
        
        return roles;
    }
    
    /**
     * Update a user's status
     * @param userId The user ID
     * @param statusId The new status ID
     * @return true if the update was successful
     */
    public boolean updateUserStatus(int userId, int statusId) {
        String sql = "UPDATE [User] SET status_id = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, statusId);
            st.setInt(2, userId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user status: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get status ID by status name
     * @param statusName The name of the status
     * @return The status ID
     */
    public int getStatusIdByName(String statusName) {
        String sql = "SELECT id FROM [UserStatus] WHERE name = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, statusName);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            System.out.println("Error getting status ID: " + e.getMessage());
        }
        return 0; // Default to 0 if not found
    }
    
    /**
     * Check if username already exists
     * @param username The username to check
     * @return true if the username exists
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM [User] WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking username existence: " + e.getMessage());
        }
        return false;
    }

    /**
     * Check if email already exists
     * @param email The email to check
     * @return true if the email exists
     */
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM [User] WHERE email_address = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking email existence: " + e.getMessage());
        }
        return false;
    }

    /**
     * Check if phone number already exists
     * @param phone The phone number to check
     * @return true if the phone number exists
     */
    public boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM [User] WHERE phone_number = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, phone);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking phone existence: " + e.getMessage());
        }
        return false;
    }

    /**
     * Create a new user with all fields
     * @param username Username
     * @param passwordHash Password hash
     * @param passwordSalt Password salt
     * @param firstName First name
     * @param lastName Last name
     * @param dateOfBirth Date of birth
     * @param phoneNumber Phone number
     * @param emailAddress Email address
     * @param address Address
     * @param statusId Status ID
     * @param createdAt Creation timestamp
     * @return User ID if successful, -1 if failed
     */
    public int createUser(String username, String passwordHash, String passwordSalt, 
                         String firstName, String lastName, java.sql.Date dateOfBirth, 
                         String phoneNumber, String emailAddress, String address, 
                         int statusId, java.sql.Timestamp createdAt) {
        String sql = "INSERT INTO [User] (username, password_hash, password_salt, " +
                    "first_name, last_name, date_of_birth, phone_number, email_address, " +
                    "address, status_id, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, username);
            st.setString(2, passwordHash);
            st.setString(3, passwordSalt);
            st.setString(4, firstName);
            st.setString(5, lastName);
            st.setDate(6, dateOfBirth);
            st.setString(7, phoneNumber);
            st.setString(8, emailAddress);
            st.setString(9, address);
            st.setInt(10, statusId);
            st.setTimestamp(11, createdAt);
            
            int rowsAffected = st.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating user: " + e.getMessage());
            e.printStackTrace(); // Add this for more detailed error information
        }
        return -1;
    }

    /**
     * Assign a role to a user
     * @param userId User ID
     * @param roleId Role ID
     * @return true if successful
     */
    public boolean assignRoleToUser(int userId, int roleId) {
        String sql = "INSERT INTO [UserRole] (user_id, role_id) VALUES (?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, roleId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error assigning role to user: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get role name by ID
     * @param roleId Role ID
     * @return Role name or empty string if not found
     */
    public String getRoleNameById(int roleId) {
        String sql = "SELECT name FROM [Role] WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            System.out.println("Error getting role name: " + e.getMessage());
        }
        return "";
    }
    
    /**
     * Get user by ID
     * @param userId User ID
     * @return User object or null if not found
     */
    public User getUserById(int userId) {
        String sql = "SELECT u.*, s.name as status_name " +
                     "FROM [User] u " +
                     "JOIN [UserStatus] s ON u.status_id = s.id " +
                     "WHERE u.id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword_hash(rs.getString("password_hash"));
                user.setPassword_salt(rs.getString("password_salt"));
                user.setFirst_name(rs.getString("first_name"));
                user.setLast_name(rs.getString("last_name"));
                user.setDate_of_birth(rs.getDate("date_of_birth"));
                user.setPhone_number(rs.getString("phone_number"));
                user.setEmail_address(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus_id(rs.getInt("status_id"));
                user.setStatus_name(rs.getString("status_name"));
                user.setCreated_at(rs.getTimestamp("created_at"));
                
                // Get all roles for this user as a string
                String allRoles = getUserRolesAsString(user.getId());
                if (!allRoles.isEmpty()) {
                    user.setRole_name(allRoles);
                }
                
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Get list of role IDs assigned to a user
     * @param userId User ID
     * @return List of role IDs
     */
    public List<Integer> getUserRoleIds(int userId) {
        List<Integer> roleIds = new ArrayList<>();
        String sql = "SELECT role_id FROM [UserRole] WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                roleIds.add(rs.getInt("role_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting user role IDs: " + e.getMessage());
        }
        return roleIds;
    }
    
    /**
     * Update user information
     * @param user User object with updated information
     * @return true if update was successful
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE [User] SET " +
                     "username = ?, password_hash = ?, password_salt = ?, " +
                     "first_name = ?, last_name = ?, date_of_birth = ?, " +
                     "phone_number = ?, email_address = ?, address = ?, " +
                     "status_id = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword_hash());
            st.setString(3, user.getPassword_salt());
            st.setString(4, user.getFirst_name());
            st.setString(5, user.getLast_name());
            st.setDate(6, new java.sql.Date(user.getDate_of_birth().getTime()));
            st.setString(7, user.getPhone_number());
            st.setString(8, user.getEmail_address());
            st.setString(9, user.getAddress());
            st.setInt(10, user.getStatus_id());
            st.setInt(11, user.getId());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Clear all roles assigned to a user
     * @param userId User ID
     * @return true if successful
     */
    public boolean clearUserRoles(int userId) {
        String sql = "DELETE FROM [UserRole] WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error clearing user roles: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get all user statuses
     * @return List of UserStatus objects
     */
    public List<vn.edu.fpt.model.UserStatus> getAllUserStatuses() {
        List<vn.edu.fpt.model.UserStatus> statuses = new ArrayList<>();
        String sql = "SELECT * FROM [UserStatus]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                vn.edu.fpt.model.UserStatus status = new vn.edu.fpt.model.UserStatus();
                status.setId(rs.getInt("id"));
                status.setName(rs.getString("name"));
                statuses.add(status);
            }
        } catch (SQLException e) {
            System.out.println("Error getting user statuses: " + e.getMessage());
        }
        return statuses;
    }

    // --- Dashboard Statistics ---
    /**
     * Đếm số lượng sinh viên (role là Student)
     */
    public int getTotalStudents() {
        String sql = "SELECT COUNT(DISTINCT u.id) FROM [User] u JOIN [UserRole] ur ON u.id = ur.user_id JOIN [Role] r ON ur.role_id = r.id WHERE r.name = 'Student'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getTotalStudents: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Đếm số lượt làm bài (QuizResult)
     */
    public int getTotalQuizAttempts() {
        String sql = "SELECT COUNT(*) FROM [QuizResult]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getTotalQuizAttempts: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Đếm số lượng quiz
     */
    public int getTotalQuizzes() {
        String sql = "SELECT COUNT(*) FROM [Quiz]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getTotalQuizzes: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Đếm số lượng môn học (Subject)
     */
    public int getTotalSubjects() {
        String sql = "SELECT COUNT(*) FROM [Subject]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getTotalSubjects: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Đếm tổng số câu hỏi
     */
    public int getTotalQuestions() {
        String sql = "SELECT COUNT(*) FROM [Question]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error getTotalQuestions: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy điểm trung bình của từng quiz
     * @return List<Object[]>: [quiz_title, avg_score]
     */
    public List<Object[]> getAverageScorePerQuiz() {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT q.tilte, AVG(qr.score) as avg_score FROM [Quiz] q LEFT JOIN [QuizResult] qr ON q.id = qr.quiz_id GROUP BY q.tilte";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getString("tilte"), rs.getDouble("avg_score")});
            }
        } catch (SQLException e) {
            System.out.println("Error getAverageScorePerQuiz: " + e.getMessage());
        }
        return result;
    }

    /**
     * Thống kê kết quả theo môn học (Subject)
     * @return List<Object[]>: [subject_name, avg_score, total_attempts]
     */
    public List<Object[]> getResultStatsBySubject() {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT s.name, AVG(qr.score) as avg_score, COUNT(qr.id) as total_attempts " +
                "FROM [Subject] s " +
                "LEFT JOIN [Quiz] q ON s.id = q.subject_id " +
                "LEFT JOIN [QuizResult] qr ON q.id = qr.quiz_id " +
                "GROUP BY s.name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getString("name"), rs.getDouble("avg_score"), rs.getInt("total_attempts")});
            }
        } catch (SQLException e) {
            System.out.println("Error getResultStatsBySubject: " + e.getMessage());
        }
        return result;
    }

    /**
     * Đếm số lượng user theo role
     * @return List<Object[]>: [role_name, count]
     */
    public List<Object[]> getUserCountByRole() {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT r.name, COUNT(u.id) as total FROM [Role] r LEFT JOIN [UserRole] ur ON r.id = ur.role_id LEFT JOIN [User] u ON ur.user_id = u.id GROUP BY r.name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getString("name"), rs.getInt("total")});
            }
        } catch (SQLException e) {
            System.out.println("Error getUserCountByRole: " + e.getMessage());
        }
        return result;
    }

    /**
     * Đếm số lượng câu hỏi theo quiz
     * @return List<Object[]>: [quiz_title, count]
     */
    public List<Object[]> getQuestionCountByQuiz() {
        List<Object[]> result = new ArrayList<>();
        String sql = "  SELECT q.title, COUNT(qq.question_id) as total FROM [Quiz] q LEFT JOIN [QuizQuestion] qq ON q.id = qq.quiz_id GROUP BY q.title";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getString("title"), rs.getInt("total")});
            }
        } catch (SQLException e) {
            System.out.println("Error getQuestionCountByQuiz: " + e.getMessage());
        }
        return result;
    }

    /**
     * Đếm số quiz theo subject
     * @return List<Object[]>: [subject_name, quiz_count]
     */
    public List<Object[]> getQuizCountBySubject() {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT s.name, COUNT(q.id) as quiz_count FROM [Subject] s LEFT JOIN [Quiz] q ON s.id = q.subject_id GROUP BY s.name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getString("name"), rs.getInt("quiz_count")});
            }
        } catch (SQLException e) {
            System.out.println("Error getQuizCountBySubject: " + e.getMessage());
        }
        return result;
    }

    /**
     * Đếm số lượt làm bài theo quiz
     * @return List<Object[]>: [quiz_title, attempt_count]
     */
    public List<Object[]> getAttemptCountByQuiz() {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT q.title, COUNT(qr.id) as attempt_count FROM [Quiz] q LEFT JOIN [QuizResult] qr ON q.id = qr.quiz_id GROUP BY q.title";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result.add(new Object[]{rs.getString("title"), rs.getInt("attempt_count")});
            }
        } catch (SQLException e) {
            System.out.println("Error getAttemptCountByQuiz: " + e.getMessage());
        }
        return result;
    }
}
