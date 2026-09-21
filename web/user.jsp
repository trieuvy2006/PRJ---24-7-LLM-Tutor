<%-- 
    Document   : user
    Created on : 21-09-2026, 01:13:47
    Author     : trieuvy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>  
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
            function doDelete(user_id) {
                if (confirm("Are you want to delete this user")) {
                    window.location = "delete?user_id=" + user_id;
                }
            }
        </script>
    </head>
    <body>
    <center>    
        <h1>User list</h1>
        <h3><a href="add.jsp">Add new</a></h3>
        <table border="1px" width="80%">
            <tr>
                <th>User_id</th>
                <th>Role_id</th>
                <th>User Name</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>ACTION</th>
            </tr>
            <c:forEach items="${requestScope.data}" var="c">
                <c:set var="user_id" value="${c.user_id}"/> 
                <tr>
                    <td>${c.user_id}</td>
                    <td>${c.role_id}</td>
                    <td>${c.username}</td>
                    <td>${c.full_name}</td>
                    <td>${c.email}</td>
                    <td>${c.phone}</td>
                    <td>
                        <a href="update?user_id=${c.user_id}">UPDATE</a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="doDelete('${user_id}')">DELETE</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </center>
</body>
</html>
