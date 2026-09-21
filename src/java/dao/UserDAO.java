package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;
import util.DBContext;

public class UserDAO extends DBContext {

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Users";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User c = new User(rs.getInt("User_id"),
                        rs.getInt("role_id"),
                        rs.getString("username"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

 public String insert(User u) {
    String sql = "INSERT INTO dbo.Users (role_id, username, password_hash, full_name, email, phone) "
               + "VALUES (?,?,?,?,?,?)";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, u.getRole_id());
        st.setString(2, u.getUsername());
        st.setString(3, u.getPassword_hash());
        st.setString(4, u.getFull_name());
        st.setString(5, u.getEmail());
        st.setString(6, u.getPhone());
        st.executeUpdate();
        return null;
    } catch (SQLException e) {
        return e.getMessage();
    }
}

    public User getUserById(int user_id) {
        String sql = "SELECT * FROM dbo.Users WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, user_id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("User_id"),
                        rs.getInt("role_id"),
                        rs.getString("username"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }
    
public String delete(int user_id) {
        String sql = "DELETE FROM dbo.Users WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, user_id);
            st.executeUpdate();
            return null;
        } catch (SQLException e) {
            return e.getMessage();
        }
    }

 public String update(User u) {
        String sql = "UPDATE dbo.Users SET role_id=?, username=?, full_name=?, email=?, phone=? "
                   + "WHERE user_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, u.getRole_id());
            st.setString(2, u.getUsername());
            st.setString(3, u.getFull_name());
            st.setString(4, u.getEmail());
            st.setString(5, u.getPhone());
            st.setInt(6, u.getUser_id());
            st.executeUpdate();
            return null;
        } catch (SQLException e) {
            return e.getMessage();
        }
    }
}