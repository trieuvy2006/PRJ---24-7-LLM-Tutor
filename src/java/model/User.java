package model;

public class User {
    int user_id, role_id;
    String username, full_name, email, phone,password_hash;

    // Constructor đầy đủ - dùng khi đọc data từ DB (đã có user_id)
    public User(int user_id, int role_id, String username, String full_name, String email, String phone) {
        this.user_id = user_id;
        this.role_id = role_id;
        this.username = username;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
    }

    // Constructor không có user_id - dùng khi thêm mới (để DB tự sinh ID)
    public User(int role_id, String username, String full_name, String email, String phone) {
        this.role_id = role_id;
        this.username = username;
        this.full_name = full_name;
        this.email = email;
        this.phone = phone;
    }
    
    public User(int role_id, String username, String password_hash, String full_name, String email, String phone) {
    this.role_id = role_id;
    this.username = username;
    this.password_hash = password_hash;
    this.full_name = full_name;
    this.email = email;
    this.phone = phone;
}
    public User(int user_id, int role_id, String username, String password_hash, String full_name, String email, String phone) {
    this.user_id = user_id;
    this.role_id = role_id;
    this.username = username;
    this.password_hash = password_hash;
    this.full_name = full_name;
    this.email = email;
    this.phone = phone;
}

    public int getUser_id() {
        return user_id;
    }

    public int getRole_id() {
        return role_id;
    }

    public String getUsername() {
        return username;
    }

    public String getFull_name() {
        return full_name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }
    
}