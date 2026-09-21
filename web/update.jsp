<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
</head>
<body>
    <h1>Update a user</h1>

    <c:set var="c" value="${requestScope.user}"/>

    <form action="update" method="post">
        Enter User_ID:<input type="number" readonly name="user_id" value="${c.user_id}"/><br/>
        Enter Role_ID:<input type="number" name="role_id" value="${c.role_id}"/><br/>
        Enter User Name:<input type="text" name="username" value="${c.username}"/><br/>
        Enter Full Name:<input type="text" name="full_name" value="${c.full_name}"/><br/>
        Enter Email:<input type="text" name="email" value="${c.email}"/><br/>
        Enter Phone:<input type="text" name="phone" value="${c.phone}"/><br/>
        <input type="submit" value="UPDATE"/>
    </form>
</body>
</html>