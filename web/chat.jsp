<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                <!-- ── DANH SÁCH PHIÊN HỘI THOẠI GẦN ĐÂY (LỊCH SỬ HỎI AI) ── -->
                <aside class="chat-history-sidebar">
                    <button type="button" class="btn-new-chat" id="btnNewChat">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Cuộc trò chuyện mới</span>
                    </button>

                    <div class="chat-history-group">
                        <div class="chat-group-title">
                            <span>Lịch sử hỏi đáp AI</span>
                            <span class="badge-count">${not empty chatSessions ? chatSessions.size() : 0}</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty chatSessions}">
                                <c:forEach var="chatSession" items="${chatSessions}">
                                    <div class="chat-session-row ${chatSession.sessionId eq chatSessionId ? 'active' : ''}">
                                        <a class="chat-session-item"
                                           href="${pageContext.request.contextPath}/chat?sessionId=${chatSession.sessionId}"
                                           title="<c:out value="${chatSession.displayTitle}"/>">
                                            <i class="bi ${chatSession.sessionId eq chatSessionId ? 'bi-chat-left-dots-fill' : 'bi-chat-left-text'}"></i>
                                            <div class="chat-session-info">
                                                <div class="chat-session-title"><c:out value="${chatSession.displayTitle}"/></div>
                                                <c:if test="${not empty chatSession.lastActivityAt}">
                                                    <div class="chat-session-time"><fmt:formatDate value="${chatSession.lastActivityAt}" pattern="dd/MM HH:mm"/></div>
                                                </c:if>
                                            </div>
                                        </a>
                                        <button type="button" class="btn-delete-session" onclick="window.deleteChatSession(${chatSession.sessionId}, event)" title="Xóa phiên này">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="chat-session-empty">
                                    <i class="bi bi-chat-square-text"></i>
                                    <span>Chưa có cuộc trò chuyện nào.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="chat-history-footer">
                        <div class="chat-engine-status">
                            <span class="status-dot-pulse"></span>
                            <span>Engine: <strong>Gemini AI 24/7</strong></span>
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
                            <button type="button" class="btn-action-ghost" id="btnClearChat" title="Tạo một cuộc trò chuyện độc lập">
                                <i class="bi bi-plus-circle"></i>
                                <span>Chat mới</span>
                            </button>
                        </div>
                    </div>

                    <!-- Luồng tin nhắn (Messages Stream) -->
                    <div class="chat-messages-container" id="chatMessagesContainer" data-session-id="${chatSessionId}">
                        <!-- Tin nhắn chào mừng từ AI Tutor -->
                        <div class="chat-message ai-message">
                            <div class="message-avatar">
                                <i class="bi bi-robot"></i>
                            </div>
                            <div class="message-content">
                                <div class="message-author">AITA AI Tutor <span class="message-time">Hệ thống 24/7</span></div>
                                <div class="message-bubble">
                                    <p>Xin chào <strong>${sessionScope.currentUser.full_name}</strong>! 👋</p>
                                    <p>Tôi là <strong>Trợ lý AI Gia sư 24/7</strong> (Cá nhân hóa lộ trình học tập FE-S-03). Tôi sẽ đồng hành cùng bạn:</p>
                                    <ul>
                                        <li>Chuyển đổi các <strong>lỗi biên dịch &amp; ngoại lệ runtime</strong> thành hướng dẫn sư phạm trực quan, dễ hiểu theo thời gian thực.</li>
                                        <li>Tự động phân tích điểm yếu (bao gồm cả kiến thức nền tảng OOP kỳ trước) và cập nhật vào <strong>Lộ trình học tập cá nhân</strong> của bạn.</li>
                                        <li>Hỗ trợ 5 môn học: <code>PRJ301</code>, <code>CSD201</code>, <code>IOT102</code>, <code>SWR302</code>, <code>JPD123</code>.</li>
                                    </ul>
                                    <p>Hãy dán đoạn code lỗi, thông báo lỗi (stack trace) hoặc câu hỏi của bạn vào khung bên dưới để tôi hỗ trợ nhé!</p>
                                </div>
                            </div>
                        </div>

                        <!-- Render lịch sử tin nhắn đã lưu trong Database -->
                        <c:if test="${not empty chatMessages}">
                            <c:forEach var="msg" items="${chatMessages}">
                                <c:choose>
                                    <c:when test="${msg.senderType eq 'STUDENT'}">
                                        <div class="chat-message user-message">
                                            <div class="message-avatar">
                                                <c:out value="${sessionScope.currentUser.full_name.substring(0, 1).toUpperCase()}"/>
                                            </div>
                                            <div class="message-content">
                                                <div class="message-author">Bạn <span class="message-time">${msg.sentAt}</span></div>
                                                <div class="message-bubble"><c:out value="${msg.messageText}"/></div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="chat-message ai-message">
                                            <div class="message-avatar">
                                                <i class="bi bi-robot"></i>
                                            </div>
                                            <div class="message-content">
                                                <div class="message-author">AITA AI Tutor <span class="message-time">${msg.sentAt}</span></div>
                                                <div class="message-bubble">${msg.messageText}</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:if>


                    </div>

                    <!-- Khu vực nhập tin nhắn (Input Box) -->
                    <div class="chat-input-wrapper">
                        <form id="chatForm" onsubmit="window.handleChatSubmit(event)">
                            <div class="chat-input-bar">
                                <button type="button" class="btn-attach-chat" id="btnAttachFile" title="Đính kèm file code (.java, .jsp, .sql, .txt...)">
                                    <i class="bi bi-paperclip"></i>
                                </button>
                                <input type="file" id="chatFileInput" style="display:none" accept=".java,.jsp,.sql,.txt,.xml,.html,.css,.js,.py,.c,.cpp">
                                <textarea id="chatInput" rows="1" placeholder="Nhập câu hỏi, dán code hoặc bấm nút 📎 để đính kèm file... (Nhấn Enter để gửi)"></textarea>
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
