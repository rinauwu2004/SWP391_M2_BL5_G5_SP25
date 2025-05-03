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
import vn.edu.fpt.model.Country;

/**
 *
 * @author Rinaaaa
 */
public class CountryDao extends DBContext{
    public List<Country> getAllCountries() {
        return list();
    }
    public List<Country> list(){
        List<Country> countries = new ArrayList<>();
        String sql = """
                     SELECT [id], [name], [code], [prefix]
                     FROM [dbo].[Country]
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)){
            ResultSet rs = stm.executeQuery();
            while(rs.next()){
                Country country = new Country();
                country.setId(rs.getInt("id"));
                country.setName(rs.getNString("name"));
                country.setCode(rs.getString("code"));
                country.setPrefix(rs.getString("prefix"));
                countries.add(country);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CountryDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return countries;
    }
    
    public Country get(String code){
        Country country = null;
        String sql = """
                     SELECT [id] ,[name] ,[code] ,[prefix]
                     FROM [dbo].[Country]
                     WHERE [name] = ? or [code] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, code);
            stm.setString(2, code);
            ResultSet rs = stm.executeQuery();
            if (rs.next()){
                country = new Country();
                country.setId(rs.getInt("id"));
                country.setName(rs.getNString("name"));
                country.setCode(rs.getString("code"));
                country.setPrefix(rs.getString("prefix"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CountryDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return country;
    }
    
    public Country get(int id){
        Country country = null;
        String sql = """
                     SELECT [id] ,[name] ,[code] ,[prefix]
                     FROM [dbo].[Country]
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()){
                country = new Country();
                country.setId(rs.getInt("id"));
                country.setName(rs.getNString("name"));
                country.setCode(rs.getString("code"));
                country.setPrefix(rs.getString("prefix"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CountryDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return country;
    }
}
