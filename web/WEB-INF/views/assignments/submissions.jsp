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
    <meta name="description" content="Xem danh sách bài nộp của sinh viên và chấm điểm.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
    <style>
        .score-pill {
            display: inline-flex; align-items: center; gap: 4px;
            background: rgba(16,185,129,0.15); color: #34d399;
            border-radius: 20px; padding: 2px 10px; font-weight: 700; font-size: 0.9rem;
        }
        .score-pill.no-score {
            background: rgba(148,163,184,0.1); color: var(--text-subtle);
            font-weight: 400; font-size: 0.8rem;
        }
        .student-identity { display: flex; flex-direction: column; gap: 2px; }
        .mssv-tag {
            font-size: 0.75rem; font-family: monospace;
            color: var(--primary); background: rgba(99,102,241,0.12);
            border-radius: 4px; padding: 1px 6px; width: fit-content;
        }
        .mssv-tag.no-mssv { color: var(--text-subtle); background: transparent; font-family: inherit; font-size: 0.75rem; }
        /* Grade modal */
        .score-input-wrap {
            display: flex; align-items: center; justify-content: center;
            gap: 12px; margin-bottom: 14px;
        }
        .score-big-input {
            width: 110px; text-align: center;
            font-size: 2.2rem; font-weight: 800; line-height: 1;
            border: 2.5px solid var(--border); border-radius: 12px;
            background: var(--bg-card); color: var(--primary);
            padding: 12px 8px;
            transition: border-color .2s;
            -moz-appearance: textfield;
        }
        .score-big-input::-webkit-outer-spin-button,
        .score-big-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        .score-big-input:focus { outline: none; border-color: var(--primary); }
        .score-stepper { display: flex; flex-direction: column; gap: 4px; }
        .score-stepper button {
            width: 32px; height: 32px; border-radius: 8px; border: 1.5px solid var(--border);
            background: var(--bg-card); color: var(--text-primary);
            font-size: 1.1rem; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: background .15s, border-color .15s;
        }
        .score-stepper button:hover { background: var(--primary); border-color: var(--primary); color: #fff; }
        .quick-scores {
            display: flex; flex-wrap: wrap; gap: 6px; justify-content: center;
            margin-bottom: 1.25rem;
        }
        .qs-btn {
            width: 38px; height: 34px; border-radius: 8px;
            border: 1.5px solid var(--border); background: var(--bg-card);
            color: var(--text-primary); font-size: 0.85rem; font-weight: 600;
            cursor: pointer; transition: all .15s;
        }
        .qs-btn:hover, .qs-btn.active {
            background: var(--primary); border-color: var(--primary); color: #fff;
        }
        .grade-feedback-input {
            width: 100%; min-height: 80px; resize: vertical;
            border: 1.5px solid var(--border); border-radius: 8px;
            background: var(--bg-card); color: var(--text-primary);
            padding: 10px 12px; font-size: 0.9rem; font-family: inherit;
            box-sizing: border-box;
        }
        .grade-feedback-input:focus { outline: none; border-color: var(--primary); }
    </style>
</head>
<body>
<div class="app-container">
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>
    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>
        <main class="content-body">
            <div class="page-header-row">
                <div class="page-header-text">
                    <h1>Danh sách Bài Nộp</h1>
                    <p>Bài tập: <strong><c:out value="${requestScope.assignment.title}"/></strong>
                        &nbsp;&mdash;&nbsp;
                        <span class="badge badge-course"><c:out value="${requestScope.assignment.course_code}"/></span>
                        <c:if test="${not empty requestScope.assignment.course_name}">
                            <span class="text-subtle" style="font-size:0.9rem;">&nbsp;<c:out value="${requestScope.assignment.course_name}"/></span>
                        </c:if>
                    </p>
                </div>
                <div class="page-header-actions">
                    <a href="${pageContext.request.contextPath}/assignments" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/assignments?action=edit&id=${requestScope.assignment.assignment_id}" class="btn btn-primary">
                        <i class="bi bi-pencil-fill"></i> Sửa deadline
                    </a>
                </div>
            </div>

            <div class="metrics-grid" style="margin-bottom:1.5rem;">
                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(99,102,241,0.15);color:#818cf8"><i class="bi bi-people-fill"></i></div>
                    <div class="metric-info">
                        <span class="metric-label">Tổng bài nộp</span>
                        <strong class="metric-val">${submissions.size()}</strong>
                    </div>
                </div>
                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(16,185,129,0.15);color:#34d399"><i class="bi bi-check2-all"></i></div>
                    <div class="metric-info">
                        <span class="metric-label">Đã chấm điểm</span>
                        <strong class="metric-val" id="gradedCounter">
                            <c:set var="gradedCount" value="0"/>
                            <c:forEach items="${submissions}" var="s">
                                <c:if test="${s.status eq 'GRADED'}"><c:set var="gradedCount" value="${gradedCount+1}"/></c:if>
                            </c:forEach>
                            ${gradedCount}
                        </strong>
                    </div>
                </div>
                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(245,158,11,0.15);color:#fbbf24"><i class="bi bi-hourglass-split"></i></div>
                    <div class="metric-info">
                        <span class="metric-label">Chờ chấm</span>
                        <strong class="metric-val" id="pendingCounter">
                            <c:set var="pendingCount" value="0"/>
                            <c:forEach items="${submissions}" var="s">
                                <c:if test="${s.status eq 'PENDING' or s.status eq 'PROCESSING'}"><c:set var="pendingCount" value="${pendingCount+1}"/></c:if>
                            </c:forEach>
                            ${pendingCount}
                        </strong>
                    </div>
                </div>
                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(236,72,153,0.15);color:#f472b6"><i class="bi bi-calendar-event-fill"></i></div>
                    <div class="metric-info">
                        <span class="metric-label">Deadline</span>
                        <strong class="metric-val" style="font-size:0.85rem;">
                            <fmt:formatDate value="${requestScope.assignment.deadline}" pattern="dd/MM/yyyy HH:mm"/>
                        </strong>
                    </div>
                </div>
            </div>

            <div id="gradeSuccessAlert" class="alert alert-success" style="display:none;">
                <i class="bi bi-check-circle-fill"></i>
                <span id="gradeSuccessMsg">Chấm điểm thành công!</span>
            </div>
            <div id="gradeErrorAlert" class="alert alert-danger" style="display:none;">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span id="gradeErrorMsg"></span>
            </div>

            <div class="data-card">
                <div class="data-card-header">
                    <h2 class="data-card-title"><i class="bi bi-collection-fill"></i> Bài nộp của sinh viên</h2>
                </div>
                <c:choose>
                    <c:when test="${empty submissions}">
                        <div class="empty-state">
                            <i class="bi bi-inbox" style="font-size:3rem;color:var(--text-subtle)"></i>
                            <p>Chưa có sinh viên nào nộp bài cho bài tập này.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" id="submissionsTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Sinh viên (MSSV)</th>
                                        <th>Lần nộp</th>
                                        <th>Thời gian nộp</th>
                                        <th>Bài nộp &amp; Tệp tin</th>
                                        <th>Trạng thái</th>
                                        <th>Điểm</th>
                                        <th>Phản hồi</th>
                                        <th>Chấm điểm</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${submissions}" var="sub" varStatus="st">
                                        <tr id="row-${sub.submission_id}">
                                            <td>${st.index + 1}</td>
                                            <td>
                                                <div class="student-identity">
                                                    <strong><c:out value="${sub.student_name}"/></strong>
                                                    <c:choose>
                                                        <c:when test="${not empty sub.student_code}">
                                                             <span class="mssv-tag"><c:out value="${sub.student_code}"/></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="mssv-tag no-mssv">Chưa có MSSV</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td class="text-center"><span class="attempt-badge">Lần ${sub.attempt_number}</span></td>
                                            <td><fmt:formatDate value="${sub.submitted_at}" pattern="HH:mm -- dd/MM/yyyy"/></td>
                                            <td>
                                                <div style="display:flex; flex-direction:column; gap:4px;">
                                                    <a href="${pageContext.request.contextPath}/assignments?action=download&id=${sub.submission_id}" 
                                                       class="btn btn-secondary btn-sm" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; padding:4px 10px; font-size:0.8rem; background:rgba(56, 189, 248, 0.12); border-color:rgba(56, 189, 248, 0.3); color:#38bdf8;" 
                                                       title="Tải về tệp bài làm của sinh viên">
                                                        <i class="bi bi-cloud-arrow-down-fill" style="color:#38bdf8; font-size:1rem;"></i> 
                                                        <span>Tải bài làm</span>
                                                    </a>
                                                    <c:if test="${not empty sub.sha256_hash}">
                                                        <span style="font-family:monospace; font-size:0.72rem; color:var(--text-subtle); cursor:pointer;" 
                                                              title="Mã băm SHA-256 xác thực: ${sub.sha256_hash} (Nhấn để sao chép)"
                                                              onclick="navigator.clipboard.writeText('${sub.sha256_hash}'); alert('Đã sao chép mã SHA-256:\n${sub.sha256_hash}');">
                                                            <i class="bi bi-shield-check" style="color:#10b981;"></i> SHA: ${sub.sha256_hash.length() > 8 ? sub.sha256_hash.substring(0, 8) : sub.sha256_hash}...
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sub.status eq 'GRADED'}">
                                                        <span class="status-badge status-graded" id="status-${sub.submission_id}">Đã chấm</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'PENDING'}">
                                                        <span class="status-badge status-pending" id="status-${sub.submission_id}">Chờ chấm</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'PROCESSING'}">
                                                        <span class="status-badge status-processing" id="status-${sub.submission_id}">Đang xử lý</span>
                                                    </c:when>
                                                    <c:when test="${sub.status eq 'FAILED'}">
                                                        <span class="status-badge status-failed" id="status-${sub.submission_id}">Lỗi</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge" id="status-${sub.submission_id}"><c:out value="${sub.status}"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <span id="score-${sub.submission_id}">
                                                    <c:choose>
                                                        <c:when test="${not empty sub.score}">
                                                            <span class="score-pill">${sub.score}/10</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="score-pill no-score">Chưa chấm</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="feedback-display-${sub.submission_id}">
                                                    <c:choose>
                                                        <c:when test="${not empty sub.feedback}">
                                                            <button type="button" class="btn btn-secondary btn-sm"
                                                                    onclick="showFeedbackOnly(this.dataset.fb)"
                                                                    data-fb="<c:out value='${sub.feedback}'/>">
                                                                <i class="bi bi-chat-left-text-fill"></i> Xem
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise><span class="text-subtle" style="font-size:0.8rem;">--</span></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <c:set var="fbEsc"><c:out value="${sub.feedback}"/></c:set>
                                                <c:set var="nameEsc"><c:out value="${sub.student_name}"/></c:set>
                                                <c:set var="codeEsc"><c:out value="${sub.student_code}"/></c:set>
                                                <button type="button" class="btn btn-primary btn-sm"
                                                        id="grade-btn-${sub.submission_id}"
                                                        onclick="openGradeModal(${sub.submission_id})">
                                                    <c:choose>
                                                        <c:when test="${not empty sub.score}">
                                                            <i class="bi bi-pencil-fill"></i> Sửa điểm
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-award-fill"></i> Chấm điểm
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
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

<div class="modal-overlay" id="gradeModal" style="display:none">
    <div class="modal-dialog" style="max-width:440px;">
        <div class="modal-header">
            <h3><i class="bi bi-award-fill" style="color:var(--primary)"></i> Chấm điểm bài nộp</h3>
            <button type="button" class="modal-close-btn" onclick="closeGradeModal()"><i class="bi bi-x-lg"></i></button>
        </div>
        <div class="modal-body">
            <!-- Thông tin sinh viên -->
            <div style="display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(99,102,241,0.07);border-radius:8px;margin-bottom:0.75rem;">
                <i class="bi bi-person-circle" style="font-size:1.4rem;color:var(--primary)"></i>
                <div>
                    <div style="font-weight:700;font-size:0.95rem;" id="gradeStudentName"></div>
                    <div id="gradeStudentCode" class="mssv-tag" style="margin-top:2px;"></div>
                </div>
            </div>

            <!-- Xem / Tải bài nộp của sinh viên -->
            <div style="display:flex; justify-content:space-between; align-items:center; padding:10px 12px; background:rgba(56, 189, 248, 0.08); border:1px solid rgba(56, 189, 248, 0.25); border-radius:8px; margin-bottom:1.25rem;">
                <div style="overflow:hidden; padding-right:8px;">
                    <div style="font-size:0.75rem; color:var(--text-subtle); text-transform:uppercase; font-weight:600;">Tệp bài làm sinh viên</div>
                    <div style="font-weight:600; font-size:0.85rem; color:#38bdf8; text-overflow:ellipsis; overflow:hidden; white-space:nowrap;" id="gradeFileName">Tệp bài nộp (.ZIP)</div>
                </div>
                <a id="gradeDownloadLink" href="#" class="btn btn-secondary btn-sm" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; padding:6px 12px; background:rgba(56,189,248,0.15); border-color:rgba(56,189,248,0.4); color:#38bdf8; white-space:nowrap;">
                    <i class="bi bi-cloud-arrow-down-fill"></i> Tải xem bài
                </a>
            </div>

            <!-- Input điểm -->
            <div style="margin-bottom:0.75rem;">
                <label style="display:block;font-weight:600;margin-bottom:10px;font-size:0.875rem;color:var(--text-subtle);text-transform:uppercase;letter-spacing:.04em;">
                    <i class="bi bi-star-fill" style="color:#fbbf24"></i> Điểm số (0 &ndash; 10)
                </label>
                <div class="score-input-wrap">
                    <div class="score-stepper">
                        <button type="button" onclick="stepScore(1)" title="Tăng"><i class="bi bi-chevron-up"></i></button>
                        <button type="button" onclick="stepScore(-1)" title="Giảm"><i class="bi bi-chevron-down"></i></button>
                    </div>
                    <input type="number" id="gradeScoreInput" min="0" max="10" step="0.5"
                           value="0" class="score-big-input"
                           oninput="onScoreInput(this.value)">
                    <span style="font-size:1.4rem;font-weight:700;color:var(--text-subtle);">/10</span>
                </div>
                <!-- Nút chọn nhanh -->
                <div class="quick-scores" id="quickScores">
                    <button class="qs-btn" onclick="setScore(0)">0</button>
                    <button class="qs-btn" onclick="setScore(1)">1</button>
                    <button class="qs-btn" onclick="setScore(2)">2</button>
                    <button class="qs-btn" onclick="setScore(3)">3</button>
                    <button class="qs-btn" onclick="setScore(4)">4</button>
                    <button class="qs-btn" onclick="setScore(5)">5</button>
                    <button class="qs-btn" onclick="setScore(6)">6</button>
                    <button class="qs-btn" onclick="setScore(7)">7</button>
                    <button class="qs-btn" onclick="setScore(8)">8</button>
                    <button class="qs-btn" onclick="setScore(9)">9</button>
                    <button class="qs-btn" onclick="setScore(10)">10</button>
                </div>
            </div>

            <!-- Nhận xét -->
            <div>
                <label for="gradeFeedbackInput" style="display:block;font-weight:600;margin-bottom:8px;font-size:0.875rem;color:var(--text-subtle);text-transform:uppercase;letter-spacing:.04em;">
                    <i class="bi bi-chat-left-text-fill" style="color:var(--primary)"></i>
                    Nhận xét <span style="font-weight:400;text-transform:none;font-size:0.8rem;">(tùy chọn)</span>
                </label>
                <textarea id="gradeFeedbackInput" class="grade-feedback-input"
                          placeholder="Nhận xét cho sinh viên..."></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeGradeModal()">Hủy</button>
            <button class="btn btn-primary" id="gradeSubmitBtn" onclick="submitGrade()">
                <i class="bi bi-award-fill"></i>
                <span id="gradeSubmitBtnText">Xác nhận chấm điểm</span>
            </button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="feedbackModal" style="display:none">
    <div class="modal-dialog">
        <div class="modal-header">
            <h3><i class="bi bi-chat-left-text-fill"></i> Phản hồi chấm điểm</h3>
            <button type="button" class="modal-close-btn" onclick="document.getElementById('feedbackModal').style.display='none'">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="modal-body">
            <p id="feedbackText" style="white-space:pre-line;line-height:1.8;"></p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary" onclick="document.getElementById('feedbackModal').style.display='none'">Đóng</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
// Du lieu cua tung bai nop (duoc inject tu JSP)
const subData = {
    <c:forEach items="${submissions}" var="sub" varStatus="st">
    "${sub.submission_id}": {
        name: "<c:out value='${sub.student_name}'/>",
        code: "<c:out value='${sub.student_code}'/>",
        score: ${not empty sub.score ? sub.score : 0},
        hasScore: ${not empty sub.score},
        feedback: "<c:out value='${sub.feedback}'/>"
    }<c:if test="${not st.last}">,</c:if>
    </c:forEach>
};

let currentSubId = null;

function openGradeModal(subId) {
    currentSubId = subId;
    const d = subData[subId] || {};
    document.getElementById('gradeStudentName').textContent = d.name || '';
    const codeEl = document.getElementById('gradeStudentCode');
    codeEl.textContent = d.code && d.code.trim() ? d.code : 'Chưa có MSSV';
    const score = d.hasScore ? parseFloat(d.score) : 0;
    document.getElementById('gradeScoreInput').value = score;
    highlightQsBtn(score);
    document.getElementById('gradeFeedbackInput').value = d.feedback || '';
    document.getElementById('gradeSubmitBtnText').textContent = 'Xác nhận chấm điểm';
    document.getElementById('gradeSubmitBtn').disabled = false;
    document.getElementById('gradeModal').style.display = 'flex';
    setTimeout(() => document.getElementById('gradeScoreInput').focus(), 100);
}

function closeGradeModal() {
    document.getElementById('gradeModal').style.display = 'none';
    currentSubId = null;
}

// Nhập trực tiếp vào input
function onScoreInput(val) {
    const v = Math.min(10, Math.max(0, parseFloat(val) || 0));
    highlightQsBtn(v);
}

// Nhấn nút số nhanh
function setScore(v) {
    document.getElementById('gradeScoreInput').value = v;
    highlightQsBtn(v);
    document.getElementById('gradeScoreInput').focus();
}

// Bước +/- 0.5
function stepScore(delta) {
    const inp = document.getElementById('gradeScoreInput');
    let v = parseFloat(inp.value) || 0;
    v = Math.min(10, Math.max(0, Math.round((v + delta * 0.5) * 10) / 10));
    inp.value = v;
    highlightQsBtn(v);
}

// Tô sáng nút tương ứng
function highlightQsBtn(v) {
    document.querySelectorAll('.qs-btn').forEach(btn => {
        btn.classList.toggle('active', parseInt(btn.textContent) === Math.round(v));
    });
}

function submitGrade() {
    if (!currentSubId) return;
    const score = parseFloat(document.getElementById('gradeScoreInput').value);
    if (isNaN(score) || score < 0 || score > 10) {
        showGradeAlert('error', 'Điểm số phải nằm trong khoảng 0.0 đến 10.0.');
        return;
    }
    const feedback = document.getElementById('gradeFeedbackInput').value;
    const btn = document.getElementById('gradeSubmitBtn');
    btn.disabled = true;
    document.getElementById('gradeSubmitBtnText').textContent = 'Đang lưu...';

    const params = new URLSearchParams();
    params.append('submission_id', currentSubId);
    params.append('score', score);
    params.append('feedback', feedback);

    fetch('${pageContext.request.contextPath}/grade', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: params.toString()
    })
    .then(async r => {
        const text = await r.text();
        try {
            return JSON.parse(text);
        } catch (e) {
            console.error('Lỗi parse JSON phản hồi:', text, e);
            throw new Error('Dữ liệu máy chủ trả về không đúng định dạng JSON.');
        }
    })
    .then(data => {
        if (data.success) {
            const savedSubId = currentSubId;
            closeGradeModal();
            updateRowUI(savedSubId, data.score, data.feedback);
            // Cập nhật subData
            if (subData[savedSubId]) {
                subData[savedSubId].score = parseFloat(data.score);
                subData[savedSubId].hasScore = true;
                subData[savedSubId].feedback = data.feedback || '';
            }
            showGradeAlert('success', 'Chấm điểm thành công! Điểm: ' + data.score + '/10');
        } else {
            showGradeAlert('error', data.error || 'Chấm điểm thất bại.');
            btn.disabled = false;
            document.getElementById('gradeSubmitBtnText').textContent = 'Xác nhận chấm điểm';
        }
    })
    .catch((err) => {
        console.error('Lỗi khi chấm điểm:', err);
        showGradeAlert('error', err.message || 'Lỗi kết nối. Vui lòng thử lại.');
        btn.disabled = false;
        document.getElementById('gradeSubmitBtnText').textContent = 'Xác nhận chấm điểm';
    });
}

function updateRowUI(subId, score, feedback) {
    const scoreEl = document.getElementById('score-' + subId);
    if (scoreEl) scoreEl.innerHTML = '<span class="score-pill">' + score + '/10</span>';

    const statusEl = document.getElementById('status-' + subId);
    if (statusEl) { statusEl.className = 'status-badge status-graded'; statusEl.textContent = 'Đã chấm'; }

    const btn = document.getElementById('grade-btn-' + subId);
    if (btn) btn.innerHTML = '<i class="bi bi-pencil-fill"></i> Sửa điểm';

    const fbEl = document.getElementById('feedback-display-' + subId);
    if (fbEl) {
        if (feedback && feedback.trim()) {
            const esc = feedback.replace(/&/g,'&amp;').replace(/"/g,'&quot;');
            fbEl.innerHTML = '<button type="button" class="btn btn-secondary btn-sm" onclick="showFeedbackOnly(this.dataset.fb)" data-fb="' + esc + '"><i class="bi bi-chat-left-text-fill"></i> Xem</button>';
        } else {
            fbEl.innerHTML = '<span class="text-subtle" style="font-size:0.8rem;">--</span>';
        }
    }
    recalcCounters();
}

function recalcCounters() {
    let graded = 0, pending = 0;
    document.querySelectorAll('#submissionsTable tbody tr').forEach(row => {
        const badge = row.querySelector('.status-badge');
        if (!badge) return;
        if (badge.classList.contains('status-graded')) graded++;
        else pending++;
    });
    const gc = document.getElementById('gradedCounter');
    const pc = document.getElementById('pendingCounter');
    if (gc) gc.textContent = graded;
    if (pc) pc.textContent = pending;
}

function showFeedbackOnly(text) {
    document.getElementById('feedbackText').textContent = text;
    document.getElementById('feedbackModal').style.display = 'flex';
}

function showGradeAlert(type, msg) {
    document.getElementById('gradeSuccessAlert').style.display = 'none';
    document.getElementById('gradeErrorAlert').style.display = 'none';
    if (type === 'success') {
        document.getElementById('gradeSuccessMsg').textContent = msg;
        document.getElementById('gradeSuccessAlert').style.display = 'flex';
        setTimeout(() => { document.getElementById('gradeSuccessAlert').style.display = 'none'; }, 5000);
    } else {
        document.getElementById('gradeErrorMsg').textContent = msg;
        document.getElementById('gradeErrorAlert').style.display = 'flex';
        setTimeout(() => { document.getElementById('gradeErrorAlert').style.display = 'none'; }, 6000);
    }
}

document.getElementById('gradeModal').addEventListener('click', e => { if (e.target === document.getElementById('gradeModal')) closeGradeModal(); });
document.getElementById('feedbackModal').addEventListener('click', e => { if (e.target === document.getElementById('feedbackModal')) document.getElementById('feedbackModal').style.display='none'; });
</script>
</body>
</html>
