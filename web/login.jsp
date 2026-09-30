<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng nhập - LLM Tutor</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; display: flex; justify-content: center; align-items: center; min-height: 80vh; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 360px; }
        .card h2 { text-align: center; margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 14px; }
        .form-group input { width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .btn:hover { background-color: #0056b3; }
        .error { color: #dc3545; margin-bottom: 15px; font-size: 14px; text-align: center; }
        .links { margin-top: 15px; text-align: center; font-size: 14px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Đăng Nhập</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="login" method="post">
            <div class="form-group">
                <label>Tên đăng nhập:</label>
                <input type="text" name="username" value="${username}" required autofocus />
            </div>
            <div class="form-group">
                <label>Mật khẩu:</label>
                <input type="password" name="password" required />
            </div>
            <button type="submit" class="btn">Đăng nhập</button>
        </form>
        <div class="links">
            Chưa có tài khoản? <a href="register">Đăng ký ngay</a>
        </div>
    </div>
</body>
</html>
