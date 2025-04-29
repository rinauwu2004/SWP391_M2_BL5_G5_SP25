/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.model;

import java.util.Date;

/**
 *
 * @author ADMIN
 */
public class QuizResult {
    private int id;
    private int user_id;
    private int quiz_id;
    private double score;
    private Date submiited_time;

    public QuizResult() {
    }

    public QuizResult(int id, int user_id, int quiz_id, double score, Date submiited_time) {
        this.id = id;
        this.user_id = user_id;
        this.quiz_id = quiz_id;
        this.score = score;
        this.submiited_time = submiited_time;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getQuiz_id() {
        return quiz_id;
    }

    public void setQuiz_id(int quiz_id) {
        this.quiz_id = quiz_id;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public Date getSubmiited_time() {
        return submiited_time;
    }

    public void setSubmiited_time(Date submiited_time) {
        this.submiited_time = submiited_time;
    }
    
    
    
}
