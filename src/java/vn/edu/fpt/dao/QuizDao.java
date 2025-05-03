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
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class QuizDao extends DBContext {

    public void create(Quiz quiz) {
        String sql = """
                     INSERT INTO [dbo].[Quiz]( 
                        [teacherId] ,[title] ,[description],
                        [code], [timeLimit], [status])
                     VALUES (?, ?, ?, ?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quiz.getTeacher().getId());
            stm.setNString(2, quiz.getTitle());
            stm.setNString(3, quiz.getDescription());
            stm.setString(4, quiz.getCode());
            stm.setInt(5, quiz.getTimeLimit());
            stm.setString(6, quiz.getStatus());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Quiz get(int id) {
        UserDao userDao = new UserDao();
        Quiz quiz = null;
        String sql = """
                     SELECT [id], [teacherId] ,[title],
                            [description], [code], [timeLimit],
                            [status], [createdAt]
                     FROM [Quiz]
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTeacher(userDao.getUser(rs.getInt("teacherId")));
                quiz.setTitle(rs.getNString("title"));
                quiz.setDescription(rs.getNString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quiz;
    }

    public Quiz get(String input) {
        UserDao userDao = new UserDao();
        Quiz quiz = null;
        String sql = """
                     SELECT [id], [teacherId] ,[title],
                            [description], [code], [timeLimit],
                            [status], [createdAt]
                     FROM [Quiz]
                     WHERE [code] = ? OR [title] = ? 
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, input);
            stm.setString(2, input);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTeacher(userDao.getUser(rs.getInt("teacherId")));
                quiz.setTitle(rs.getNString("title"));
                quiz.setDescription(rs.getNString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quiz;
    }

    public List<Quiz> list(int teacherId) {
        UserDao userDao = new UserDao();
        List<Quiz> quizzes = new ArrayList<>();
        String sql = """
                     SELECT [id], [teacherId], [title], [description], 
                     [code], [timeLimit], [status], [createdAt] FROM [dbo].[Quiz]
                     WHERE [teacherId] = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, teacherId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTeacher(userDao.getUser(rs.getInt("teacherId")));
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
                quizzes.add(quiz);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quizzes;
    }

    public boolean isCodeExists(String code) throws SQLException {
        String sql = "SELECT 1 FROM [Quiz] WHERE [code] = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    public List<Quiz> getQuizzesByTeacher(int teacherId) {
        List<Quiz> quizzes = new ArrayList<>();
        UserDao userDao = new UserDao();
        
        String sql = """
                     SELECT [id], [teacherId], [title], [description], 
                            [code], [timeLimit], [status], [createdAt]
                     FROM [Quiz]
                     WHERE [teacherId] = ?
                     ORDER BY [createdAt] DESC
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, teacherId);
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                
                User teacher = userDao.getUserById(rs.getInt("teacherId"));
                quiz.setTeacher(teacher);
                
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
                
                quizzes.add(quiz);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return quizzes;
    }
    
    public Quiz getQuizById(int quizId) {
        Quiz quiz = null;
        UserDao userDao = new UserDao();
        
        String sql = """
                     SELECT [id], [teacherId], [title], [description], 
                            [code], [timeLimit], [status], [createdAt]
                     FROM [Quiz]
                     WHERE [id] = ?
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                
                User teacher = userDao.getUserById(rs.getInt("teacherId"));
                quiz.setTeacher(teacher);
                
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return quiz;
    }
    
    public void createQuiz(Quiz quiz) {
        String sql = """
                     INSERT INTO [Quiz] ([teacherId], [title], [description], 
                                        [code], [timeLimit], [status])
                     VALUES (?, ?, ?, ?, ?, ?)
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quiz.getTeacher().getId());
            stm.setString(2, quiz.getTitle());
            stm.setString(3, quiz.getDescription());
            stm.setString(4, quiz.getCode());
            stm.setInt(5, quiz.getTimeLimit());
            stm.setString(6, quiz.getStatus());
            
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void updateQuiz(Quiz quiz) {
        String sql = """
                     UPDATE [Quiz]
                     SET [title] = ?, 
                         [description] = ?, 
                         [timeLimit] = ?, 
                         [status] = ?
                     WHERE [id] = ?
                     """;
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, quiz.getTitle());
            stm.setString(2, quiz.getDescription());
            stm.setInt(3, quiz.getTimeLimit());
            stm.setString(4, quiz.getStatus());
            stm.setInt(5, quiz.getId());
            
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void deleteQuiz(int quizId) {
        String sql = "DELETE FROM [Quiz] WHERE [id] = ?";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public int countQuestionsByQuizId(int quizId) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS questionCount FROM [Question] WHERE [quizId] = ?";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("questionCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return count;
    }
    
    public int countAttemptsByQuizId(int quizId) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS attemptCount FROM [QuizAttempt] WHERE [quizId] = ?";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("attemptCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return count;
    }  


    public int countAllQuizzes() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS quizCount FROM [Quiz]";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("quizCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }

    public List<Quiz> getAllQuizzes(int offset, int limit) {
        List<Quiz> quizzes = new ArrayList<>();
        UserDao userDao = new UserDao();

        String sql = """
                     SELECT [id], [teacherId], [title], [description],
                            [code], [timeLimit], [status], [createdAt]
                     FROM [Quiz]
                     ORDER BY [createdAt] DESC
                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, offset);
            stm.setInt(2, limit);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));

                User teacher = userDao.getUserById(rs.getInt("teacherId"));
                quiz.setTeacher(teacher);

                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                quizzes.add(quiz);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return quizzes;
    }

    public List<Quiz> searchQuizzes(String searchTerm, String searchBy, int offset, int limit) {
        List<Quiz> quizzes = new ArrayList<>();
        UserDao userDao = new UserDao();

        String sql;

        switch (searchBy) {
            case "title":
                sql = """
                      SELECT q.[id], q.[teacherId], q.[title], q.[description],
                             q.[code], q.[timeLimit], q.[status], q.[createdAt]
                      FROM [Quiz] q
                      WHERE q.[title] LIKE ?
                      ORDER BY q.[createdAt] DESC
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "code":
                sql = """
                      SELECT q.[id], q.[teacherId], q.[title], q.[description],
                             q.[code], q.[timeLimit], q.[status], q.[createdAt]
                      FROM [Quiz] q
                      WHERE q.[code] LIKE ?
                      ORDER BY q.[createdAt] DESC
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            case "teacher":
                sql = """
                      SELECT q.[id], q.[teacherId], q.[title], q.[description],
                             q.[code], q.[timeLimit], q.[status], q.[createdAt]
                      FROM [Quiz] q
                      JOIN [User] u ON q.[teacherId] = u.[id]
                      WHERE u.[first_name] LIKE ? OR u.[last_name] LIKE ?
                      ORDER BY q.[createdAt] DESC
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
            default:
                sql = """
                      SELECT q.[id], q.[teacherId], q.[title], q.[description],
                             q.[code], q.[timeLimit], q.[status], q.[createdAt]
                      FROM [Quiz] q
                      JOIN [User] u ON q.[teacherId] = u.[id]
                      WHERE q.[title] LIKE ? OR q.[code] LIKE ? OR u.[first_name] LIKE ? OR u.[last_name] LIKE ?
                      ORDER BY q.[createdAt] DESC
                      OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                      """;
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "title":
                case "code":
                    stm.setString(1, searchPattern);
                    stm.setInt(2, offset);
                    stm.setInt(3, limit);
                    break;
                case "teacher":
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
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));

                User teacher = userDao.getUserById(rs.getInt("teacherId"));
                quiz.setTeacher(teacher);

                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCode(rs.getString("code"));
                quiz.setTimeLimit(rs.getInt("timeLimit"));
                quiz.setStatus(rs.getString("status"));
                quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                quizzes.add(quiz);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return quizzes;
    }

    public int countSearchResults(String searchTerm, String searchBy) {
        int count = 0;
        String sql;

        switch (searchBy) {
            case "title":
                sql = "SELECT COUNT(*) AS quizCount FROM [Quiz] WHERE [title] LIKE ?";
                break;
            case "code":
                sql = "SELECT COUNT(*) AS quizCount FROM [Quiz] WHERE [code] LIKE ?";
                break;
            case "teacher":
                sql = """
                      SELECT COUNT(*) AS quizCount
                      FROM [Quiz] q
                      JOIN [User] u ON q.[teacherId] = u.[id]
                      WHERE u.[first_name] LIKE ? OR u.[last_name] LIKE ?
                      """;
                break;
            default:
                sql = """
                      SELECT COUNT(*) AS quizCount
                      FROM [Quiz] q
                      JOIN [User] u ON q.[teacherId] = u.[id]
                      WHERE q.[title] LIKE ? OR q.[code] LIKE ? OR u.[first_name] LIKE ? OR u.[last_name] LIKE ?
                      """;
                break;
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";

            switch (searchBy) {
                case "title":
                case "code":
                    stm.setString(1, searchPattern);
                    break;
                case "teacher":
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
                count = rs.getInt("quizCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return count;
    }
}
