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

/**
 *
 * @author Rinaaaa
 */
public class AnswerDao extends DBContext {

    // Cache cho các câu trả lời theo ID
    private static final Map<Integer, Answer> answerCache = new ConcurrentHashMap<>();

    // Cache cho danh sách câu trả lời theo questionId
    private static final Map<Integer, List<Answer>> questionAnswersCache = new ConcurrentHashMap<>();

    // Cache cho danh sách câu trả lời đúng theo questionId
    private static final Map<Integer, List<Answer>> correctAnswersCache = new ConcurrentHashMap<>();

    // Thời gian cache hết hạn (5 phút)
    private static final long CACHE_EXPIRY_MS = 5 * 60 * 1000;

    // Thời điểm cache được tạo
    private static final Map<Integer, Long> answerCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<Integer, Long> questionAnswersCacheTimestamp = new ConcurrentHashMap<>();
    private static final Map<Integer, Long> correctAnswersCacheTimestamp = new ConcurrentHashMap<>();

    /**
     * Tạo mới một câu trả lời
     *
     * @param answer Câu trả lời cần tạo
     * @return ID của câu trả lời vừa tạo
     */
    public int create(Answer answer) {
        String sql = """
                     INSERT INTO [Answer] ([questionId], [content], [isCorrect]) 
                     VALUES (?, ?, ?)
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, answer.getQuestion().getId());
            stm.setNString(2, answer.getContent());
            stm.setBoolean(3, answer.isIsCorrect());
            stm.executeUpdate();

            // Lấy ID được tạo
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    answer.setId(id);

                    // Xóa cache liên quan
                    clearCacheForQuestion(answer.getQuestion().getId());

                    return id;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Lấy câu trả lời theo ID với caching
     *
     * @param id ID của câu trả lời
     * @return Câu trả lời tìm thấy hoặc null
     */
    public Answer getAnswerById(int id) {
        // Kiểm tra cache trước
        if (answerCache.containsKey(id)) {
            Long timestamp = answerCacheTimestamp.get(id);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return answerCache.get(id);
            }
        }

        Answer answer = null;
        String sql = """
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [id] = ?
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    answer = new Answer();
                    answer.setId(rs.getInt("id"));

                    // Tạo đối tượng Question nhẹ thay vì tải toàn bộ
                    Question question = new Question();
                    question.setId(rs.getInt("questionId"));
                    answer.setQuestion(question);

                    answer.setContent(rs.getNString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));

                    // Lưu vào cache
                    answerCache.put(id, answer);
                    answerCacheTimestamp.put(id, System.currentTimeMillis());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answer;
    }

    /**
     * Lấy câu trả lời theo ID với đầy đủ thông tin Question
     *
     * @param id ID của câu trả lời
     * @return Câu trả lời với đầy đủ thông tin Question
     */
    public Answer getAnswerWithFullQuestion(int id) {
        Answer answer = getAnswerById(id);
        if (answer != null) {
            QuestionDao questionDao = new QuestionDao();
            Question question = questionDao.getQuestionById(answer.getQuestion().getId());
            answer.setQuestion(question);
        }
        return answer;
    }

    /**
     * Lấy danh sách câu trả lời theo questionId với caching
     *
     * @param questionId ID của câu hỏi
     * @return Danh sách câu trả lời
     */
    public List<Answer> getAnswersByQuestionId(int questionId) {
        // Kiểm tra cache trước
        if (questionAnswersCache.containsKey(questionId)) {
            Long timestamp = questionAnswersCacheTimestamp.get(questionId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(questionAnswersCache.get(questionId));
            }
        }

        List<Answer> answers = new ArrayList<>();

        // Tạo đối tượng Question nhẹ
        Question question = new Question();
        question.setId(questionId);

        String sql = """
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [questionId] = ?
                 ORDER BY [id]
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Answer answer = new Answer();
                    answer.setId(rs.getInt("id"));
                    answer.setQuestion(question); // Sử dụng cùng một đối tượng Question cho tất cả câu trả lời
                    answer.setContent(rs.getNString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));
                    answers.add(answer);

                    // Cập nhật cache cho câu trả lời riêng lẻ
                    answerCache.put(answer.getId(), answer);
                    answerCacheTimestamp.put(answer.getId(), System.currentTimeMillis());
                }
            }

            // Lưu danh sách vào cache
            questionAnswersCache.put(questionId, new ArrayList<>(answers));
            questionAnswersCacheTimestamp.put(questionId, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answers;
    }

    /**
     * Lấy danh sách câu trả lời đúng theo questionId với caching
     *
     * @param questionId ID của câu hỏi
     * @return Danh sách câu trả lời đúng
     */
    public List<Answer> getCorrectAnswersByQuestionId(int questionId) {
        // Kiểm tra cache trước
        if (correctAnswersCache.containsKey(questionId)) {
            Long timestamp = correctAnswersCacheTimestamp.get(questionId);
            if (timestamp != null && System.currentTimeMillis() - timestamp < CACHE_EXPIRY_MS) {
                return new ArrayList<>(correctAnswersCache.get(questionId));
            }
        }

        List<Answer> answers = new ArrayList<>();

        // Tạo đối tượng Question nhẹ
        Question question = new Question();
        question.setId(questionId);

        String sql = """
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [questionId] = ? AND [isCorrect] = 1
                 ORDER BY [id]
                 """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Answer answer = new Answer();
                    answer.setId(rs.getInt("id"));
                    answer.setQuestion(question); // Sử dụng cùng một đối tượng Question cho tất cả câu trả lời
                    answer.setContent(rs.getNString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));
                    answers.add(answer);
                }
            }

            // Lưu danh sách vào cache
            correctAnswersCache.put(questionId, new ArrayList<>(answers));
            correctAnswersCacheTimestamp.put(questionId, System.currentTimeMillis());

        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return answers;
    }

    /**
     * Lấy danh sách câu trả lời theo danh sách questionId trong một truy vấn
     * Giảm số lượng truy vấn khi cần lấy câu trả lời cho nhiều câu hỏi
     *
     * @param questionIds Danh sách ID của câu hỏi
     * @return Map chứa danh sách câu trả lời theo questionId
     */
    public Map<Integer, List<Answer>> getAnswersByQuestionIds(List<Integer> questionIds) {
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
                 SELECT [id], [questionId], [content], [isCorrect]
                 FROM [Answer]
                 WHERE [questionId] IN (%s)
                 ORDER BY [questionId], [id]
                 """, placeholders);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Thiết lập các tham số cho truy vấn IN
            for (int i = 0; i < questionIds.size(); i++) {
                stm.setInt(i + 1, questionIds.get(i));
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
                    answer.setContent(rs.getNString("content"));
                    answer.setIsCorrect(rs.getBoolean("isCorrect"));

                    // Thêm vào map kết quả
                    result.computeIfAbsent(questionId, k -> new ArrayList<>()).add(answer);

                    // Cập nhật cache
                    answerCache.put(answer.getId(), answer);
                    answerCacheTimestamp.put(answer.getId(), System.currentTimeMillis());
                }

                // Cập nhật cache cho từng questionId
                for (Map.Entry<Integer, List<Answer>> entry : result.entrySet()) {
                    int questionId = entry.getKey();
                    List<Answer> answers = entry.getValue();

                    questionAnswersCache.put(questionId, new ArrayList<>(answers));
                    questionAnswersCacheTimestamp.put(questionId, System.currentTimeMillis());

                    // Cập nhật cache cho câu trả lời đúng
                    List<Answer> correctAnswers = answers.stream()
                            .filter(Answer::isIsCorrect)
                            .toList();

                    correctAnswersCache.put(questionId, new ArrayList<>(correctAnswers));
                    correctAnswersCacheTimestamp.put(questionId, System.currentTimeMillis());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Cập nhật câu trả lời
     *
     * @param answer Câu trả lời cần cập nhật
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean update(Answer answer) {
        String sql = """
                     UPDATE [Answer]
                     SET [content] = ?, [isCorrect] = ?
                     WHERE [id] = ?
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setNString(1, answer.getContent());
            stm.setBoolean(2, answer.isIsCorrect());
            stm.setInt(3, answer.getId());
            int rowsAffected = stm.executeUpdate();

            // Xóa cache liên quan
            if (rowsAffected > 0) {
                answerCache.remove(answer.getId());
                answerCacheTimestamp.remove(answer.getId());
                clearCacheForQuestion(answer.getQuestion().getId());
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Xóa câu trả lời
     *
     * @param answerId ID của câu trả lời cần xóa
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean delete(int answerId) {
        // Lấy thông tin câu trả lời trước khi xóa để cập nhật cache
        Answer answer = getAnswerById(answerId);
        if (answer == null) {
            return false;
        }

        String sql = "DELETE FROM [Answer] WHERE [id] = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, answerId);
            int rowsAffected = stm.executeUpdate();

            // Xóa cache liên quan
            if (rowsAffected > 0) {
                answerCache.remove(answerId);
                answerCacheTimestamp.remove(answerId);
                clearCacheForQuestion(answer.getQuestion().getId());
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AnswerDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Xóa cache cho một câu hỏi cụ thể
     *
     * @param questionId ID của câu hỏi
     */
    private void clearCacheForQuestion(int questionId) {
        questionAnswersCache.remove(questionId);
        questionAnswersCacheTimestamp.remove(questionId);
        correctAnswersCache.remove(questionId);
        correctAnswersCacheTimestamp.remove(questionId);
    }

    /**
     * Xóa toàn bộ cache
     */
    public void clearAllCache() {
        answerCache.clear();
        answerCacheTimestamp.clear();
        questionAnswersCache.clear();
        questionAnswersCacheTimestamp.clear();
        correctAnswersCache.clear();
        correctAnswersCacheTimestamp.clear();
    }
}
