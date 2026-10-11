<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — AITA 24/7 LLM Tutor Platform</title>
    <meta name="description" content="Đăng nhập vào hệ thống gia sư AI thông minh 24/7 cho sinh viên FPT University.">
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
    <!-- ── CỘT TRÁI: HERO BANNER GIỚI THIỆU HỆ THỐNG GIA SƯ AI ── -->
    <div class="auth-hero">
        <div class="auth-hero-glow"></div>

        <div class="hero-brand">
            <div class="brand-icon">A</div>
            <div>
                <div class="brand-name">AITA Platform</div>
            </div>
            <span class="brand-tag">FPT EDU • 24/7 AI</span>
        </div>

        <div class="hero-content">
            <div class="hero-badge">
                <span class="status-ping"></span>
                <span>Hệ thống AI Tutor đang trực tuyến</span>
            </div>

            <h1 class="hero-title">
                Học tập không gián đoạn cùng <span>Gia sư AI 24/7</span>
            </h1>

            <p class="hero-desc">
                Giải đáp lỗi code, gỡ rối thuật toán Java Web và đồng hành cùng sinh viên FPT University mọi lúc, mọi nơi ngay khi giảng viên vắng mặt.
            </p>

            <div class="hero-features">
                <div class="feature-item">
                    <div class="feature-icon ai"><i class="bi bi-robot"></i></div>
                    <div class="feature-text">
                        <h4>Trợ lý LLM chuyên sâu cho PRJ301</h4>
                        <p>Tự động phân tích NullPointer, lỗi SQL và cấu trúc MVC theo thời gian thực.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon code"><i class="bi bi-code-slash"></i></div>
                    <div class="feature-text">
                        <h4>Gợi ý phương pháp, không chép hộ</h4>
                        <p>Hướng dẫn tư duy từng bước theo chuẩn đầu ra của môn học.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon speed"><i class="bi bi-lightning-charge-fill"></i></div>
                    <div class="feature-text">
                        <h4>Phản hồi tức thì dưới 1 giây</h4>
                        <p>Sẵn sàng hỗ trợ 24/7 ngay cả trong các buổi ôn thi hay làm đồ án đêm.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="hero-footer">
            <span>© 2026 PRJ301 — Lập trình Java Web • FPT University</span>
            <span>AITA Engine v2.4</span>
        </div>
    </div>

    <!-- ── CỘT PHẢI: FORM ĐĂNG NHẬP GỌN GÀNG, HIỆN ĐẠI ── -->
    <div class="auth-panel">
        <div class="auth-top-controls">
            <button type="button" class="btn-theme-toggle" aria-label="Đổi giao diện sáng/tối" title="Đổi giao diện sáng/tối">
                <i class="bi bi-sun-fill"></i>
            </button>
        </div>

        <div class="auth-card">
            <div class="auth-card-header">
                <h2 class="auth-card-title">Đăng nhập</h2>
                <p class="auth-card-sub">Chào mừng trở lại! Vui lòng nhập thông tin tài khoản.</p>
            </div>

            <!-- Thông báo Lỗi -->
            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-octagon-fill" style="font-size:16px; flex-shrink:0"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <!-- Thông báo Đăng xuất thành công -->
            <c:if test="${param.message eq 'logged_out'}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill" style="font-size:16px; flex-shrink:0"></i>
                    <div>Bạn đã đăng xuất an toàn khỏi hệ thống.</div>
                </div>
            </c:if>

            <!-- FORM ĐĂNG NHẬP (Giữ nguyên chính xác action, method, name của input) -->
            <form id="login-form" action="login" method="post">
                <div class="form-group">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <div class="input-wrapper">
                        <i class="bi bi-person-fill input-icon"></i>
                        <input id="username" type="text" name="username" class="form-input"
                               value="${not empty username ? username : cookie.cuser.value}"
                               placeholder="Nhập tên tài khoản..." required autofocus />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="bi bi-lock-fill input-icon"></i>
                        <input id="password" type="password" name="password" class="form-input"
                               value="${cookie.cpass.value}"
                               placeholder="Nhập mật khẩu..." required />
                        <button type="button" class="btn-toggle-pass" aria-label="Hiện/ẩn mật khẩu">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                    </div>
                </div>

                <div class="form-check-row">
                    <label class="checkbox-label" for="remember">
                        <input type="checkbox" name="remember" id="remember"
                               ${not empty cookie.cuser ? 'checked' : ''} />
                        <span>Ghi nhớ đăng nhập trong 7 ngày</span>
                    </label>
                </div>

                <button id="btn-login" type="submit" class="btn-submit">
                    <span class="spinner"></span>
                    <span>Đăng nhập vào hệ thống</span>
                    <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="auth-divider">
                <span>hoặc</span>
            </div>

            <div class="auth-switch">
                Chưa có tài khoản học viên?
                <a href="register">Tạo tài khoản ngay →</a>
            </div>
        </div>
    </div>
</div>

<!-- Global App Controller JS -->
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
