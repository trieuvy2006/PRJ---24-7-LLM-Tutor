package model;

/**
 * Model đại diện cho bảng Roles trong database AITA_DB.
 * role_id = 1: ADMIN
 * role_id = 2: INSTRUCTOR
 * role_id = 3: STUDENT
 */
public class Role {
    public static final int ADMIN = 1;
    public static final int INSTRUCTOR = 2;
    public static final int STUDENT = 3;

    private int role_id;
    private String role_name;

    public Role() {
    }

    public Role(int role_id, String role_name) {
        this.role_id = role_id;
        this.role_name = role_name;
    }

    public int getRole_id() {
        return role_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
    }

    public String getRole_name() {
        return role_name;
    }

    public void setRole_name(String role_name) {
        this.role_name = role_name;
    }

    public static String getRoleNameById(int roleId) {
        switch (roleId) {
            case ADMIN:
                return "ADMIN";
            case INSTRUCTOR:
                return "INSTRUCTOR";
            case STUDENT:
                return "STUDENT";
            default:
                return "UNKNOWN (" + roleId + ")";
        }
    }

    @Override
    public String toString() {
        return "Role{" + "role_id=" + role_id + ", role_name=" + role_name + '}';
    }
}
