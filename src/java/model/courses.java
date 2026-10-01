/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class courses {
    private int course_id;
    private String course_code;
    private String course_name;
    private String description;

    public courses() {
    }

    public courses(int course_id, String course_code, String course_name, String description) {
        this.course_id = course_id;
        this.course_code = course_code;
        this.course_name = course_name;
        this.description = description;
    }

    public int getCourse_id() {
        return course_id;
    }

    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public String getCourse_code() {
        return course_code;
    }

    public void setCourse_code(String course_code) {
        this.course_code = course_code;
    }

    public String getCourse_name() {
        return course_name;
    }

    public void setCourse_name(String course_name) {
        this.course_name = course_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "courses{" + "course_id=" + course_id + ", course_code=" + course_code + ", course_name=" + course_name + ", description=" + description + '}';
    }
}
