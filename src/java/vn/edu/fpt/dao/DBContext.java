/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Rinaaaa
 */
public class DBContext {

    protected static Connection connection;

    public DBContext() {
        try {
            String user = "sa";
            String pass = "123";
            String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=SWP391_M2_BL5;trustServerCertificate=true";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
     public static void main(String[] args) {
        DBContext db = new DBContext();
        Connection conn = null;
        try {
            conn = DBContext.connection;
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Kết nối cơ sở dữ liệu thành công!");
            } else {
                System.out.println("❌ Kết nối cơ sở dữ liệu thất bại!");
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi kiểm tra kết nối: " + e.getMessage());
        } finally {
            try {
                if (conn != null) conn.close();
                System.out.println("🔌 Đã đóng kết nối.");
            } catch (SQLException e) {
                System.out.println("❌ Lỗi khi đóng kết nối: " + e.getMessage());
            }
        }
    }
}
