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
    <title>Lịch sử nộp bài — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Xem lại tất cả bài nộp, điểm số và phản hồi từ hệ thống chấm điểm.">
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
                    <h1>Lịch sử Nộp Bài & Kết Quả</h1>
                </div>
                <div class="page-header-actions">
                    <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Danh sách bài tập
                    </a>
                </div>
            </div>

            <!-- Flash message -->
            <c:if test="${param.message eq 'submitted'}">
                <div class="alert alert-success" id="alertSuccess">
                    <i class="bi bi-check-circle-fill"></i>
                    Nộp bài thành công! Hệ thống AI đang xử lý bài làm của bạn.
                </div>
            </c:if>

            <div class="data-card">
                <div class="data-card-header">
                    <h2 class="data-card-title">
                        <i class="bi bi-clock-history"></i>
                        Lịch sử bài nộp của bạn
                        <span class="badge-count">${submissions.size()} lần</span>
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${empty submissions}">
                        <div class="empty-state">
                            <i class="bi bi-inbox" style="font-size:3rem; color:var(--text-subtle)"></i>
                            <p>Bạn chưa nộp bài tập nào.</p>
                            <a href="${pageContext.request.contextPath}/assignments" class="btn btn-primary">
                                Xem danh sách bài tập
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" id="historyTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Bài tập</th>
                                        <th>Môn học</th>
                                        <th>Lần nộp</th>
                                        <th>Thời gian nộp</th>
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
                                                <strong><c:out value="${sub.assignment_title}"/></strong>
                                            </td>
                                            <td>
                                                <span class="badge badge-course">
                                                    <c:out value="${sub.course_code}"/>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="attempt-badge">Lần ${sub.attempt_number}</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${sub.submitted_at}" pattern="HH:mm — dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sub.status eq 'GRADED'}">
                                                        <span class="status-badge status-graded">Đã chấm điểm</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'PENDING'}">
                                                        <span class="status-badge status-pending">Chờ chấm</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'PROCESSING'}">
                                                        <span class="status-badge status-processing">Đang xử lý</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'FAILED'}">
                                                        <span class="status-badge status-failed">Lỗi nộp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge"><c:out value="${sub.status}"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not empty sub.score}">
                                                        <strong class="score-value">${sub.score}/10</strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-subtle">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty sub.feedback}">
                                                        <button type="button" class="btn btn-secondary btn-sm"
                                                                onclick="showFeedback('${sub.submission_id}', this.dataset.fb)"
                                                                data-fb="<c:out value='${sub.feedback}'/>">
                                                            <i class="bi bi-chat-left-text-fill"></i> Xem
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-subtle">Chưa có</span>
                                                    </c:otherwise>
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

<!-- Modal xem feedback -->
<div class="modal-overlay" id="feedbackModal" style="display:none">
    <div class="modal-dialog">
        <div class="modal-header">
            <h3><i class="bi bi-chat-left-text-fill"></i> Phản hồi từ Hệ thống</h3>
            <button type="button" class="modal-close-btn" onclick="closeFeedback()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="modal-body">
            <p id="feedbackText" style="white-space: pre-line; line-height: 1.8;"></p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary" onclick="closeFeedback()">Đóng</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
function showFeedback(id, text) {
    document.getElementById('feedbackText').textContent = text;
    document.getElementById('feedbackModal').style.display = 'flex';
}
function closeFeedback() {
    document.getElementById('feedbackModal').style.display = 'none';
}
setTimeout(() => {
    const el = document.getElementById('alertSuccess');
    if (el) el.style.display = 'none';
}, 5000);
</script>
</body>
</html>
