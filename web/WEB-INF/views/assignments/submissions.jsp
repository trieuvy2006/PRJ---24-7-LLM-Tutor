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
    <title>Bài nộp — ${requestScope.assignment.title} — AITA</title>
    <meta name="description" content="Xem danh sách tất cả bài nộp của sinh viên cho bài tập này.">
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
                    <h1>Danh sách Bài Nộp</h1>
                    <p>Bài tập: <strong><c:out value="${requestScope.assignment.title}"/></strong>
                        — Môn: <span class="badge badge-course"><c:out value="${requestScope.assignment.course_code}"/></span>
                    </p>
                </div>
                <div class="page-header-actions">
                    <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/assignments?action=edit&id=${requestScope.assignment.assignment_id}"
                       class="btn btn-primary">
                        <i class="bi bi-pencil-fill"></i> Sửa deadline
                    </a>
                </div>
            </div>

            <!-- Thông tin bài tập tóm tắt -->
            <div class="metrics-grid" style="margin-bottom: 1.5rem;">
                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(99,102,241,0.15); color:#818cf8">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Tổng bài nộp</span>
                        <strong class="metric-val">${submissions.size()}</strong>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(16,185,129,0.15); color:#34d399">
                        <i class="bi bi-check2-all"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Đã chấm điểm</span>
                        <strong class="metric-val">
                            <c:set var="gradedCount" value="0"/>
                            <c:forEach items="${submissions}" var="s">
                                <c:if test="${s.status eq 'GRADED'}">
                                    <c:set var="gradedCount" value="${gradedCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${gradedCount}
                        </strong>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(245,158,11,0.15); color:#fbbf24">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Chờ chấm</span>
                        <strong class="metric-val">
                            <c:set var="pendingCount" value="0"/>
                            <c:forEach items="${submissions}" var="s">
                                <c:if test="${s.status eq 'PENDING'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </strong>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(236,72,153,0.15); color:#f472b6">
                        <i class="bi bi-calendar-event-fill"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Deadline</span>
                        <strong class="metric-val" style="font-size:0.85rem;">
                            <fmt:formatDate value="${requestScope.assignment.deadline}" pattern="dd/MM/yyyy HH:mm"/>
                        </strong>
                    </div>
                </div>
            </div>

            <!-- Danh sách bài nộp -->
            <div class="data-card">
                <div class="data-card-header">
                    <h2 class="data-card-title">
                        <i class="bi bi-collection-fill"></i>
                        Bài nộp của sinh viên
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${empty submissions}">
                        <div class="empty-state">
                            <i class="bi bi-inbox" style="font-size:3rem; color:var(--text-subtle)"></i>
                            <p>Chưa có sinh viên nào nộp bài cho bài tập này.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" id="submissionsTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Sinh viên</th>
                                        <th>MSSV</th>
                                        <th>Lần nộp</th>
                                        <th>Thời gian nộp</th>
                                        <th>SHA-256 (tóm tắt)</th>
                                        <th>Trạng thái</th>
                                        <th>Điểm</th>
                                        <th>Phản hồi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${submissions}" var="sub" varStatus="st">
                                        <tr>
                                            <td>${st.index + 1}</td>
                                            <td>
                                                <strong><c:out value="${sub.student_name}"/></strong>
                                            </td>
                                            <td>
                                                <span class="text-monospace">
                                                    <c:out value="${sub.student_code}"/>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="attempt-badge">Lần ${sub.attempt_number}</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${sub.submitted_at}" pattern="HH:mm — dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <span class="text-monospace hash-preview"
                                                      title="${sub.sha256_hash}">
                                                    ${sub.sha256_hash.substring(0, 12)}…
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sub.status eq 'GRADED'}">
                                                        <span class="status-badge status-graded">Đã chấm</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'PENDING'}">
                                                        <span class="status-badge status-pending">Chờ chấm</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'PROCESSING'}">
                                                        <span class="status-badge status-processing">Xử lý</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'FAILED'}">
                                                        <span class="status-badge status-failed">Lỗi</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not empty sub.score}">
                                                        <strong class="score-value">${sub.score}</strong>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty sub.feedback}">
                                                        <button type="button" class="btn btn-secondary btn-sm"
                                                                onclick="showFeedback(this.dataset.fb)"
                                                                data-fb="<c:out value='${sub.feedback}'/>">
                                                            <i class="bi bi-chat-left-text-fill"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
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

<!-- Modal phản hồi -->
<div class="modal-overlay" id="feedbackModal" style="display:none">
    <div class="modal-dialog">
        <div class="modal-header">
            <h3><i class="bi bi-chat-left-text-fill"></i> Phản hồi chấm điểm</h3>
            <button type="button" class="modal-close-btn" onclick="document.getElementById('feedbackModal').style.display='none'">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="modal-body">
            <p id="feedbackText" style="white-space:pre-line; line-height:1.8;"></p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary" onclick="document.getElementById('feedbackModal').style.display='none'">Đóng</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
function showFeedback(text) {
    document.getElementById('feedbackText').textContent = text;
    document.getElementById('feedbackModal').style.display = 'flex';
}
</script>
</body>
</html>
