package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng Users trong database AITA_DB.
 * Lưu trữ thông tin tài khoản người dùng: Admin, Giảng viên, Sinh viên.
 */
public class User {
    private int user_id;
    private int role_id;
    private String username;
    private String password_hash;
    private String full_name;
    private String email;
    private String phone;
    private String student_code;
    private Integer class_id;
    private Timestamp created_at;
    
    // Tên vai trò (ADMIN, INSTRUCTOR, STUDENT) để hiển thị thân thiện
    private String role_name;

    public User() {
    }

    // Constructor giữ nguyên cho code cũ đọc data từ DB (6 tham số)
    public User(int user_id, int role_id, String username, String full_name, String email, String phone) {
        this.user_id = user_id;
        this.role_id = role_id;
        this.username = username;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
        this.role_name = Role.getRoleNameById(role_id);
    }

    // Constructor giữ nguyên khi thêm mới không có user_id (5 tham số)
    public User(int role_id, String username, String full_name, String email, String phone) {
        this.role_id = role_id;
        this.username = username;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
        this.role_name = Role.getRoleNameById(role_id);
    }

    // Constructor giữ nguyên khi thêm mới có password_hash (6 tham số)
    public User(int role_id, String username, String password_hash, String full_name, String email, String phone) {
        this.role_id = role_id;
        this.username = username;
        this.password_hash = password_hash;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
        this.role_name = Role.getRoleNameById(role_id);
    }

    // Constructor giữ nguyên có user_id và password_hash (7 tham số)
    public User(int user_id, int role_id, String username, String password_hash, String full_name, String email, String phone) {
        this.user_id = user_id;
        this.role_id = role_id;
        this.username = username;
        this.password_hash = password_hash;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
        this.role_name = Role.getRoleNameById(role_id);
    }

    // Constructor đầy đủ tất cả các trường trong bảng Users của database AITA_DB
    public User(int user_id, int role_id, String username, String password_hash, String full_name, 
                String email, String phone, String student_code, Integer class_id, Timestamp created_at) {
        this.user_id = user_id;
        this.role_id = role_id;
        this.username = username;
        this.password_hash = password_hash;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
        this.student_code = student_code;
        this.class_id = class_id;
        this.created_at = created_at;
        this.role_name = Role.getRoleNameById(role_id);
    }

    // Constructor tạo mới đầy đủ thông tin (chưa có user_id và created_at do DB tự sinh)
    public User(int role_id, String username, String password_hash, String full_name, 
                String email, String phone, String student_code, Integer class_id) {
        this.role_id = role_id;
        this.username = username;
        this.password_hash = password_hash;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
        this.student_code = student_code;
        this.class_id = class_id;
        this.role_name = Role.getRoleNameById(role_id);
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getRole_id() {
        return role_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
        this.role_name = Role.getRoleNameById(role_id);
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStudent_code() {
        return student_code;
    }

    public void setStudent_code(String student_code) {
        this.student_code = student_code;
    }

    public Integer getClass_id() {
        return class_id;
    }

    public void setClass_id(Integer class_id) {
        this.class_id = class_id;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public String getRole_name() {
        if (role_name == null || role_name.isEmpty()) {
            role_name = Role.getRoleNameById(role_id);
        }
        return role_name;
    }

    public void setRole_name(String role_name) {
        this.role_name = role_name;
    }

    // Các hàm tiện ích kiểm tra phân quyền
    public boolean isAdmin() {
        return this.role_id == Role.ADMIN;
    }

    public boolean isStudent() {
        return this.role_id == Role.STUDENT;
    }

    public boolean isInstructor() {
        return this.role_id == Role.INSTRUCTOR;
    }

    @Override
    public String toString() {
        return String.format("ID: %-3d | Role: %-10s | Username: %-15s | Họ tên: %-22s | Email: %-25s | SĐT: %-11s | MSSV: %-10s | Lớp: %s",
                user_id, getRole_name(), username, full_name, email, 
                (phone != null ? phone : "-"), 
                (student_code != null ? student_code : "-"), 
                (class_id != null ? class_id : "-"));
    }
}