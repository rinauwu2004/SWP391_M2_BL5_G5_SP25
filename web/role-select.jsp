<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuizOnline - Select Role</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <div class="floating-shapes">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
        
        <div class="role-container">
            <div class="logo">
                <h1>Quiz<span>Online</span></h1>
            </div>
            
            <h2>Select Your Role</h2>
            <p>You have multiple roles. Please select which role you want to login as:</p>
            
            <div class="role-list${fn:length(userRoles) == 2 ? ' role-list-two' : ''}">
                <c:forEach items="${userRoles}" var="role">
                    <form action="login" method="post">
                        <input type="hidden" name="userId" value="${userId}">
                        <input type="hidden" name="roleId" value="${role.role_id}">
                        <button type="submit" class="role-button">
                            <c:choose>
                                <c:when test="${role.role_name == 'Admin'}">
                                    <i class="fas fa-user-shield"></i>
                                </c:when>
                                <c:when test="${role.role_name == 'Subject Manager'}">
                                    <i class="fas fa-tasks"></i>
                                </c:when>
                                <c:when test="${role.role_name == 'Teacher'}">
                                    <i class="fas fa-chalkboard-teacher"></i>
                                </c:when>
                                <c:when test="${role.role_name == 'Student'}">
                                    <i class="fas fa-user-graduate"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-user"></i>
                                </c:otherwise>
                            </c:choose>
                            ${role.role_name}
                        </button>
                    </form>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
