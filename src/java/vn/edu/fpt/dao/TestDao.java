/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
public class TestDao extends DBContext {

    public int countAllTests() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS testCount FROM [Quiz]";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("testCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TestDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countActiveTests() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS testCount FROM [Quiz] WHERE [status] = 'Active'";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("testCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TestDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countAllTestAttempts() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS attemptCount FROM [QuizAttempt]";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("attemptCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TestDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int countCompletedTestAttempts() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS attemptCount FROM [QuizAttempt] WHERE [submittedTime] IS NOT NULL";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("attemptCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TestDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public int[] getTestAttemptsByMonth(int year) {
        int[] monthlyAttempts = new int[12]; // Array to store counts for each month (0-11)

        String sql = """
                     SELECT MONTH([startedTime]) AS month, COUNT(*) AS count
                     FROM [QuizAttempt]
                     WHERE YEAR([startedTime]) = ?
                     GROUP BY MONTH([startedTime])
                     ORDER BY MONTH([startedTime])
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, year);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                int month = rs.getInt("month");
                int count = rs.getInt("count");
                monthlyAttempts[month - 1] = count; // Adjust for 0-based array
            }
        } catch (SQLException ex) {
            Logger.getLogger(TestDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return monthlyAttempts;
    }
}
