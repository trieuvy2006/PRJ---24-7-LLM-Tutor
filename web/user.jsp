<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Kiểm tra bảo vệ quyền truy cập: Chỉ Admin mới được vào trang này --%>
<c:if test="${empty sessionScope.currentUser or (!sessionScope.currentUser.isAdmin() and sessionScope.currentUser.role_id != 1)}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Người dùng — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Danh sách tài khoản quản trị, giảng viên và sinh viên trong hệ thống AITA.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
</head>
<body>

<div class="app-container">
    <!-- ── SIDEBAR ĐIỀU HƯỚNG THEO VAI TRÒ ── -->
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <!-- ── KHU VỰC NỘI DUNG CHÍNH & TOPBAR ── -->
    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body">
            <!-- Header tiêu đề trang & Nút thêm người dùng -->
            <div class="page-header-row">
                <div class="page-header-text">
                    <h1>Quản lý Tài khoản & Phân quyền</h1>
                </div>
                <div class="page-header-actions">
                    <c:if test="${sessionScope.role eq 'ADMIN' or sessionScope.currentUser.role_id == 1}">
                        <a href="add.jsp" id="btn-add-user" class="btn btn-primary">
                            <i class="bi bi-person-plus-fill"></i>
                            <span>+ Thêm người dùng mới</span>
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Thông báo Lỗi hoặc Thành công từ Servlet -->
            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-octagon-fill" style="font-size:18px; flex-shrink:0"></i>
                    <div><strong>Thông báo lỗi:</strong> ${error}</div>
                </div>
            </c:if>
            <c:if test="${param.message eq 'profile_updated'}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill" style="font-size:18px; flex-shrink:0"></i>
                    <div>Cập nhật hồ sơ tài khoản thành công!</div>
                </div>
            </c:if>

            <!-- Khung Bảng Dữ Liệu -->
            <div class="table-card">
                <!-- Toolbar tìm kiếm & lọc nhanh theo vai trò -->
                <div class="table-toolbar">
                    <div class="filter-group">
                        <div style="position:relative">
                            <input type="text" id="tableSearchInput" class="filter-input" 
                                   placeholder="Lọc tên, username, email..." 
                                   onkeyup="window.filterUserTable()" />
                        </div>

                        <select id="tableRoleFilter" class="filter-select" onchange="window.filterUserTable()">
                            <option value="">-- Tất cả vai trò --</option>
                            <option value="1">Quản trị viên (ADMIN)</option>
                            <option value="2">Giảng viên (INSTRUCTOR)</option>
                            <option value="3">Sinh viên (STUDENT)</option>
                        </select>
                    </div>

                    <div style="font-size:13px; color:var(--text-muted)">
                        Tổng số: <strong style="color:var(--text-main)">${requestScope.data != null ? requestScope.data.size() : 0}</strong> tài khoản
                    </div>
                </div>

                <!-- Bảng Danh Sách -->
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width:70px">ID</th>
                                <th>Người dùng</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th style="width:140px">Vai trò</th>
                                <th style="width:110px; text-align:center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="userTableBody">
                            <c:forEach items="${requestScope.data}" var="u">
                                <tr class="user-row" 
                                    data-username="${u.username}" 
                                    data-fullname="${u.full_name}" 
                                    data-email="${u.email}" 
                                    data-role-id="${u.role_id}">
                                    <td style="color:var(--text-subtle); font-weight:600">#${u.user_id}</td>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-cell-avatar">
                                                ${u.full_name != null and u.full_name.length() > 0 ? u.full_name.substring(0, 1).toUpperCase() : 'U'}
                                            </div>
                                            <div class="user-cell-info">
                                                <h4>${u.full_name}</h4>
                                                <p>@${u.username}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-muted)">${u.email}</td>
                                    <td style="color:var(--text-muted)">
                                        <c:out value="${not empty u.phone ? u.phone : '—'}" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role_id == 1}">
                                                <span class="badge-role admin">
                                                    <i class="bi bi-shield-lock-fill"></i> ADMIN
                                                </span>
                                            </c:when>
                                            <c:when test="${u.role_id == 2}">
                                                <span class="badge-role instructor">
                                                    <i class="bi bi-mortarboard-fill"></i> INSTRUCTOR
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-role student">
                                                    <i class="bi bi-person-fill"></i> STUDENT
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="table-actions" style="justify-content:center">
                                            <a href="update?user_id=${u.user_id}" class="action-icon-btn" 
                                               aria-label="Chỉnh sửa thông tin" title="Chỉnh sửa">
                                                <i class="bi bi-pencil-fill"></i>
                                            </a>
                                            <button type="button" 
                                                    onclick="window.openDeleteModal('${u.user_id}', '${u.username}')" 
                                                    class="action-icon-btn delete" 
                                                    aria-label="Xóa tài khoản" title="Xóa">
                                                <i class="bi bi-trash3-fill"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Trạng thái trống (Empty State khi tìm kiếm không thấy hoặc data trống) -->
                    <div id="tableEmptyState" class="table-empty-state" 
                         style="${empty requestScope.data ? 'display:block' : 'display:none'}">
                        <div class="empty-icon"><i class="bi bi-folder-x"></i></div>
                        <div class="empty-title">Không tìm thấy tài khoản phù hợp</div>
                        <div class="empty-desc">
                            Không có kết quả nào khớp với từ khóa hoặc bộ lọc vai trò hiện tại. Vui lòng thử lại.
                        </div>
                        <button type="button" onclick="document.getElementById('tableSearchInput').value=''; document.getElementById('tableRoleFilter').value=''; window.filterUserTable();" class="btn btn-secondary btn-sm">
                            <i class="bi bi-arrow-counterclockwise"></i> Xóa bộ lọc
                        </button>
                    </div>
                </div>

                <!-- Phân trang giao diện sạch -->
                <div class="table-pagination">
                    <div>Hiển thị 1 đến ${requestScope.data != null ? requestScope.data.size() : 0} trong số ${requestScope.data != null ? requestScope.data.size() : 0} mục</div>
                    <div class="pagination-pages">
                        <button type="button" class="page-btn" disabled><i class="bi bi-chevron-left"></i></button>
                        <button type="button" class="page-btn active">1</button>
                        <button type="button" class="page-btn" disabled><i class="bi bi-chevron-right"></i></button>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal xác nhận xóa & Script Controller -->
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
