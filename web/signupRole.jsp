<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Choose Your Role</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #ffffff;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                position: relative;
            }

            .back-button {
                position: absolute;
                top: 20px;
                left: 20px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #f3f4f6;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            .back-button:hover {
                background-color: #e5e7eb;
                transform: translateY(-2px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .back-button:active {
                transform: translateY(0);
            }

            .back-arrow {
                width: 10px;
                height: 10px;
                border: solid #4b5563;
                border-width: 0 2px 2px 0;
                transform: rotate(135deg);
                margin: 1px 0px 0px 3px;
            }

            .container {
                max-width: 1000px;
                width: 100%;
                padding: 0 20px;
            }

            h1 {
                font-size: 24px;
                font-weight: 600;
                color: #1f2937;
                text-align: center;
                margin-bottom: 40px;
            }

            .cards-container {
                display: flex;
                gap: 24px;
                justify-content: center;
                flex-wrap: wrap;
            }

            .card {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
                padding: 32px;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                width: 100%;
                max-width: 350px;
                transition: box-shadow 0.3s ease;
                text-decoration: none;
                color: inherit;
                transition: all 0.3s ease;
            }

            .card:hover {
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 2px 4px rgba(0, 0, 0, 0.06);
                transform: translateY(-2px);
            }

            .card:active {
                transform: translateY(0);
            }

            .icon-container {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 16px;
            }

            .teacher-icon {
                background-color: rgba(59, 130, 246, 0.1);
            }

            .student-icon {
                background-color: rgba(139, 92, 246, 0.1);
            }

            .icon-container img {
                width: 24px;
                height: 24px;
                object-fit: contain;
            }

            .card h2 {
                font-size: 20px;
                font-weight: 500;
                color: #1f2937;
                margin-bottom: 12px;
            }

            .card p {
                font-size: 14px;
                color: #4b5563;
                line-height: 1.5;
            }

            @media (max-width: 768px) {
                .cards-container {
                    flex-direction: column;
                    align-items: center;
                }
            }
        </style>
    </head>
    <body>
        <c:set var="purpose" value="${param.purpose}"/>
        <!-- Back Button -->
        <button class="back-button" onclick="window.history.back()">
            <div class="back-arrow"></div>
        </button>

        <div class="container">
            <h1>Choose your role</h1>
            <c:choose>
                <c:when test="${purpose == 'signup'}">
                    <div class="cards-container">
                        <!-- Teacher Card -->
                        <a class="card" href="<%=request.getContextPath()%>/signup?role=Teacher">
                            <div class="icon-container teacher-icon">
                                <img src="img/Teacher.png" alt="Teacher Icon">
                            </div>
                            <h2>Teacher</h2>
                            <p>Create and manage courses, interact with students, and share your knowledge with the world. Perfect for educators and experts looking to teach online.</p>
                        </a>
                        <!-- Student Card -->
                        <a class="card" href="<%=request.getContextPath()%>/signup?role=Student">
                            <div class="icon-container student-icon">
                                <img src="img/Student.png" alt="Student Icon">
                            </div>
                            <h2>Student</h2>
                            <p>Access courses, learn at your own pace, and connect with teachers and fellow students. Ideal for learners seeking quality education online.</p>
                        </a>
                    </div>
                </c:when>
                <c:when test="${purpose == 'complete-profile'}">
                    <div class="cards-container">
                        <!-- Teacher Card -->
                        <a class="card" href="<%=request.getContextPath()%>/complete-profile?role=Teacher">
                            <div class="icon-container teacher-icon">
                                <img src="img/Teacher.png" alt="Teacher Icon">
                            </div>
                            <h2>Teacher</h2>
                            <p>Create and manage courses, interact with students, and share your knowledge with the world. Perfect for educators and experts looking to teach online.</p>
                        </a>
                        <!-- Student Card -->
                        <a class="card" href="<%=request.getContextPath()%>/complete-profile?role=Student">
                            <div class="icon-container student-icon">
                                <img src="img/Student.png" alt="Student Icon">
                            </div>
                            <h2>Student</h2>
                            <p>Access courses, learn at your own pace, and connect with teachers and fellow students. Ideal for learners seeking quality education online.</p>
                        </a>
                    </div>
                </c:when>

            </c:choose>
        </div>
        <c:if test="${param.debug == 'true'}">
            <div style="margin-top: 20px; text-align: center; color: #6b7280; font-size: 12px;">
                Debug mode: ${pageContext.servletContext.serverInfo}
            </div>
        </c:if>
    </body>
</html>