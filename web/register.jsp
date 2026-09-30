<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký tài khoản - LLM Tutor</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; display: flex; justify-content: center; align-items: center; min-height: 90vh; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 420px; }
        .card h2 { text-align: center; margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 12px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 13px; }
        .form-group input { width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn:hover { background-color: #218838; }
        .error { color: #dc3545; margin-bottom: 15px; font-size: 14px; text-align: center; }
        .links { margin-top: 15px; text-align: center; font-size: 14px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Đăng Ký Tài Khoản</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="register" method="post">
            <div class="form-group">
                <label>Tên đăng nhập (*):</label>
                <input type="text" name="username" value="${username}" required />
            </div>
            <div class="form-group">
                <label>Mật khẩu (*):</label>
                <input type="password" name="password" required />
            </div>
            <div class="form-group">
                <label>Họ và tên (*):</label>
                <input type="text" name="full_name" value="${full_name}" required />
            </div>
            <div class="form-group">
                <label>Email (*):</label>
                <input type="email" name="email" value="${email}" required />
            </div>
            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="phone" value="${phone}" />
            </div>
            <div class="form-group">
                <label>Mã sinh viên:</label>
                <input type="text" name="student_code" value="${student_code}" placeholder="Ví dụ: SE180001" />
            </div>
            <div class="form-group">
                <label>Lớp học (Class ID):</label>
                <input type="number" name="class_id" placeholder="1: SE1801, 2: SE1802, 3: IA1701" />
            </div>
            <button type="submit" class="btn">Đăng ký ngay</button>
        </form>
        <div class="links">
            Đã có tài khoản? <a href="login">Đăng nhập</a>
        </div>
    </div>
</body>
</html>
