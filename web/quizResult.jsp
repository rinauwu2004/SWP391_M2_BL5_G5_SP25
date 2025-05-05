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
        <title>Quiz Result - ${attempt.quiz.title}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f0f2f5;
                color: #333;
            }

            .container {
                max-width: 900px;
                margin: 40px auto;
                padding: 20px;
            }

            .result-card {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
                overflow: hidden;
                margin-bottom: 30px;
                transition: transform 0.3s ease;
            }

            .result-card:hover {
                transform: translateY(-5px);
            }

            .result-header {
                background: linear-gradient(135deg, #4f46e5, #7c3aed);
                color: white;
                padding: 30px;
                text-align: center;
                position: relative;
            }

            .result-title {
                font-size: 32px;
                font-weight: bold;
                margin-bottom: 10px;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            }

            .quiz-name {
                font-size: 20px;
                opacity: 0.9;
                margin-bottom: 5px;
            }

            .quiz-code {
                font-size: 16px;
                opacity: 0.8;
                background-color: rgba(255, 255, 255, 0.2);
                padding: 5px 10px;
                border-radius: 20px;
                display: inline-block;
                margin-top: 10px;
            }

            .result-body {
                padding: 30px;
            }

            .result-score {
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 20px 0 40px;
            }

            .score-circle {
                width: 180px;
                height: 180px;
                border-radius: 50%;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                font-weight: bold;
                color: white;
                position: relative;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
                border: 6px solid white;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .score-circle:hover {
                transform: scale(1.05);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            }

            .score-value {
                font-size: 42px;
                line-height: 1;
                margin-bottom: 5px;
            }

            .score-label {
                font-size: 18px;
                opacity: 0.9;
            }

            .score-fraction {
                font-size: 16px;
                margin-top: 5px;
                opacity: 0.8;
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
                padding: 20px;
                background-color: #f8fafc;
                border-radius: 10px;
                border-left: 4px solid #4f46e5;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .detail-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            }

            .detail-label {
                font-size: 14px;
                color: #6b7280;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
            }

            .detail-label i {
                margin-right: 8px;
                color: #4f46e5;
            }

            .detail-value {
                font-size: 20px;
                font-weight: 600;
                color: #111827;
            }

            .action-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 40px;
            }

            .btn {
                padding: 14px 28px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                text-decoration: none;
                text-align: center;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .btn i {
                margin-right: 8px;
            }

            .btn-primary {
                background-color: #4f46e5;
                color: white;
                border: none;
                box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            }

            .btn-primary:hover {
                background-color: #4338ca;
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(79, 70, 229, 0.4);
            }

            .btn-secondary {
                background-color: white;
                color: #4b5563;
                border: 2px solid #e5e7eb;
            }

            .btn-secondary:hover {
                background-color: #f9fafb;
                border-color: #d1d5db;
                transform: translateY(-2px);
            }

            .btn-success {
                background-color: #10b981;
                color: white;
                border: none;
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            }

            .btn-success:hover {
                background-color: #059669;
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4);
            }

            .pass-badge {
                display: inline-block;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 16px;
            }

            .pass {
                background-color: #d1fae5;
                color: #065f46;
            }

            .fail {
                background-color: #fee2e2;
                color: #b91c1c;
            }

            .performance-stats {
                background-color: #f8fafc;
                border-radius: 10px;
                padding: 20px;
                margin-top: 30px;
                border-top: 1px solid #e5e7eb;
            }

            .stats-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #4b5563;
                display: flex;
                align-items: center;
            }

            .stats-title i {
                margin-right: 8px;
                color: #4f46e5;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
            }

            .stat-item {
                background-color: white;
                padding: 15px;
                border-radius: 8px;
                text-align: center;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            }

            .stat-value {
                font-size: 24px;
                font-weight: 700;
                color: #4f46e5;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 14px;
                color: #6b7280;
            }

            .confetti {
                position: absolute;
                width: 10px;
                height: 10px;
                background-color: #f00;
                border-radius: 50%;
                animation: confetti-fall 5s ease-in-out infinite;
            }

            @keyframes confetti-fall {
                0% {
                    transform: translateY(-100px) rotate(0deg);
                    opacity: 1;
                }
                100% {
                    transform: translateY(500px) rotate(720deg);
                    opacity: 0;
                }
            }

            @media (max-width: 768px) {
                .result-details {
                    grid-template-columns: 1fr;
                }

                .stats-grid {
                    grid-template-columns: 1fr;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
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
                    <p class="quiz-code"><i class="fas fa-hashtag"></i> ${attempt.quiz.code}</p>

                    <c:if test="${attempt.score >= 70}">
                        <script>
                            // Add confetti effect for high scores
                            document.addEventListener('DOMContentLoaded', function () {
                                const header = document.querySelector('.result-header');
                                const colors = ['#ff0000', '#00ff00', '#0000ff', '#ffff00', '#ff00ff', '#00ffff'];

                                for (let i = 0; i < 50; i++) {
                                    const confetti = document.createElement('div');
                                    confetti.classList.add('confetti');
                                    confetti.style.left = Math.random() * 100 + '%';
                                    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                                    confetti.style.width = (Math.random() * 8 + 5) + 'px';
                                    confetti.style.height = (Math.random() * 8 + 5) + 'px';
                                    confetti.style.animationDelay = Math.random() * 5 + 's';
                                    confetti.style.animationDuration = (Math.random() * 3 + 3) + 's';
                                    header.appendChild(confetti);
                                }
                            });
                        </script>
                    </c:if>
                </div>

                <div class="result-body">
                    <div class="result-score">
                        <div class="score-circle" style="background: ${attempt.score >= 70 ? 'linear-gradient(135deg, #10b981, #059669)' : attempt.score >= 50 ? 'linear-gradient(135deg, #f59e0b, #d97706)' : 'linear-gradient(135deg, #ef4444, #b91c1c)'}">
                            <span class="score-value"><fmt:formatNumber value="${attempt.score}" pattern="#,##0.0" />%</span>
                            <span class="score-label">${attempt.score >= 70 ? 'Excellent!' : attempt.score >= 50 ? 'Good Job!' : 'Try Again'}</span>
                            <span class="score-fraction">${correctAnswers}/${totalQuestions} correct</span>
                        </div>
                    </div>

                    <div class="result-details">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-user-graduate"></i> Student</span>
                            <span class="detail-value">${attempt.student.firstName} ${attempt.student.lastName}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-check-circle"></i> Status</span>
                            <span class="detail-value">
                                <span class="pass-badge ${attempt.score >= 50 ? 'pass' : 'fail'}">
                                    <i class="fas ${attempt.score >= 50 ? 'fa-trophy' : 'fa-times-circle'}"></i>
                                    ${attempt.score >= 50 ? 'PASSED' : 'FAILED'}
                                </span>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-play-circle"></i> Started</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${attempt.startedTime}" pattern="MMM dd, yyyy HH:mm:ss" />
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-flag-checkered"></i> Submitted</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${attempt.submittedTime}" pattern="MMM dd, yyyy HH:mm:ss" />
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-stopwatch"></i> Time Spent</span>
                            <span class="detail-value">${timeSpent}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-question-circle"></i> Questions</span>
                            <span class="detail-value">${attempt.quiz.questions.size()}</span>
                        </div>
                    </div>

                    <div class="performance-stats">
                        <h3 class="stats-title"><i class="fas fa-chart-line"></i> Performance Statistics</h3>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-value">${correctAnswers}</div>
                                <div class="stat-label">Correct Answers</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">${totalQuestions - correctAnswers}</div>
                                <div class="stat-label">Incorrect Answers</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value"><fmt:formatNumber value="${(correctAnswers / totalQuestions) * 100}" pattern="#,##0.0" />%</div>
                                <div class="stat-label">Accuracy</div>
                            </div>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/quiz/review?attemptId=${attempt.id}" class="btn btn-primary">
                            <i class="fas fa-search"></i> Review Answers
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz/join" class="btn btn-secondary">
                            <i class="fas fa-redo"></i> Take Another Quiz
                        </a>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-success">
                            <i class="fas fa-home"></i> Back to Homepage
                        </a>
                    </div>
                </div>
            </div>

            <c:if test="${attempt.score >= 70}">
                <div class="result-card">
                    <div class="result-body">
                        <h3 class="stats-title"><i class="fas fa-award"></i> Achievement Unlocked!</h3>
                        <p style="text-align: center; padding: 20px;">
                            <i class="fas fa-medal" style="font-size: 48px; color: gold; display: block; margin-bottom: 15px;"></i>
                            <span style="font-size: 24px; font-weight: bold; color: #4f46e5;">High Score Master</span>
                            <br>
                            <span style="color: #6b7280; margin-top: 10px; display: block;">
                                You've achieved an excellent score on this quiz! Keep up the great work!
                            </span>
                        </p>
                    </div>
                </div>
            </c:if>
        </div>
    </body>
</html>
