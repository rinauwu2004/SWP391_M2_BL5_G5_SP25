<%-- 
    Document   : errorPage
    Created on : 28 Apr 2025, 11:15:29
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error Page</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #f3f4f6;
                padding: 1rem;
            }

            .error-container {
                background-color: white;
                border-radius: 0.5rem;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
                max-width: 28rem;
                width: 100%;
                padding: 2rem;
            }

            .error-content {
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .error-icon {
                background-color: #ef4444;
                border-radius: 50%;
                padding: 1rem;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1.5rem;
                width: 3.5rem;
                height: 3.5rem;
            }

            .error-icon span {
                color: white;
                font-weight: bold;
                font-size: 1.5rem;
            }

            .error-title {
                color: #111827;
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 0.75rem;
            }

            .error-description {
                color: #4b5563;
                margin-bottom: 2rem;
            }

            .error-message-section {
                width: 100%;
                margin-bottom: 2rem;
            }

            .error-message-label {
                color: #374151;
                font-weight: 500;
                margin-bottom: 0.5rem;
                text-align: center;
            }

            .error-message {
                color: #ef4444;
                text-align: center;
            }

            .action-buttons {
                display: flex;
                gap: 1rem;
                width: 100%;
            }

            .btn {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: 0.375rem;
                border: none;
                color: white;
                font-weight: 500;
                cursor: pointer;
                flex: 1;
            }

            .btn-back {
                background-color: #4b5563;
            }

            .btn-home {
                background-color: #2563eb;
            }

            .icon {
                width: 1.125rem;
                height: 1.125rem;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-content">
                <!-- Error Icon -->
                <div class="error-icon">
                    <span>!</span>
                </div>

                <!-- Error Title -->
                <h1 class="error-title">Oops! Something went wrong</h1>

                <!-- Error Description -->
                <p class="error-description">
                    We encountered an error while processing your request. Please try again later.
                </p>

                <!-- Error Message Section -->
                <div class="error-message-section">
                    <p class="error-message-label">Error Message:</p>
                    <p class="error-message">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                ${errorMessage}
                            </c:when>
                            <c:otherwise>
                                [Error message will appear here]
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button class="btn btn-back" onclick="window.history.back()">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 12H5M12 19l-7-7 7-7"/>
                        </svg>
                        <span>Go Back</span>
                    </button>
                    <button class="btn btn-home" onclick="window.location.href = '<c:url value="/home" />'">
                        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                        <polyline points="9 22 9 12 15 12 15 22"/>
                        </svg>
                        <span>Return Home</span>
                    </button>
                </div>
            </div>
        </div>
    </body>
</html>