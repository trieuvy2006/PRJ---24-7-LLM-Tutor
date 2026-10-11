<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản — AITA 24/7 LLM Tutor Platform</title>
    <meta name="description" content="Tạo tài khoản sinh viên trên hệ thống gia sư AI 24/7 tại FPT University.">
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
    <!-- ── CỘT TRÁI: HERO BANNER ── -->
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
                <span>Tham gia cộng đồng học tập thông minh</span>
            </div>

            <h1 class="hero-title">
                Khởi tạo hành trình làm chủ <span>Java Web</span> cùng AI
            </h1>

            <p class="hero-desc">
                Đăng ký tài khoản sinh viên chỉ trong vài bước để được cấp quyền truy cập phòng trợ giảng AI, nhận bài tập và theo dõi tiến độ học tập 24/7.
            </p>

            <div class="hero-features">
                <div class="feature-item">
                    <div class="feature-icon speed"><i class="bi bi-person-check-fill"></i></div>
                    <div class="feature-text">
                        <h4>Kích hoạt tài khoản tức thì</h4>
                        <p>Đồng bộ dữ liệu mã sinh viên và lớp học ngay sau khi hoàn tất đăng ký.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon ai"><i class="bi bi-shield-check"></i></div>
                    <div class="feature-text">
                        <h4>Bảo mật thông tin chuẩn mực</h4>
                        <p>Mật khẩu được mã hóa an toàn, phân quyền rõ ràng theo từng vai trò.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="hero-footer">
            <span>© 2026 PRJ301 — Lập trình Java Web • FPT University</span>
            <span>AITA Engine v2.4</span>
        </div>
    </div>

    <!-- ── CỘT PHẢI: FORM ĐĂNG KÝ ── -->
    <div class="auth-panel">
        <div class="auth-top-controls">
            <button type="button" class="btn-theme-toggle" aria-label="Đổi giao diện sáng/tối" title="Đổi giao diện sáng/tối">
                <i class="bi bi-sun-fill"></i>
            </button>
        </div>

        <div class="auth-card wide">
            <div class="auth-card-header">
                <h2 class="auth-card-title">Tạo tài khoản mới</h2>
                <p class="auth-card-sub">Điền các thông tin dưới đây để đăng ký tài khoản sinh viên.</p>
            </div>

            <!-- Error Box -->
            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-octagon-fill" style="font-size:16px; flex-shrink:0"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <!-- FORM ĐĂNG KÝ (Giữ nguyên chính xác action, method, name của input) -->
            <form id="register-form" action="register" method="post">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px">
                    <div class="form-group">
                        <label class="form-label" for="reg-username">Tên đăng nhập (*)</label>
                        <div class="input-wrapper">
                            <i class="bi bi-person-fill input-icon"></i>
                            <input id="reg-username" type="text" name="username" class="form-input"
                                   value="${username}" placeholder="VD: vynt, duynd..." required autofocus />
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="reg-password">Mật khẩu (*)</label>
                        <div class="input-wrapper">
                            <i class="bi bi-lock-fill input-icon"></i>
                            <input id="reg-password" type="password" name="password" class="form-input"
                                   placeholder="Tối thiểu 6 ký tự..." required />
                            <button type="button" class="btn-toggle-pass" aria-label="Hiện/ẩn mật khẩu">
                                <i class="bi bi-eye-fill"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-fullname">Họ và tên (*)</label>
                    <div class="input-wrapper">
                        <i class="bi bi-card-text input-icon"></i>
                        <input id="reg-fullname" type="text" name="full_name" class="form-input"
                               value="${full_name}" placeholder="Nguyễn Văn A..." required />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-email">Email FPT Edu (*)</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope-fill input-icon"></i>
                        <input id="reg-email" type="email" name="email" class="form-input"
                               value="${email}" placeholder="example@fpt.edu.vn..." required />
                    </div>
                </div>

                <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px">
                    <div class="form-group">
                        <label class="form-label" for="reg-phone">Số điện thoại</label>
                        <div class="input-wrapper">
                            <i class="bi bi-telephone-fill input-icon"></i>
                            <input id="reg-phone" type="text" name="phone" class="form-input"
                                   value="${phone}" placeholder="0987654321..." />
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="reg-scode">Mã sinh viên</label>
                        <div class="input-wrapper">
                            <i class="bi bi-upc-scan input-icon"></i>
                            <input id="reg-scode" type="text" name="student_code" class="form-input"
                                   value="${student_code}" placeholder="SE180001, QE200035..." />
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-class">Lớp học phụ trách</label>
                    <div class="input-wrapper">
                        <i class="bi bi-building input-icon"></i>
                        <select id="reg-class" name="class_id" class="form-input" style="padding-left:42px; cursor:pointer">
                            <option value="">-- Chọn lớp học (Dành cho Sinh viên) --</option>
                            <option value="1">SE1801 — Kỹ thuật Phần mềm 1801</option>
                            <option value="2">SE1802 — Kỹ thuật Phần mềm 1802</option>
                            <option value="3">IA1701 — An toàn Thông tin 1701</option>
                        </select>
                    </div>
                </div>

                <button id="btn-register" type="submit" class="btn-submit" style="margin-top:6px">
                    <span class="spinner"></span>
                    <span>Tạo tài khoản học viên</span>
                    <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="auth-divider">
                <span>hoặc</span>
            </div>

            <div class="auth-switch">
                Đã có tài khoản trên AITA?
                <a href="login">Đăng nhập ngay →</a>
            </div>
        </div>
    </div>
</div>

<!-- Global App Controller JS -->
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
