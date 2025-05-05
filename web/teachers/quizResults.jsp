<%-- 
    Document   : quizResults
    Created on : Apr 29, 2025, 1:30:00 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${quiz.title} - Quiz Results</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
            }
            
            body {
                background-color: #f5f5f5;
                color: #333;
                line-height: 1.6;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            
            /* Header Styles */
            header {
                background-color: #fff;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 100;
            }
            
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
            }
            
            .logo {
                display: flex;
                align-items: center;
                font-weight: 700;
                font-size: 1.5rem;
                color: #4f46e5;
                text-decoration: none;
            }
            
            .logo-icon {
                margin-right: 8px;
                font-size: 1.8rem;
            }
            
            nav ul {
                display: flex;
                list-style: none;
            }
            
            nav ul li {
                margin-left: 25px;
            }
            
            nav ul li a {
                color: #4b5563;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }
            
            nav ul li a:hover {
                color: #4f46e5;
            }
            
            .auth-buttons {
                display: flex;
                align-items: center;
            }
            
            .user-greeting {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            
            .user-greeting a {
                color: #4b5563;
                text-decoration: none;
                font-weight: 500;
            }
            
            .btn {
                display: inline-block;
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: 500;
                text-align: center;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.3s;
            }
            
            .btn-sm {
                padding: 6px 12px;
                font-size: 0.875rem;
            }
            
            .btn-primary {
                background-color: #4f46e5;
                color: white;
                border: 1px solid #4f46e5;
            }
            
            .btn-primary:hover {
                background-color: #4338ca;
                border-color: #4338ca;
            }
            
            .btn-outline {
                background-color: transparent;
                color: #4f46e5;
                border: 1px solid #4f46e5;
                margin-right: 10px;
            }
            
            .btn-outline:hover {
                background-color: #4f46e5;
                color: white;
            }
            
            .btn-danger {
                background-color: #ef4444;
                color: white;
                border: 1px solid #ef4444;
            }
            
            .btn-danger:hover {
                background-color: #dc2626;
                border-color: #dc2626;
            }
            
            /* Quiz Results Styles */
            .quiz-results {
                padding: 40px 0;
            }
            
            .quiz-results-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 30px;
            }
            
            .quiz-results-title {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 10px;
            }
            
            .quiz-results-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 20px;
            }
            
            .quiz-results-meta span {
                display: flex;
                align-items: center;
                color: #6b7280;
                font-size: 0.875rem;
            }
            
            .quiz-results-meta i {
                margin-right: 5px;
            }
            
            .quiz-results-actions {
                display: flex;
                gap: 10px;
            }
            
            .status-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 500;
            }
            
            .status-active {
                background-color: #dcfce7;
                color: #166534;
            }
            
            .status-inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }
            
            .status-draft {
                background-color: #f3f4f6;
                color: #4b5563;
            }
            
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .stat-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                text-align: center;
            }
            
            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: #4f46e5;
                margin-bottom: 5px;
            }
            
            .stat-label {
                font-size: 0.875rem;
                color: #6b7280;
            }
            
            .charts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .chart-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
            }
            
            .chart-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
                text-align: center;
            }
            
            .chart-container {
                position: relative;
                height: 250px;
            }
            
            .attempts-table-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                margin-bottom: 30px;
            }
            
            .attempts-table-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
            }
            
            .attempts-table {
                width: 100%;
                border-collapse: collapse;
            }
            
            .attempts-table th,
            .attempts-table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #e5e7eb;
            }
            
            .attempts-table th {
                background-color: #f9fafb;
                font-weight: 600;
                color: #374151;
            }
            
            .attempts-table tr:hover {
                background-color: #f9fafb;
            }
            
            .attempts-table .status-completed {
                color: #166534;
                background-color: #dcfce7;
                padding: 4px 8px;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 500;
            }
            
            .attempts-table .status-in-progress {
                color: #9a3412;
                background-color: #ffedd5;
                padding: 4px 8px;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 500;
            }
            
            .score-cell {
                font-weight: 600;
            }
            
            .high-score {
                color: #166534;
            }
            
            .medium-score {
                color: #9a3412;
            }
            
            .low-score {
                color: #991b1b;
            }
            
            .empty-state {
                text-align: center;
                padding: 60px 0;
            }
            
            .empty-icon {
                font-size: 4rem;
                color: #d1d5db;
                margin-bottom: 20px;
            }
            
            .empty-title {
                font-size: 1.5rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 10px;
            }
            
            .empty-description {
                color: #6b7280;
                max-width: 500px;
                margin: 0 auto 20px;
            }
            
            /* Footer Styles */
            footer {
                background-color: #1f2937;
                color: #f9fafb;
                padding: 40px 0 20px;
            }
            
            .footer-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 40px;
                margin-bottom: 40px;
            }
            
            .footer-brand {
                grid-column: span 2;
            }
            
            .footer-brand .logo {
                color: #f9fafb;
                margin-bottom: 15px;
            }
            
            .footer-brand p {
                color: #d1d5db;
                max-width: 300px;
            }
            
            .footer-links h4 {
                font-size: 1.125rem;
                font-weight: 600;
                margin-bottom: 15px;
            }
            
            .footer-links ul {
                list-style: none;
            }
            
            .footer-links ul li {
                margin-bottom: 10px;
            }
            
            .footer-links ul li a {
                color: #d1d5db;
                text-decoration: none;
                transition: color 0.3s;
            }
            
            .footer-links ul li a:hover {
                color: #f9fafb;
            }
            
            .footer-social h4 {
                font-size: 1.125rem;
                font-weight: 600;
                margin-bottom: 15px;
            }
            
            .social-icons {
                display: flex;
                gap: 15px;
            }
            
            .social-icons a {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: #374151;
                color: #f9fafb;
                transition: all 0.3s;
            }
            
            .social-icons a:hover {
                background-color: #4f46e5;
                transform: translateY(-3px);
            }
            
            .footer-bottom {
                text-align: center;
                padding-top: 20px;
                border-top: 1px solid #374151;
                color: #9ca3af;
                font-size: 0.875rem;
            }
            
            /* Responsive Styles */
            @media (max-width: 768px) {
                .navbar {
                    flex-direction: column;
                    padding: 15px 0;
                }
                
                nav ul {
                    margin: 15px 0;
                }
                
                .quiz-results-header {
                    flex-direction: column;
                }
                
                .quiz-results-actions {
                    margin-top: 20px;
                }
                
                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
                
                .charts-grid {
                    grid-template-columns: 1fr;
                }
                
                .footer-grid {
                    grid-template-columns: 1fr;
                }
                
                .footer-brand {
                    grid-column: span 1;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation Bar -->
        <header>
            <div class="container">
                <div class="navbar">
                    <div class="logo">
                        <a href="<%=request.getContextPath()%>/teacher/home">
                            <span class="logo-icon"><i class="fas fa-puzzle-piece"></i></span>
                            <span class="logo-text">QuizMaster</span>
                        </a>
                    </div>
                    <nav>
                        <ul>
                            <li><a href="<%=request.getContextPath()%>/teacher/home">Home</a></li>
                            
                            
                        </ul>
                    </nav>
                    <div class="auth-buttons">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="user-greeting">
                                    <a href="<%=request.getContextPath()%>/user/view-profile">Hello, ${sessionScope.user.lastName} ${sessionScope.user.firstName}</a>
                                    <a href="<%=request.getContextPath()%>/signout" class="btn btn-outline btn-sm">Logout</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="<%=request.getContextPath()%>/signin" class="btn btn-outline">Sign In</a>
                                <a href="<%=request.getContextPath()%>/signup-role?purpose=signup" class="btn btn-primary">Sign Up</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </header>

        <!-- Quiz Results Content -->
        <section class="quiz-results">
            <div class="container">
                <div class="quiz-results-header">
                    <div>
                        <h1 class="quiz-results-title">${quiz.title} - Results</h1>
                        <div class="quiz-results-meta">
                            <span><i class="fas fa-clock"></i> ${quiz.timeLimit} minutes</span>
                            <span><i class="fas fa-question-circle"></i> ${questionCount} questions</span>
                            <span><i class="fas fa-users"></i> ${completedAttemptsCount + inProgressAttemptsCount} attempts</span>
                            <span><i class="fas fa-calendar-alt"></i> Created on <fmt:formatDate value="${quiz.createdAt}" pattern="MMM dd, yyyy" /></span>
                            <span>
                                <c:choose>
                                    <c:when test="${quiz.status eq 'active'}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:when test="${quiz.status eq 'inactive'}">
                                        <span class="status-badge status-inactive">Inactive</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-draft">Draft</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="quiz-results-actions">
                        <a href="<%=request.getContextPath()%>/quiz/view?id=${quiz.id}" class="btn btn-outline">
                            <i class="fas fa-eye"></i> View Quiz
                        </a>
                        <a href="<%=request.getContextPath()%>/quiz/edit?id=${quiz.id}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Quiz
                        </a>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty attempts}">
                        <!-- Empty State -->
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <h2 class="empty-title">No attempts yet</h2>
                            <p class="empty-description">
                                No students have attempted this quiz yet. Share the quiz code with your students to get started.
                            </p>
                            <div>
                                <strong>Quiz Code:</strong> ${quiz.code}
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Statistics Cards -->
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-value">${completedAttemptsCount}</div>
                                <div class="stat-label">Completed Attempts</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-value">${inProgressAttemptsCount}</div>
                                <div class="stat-label">In Progress</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-value"><fmt:formatNumber value="${averageScore * 100}" pattern="#0.0" />%</div>
                                <div class="stat-label">Average Score</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-value"><fmt:formatNumber value="${highestScore * 100}" pattern="#0.0" />%</div>
                                <div class="stat-label">Highest Score</div>
                            </div>
                        </div>

                        <!-- Charts -->
                        <div class="charts-grid">
                            <div class="chart-card">
                                <h3 class="chart-title">Attempt Status</h3>
                                <div class="chart-container">
                                    <canvas id="statusChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <h3 class="chart-title">Score Distribution</h3>
                                <div class="chart-container">
                                    <canvas id="scoreChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Attempts Table -->
                        <div class="attempts-table-card">
                            <h3 class="attempts-table-title">All Attempts</h3>
                            <div class="table-responsive">
                                <table class="attempts-table">
                                    <thead>
                                        <tr>
                                            <th>Student</th>
                                            <th>Started</th>
                                            <th>Submitted</th>
                                            <th>Duration</th>
                                            <th>Score</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="attempt" items="${attempts}">
                                            <tr>
                                                <td>${attempt.student.firstName} ${attempt.student.lastName}</td>
                                                <td><fmt:formatDate value="${attempt.startedTime}" pattern="MMM dd, yyyy HH:mm" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${attempt.submittedTime != null}">
                                                            <fmt:formatDate value="${attempt.submittedTime}" pattern="MMM dd, yyyy HH:mm" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${attempt.formattedDuration}</td>
                                                <td class="score-cell 
                                                    <c:choose>
                                                        <c:when test="${attempt.score >= 0.8}">high-score</c:when>
                                                        <c:when test="${attempt.score >= 0.6}">medium-score</c:when>
                                                        <c:when test="${attempt.score > 0}">low-score</c:when>
                                                    </c:choose>
                                                ">
                                                    <c:choose>
                                                        <c:when test="${attempt.submittedTime != null}">
                                                            ${attempt.scorePercentage}
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${attempt.status eq 'Completed'}">
                                                            <span class="status-completed">Completed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-in-progress">In Progress</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- Footer -->
        <footer>
            <div class="container">
                <div class="footer-grid">
                    <div class="footer-brand">
                        <div class="logo">
                            <span class="logo-icon"><i class="fas fa-puzzle-piece"></i></span>
                            <span class="logo-text">QuizMaster</span>
                        </div>
                        <p>Making learning fun and interactive through engaging quizzes.</p>
                    </div>
                    <div class="footer-links">
                        <h4>Quick Links</h4>
                        <ul>
                            <li><a href="<%=request.getContextPath()%>/home">Home</a></li>
                            <li><a href="<%=request.getContextPath()%>/about.jsp">About Us</a></li>
                            <li><a href="<%=request.getContextPath()%>/categories.jsp">Categories</a></li>
                            <li><a href="<%=request.getContextPath()%>/contact.jsp">Contact</a></li>
                        </ul>
                    </div>
                    <div class="footer-links">
                        <h4>Teacher Resources</h4>
                        <ul>
                            <li><a href="<%=request.getContextPath()%>/teacher/home">Dashboard</a></li>
                            <li><a href="<%=request.getContextPath()%>/quiz/create">Create Quiz</a></li>
                            <li><a href="<%=request.getContextPath()%>/help.jsp">Help Center</a></li>
                        </ul>
                    </div>
                    <div class="footer-social">
                        <h4>Follow Us</h4>
                        <div class="social-icons">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; <c:set var="now" value="<%= new java.util.Date() %>" />
                        <fmt:formatDate value="${now}" pattern="yyyy" /> QuizMaster. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <!-- Charts JavaScript -->
        <script>
            // Only initialize charts if there are attempts
            <c:if test="${not empty attempts}">
                // Count completed and in-progress attempts
                const completedCount = ${completedAttemptsCount};
                const inProgressCount = ${inProgressAttemptsCount};
                
                // Create status chart
                const statusCtx = document.getElementById('statusChart').getContext('2d');
                const statusChart = new Chart(statusCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Completed', 'In Progress'],
                        datasets: [{
                            data: [completedCount, inProgressCount],
                            backgroundColor: ['#4f46e5', '#f97316'],
                            borderColor: ['#4338ca', '#ea580c'],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
                
                // Create score distribution chart
                // We'll create a simple distribution of scores in ranges
                const scoreRanges = {
                    '90-100%': 0,
                    '80-89%': 0,
                    '70-79%': 0,
                    '60-69%': 0,
                    '50-59%': 0,
                    'Below 50%': 0
                };
                
                <c:forEach var="attempt" items="${attempts}">
                    <c:if test="${attempt.submittedTime != null}">
                        const score = ${attempt.score} * 100;
                        if (score >= 90) {
                            scoreRanges['90-100%']++;
                        } else if (score >= 80) {
                            scoreRanges['80-89%']++;
                        } else if (score >= 70) {
                            scoreRanges['70-79%']++;
                        } else if (score >= 60) {
                            scoreRanges['60-69%']++;
                        } else if (score >= 50) {
                            scoreRanges['50-59%']++;
                        } else {
                            scoreRanges['Below 50%']++;
                        }
                    </c:if>
                </c:forEach>
                
                const scoreCtx = document.getElementById('scoreChart').getContext('2d');
                const scoreChart = new Chart(scoreCtx, {
                    type: 'bar',
                    data: {
                        labels: Object.keys(scoreRanges),
                        datasets: [{
                            label: 'Number of Students',
                            data: Object.values(scoreRanges),
                            backgroundColor: '#4f46e5',
                            borderColor: '#4338ca',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1
                                }
                            }
                        }
                    }
                });
            </c:if>
        </script>
    </body>
</html>
