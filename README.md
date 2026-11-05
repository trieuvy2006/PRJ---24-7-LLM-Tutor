# AITA — Nền Tảng Học Tập & Hỗ Trợ Sinh Viên (PRJ301)

Dự án Java Web Application (Servlet, JSP, JSTL, JDBC, SQL Server) xây dựng trên NetBeans (Ant Build) và Apache Tomcat 10.0 (tương thích JDK 8).

```text
Browser (JSP/JSTL) ⇄ Controller (Servlet/Filter) ⇄ Service ⇄ DAO ⇄ MS SQL Server (AITA_DB)
                                                  ⇄ Supabase Cloud Storage (Nộp bài tập)
                                                  ⇄ Gemini API (Trợ lý học tập)
```

## 1. Chạy trên NetBeans

1. Mở thư mục này trong NetBeans dưới dạng dự án **AITA**.
2. Kiểm tra thư viện `lib/sqljdbc42-6.0.8112.jar` và JSTL 2.0 đã có trong mục Libraries.
3. Chọn Apache Tomcat 10.0 làm Web Server.
4. Chạy script `data/setup.sql` trong SQL Server để khởi tạo database `AITA_DB`.
   *(Nếu database đã có từ trước, chạy thêm `data/upgrade_supabase.sql` để mở rộng cột `file_path` lên 500 ký tự).*
5. Bấm **Run Project** và mở `http://localhost:8080/AITA/`.

`src/java/util/DBContext.java` mặc định kết nối MS SQL Server tại `localhost:1433`, database `AITA_DB`, user `sa`, pass `123`.

---

## 2. Cấu hình Supabase Cloud Storage (Nộp & Lưu trữ bài làm)

Hệ thống đã được nâng cấp chuyển đổi hoàn toàn từ lưu trữ local disk sang **Supabase Cloud Object Storage**:

1. Tạo một dự án miễn phí trên [Supabase.com](https://supabase.com).
2. Vào **Storage** -> Nhấn **New Bucket** -> Đặt tên bucket là `submissions` -> Bật chế độ **Public bucket**.
3. Vào **Project Settings** -> **API** -> Lấy **Project URL** và **anon key** (hoặc **service_role key**).
4. Điền vào file `aitutor.properties`:
   ```properties
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_KEY=your-supabase-api-key
   SUPABASE_BUCKET=submissions
   ```
5. Khi sinh viên nộp bài:
   - File ZIP được kiểm tra mã băm toàn vẹn **SHA-256**.
   - Tự động upload nhị phân trực tiếp lên Supabase Cloud Storage.
   - Database lưu trữ đường dẫn Cloud URL công khai: `https://...supabase.co/storage/v1/object/public/submissions/...zip`.
   - Giảng viên và sinh viên có thể tải bài làm trực tiếp từ Cloud hoặc mở trực tiếp trên Cloud Storage CDN.
   - *Cơ chế Fallback an toàn*: Nếu chưa điền key hoặc mất kết nối mạng, hệ thống tự động lưu trữ dự phòng cục bộ mà không gây gián đoạn hay lỗi hệ thống.

---

## 3. Cấu hình Trợ lý Học tập (Gemini API)

Điền API Key vào file `aitutor.properties`:
```properties
GEMINI_API_KEY=your-gemini-api-key-here
GEMINI_MODEL=gemini-3.5-flash-lite
```
Hoặc thiết lập biến môi trường trước khi khởi động Tomcat:
```powershell
$env:GEMINI_API_KEY = "your-key-here"
```
