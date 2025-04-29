package vn.edu.fpt.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.model.User;
import vn.edu.fpt.util.PasswordHash;

/**
 *
 * @author ADMIN
 */
public class AuthDAO extends DBContext {
    
    /**
     * Check login with either username or email
     * @param usernameOrEmail Either username or email
     * @param password Plain password (will be verified with hash)
     * @return User object if login successful, null otherwise
     */
    public User checkLogin(String usernameOrEmail, String password) {
        String sql = "SELECT u.*, s.name as status_name FROM [User] u "
                + "JOIN [UserStatus] s ON u.status_id = s.id "
                + "WHERE (u.username = ? OR u.email_address = ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, usernameOrEmail);
            st.setString(2, usernameOrEmail);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                // Get user data
                String storedHash = rs.getString("password_hash");
                String storedSalt = rs.getString("password_salt");
                String statusName = rs.getString("status_name");
                int statusId = rs.getInt("status_id");
                
                // Only proceed for active accounts
                if (!statusName.equals("Active")) {
                    User user = new User();
                    user.setStatus_id(statusId);
                    user.setStatus_name(statusName);
                    return user;
                }
                
                // Verify password with proper error handling
                try {
                    // Check if we have valid hash and salt
                    if (storedHash == null || storedSalt == null || 
                        storedHash.isEmpty() || storedSalt.isEmpty()) {
                        System.out.println("Invalid stored hash or salt for user: " + usernameOrEmail);
                        return null;
                    }
                    
                    if (PasswordHash.verifyPassword(password, storedHash, storedSalt)) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setPassword_hash(storedHash);
                        user.setPassword_salt(storedSalt);
                        user.setFirst_name(rs.getString("first_name"));
                        user.setLast_name(rs.getString("last_name"));
                        user.setDate_of_birth(rs.getDate("date_of_birth"));
                        user.setPhone_number(rs.getString("phone_number"));
                        user.setEmail_address(rs.getString("email_address"));
                        user.setAddress(rs.getString("address"));
                        user.setStatus_id(statusId);
                        user.setStatus_name(statusName);
                        user.setCreated_at(rs.getDate("created_at"));
                        return user;
                    }
                } catch (Exception e) {
                    System.out.println("Error verifying password: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking login: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Get all roles for a specific user
     * @param userId User ID
     * @return List of User objects with role information
     */
    public List<User> getUserRoles(int userId) {
        List<User> userRoles = new ArrayList<>();
        String sql = "SELECT r.id, r.name FROM [UserRole] ur "
                + "JOIN [Role] r ON ur.role_id = r.id "
                + "WHERE ur.user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User userRole = new User();
                userRole.setId(userId);
                userRole.setRole_id(rs.getInt("id"));
                userRole.setRole_name(rs.getString("name"));
                userRoles.add(userRole);
            }
        } catch (SQLException e) {
            System.out.println("Error getting user roles: " + e.getMessage());
        }
        return userRoles;
    }
    
    /**
     * Get a specific role for a user
     * @param userId User ID
     * @param roleId Role ID
     * @return User object with role information
     */
    public User getUserWithRole(int userId, int roleId) {
        String sql = "SELECT u.*, r.name as role_name, s.name as status_name FROM [User] u "
                + "JOIN [UserRole] ur ON u.id = ur.user_id "
                + "JOIN [Role] r ON ur.role_id = r.id "
                + "JOIN [UserStatus] s ON u.status_id = s.id "
                + "WHERE u.id = ? AND r.id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, roleId);
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
                user.setCreated_at(rs.getDate("created_at"));
                user.setRole_id(roleId);
                user.setRole_name(rs.getString("role_name"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error getting user with role: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Create a new user with properly hashed password
     * @param user User object with plain password
     * @param plainPassword The plain text password to hash
     * @return true if user was created successfully, false otherwise
     */
    public boolean createUser(User user, String plainPassword) {
        // Generate password hash and salt
        String[] hashAndSalt = PasswordHash.generatePasswordHash(plainPassword);
        if (hashAndSalt[0] == null || hashAndSalt[1] == null) {
            return false;
        }
        
        String sql = "INSERT INTO [User] (username, password_hash, password_salt, first_name, last_name, "
                + "date_of_birth, phone_number, email_address, address, status_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getUsername());
            st.setString(2, hashAndSalt[0]); // Hash
            st.setString(3, hashAndSalt[1]); // Salt
            st.setString(4, user.getFirst_name());
            st.setString(5, user.getLast_name());
            st.setDate(6, new java.sql.Date(user.getDate_of_birth().getTime()));
            st.setString(7, user.getPhone_number());
            st.setString(8, user.getEmail_address());
            st.setString(9, user.getAddress());
            st.setInt(10, user.getStatus_id());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error creating user: " + e.getMessage());
            return false;
        }
    }
}
