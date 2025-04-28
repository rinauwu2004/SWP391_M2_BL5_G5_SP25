<%-- 
    Document   : listQuiz
    Created on : 29 Apr 2025, 02:34:04
    Author     : Rinaaaa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>List Quiz</h1>
        <c:if test="${not empty error}">
            <p style="margin-top: 5px; color:red; text-align: center; font-size: 14px;">${error}</p>
        </c:if>
    </body>
</html>
