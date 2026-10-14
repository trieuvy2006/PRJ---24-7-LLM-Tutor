<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<c:if test="${not sessionScope.currentUser.isStudent()}">
    <c:redirect url="/assignments"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Nộp bài — ${requestScope.assignment.title} — AITA</title>
    <meta name="description" content="Trang nộp bài tập: upload file ZIP, kiểm tra deadline, xem trạng thái bài nộp.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
</head>
<body>

<div class="app-container">
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body">
            <div class="page-header-row">
                <div class="page-header-text">
                    <h1>Nộp Bài Tập</h1>
                    <p>Upload file ZIP bài làm của bạn. Hệ thống sẽ tính mã SHA-256 để xác nhận tính toàn vẹn.</p>
                </div>
                <div class="page-header-actions">
                    <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/submit?action=history" class="btn btn-secondary">
                        <i class="bi bi-clock-history"></i> Lịch sử nộp
                    </a>
                </div>
            </div>

            <!-- Error / Success -->
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <c:out value="${requestScope.error}"/>
                </div>
            </c:if>

            <!-- Thông tin bài tập -->
            <div class="data-card">
                <div class="data-card-header">
                    <h2 class="data-card-title">
                        <i class="bi bi-journal-text"></i>
                        Thông tin bài tập
                    </h2>
                    <c:choose>
                        <c:when test="${requestScope.assignment.overdue}">
                            <span class="status-badge status-failed">Đã đóng</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-pending">Đang mở</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div style="padding: 1.25rem 1.5rem;">
                    <div class="form-group-inline">
                        <span class="badge badge-course">
                            <c:out value="${requestScope.assignment.course_code}"/>
                        </span>
                        <h3 style="margin: 0; font-size: 1.1rem;">
                            <c:out value="${requestScope.assignment.title}"/>
                        </h3>
                    </div>
                    <c:if test="${not empty requestScope.assignment.description}">
                        <p style="margin-top: 0.75rem; color: var(--text-subtle); white-space: pre-line;">
                            <c:out value="${requestScope.assignment.description}"/>
                        </p>
                    </c:if>

                    <div class="deadline-info-block ${requestScope.assignment.overdue ? 'deadline-overdue' : 'deadline-open'}">
                        <i class="bi bi-${requestScope.assignment.overdue ? 'lock-fill' : 'clock-fill'}"></i>
                        <span>
                            <strong>Hạn nộp:</strong>
                            <fmt:formatDate value="${requestScope.assignment.deadline}" pattern="HH:mm — EEEE, dd/MM/yyyy" timeZone="Asia/Ho_Chi_Minh"/>
                        </span>
                        <c:if test="${requestScope.assignment.overdue}">
                            <span class="text-danger">&nbsp;(Đã hết hạn)</span>
                        </c:if>
                    </div>

                    <!-- Thông tin bài nộp gần nhất -->
                    <c:if test="${not empty requestScope.latestSubmission}">
                        <div class="last-submission-info">
                            <i class="bi bi-archive-fill"></i>
                            <span>Lần nộp gần nhất (lần ${requestScope.latestSubmission.attempt_number}):
                                <strong>${requestScope.latestSubmission.getStatusLabel()}</strong>
                                — <fmt:formatDate value="${requestScope.latestSubmission.submitted_at}" pattern="HH:mm dd/MM/yyyy"/>
                            </span>
                            <c:if test="${not empty requestScope.latestSubmission.score}">
                                &nbsp;|&nbsp;Điểm: <strong>${requestScope.latestSubmission.score}/10</strong>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Form nộp bài -->
            <c:if test="${not requestScope.assignment.overdue}">
                <div class="data-card" style="margin-top: 1.5rem;">
                    <div class="data-card-header">
                        <h2 class="data-card-title">
                            <i class="bi bi-upload"></i> Upload File Bài Làm
                        </h2>
                    </div>

                    <form method="POST"
                          action="${pageContext.request.contextPath}/submit"
                          enctype="multipart/form-data"
                          id="submitForm"
                          style="padding: 1.25rem 1.5rem;">

                        <input type="hidden" name="assignment_id" value="${requestScope.assignment.assignment_id}">

                        <!-- File Drop Zone -->
                        <div class="file-drop-zone" id="dropZone" onclick="document.getElementById('submission_file').click()">
                            <div class="drop-zone-content" id="dropZoneContent">
                                <i class="bi bi-file-earmark-zip-fill" style="font-size: 3rem; color: var(--primary)"></i>
                                <p style="font-size: 1.1rem; font-weight: 600; margin: 0.5rem 0;">
                                    Kéo thả file hoặc <span class="link-text">nhấp để chọn</span>
                                </p>
                                <p style="color: var(--text-subtle); font-size: 0.85rem; margin: 0;">
                                    Chỉ chấp nhận file <strong>.zip</strong> — tối đa 50 MB
                                </p>
                            </div>
                            <div id="fileSelectedInfo" style="display:none;">
                                <i class="bi bi-check-circle-fill" style="font-size:2rem; color:#10b981"></i>
                                <p id="selectedFileName" style="font-size:1rem; font-weight:600; margin:0.5rem 0;"></p>
                                <p id="selectedFileSize" style="color: var(--text-subtle); font-size:0.85rem; margin:0;"></p>
                                <button type="button" class="btn btn-secondary btn-sm" style="margin-top:0.5rem;"
                                        onclick="resetFile(event)">Chọn lại file</button>
                            </div>
                        </div>

                        <input type="file" id="submission_file" name="submission_file"
                               accept=".zip" style="display:none"
                               onchange="handleFileSelect(this)">

                        <div class="form-hint" style="margin-top: 1rem;">
                            <i class="bi bi-shield-check" style="color:#10b981"></i>
                            Hệ thống sẽ tính mã <strong>SHA-256</strong> của file để kiểm tra tính toàn vẹn và phát hiện bài trùng lặp.
                        </div>

                        <div class="form-actions" style="margin-top: 1.5rem;">
                            <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-primary" id="btnSubmit" disabled>
                                <i class="bi bi-cloud-arrow-up-fill"></i>
                                <span id="btnSubmitText">Chọn file trước</span>
                            </button>
                        </div>
                    </form>
                </div>
            </c:if>

            <!-- Thông báo đã đóng -->
            <c:if test="${requestScope.assignment.overdue}">
                <div class="data-card" style="margin-top:1.5rem; text-align:center; padding: 2rem;">
                    <i class="bi bi-lock-fill" style="font-size:3rem; color:var(--text-subtle)"></i>
                    <p style="font-size:1.1rem; margin-top:1rem;">Bài tập này đã quá hạn nộp.</p>
                    <a href="${pageContext.request.contextPath}/submit?action=history" class="btn btn-secondary">
                        Xem lịch sử bài nộp của tôi
                    </a>
                </div>
            </c:if>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
const dropZone = document.getElementById('dropZone');
const fileInput = document.getElementById('submission_file');
const btnSubmit = document.getElementById('btnSubmit');

// Drag & Drop
dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.classList.add('drag-over'); });
dropZone.addEventListener('dragleave', () => dropZone.classList.remove('drag-over'));
dropZone.addEventListener('drop', e => {
    e.preventDefault();
    dropZone.classList.remove('drag-over');
    const files = e.dataTransfer.files;
    if (files.length > 0) {
        const dt = new DataTransfer();
        dt.items.add(files[0]);
        fileInput.files = dt.files;
        showFile(files[0]);
    }
});

function handleFileSelect(input) {
    if (input.files && input.files[0]) {
        showFile(input.files[0]);
    }
}

function showFile(file) {
    if (!file.name.toLowerCase().endsWith('.zip')) {
        alert('Chỉ chấp nhận file .zip!');
        return;
    }
    document.getElementById('dropZoneContent').style.display = 'none';
    document.getElementById('fileSelectedInfo').style.display = 'block';
    document.getElementById('selectedFileName').textContent = file.name;
    const mb = (file.size / 1024 / 1024).toFixed(2);
    document.getElementById('selectedFileSize').textContent = 'Kích thước: ' + mb + ' MB';
    btnSubmit.disabled = false;
    document.getElementById('btnSubmitText').textContent = 'Nộp bài ngay';
}

function resetFile(e) {
    e.stopPropagation();
    fileInput.value = '';
    document.getElementById('dropZoneContent').style.display = 'block';
    document.getElementById('fileSelectedInfo').style.display = 'none';
    btnSubmit.disabled = true;
    document.getElementById('btnSubmitText').textContent = 'Chọn file trước';
}

// Loading state khi submit
document.getElementById('submitForm').addEventListener('submit', function() {
    btnSubmit.disabled = true;
    document.getElementById('btnSubmitText').textContent = 'Đang nộp bài...';
    btnSubmit.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang nộp bài...';
});
</script>
</body>
</html>
