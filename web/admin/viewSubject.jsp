<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Subject - QuizMaster</title>
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

            /* Subject Details Styles */
            .subject-details-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .subject-header {
                background-color: #3498db;
                color: white;
                padding: 20px;
                position: relative;
            }

            .subject-title {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 5px;
            }

            .subject-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 10px;
                font-size: 0.9rem;
            }

            .subject-meta-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .subject-content {
                padding: 20px;
            }

            .subject-section {
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

            .subject-description {
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

            /* Related Quizzes Styles */
            .related-quizzes-list {
                list-style: none;
            }

            .quiz-item {
                background-color: #f8f9fa;
                border-radius: 6px;
                padding: 15px;
                margin-bottom: 15px;
                border-left: 3px solid #3498db;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .quiz-info {
                flex: 1;
            }

            .quiz-title {
                font-weight: 500;
                margin-bottom: 5px;
            }

            .quiz-meta {
                font-size: 0.8rem;
                color: #7f8c8d;
            }

            .quiz-actions {
                display: flex;
                gap: 10px;
            }

            .quiz-view-btn {
                padding: 5px 10px;
                background-color: #3498db;
                color: white;
                border-radius: 4px;
                text-decoration: none;
                font-size: 0.8rem;
                transition: all 0.3s ease;
            }

            .quiz-view-btn:hover {
                background-color: #2980b9;
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

                .subject-meta {
                    flex-direction: column;
                    gap: 10px;
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
                        <a href="<%=request.getContextPath()%>/admin/quizzes">
                            <span class="menu-icon"><i class="fas fa-clipboard-list"></i></span>
                            Quizzes
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/subjects" class="active">
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
                <h1 class="page-title">View Subject</h1>
                <div class="header-actions">
                    <a href="<%=request.getContextPath()%>/admin/subjects" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Subjects
                    </a>
                </div>
            </div>

            <!-- Subject Details -->
            <div class="subject-details-card">
                <div class="subject-header">
                    <h2 class="subject-title">${subject.name}</h2>
                    <div class="subject-meta">
                        <div class="subject-meta-item">
                            <i class="fas fa-code"></i>
                            <span>Code: ${subject.code}</span>
                        </div>
                        <div class="subject-meta-item">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Created on: <fmt:formatDate value="${subject.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                        </div>
                        <div class="subject-meta-item">
                            <i class="fas fa-calendar-check"></i>
                            <span>Last modified: <fmt:formatDate value="${subject.modifiedAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                        </div>
                        <div class="subject-meta-item">
                            <i class="fas fa-info-circle"></i>
                            <span>Status:
                                <c:choose>
                                    <c:when test="${subject.status}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="subject-content">
                    <!-- Description Section -->
                    <div class="subject-section">
                        <h3 class="section-title">Description</h3>
                        <p class="subject-description">${subject.description}</p>
                    </div>

                    <!-- Related Quizzes Section -->
                    <div class="subject-section">
                        <h3 class="section-title">Related Quizzes</h3>
                        <p>No quizzes are associated with this subject yet.</p>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
