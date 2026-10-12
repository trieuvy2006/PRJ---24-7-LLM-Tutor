<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Kiểm tra bảo vệ quyền truy cập: Chỉ Admin mới được thêm người dùng --%>
<c:if test="${empty sessionScope.currentUser or (!sessionScope.currentUser.isAdmin() and sessionScope.currentUser.role_id != 1)}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thêm Người dùng Mới — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Thêm tài khoản người dùng mới vào hệ thống AITA.">
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
            <!-- Header Tiêu Đề -->
            <div class="page-header-row">
                <div class="page-header-text">
                    <h1>Thêm Người dùng Mới</h1>
                    <p>Khởi tạo tài khoản Quản trị viên, Giảng viên hoặc Sinh viên với đầy đủ thông tin.</p>
                </div>
                <div class="page-header-actions">
                    <a href="user" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
            </div>

            <!-- Khung Form Container -->
            <div class="form-container-card">
                <!-- Thông báo lỗi nếu có -->
                <c:if test="${not empty requestScope.error}">
                    <div class="alert-box alert-error">
                        <i class="bi bi-exclamation-octagon-fill" style="font-size:18px; flex-shrink:0"></i>
                        <div><strong>Lỗi thêm mới:</strong> ${requestScope.error}</div>
                    </div>
                </c:if>

                <!-- FORM THÊM NGƯỜI DÙNG (Giữ nguyên 100% action='add', method='get', name của các input) -->
                <form id="add-user-form" action="add" method="get">
                    <div class="form-grid-2col">
                        <div class="form-group-app col-full">
                            <label for="add-role">Vai trò trong hệ thống (*)</label>
                            <select id="add-role" name="role_id" required>
                                <option value="">-- Chọn vai trò người dùng --</option>
                                <option value="1">1 — Quản trị viên (ADMIN)</option>
                                <option value="2">2 — Giảng viên (INSTRUCTOR)</option>
                                <option value="3" selected>3 — Sinh viên (STUDENT)</option>
                            </select>
                            <span class="field-hint">Chọn vai trò thích hợp để hệ thống cấp quyền tương ứng.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="add-username">Tên đăng nhập (*)</label>
                            <input id="add-username" type="text" name="username"
                                   placeholder="VD: vynt, dungkt, admin..." required autofocus />
                            <span class="field-hint">Viết liền, không dấu, dùng để đăng nhập.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="add-password">Mật khẩu (*)</label>
                            <input id="add-password" type="text" name="password_hash"
                                   placeholder="Nhập mật khẩu khởi tạo..." required />
                            <span class="field-hint">Tối thiểu 6 ký tự bảo mật.</span>
                        </div>

                        <div class="form-group-app col-full">
                            <label for="add-fullname">Họ và tên (*)</label>
                            <input id="add-fullname" type="text" name="full_name"
                                   placeholder="VD: Lương Triệu Vỹ, Nguyễn Văn Dũng..." required />
                            <span class="field-hint">Họ tên đầy đủ có dấu để hiển thị trên giao diện.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="add-email">Địa chỉ Email (*)</label>
                            <input id="add-email" type="email" name="email"
                                   placeholder="example@fpt.edu.vn..." required />
                        </div>

                        <div class="form-group-app">
                            <label for="add-phone">Số điện thoại liên hệ</label>
                            <input id="add-phone" type="text" name="phone"
                                   placeholder="0987654321..." />
                        </div>
                    </div>

                    <div class="form-footer-actions">
                        <button id="btn-save-user" type="submit" class="btn btn-primary">
                            <span class="spinner"></span>
                            <i class="bi bi-floppy-fill"></i>
                            <span>Lưu tài khoản</span>
                        </button>
                        <a href="user" class="btn btn-secondary">
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<!-- Modal & Scripts -->
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
