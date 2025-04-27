/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.model;

import java.util.Date;

public class Lesson {

    private int id;
    private String name;
    private String description;
    private Subject subjectId;
    private int status;
    private Date modifiedAt;
    private Date createdAt;

    public Lesson() {
    }

    public Lesson(int id, String name, String description, Subject subjectId, int status, Date modifiedAt, Date createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.subjectId = subjectId;
        this.status = status;
        this.modifiedAt = modifiedAt;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Subject getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(Subject subjectId) {
        this.subjectId = subjectId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(Date modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Lesson{" + "id=" + id + ", name=" + name + ", description=" + description + ", subjectId=" + subjectId + ", status=" + status + ", modifiedAt=" + modifiedAt + ", createdAt=" + createdAt + '}';
    }

}
