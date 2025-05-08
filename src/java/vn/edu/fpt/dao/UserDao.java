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
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class UserDao extends DBContext {

    public void addUser(User user) {
        String sql = """
                     INSERT INTO [dbo].[User](
                        [username], [password_hash], [password_salt],
                     	[first_name], [last_name], [date_of_birth],
                        [country_id], [phone_number], [email_address], [address], [role_id])
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, user.getUsername());
            stm.setString(2, user.getHashPassword());
            stm.setString(3, user.getSaltPassword());
            stm.setNString(4, user.getFirstName());
            stm.setNString(5, user.getLastName());
            stm.setDate(6, user.getDob());
            stm.setInt(7, user.getCountry().getId());
            stm.setString(8, user.getPhoneNumber());
            stm.setString(9, user.getEmailAddress());
            stm.setString(10, user.getAddress());
            stm.setInt(11,user.getRole().getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public User getUser(String input) {
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();
        User user = null;
        String sql = """
                 SELECT [id], [username], [password_hash], [password_salt], 
                        [first_name], [last_name], [date_of_birth], 
                        [country_id], [phone_number], [email_address], [address],
                        [status_id], [role_id], [created_at]
                 FROM [User] WHERE [username] = ? OR [email_address] = ?
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, input);
            stm.setString(2, input);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return user;
    }
    
    public User getUser(int id) {
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();
        User user = null;
        String sql = """
                 SELECT [id], [username], [password_hash], [password_salt], 
                        [first_name], [last_name], [date_of_birth], 
                        [country_id], [phone_number], [email_address], [address],
                        [status_id], [role_id], [created_at]
                 FROM [User] WHERE [id] = ?
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return user;
    }
    
    public void changePassword(String input, String hashPassword) {
        String sql = """
                     UPDATE [dbo].[User]
                        SET [password_hash] = ?
                     WHERE [email_address] = ? OR [username] = ? 
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, hashPassword);
            stm.setString(2, input);
            stm.setString(3, input);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public boolean isUsernameTaken(String username) {
        String sql = "SELECT 1 FROM [User] WHERE [username] = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean isEmailTaken(String email) {
        String sql = "SELECT 1 FROM [User] WHERE [email_address] = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean isPhoneTaken(String phone) {
        String sql = "SELECT 1 FROM [User] WHERE [phone_number] = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    public User getUserById(int userId) {
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();
        User user = null;
        String sql = "SELECT [id], [username], [password_hash], [password_salt],\n" +
"                        [first_name], [last_name], [date_of_birth],\n" +
"                        [country_id], [phone_number], [email_address], [address],\n" +
"                        [status_id], [role_id], [created_at]\n" +
"                 FROM [User] WHERE [id] = ?";
              
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return user;
    }
    public List<User> getAllUsers(int offset, int limit) {
        List<User> users = new ArrayList<>();
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();

        String sql = """
                     SELECT [id], [username], [password_hash], [password_salt],
                            [first_name], [last_name], [date_of_birth],
                            [country_id], [phone_number], [email_address], [address],
                            [status_id], [role_id], [created_at]
                     FROM [User]
                     ORDER BY [id]
                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, offset);
            stm.setInt(2, limit);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return users;
    }

    public List<User> getStudentAndTeacherUsers(int offset, int limit) {
        List<User> users = new ArrayList<>();
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();

        String sql = """
                     SELECT [id], [username], [password_hash], [password_salt],
                            [first_name], [last_name], [date_of_birth],
                            [country_id], [phone_number], [email_address], [address],
                            [status_id], [role_id], [created_at]
                     FROM [User]
                     WHERE [role_id] IN (2, 3, 4)
                     ORDER BY [id]
                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, offset);
            stm.setInt(2, limit);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return users;
    }

    public int countAllUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS userCount FROM [User]";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countStudentAndTeacherUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [role_id] IN (2, 3)";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int[] getUserRegistrationsByMonth(int year) {
        int[] monthlyRegistrations = new int[12]; // Array to store counts for each month (0-11)

        String sql = """
                     SELECT MONTH([created_at]) AS month, COUNT(*) AS count
                     FROM [User]
                     WHERE YEAR([created_at]) = ?
                     GROUP BY MONTH([created_at])
                     ORDER BY MONTH([created_at])
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, year);
            ResultSet rs = stm.executeQuery();

            // Initialize all months to 0
            for (int i = 0; i < 12; i++) {
                monthlyRegistrations[i] = 0;
            }

            // Fill in the actual counts
            while (rs.next()) {
                int month = rs.getInt("month");
                int count = rs.getInt("count");
                monthlyRegistrations[month - 1] = count; // Adjust for 0-based array
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return monthlyRegistrations;
    }

    public int countUsersByRole(String roleName) {
        int count = 0;
        String sql = """
                     SELECT COUNT(*) AS userCount
                     FROM [User] u
                     JOIN [Role] r ON u.role_id = r.id
                     WHERE r.name = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, roleName);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countUsersByStatus(String statusName) {
        int count = 0;
        String sql = """
                     SELECT COUNT(*) AS userCount
                     FROM [User] u
                     JOIN [UserStatus] s ON u.status_id = s.id
                     WHERE s.name = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, statusName);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countUsersByStatusId(int statusId) {
        int count = 0;
        String sql = """
                     SELECT COUNT(*) AS userCount
                     FROM [User]
                     WHERE status_id = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, statusId);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countStudentTeachersByStatusId(int statusId) {
        int count = 0;
        String sql = """
                     SELECT COUNT(*) AS userCount
                     FROM [User]
                     WHERE status_id = ? AND role_id IN (2, 3)
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, statusId);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public void updateUser(User user) {
        String sql = """
                     UPDATE [User]
                     SET [first_name] = ?,
                         [last_name] = ?,
                         [date_of_birth] = ?,
                         [phone_number] = ?,
                         [address] = ?,
                         [country_id] = ?,
                         [status_id] = ?
                     WHERE [id] = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setNString(1, user.getFirstName());
            stm.setNString(2, user.getLastName());
            stm.setDate(3, user.getDob());
            stm.setString(4, user.getPhoneNumber());
            stm.setString(5, user.getAddress());
            stm.setInt(6, user.getCountry().getId());
            stm.setInt(7, user.getStatus().getId());
            stm.setInt(8, user.getId());

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void updateUserStatus(int userId, int statusId) {
        String sql = "UPDATE [User] SET [status_id] = ? WHERE [id] = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, statusId);
            stm.setInt(2, userId);

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void deleteUser(int userId) {
        String sql = "DELETE FROM [User] WHERE [id] = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public List<User> searchUsers(String searchTerm, String searchBy, int offset, int limit) {
        List<User> users = new ArrayList<>();
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();

        String sql;

        switch (searchBy) {
            case "username":
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE [username] LIKE ?
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "email":
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE [email_address] LIKE ?
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "name":
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE [first_name] LIKE ? OR [last_name] LIKE ?
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            default:
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE [username] LIKE ? OR [email_address] LIKE ? OR [first_name] LIKE ? OR [last_name] LIKE ?
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "username":
                case "email":
                    stm.setString(1, searchPattern);
                    stm.setInt(2, offset);
                    stm.setInt(3, limit);
                    break;
                case "name":
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setInt(3, offset);
                    stm.setInt(4, limit);
                    break;
                default:
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setString(3, searchPattern);
                    stm.setString(4, searchPattern);
                    stm.setInt(5, offset);
                    stm.setInt(6, limit);
                    break;
            }

            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return users;
    }

    public List<User> searchStudentAndTeacherUsers(String searchTerm, String searchBy, int offset, int limit) {
        List<User> users = new ArrayList<>();
        CountryDao countryDao = new CountryDao();
        RoleDao roleDao = new RoleDao();
        UserStatusDao userStatusDao = new UserStatusDao();

        String sql;

        switch (searchBy) {
            case "username":
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE [username] LIKE ? AND [role_id] IN (2, 3)
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "email":
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE [email_address] LIKE ? AND [role_id] IN (2, 3)
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "name":
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE ([first_name] LIKE ? OR [last_name] LIKE ?) AND [role_id] IN (2, 3)
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            default:
                sql = """
                      SELECT [id], [username], [password_hash], [password_salt],
                             [first_name], [last_name], [date_of_birth],
                             [country_id], [phone_number], [email_address], [address],
                             [status_id], [role_id], [created_at]
                      FROM [User]
                      WHERE ([username] LIKE ? OR [email_address] LIKE ? OR [first_name] LIKE ? OR [last_name] LIKE ?) AND [role_id] IN (2, 3)
                      ORDER BY [id]
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "username":
                case "email":
                    stm.setString(1, searchPattern);
                    stm.setInt(2, offset);
                    stm.setInt(3, limit);
                    break;
                case "name":
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setInt(3, offset);
                    stm.setInt(4, limit);
                    break;
                default:
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setString(3, searchPattern);
                    stm.setString(4, searchPattern);
                    stm.setInt(5, offset);
                    stm.setInt(6, limit);
                    break;
            }

            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setHashPassword(rs.getString("password_hash"));
                user.setSaltPassword(rs.getString("password_salt"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setDob(Date.valueOf(rs.getString("date_of_birth")));
                user.setCountry(countryDao.get(rs.getInt("country_id")));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmailAddress(rs.getString("email_address"));
                user.setAddress(rs.getString("address"));
                user.setStatus(userStatusDao.get(rs.getInt("status_id")));
                user.setRole(roleDao.get(rs.getInt("role_id")));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return users;
    }

    public int countSearchResults(String searchTerm, String searchBy) {
        int count = 0;
        String sql;

        switch (searchBy) {
            case "username":
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [username] LIKE ?";
                break;
            case "email":
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [email_address] LIKE ?";
                break;
            case "name":
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [first_name] LIKE ? OR [last_name] LIKE ?";
                break;
            default:
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [username] LIKE ? OR [email_address] LIKE ? OR [first_name] LIKE ? OR [last_name] LIKE ?";
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "username":
                case "email":
                    stm.setString(1, searchPattern);
                    break;
                case "name":
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    break;
                default:
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setString(3, searchPattern);
                    stm.setString(4, searchPattern);
                    break;
            }

            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countStudentAndTeacherSearchResults(String searchTerm, String searchBy) {
        int count = 0;
        String sql;

        switch (searchBy) {
            case "username":
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [username] LIKE ? AND [role_id] IN (2, 3)";
                break;
            case "email":
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE [email_address] LIKE ? AND [role_id] IN (2, 3)";
                break;
            case "name":
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE ([first_name] LIKE ? OR [last_name] LIKE ?) AND [role_id] IN (2, 3)";
                break;
            default:
                sql = "SELECT COUNT(*) AS userCount FROM [User] WHERE ([username] LIKE ? OR [email_address] LIKE ? OR [first_name] LIKE ? OR [last_name] LIKE ?) AND [role_id] IN (2, 3)";
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "username":
                case "email":
                    stm.setString(1, searchPattern);
                    break;
                case "name":
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    break;
                default:
                    stm.setString(1, searchPattern);
                    stm.setString(2, searchPattern);
                    stm.setString(3, searchPattern);
                    stm.setString(4, searchPattern);
                    break;
            }

            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                count = rs.getInt("userCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

}
