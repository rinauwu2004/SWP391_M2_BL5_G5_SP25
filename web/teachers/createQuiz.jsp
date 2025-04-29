<%-- 
    Document   : createQuiz
    Created on : Apr 29, 2025, 2:00:00 AM
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
        <title>Create New Quiz - QuizMaster</title>
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
            
            /* Form Styles */
            .create-quiz-section {
                padding: 40px 0;
            }
            
            .create-quiz-title {
                font-size: 1.875rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 30px;
            }
            
            .form-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 30px;
                margin-bottom: 30px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-label {
                display: block;
                font-size: 0.875rem;
                font-weight: 500;
                color: #374151;
                margin-bottom: 8px;
            }
            
            .form-label .required {
                color: #ef4444;
                margin-left: 4px;
            }
            
            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 0.875rem;
                color: #111827;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            
            .form-control:focus {
                outline: none;
                border-color: #4f46e5;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }
            
            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }
            
            .form-row {
                display: flex;
                gap: 20px;
            }
            
            .form-row .form-group {
                flex: 1;
            }
            
            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 30px;
            }
            
            .alert {
                padding: 12px 16px;
                border-radius: 6px;
                margin-bottom: 20px;
            }
            
            .alert-danger {
                background-color: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }
            
            .alert-success {
                background-color: #dcfce7;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            
            .form-help-text {
                font-size: 0.75rem;
                color: #6b7280;
                margin-top: 4px;
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
                
                .form-row {
                    flex-direction: column;
                    gap: 0;
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
                            <li><a href="<%=request.getContextPath()%>/home">Home</a></li>
                            <li><a href="<%=request.getContextPath()%>/teacher/home">Dashboard</a></li>
                            <li><a href="<%=request.getContextPath()%>/quiz/create" class="active">Create Quiz</a></li>
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

        <!-- Create Quiz Form -->
        <section class="create-quiz-section">
            <div class="container">
                <h1 class="create-quiz-title">Create New Quiz</h1>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>
                
                <div class="form-card">
                    <form action="<%=request.getContextPath()%>/quiz/create" method="post">
                        <div class="form-group">
                            <label for="title" class="form-label">Quiz Title<span class="required">*</span></label>
                            <input type="text" id="title" name="title" class="form-control" placeholder="Enter a descriptive title for your quiz" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-control" placeholder="Provide a brief description of your quiz"></textarea>
                            <p class="form-help-text">This will help students understand what the quiz is about.</p>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="timeLimit" class="form-label">Time Limit (minutes)<span class="required">*</span></label>
                                <input type="number" id="timeLimit" name="timeLimit" class="form-control" value="30" min="1" required>
                                <p class="form-help-text">How much time students will have to complete the quiz.</p>
                            </div>
                            
                            <div class="form-group">
                                <label for="status" class="form-label">Status<span class="required">*</span></label>
                                <select id="status" name="status" class="form-control" required>
                                    <option value="active">Active</option>
                                    <option value="inactive" selected>Inactive</option>
                                </select>
                                <p class="form-help-text">Set to "Inactive" while you're creating the quiz. Change to "Active" when it's ready for students.</p>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <a href="<%=request.getContextPath()%>/teacher/home" class="btn btn-outline">Cancel</a>
                            <button type="submit" class="btn btn-primary">Create Quiz</button>
                        </div>
                    </form>
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
