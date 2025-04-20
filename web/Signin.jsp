<%-- 
    Document   : Signin.jsp
    Created on : 20 Apr 2025, 17:03:43
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign In</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #ffffff;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }

            .signin-container {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 32px;
                width: 100%;
                max-width: 400px;
            }

            .signin-header {
                text-align: center;
                margin-bottom: 24px;
            }

            .signin-header h1 {
                font-size: 24px;
                font-weight: 600;
                color: #262626;
                margin-bottom: 8px;
            }

            .signin-header p {
                color: #737373;
                font-size: 14px;
            }

            .form-group {
                margin-bottom: 16px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 500;
                color: #525252;
                margin-bottom: 8px;
            }

            .input-with-icon {
                position: relative;
            }

            .input-with-icon input {
                width: 100%;
                padding: 10px 10px 10px 40px;
                border: 1px solid #d4d4d4;
                border-radius: 4px;
                font-size: 14px;
                outline: none;
            }

            .input-with-icon input:focus {
                border-color: #adaebc;
                box-shadow: 0 0 0 2px rgba(173, 174, 188, 0.2);
            }

            .input-with-icon input::placeholder {
                color: #a3a3a3;
            }

            .input-icon {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #a3a3a3;
            }

            .remember-me {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .remember-me input[type="checkbox"] {
                width: 16px;
                height: 16px;
                margin-right: 8px;
                border: 1px solid #d4d4d4;
                border-radius: 4px;
            }

            .remember-me label {
                font-size: 14px;
                color: #737373;
            }

            .signin-button {
                width: 100%;
                background-color: #262626;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 10px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .signin-button:hover {
                background-color: #404040;
            }

            .signup-link {
                margin-top: 24px;
                text-align: center;
                font-size: 14px;
                color: #737373;
            }

            .signup-link a {
                color: #262626;
                font-weight: 500;
                text-decoration: none;
            }

            .signup-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="signin-container">
            <div class="signin-header">
                <h1>Sign in</h1>
                <p>Enter your credentials to access your account</p>
            </div>

            <form action="<%=request.getContextPath()%>/signin" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-with-icon">
                        <span class="input-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </span>
                        <input type="text" id="username" name="username" value="${param.username}" placeholder="Enter your username" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-with-icon">
                        <span class="input-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                        </span>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    </div>
                </div>

                <div class="remember-me">
                    <input type="checkbox" id="remember-me" name="remember-me">
                    <label for="remember-me">Remember me</label>
                </div>

                <button type="submit" class="signin-button">Sign in</button>
            </form>

            <div class="signup-link">
                Don't have an account? <a href="signup.jsp">Sign up</a>
            </div>

            <c:if test="${not empty error}">
                <p style="color:red; text-align: center; font-size: 14px;">${error}</p>
            </c:if>
        </div>
    </body>
</html>