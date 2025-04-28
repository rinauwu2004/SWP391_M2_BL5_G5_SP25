<%--
    Document   : home
    Created on : Apr 28, 2025, 11:35:49 PM
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
        <title>Teacher Dashboard - QuizMaster</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

            /* Dashboard Styles */
            .dashboard {
                padding: 40px 0;
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }

            .dashboard-title {
                font-size: 1.875rem;
                font-weight: 700;
                color: #111827;
            }

            .quiz-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 24px;
                margin-bottom: 40px;
            }

            .quiz-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                transition: transform 0.3s, box-shadow 0.3s;
            }

            .quiz-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .quiz-header {
                padding: 20px;
                border-bottom: 1px solid #e5e7eb;
            }

            .quiz-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 8px;
            }

            .quiz-description {
                color: #6b7280;
                font-size: 0.875rem;
                margin-bottom: 12px;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .quiz-meta {
                display: flex;
                align-items: center;
                gap: 15px;
                color: #6b7280;
                font-size: 0.75rem;
            }

            .quiz-meta span {
                display: flex;
                align-items: center;
            }

            .quiz-meta i {
                margin-right: 5px;
            }

            .quiz-body {
                padding: 20px;
            }

            .quiz-stats {
                display: flex;
                justify-content: space-between;
                margin-bottom: 20px;
            }

            .stat-item {
                text-align: center;
                flex: 1;
            }

            .stat-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 0.75rem;
                color: #6b7280;
            }

            .quiz-actions {
                display: flex;
                gap: 10px;
            }

            .quiz-actions .btn {
                flex: 1;
                font-size: 0.875rem;
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

                .quiz-grid {
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
                        <a href="<%=request.getContextPath()%>/home">
                            <span class="logo-icon"><i class="fas fa-puzzle-piece"></i></span>
                            <span class="logo-text">QuizMaster</span>
                        </a>
                    </div>
                    <nav>
                        <ul>
                            <li><a href="<%=request.getContextPath()%>/teachers/home.jsp">Home</a></li>
                            <li><a href="<%=request.getContextPath()%>/teachers/home" class="active">Dashboard</a></li>
                            <li><a href="<%=request.getContextPath()%>/teachers/createQuiz.jsp">Create Quiz</a></li>
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

        <!-- Dashboard Content -->
        <section class="dashboard">
            <div class="container">
                <div class="dashboard-header">
                    <h1 class="dashboard-title">My Quizzes</h1>
                    <a href="<%=request.getContextPath()%>/teachers/createQuiz.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create New Quiz
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty quizzes}">
                        <!-- Empty State -->
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <h2 class="empty-title">No quizzes yet</h2>
                            <p class="empty-description">
                                You haven't created any quizzes yet. Start by creating your first quiz to engage your students.
                            </p>
                            <a href="<%=request.getContextPath()%>/teachers/createQuiz.jsp" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Create Your First Quiz
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Quiz Grid -->
                        <div class="quiz-grid">
                            <c:forEach var="quiz" items="${quizzes}">
                                <div class="quiz-card">
                                    <div class="quiz-header">
                                        <h3 class="quiz-title">${quiz.title}</h3>
                                        <p class="quiz-description">${quiz.description}</p>
                                        <div class="quiz-meta">
                                            <span><i class="fas fa-clock"></i> ${quiz.timeLimit} min</span>
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
                                            <span><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="${quiz.createdAt}" pattern="MMM dd, yyyy" /></span>
                                        </div>
                                    </div>
                                    <div class="quiz-body">
                                        <div class="quiz-stats">
                                            <div class="stat-item">
                                                <div class="stat-value">${requestScope['questionCount_'.concat(quiz.id)]}</div>
                                                <div class="stat-label">Questions</div>
                                            </div>
                                            <div class="stat-item">
                                                <div class="stat-value">${requestScope['attemptCount_'.concat(quiz.id)]}</div>
                                                <div class="stat-label">Attempts</div>
                                            </div>
                                            <div class="stat-item">
                                                <div class="stat-value">${quiz.code}</div>
                                                <div class="stat-label">Code</div>
                                            </div>
                                        </div>
                                        <div class="quiz-actions">
                                            <a href="<%=request.getContextPath()%>/quiz/view?id=${quiz.id}" class="btn btn-outline">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                            <a href="<%=request.getContextPath()%>/quiz/edit?id=${quiz.id}" class="btn btn-primary">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <a href="<%=request.getContextPath()%>/quiz/results?id=${quiz.id}" class="btn btn-outline">
                                                <i class="fas fa-chart-bar"></i> Results
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
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
                            <li><a href="<%=request.getContextPath()%>/teachers/home.jsp">Dashboard</a></li>
                            <li><a href="<%=request.getContextPath()%>/teachers/createQuiz.jsp">Create Quiz</a></li>
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
    </body>
</html>
