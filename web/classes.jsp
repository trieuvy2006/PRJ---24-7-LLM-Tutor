<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lớp học phụ trách — AITA 24/7 LLM Tutor</title>
    <meta name="description" content="Danh sách các lớp học, học viên và tình hình tương tác AI do giảng viên phụ trách.">
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
            <!-- Header Tiêu đề & Thao tác nhanh -->
            <div class="page-header-row">
                <div class="page-header-text">
                    <h1>Danh sách Lớp học phụ trách</h1>
                </div>
                <div class="page-header-actions">
                    <button type="button" class="btn btn-primary" onclick="alert('Tính năng Tạo Lớp học mới sẽ mở trong kỳ học tiếp theo!');">
                        <i class="bi bi-plus-circle-fill"></i>
                        <span>+ Thêm lớp học mới</span>
                    </button>
                </div>
            </div>

            <!-- Thống kê nhanh Metric Cards -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(99, 102, 241, 0.15); color:#818cf8">
                        <i class="bi bi-easel2-fill"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Lớp học phần</span>
                        <strong class="metric-val">${requestScope.classes != null ? requestScope.classes.size() : 0} lớp</strong>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(16, 185, 129, 0.15); color:#34d399">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Tổng số sinh viên</span>
                        <strong class="metric-val">
                            <c:set var="totalStudents" value="0"/>
                            <c:forEach items="${requestScope.classes}" var="c">
                                <c:set var="totalStudents" value="${totalStudents + c.student_count}"/>
                            </c:forEach>
                            ${totalStudents} sinh viên
                        </strong>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(245, 158, 11, 0.15); color:#fbbf24">
                        <i class="bi bi-journal-check"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">Milestones đang mở</span>
                        <strong class="metric-val">4 bài tập</strong>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon-box" style="background:rgba(236, 72, 153, 0.15); color:#f472b6">
                        <i class="bi bi-cpu-fill"></i>
                    </div>
                    <div class="metric-info">
                        <span class="metric-label">AI Tutor Giám sát</span>
                        <strong class="metric-val" style="color:#34d399">24/7 Hoạt động</strong>
                    </div>
                </div>
            </div>

            <!-- Danh sách Lớp học dạng Cards -->
            <div class="classes-grid">
                <c:forEach items="${requestScope.classes}" var="cls">
                    <div class="class-card">
                        <div class="class-card-header">
                            <div>
                                <span class="class-badge-code">${cls.class_code}</span>
                                <h3 class="class-title">${cls.class_name}</h3>
                            </div>
                            <div class="class-status-badge">Học kỳ Fall 2026</div>
                        </div>

                        <div class="class-card-body">
                            <div class="class-meta-item">
                                <i class="bi bi-book-fill"></i>
                                <span>Môn học: <strong>${cls.course_code}</strong></span>
                            </div>
                            <div class="class-meta-item">
                                <i class="bi bi-clock-fill"></i>
                                <span>Lịch học: ${cls.schedule}</span>
                            </div>
                            <div class="class-meta-item">
                                <i class="bi bi-geo-alt-fill"></i>
                                <span>Phòng học: ${cls.room}</span>
                            </div>

                            <div class="class-divider"></div>

                            <div class="class-stat-row">
                                <div class="class-students-count">
                                    <i class="bi bi-person-fill"></i>
                                    <strong>${cls.student_count}</strong> sinh viên ghi danh
                                </div>
                                <span style="font-size:12px; color:var(--text-subtle)">Tiến độ: ${cls.progress}%</span>
                            </div>

                            <div class="class-progress-bar">
                                <div class="class-progress-fill" style="width: ${cls.progress}%"></div>
                            </div>
                        </div>

                        <div class="class-card-actions">
                            <button type="button" class="btn btn-primary btn-sm" onclick="alert('Đang mở chi tiết lớp ${cls.class_code}!');">
                                <i class="bi bi-box-arrow-in-right"></i> Vào lớp học
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </main>
    </div>
</div>

<!-- Modal & Scripts -->
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
