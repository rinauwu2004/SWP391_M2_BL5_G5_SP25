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
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.UserStatus;

/**
 *
 * @author Rinaaaa
 */
public class UserStatusDao extends DBContext {

    public UserStatus get(int id) {
        UserStatus userStatus = null;
        String sql = """
                     SELECT [id] ,[name]
                     FROM [UserStatus]
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                userStatus = new UserStatus();
                userStatus.setId(rs.getInt("id"));
                userStatus.setName(rs.getString("name"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return userStatus;
    }
    public List<UserStatus> getAllStatuses() {
        List<UserStatus> statuses = new ArrayList<>();
        String sql = """
                     SELECT [id], [name]
                     FROM [UserStatus]
                     ORDER BY [id]
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                UserStatus status = new UserStatus();
                status.setId(rs.getInt("id"));
                status.setName(rs.getString("name"));
                statuses.add(status);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserStatusDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return statuses;
    }

    public UserStatus getByName(String name) {
        UserStatus userStatus = null;
        String sql = """
                     SELECT [id] ,[name]
                     FROM [UserStatus]
                     WHERE [name] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, name);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                userStatus = new UserStatus();
                userStatus.setId(rs.getInt("id"));
                userStatus.setName(rs.getString("name"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return userStatus;
    }
}
