<%-- 
    Document   : doQuiz
    Created on : 2 May 2025, 15:18:24
    Author     : Rinaaaa
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quiz</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #ffffff;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            /* Header Styles */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #e5e7eb;
                flex-wrap: wrap;
            }

            .quiz-info {
                display: flex;
                gap: 20px;
                flex-wrap: wrap;
            }

            .quiz-info-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .label {
                color: #4b5563;
                font-weight: 500;
            }

            .value {
                font-weight: bold;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .timer {
                background-color: #fee2e2;
                color: #dc2626;
                font-weight: bold;
                padding: 5px 15px;
                border-radius: 4px;
            }

            .timestamp {
                color: #4b5563;
            }

            .main-content {
                display: flex;
                gap: 30px;
                margin-top: 30px;
            }

            .sidebar {
                width: 300px;
            }

            .question-counter {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
            }

            .question-counter span {
                color: #2563eb;
            }

            .question-nav {
                display: grid;
                grid-template-columns: repeat(5, 1fr);
                gap: 8px;
                margin-bottom: 30px;
            }

            .question-btn {
                height: 48px;
                width: 48px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                border: none;
                font-size: 16px;
            }

            .question-btn.current {
                background-color: #2563eb;
                color: white;
                border: 2px solid #1d4ed8;
            }

            .question-btn.answered {
                background-color: #d1fae5;
                color: #374151;
                border: 1px solid #a7f3d0;
            }

            .question-btn.unanswered {
                background-color: #f3f4f6;
                color: #4b5563;
                border: 1px solid #e5e7eb;
            }

            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .next-btn {
                padding: 12px;
                background-color: #f3f4f6;
                color: #4b5563;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
            }

            .submit-btn {
                padding: 12px;
                background-color: #059669;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
            }

            .question-content {
                flex: 1;
                background-color: #fee2e2;
                border-radius: 8px;
                padding: 24px;
                max-height: fit-content;
            }

            .question-title {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 16px;
            }

            .question-text {
                font-size: 18px;
                margin-bottom: 24px;
            }

            .answer-options {
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            .answer-option {
                display: flex;
                align-items: center;
                gap: 12px;
                background-color: white;
                padding: 16px;
                border-radius: 6px;
            }

            .answer-option input[type="checkbox"] {
                width: 20px;
                height: 20px;
            }

            .answer-option label {
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                justify-content: center;
                align-items: center;
            }

            .modal-content {
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                width: 400px;
                text-align: center;
            }

            .modal-title {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 20px;
            }

            .modal-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 30px;
            }

            .modal-submit {
                padding: 10px 20px;
                background-color: #059669;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
            }

            .modal-cancel {
                padding: 10px 20px;
                background-color: white;
                color: #4b5563;
                border: 1px solid #e5e7eb;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
            }

            @media (max-width: 768px) {
                header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }

                .quiz-info, .user-info {
                    flex-direction: column;
                    gap: 10px;
                    width: 100%;
                }

                .main-content {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <header>
                <div class="quiz-info">
                    <div class="quiz-info-item">
                        <span class="label">Quiz Name:</span>
                        <span class="value">${quiz.title}</span>
                    </div>
                    <div class="quiz-info-item">
                        <span class="label">Code:</span>
                        <span class="value">${quiz.code}</span>
                    </div>
                    <div class="quiz-info-item">
                        <span class="label">Duration:</span>
                        <span class="value">${quiz.timeLimit} minutes</span>
                    </div>
                </div>
                <div class="user-info">
                    <span class="value">${user.firstName} ${user.lastName}</span>
                    <span class="timer" id="timer"></span>
                    <c:set var="currentTime" value="<%= new java.util.Date() %>" />
                    <span class="timestamp">
                        <fmt:formatDate value="${currentTime}" pattern="MMM dd, yyyy HH:mm:ss" />
                    </span>
                </div>
            </header>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Sidebar with Question Navigation -->
                <div class="sidebar">
                    <div class="question-counter">
                        Question <span id="currentQuestionNumber">${questionNumber}</span>/${totalQuestions}
                    </div>

                    <div class="question-nav">
                        <c:forEach var="i" begin="1" end="${totalQuestions}">
                            <button class="question-btn ${i == questionNumber ? 'current' : 'unanswered'}" 
                                    onclick="navigateToQuestion(${i})" ${i == questionNumber ? 'disabled' : ''}
                                    >${i}</button>
                        </c:forEach>
                    </div>

                    <div class="action-buttons">
                        <button class="next-btn" onclick="nextQuestion()">Next Question</button>
                        <button class="submit-btn" onclick="showSubmitConfirmation()">Submit Quiz</button>
                    </div>
                </div>

                <!-- Question Content -->
                <div class="question-content">
                    <h3 class="question-title">Question ${questionNumber}</h3>
                    <p class="question-text">${currentQuestion.content}</p>

                    <form id="questionForm" data-question-id="${currentQuestion.id}">
                        <div class="answer-options">
                            <c:forEach var="option" items="${options}" varStatus="status">
                                <div class="answer-option">
                                    <input 
                                        type="checkbox" 
                                        id="option${status.index}" 
                                        name="answer" 
                                        value="${option.id}"
                                        <c:if test="${selectedAnswers.contains(option.id)}">checked</c:if>
                                            >
                                        <label for="option${status.index}">${option.content}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Add this to your doQuiz.jsp file, replacing the existing submit modal -->
            <div class="modal" id="submitModal">
                <div class="modal-content">
                    <h3 class="modal-title">Are you sure you want to submit this quiz?</h3>
                    <div class="modal-buttons">
                        <form method="POST" action="${pageContext.request.contextPath}/quiz/do">
                            <input type="hidden" name="action" value="submitQuiz">
                            <button type="submit" class="modal-submit">Submit</button>
                            <button type="button" class="modal-cancel" onclick="hideSubmitConfirmation()">Cancel</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            window.remainingSeconds = ${remainingSeconds};
            window.quizTimeLimit = ${quiz.timeLimit};
            window.totalQuestions = ${totalQuestions};
        </script>
        <script src="${pageContext.request.contextPath}/js/doQuiz.js"></script>
    </body>
</html>
