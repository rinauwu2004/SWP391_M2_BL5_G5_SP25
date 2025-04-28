<%-- 
    Document   : Homepage
    Created on : 21 Apr 2025, 02:53:57
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuizMaster - Test Your Knowledge</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                            <li><a href="Homepage.jsp">Home</a></li>
                            <li><a href="quizzes.jsp">Quizzes</a></li>
                            <li><a href="categories.jsp">Categories</a></li>
                            <li><a href="about.jsp">About</a></li>
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
        <c:if test="${not empty message}">
            <p style="margin-top: 10px; margin-bottom: 10px; color:green; text-align: center; font-size: 16px;">${message}</p>
        </c:if>
        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <div class="hero-text">
                        <h1>Test Your Knowledge with Fun Quizzes</h1>
                        <p>Challenge yourself with thousands of quizzes across various categories. Learn, compete, and have fun!</p>
                        <a href="quizzes.jsp" class="btn btn-primary">
                            Start Quiz Now
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="hero-image">
                        <img src="<%= request.getContextPath() + "/img/img.png" %>" alt="Quiz Illustration">
                    </div>
                </div>
            </div>
        </section>

        <!-- Popular Categories -->
        <section class="categories">
            <div class="container">
                <h2 class="section-title">Popular Categories</h2>
                <div class="category-grid">
                    <div class="category-card">
                        <div class="category-icon technology">
                            <i class="fas fa-laptop-code"></i>
                        </div>
                        <h3>Technology</h3>
                        <p>500+ Quizzes</p>
                    </div>
                    <div class="category-card">
                        <div class="category-icon science">
                            <i class="fas fa-flask"></i>
                        </div>
                        <h3>Science</h3>
                        <p>300+ Quizzes</p>
                    </div>
                    <div class="category-card">
                        <div class="category-icon arts">
                            <i class="fas fa-palette"></i>
                        </div>
                        <h3>Arts</h3>
                        <p>200+ Quizzes</p>
                    </div>
                    <div class="category-card">
                        <div class="category-icon geography">
                            <i class="fas fa-globe-americas"></i>
                        </div>
                        <h3>Geography</h3>
                        <p>400+ Quizzes</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Why Choose QuizMaster -->
        <section class="features">
            <div class="container">
                <h2 class="section-title">Why Choose QuizMaster?</h2>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h3>Fast & Interactive</h3>
                        <p>Engage with our lightning-fast quiz interface</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-trophy"></i>
                        </div>
                        <h3>Compete & Win</h3>
                        <p>Challenge friends and win achievements</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3>Track Progress</h3>
                        <p>Monitor your learning journey</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Popular Quizzes -->
        <section class="quizzes">
            <div class="container">
                <h2 class="section-title">Popular Quizzes</h2>
                <div class="quiz-grid">
                    <div class="quiz-card">
                        <div class="quiz-icon programming">
                            <i class="fas fa-code"></i>
                        </div>
                        <h3>Programming Basics</h3>
                        <p>Test your coding knowledge</p>
                        <div class="quiz-footer">
                            <span>20 Questions</span>
                            <a href="quiz.jsp?id=1" class="btn btn-primary">Start Quiz</a>
                        </div>
                    </div>
                    <div class="quiz-card">
                        <div class="quiz-icon environmental">
                            <i class="fas fa-leaf"></i>
                        </div>
                        <h3>Environmental Science</h3>
                        <p>Learn about our planet</p>
                        <div class="quiz-footer">
                            <span>15 Questions</span>
                            <a href="quiz.jsp?id=2" class="btn btn-success">Start Quiz</a>
                        </div>
                    </div>
                    <div class="quiz-card">
                        <div class="quiz-icon history">
                            <i class="fas fa-landmark"></i>
                        </div>
                        <h3>World History</h3>
                        <p>Explore historical events</p>
                        <div class="quiz-footer">
                            <span>25 Questions</span>
                            <a href="quiz.jsp?id=3" class="btn btn-primary">Start Quiz</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Call to Action -->
        <section class="cta">
            <div class="container">
                <h2>Ready to Test Your Knowledge?</h2>
                <p>Join thousands of users and start your learning journey today!</p>
                <a href="<%=request.getContextPath()%>/signup" class="btn btn-light">
                    Create Free Account
                    <i class="fas fa-arrow-right"></i>
                </a>
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
                            <li><a href="index.jsp">Home</a></li>
                            <li><a href="about.jsp">About Us</a></li>
                            <li><a href="categories.jsp">Categories</a></li>
                            <li><a href="contact.jsp">Contact</a></li>
                        </ul>
                    </div>
                    <div class="footer-links">
                        <h4>Categories</h4>
                        <ul>
                            <li><a href="category.jsp?id=tech">Technology</a></li>
                            <li><a href="category.jsp?id=science">Science</a></li>
                            <li><a href="category.jsp?id=arts">Arts</a></li>
                            <li><a href="category.jsp?id=geo">Geography</a></li>
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

        <script type="text/javascript" src="<%= request.getContextPath() + "/js/scripts.js" %>"></script>
    </body>
</html>