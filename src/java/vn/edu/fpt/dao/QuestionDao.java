/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.model.Answer;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.Quiz;

/**
 *
 * @author Rinaaaa
 */
public class QuestionDao extends DBContext {

    // Cache cho các câu hỏi theo ID
    private static final Map<Integer, Question> questionCache = new ConcurrentHashMap<>();

    // Cache cho danh sách câu hỏi theo quizId
    private static final Map<Integer, List<Question>> quizQuestionsCache = new ConcurrentHashMap<>();

    // Cache cho các quiz theo ID
    private static final Map<Integer, Quiz> quizCache = new ConcurrentHashMap<>();

    // Thời gian cache hết hạn (5 phút)
    private static final long CACHE_EXPIRY_MS = 5 * 60 * 1000;

    // Thời điểm cache được tạo
    private static final Map<Integer, Long> questionCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<Integer, Long> quizQuestionsCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<Integer, Long> quizCacheTimestamp = new ConcurrentHashMap<>();

    /**
     * Tạo mới một câu hỏi
     *
     * @param question Câu hỏi cần tạo
     * @return ID của câu hỏi vừa tạo
     */
    public int create(Question question) {
        String sql = """
                     INSERT INTO [Question] ([quizId], [content]) 
                     VALUES (?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, question.getQuiz().getId());
            stm.setNString(2, question.getContent());
            stm.executeUpdate();

            // Lấy ID được tạo
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    question.setId(id);

                    // Xóa cache liên quan
                    clearCacheForQuiz(question.getQuiz().getId());

                    return id;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Lấy câu hỏi theo nội dung
     *
     * @param input Nội dung câu hỏi
     * @return Câu hỏi tìm thấy hoặc null
     */
    public Question get(String input) {
        Question question = null;
        String sql = """
                     SELECT [id], [quizId], [content]
                     FROM [Question]
                     WHERE [content] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setNString(1, input);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    int quizId = rs.getInt("quizId");

                    // Lấy quiz từ cache hoặc database
                    Quiz quiz = getQuizFromCacheOrDb(quizId);

                    question = new Question();
                    question.setId(rs.getInt("id"));
                    question.setQuiz(quiz);
                    question.setContent(rs.getNString("content"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return question;
    }

    /**
     * Lấy câu hỏi theo ID với caching
     *
     * @param id ID của câu hỏi
     * @return Câu hỏi tìm thấy hoặc null
     */
    public Question getQuestionById(int id) {
        // Kiểm tra cache trước
        if (questionCache.containsKey(id)) {
            Long timestamp = questionCacheTimestamp.get(id);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return questionCache.get(id);
            }
        }

        Question question = null;
        String sql = """
                 SELECT [id], [quizId], [content]
                 FROM [Question]
                 WHERE [id] = ?
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    int quizId = rs.getInt("quizId");

                    // Lấy quiz từ cache hoặc database
                    Quiz quiz = getQuizFromCacheOrDb(quizId);

                    question = new Question();
                    question.setId(rs.getInt("id"));
                    question.setQuiz(quiz);
                    question.setContent(rs.getNString("content"));

                    // Lưu vào cache
                    questionCache.put(id, question);
                    questionCacheTimestamp.put(id, System.currentTimeMillis());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return question;
    }

    /**
     * Lấy danh sách câu hỏi theo quizId với caching Tối ưu để giảm số lượng
     * truy vấn cơ sở dữ liệu
     *
     * @param quizId ID của quiz
     * @return Danh sách câu hỏi
     */
    public List<Question> getQuestionsByQuizId(int quizId) {
        // Kiểm tra cache trước
        if (quizQuestionsCache.containsKey(quizId)) {
            Long timestamp = quizQuestionsCacheTimestamp.get(quizId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(quizQuestionsCache.get(quizId));
            }
        }

        List<Question> questions = new ArrayList<>();

        // Lấy quiz từ cache hoặc database
        Quiz quiz = getQuizFromCacheOrDb(quizId);

        String sql = """
                 SELECT [id], [quizId], [content]
                 FROM [Question]
                 WHERE [quizId] = ?
                 ORDER BY [id]
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Question question = new Question();
                    question.setId(rs.getInt("id"));
                    question.setQuiz(quiz); // Sử dụng cùng một đối tượng Quiz cho tất cả câu hỏi
                    question.setContent(rs.getNString("content"));
                    questions.add(question);

                    // Cập nhật cache cho câu hỏi riêng lẻ
                    questionCache.put(question.getId(), question);
                    questionCacheTimestamp.put(question.getId(), System.currentTimeMillis());
                }
            }

            // Lưu danh sách vào cache
            quizQuestionsCache.put(quizId, new ArrayList<>(questions));
            quizQuestionsCacheTimestamp.put(quizId, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return questions;
    }

    /**
     * Lấy câu hỏi và câu trả lời trong một truy vấn JOIN Tối ưu hiệu suất bằng
     * cách giảm số lượng truy vấn
     *
     * @param quizId ID của quiz
     * @return Danh sách câu hỏi với câu trả lời
     */
    public List<Question> getQuestionsWithAnswersByQuizId(int quizId) {
        Map<Integer, Question> questionMap = new HashMap<>();

        // Lấy quiz từ cache hoặc database
        Quiz quiz = getQuizFromCacheOrDb(quizId);

        String sql = """
                     SELECT q.[id], q.[quizId], q.[content],
                            a.[id] as answer_id, a.[content] as answer_content, 
                            a.[isCorrect], a.[questionId]
                     FROM [Question] q
                     LEFT JOIN [Answer] a ON q.[id] = a.[questionId]
                     WHERE q.[quizId] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int questionId = rs.getInt("id");

                    // Lấy hoặc tạo câu hỏi
                    Question question = questionMap.get(questionId);
                    if (question == null) {
                        question = new Question();
                        question.setId(questionId);
                        question.setQuiz(quiz); // Sử dụng cùng một đối tượng Quiz cho tất cả câu hỏi
                        question.setContent(rs.getNString("content"));
                        question.setAnswers(new ArrayList<>());
                        questionMap.put(questionId, question);
                    }

                    // Thêm câu trả lời nếu có
                    if (rs.getObject("answer_id") != null) {
                        Answer answer = new Answer();
                        answer.setId(rs.getInt("answer_id"));
                        answer.setContent(rs.getNString("answer_content"));
                        answer.setIsCorrect(rs.getBoolean("isCorrect"));
                        answer.setQuestion(question); // Thiết lập tham chiếu đến câu hỏi
                        question.getAnswers().add(answer);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new ArrayList<>(questionMap.values());
    }

    /**
     * Lấy số lượng câu hỏi trong một quiz
     *
     * @param quizId ID của quiz
     * @return Số lượng câu hỏi
     */
    public int getQuestionCountByQuizId(int quizId) {
        String sql = "SELECT COUNT(*) FROM [Question] WHERE [quizId] = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Cập nhật câu hỏi
     *
     * @param question Câu hỏi cần cập nhật
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean update(Question question) {
        String sql = """
                     UPDATE [Question]
                     SET [content] = ?
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setNString(1, question.getContent());
            stm.setInt(2, question.getId());
            int rowsAffected = stm.executeUpdate();

            // Xóa cache liên quan
            if (rowsAffected > 0) {
                questionCache.remove(question.getId());
                questionCacheTimestamp.remove(question.getId());
                clearCacheForQuiz(question.getQuiz().getId());
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Xóa câu hỏi
     *
     * @param questionId ID của câu hỏi cần xóa
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean delete(int questionId) {
        // Lấy thông tin câu hỏi trước khi xóa để cập nhật cache
        Question question = getQuestionById(questionId);
        if (question == null) {
            return false;
        }

        String sql = "DELETE FROM [Question] WHERE [id] = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            int rowsAffected = stm.executeUpdate();

            // Xóa cache liên quan
            if (rowsAffected > 0) {
                questionCache.remove(questionId);
                questionCacheTimestamp.remove(questionId);
                clearCacheForQuiz(question.getQuiz().getId());
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Lấy Quiz từ cache hoặc database
     *
     * @param quizId ID của quiz
     * @return Đối tượng Quiz
     */
    private Quiz getQuizFromCacheOrDb(int quizId) {
        // Kiểm tra cache trước
        if (quizCache.containsKey(quizId)) {
            Long timestamp = quizCacheTimestamp.get(quizId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return quizCache.get(quizId);
            }
        }

        // Nếu không có trong cache, lấy từ database
        QuizDao quizDao = new QuizDao();
        Quiz quiz = quizDao.get(quizId);

        // Lưu vào cache
        if (quiz != null) {
            quizCache.put(quizId, quiz);
            quizCacheTimestamp.put(quizId, System.currentTimeMillis());
        }

        return quiz;
    }

    /**
     * Xóa cache cho một quiz cụ thể
     *
     * @param quizId ID của quiz
     */
    private void clearCacheForQuiz(int quizId) {
        quizQuestionsCache.remove(quizId);
        quizQuestionsCacheTimestamp.remove(quizId);
        quizCache.remove(quizId);
        quizCacheTimestamp.remove(quizId);
    }

    /**
     * Xóa toàn bộ cache
     */
    public void clearAllCache() {
        questionCache.clear();
        questionCacheTimestamp.clear();
        quizQuestionsCache.clear();
        quizQuestionsCacheTimestamp.clear();
        quizCache.clear();
        quizCacheTimestamp.clear();
    }

    /**
     * Lấy danh sách câu hỏi theo quizId với phân trang
     *
     * @param quizId ID của quiz
     * @param pageNumber Số trang (bắt đầu từ 1)
     * @param pageSize Số lượng câu hỏi mỗi trang
     * @return Danh sách câu hỏi theo trang
     */
    public List<Question> getQuestionsByQuizIdPaginated(int quizId, int pageNumber, int pageSize) {
        List<Question> questions = new ArrayList<>();

        // Lấy quiz từ cache hoặc database
        Quiz quiz = getQuizFromCacheOrDb(quizId);

        String sql = """
                 SELECT [id], [quizId], [content]
                 FROM [Question]
                 WHERE [quizId] = ?
                 ORDER BY [id]
                 OFFSET ? ROWS
                 FETCH NEXT ? ROWS ONLY
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            stm.setInt(2, (pageNumber - 1) * pageSize);
            stm.setInt(3, pageSize);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Question question = new Question();
                    question.setId(rs.getInt("id"));
                    question.setQuiz(quiz); // Sử dụng cùng một đối tượng Quiz cho tất cả câu hỏi
                    question.setContent(rs.getNString("content"));
                    questions.add(question);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return questions;
    }

    /**
     * Lấy danh sách câu hỏi và câu trả lời với JOIN và phân trang
     *
     * @param quizId ID của quiz
     * @param pageNumber Số trang (bắt đầu từ 1)
     * @param pageSize Số lượng câu hỏi mỗi trang
     * @return Danh sách câu hỏi với câu trả lời theo trang
     */
    public List<Question> getQuestionsWithAnswersPaginated(int quizId, int pageNumber, int pageSize) {
        Map<Integer, Question> questionMap = new HashMap<>();

        // Lấy quiz từ cache hoặc database
        Quiz quiz = getQuizFromCacheOrDb(quizId);

        // Truy vấn phức tạp hơn để lấy câu hỏi theo trang và JOIN với câu trả lời
        String sql = """
                     WITH PaginatedQuestions AS (
                         SELECT [id], [quizId], [content], 
                                ROW_NUMBER() OVER (ORDER BY [id]) AS RowNum
                         FROM [Question]
                         WHERE [quizId] = ?
                     )
                     SELECT q.[id], q.[quizId], q.[content],
                            a.[id] as answer_id, a.[content] as answer_content, 
                            a.[isCorrect], a.[questionId]
                     FROM PaginatedQuestions q
                     LEFT JOIN [Answer] a ON q.[id] = a.[questionId]
                     WHERE q.RowNum BETWEEN ? AND ?
                     ORDER BY q.[id], a.[id]
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizId);
            stm.setInt(2, (pageNumber - 1) * pageSize + 1);
            stm.setInt(3, pageNumber * pageSize);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int questionId = rs.getInt("id");

                    // Lấy hoặc tạo câu hỏi
                    Question question = questionMap.get(questionId);
                    if (question == null) {
                        question = new Question();
                        question.setId(questionId);
                        question.setQuiz(quiz); // Sử dụng cùng một đối tượng Quiz cho tất cả câu hỏi
                        question.setContent(rs.getNString("content"));
                        question.setAnswers(new ArrayList<>());
                        questionMap.put(questionId, question);
                    }

                    // Thêm câu trả lời nếu có
                    if (rs.getObject("answer_id") != null) {
                        Answer answer = new Answer();
                        answer.setId(rs.getInt("answer_id"));
                        answer.setContent(rs.getNString("answer_content"));
                        answer.setIsCorrect(rs.getBoolean("isCorrect"));
                        answer.setQuestion(question); // Thiết lập tham chiếu đến câu hỏi
                        question.getAnswers().add(answer);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuestionDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new ArrayList<>(questionMap.values());
    }
}
