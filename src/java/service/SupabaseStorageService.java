package service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 * Service tích hợp Supabase Cloud Storage để lưu trữ bài nộp sinh viên (.zip).
 * Thay thế hoàn toàn cơ chế nộp bài và tải về local, đáp ứng tiêu chuẩn chấm đồ án môn PRJ301.
 * 
 * Tương thích Java 8 (dùng HttpURLConnection thuần túy, không phụ thuộc thư viện ngoài).
 */
public class SupabaseStorageService {

    private static final int CONNECT_TIMEOUT_MS = 15_000;
    private static final int READ_TIMEOUT_MS = 120_000;

    public static class StorageResult {
        private final boolean success;
        private final String fileUrl;
        private final boolean cloud;
        private final String message;

        public StorageResult(boolean success, String fileUrl, boolean cloud, String message) {
            this.success = success;
            this.fileUrl = fileUrl;
            this.cloud = cloud;
            this.message = message;
        }

        public boolean isSuccess() { return success; }
        public String getFileUrl() { return fileUrl; }
        public boolean isCloud() { return cloud; }
        public String getMessage() { return message; }
    }

    /**
     * Kiểm tra Supabase Storage đã được cấu hình hay chưa.
     */
    public static boolean isConfigured() {
        String url = getSupabaseUrl();
        String key = getSupabaseKey();
        return url != null && !url.trim().isEmpty() && key != null && !key.trim().isEmpty();
    }

    public static String getSupabaseUrl() {
        return readConfig("SUPABASE_URL", "supabase.url");
    }

    public static String getSupabaseKey() {
        return readConfig("SUPABASE_KEY", "supabase.key");
    }

    public static String getSupabaseBucket() {
        String bucket = readConfig("SUPABASE_BUCKET", "supabase.bucket");
        return (bucket != null && !bucket.trim().isEmpty()) ? bucket.trim() : "submissions";
    }

    /**
     * Upload file dữ liệu lên Supabase Storage qua REST API.
     * 
     * Endpoint Supabase:
     * POST {SUPABASE_URL}/storage/v1/object/{BUCKET}/{FILE_NAME}
     * Headers:
     *   apikey: {SUPABASE_KEY}
     *   Authorization: Bearer {SUPABASE_KEY}
     *   Content-Type: application/zip
     *   x-upsert: true
     */
    public static StorageResult uploadFile(byte[] fileData, String fileName, String contentType) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return new StorageResult(false, null, false, "Tên file không hợp lệ.");
        }

        String rawUrl = getSupabaseUrl();
        String key = getSupabaseKey();
        String bucket = getSupabaseBucket();

        if (rawUrl == null || rawUrl.trim().isEmpty() || key == null || key.trim().isEmpty()) {
            return new StorageResult(false, null, false,
                    "Chưa cấu hình SUPABASE_URL hoặc SUPABASE_KEY trong aitutor.properties.");
        }

        // Chuẩn hóa Base URL (bỏ dấu gạch chéo cuối nếu có)
        String baseUrl = rawUrl.trim();
        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }

        // Tên file lưu trên cloud (an toàn ký tự URL)
        String cleanFileName = fileName.replace(" ", "_");

        String endpoint = baseUrl + "/storage/v1/object/" + bucket + "/" + cleanFileName;
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(CONNECT_TIMEOUT_MS);
            conn.setReadTimeout(READ_TIMEOUT_MS);
            conn.setDoOutput(true);

            // Supabase Auth & Headers
            conn.setRequestProperty("apikey", key.trim());
            conn.setRequestProperty("Authorization", "Bearer " + key.trim());
            conn.setRequestProperty("Content-Type", (contentType != null && !contentType.isEmpty()) ? contentType : "application/zip");
            conn.setRequestProperty("x-upsert", "true"); // Cho phép ghi đè nếu upload lại lần nộp cùng phiên
            conn.setFixedLengthStreamingMode(fileData.length);

            // Gửi dữ liệu file nhị phân
            try (OutputStream out = conn.getOutputStream()) {
                out.write(fileData);
                out.flush();
            }

            int statusCode = conn.getResponseCode();
            if (statusCode >= 200 && statusCode < 300) {
                // Upload Supabase thành công!
                // Sinh Public URL chuẩn của Supabase Storage
                String publicUrl = baseUrl + "/storage/v1/object/public/" + bucket + "/" + cleanFileName;
                return new StorageResult(true, publicUrl, true, "Upload Supabase thành công.");
            } else {
                // Đọc thông báo lỗi từ Supabase
                String errBody = "";
                try (InputStream errStream = conn.getErrorStream()) {
                    if (errStream != null) {
                        BufferedReader reader = new BufferedReader(new InputStreamReader(errStream, StandardCharsets.UTF_8));
                        StringBuilder sb = new StringBuilder();
                        String line;
                        while ((line = reader.readLine()) != null) {
                            sb.append(line);
                        }
                        errBody = sb.toString();
                    }
                } catch (Exception ignored) {}

                return new StorageResult(false, null, false,
                        "Supabase Storage trả về HTTP " + statusCode + ": " + errBody);
            }
        } catch (Exception ex) {
            return new StorageResult(false, null, false, "Lỗi kết nối Supabase Storage: " + ex.getMessage());
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    /**
     * Mở InputStream tải trực tiếp từ Supabase Cloud.
     */
    public static HttpURLConnection openDownloadConnection(String remoteUrl) throws IOException {
        URL url = new URL(remoteUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(CONNECT_TIMEOUT_MS);
        conn.setReadTimeout(READ_TIMEOUT_MS);

        String key = getSupabaseKey();
        if (key != null && !key.trim().isEmpty()) {
            conn.setRequestProperty("apikey", key.trim());
            conn.setRequestProperty("Authorization", "Bearer " + key.trim());
        }
        return conn;
    }

    /**
     * Đọc cấu hình từ aitutor.properties, System Properties hoặc Environment Variables.
     */
    private static String readConfig(String envKey, String propKey) {
        // 1. Kiểm tra file cấu hình aitutor.properties
        try {
            File[] searchLocations = new File[] {
                new File("aitutor.properties"),
                new File("D:\\Github\\PRJ---24-7-LLM-Tutor\\aitutor.properties"),
                new File("../aitutor.properties")
            };
            for (File f : searchLocations) {
                if (f.exists() && f.isFile()) {
                    try (FileInputStream fis = new FileInputStream(f)) {
                        Properties props = new Properties();
                        props.load(fis);
                        String val = props.getProperty(propKey);
                        if (val == null) val = props.getProperty(envKey);
                        if (val != null && !val.trim().isEmpty()) return val.trim();
                    }
                }
            }
        } catch (Exception ignored) {}

        // 2. System Property
        String sysProp = System.getProperty(propKey);
        if (sysProp != null && !sysProp.trim().isEmpty()) return sysProp.trim();

        // 3. System Environment
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) return envVal.trim();

        return null;
    }
}

