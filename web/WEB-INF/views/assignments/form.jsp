<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<c:if test="${sessionScope.currentUser.isStudent()}">
    <c:redirect url="/assignments"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="isEdit" value="${not empty requestScope.assignment}"/>
    <title>${isEdit ? 'Sửa bài tập' : 'Tạo bài tập mới'} — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="${isEdit ? 'Chỉnh sửa thông tin và deadline bài tập' : 'Tạo bài tập mới cho môn học'}">
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
                    <h1>${isEdit ? 'Chỉnh sửa Bài tập' : 'Tạo Bài tập mới'}</h1>
                    <p>${isEdit ? 'Cập nhật thông tin, mô tả hoặc gia hạn deadline bài tập.' : 'Điền thông tin để tạo bài tập / milestone mới cho sinh viên.'}</p>
                </div>
                <div class="page-header-actions">
                    <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
            </div>

            <!-- Error -->
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <c:out value="${requestScope.error}"/>
                </div>
            </c:if>

            <!-- Form Card -->
            <div class="data-card" style="max-width: 800px; margin: 0 auto;">
                <div class="data-card-header">
                    <h2 class="data-card-title">
                        <i class="bi bi-${isEdit ? 'pencil-square' : 'plus-circle-fill'}"></i>
                        ${isEdit ? 'Cập nhật thông tin bài tập' : 'Thông tin bài tập mới'}
                    </h2>
                </div>

                <form method="POST"
                      action="${pageContext.request.contextPath}/assignments?action=${isEdit ? 'edit' : 'add'}"
                      class="form-layout" id="assignmentForm">

                    <!-- hidden field khi edit -->
                    <c:if test="${isEdit}">
                        <input type="hidden" name="assignment_id" value="${requestScope.assignment.assignment_id}">
                        <fmt:formatDate value="${requestScope.assignment.deadline}" pattern="yyyy-MM-dd'T'HH:mm" var="deadlineFormatted"/>
                    </c:if>

                    <!-- Tiêu đề bài tập -->
                    <div class="form-group">
                        <label for="title" class="form-label">
                            <i class="bi bi-card-heading"></i> Tiêu đề bài tập <span class="text-danger">*</span>
                        </label>
                        <input type="text" id="title" name="title" class="form-control" required
                               placeholder="Ví dụ: Milestone 3 — Xây dựng giao diện JSP..."
                               value="<c:out value='${isEdit ? requestScope.assignment.title : ""}'/>"
                               maxlength="200">
                    </div>

                    <!-- Môn học -->
                    <div class="form-group">
                        <label for="course_id" class="form-label">
                            <i class="bi bi-book-fill"></i> Môn học <span class="text-danger">*</span>
                        </label>
                        <select id="course_id" name="course_id" class="form-control" required>
                            <option value="">-- Chọn môn học --</option>
                            <c:forEach items="${requestScope.courses}" var="course">
                                <option value="${course.course_id}"
                                    ${isEdit && requestScope.assignment.course_id == course.course_id ? 'selected' : ''}>
                                    ${course.course_code} — ${course.course_name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Mô tả -->
                    <div class="form-group">
                        <label for="description" class="form-label">
                            <i class="bi bi-text-paragraph"></i> Mô tả / Yêu cầu bài tập
                        </label>
                        <textarea id="description" name="description" class="form-control"
                                  rows="5" placeholder="Mô tả chi tiết yêu cầu bài tập, các tiêu chí chấm điểm..."><c:out value='${isEdit ? requestScope.assignment.description : ""}'/></textarea>
                    </div>

                    <!-- Deadline -->
                    <div class="form-group">
                        <label for="deadline" class="form-label">
                            <i class="bi bi-calendar-event-fill"></i> Hạn nộp (Deadline) <span class="text-danger">*</span>
                        </label>
                        <input type="datetime-local" id="deadline" name="deadline" class="form-control" required
                               value="${not empty deadlineFormatted ? deadlineFormatted : ''}">
                        <small class="form-hint">
                            <i class="bi bi-info-circle"></i>
                            Sinh viên không thể nộp bài sau mốc thời gian này.
                            <c:if test="${isEdit}">
                                Deadline hiện tại:
                                <strong><fmt:formatDate value="${requestScope.assignment.deadline}" pattern="dd/MM/yyyy HH:mm"/></strong>
                            </c:if>
                        </small>
                    </div>

                    <!-- Nút submit -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary" id="btnSubmitForm">
                            <i class="bi bi-${isEdit ? 'check-circle-fill' : 'plus-circle-fill'}"></i>
                            ${isEdit ? 'Lưu thay đổi' : 'Tạo bài tập'}
                        </button>
                    </div>
                </form>
            </div>

            <!-- Hướng dẫn thay đổi deadline -->
            <c:if test="${isEdit}">
                <div class="data-card" style="max-width: 800px; margin: 1.5rem auto 0;">
                    <div class="data-card-header">
                        <h2 class="data-card-title">
                            <i class="bi bi-lightbulb-fill" style="color:#fbbf24"></i>
                            Lưu ý khi chỉnh sửa deadline
                        </h2>
                    </div>
                    <div style="padding: 1.25rem 1.5rem; color: var(--text-subtle); font-size: 0.9rem; line-height: 1.7;">
                        <ul style="margin: 0; padding-left: 1.5rem;">
                            <li>Gia hạn deadline sẽ cho phép sinh viên nộp bài thêm sau thời gian cũ.</li>
                            <li>Rút ngắn deadline có thể ảnh hưởng sinh viên chưa kịp nộp bài.</li>
                            <li>Deadline mới sẽ được áp dụng ngay lập tức sau khi lưu.</li>
                            <li>Các bài đã nộp trước đó <strong>không bị ảnh hưởng</strong> khi đổi deadline.</li>
                        </ul>
                    </div>
                </div>
            </c:if>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
// Nếu đang sửa: tự điền deadline vào input datetime-local
<c:if test="${isEdit}">
(function() {
    const dl = document.getElementById('deadline');
    if (dl && '${requestScope.assignment.deadline}' !== '') {
        // Convert SQL Timestamp "yyyy-MM-dd HH:mm:ss.SSS" → "yyyy-MM-ddTHH:mm"
        const raw = '${requestScope.assignment.deadline}';
        const d = new Date(raw);
        if (!isNaN(d)) {
            const pad = n => String(n).padStart(2, '0');
            dl.value = d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate())
                     + 'T' + pad(d.getHours()) + ':' + pad(d.getMinutes());
        }
    }
})();
</c:if>

// Đặt min datetime bằng giờ hiện tại
document.getElementById('deadline').min = new Date().toISOString().slice(0,16);
</script>
</body>
</html>
