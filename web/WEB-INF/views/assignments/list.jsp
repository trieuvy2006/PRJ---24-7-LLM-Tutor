<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Bài tập & Milestones — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Danh sách bài tập và milestones theo môn học, hạn nộp, trạng thái.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
</head>
<body>

<div class="app-container">
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body">
            <!-- Page Header -->
            <div class="page-header-row">
                <div class="page-header-text">
                    <h1>Bài tập & Milestones</h1>
                    <c:choose>
                        <c:when test="${sessionScope.currentUser.isStudent()}">
                            <p>Danh sách bài tập của các môn học bạn đang theo học.</p>
                        </c:when>
                        <c:otherwise>
                            <p>Quản lý bài tập, deadline và theo dõi tiến độ nộp bài của sinh viên.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="page-header-actions">
                    <c:if test="${not sessionScope.currentUser.isStudent()}">
                        <a href="${pageContext.request.contextPath}/assignments?action=add"
                           class="btn btn-primary" id="btnCreateAssignment">
                            <i class="bi bi-plus-circle-fill"></i>
                            <span>+ Tạo bài tập mới</span>
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.currentUser.isStudent()}">
                        <a href="${pageContext.request.contextPath}/submit?action=history"
                           class="btn btn-secondary" id="btnViewHistory">
                            <i class="bi bi-clock-history"></i>
                            <span>Lịch sử nộp bài</span>
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Flash messages -->
            <c:if test="${not empty param.message}">
                <div class="alert alert-success" id="alertSuccess">
                    <i class="bi bi-check-circle-fill"></i>
                    <c:choose>
                        <c:when test="${param.message eq 'created'}">Tạo bài tập mới thành công!</c:when>
                        <c:when test="${param.message eq 'updated'}">Cập nhật bài tập thành công!</c:when>
                        <c:when test="${param.message eq 'deleted'}">Xóa bài tập thành công!</c:when>
                        <c:otherwise>Thao tác thành công!</c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger" id="alertError">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <c:choose>
                        <c:when test="${param.error eq 'forbidden'}">Bạn không có quyền thực hiện thao tác này.</c:when>
                        <c:when test="${param.error eq 'not_found'}">Không tìm thấy bài tập.</c:when>
                        <c:otherwise><c:out value="${param.error}"/></c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Assignment Table -->
            <div class="data-card">
                <div class="data-card-header">
                    <h2 class="data-card-title">
                        <i class="bi bi-journal-check"></i>
                        Danh sách bài tập
                        <span class="badge-count">${assignments.size()} bài</span>
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${empty assignments}">
                        <div class="empty-state">
                            <i class="bi bi-journal-x" style="font-size:3rem; color:var(--text-subtle)"></i>
                            <p>Chưa có bài tập nào.</p>
                            <c:if test="${not sessionScope.currentUser.isStudent()}">
                                <a href="${pageContext.request.contextPath}/assignments?action=add" class="btn btn-primary">
                                    Tạo bài tập đầu tiên
                                </a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" id="assignmentsTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Bài tập</th>
                                        <th>Môn học</th>
                                        <th>Người tạo</th>
                                        <th>Hạn nộp (Deadline)</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${assignments}" var="a" varStatus="st">
                                        <tr>
                                            <td>${st.index + 1}</td>
                                            <td>
                                                <div class="assignment-title-cell">
                                                    <strong><c:out value="${a.title}"/></strong>
                                                    <c:if test="${not empty a.description}">
                                                        <small class="text-subtle" title="${a.description}">
                                                            <c:out value="${a.description.length() > 60 ? a.description.substring(0,60).concat('…') : a.description}"/>
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge badge-course">
                                                    <c:out value="${a.course_code}"/>
                                                </span>
                                            </td>
                                            <td><c:out value="${a.created_by_name}"/></td>
                                            <td>
                                                <div class="deadline-cell">
                                                    <fmt:formatDate value="${a.deadline}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${a.overdue}">
                                                        <span class="status-badge status-failed">Đã đóng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-pending">Đang mở</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <!-- Sinh viên: Nộp bài -->
                                                    <c:if test="${sessionScope.currentUser.isStudent()}">
                                                        <c:choose>
                                                            <c:when test="${not a.overdue}">
                                                                <a href="${pageContext.request.contextPath}/submit?assignment_id=${a.assignment_id}"
                                                                   class="btn btn-primary btn-sm" title="Nộp bài">
                                                                    <i class="bi bi-upload"></i> Nộp bài
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="btn btn-secondary btn-sm disabled">
                                                                    <i class="bi bi-lock-fill"></i> Đã đóng
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>

                                                    <!-- Instructor / Admin: Sửa + Xem bài nộp + Xóa -->
                                                    <c:if test="${not sessionScope.currentUser.isStudent()}">
                                                        <a href="${pageContext.request.contextPath}/assignments?action=edit&id=${a.assignment_id}"
                                                           class="btn btn-secondary btn-sm" title="Sửa bài tập / Đổi deadline">
                                                            <i class="bi bi-pencil-fill"></i> Sửa
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/assignments?action=submissions&id=${a.assignment_id}"
                                                           class="btn btn-secondary btn-sm" title="Xem bài nộp">
                                                            <i class="bi bi-collection-fill"></i> Bài nộp
                                                        </a>
                                                        <c:if test="${sessionScope.currentUser.isAdmin()}">
                                                            <button type="button" class="btn btn-danger btn-sm"
                                                                    onclick="confirmDelete(${a.assignment_id}, '${a.title}')"
                                                                    title="Xóa bài tập">
                                                                <i class="bi bi-trash-fill"></i>
                                                            </button>
                                                        </c:if>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<!-- Modal xác nhận xóa -->
<div class="modal-overlay" id="deleteModal" style="display:none">
    <div class="modal-dialog">
        <div class="modal-header">
            <h3><i class="bi bi-exclamation-triangle-fill text-warning"></i> Xác nhận xóa</h3>
        </div>
        <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa bài tập <strong id="deleteTargetTitle"></strong>?</p>
            <p class="text-subtle">Hành động này không thể hoàn tác. Nếu đã có sinh viên nộp bài, việc xóa sẽ bị từ chối.</p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
            <a id="deleteConfirmLink" href="#" class="btn btn-danger">
                <i class="bi bi-trash-fill"></i> Xóa ngay
            </a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
function confirmDelete(id, title) {
    document.getElementById('deleteTargetTitle').textContent = '"' + title + '"';
    document.getElementById('deleteConfirmLink').href =
        '${pageContext.request.contextPath}/assignments?action=delete&id=' + id;
    document.getElementById('deleteModal').style.display = 'flex';
}
function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
}
// Tự đóng alert sau 5 giây
setTimeout(() => {
    const s = document.getElementById('alertSuccess');
    const e = document.getElementById('alertError');
    if (s) s.style.display = 'none';
    if (e) e.style.display = 'none';
}, 5000);
</script>
</body>
</html>
