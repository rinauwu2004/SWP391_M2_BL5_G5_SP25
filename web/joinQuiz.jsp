<%-- 
    Document   : joinQuiz
    Created on : 2 May 2025, 14:48:07
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Join Quiz</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                background-color: #EBF3FF;
            }

            .card {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                width: 100%;
                max-width: 450px;
                padding: 40px;
            }

            h1 {
                text-align: center;
                font-size: 28px;
                font-weight: bold;
                color: #1A1A1A;
                margin-bottom: 16px;
            }

            .description {
                text-align: center;
                color: #4A4A4A;
                font-size: 16px;
                margin-bottom: 32px;
            }

            .input-field {
                width: 100%;
                text-align: center;
                letter-spacing: 8px;
                text-transform: uppercase;
                padding: 16px;
                font-size: 18px;
                border: 1px solid #E5E5E5;
                border-radius: 8px;
                margin-bottom: 24px;
                outline: none;
                color: #1A1A1A;
            }

            .input-field::placeholder {
                color: #BBBBBB;
                letter-spacing: normal;
                text-transform: none;
            }

            .join-button {
                width: 100%;
                padding: 16px;
                background-color: #5E5CFF;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: background-color 0.2s;
            }

            .join-button:hover {
                background-color: #4A48E0;
            }

            .arrow-icon {
                margin-left: 8px;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>Join Quiz</h1>
            <p class="description">Enter the quiz code provided by your teacher</p>

            <c:if test="${not empty errorMessage}">
                <p style="margin-top: 5px; color:red; text-align: center; font-size: 14px;">${errorMessage}</p>
            </c:if>

            <form action="<%=request.getContextPath()%>/quiz/join" method="post">
                <input type="text" id="quizCode" name="quizCode" class="input-field" placeholder="Enter quiz code" required>

                <button type="submit" class="join-button">
                    Join Quiz
                    <span class="arrow-icon">→</span>
                </button>
            </form>
        </div>

        <script>
            document.getElementById('quizCode').addEventListener('input', function () {
                this.value = this.value.replace(/[^a-zA-Z0-9]/g, '');
            });
        </script>        
    </body>
</html>