<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chỉnh sửa Người dùng — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Chỉnh sửa thông tin tài khoản người dùng trong hệ thống AITA.">
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
            <c:set var="u" value="${requestScope.user}"/>

            <!-- Header Tiêu Đề & Avatar người dùng -->
            <div class="page-header-row">
                <div style="display:flex; align-items:center; gap:16px">
                    <div class="user-avatar-circle" style="width:52px; height:52px; font-size:20px">
                        ${u != null and u.full_name != null and u.full_name.length() > 0 ? u.full_name.substring(0, 1).toUpperCase() : 'U'}
                    </div>
                    <div class="page-header-text">
                        <h1>Chỉnh sửa: <c:out value="${u.username}" /></h1>
                        <p>Cập nhật vai trò, email và thông tin cá nhân của người dùng #${u.user_id}.</p>
                    </div>
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
                <c:if test="${not empty error}">
                    <div class="alert-box alert-error">
                        <i class="bi bi-exclamation-octagon-fill" style="font-size:18px; flex-shrink:0"></i>
                        <div><strong>Lỗi cập nhật:</strong> ${error}</div>
                    </div>
                </c:if>

                <!-- FORM CẬP NHẬT (Giữ nguyên 100% action='update', method='post', name của các input) -->
                <form id="update-user-form" action="update" method="post">
                    <div class="form-grid-2col">
                        <div class="form-group-app">
                            <label for="upd-id">User ID (Mã định danh)</label>
                            <input id="upd-id" type="number" name="user_id" value="${u.user_id}" readonly />
                            <span class="field-hint">Mã ID hệ thống tự sinh, không thể thay đổi.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="upd-role">Vai trò (Role ID)</label>
                            <select id="upd-role" name="role_id">
                                <option value="1" ${u.role_id == 1 ? 'selected' : ''}>1 — Quản trị viên (ADMIN)</option>
                                <option value="2" ${u.role_id == 2 ? 'selected' : ''}>2 — Giảng viên (INSTRUCTOR)</option>
                                <option value="3" ${u.role_id == 3 ? 'selected' : ''}>3 — Sinh viên (STUDENT)</option>
                            </select>
                            <span class="field-hint">Thay đổi vai trò sẽ điều chỉnh quyền hạn truy cập.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="upd-username">Tên đăng nhập (*)</label>
                            <input id="upd-username" type="text" name="username" value="${u.username}" required />
                            <span class="field-hint">Tên đăng nhập duy nhất của tài khoản.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="upd-fullname">Họ và tên (*)</label>
                            <input id="upd-fullname" type="text" name="full_name" value="${u.full_name}" required />
                            <span class="field-hint">Họ tên hiển thị công khai trên hệ thống.</span>
                        </div>

                        <div class="form-group-app">
                            <label for="upd-email">Địa chỉ Email (*)</label>
                            <input id="upd-email" type="email" name="email" value="${u.email}" required />
                        </div>

                        <div class="form-group-app">
                            <label for="upd-phone">Số điện thoại liên hệ</label>
                            <input id="upd-phone" type="text" name="phone" value="${u.phone}" />
                        </div>
                    </div>

                    <div class="form-footer-actions">
                        <button id="btn-update-user" type="submit" class="btn btn-primary">
                            <span class="spinner"></span>
                            <i class="bi bi-check2-circle"></i>
                            <span>Cập nhật thông tin</span>
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