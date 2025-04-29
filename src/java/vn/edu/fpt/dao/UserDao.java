/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
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
        String sql = """
                 SELECT [id], [username], [password_hash], [password_salt],
                        [first_name], [last_name], [date_of_birth],
                        [country_id], [phone_number], [email_address], [address],
                        [status_id], [role_id], [created_at]
                 FROM [User] WHERE [id] = ?
                 """;
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
}
