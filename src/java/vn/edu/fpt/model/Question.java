/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.model;

import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
public class Question {
    private int id;
    private String description;
    private String option;
    private String correc_answer;

    public Question() {
    }

    public Question(int id, String description, String option, String correc_answer) {
        this.id = id;
        this.description = description;
        this.option = option;
        this.correc_answer = correc_answer;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getOption() {
        return option;
    }

    public void setOption(String option) {
        this.option = option;
    }

    public String getCorrec_answer() {
        return correc_answer;
    }

    public void setCorrec_answer(String correc_answer) {
        this.correc_answer = correc_answer;
    }
    
    
    
    
}
