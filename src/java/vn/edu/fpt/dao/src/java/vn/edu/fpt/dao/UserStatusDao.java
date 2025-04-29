/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
}
