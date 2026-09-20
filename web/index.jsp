<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.DemoMessage"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AITA - JDBC Demo</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
    </head>
    <body>
        <main>
            <h1>AITA - SQL Server JDBC Demo</h1>
            <% if (Boolean.TRUE.equals(request.getAttribute("connected"))) { %>
                <p class="ok">Đã kết nối SQL Server: AITA_DB</p>
            <% } else { %>
                <p class="error">Chưa kết nối được database.</p>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <pre class="error"><%= request.getAttribute("error") %></pre>
            <% } %>

            <form action="${pageContext.request.contextPath}/database-demo" method="post">
                <label for="content">Nội dung demo</label>
                <input id="content" name="content" maxlength="255" required>
                <button type="submit">Lưu vào database</button>
            </form>

            <h2>Dữ liệu lấy từ dbo.DemoMessages</h2>
            <table>
                <thead><tr><th>ID</th><th>Nội dung</th><th>Thời gian tạo</th></tr></thead>
                <tbody>
                    <% List<DemoMessage> messages = (List<DemoMessage>) request.getAttribute("messages"); %>
                    <% if (messages != null) for (DemoMessage message : messages) { %>
                        <tr><td><%= message.getId() %></td><td><%= message.getContent() %></td><td><%= message.getCreatedAt() %></td></tr>
                    <% } %>
                </tbody>
            </table>
        </main>
    </body>
</html>
