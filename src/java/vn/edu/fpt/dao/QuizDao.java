package vn.edu.fpt.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class QuizDao extends DBContext {

    // Cache cho các quiz theo ID
    private static final Map<Integer, Quiz> quizCache = new ConcurrentHashMap<>();

    // Cache cho các quiz theo code
    private static final Map<String, Quiz> quizCodeCache = new ConcurrentHashMap<>();

    // Cache cho danh sách quiz theo teacherId
    private static final Map<Integer, List<Quiz>> teacherQuizzesCache = new ConcurrentHashMap<>();

    // Thời gian cache hết hạn (5 phút)
    private static final long CACHE_EXPIRY_MS = 5 * 60 * 1000;

    // Thời điểm cache được tạo
    private static final Map<Integer, Long> quizCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<String, Long> quizCodeCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<Integer, Long> teacherQuizzesCacheTimestamp = new ConcurrentHashMap<>();

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

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

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

    /**
     * Tạo mới một quiz
     *
     * @param quiz Quiz cần tạo
     * @return ID của quiz vừa tạo
     */
    public int create(Quiz quiz) {
        String sql = """
                     INSERT INTO [dbo].[Quiz]( 
                        [teacherId] ,[title] ,[description],
                        [code], [timeLimit], [status])
                     VALUES (?, ?, ?, ?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, quiz.getTeacher().getId());
            stm.setNString(2, quiz.getTitle());
            stm.setNString(3, quiz.getDescription());
            stm.setString(4, quiz.getCode());
            stm.setInt(5, quiz.getTimeLimit());
            stm.setString(6, quiz.getStatus());
            stm.executeUpdate();

            // Lấy ID được tạo
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    quiz.setId(id);

                    // Xóa cache liên quan
                    clearCacheForTeacher(quiz.getTeacher().getId());

                    return id;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Lấy quiz theo ID với caching
     *
     * @param id ID của quiz
     * @return Quiz tìm thấy hoặc null
     */
    public Quiz get(int id) {
        // Kiểm tra cache trước
        if (quizCache.containsKey(id)) {
            Long timestamp = quizCacheTimestamp.get(id);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return quizCache.get(id);
            }
        }

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
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    quiz = new Quiz();
                    quiz.setId(rs.getInt("id"));

                    // Tạo đối tượng User nhẹ
                    User teacher = new User();
                    teacher.setId(rs.getInt("teacherId"));
                    quiz.setTeacher(teacher);

                    quiz.setTitle(rs.getNString("title"));
                    quiz.setDescription(rs.getNString("description"));
                    quiz.setCode(rs.getString("code"));
                    quiz.setTimeLimit(rs.getInt("timeLimit"));
                    quiz.setStatus(rs.getString("status"));
                    quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                    // Lưu vào cache
                    quizCache.put(id, quiz);
                    quizCacheTimestamp.put(id, System.currentTimeMillis());

                    if (quiz.getCode() != null) {
                        quizCodeCache.put(quiz.getCode(), quiz);
                        quizCodeCacheTimestamp.put(quiz.getCode(), System.currentTimeMillis());
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quiz;
    }

    /**
     * Lấy quiz theo ID với đầy đủ thông tin Teacher
     *
     * @param id ID của quiz
     * @return Quiz với đầy đủ thông tin Teacher
     */
    public Quiz getWithFullTeacher(int id) {
        Quiz quiz = get(id);
        if (quiz != null && quiz.getTeacher() != null) {
            UserDao userDao = new UserDao();
            User teacher = userDao.getUser(quiz.getTeacher().getId());
            quiz.setTeacher(teacher);
        }
        return quiz;
    }

    /**
     * Lấy quiz theo code với caching
     *
     * @param code Code của quiz
     * @return Quiz tìm thấy hoặc null
     */
    public Quiz get(String code) {
        // Kiểm tra cache trước
        if (quizCodeCache.containsKey(code)) {
            Long timestamp = quizCodeCacheTimestamp.get(code);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return quizCodeCache.get(code);
            }
        }

        Quiz quiz = null;
        String sql = """
                     SELECT [id], [teacherId] ,[title],
                            [description], [code], [timeLimit],
                            [status], [createdAt]
                     FROM [Quiz]
                     WHERE [code] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, code);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    quiz = new Quiz();
                    quiz.setId(rs.getInt("id"));

                    // Tạo đối tượng User nhẹ
                    User teacher = new User();
                    teacher.setId(rs.getInt("teacherId"));
                    quiz.setTeacher(teacher);

                    quiz.setTitle(rs.getNString("title"));
                    quiz.setDescription(rs.getNString("description"));
                    quiz.setCode(rs.getString("code"));
                    quiz.setTimeLimit(rs.getInt("timeLimit"));
                    quiz.setStatus(rs.getString("status"));
                    quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                    // Lưu vào cache
                    quizCache.put(quiz.getId(), quiz);
                    quizCacheTimestamp.put(quiz.getId(), System.currentTimeMillis());

                    quizCodeCache.put(code, quiz);
                    quizCodeCacheTimestamp.put(code, System.currentTimeMillis());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quiz;
    }

    /**
     * Lấy danh sách quiz theo teacherId với caching
     *
     * @param teacherId ID của giáo viên
     * @return Danh sách quiz
     */
    public List<Quiz> list(int teacherId) {
        // Kiểm tra cache trước
        if (teacherQuizzesCache.containsKey(teacherId)) {
            Long timestamp = teacherQuizzesCacheTimestamp.get(teacherId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(teacherQuizzesCache.get(teacherId));
            }
        }

        List<Quiz> quizzes = new ArrayList<>();

        // Tạo đối tượng User nhẹ
        User teacher = new User();
        teacher.setId(teacherId);

        String sql = """
                     SELECT [id], [teacherId], [title], [description], 
                     [code], [timeLimit], [status], [createdAt] FROM [dbo].[Quiz]
                     WHERE [teacherId] = ?
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, teacherId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setId(rs.getInt("id"));
                    quiz.setTeacher(teacher); // Sử dụng cùng một đối tượng Teacher cho tất cả quiz
                    quiz.setTitle(rs.getString("title"));
                    quiz.setDescription(rs.getString("description"));
                    quiz.setCode(rs.getString("code"));
                    quiz.setTimeLimit(rs.getInt("timeLimit"));
                    quiz.setStatus(rs.getString("status"));
                    quiz.setCreatedAt(rs.getTimestamp("createdAt"));

                    quizzes.add(quiz);

                    // Cập nhật cache cho quiz riêng lẻ
                    quizCache.put(quiz.getId(), quiz);
                    quizCacheTimestamp.put(quiz.getId(), System.currentTimeMillis());

                    if (quiz.getCode() != null) {
                        quizCodeCache.put(quiz.getCode(), quiz);
                        quizCodeCacheTimestamp.put(quiz.getCode(), System.currentTimeMillis());
                    }
                }
            }

            // Lưu danh sách vào cache
            teacherQuizzesCache.put(teacherId, new ArrayList<>(quizzes));
            teacherQuizzesCacheTimestamp.put(teacherId, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return quizzes;
    }

    /**
     * Kiểm tra xem code đã tồn tại chưa
     *
     * @param code Code cần kiểm tra
     * @return true nếu code đã tồn tại, false nếu chưa
     */
    public boolean isCodeExists(String code) throws SQLException {
        // Kiểm tra cache trước
        if (quizCodeCache.containsKey(code)) {
            return true;
        }

        String sql = "SELECT 1 FROM [Quiz] WHERE [code] = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Tải questions cho một quiz cụ thể khi cần
     *
     * @param quiz Quiz cần tải questions
     */
    public void loadQuestionsForQuiz(Quiz quiz) {
        if (quiz != null) {
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsByQuizId(quiz.getId());
            quiz.setQuestions(questions);
        }
    }

    /**
     * Tải questions và answers cho một quiz cụ thể khi cần
     *
     * @param quiz Quiz cần tải questions và answers
     */
    public void loadQuestionsWithAnswersForQuiz(Quiz quiz) {
        if (quiz != null) {
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsWithAnswersByQuizId(quiz.getId());
            quiz.setQuestions(questions);
        }
    }

    /**
     * Cập nhật quiz
     *
     * @param quiz Quiz cần cập nhật
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean update(Quiz quiz) {
        String sql = """
                     UPDATE [Quiz]
                     SET [title] = ?, [description] = ?, [timeLimit] = ?, [status] = ?
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setNString(1, quiz.getTitle());
            stm.setNString(2, quiz.getDescription());
            stm.setInt(3, quiz.getTimeLimit());
            stm.setString(4, quiz.getStatus());
            stm.setInt(5, quiz.getId());
            int rowsAffected = stm.executeUpdate();

            // Xóa cache liên quan
            if (rowsAffected > 0) {
                clearCacheForQuiz(quiz.getId());
                clearCacheForTeacher(quiz.getTeacher().getId());
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Xóa cache cho một quiz cụ thể
     *
     * @param quizId ID của quiz
     */
    private void clearCacheForQuiz(int quizId) {
        Quiz quiz = quizCache.get(quizId);
        if (quiz != null && quiz.getCode() != null) {
            quizCodeCache.remove(quiz.getCode());
            quizCodeCacheTimestamp.remove(quiz.getCode());
        }

        quizCache.remove(quizId);
        quizCacheTimestamp.remove(quizId);
    }

    /**
     * Xóa cache cho một giáo viên cụ thể
     *
     * @param teacherId ID của giáo viên
     */
    private void clearCacheForTeacher(int teacherId) {
        teacherQuizzesCache.remove(teacherId);
        teacherQuizzesCacheTimestamp.remove(teacherId);
    }

    /**
     * Xóa toàn bộ cache
     */
    public void clearAllCache() {
        quizCache.clear();
        quizCacheTimestamp.clear();
        quizCodeCache.clear();
        quizCodeCacheTimestamp.clear();
        teacherQuizzesCache.clear();
        teacherQuizzesCacheTimestamp.clear();
    }
}
