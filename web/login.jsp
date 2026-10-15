<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — AITA</title>
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Auth CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <!-- Theme Flash Prevention -->
    <script>
        (function() {
            var t = localStorage.getItem('aita_theme_pref') || 'dark';
            document.documentElement.setAttribute('data-theme', t);
        })();
    </script>
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-panel">
        <div class="auth-top-controls">
            <button type="button" class="btn-theme-toggle" aria-label="Đổi giao diện sáng/tối" title="Đổi giao diện sáng/tối">
                <i class="bi bi-sun-fill"></i>
            </button>
        </div>

        <div class="auth-card">
            <!-- Tên Website & Logo -->
            <div class="auth-card-header" style="text-align: center; margin-bottom: 24px;">
                <div style="display: inline-flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;">
                    <div class="brand-icon" style="width: 40px; height: 40px; font-size: 20px;">A</div>
                    <span style="font-size: 24px; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em;">AITA Tutor</span>
                </div>
                <h2 class="auth-card-title" style="margin: 0; font-size: 22px;">Đăng nhập</h2>
            </div>

            <!-- Thông báo Lỗi Đăng Nhập -->
            <c:if test="${not empty error or not empty param.error}">
                <div class="alert-box alert-error" id="login-error-alert" role="alert">
                    <i class="bi bi-exclamation-octagon-fill" style="font-size:18px; flex-shrink:0"></i>
                    <div>
                        <c:choose>
                            <c:when test="${not empty error}">${error}</c:when>
                            <c:when test="${param.error eq 'access_denied'}">
                                Vui lòng đăng nhập để tiếp tục.
                            </c:when>
                            <c:when test="${param.error eq 'admin_only'}">
                                Tài khoản không có quyền truy cập trang này.
                            </c:when>
                            <c:when test="${param.error eq 'invalid'}">
                                Tên đăng nhập hoặc mật khẩu không chính xác!
                            </c:when>
                            <c:otherwise>${param.error}</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <!-- Thông báo Đăng xuất thành công -->
            <c:if test="${param.message eq 'logged_out'}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill" style="font-size:16px; flex-shrink:0"></i>
                    <div>Đã đăng xuất thành công.</div>
                </div>
            </c:if>

            <!-- FORM ĐĂNG NHẬP -->
            <form id="login-form" action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <div class="input-wrapper">
                        <i class="bi bi-person-fill input-icon"></i>
                        <input id="username" type="text" name="username" class="form-input"
                               value="${not empty username ? username : cookie.cuser.value}"
                               placeholder="Nhập tên đăng nhập" required autofocus />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="bi bi-lock-fill input-icon"></i>
                        <input id="password" type="password" name="password" class="form-input"
                               value="${cookie.cpass.value}"
                               placeholder="Nhập mật khẩu" required />
                        <button type="button" class="btn-toggle-pass" aria-label="Hiện/ẩn mật khẩu">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                    </div>
                </div>

                <div class="form-check-row">
                    <label class="checkbox-label" for="remember">
                        <input type="checkbox" name="remember" id="remember"
                               ${not empty cookie.cuser ? 'checked' : ''} />
                        <span>Ghi nhớ mật khẩu</span>
                    </label>
                </div>

                <button id="btn-login" type="submit" class="btn-submit">
                    <span class="spinner"></span>
                    <span>Đăng nhập</span>
                </button>
            </form>

            <div class="auth-divider">
                <span>hoặc</span>
            </div>

            <div class="auth-switch">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </div>
        </div>
    </div>
</div>

<!-- Global App Controller JS -->
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
