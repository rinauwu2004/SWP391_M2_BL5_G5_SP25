/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.model;

public class ModuleClass {

    private int id;
    private String name;
    private String description;
    private String url;
    private Lesson lessonId;

    public ModuleClass() {
    }

    public ModuleClass(int id, String name, String description, String url, Lesson lessonId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.url = url;
        this.lessonId = lessonId;
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Lesson getLessonId() {
        return lessonId;
    }

    public void setLessonId(Lesson lessonId) {
        this.lessonId = lessonId;
    }

    @Override
    public String toString() {
        return "module{" + "id=" + id + ", name=" + name + ", description=" + description + ", url=" + url + ", lessonId=" + lessonId + '}';
    }

}
