/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.model;

import java.sql.Timestamp;

/**
 *
 * @author Rinaaaa
 */
public class QuizAttempt {
    private int id;
    private User student;
    private Quiz quiz;
    private Timestamp startedTime;
    private Timestamp submittedTime;
    private float score;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getStudent() {
        return student;
    }

    public void setStudent(User student) {
        this.student = student;
    }

    public Quiz getQuiz() {
        return quiz;
    }

    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }

    public Timestamp getStartedTime() {
        return startedTime;
    }

    public void setStartedTime(Timestamp startedTime) {
        this.startedTime = startedTime;
    }

    public Timestamp getSubmittedTime() {
        return submittedTime;
    }

    public void setSubmittedTime(Timestamp submittedTime) {
        this.submittedTime = submittedTime;
    }

    public float getScore() {
        return score;
    }

    public void setScore(float score) {
        this.score = score;
    }

    public long getDurationInSeconds() {
        if (startedTime == null || submittedTime == null) {
            return 0;
        }
        return (submittedTime.getTime() - startedTime.getTime()) / 1000;
    }

    public String getFormattedDuration() {
        long seconds = getDurationInSeconds();
        long minutes = seconds / 60;
        long remainingSeconds = seconds % 60;

        return String.format("%d:%02d", minutes, remainingSeconds);
    }

    public String getStatus() {
        if (submittedTime == null) {
            return "In Progress";
        } else {
            return "Completed";
        }
    }

    public String getScorePercentage() {
        return String.format("%.1f%%", score * 100);
    }
}
