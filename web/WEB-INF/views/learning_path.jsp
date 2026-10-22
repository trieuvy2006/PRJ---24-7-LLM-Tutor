<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lộ trình Học tập Cá nhân hóa — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Lộ trình học tập cá nhân hóa được tự động tổng hợp từ lỗi biên dịch và tương tác với AI Tutor.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
    <style>
        .learning-path-header {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.12), rgba(168, 85, 247, 0.08));
            border: 1px solid rgba(99, 102, 241, 0.2);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }
        .learning-path-header h1 {
            font-size: 1.5rem;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .learning-path-header p {
            margin: 0;
            color: var(--text-subtle);
            max-width: 700px;
            font-size: 0.95rem;
            line-height: 1.5;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
        }
        .stat-icon.total { background: rgba(99, 102, 241, 0.15); color: #6366f1; }
        .stat-icon.in-progress { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .stat-icon.completed { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .stat-val { font-size: 1.6rem; font-weight: 700; line-height: 1.2; }
        .stat-lbl { font-size: 0.85rem; color: var(--text-subtle); }
        .progress-bar-container {
            width: 100%;
            height: 8px;
            background: var(--border);
            border-radius: 4px;
            overflow: hidden;
            margin-top: 12px;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #6366f1, #10b981);
            border-radius: 4px;
            transition: width 0.4s ease;
        }
        .topic-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 20px;
            margin-bottom: 16px;
            transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
            position: relative;
        }
        .topic-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            border-color: rgba(99, 102, 241, 0.4);
        }
        .topic-card.completed {
            opacity: 0.8;
            border-left: 4px solid #10b981;
        }
        .topic-card.in-progress {
            border-left: 4px solid #f59e0b;
        }
        .topic-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
        }
        .topic-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text);
            margin: 0;
        }
        .topic-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-in-progress { background: rgba(245, 158, 11, 0.15); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.3); }
        .badge-completed { background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); }
        .action-box {
            background: var(--surface-subtle, rgba(255, 255, 255, 0.03));
            border-left: 3px solid #6366f1;
            padding: 12px 16px;
            border-radius: 0 8px 8px 0;
            margin-bottom: 16px;
            font-size: 0.92rem;
            color: var(--text-muted);
            line-height: 1.5;
        }
        .action-box strong { color: var(--text); }
        .topic-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            font-size: 0.85rem;
            color: var(--text-subtle);
        }
        .topic-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>

<div class="app-container">
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body">
            <!-- GIAO DIỆN DÀNH CHO SINH VIÊN (ROLE_ID == 3) -->
            <c:if test="${empty sessionScope.role or sessionScope.role eq 'STUDENT' or sessionScope.currentUser.role_id == 3}">
                <!-- Thống kê tiến độ -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon total"><i class="bi bi-list-check"></i></div>
                        <div>
                            <div class="stat-val">${totalItems}</div>
                            <div class="stat-lbl">Mục tiêu AI chẩn đoán</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon in-progress"><i class="bi bi-hourglass-split"></i></div>
                        <div>
                            <div class="stat-val">${inProgressItems}</div>
                            <div class="stat-lbl">Đang cần rèn luyện</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon completed"><i class="bi bi-patch-check-fill"></i></div>
                        <div>
                            <div class="stat-val">${completedItems}</div>
                            <div class="stat-lbl">Đã khắc phục thành công</div>
                        </div>
                    </div>
                    <div class="stat-card" style="flex-direction: column; align-items: flex-start; justify-content: center;">
                        <div style="display:flex; justify-content:space-between; width:100%; font-size:0.85rem;">
                            <span>Tiến độ cải thiện</span>
                            <strong>${progressPercent}%</strong>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar-fill" style="width: ${progressPercent}%;"></div>
                        </div>
                    </div>
                </div>

                <!-- Danh sách các thẻ Điểm yếu & Lộ trình -->
                <div class="topics-container">
                    <c:choose>
                        <c:when test="${not empty paths}">
                            <c:forEach var="p" items="${paths}">
                                <div class="topic-card ${p.status eq 'COMPLETED' ? 'completed' : 'in-progress'}">
                                    <div class="topic-header">
                                        <div>
                                            <h3 class="topic-title">
                                                <i class="bi bi-crosshair2" style="color: #6366f1; margin-right: 6px;"></i>
                                                ${p.weaknessTopic}
                                            </h3>
                                        </div>
                                        <span class="topic-badge ${p.status eq 'COMPLETED' ? 'badge-completed' : 'badge-in-progress'}">
                                            <i class="bi ${p.status eq 'COMPLETED' ? 'bi-check-circle-fill' : 'bi-arrow-repeat'}"></i>
                                            ${p.status eq 'COMPLETED' ? 'Đã khắc phục' : 'Cần cải thiện'}
                                        </span>
                                    </div>

                                    <div class="action-box">
                                        <strong><i class="bi bi-lightbulb-fill" style="color: #f59e0b;"></i> Hướng dẫn sư phạm &amp; Hành động:</strong><br>
                                        ${p.recommendedAction}
                                    </div>

                                    <div class="topic-footer">
                                        <div>
                                            <i class="bi bi-calendar-event"></i> Phát hiện: ${p.createdAt}
                                        </div>
                                        <div class="topic-actions">
                                            <a href="${pageContext.request.contextPath}/chat" class="btn btn-secondary btn-sm" title="Hỏi AI thêm về chủ đề này">
                                                <i class="bi bi-robot"></i> Hỏi AI Tutor
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
                                                            <i class="bi bi-check2"></i> Đã hiểu &amp; Khắc phục
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 48px 20px; background: var(--surface); border-radius: 16px; border: 1px dashed var(--border);">
                                <i class="bi bi-emoji-smile" style="font-size: 3rem; color: #10b981;"></i>
                                <h3 style="margin: 16px 0 8px 0;">Hiện chưa ghi nhận lỗ hổng kiến thức nào!</h3>
                                <p style="color: var(--text-subtle); max-width: 500px; margin: 0 auto 20px auto;">
                                    Khi bạn nộp bài tập hoặc hỏi lỗi code trong khung chat AI Tutor, hệ thống sẽ tự động chẩn đoán và lập lộ trình cải thiện tại đây.
                                </p>
                                <a href="${pageContext.request.contextPath}/chat" class="btn btn-primary">
                                    <i class="bi bi-robot"></i> Trò chuyện với AI Tutor ngay
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- GIAO DIỆN DÀNH CHO GIẢNG VIÊN / ADMIN (ROLE_ID == 1 hoặc 2) -->
            <c:if test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'INSTRUCTOR' or sessionScope.currentUser.role_id <= 2}">
                <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 20px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2 style="font-size: 1.25rem; margin: 0;">
                            <i class="bi bi-bar-chart-line-fill" style="color: #6366f1;"></i>
                            Báo cáo Tổng hợp Điểm yếu Sinh viên
                        </h2>
                        <span style="font-size: 0.85rem; color: var(--text-subtle);">Tổng cộng: <strong>${allPaths.size()}</strong> mục ghi nhận</span>
                    </div>

                    <div style="overflow-x: auto;">
                        <table class="table" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 2px solid var(--border); text-align: left; font-size: 0.85rem; color: var(--text-subtle);">
                                    <th style="padding: 12px 16px;">Mã SV</th>
                                    <th style="padding: 12px 16px;">Họ tên Sinh viên</th>
                                    <th style="padding: 12px 16px;">Điểm yếu AI chẩn đoán</th>
                                    <th style="padding: 12px 16px;">Khuyến nghị hành động</th>
                                    <th style="padding: 12px 16px;">Trạng thái</th>
                                    <th style="padding: 12px 16px;">Thời gian</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${allPaths}">
                                    <tr style="border-bottom: 1px solid var(--border); font-size: 0.9rem;">
                                        <td style="padding: 12px 16px;"><code>${item.studentCode}</code></td>
                                        <td style="padding: 12px 16px; font-weight: 600;">${item.studentName}</td>
                                        <td style="padding: 12px 16px;">
                                            <span style="color: #6366f1; font-weight: 500;">${item.weaknessTopic}</span>
                                        </td>
                                        <td style="padding: 12px 16px; color: var(--text-muted); max-width: 320px;">
                                            ${item.recommendedAction}
                                        </td>
                                        <td style="padding: 12px 16px;">
                                            <span class="topic-badge ${item.status eq 'COMPLETED' ? 'badge-completed' : 'badge-in-progress'}">
                                                ${item.status eq 'COMPLETED' ? 'Đã khắc phục' : 'Đang xử lý'}
                                            </span>
                                        </td>
                                        <td style="padding: 12px 16px; color: var(--text-subtle); font-size: 0.8rem;">
                                            ${item.createdAt}
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
</body>
</html>
