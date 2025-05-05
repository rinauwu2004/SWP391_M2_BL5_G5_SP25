<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Quiz History | QuizMaster</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4f46e5;
                --primary-hover: #4338ca;
                --success-color: #10b981;
                --success-bg: #d1fae5;
                --danger-color: #ef4444;
                --danger-bg: #fee2e2;
                --warning-color: #f59e0b;
                --light-bg: #f9fafb;
                --info-color: #0ea5e9;
                --info-bg: #e0f2fe;
                --card-border: #e5e7eb;
                --text-primary: #111827;
                --text-secondary: #4b5563;
                --text-muted: #6b7280;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
                --radius-sm: 0.375rem;
                --radius-md: 0.5rem;
                --radius-lg: 0.75rem;
                --radius-full: 9999px;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--light-bg);
                color: var(--text-primary);
                line-height: 1.6;
            }

            .page-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem 1rem;
            }

            .page-header {
                position: relative;
                margin-bottom: 2.5rem;
                padding-bottom: 1.5rem;
                border-bottom: 1px solid var(--card-border);
            }

            .page-title {
                font-size: 2.25rem;
                font-weight: 700;
                color: var(--text-primary);
                margin-bottom: 0.5rem;
                background: linear-gradient(to right, var(--primary-color), #818cf8);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                display: inline-block;
            }

            .page-subtitle {
                font-size: 1.1rem;
                color: var(--text-secondary);
                max-width: 600px;
            }

            .back-button {
                position: absolute;
                top: 0;
                right: 0;
                display: flex;
                align-items: center;
                padding: 0.5rem 1rem;
                background-color: white;
                border: 1px solid var(--card-border);
                border-radius: var(--radius-md);
                color: var(--text-secondary);
                font-weight: 500;
                font-size: 0.875rem;
                transition: all 0.2s ease;
                box-shadow: var(--shadow-sm);
                text-decoration: none;
            }

            .back-button:hover {
                background-color: var(--light-bg);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
                color: var(--primary-color);
            }

            .back-button i {
                margin-right: 0.5rem;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2.5rem;
            }

            .stat-card {
                background-color: white;
                border-radius: var(--radius-lg);
                padding: 1.5rem;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--card-border);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-md);
                border-color: #d1d5db;
            }

            .stat-card::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: linear-gradient(to right, var(--primary-color), #818cf8);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .stat-card:hover::after {
                opacity: 1;
            }

            .stat-card.total-card::after {
                background: linear-gradient(to right, var(--primary-color), #818cf8);
            }

            .stat-card.attempts-card::after {
                background: linear-gradient(to right, var(--info-color), #38bdf8);
            }

            .stat-card.passed-card::after {
                background: linear-gradient(to right, var(--success-color), #34d399);
            }

            .stat-card.failed-card::after {
                background: linear-gradient(to right, var(--danger-color), #f87171);
            }

            .stat-card.average-card::after {
                background: linear-gradient(to right, var(--warning-color), #fbbf24);
            }

            .stat-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .stat-info h3 {
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--text-muted);
                margin-bottom: 0.5rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .stat-info .value {
                font-size: 2.25rem;
                font-weight: 700;
                color: var(--text-primary);
                line-height: 1;
            }

            .stat-icon {
                width: 48px;
                height: 48px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: var(--radius-full);
                font-size: 1.25rem;
            }

            .total-card .stat-icon {
                background-color: rgba(79, 70, 229, 0.1);
                color: var(--primary-color);
            }

            .attempts-card .stat-icon {
                background-color: rgba(14, 165, 233, 0.1);
                color: var(--info-color);
            }

            .passed-card .stat-icon {
                background-color: rgba(16, 185, 129, 0.1);
                color: var(--success-color);
            }

            .failed-card .stat-icon {
                background-color: rgba(239, 68, 68, 0.1);
                color: var(--danger-color);
            }

            .average-card .stat-icon {
                background-color: rgba(245, 158, 11, 0.1);
                color: var(--warning-color);
            }

            .history-card {
                background-color: white;
                border-radius: var(--radius-lg);
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--card-border);
                overflow: hidden;
                margin-bottom: 2rem;
            }

            .history-header {
                padding: 1.5rem;
                border-bottom: 1px solid var(--card-border);
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .history-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--text-primary);
                margin: 0;
            }

            .search-form {
                display: flex;
                max-width: 400px;
                width: 100%;
            }

            .search-input {
                flex: 1;
                padding: 0.625rem 1rem;
                border: 1px solid var(--card-border);
                border-radius: var(--radius-md) 0 0 var(--radius-md);
                font-size: 0.875rem;
                transition: border-color 0.2s ease;
            }

            .search-input:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
            }

            .search-button {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 0.625rem 1rem;
                border-radius: 0 var(--radius-md) var(--radius-md) 0;
                font-weight: 500;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                transition: background-color 0.2s ease;
            }

            .search-button:hover {
                background-color: var(--primary-hover);
            }

            .search-button i {
                margin-right: 0.5rem;
            }

            .table-container {
                overflow-x: auto;
                padding: 0 1.5rem;
            }

            .history-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
            }

            .history-table th {
                background-color: var(--light-bg);
                color: var(--text-secondary);
                font-weight: 500;
                font-size: 0.875rem;
                text-align: left;
                padding: 1rem;
                border-bottom: 1px solid var(--card-border);
                position: sticky;
                top: 0;
            }

            .history-table td {
                padding: 1rem;
                border-bottom: 1px solid var(--card-border);
                color: var(--text-primary);
                font-size: 0.875rem;
                vertical-align: middle;
            }

            .history-table tr:last-child td {
                border-bottom: none;
            }

            .history-table tr:hover td {
                background-color: rgba(249, 250, 251, 0.5);
            }

            .pass-badge {
                background-color: var(--success-bg);
                color: var(--success-color);
                padding: 0.25rem 0.75rem;
                border-radius: var(--radius-full);
                font-weight: 500;
                font-size: 0.75rem;
                display: inline-block;
            }

            .fail-badge {
                background-color: var(--danger-bg);
                color: var(--danger-color);
                padding: 0.25rem 0.75rem;
                border-radius: var(--radius-full);
                font-weight: 500;
                font-size: 0.75rem;
                display: inline-block;
            }

            .view-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 32px;
                height: 32px;
                border-radius: var(--radius-full);
                color: var(--primary-color);
                background-color: rgba(79, 70, 229, 0.1);
                transition: all 0.2s ease;
            }

            .view-btn:hover {
                background-color: var(--primary-color);
                color: white;
                transform: scale(1.1);
            }

            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1.5rem;
                border-top: 1px solid var(--card-border);
                flex-wrap: wrap;
                gap: 1rem;
            }

            .pagination-info {
                color: var(--text-muted);
                font-size: 0.875rem;
            }

            .pagination {
                display: flex;
                list-style: none;
                padding: 0;
                margin: 0;
                gap: 0.25rem;
            }

            .page-item .page-link {
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 36px;
                height: 36px;
                padding: 0 0.75rem;
                border-radius: var(--radius-md);
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--text-secondary);
                background-color: white;
                border: 1px solid var(--card-border);
                transition: all 0.2s ease;
            }

            .page-item .page-link:hover {
                background-color: var(--light-bg);
                color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .page-item.active .page-link {
                background-color: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
            }

            .page-item.disabled .page-link {
                color: #d1d5db;
                pointer-events: none;
                background-color: white;
                border-color: var(--card-border);
            }

            .empty-state {
                padding: 3rem 1.5rem;
                text-align: center;
            }

            .empty-icon {
                font-size: 3rem;
                color: #d1d5db;
                margin-bottom: 1rem;
            }

            .empty-message {
                font-size: 1rem;
                color: var(--text-secondary);
                margin-bottom: 1.5rem;
            }

            @media (max-width: 768px) {
                .page-title {
                    font-size: 1.75rem;
                }

                .history-header {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .search-form {
                    max-width: 100%;
                }

                .pagination-container {
                    flex-direction: column;
                    align-items: flex-start;
                }
            }

            /* Animation for cards */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .stat-card {
                animation: fadeInUp 0.5s ease forwards;
            }

            .stat-card:nth-child(1) {
                animation-delay: 0.1s;
            }

            .stat-card:nth-child(2) {
                animation-delay: 0.2s;
            }

            .stat-card:nth-child(3) {
                animation-delay: 0.3s;
            }

            .stat-card:nth-child(4) {
                animation-delay: 0.4s;
            }

            .stat-card:nth-child(5) {
                animation-delay: 0.5s;
            }

            /* Pulse animation for badges */
            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
                100% {
                    transform: scale(1);
                }
            }

            .pass-badge, .fail-badge {
                animation: pulse 2s infinite;
            }
        </style>
    </head>
    <body>
        <div class="page-container">
            <div class="page-header">
                <h1 class="page-title">My Quiz History</h1>
                <p class="page-subtitle">Track your quiz performance and progress over time to improve your learning journey</p>
                <a href="javascript:history.back()" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>

            <!-- Summary Cards -->
            <div class="stats-grid">
                <!-- Total Quizzes Card -->
                <div class="stat-card total-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Total Quizzes</h3>
                            <div class="value">${totalQuizzes}</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Attempts Card -->
                <div class="stat-card attempts-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Total Attempts</h3>
                            <div class="value">${totalAttempts}</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-redo-alt"></i>
                        </div>
                    </div>
                </div>

                <!-- Passed Card -->
                <div class="stat-card passed-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Passed</h3>
                            <div class="value">${passedCount}</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                </div>

                <!-- Failed Card -->
                <div class="stat-card failed-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Failed</h3>
                            <div class="value">${failedCount}</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-times-circle"></i>
                        </div>
                    </div>
                </div>

                <!-- Average Score Card -->
                <div class="stat-card average-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h3>Average Score</h3>
                            <div class="value">${averageScore}%</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quiz History Table -->
            <div class="history-card">
                <div class="history-header">
                    <h2 class="history-title">Quiz History</h2>

                    <!-- Search Form -->
                    <form action="<%=request.getContextPath()%>/quiz/history" method="get" class="search-form">
                        <input type="text" name="searchQuizId" value="${searchQuizId}" 
                               class="search-input" placeholder="Search by quiz code...">
                        <button type="submit" class="search-button">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </form>
                </div>

                <div class="table-container">
                    <c:choose>
                        <c:when test="${not empty quizAttempts}">
                            <table class="history-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Quiz Code</th>
                                        <th>Attempt</th>
                                        <th>Started Time</th>
                                        <th>Submitted Time</th>
                                        <th>Score</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${quizAttempts}" var="attempt" varStatus="loop">
                                        <tr>
                                            <td>${(currentPage-1) * 10 + loop.index + 1}</td>
                                            <td><strong>${attempt.quiz.code}</strong></td>
                                            <td>${attemptNumbers[attempt.id]}</td>
                                            <td>
                                                <fmt:formatDate value="${attempt.startedTime}" 
                                                                pattern="yyyy-MM-dd HH:mm:ss" />
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${attempt.submittedTime}" 
                                                                pattern="yyyy-MM-dd HH:mm:ss" />
                                            </td>
                                            <td><strong>${attempt.score}%</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${attempt.score >= 50}">
                                                        <span class="pass-badge">Pass</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="fail-badge">Fail</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="<%=request.getContextPath()%>/quiz/attempt-detail?id=${attempt.id}" class="view-btn" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-clipboard-list"></i>
                                </div>
                                <p class="empty-message">No quiz attempts found. Start taking quizzes to see your history here.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 0}">
                    <div class="pagination-container">
                        <p class="pagination-info">
                            Showing ${(currentPage-1) * 10 + 1} to 
                            <c:set var="endIndex" value="${currentPage * 10}" />
                            <c:if test="${endIndex > totalAttempts}">
                                <c:set var="endIndex" value="${totalAttempts}" />
                            </c:if>
                            ${endIndex} of ${totalAttempts} entries
                        </p>

                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="<%=request.getContextPath()%>/quiz/history?page=${currentPage - 1}${searchQuizId != null ? '&searchQuizId='.concat(searchQuizId) : ''}" aria-label="Previous">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${currentPage == i}">
                                            <li class="page-item active">
                                                <span class="page-link">${i}</span>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item">
                                                <a class="page-link" href="<%=request.getContextPath()%>/quiz/history?page=${i}${searchQuizId != null ? '&searchQuizId='.concat(searchQuizId) : ''}">${i}</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="<%=request.getContextPath()%>/quiz/history?page=${currentPage + 1}${searchQuizId != null ? '&searchQuizId='.concat(searchQuizId) : ''}" aria-label="Next">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>