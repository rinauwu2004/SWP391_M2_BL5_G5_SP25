<%-- 
    Document   : viewQuiz
    Created on : Apr 29, 2025, 12:30:00 AM
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
        <title>${quiz.title} - Quiz Details</title>
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
            
            /* Quiz Details Styles */
            .quiz-details {
                padding: 40px 0;
            }
            
            .quiz-details-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 30px;
            }
            
            .quiz-details-title {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 10px;
            }
            
            .quiz-details-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 20px;
            }
            
            .quiz-details-meta span {
                display: flex;
                align-items: center;
                color: #6b7280;
                font-size: 0.875rem;
            }
            
            .quiz-details-meta i {
                margin-right: 5px;
            }
            
            .quiz-details-description {
                color: #4b5563;
                margin-bottom: 30px;
                max-width: 800px;
            }
            
            .quiz-details-actions {
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
            
            .quiz-stats-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                margin-bottom: 30px;
            }
            
            .quiz-stats-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
            }
            
            .quiz-stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 20px;
            }
            
            .stat-item {
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
            
            .questions-section {
                margin-bottom: 40px;
            }
            
            .questions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .questions-title {
                font-size: 1.5rem;
                font-weight: 600;
                color: #111827;
            }
            
            .question-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 15px;
            }
            
            .question-number {
                font-size: 1.125rem;
                font-weight: 600;
                color: #111827;
            }
            
            .question-actions {
                display: flex;
                gap: 10px;
            }
            
            .question-content {
                color: #4b5563;
                margin-bottom: 20px;
            }
            
            .answers-list {
                list-style: none;
            }
            
            .answer-item {
                display: flex;
                align-items: center;
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 10px;
            }
            
            .answer-item.correct {
                background-color: #dcfce7;
            }
            
            .answer-item.incorrect {
                background-color: #fee2e2;
            }
            
            .answer-marker {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
                font-weight: 600;
            }
            
            .answer-marker.correct {
                background-color: #22c55e;
                color: white;
            }
            
            .answer-marker.incorrect {
                background-color: #ef4444;
                color: white;
            }
            
            .answer-content {
                flex: 1;
            }
            
            .empty-questions {
                text-align: center;
                padding: 40px 0;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }
            
            .empty-icon {
                font-size: 3rem;
                color: #d1d5db;
                margin-bottom: 20px;
            }
            
            .empty-title {
                font-size: 1.25rem;
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
                
                .quiz-details-header {
                    flex-direction: column;
                }
                
                .quiz-details-actions {
                    margin-top: 20px;
                }
                
                .quiz-stats-grid {
                    grid-template-columns: repeat(2, 1fr);
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

        <!-- Quiz Details Content -->
        <section class="quiz-details">
            <div class="container">
                <div class="quiz-details-header">
                    <div>
                        <h1 class="quiz-details-title">${quiz.title}</h1>
                        <div class="quiz-details-meta">
                            <span><i class="fas fa-clock"></i> ${quiz.timeLimit} minutes</span>
                            <span><i class="fas fa-calendar-alt"></i> Created on <fmt:formatDate value="${quiz.createdAt}" pattern="MMM dd, yyyy" /></span>
                            <span><i class="fas fa-key"></i> Quiz Code: ${quiz.code}</span>
                            <span>
                                <c:choose>
                                    <c:when test="${quiz.status eq 'Active'}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:when test="${quiz.status eq 'Inactive'}">
                                        <span class="status-badge status-inactive">Inactive</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-draft">Draft</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <p class="quiz-details-description">${quiz.description}</p>
                    </div>
                    <div class="quiz-details-actions">
                        <a href="<%=request.getContextPath()%>/quiz/edit?id=${quiz.id}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Quiz
                        </a>
                        <a href="<%=request.getContextPath()%>/quiz/results?id=${quiz.id}" class="btn btn-outline">
                            <i class="fas fa-chart-bar"></i> View Results
                        </a>
                        <a href="<%=request.getContextPath()%>/quiz/add-question?quizId=${quiz.id}" class="btn btn-outline">
                            <i class="fas fa-plus"></i> Add Question
                        </a>
                    </div>
                </div>

                <!-- Quiz Statistics -->
                <div class="quiz-stats-card">
                    <h2 class="quiz-stats-title">Quiz Statistics</h2>
                    <div class="quiz-stats-grid">
                        <div class="stat-item">
                            <div class="stat-value">${questions.size()}</div>
                            <div class="stat-label">Questions</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${attemptCount}</div>
                            <div class="stat-label">Attempts</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${quiz.timeLimit}</div>
                            <div class="stat-label">Minutes</div>
                        </div>
                    </div>
                </div>

                <!-- Questions Section -->
                <div class="questions-section">
                    <div class="questions-header">
                        <h2 class="questions-title">Questions</h2>
                    </div>

                    <c:choose>
                        <c:when test="${empty questions}">
                            <div class="empty-questions">
                                <div class="empty-icon">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <h3 class="empty-title">No questions yet</h3>
                                <p class="empty-description">
                                    This quiz doesn't have any questions yet. Add questions to make it available for students.
                                </p>
                                <a href="<%=request.getContextPath()%>/quiz/add-question?quizId=${quiz.id}" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Add First Question
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <div class="question-card">
                                    <div class="question-header">
                                        <h3 class="question-number">Question ${status.index + 1}</h3>
                                        <div class="question-actions">
                                            <a href="<%=request.getContextPath()%>/quiz/edit-question?id=${question.id}" class="btn btn-outline btn-sm">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <a href="<%=request.getContextPath()%>/quiz/delete-question?id=${question.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this question?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </div>
                                    </div>
                                    <div class="question-content">
                                        ${question.content}
                                    </div>
                                    <!-- Answers would be displayed here if we had them in the model -->
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
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
    </body>
</html>
