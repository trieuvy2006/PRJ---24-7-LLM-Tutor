<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản — AITA</title>
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

        <div class="auth-card wide">
            <!-- Tên Website & Logo -->
            <div class="auth-card-header" style="text-align: center; margin-bottom: 24px;">
                <div style="display: inline-flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;">
                    <div class="brand-icon" style="width: 40px; height: 40px; font-size: 20px;">A</div>
                    <span style="font-size: 24px; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em;">AITA Tutor</span>
                </div>
                <h2 class="auth-card-title" style="margin: 0; font-size: 22px;">Đăng ký tài khoản</h2>
            </div>

            <!-- Error Box -->
            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-octagon-fill" style="font-size:16px; flex-shrink:0"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <!-- FORM ĐĂNG KÝ -->
            <form id="register-form" action="${pageContext.request.contextPath}/register" method="post">
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
                    <label class="form-label" for="reg-email">Email (*)</label>
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
                        <label class="form-label" for="reg-scode">Mã sinh viên (*)</label>
                        <div class="input-wrapper">
                            <i class="bi bi-upc-scan input-icon"></i>
                            <input id="reg-scode" type="text" name="student_code" class="form-input"
                                   value="${student_code}" placeholder="SE180001, QE200035..." required />
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-class">Lớp học (*)</label>
                    <div class="input-wrapper">
                        <i class="bi bi-building input-icon"></i>
                        <select id="reg-class" name="class_id" class="form-input" style="padding-left:42px; cursor:pointer" required>
                            <option value="">-- Chọn lớp học --</option>
                            <option value="1">SE1801 — Java Web Application Development</option>
                            <option value="2">SE1802 — Data Structures and Algorithms</option>
                            <option value="3">AI1701 — Internet of Things</option>
                        </select>
                    </div>
                </div>

                <!-- Môn học đăng ký trong kỳ (Chọn nhiều môn, mặc định cả 5 môn) -->
                <div class="form-group" style="margin-top: 10px;">
                    <label class="form-label">
                        <i class="bi bi-journal-bookmark-fill"></i> Môn học đăng ký trong kỳ (*)
                    </label>
                    <div class="course-checkbox-container">
                        <label class="course-check-item">
                            <input type="checkbox" name="course_codes" value="IOT102" checked>
                            <span class="course-code-badge">IOT102</span>
                            <span class="course-name-text">Internet of Things</span>
                        </label>
                        <label class="course-check-item">
                            <input type="checkbox" name="course_codes" value="PRJ301" checked>
                            <span class="course-code-badge">PRJ301</span>
                            <span class="course-name-text">Java Web Application Development</span>
                        </label>
                        <label class="course-check-item">
                            <input type="checkbox" name="course_codes" value="SWR302" checked>
                            <span class="course-code-badge">SWR302</span>
                            <span class="course-name-text">Software Requirements</span>
                        </label>
                        <label class="course-check-item">
                            <input type="checkbox" name="course_codes" value="JPD123" checked>
                            <span class="course-code-badge">JPD123</span>
                            <span class="course-name-text">Elementary Japanese 1</span>
                        </label>
                        <label class="course-check-item">
                            <input type="checkbox" name="course_codes" value="CSD201" checked>
                            <span class="course-code-badge">CSD201</span>
                            <span class="course-name-text">Data Structures and Algorithms</span>
                        </label>
                    </div>
                    <span class="field-hint" style="display:block; margin-top:6px; font-size:12px; color:var(--text-subtle);">
                        <i class="bi bi-info-circle"></i> Mặc định đã chọn cả 5 môn học kỳ này. Bạn có thể chọn nhiều môn học cùng lúc.
                    </span>
                </div>

                <button id="btn-register" type="submit" class="btn-submit" style="margin-top:12px">
                    <span class="spinner"></span>
                    <span>Đăng ký</span>
                </button>
            </form>

            <div class="auth-divider">
                <span>hoặc</span>
            </div>

            <div class="auth-switch">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </div>
        </div>
    </div>
</div>

<!-- Global App Controller JS -->
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
