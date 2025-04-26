<%-- 
    Document   : ForgotPassword
    Created on : 27 Apr 2025, 01:11:41
    Author     : Rinaaaa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Find Your Account</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap"/>
        <style>
            /* Base styles */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: "Poppins", sans-serif;
            }

            /* Page container */
            .page-container {
                max-width: none;
                margin-left: auto;
                margin-right: auto;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f9fafb;
            }

            /* Account finder card */
            .account-finder-card {
                width: 448px;
                padding: 32px;
                border-radius: 12px;
                background-color: #fff;
                box-shadow:
                    0px 4px 6px rgba(0, 0, 0, 0.1),
                    0px 10px 15px rgba(0, 0, 0, 0.1);
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            /* Card header */
            .card-header {
                text-align: center;
                margin-bottom: 20px;
            }

            .title {
                font-weight: 700;
                font-size: 30px;
                color: #111827;
            }

            .description {
                font-weight: 400;
                font-size: 16px;
                color: #4b5563;
                margin-top: -6px;
            }

            /* Form elements */
            .search-form {
                width: 100%;
            }

            .input-container {
                width: 100%;
                margin-bottom: 24px;
            }

            .search-input {
                font-family: "Poppins", sans-serif;
                font-weight: 400;
                font-size: 16px;
                color: black;
                width: 100%;
                height: 50px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                padding: 0 16px;
                background-color: #fff;
            }

            /* Button container */
            .button-container {
                width: 100%;
                display: flex;
                justify-content: space-between;
            }

            .cancel-button {
                width: 184px;
                height: 46px;
                border-radius: 8px;
                cursor: pointer;
                border: 1px solid #d1d5db;
                background-color: #fff;
                transition: all 0.3s ease;
            }

            .cancel-button a{
                text-decoration: none;
                font-family: "Poppins", sans-serif;
                font-weight: 500;
                font-size: 14px;
                color: #374151;
            }

            .cancel-button:hover {
                background-color: #f3f4f6;
                transform: scale(1.02);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .search-button {
                width: 184px;
                height: 46px;
                border-radius: 8px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: "Poppins", sans-serif;
                font-weight: 500;
                font-size: 14px;
                cursor: pointer;
                background-color: #2563eb;
                color: #fff;
                position: relative;
                border: none;
                transition: all 0.3s ease;
            }

            .search-button:hover {
                background-color: #1d4ed8;
                transform: scale(1.02);
                box-shadow: 0 2px 8px rgba(37, 99, 235, 0.4);
            }

            .search-icon {
                position: absolute;
                left: 16px;
            }

            .button-text {
                margin-left: 16px;
            }

            /* Responsive styles */
            @media (max-width: 991px) {
                .page-container {
                    max-width: 991px;
                }

                .account-finder-card {
                    width: 90%;
                    padding: 24px;
                }

                .title {
                    font-size: 28px;
                }

                .description {
                    font-size: 15px;
                }

                .search-input {
                    font-size: 15px;
                    height: 48px;
                }

                .cancel-button {
                    height: 44px;
                    width: 48%;
                }

                .search-button {
                    height: 44px;
                    width: 48%;
                }
            }

            @media (max-width: 640px) {
                .page-container {
                    max-width: 640px;
                }

                .account-finder-card {
                    width: 100%;
                    padding: 16px;
                }

                .title {
                    font-size: 26px;
                }

                .description {
                    font-size: 14px;
                }

                .search-input {
                    font-size: 14px;
                    height: 46px;
                }

                .cancel-button {
                    height: 42px;
                    width: 48%;
                }

                .search-button {
                    height: 42px;
                    width: 48%;
                }
            }
        </style>
    </head>
    <body>
        <main class="page-container">
            <section class="account-finder-card">
                <header class="card-header">
                    <h1 class="title">Find your account</h1>
                    <p class="description"><br/>
                        Please enter your email address or username to search for your
                        account.
                    </p>
                    <c:if test="${not empty message}">
                        <p style="margin-top: 10px; color:red; text-align: center; font-size: 16x;">${message}</p>
                    </c:if>
                </header>
                <form action="<%=request.getContextPath()%>/forgot-password" method="post" class="search-form">
                    <div class="input-container">
                        <input type="text" id="input" name="input" class="search-input" placeholder="Enter your email address or username" aria-label="Email address or username"/>
                    </div>
                    <div class="button-container">
                        <button type="button" class="cancel-button" onclick="document.getElementById('cancel-link').click();">
                            <a href="signin" id="cancel-link">Cancel</a>
                        </button>
                        <button type="submit" class="search-button">
                            <i class="ti ti-search search-icon"></i>
                            <span class="button-text">Search</span>
                        </button>
                    </div>
                </form>
            </section>
        </main>
    </body>
</html>

