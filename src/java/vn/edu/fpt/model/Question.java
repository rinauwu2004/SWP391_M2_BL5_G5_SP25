/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.model;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Rinaaaa
 */
public class Question {

    private int id;
    private Quiz quiz;
    private String content;
    private List<Answer> answers; // Thêm trường để lưu danh sách câu trả lời

    public Question() {
        // Khởi tạo danh sách rỗng để tránh NullPointerException
        this.answers = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Quiz getQuiz() {
        return quiz;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    /**
     * Lấy danh sách câu trả lời của câu hỏi
     *
     * @return Danh sách câu trả lời
     */
    public List<Answer> getAnswers() {
        return answers;
    }

    /**
     * Thiết lập danh sách câu trả lời cho câu hỏi
     *
     * @param answers Danh sách câu trả lời
     */
    public void setAnswers(List<Answer> answers) {
        this.answers = answers;
    }

    /**
     * Thêm một câu trả lời vào danh sách
     *
     * @param answer Câu trả lời cần thêm
     */
    public void addAnswer(Answer answer) {
        if (this.answers == null) {
            this.answers = new ArrayList<>();
        }
        this.answers.add(answer);
    }

    /**
     * Kiểm tra xem câu hỏi có câu trả lời nào không
     *
     * @return true nếu có ít nhất một câu trả lời, false nếu không có
     */
    public boolean hasAnswers() {
        return this.answers != null && !this.answers.isEmpty();
    }

    /**
     * Lấy số lượng câu trả lời
     *
     * @return Số lượng câu trả lời
     */
    public int getAnswerCount() {
        return this.answers != null ? this.answers.size() : 0;
    }

    /**
     * Lấy số lượng câu trả lời đúng
     *
     * @return Số lượng câu trả lời đúng
     */
    public int getCorrectAnswerCount() {
        if (this.answers == null) {
            return 0;
        }

        int count = 0;
        for (Answer answer : this.answers) {
            if (answer.isIsCorrect()) {
                count++;
            }
        }
        return count;
    }

    /**
     * Kiểm tra xem câu hỏi có nhiều câu trả lời đúng không
     *
     * @return true nếu có nhiều hơn 1 câu trả lời đúng, false nếu không
     */
    public boolean hasMultipleCorrectAnswers() {
        return getCorrectAnswerCount() > 1;
    }

    /**
     * Lấy quizId từ đối tượng Quiz Phương thức tiện ích để tránh
     * NullPointerException
     *
     * @return ID của quiz hoặc 0 nếu quiz là null
     */
    public int getQuizId() {
        return this.quiz != null ? this.quiz.getId() : 0;
    }
}
