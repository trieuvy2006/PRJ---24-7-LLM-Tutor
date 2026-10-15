package model;

/**
 * Model đại diện cho bảng Classes trong database AITA_DB.
 */
public class ClassRoom {
    private int class_id;
    private String class_code;
    private String class_name;
    private int student_count;
    private String course_code;
    private String schedule;
    private String room;

    public ClassRoom() {
    }

    public ClassRoom(int class_id, String class_code, String class_name) {
        this.class_id = class_id;
        this.class_code = class_code;
        this.class_name = class_name;
    }

    public ClassRoom(int class_id, String class_code, String class_name, int student_count) {
        this.class_id = class_id;
        this.class_code = class_code;
        this.class_name = class_name;
        this.student_count = student_count;
    }

    public int getClass_id() {
        return class_id;
    }

    public void setClass_id(int class_id) {
        this.class_id = class_id;
    }

    public String getClass_code() {
        return class_code;
    }

    public void setClass_code(String class_code) {
        this.class_code = class_code;
    }

    public String getClass_name() {
        return class_name;
    }

    public void setClass_name(String class_name) {
        this.class_name = class_name;
    }

    public int getStudent_count() {
        return student_count;
    }

    public void setStudent_count(int student_count) {
        this.student_count = student_count;
    }

    public String getCourse_code() {
        return course_code != null ? course_code : "PRJ301";
    }

    public void setCourse_code(String course_code) {
        this.course_code = course_code;
    }

    public String getSchedule() {
        return schedule != null ? schedule : "Thứ 2, Thứ 4 (Ca 2: 09:30 - 11:50)";
    }

    public void setSchedule(String schedule) {
        this.schedule = schedule;
    }

    public String getRoom() {
        return room != null ? room : "Phòng 302";
    }

    public void setRoom(String room) {
        this.room = room;
    }

    /**
     * Kiểm tra số phòng hợp lệ:
     * Dãy phòng từ: 201-220, 301-320, 401-420, 501-520. Không có Alpha/Beta.
     */
    public static boolean isValidRoom(int roomNumber) {
        return (roomNumber >= 201 && roomNumber <= 220)
            || (roomNumber >= 301 && roomNumber <= 320)
            || (roomNumber >= 401 && roomNumber <= 420)
            || (roomNumber >= 501 && roomNumber <= 520);
    }
}
