<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ & Quản lý Tài khoản — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Quản lý thông tin cá nhân, cập nhật email, số điện thoại và đổi mật khẩu tài khoản.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
</head>
<body>

<div class="app-container">
    <!-- ── SIDEBAR ĐIỀU HƯỚNG ── -->
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <!-- ── KHU VỰC NỘI DUNG CHÍNH ── -->
    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body">
            <c:set var="u" value="${requestScope.user != null ? requestScope.user : sessionScope.currentUser}"/>

            <!-- Profile Hero Banner -->
            <div class="profile-hero-card">
                <div class="profile-hero-avatar">
                    ${u != null and u.full_name != null and u.full_name.length() > 0 ? u.full_name.substring(0, 1).toUpperCase() : 'U'}
                </div>
                <div class="profile-hero-details">
                    <div style="display:flex; align-items:center; gap:12px; flex-wrap:wrap">
                        <h2>${u.full_name}</h2>
                        <c:choose>
                            <c:when test="${u.role_id == 1}">
                                <span class="badge-role admin"><i class="bi bi-shield-lock-fill"></i> Quản trị viên</span>
                            </c:when>
                            <c:when test="${u.role_id == 2}">
                                <span class="badge-role instructor"><i class="bi bi-mortarboard-fill"></i> Giảng viên</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-role student"><i class="bi bi-person-workspace"></i> Sinh viên</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p class="profile-hero-sub">
                        <span>@${u.username}</span> • 
                        <span>ID: #${u.user_id}</span> • 
                        <c:if test="${not empty u.student_code}">
                            <span>MSSV: <strong>${u.student_code}</strong></span> • 
                        </c:if>
                        <span>Email: ${u.email}</span>
                    </p>
                </div>
            </div>

            <!-- Thông báo Lỗi hoặc Thành công -->
            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-octagon-fill" style="font-size:18px; flex-shrink:0"></i>
                    <div><strong>Lỗi thao tác:</strong> ${error}</div>
                </div>
            </c:if>
            <c:if test="${param.message eq 'profile_updated'}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill" style="font-size:18px; flex-shrink:0"></i>
                    <div>Cập nhật thông tin liên hệ thành công!</div>
                </div>
            </c:if>
            <c:if test="${param.message eq 'password_changed'}">
                <div class="alert-box alert-success">
                    <i class="bi bi-shield-check" style="font-size:18px; flex-shrink:0"></i>
                    <div>Đổi mật khẩu tài khoản thành công! Hãy ghi nhớ mật khẩu mới của bạn.</div>
                </div>
            </c:if>

            <!-- Khuyến nghị quy chuẩn quản lý hồ sơ theo chuẩn các trường ĐH / LMS -->
            <div class="guideline-card">
                <div class="guideline-icon">
                    <i class="bi bi-info-circle-fill"></i>
                </div>
                <div class="guideline-text">
                    <strong>Quy chuẩn quản lý hồ sơ tài khoản Nhà trường:</strong>
                    <p>
                        Các thông tin định danh như <em>Mã số (User ID/MSSV), Tên đăng nhập, Vai trò và Họ tên chính thức</em> được đồng bộ cố định theo dữ liệu tuyển sinh/đào tạo để đảm bảo tính xác thực khi thi cử và điểm danh. Bạn có toàn quyền cập nhật <strong>Email liên lạc, Số điện thoại và Đổi mật khẩu</strong> trực tiếp bên dưới.
                    </p>
                </div>
            </div>

            <div class="profile-grid-2col">
                <!-- CỘT 1: THÔNG TIN ĐỊNH DANH (CỐ ĐỊNH - READ-ONLY) -->
                <div class="form-container-card">
                    <div class="card-sec-header">
                        <i class="bi bi-lock-fill" style="color:var(--text-subtle)"></i>
                        <h3>Thông tin định danh đào tạo (Cố định)</h3>
                    </div>
                    <p style="font-size:12.5px; color:var(--text-muted); margin-bottom:18px">
                        Thông tin được bảo hộ bởi hệ thống đào tạo, chỉ Quản trị viên cấp cao mới có quyền điều chỉnh.
                    </p>

                    <div class="form-group-app">
                        <label>Mã định danh hệ thống (User ID)</label>
                        <div class="input-wrapper readonly-wrapper">
                            <input type="text" value="#${u.user_id}" readonly />
                            <i class="bi bi-lock input-end-icon"></i>
                        </div>
                    </div>

                    <div class="form-group-app">
                        <label>Tên đăng nhập (Username)</label>
                        <div class="input-wrapper readonly-wrapper">
                            <input type="text" value="${u.username}" readonly />
                            <i class="bi bi-lock input-end-icon"></i>
                        </div>
                    </div>

                    <div class="form-group-app">
                        <label>Họ và tên chính thức</label>
                        <div class="input-wrapper readonly-wrapper">
                            <input type="text" value="${u.full_name}" readonly />
                            <i class="bi bi-shield-check input-end-icon" style="color:var(--success)"></i>
                        </div>
                        <span class="field-hint">Đồng bộ chính xác theo hồ sơ CCCD / Học bạ.</span>
                    </div>

                    <div class="form-group-app">
                        <label>Vai trò hệ thống</label>
                        <div class="input-wrapper readonly-wrapper">
                            <input type="text" value="${u.getRole_name()}" readonly />
                            <i class="bi bi-person-badge input-end-icon"></i>
                        </div>
                    </div>

                    <c:if test="${not empty u.student_code}">
                        <div class="form-group-app">
                            <label>Mã sinh viên (Student Code)</label>
                            <div class="input-wrapper readonly-wrapper">
                                <input type="text" value="${u.student_code}" readonly />
                                <i class="bi bi-mortarboard input-end-icon"></i>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- CỘT 2: THÔNG TIN LIÊN LẠC (CHO PHÉP TỰ CHỈNH SỬA) & ĐỔI MẬT KHẨU -->
                <div style="display:flex; flex-direction:column; gap:24px">
                    <!-- Khung Sửa Thông Tin Liên Lạc -->
                    <div class="form-container-card">
                        <div class="card-sec-header">
                            <i class="bi bi-pencil-square" style="color:var(--primary)"></i>
                            <h3>Thông tin liên lạc (Tự cập nhật)</h3>
                        </div>

                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="updateProfile" />

                            <div class="form-group-app">
                                <label for="prof-email">Địa chỉ Email liên hệ (*)</label>
                                <div class="input-wrapper">
                                    <input id="prof-email" type="email" name="email" value="${u.email}" required />
                                    <i class="bi bi-envelope input-end-icon"></i>
                                </div>
                                <span class="field-hint">Dùng để nhận thông báo bài tập và trao đổi với Giảng viên.</span>
                            </div>

                            <div class="form-group-app">
                                <label for="prof-phone">Số điện thoại liên lạc</label>
                                <div class="input-wrapper">
                                    <input id="prof-phone" type="tel" name="phone" value="${u.phone}" placeholder="Ví dụ: 0912345678" />
                                    <i class="bi bi-telephone input-end-icon"></i>
                                </div>
                                <span class="field-hint">Số điện thoại di động dùng để xác thực và liên lạc.</span>
                            </div>

                            <div class="form-footer-actions" style="margin-top:16px">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save-fill"></i>
                                    <span>Lưu thay đổi hồ sơ</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Khung Đổi Mật Khẩu -->
                    <div class="form-container-card">
                        <div class="card-sec-header">
                            <i class="bi bi-shield-lock" style="color:var(--accent-purple, #a855f7)"></i>
                            <h3>Bảo mật & Đổi mật khẩu</h3>
                        </div>

                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="changePassword" />

                            <div class="form-group-app">
                                <label for="pass-current">Mật khẩu hiện tại (*)</label>
                                <div class="input-wrapper">
                                    <input id="pass-current" type="password" name="old_password" required placeholder="Nhập mật khẩu đang dùng" />
                                    <button type="button" class="btn-toggle-pass" aria-label="Hiện mật khẩu"><i class="bi bi-eye-fill"></i></button>
                                </div>
                            </div>

                            <div class="form-group-app">
                                <label for="pass-new">Mật khẩu mới (*)</label>
                                <div class="input-wrapper">
                                    <input id="pass-new" type="password" name="new_password" required placeholder="Tối thiểu 6 ký tự" />
                                    <button type="button" class="btn-toggle-pass" aria-label="Hiện mật khẩu"><i class="bi bi-eye-fill"></i></button>
                                </div>
                            </div>

                            <div class="form-group-app">
                                <label for="pass-confirm">Xác nhận mật khẩu mới (*)</label>
                                <div class="input-wrapper">
                                    <input id="pass-confirm" type="password" name="confirm_password" required placeholder="Nhập lại mật khẩu mới" />
                                    <button type="button" class="btn-toggle-pass" aria-label="Hiện mật khẩu"><i class="bi bi-eye-fill"></i></button>
                                </div>
                            </div>

                            <div class="form-footer-actions" style="margin-top:16px">
                                <button type="submit" class="btn btn-secondary">
                                    <i class="bi bi-key-fill"></i>
                                    <span>Cập nhật mật khẩu</span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal & Scripts -->
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
