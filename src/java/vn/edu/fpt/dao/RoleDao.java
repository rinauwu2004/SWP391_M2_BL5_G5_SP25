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
import vn.edu.fpt.model.Role;

/**
 *
 * @author Rinaaaa
 */
public class RoleDao extends DBContext {

    public Role get(int id) {
        Role role = null;
        String sql = """
                     SELECT [id], [name], [description]
                     FROM [dbo].[Role]
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
            }    
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return role;
    }
    
    public Role get(String name) {
        Role role = null;
        String sql = """
                     SELECT [id], [name], [description]
                     FROM [dbo].[Role]
                     WHERE [name] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, name);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
            }    
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return role;
    }
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = """
                     SELECT [id], [name], [description]
                     FROM [dbo].[Role]
                     ORDER BY [id]
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                roles.add(role);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RoleDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return roles;
    }
}
