<%-- 
    Document   : ViewProfileDetails
    Created on : 27 Apr 2025, 04:50:00
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Profile</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            }

            body {
                background-color: #ffffff;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                padding: 1rem;
            }
            
            .back-button {
                position: absolute;
                top: 20px;
                left: 20px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #f3f4f6;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            .back-button:hover {
                background-color: #e5e7eb;
                transform: translateY(-2px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .back-button:active {
                transform: translateY(0);
            }

            .back-arrow {
                width: 10px;
                height: 10px;
                border: solid #4b5563;
                border-width: 0 2px 2px 0;
                transform: rotate(135deg);
                margin: 1px 0px 0px 3px;
            }

            .profile-container {
                width: 100%;
                max-width: 768px;
                background-color: white;
                border-radius: 0.5rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid #ced4da;
            }

            .profile-content {
                padding: 2rem;
            }

            .profile-header {
                text-align: center;
                margin-bottom: 3rem;
            }

            .profile-name {
                font-size: 1.5rem;
                font-weight: 500;
                color: #111827;
            }

            .profile-membership {
                color: #6b7280;
                margin-top: 0.25rem;
            }

            .profile-divider {
                border-top: 1px solid #ced4da;
                margin-bottom: 2rem;
            }

            .profile-details {
                display: grid;
                grid-template-columns: 1fr;
                gap: 2rem;
            }

            @media (min-width: 768px) {
                .profile-details {
                    grid-template-columns: 1fr 1fr;
                    column-gap: 3rem;
                    row-gap: 2rem;
                }
            }

            .profile-field {
                margin-bottom: 0.25rem;
            }

            .field-label {
                display: block;
                font-size: 0.875rem;
                color: #6b7280;
                margin-bottom: 0.25rem;
            }

            .field-value {
                color: #111827;
            }

            .button-container {
                margin-top: 3rem;
            }

            .change-password-btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background-color: #2563eb;
                padding: 0.5rem 1rem;
                border-radius: 0.375rem;
                border: none;
                cursor: pointer;
                font-size: 0.875rem;
                transition: background-color 0.2s;
            }

            .change-password-btn:hover {
                background-color: #1d4ed8;
            }
            
            .button-href {
                color: #ffffff;
                font-size: 15px;
                font-weight: bold;
                text-align: center;
                line-height: normal;
                white-space: nowrap;
                text-decoration: none;
            }

            .key-icon {
                width: 1rem;
                height: 1rem;
            }
        </style>
    </head>
    <body>
        <!-- Back Button -->
        <button class="back-button" onclick="window.history.back()">
            <div class="back-arrow"></div>
        </button>
        
        <div class="profile-container">
            <div class="profile-content">
                <div class="profile-header">
                    <h1 class="profile-name">${user.firstName} ${user.lastName}</h1>
                </div>

                <div class="profile-divider"></div>

                <div class="profile-details">
                    <div>
                        <label class="field-label">First Name</label>
                        <p class="field-value">${user.firstName}</p>
                    </div>

                    <div>
                        <label class="field-label">Last Name</label>
                        <p class="field-value">${user.lastName}</p>
                    </div>

                    <div>
                        <label class="field-label">Email Address</label>
                        <p class="field-value">${user.emailAddress}</p>
                    </div>

                    <div>
                        <label class="field-label">Date of Birth</label>
                        <p class="field-value">${formattedDob}</p>
                    </div>

                    <div>
                        <label class="field-label">Phone Number</label>
                        <p class="field-value">${user.phoneNumber}</p>
                    </div>

                    <div>
                        <label class="field-label">Created Time</label>
                        <p class="field-value">${formattedCreatedAt}</p>
                    </div>

                    <div>
                        <label class="field-label">Country</label>
                        <p class="field-value">${user.country.name}</p>
                    </div>
                </div>

                <div class="button-container">
                    <button class="change-password-btn">
                        <svg class="key-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path>
                        </svg>
                        <a href="forgot-password" class="button-href">Change Password</a>
                    </button>
                </div>
            </div>
        </div>
    </body>
</html>