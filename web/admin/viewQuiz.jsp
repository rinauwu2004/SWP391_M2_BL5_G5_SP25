<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Quiz - QuizMaster</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fb;
                color: #333;
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar Styles */
            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: #ecf0f1;
                display: flex;
                flex-direction: column;
                position: fixed;
                height: 100vh;
                overflow-y: auto;
                transition: all 0.3s ease;
            }

            .sidebar-header {
                padding: 20px;
                background-color: #1a2530;
                text-align: center;
            }

            .logo {
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                color: #ecf0f1;
                font-size: 1.5rem;
                font-weight: bold;
            }

            .logo-icon {
                margin-right: 10px;
                font-size: 1.8rem;
                color: #3498db;
            }

            .user-info {
                display: flex;
                align-items: center;
                padding: 20px;
                border-bottom: 1px solid #34495e;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #3498db;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
            }

            .user-details {
                flex: 1;
            }

            .user-name {
                font-weight: bold;
                font-size: 0.9rem;
            }

            .user-role {
                font-size: 0.8rem;
                color: #bdc3c7;
            }

            .sidebar-menu {
                padding: 20px 0;
                flex: 1;
            }

            .menu-label {
                padding: 0 20px;
                margin-bottom: 10px;
                font-size: 0.8rem;
                color: #bdc3c7;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .sidebar-menu ul {
                list-style: none;
            }

            .sidebar-menu li {
                margin-bottom: 5px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                text-decoration: none;
                color: #ecf0f1;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .sidebar-menu a:hover {
                background-color: #34495e;
            }

            .sidebar-menu a.active {
                background-color: #3498db;
                color: #fff;
                border-left: 4px solid #2980b9;
            }

            .menu-icon {
                margin-right: 10px;
                width: 20px;
                text-align: center;
            }

            /* Main Content Styles */
            .main-content {
                flex: 1;
                margin-left: 250px;
                padding: 20px;
                transition: all 0.3s ease;
            }

            /* Header Styles */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                background-color: #fff;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .page-title {
                font-size: 1.5rem;
                font-weight: bold;
                color: #2c3e50;
            }

            .header-actions {
                display: flex;
                gap: 10px;
            }

            .btn {
                padding: 8px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .btn-primary {
                background-color: #3498db;
                color: white;
            }

            .btn-primary:hover {
                background-color: #2980b9;
            }

            .btn-secondary {
                background-color: #ecf0f1;
                color: #2c3e50;
            }

            .btn-secondary:hover {
                background-color: #bdc3c7;
            }

            /* Quiz Details Styles */
            .quiz-details-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .quiz-header {
                background-color: #3498db;
                color: white;
                padding: 20px;
                position: relative;
            }

            .quiz-title {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 5px;
            }

            .quiz-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 10px;
                font-size: 0.9rem;
            }

            .quiz-meta-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .quiz-content {
                padding: 20px;
            }

            .quiz-section {
                margin-bottom: 30px;
            }

            .section-title {
                font-size: 1.2rem;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }

            .quiz-description {
                line-height: 1.6;
                color: #555;
                margin-bottom: 20px;
            }

            /* Status Badge Styles */
            .status-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: 500;
            }

            .status-active {
                background-color: #e8f7f0;
                color: #27ae60;
            }

            .status-inactive {
                background-color: #f8eae7;
                color: #e74c3c;
            }

            .status-draft {
                background-color: #f5f7fb;
                color: #7f8c8d;
            }

            /* Questions List Styles */
            .questions-list {
                list-style: none;
            }

            .question-item {
                background-color: #f8f9fa;
                border-radius: 6px;
                padding: 15px;
                margin-bottom: 15px;
                border-left: 3px solid #3498db;
            }

            .question-content {
                font-weight: 500;
                margin-bottom: 10px;
            }

            .question-number {
                display: inline-block;
                width: 24px;
                height: 24px;
                background-color: #3498db;
                color: white;
                border-radius: 50%;
                text-align: center;
                line-height: 24px;
                margin-right: 10px;
                font-size: 0.8rem;
                font-weight: bold;
            }

            /* Stats Card Styles */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .stat-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 15px;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .stat-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 10px;
                font-size: 1.5rem;
                color: white;
            }

            .icon-questions {
                background-color: #3498db;
            }

            .icon-attempts {
                background-color: #e74c3c;
            }

            .icon-time {
                background-color: #f39c12;
            }

            .stat-value {
                font-size: 1.8rem;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 0.9rem;
                color: #7f8c8d;
            }

            /* Responsive Styles */
            @media (max-width: 768px) {
                .sidebar {
                    width: 70px;
                }

                .logo-text,
                .user-details,
                .menu-label {
                    display: none;
                }

                .main-content {
                    margin-left: 70px;
                }

                .sidebar-menu a {
                    justify-content: center;
                    padding: 15px;
                }

                .menu-icon {
                    margin-right: 0;
                }

                .user-info {
                    justify-content: center;
                }

                .user-avatar {
                    margin-right: 0;
                }

                .stats-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%=request.getContextPath()%>/admin/home" class="logo">
                    <span class="logo-icon"><i class="fas fa-puzzle-piece"></i></span>
                    <span class="logo-text">QuizMaster</span>
                </a>
            </div>

            <!-- User Info -->
            <div class="user-info">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="user-details">
                    <div class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                    <div class="user-role">${sessionScope.user.role.name}</div>
                </div>
            </div>

            <!-- Sidebar Menu -->
            <div class="sidebar-menu">
                <div class="menu-label">Main</div>
                <ul>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/home">
                            <span class="menu-icon"><i class="fas fa-tachometer-alt"></i></span>
                            Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/users">
                            <span class="menu-icon"><i class="fas fa-users"></i></span>
                            Users
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/quizzes" class="active">
                            <span class="menu-icon"><i class="fas fa-clipboard-list"></i></span>
                            Quizzes
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/subjects">
                            <span class="menu-icon"><i class="fas fa-book"></i></span>
                            Subjects
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/reports">
                            <span class="menu-icon"><i class="fas fa-chart-bar"></i></span>
                            Reports
                        </a>
                    </li>
                </ul>

                <div class="menu-label">Account</div>
                <ul>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/profile">
                            <span class="menu-icon"><i class="fas fa-user-cog"></i></span>
                            Profile
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/signout">
                            <span class="menu-icon"><i class="fas fa-sign-out-alt"></i></span>
                            Sign Out
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <div class="header">
                <h1 class="page-title">View Quiz</h1>
                <div class="header-actions">
                    <a href="<%=request.getContextPath()%>/admin/quizzes" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Quizzes
                    </a>
                </div>
            </div>

            <!-- Quiz Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-questions">
                        <i class="fas fa-question"></i>
                    </div>
                    <div class="stat-value">-</div>
                    <div class="stat-label">Questions</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-attempts">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-value">${attemptCount}</div>
                    <div class="stat-label">Attempts</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-time">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-value">${quiz.timeLimit}</div>
                    <div class="stat-label">Minutes</div>
                </div>
            </div>

            <!-- Quiz Details -->
            <div class="quiz-details-card">
                <div class="quiz-header">
                    <h2 class="quiz-title">${quiz.title}</h2>
                    <div class="quiz-meta">
                        <div class="quiz-meta-item">
                            <i class="fas fa-user"></i>
                            <span>Created by: ${quiz.teacher.firstName} ${quiz.teacher.lastName}</span>
                        </div>
                        <div class="quiz-meta-item">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Created on: <fmt:formatDate value="${quiz.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                        </div>
                        <div class="quiz-meta-item">
                            <i class="fas fa-key"></i>
                            <span>Code: ${quiz.code}</span>
                        </div>
                        <div class="quiz-meta-item">
                            <i class="fas fa-info-circle"></i>
                            <span>Status:
                                <c:choose>
                                    <c:when test="${quiz.status eq 'Active'}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:when test="${quiz.status eq 'Inactive'}">
                                        <span class="status-badge status-inactive">Inactive</span>
                                    </c:when>
                                    <c:when test="${quiz.status eq 'Not started'}">
                                        <span class="status-badge status-draft">Not Started</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge">${quiz.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="quiz-content">
                    <!-- Description Section -->
                    <div class="quiz-section">
                        <h3 class="section-title">Description</h3>
                        <p class="quiz-description">${quiz.description}</p>
                    </div>

                    <!-- Questions Section -->
                    <div class="quiz-section">
                        <h3 class="section-title">Questions</h3>
                        <p>Questions information is not available in admin view.</p>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
