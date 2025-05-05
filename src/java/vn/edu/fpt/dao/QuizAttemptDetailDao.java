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
import vn.edu.fpt.model.QuizAttempt;

import vn.edu.fpt.model.QuizAttemptDetail;

/**
 *
 * @author Rinaaaa
 */
public class QuizAttemptDetailDao extends DBContext {

    // Cache cho danh sách chi tiết attempt theo attemptId
    private static final Map<Integer, List<QuizAttemptDetail>> attemptDetailsCache = new ConcurrentHashMap<>();

    // Cache cho danh sách câu trả lời đã chọn theo attemptId và questionId
    private static final Map<String, List<Answer>> selectedAnswersCache = new ConcurrentHashMap<>();

    // Thời gian cache hết hạn (5 phút)
    private static final long CACHE_EXPIRY_MS = 5 * 60 * 1000;

    // Thời điểm cache được tạo
    private static final Map<Integer, Long> attemptDetailsCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<String, Long> selectedAnswersCacheTimestamp = new ConcurrentHashMap<>();

    /**
     * Tạo mới một chi tiết attempt
     *
     * @param detail Chi tiết attempt cần tạo
     * @return ID của chi tiết attempt vừa tạo
     */
    public int create(QuizAttemptDetail detail) {
        String sql = """
                     INSERT INTO [QuizAttemptDetail] 
                     ([attemptId], [questionId], [answerId]) 
                     VALUES (?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, detail.getAttempt().getId());
            stm.setInt(2, detail.getQuestion().getId());
            stm.setInt(3, detail.getAnswer().getId());
            stm.executeUpdate();

            // Lấy ID được tạo
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    detail.setId(id);

                    // Xóa cache liên quan
                    clearCacheForAttempt(detail.getAttempt().getId());
                    clearCacheForSelectedAnswers(detail.getAttempt().getId(), detail.getQuestion().getId());

                    return id;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Tạo nhiều chi tiết attempt cùng lúc Tối ưu hiệu suất khi cần lưu nhiều
     * câu trả lời
     *
     * @param details Danh sách chi tiết attempt cần tạo
     * @return Số lượng chi tiết đã tạo thành công
     */
    public int createBatch(List<QuizAttemptDetail> details) {
        if (details == null || details.isEmpty()) {
            return 0;
        }

        int successCount = 0;
        String sql = """
                     INSERT INTO [QuizAttemptDetail] 
                     ([attemptId], [questionId], [answerId]) 
                     VALUES (?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            connection.setAutoCommit(false);

            for (QuizAttemptDetail detail : details) {
                stm.setInt(1, detail.getAttempt().getId());
                stm.setInt(2, detail.getQuestion().getId());
                stm.setInt(3, detail.getAnswer().getId());
                stm.addBatch();

                // Xóa cache liên quan
                clearCacheForAttempt(detail.getAttempt().getId());
                clearCacheForSelectedAnswers(detail.getAttempt().getId(), detail.getQuestion().getId());
            }

            int[] results = stm.executeBatch();
            connection.commit();

            for (int result : results) {
                if (result > 0) {
                    successCount++;
                }
            }

            connection.setAutoCommit(true);
        } catch (SQLException ex) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException rollbackEx) {
                Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, rollbackEx);
            }
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return successCount;
    }

    /**
     * Lấy tất cả chi tiết cho một attempt
     *
     * @param attemptId ID của attempt
     * @return Danh sách chi tiết attempt
     */
    public List<QuizAttemptDetail> getByAttempt(int attemptId) {
        // Kiểm tra cache trước
        if (attemptDetailsCache.containsKey(attemptId)) {
            Long timestamp = attemptDetailsCacheTimestamp.get(attemptId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(attemptDetailsCache.get(attemptId));
            }
        }

        List<QuizAttemptDetail> details = new ArrayList<>();
        String sql = """
                     SELECT [id], [attemptId], [questionId], [answerId] 
                     FROM [QuizAttemptDetail] 
                     WHERE [attemptId] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    QuizAttemptDetail detail = new QuizAttemptDetail();
                    detail.setId(rs.getInt("id"));

                    // Tạo đối tượng nhẹ thay vì tải toàn bộ
                    QuizAttempt attempt = new QuizAttempt();
                    attempt.setId(attemptId);
                    detail.setAttempt(attempt);

                    Question question = new Question();
                    question.setId(rs.getInt("questionId"));
                    detail.setQuestion(question);

                    Answer answer = new Answer();
                    answer.setId(rs.getInt("answerId"));
                    detail.setAnswer(answer);

                    details.add(detail);
                }
            }

            // Lưu vào cache
            attemptDetailsCache.put(attemptId, new ArrayList<>(details));
            attemptDetailsCacheTimestamp.put(attemptId, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return details;
    }

    /**
     * Lấy tất cả chi tiết cho một attempt với tối ưu Sử dụng JOIN để giảm số
     * lượng truy vấn
     *
     * @param attemptId ID của attempt
     * @return Danh sách chi tiết attempt
     */
    public List<QuizAttemptDetail> getByAttemptOptimized(int attemptId) {
        // Kiểm tra cache trước
        if (attemptDetailsCache.containsKey(attemptId)) {
            Long timestamp = attemptDetailsCacheTimestamp.get(attemptId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(attemptDetailsCache.get(attemptId));
            }
        }

        List<QuizAttemptDetail> details = new ArrayList<>();

        // Sử dụng JOIN để lấy tất cả dữ liệu liên quan trong một truy vấn
        String sql = """
                     SELECT d.[id], d.[attemptId], d.[questionId], d.[answerId],
                            q.[content] as question_content, q.[quizId],
                            a.[content] as answer_content, a.[isCorrect]
                     FROM [QuizAttemptDetail] d
                     JOIN [Question] q ON d.[questionId] = q.[id]
                     JOIN [Answer] a ON d.[answerId] = a.[id]
                     WHERE d.[attemptId] = ?
                     ORDER BY q.[id], a.[id]
                     """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);

            // Sử dụng Map để tránh tạo nhiều đối tượng Question trùng lặp
            Map<Integer, Question> questionMap = new HashMap<>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    QuizAttemptDetail detail = new QuizAttemptDetail();
                    detail.setId(rs.getInt("id"));

                    // Tạo đối tượng QuizAttempt nhẹ
                    QuizAttempt attempt = new QuizAttempt();
                    attempt.setId(attemptId);
                    detail.setAttempt(attempt);

                    // Lấy hoặc tạo đối tượng Question
                    int questionId = rs.getInt("questionId");
                    Question question = questionMap.get(questionId);
                    if (question == null) {
                        question = new Question();
                        question.setId(questionId);
                        question.setContent(rs.getString("question_content"));

                        // Tạo đối tượng Quiz nhẹ
                        vn.edu.fpt.model.Quiz quiz = new vn.edu.fpt.model.Quiz();
                        quiz.setId(rs.getInt("quizId"));
                        question.setQuiz(quiz);

                        questionMap.put(questionId, question);
                    }
                    detail.setQuestion(question);

                    // Tạo đối tượng Answer
                    Answer answer = new Answer();
                    answer.setId(rs.getInt("answerId"));
                    answer.setContent(rs.getString("answer_content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));
                    answer.setQuestion(question); // Thiết lập tham chiếu đến câu hỏi
                    detail.setAnswer(answer);

                    details.add(detail);
                }
            }

            // Lưu vào cache
            attemptDetailsCache.put(attemptId, new ArrayList<>(details));
            attemptDetailsCacheTimestamp.put(attemptId, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return details;
    }

    /**
     * Lấy tất cả câu trả lời đã chọn cho một câu hỏi trong một attempt
     *
     * @param attemptId ID của attempt
     * @param questionId ID của câu hỏi
     * @return Danh sách câu trả lời đã chọn
     */
    public List<Answer> getSelectedAnswers(int attemptId, int questionId) {
        // Tạo key cho cache
        String cacheKey = attemptId + "_" + questionId;

        // Kiểm tra cache trước
        if (selectedAnswersCache.containsKey(cacheKey)) {
            Long timestamp = selectedAnswersCacheTimestamp.get(cacheKey);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(selectedAnswersCache.get(cacheKey));
            }
        }

        List<Answer> answers = new ArrayList<>();
        String sql = """
                     SELECT a.[id], a.[questionId], a.[content], a.[isCorrect]
                     FROM [Answer] a 
                     JOIN [QuizAttemptDetail] d ON a.[id] = d.[answerId] 
                     WHERE d.[attemptId] = ? AND d.[questionId] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            stm.setInt(2, questionId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Answer answer = new Answer();
                    answer.setId(rs.getInt("id"));

                    // Tạo đối tượng Question nhẹ
                    Question question = new Question();
                    question.setId(questionId);
                    answer.setQuestion(question);

                    answer.setContent(rs.getString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));

                    answers.add(answer);
                }
            }

            // Lưu vào cache
            selectedAnswersCache.put(cacheKey, new ArrayList<>(answers));
            selectedAnswersCacheTimestamp.put(cacheKey, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answers;
    }

    /**
     * Lấy tất cả câu trả lời đã chọn cho nhiều câu hỏi trong một attempt Tối ưu
     * hiệu suất bằng cách giảm số lượng truy vấn
     *
     * @param attemptId ID của attempt
     * @param questionIds Danh sách ID của câu hỏi
     * @return Map chứa danh sách câu trả lời đã chọn theo questionId
     */
    public Map<Integer, List<Answer>> getSelectedAnswersForQuestions(int attemptId, List<Integer> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) {
            return new HashMap<>();
        }

        Map<Integer, List<Answer>> result = new HashMap<>();

        // Tạo chuỗi IN cho truy vấn SQL
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < questionIds.size(); i++) {
            placeholders.append("?");
            if (i < questionIds.size() - 1) {
                placeholders.append(",");
            }
        }

        String sql = String.format("""
                     SELECT a.[id], a.[questionId], a.[content], a.[isCorrect]
                     FROM [Answer] a 
                     JOIN [QuizAttemptDetail] d ON a.[id] = d.[answerId] 
                     WHERE d.[attemptId] = ? AND d.[questionId] IN (%s)
                     ORDER BY d.[questionId], a.[id]
                     """, placeholders);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);

            // Thiết lập các tham số cho truy vấn IN
            for (int i = 0; i < questionIds.size(); i++) {
                stm.setInt(i + 2, questionIds.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int questionId = rs.getInt("questionId");

                    // Tạo đối tượng Question nhẹ
                    Question question = new Question();
                    question.setId(questionId);

                    // Tạo câu trả lời
                    Answer answer = new Answer();
                    answer.setId(rs.getInt("id"));
                    answer.setQuestion(question);
                    answer.setContent(rs.getString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));

                    // Thêm vào map kết quả
                    result.computeIfAbsent(questionId, k -> new ArrayList<>()).add(answer);

                    // Cập nhật cache
                    String cacheKey = attemptId + "_" + questionId;
                    selectedAnswersCache.put(cacheKey, result.get(questionId));
                    selectedAnswersCacheTimestamp.put(cacheKey, System.currentTimeMillis());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Xóa tất cả chi tiết attempt cho một câu hỏi cụ thể Hữu ích khi cần cập
     * nhật câu trả lời cho một câu hỏi
     *
     * @param attemptId ID của attempt
     * @param questionId ID của câu hỏi
     * @return Số lượng chi tiết đã xóa
     */
    public int deleteByAttemptAndQuestion(int attemptId, int questionId) {
        String sql = """
                     DELETE FROM [QuizAttemptDetail]
                     WHERE [attemptId] = ? AND [questionId] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, attemptId);
            stm.setInt(2, questionId);
            int rowsAffected = stm.executeUpdate();

            // Xóa cache liên quan
            clearCacheForAttempt(attemptId);
            clearCacheForSelectedAnswers(attemptId, questionId);

            return rowsAffected;
        } catch (SQLException ex) {
            Logger.getLogger(QuizAttemptDetailDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Xóa cache cho một attempt cụ thể
     *
     * @param attemptId ID của attempt
     */
    private void clearCacheForAttempt(int attemptId) {
        attemptDetailsCache.remove(attemptId);
        attemptDetailsCacheTimestamp.remove(attemptId);
    }

    /**
     * Xóa cache cho câu trả lời đã chọn của một câu hỏi trong một attempt
     *
     * @param attemptId ID của attempt
     * @param questionId ID của câu hỏi
     */
    private void clearCacheForSelectedAnswers(int attemptId, int questionId) {
        String cacheKey = attemptId + "_" + questionId;
        selectedAnswersCache.remove(cacheKey);
        selectedAnswersCacheTimestamp.remove(cacheKey);
    }

    /**
     * Xóa toàn bộ cache
     */
    public void clearAllCache() {
        attemptDetailsCache.clear();
        attemptDetailsCacheTimestamp.clear();
        selectedAnswersCache.clear();
        selectedAnswersCacheTimestamp.clear();
    }
}
