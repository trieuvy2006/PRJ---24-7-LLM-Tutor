package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Tiện ích mã hóa và xác thực mật khẩu.
 * Sử dụng thuật toán SHA-256 chuẩn, đồng thời tương thích ngược với dữ liệu mẫu trong DB.
 */
public class PasswordUtil {

    /**
     * Băm mật khẩu bằng thuật toán SHA-256 sang chuỗi Hex.
     * @param password mật khẩu văn bản thô
     * @return chuỗi hash SHA-256 dạng hex (64 ký tự)
     */
    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            throw new RuntimeException("Lỗi thuật toán mã hóa SHA-256: " + e.getMessage(), e);
        }
    }

    /**
     * Kiểm tra tính hợp lệ của mật khẩu người dùng nhập so với mật khẩu đã lưu trong database.
     * Hỗ trợ:
     * 1. Khớp SHA-256 hex hash (dành cho tài khoản mới hoặc đổi mật khẩu).
     * 2. Khớp chuỗi hash tiền tố trong dữ liệu mẫu (ví dụ: 'hash_' + username/password).
     * 3. Khớp chuỗi nguyên bản (nếu DB chưa mã hóa).
     *
     * @param rawPassword mật khẩu thô người dùng nhập vào
     * @param storedHash chuỗi password_hash lưu trong database
     * @return true nếu mật khẩu đúng, false nếu sai
     */
    public static boolean verifyPassword(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null) {
            return false;
        }
        // 1. Kiểm tra khớp SHA-256
        String hashedRaw = hashPassword(rawPassword);
        if (storedHash.equalsIgnoreCase(hashedRaw)) {
            return true;
        }
        // 2. Kiểm tra khớp dữ liệu mẫu trong setup.sql (ví dụ: 'hash_admin_123' với password 'admin_123' hoặc chính 'hash_admin_123')
        if (storedHash.equals(rawPassword)) {
            return true;
        }
        if (storedHash.equals("hash_" + rawPassword)) {
            return true;
        }
        return false;
    }
}
