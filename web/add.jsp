<%-- 
    Document   : Add
    Created on : 21-09-2026, 01:40:45
    Author     : trieuvy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Add new user</h1>
        <h3 style="color: red">${requestScope.error}</h3>
        <form action="add">
            Enter Role_ID:<input type="number" name="role_id"/><br/>
            Enter User Name:<input type="Text" name="username"/><br/>
            Enter Password:<input type="text" name="password_hash"/><br/>
            Enter Full Name:<input type="Text" name="full_name"/><br/>
            Enter Email:<input type="Text" name="email"/><br/>
            Enter Phone:<input type="text" name="phone"/><br/>
            <input type="submit" value="Save"/>
        </form>
    </body>
</html>
