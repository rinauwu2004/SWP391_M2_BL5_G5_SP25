package vn.edu.fpt.model;

/**
 *
 * @author Rinaaaa
 */
public class Answer {

    private int id;
    private Question question;
    private String content;
    private boolean isCorrect;

    private int questionId;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Question getQuestion() {
        return question;
    }

    public void setQuestion(Question question) {
        this.question = question;
        if (question != null) {
            this.questionId = question.getId();
        }
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    /**
     * Lấy questionId trực tiếp hoặc từ đối tượng Question
     *
     * @return ID của câu hỏi
     */
    public int getQuestionId() {
        if (question != null) {
            return question.getId();
        }
        return questionId;
    }

    /**
     * Thiết lập questionId trực tiếp
     *
     * @param questionId ID của câu hỏi
     */
    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    /**
     * Kiểm tra xem câu trả lời có đúng không Phương thức tiện ích để sử dụng
     * trong JSP
     *
     * @return true nếu câu trả lời đúng, false nếu sai
     */
    public boolean isCorrect() {
        return isCorrect;
    }

    /**
     * So sánh với một câu trả lời khác
     *
     * @param other Câu trả lời khác
     * @return true nếu hai câu trả lời có cùng ID, false nếu không
     */
    public boolean equals(Answer other) {
        if (other == null) {
            return false;
        }
        return this.id == other.id;
    }

    /**
     * Kiểm tra xem câu trả lời có thuộc về câu hỏi không
     *
     * @param questionId ID của câu hỏi cần kiểm tra
     * @return true nếu câu trả lời thuộc về câu hỏi, false nếu không
     */
    public boolean belongsToQuestion(int questionId) {
        return getQuestionId() == questionId;
    }
}
