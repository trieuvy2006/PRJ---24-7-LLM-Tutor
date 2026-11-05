<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lộ trình Học tập &amp; Kế hoạch Ôn tập — AITA</title>
    <meta name="description" content="Lộ trình học tập cá nhân hóa giúp sinh viên phát hiện điểm yếu và ôn tập hiệu quả.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
    <style>
        .learning-path-header {
            background: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .learning-path-header h1 {
            font-size: 1.45rem;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
        }
        .learning-path-header p {
            margin: 0;
            color: var(--text-muted);
            max-width: 750px;
            font-size: 0.92rem;
            line-height: 1.5;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: var(--shadow-sm);
        }
        .stat-icon {
            width: 46px;
            height: 46px;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            flex-shrink: 0;
        }
        .stat-icon.total { background: rgba(37, 99, 235, 0.1); color: var(--primary); }
        .stat-icon.in-progress { background: rgba(245, 158, 11, 0.12); color: #d97706; }
        .stat-icon.completed { background: rgba(16, 185, 129, 0.12); color: #059669; }
        .stat-val { font-size: 1.5rem; font-weight: 700; line-height: 1.2; color: var(--text-main); }
        .stat-lbl { font-size: 0.82rem; color: var(--text-muted); }
        .progress-bar-container {
            width: 100%;
            height: 7px;
            background: var(--border-color);
            border-radius: 4px;
            overflow: hidden;
            margin-top: 10px;
        }
        .progress-bar-fill {
            height: 100%;
            background: var(--primary);
            border-radius: 4px;
            transition: width 0.4s ease;
        }

        /* Danh sách phiếu lộ trình học */
        .topics-container {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .topic-card {
            background: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 18px 20px;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }
        .topic-card:hover {
            border-color: #cbd5e1;
            box-shadow: var(--shadow-md);
        }
        .topic-card.completed {
            border-left: 4px solid #10b981;
        }
        .topic-card.in-progress {
            border-left: 4px solid #f59e0b;
        }
        .topic-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }
        .topic-title {
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--text-main);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .topic-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-in-progress { background: rgba(245, 158, 11, 0.12); color: #d97706; border: 1px solid rgba(245, 158, 11, 0.25); }
        .badge-completed { background: rgba(16, 185, 129, 0.12); color: #059669; border: 1px solid rgba(16, 185, 129, 0.25); }
        
        /* Phần tóm tắt ngắn gọn bên ngoài */
        .topic-summary-row {
            margin-top: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .topic-summary-text {
            color: var(--text-muted);
            font-size: 0.88rem;
            line-height: 1.5;
            flex: 1;
            min-width: 250px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .btn-toggle-detail {
            background: transparent;
            border: 1px solid var(--border-color);
            color: var(--primary);
            font-size: 0.82rem;
            font-weight: 600;
            padding: 5px 12px;
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
        }
        .btn-toggle-detail:hover {
            background: rgba(37, 99, 235, 0.06);
            border-color: var(--primary);
        }

        /* Phần chi tiết bên trong (ẩn mặc định) */
        .topic-detail-drawer {
            display: none;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px dashed var(--border-color);
        }
        .topic-detail-drawer.open {
            display: block;
            animation: fadeIn 0.2s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .detail-box {
            background: var(--bg-surface-elevated, #f8fafc);
            border-left: 3px solid var(--primary);
            padding: 14px 16px;
            border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
            font-size: 0.9rem;
            color: var(--text-main);
            line-height: 1.6;
            margin-bottom: 14px;
        }
        .detail-box .step-title {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 6px;
            font-size: 0.92rem;
            font-weight: 600;
        }
        .detail-box strong {
            color: var(--text-main);
            font-weight: 600;
            display: inline;
        }
        .topic-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            font-size: 0.82rem;
            color: var(--text-subtle);
        }
        .topic-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>

<div class="app-container">
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body">
            <!-- ── GIAO DIỆN DÀNH CHO SINH VIÊN (ROLE_ID == 3) ── -->
            <c:if test="${empty sessionScope.role or sessionScope.role eq 'STUDENT' or sessionScope.currentUser.role_id == 3}">
                <!-- Header giới thiệu -->
                <div class="learning-path-header">
                    <h1>
                        <i class="bi bi-compass-fill" style="color: var(--primary);"></i>
                        Kế Hoạch &amp; Lộ Trình Học Tập Cá Nhân
                    </h1>
                    <p>
                        Hệ thống tự động theo dõi tiến độ bài nộp và câu hỏi thực hành để lập kế hoạch ôn tập tập trung, giúp bạn nhanh chóng củng cố các lỗ hổng kiến thức trước kỳ thi.
                    </p>
                </div>

                <!-- Thống kê tiến độ -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon total"><i class="bi bi-journal-bookmark-fill"></i></div>
                        <div>
                            <div class="stat-val">${totalItems}</div>
                            <div class="stat-lbl">Chủ đề cần lưu ý</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon in-progress"><i class="bi bi-hourglass-split"></i></div>
                        <div>
                            <div class="stat-val">${inProgressItems}</div>
                            <div class="stat-lbl">Đang cần ôn luyện</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon completed"><i class="bi bi-check-circle-fill"></i></div>
                        <div>
                            <div class="stat-val">${completedItems}</div>
                            <div class="stat-lbl">Đã nắm vững</div>
                        </div>
                    </div>
                    <div class="stat-card" style="flex-direction: column; align-items: flex-start; justify-content: center;">
                        <div style="display:flex; justify-content:space-between; width:100%; font-size:0.85rem;">
                            <span class="stat-lbl">Tiến độ hoàn thành</span>
                            <strong style="color: var(--primary);">${progressPercent}%</strong>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar-fill" style="width: ${progressPercent}%;"></div>
                        </div>
                    </div>
                </div>

                <!-- Danh sách các thẻ Lộ trình học (Hiển thị gọn gàng) -->
                <div class="topics-container">
                    <c:choose>
                        <c:when test="${not empty paths}">
                            <c:forEach var="p" items="${paths}" varStatus="loop">
                                <div class="topic-card ${p.status eq 'COMPLETED' ? 'completed' : 'in-progress'}" id="card-${p.pathId}">
                                    <div class="topic-header">
                                        <h3 class="topic-title">
                                            <i class="bi ${p.status eq 'COMPLETED' ? 'bi-check2-circle' : 'bi-bullseye'}" 
                                               style="color: ${p.status eq 'COMPLETED' ? '#10b981' : 'var(--primary)'};"></i>
                                            <c:out value="${p.weaknessTopic}"/>
                                        </h3>
                                        <span class="topic-badge ${p.status eq 'COMPLETED' ? 'badge-completed' : 'badge-in-progress'}">
                                            <i class="bi ${p.status eq 'COMPLETED' ? 'bi-check-circle-fill' : 'bi-arrow-repeat'}"></i>
                                            ${p.status eq 'COMPLETED' ? 'Đã hoàn thành' : 'Cần rèn luyện'}
                                        </span>
                                    </div>

                                    <!-- Tóm tắt sơ lược bên ngoài (Gọn gàng: Chỉ tóm tắt mục tiêu & thời lượng) -->
                                    <div class="topic-summary-row">
                                        <div class="topic-summary-text">
                                            <span style="font-weight:600; color:var(--text-main);">Mục tiêu:</span>
                                            Củng cố bản chất <c:out value="${p.weaknessTopic}"/> &mdash; <span style="color:#d97706; font-weight:500;">Ưu tiên ôn tập cao</span>
                                        </div>
                                        <button type="button" class="btn-toggle-detail" onclick="togglePathDetail(${p.pathId})">
                                            <span id="btn-text-${p.pathId}">Xem chi tiết</span>
                                            <i class="bi bi-chevron-down" id="icon-${p.pathId}"></i>
                                        </button>
                                    </div>

                                    <!-- Khu vực xem chi tiết mở rộng (Bung ra lộ trình 3 bước chuyên sâu) -->
                                    <div class="topic-detail-drawer" id="drawer-${p.pathId}">
                                        <div class="detail-box">
                                            <div style="margin-bottom: 12px; padding-bottom: 10px; border-bottom: 1px dashed var(--border-color);">
                                                <div class="step-title" style="color:var(--primary);">
                                                    <i class="bi bi-1-circle-fill"></i> Bước 1: Ôn tập lý thuyết nền tảng &amp; Bản chất
                                                </div>
                                                <p style="margin: 4px 0 0 0; color:var(--text-muted); font-size:0.88rem;">
                                                    Đọc lại tài liệu bài giảng môn học về <strong><c:out value="${p.weaknessTopic}"/></strong>, chú ý nguyên lý hoạt động, cấu trúc dữ liệu và điều kiện biên tránh lỗi runtime.
                                                </p>
                                            </div>

                                            <div style="margin-bottom: 12px; padding-bottom: 10px; border-bottom: 1px dashed var(--border-color);">
                                                <div class="step-title" style="color:#d97706;">
                                                    <i class="bi bi-2-circle-fill"></i> Bước 2: Hướng dẫn thực hành từng bước
                                                </div>
                                                <p style="margin: 4px 0 0 0; color:var(--text-main); font-size:0.9rem; line-height:1.5;">
                                                    <c:out value="${p.recommendedAction}"/>
                                                </p>
                                            </div>

                                            <div>
                                                <div class="step-title" style="color:#059669;">
                                                    <i class="bi bi-3-circle-fill"></i> Bước 3: Tự kiểm thử &amp; Hoàn thiện
                                                </div>
                                                <p style="margin: 4px 0 0 0; color:var(--text-muted); font-size:0.88rem;">
                                                    Mở NetBeans/IDE, tự code lại bài mẫu và chạy thử với ít nhất 2 bộ test data để đảm bảo đã nắm vững 100%.
                                                </p>
                                            </div>
                                        </div>

                                        <div class="topic-footer">
                                            <div>
                                                <i class="bi bi-clock-history"></i> Ghi nhận: <fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                            <div class="topic-actions">
                                                <a href="${pageContext.request.contextPath}/chat?topic=${p.weaknessTopic}" class="btn btn-secondary btn-sm" title="Bấm vào để Trợ lý tự động hướng dẫn chủ đề này">
                                                    <i class="bi bi-chat-dots-fill" style="color:var(--primary)"></i> Trao đổi với Trợ lý
                                                </a>
                                                <form method="POST" action="${pageContext.request.contextPath}/learning-path" style="display:inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="path_id" value="${p.pathId}">
                                                    <c:choose>
                                                        <c:when test="${p.status eq 'COMPLETED'}">
                                                            <input type="hidden" name="status" value="IN_PROGRESS">
                                                            <button type="submit" class="btn btn-secondary btn-sm" title="Đánh dấu cần ôn tập lại">
                                                                <i class="bi bi-arrow-counterclockwise"></i> Ôn tập lại
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="hidden" name="status" value="COMPLETED">
                                                            <button type="submit" class="btn btn-primary btn-sm" style="background:#10b981; border-color:#10b981;">
                                                                <i class="bi bi-check2"></i> Đã nắm vững
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 48px 20px; background: var(--bg-surface); border-radius: var(--radius-md); border: 1px dashed var(--border-color);">
                                <i class="bi bi-mortarboard" style="font-size: 3rem; color: var(--primary);"></i>
                                <h3 style="margin: 16px 0 8px 0; font-size: 1.15rem;">Tiến độ học tập hiện tại rất tốt!</h3>
                                <p style="color: var(--text-muted); max-width: 500px; margin: 0 auto 20px auto; font-size: 0.9rem;">
                                    Khi bạn nộp bài tập hoặc trao đổi về mã nguồn trong mục Hỗ trợ học tập, hệ thống sẽ tự động tổng hợp những chủ đề bạn cần củng cố tại đây.
                                </p>
                                <a href="${pageContext.request.contextPath}/chat" class="btn btn-primary">
                                    <i class="bi bi-chat-dots-fill"></i> Mở khung Trợ lý Học tập
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- ── GIAO DIỆN DÀNH CHO GIẢNG VIÊN / ADMIN (ROLE_ID <= 2) ── -->
            <c:if test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'INSTRUCTOR' or sessionScope.currentUser.role_id <= 2}">
                <div class="data-card">
                    <div class="data-card-header" style="justify-content: space-between;">
                        <h2 class="data-card-title">
                            <i class="bi bi-bar-chart-line-fill" style="color: var(--primary);"></i>
                            Báo Cáo Tổng Hợp Điểm Yếu &amp; Nhu Cầu Ôn Tập Của Sinh Viên
                        </h2>
                        <span class="badge" style="background:var(--border-color); color:var(--text-main); font-size:0.8rem; padding:4px 10px;">
                            Tổng: <strong>${allPaths.size()}</strong> mục ghi nhận
                        </span>
                    </div>

                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>MSSV</th>
                                    <th>Họ tên Sinh viên</th>
                                    <th>Chủ đề cần cải thiện</th>
                                    <th>Khuyến nghị ôn tập</th>
                                    <th>Trạng thái</th>
                                    <th>Thời gian</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${allPaths}">
                                    <tr>
                                        <td><code><c:out value="${item.studentCode}"/></code></td>
                                        <td style="font-weight: 600;"><c:out value="${item.studentName}"/></td>
                                        <td>
                                            <span style="color: var(--primary); font-weight: 600;">
                                                <c:out value="${item.weaknessTopic}"/>
                                            </span>
                                        </td>
                                        <td style="color: var(--text-muted); max-width: 380px;">
                                            <div style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;" title="<c:out value='${item.recommendedAction}'/>">
                                                <c:out value="${item.recommendedAction}"/>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="topic-badge ${item.status eq 'COMPLETED' ? 'badge-completed' : 'badge-in-progress'}">
                                                ${item.status eq 'COMPLETED' ? 'Đã khắc phục' : 'Đang ôn tập'}
                                            </span>
                                        </td>
                                        <td style="font-size:0.82rem; color:var(--text-subtle);">
                                            <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>

<script>
function togglePathDetail(id) {
    var drawer = document.getElementById('drawer-' + id);
    var btnText = document.getElementById('btn-text-' + id);
    var icon = document.getElementById('icon-' + id);
    if (!drawer) return;

    if (drawer.classList.contains('open')) {
        drawer.classList.remove('open');
        btnText.innerText = 'Xem chi tiết';
        icon.className = 'bi bi-chevron-down';
    } else {
        drawer.classList.add('open');
        btnText.innerText = 'Thu gọn';
        icon.className = 'bi bi-chevron-up';
    }
}
</script>
</body>
</html>
