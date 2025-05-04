<%-- 
    Document   : quizResult
    Created on : 4 May 2025, 15:05:09
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
        <title>Quiz Result</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f9fafb;
            }

            .container {
                max-width: 800px;
                margin: 40px auto;
                padding: 20px;
            }

            .result-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 30px;
                margin-bottom: 30px;
            }

            .result-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .result-title {
                font-size: 28px;
                font-weight: bold;
                color: #111827;
                margin-bottom: 10px;
            }

            .quiz-name {
                font-size: 18px;
                color: #4b5563;
                margin-bottom: 5px;
            }

            .result-score {
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 30px 0;
            }

            .score-circle {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                font-weight: bold;
                color: white;
            }

            .score-value {
                font-size: 36px;
            }

            .score-label {
                font-size: 16px;
            }

            .result-details {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 30px;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                padding: 15px;
                background-color: #f3f4f6;
                border-radius: 6px;
            }

            .detail-label {
                font-size: 14px;
                color: #6b7280;
                margin-bottom: 5px;
            }

            .detail-value {
                font-size: 18px;
                font-weight: 600;
                color: #111827;
            }

            .action-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                padding: 12px 24px;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                text-align: center;
                transition: all 0.2s;
            }

            .btn-primary {
                background-color: #2563eb;
                color: white;
                border: none;
            }

            .btn-primary:hover {
                background-color: #1d4ed8;
            }

            .btn-secondary {
                background-color: white;
                color: #4b5563;
                border: 1px solid #e5e7eb;
            }

            .btn-secondary:hover {
                background-color: #f9fafb;
            }

            .pass-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 4px;
                font-weight: 500;
                font-size: 14px;
                margin-top: 10px;
            }

            .pass {
                background-color: #d1fae5;
                color: #065f46;
            }

            .fail {
                background-color: #fee2e2;
                color: #b91c1c;
            }

            @media (max-width: 640px) {
                .result-details {
                    grid-template-columns: 1fr;
                }

                .action-buttons {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="result-card">
                <div class="result-header">
                    <h1 class="result-title">Quiz Result</h1>
                    <p class="quiz-name">${attempt.quiz.title}</p>
                    <p class="quiz-code">Code: ${attempt.quiz.code}</p>
                </div>

                <div class="result-score">
                    <div class="score-circle" style="background-color: ${attempt.score >= 50 ? '#059669' : '#dc2626'}">
                        <span class="score-value"><fmt:formatNumber value="${attempt.score}" pattern="#,##0.0" />%</span>
                        <span class="score-label">Score</span>
                    </div>
                </div>

                <div class="result-details">
                    <div class="detail-item">
                        <span class="detail-label">Student</span>
                        <span class="detail-value">${attempt.student.firstName} ${attempt.student.lastName}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Status</span>
                        <span class="detail-value">
                            <span class="pass-badge ${attempt.score >= 50 ? 'pass' : 'fail'}">
                                ${attempt.score >= 50 ? 'PASSED' : 'FAILED'}
                            </span>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Started</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${attempt.startedTime}" pattern="MMM dd, yyyy HH:mm:ss" />
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Submitted</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${attempt.submittedTime}" pattern="MMM dd, yyyy HH:mm:ss" />
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Time Spent</span>
                        <span class="detail-value">${timeSpent}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Questions</span>
                        <span class="detail-value">${attempt.quiz.questions.size()}</span>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/quiz/review?attemptId=${attempt.id}" class="btn btn-primary">Review Answers</a>
                    <a href="${pageContext.request.contextPath}/quiz/join" class="btn btn-secondary">Take Another Quiz</a>
                </div>
            </div>
        </div>
    </body>
</html>
