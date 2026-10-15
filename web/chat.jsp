<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/login?error=access_denied"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>AI Tutor Chatbot 24/7 — AITA Tutor Platform</title>
    <meta name="description" content="Trợ lý gia sư AI 24/7 hỗ trợ giải đáp thắc mắc học tập và lập trình cho học sinh, sinh viên.">
    <%@ include file="/WEB-INF/views/fragments/header.jspf" %>
</head>
<body>

<div class="app-container">
    <!-- ── SIDEBAR ĐIỀU HƯỚNG ── -->
    <%@ include file="/WEB-INF/views/fragments/sidebar.jspf" %>

    <!-- ── KHU VỰC NỘI DUNG CHÍNH ── -->
    <div class="app-main">
        <%@ include file="/WEB-INF/views/fragments/topbar.jspf" %>

        <main class="content-body content-body-chat">
            <div class="chat-layout-wrapper">
                <!-- ── DANH SÁCH PHIÊN HỘI THOẠI GẦN ĐÂY ── -->
                <aside class="chat-history-sidebar">
                    <button type="button" class="btn-new-chat" id="btnNewChat">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Cuộc trò chuyện mới</span>
                    </button>

                    <div class="chat-history-group">
                        <div class="chat-group-title">Hôm nay</div>
                        <div class="chat-session-item active">
                            <i class="bi bi-chat-left-dots"></i>
                            <div class="chat-session-title">Giải đáp Servlet & JSP MVC2</div>
                        </div>
                    </div>

                    <div class="chat-history-group">
                        <div class="chat-group-title">Gần đây</div>
                        <div class="chat-session-item">
                            <i class="bi bi-chat-left-text"></i>
                            <div class="chat-session-title">Sửa lỗi NullPointerException JDBC</div>
                        </div>
                        <div class="chat-session-item">
                            <i class="bi bi-chat-left-text"></i>
                            <div class="chat-session-title">Thiết kế CSDL quan hệ Milestone 1</div>
                        </div>
                        <div class="chat-session-item">
                            <i class="bi bi-chat-left-text"></i>
                            <div class="chat-session-title">Phân quyền Filter trong Java Web</div>
                        </div>
                    </div>

                    <div class="chat-history-footer">
                        <div class="chat-engine-status">
                            <span class="status-dot-pulse"></span>
                            <span>Model: <strong>Claude 3.5 Sonnet</strong></span>
                        </div>
                    </div>
                </aside>

                <!-- ── KHUNG CHAT CHÍNH VỚI AI TUTOR ── -->
                <section class="chat-main-area">
                    <!-- Header Chat -->
                    <div class="chat-main-header">
                        <div class="chat-agent-info">
                            <div class="agent-avatar">
                                <i class="bi bi-robot"></i>
                            </div>
                            <div>
                                <h2>AITA AI Tutor 24/7</h2>
                            </div>
                        </div>
                        <div class="chat-header-actions">
                            <button type="button" class="btn-action-ghost" id="btnClearChat" title="Làm mới đoạn hội thoại">
                                <i class="bi bi-arrow-counterclockwise"></i>
                                <span>Làm mới</span>
                            </button>
                        </div>
                    </div>

                    <!-- Luồng tin nhắn (Messages Stream) -->
                    <div class="chat-messages-container" id="chatMessagesContainer">
                        <!-- Tin nhắn chào mừng từ AI Tutor -->
                        <div class="chat-message ai-message">
                            <div class="message-avatar">
                                <i class="bi bi-robot"></i>
                            </div>
                            <div class="message-content">
                                <div class="message-author">AITA AI Tutor <span class="message-time">Vừa xong</span></div>
                                <div class="message-bubble">
                                    <p>Xin chào <strong>${sessionScope.currentUser.full_name}</strong>! 👋</p>
                                    <p>Tôi là <strong>Trợ lý AI Gia sư 24/7</strong> của bạn. Tôi có thể đồng hành cùng bạn:</p>
                                    <ul>
                                        <li>Giải thích lý thuyết và luồng xử lý của mô hình <strong>MVC2 (Model-View-Controller)</strong>.</li>
                                        <li>Rà soát lỗi cú pháp hoặc logic trong <code>Servlet</code>, <code>JSP/JSTL</code>, <code>JDBC DBContext</code>.</li>
                                        <li>Gợi ý phương pháp giải bài tập, tối ưu hóa câu lệnh truy vấn SQL.</li>
                                    </ul>
                                    <p>Bạn đang gặp vướng mắc hay muốn cùng tôi tìm hiểu chủ đề nào hôm nay?</p>
                                </div>
                            </div>
                        </div>

                        <!-- Gợi ý câu hỏi nhanh (Prompt Quick Pills) -->
                        <div class="chat-quick-suggestions" id="quickSuggestions">
                            <div class="quick-pill" onclick="window.sendSuggestedPrompt(this.innerText)">
                                💡 Giải thích vòng đời của HttpServlet (init, service, destroy)
                            </div>
                            <div class="quick-pill" onclick="window.sendSuggestedPrompt(this.innerText)">
                                🔍 Cách khắc phục lỗi Tiếng Việt bị lỗi font (UTF-8) trong JSP & Servlet
                            </div>
                            <div class="quick-pill" onclick="window.sendSuggestedPrompt(this.innerText)">
                                🛠️ Tìm lỗi 500 khi kết nối cơ sở dữ liệu qua DBContext
                            </div>
                            <div class="quick-pill" onclick="window.sendSuggestedPrompt(this.innerText)">
                                📚 Hướng dẫn làm bài Milestone nộp bài tập Java Web
                            </div>
                        </div>
                    </div>

                    <!-- Khu vực nhập tin nhắn (Input Box) -->
                    <div class="chat-input-wrapper">
                        <form id="chatForm" onsubmit="window.handleChatSubmit(event)">
                            <div class="chat-input-bar">
                                <textarea id="chatInput" rows="1" placeholder="Nhập câu hỏi hoặc dán mã nguồn cần AI giải thích... (Nhấn Enter để gửi, Shift+Enter xuống dòng)"></textarea>
                                <button type="submit" class="btn-send-chat" id="btnSendChat" aria-label="Gửi tin nhắn">
                                    <i class="bi bi-send-fill"></i>
                                </button>
                            </div>
                            <div class="chat-input-hint">
                                <span><i class="bi bi-shield-check"></i> AI Tutor hỗ trợ định hướng tư duy sư phạm. Hãy tự kiểm chứng và thực thi code trên IDE.</span>
                            </div>
                        </form>
                    </div>
                </section>
            </div>
        </main>
    </div>
</div>

<!-- Modal & Scripts -->
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
