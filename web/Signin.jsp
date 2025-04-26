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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap" rel="stylesheet">
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

            .form-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .remember-option {
                display: flex;
                align-items: center;
            }

            .remember-checkbox {
                margin-right: 8px;
            }

            .remember-label {
                font-size: 14px;
                color: #4b5563;
            }

            .forgot-password {
                font-weight: 500;
                font-size: 14px;
                color: #4f46e5;
                text-decoration: none;
            }

            .signin-button {
                width: 100%;
                background-color: #262626;
                color: white;
                border: none;
                border-radius: 4px;
                margin-top: 15px;
                padding: 12px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .signin-button:hover {
                background-color: #404040;
            }

            .signup-link {
                margin-top: 20px;
                text-align: center;
            }

            .signup-link a {
                font-weight: 500;
                font-size: 16px;
                color: #4f46e5;
                text-decoration: none;
            }

            .signup-link a:hover {
                text-decoration: underline;
            }

            .google-button {
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 10px;
                border: 1px solid #d1d5db;
                background-color: #fff;
                border-radius: 6px;
                font-family: "Poppins", sans-serif;
                font-weight: 500;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.05);
            }

            .google-button:hover {
                background-color: red;
                color: white;
            }

            .google-button:hover .google-icon path {
                fill: white;
            }

            .google-button a {
                color: #374151;
                padding: 0 0 5px 8px;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .google-button:hover a {
                color: white;
            }

            .divider {
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                margin: 20px 0;
            }

            .divider::before,
            .divider::after {
                content: "";
                flex: 1;
                border-bottom: 1px solid #d1d5db;
            }

            .divider-text {
                background-color: #fff;
                padding: 0 10px;
                font-size: 14px;
                color: #6b7280;
            }

            .lock-icon path {
                fill: white;
            }
        </style>
    </head>
    <body>
        <div class="signin-container">
            <div class="signin-header">
                <h1>Sign in</h1>
                <p>Enter your credentials to access your account</p>
                <c:if test="${not empty message}">
                    <p style="margin-top: 5px; color:green; text-align: center; font-size: 14px;">${message}</p>
                </c:if>
            </div>

            <form action="<%=request.getContextPath()%>/signin" method="post">
                <div class="form-group">
                    <label for="username">Username or email address</label>
                    <div class="input-with-icon">
                        <span class="input-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </span>
                        <input type="text" id="username" name="username" value="${param.username != null ? param.username : (savedUsername != null ? savedUsername : '')}" placeholder="Enter your username/email address" required>
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

                <div class="form-options">
                    <div class="remember-option">
                        <input type="checkbox" id="remember" name="remember" ${savedUsername != null ? "checked" : ""} class="remember-checkbox" />
                        <label for="remember" class="remember-label">Remember me</label>
                    </div>
                    <a href="#" class="forgot-password">Forgot your password?</a>
                </div>

                <button type="submit" class="signin-button">Sign in</button>
            </form>

            <div class="divider">
                <span class="divider-text">Or continue with</span>
            </div>

            <button type="button" class="google-button">
                <div class="button-icon">
                    <svg width="18" height="19" viewBox="0 0 18 19" fill="none" xmlns="http://www.w3.org/2000/svg" class="google-icon">
                    <g clip-path="url(#clip0_146_54)">
                    <path d="M17.3281 9.70391C17.3281 14.6785 13.9215 18.2188 8.89062 18.2188C4.06719 18.2188 0.171875 14.3234 0.171875 9.5C0.171875 4.67656 4.06719 0.78125 8.89062 0.78125C11.2391 0.78125 13.2148 1.64258 14.7371 3.06289L12.3641 5.34453C9.25976 2.34922 3.48711 4.59922 3.48711 9.5C3.48711 12.541 5.91641 15.0055 8.89062 15.0055C12.343 15.0055 13.6367 12.5305 13.8406 11.2473H8.89062V8.24844H17.191C17.2719 8.69492 17.3281 9.12383 17.3281 9.70391Z" fill="black"></path>
                    </g>
                    <defs>
                    <clipPath id="clip0_146_54">
                        <path d="M0.171875 0.5H17.3281V18.5H0.171875V0.5Z" fill="white"></path>
                    </clipPath>
                    </defs>
                    </svg>
                </div>
                <div class="button-link">
                    <a href="${googleLoginURL}">
                        Sign in with Google
                    </a>
                </div>
            </button>

            <div class="signup-link">
                Don't have an account? <a href="signup">Sign up</a>
            </div>

            <c:if test="${not empty error}">
                <p style="margin-top: 5px; color:red; text-align: center; font-size: 14px;">${error}</p>
            </c:if>
        </div>
    </body>
</html>