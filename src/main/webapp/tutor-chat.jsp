<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Tutor Chat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<main class="page-shell">
    <section class="chat-panel">
        <h1>AI Tutor Chat</h1>
        <form action="${pageContext.request.contextPath}/tutor" method="post" class="chat-form">
            <label for="question">Question</label>
            <textarea id="question" name="question" rows="5" placeholder="Ask the AI tutor...">${question}</textarea>
            <button type="submit">Send</button>
        </form>

        <% if (request.getAttribute("answer") != null) { %>
            <div class="answer-box">
                <h2>Answer</h2>
                <p><%= request.getAttribute("answer") %></p>
            </div>
        <% } %>
    </section>
</main>
</body>
</html>
