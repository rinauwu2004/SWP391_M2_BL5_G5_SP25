<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${user.firstName} ${user.lastName} | Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4f46e5;
                --primary-hover: #4338ca;
                --primary-light: #eef2ff;
                --secondary-color: #6b7280;
                --success-color: #10b981;
                --danger-color: #ef4444;
                --warning-color: #f59e0b;
                --light-bg: #f9fafb;
                --card-border: #e5e7eb;
                --text-primary: #111827;
                --text-secondary: #4b5563;
                --text-muted: #6b7280;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
                --radius-sm: 0.375rem;
                --radius-md: 0.5rem;
                --radius-lg: 0.75rem;
                --radius-full: 9999px;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--light-bg);
                color: var(--text-primary);
                line-height: 1.6;
                min-height: 100vh;
                padding: 2rem 1rem;
            }

            .page-container {
                max-width: 900px;
                margin: 0 auto;
                position: relative;
            }

            /* Improved back button styling */
            .back-link {
                position: absolute;
                top: 1.5rem;
                left: 1.5rem;
                z-index: 10;
                text-decoration: none; /* Remove underline */
            }

            .back-button {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                background-color: white;
                color: var(--primary-color);
                border: 1px solid var(--card-border);
                border-radius: var(--radius-md);
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
                font-weight: 500;
                box-shadow: var(--shadow-sm);
                transition: all 0.3s ease;
            }

            .back-button:hover {
                background-color: var(--primary-light);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
                border-color: var(--primary-color);
            }

            .back-button i {
                font-size: 0.875rem;
            }

            .profile-card {
                background-color: white;
                border-radius: var(--radius-lg);
                box-shadow: var(--shadow-md);
                overflow: hidden;
                margin-top: 2rem;
            }

            .profile-header {
                background: linear-gradient(to right, var(--primary-color), #818cf8);
                padding: 3rem 2rem 8rem;
                position: relative;
                text-align: center;
                color: white;
            }

            .profile-cover-pattern {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.1' fill-rule='evenodd'/%3E%3C/svg%3E");
                opacity: 0.6;
            }

            .profile-title {
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                position: relative;
            }

            .profile-subtitle {
                font-size: 1rem;
                font-weight: 500;
                opacity: 0.9;
                position: relative;
            }

            .profile-avatar-container {
                position: absolute;
                bottom: -60px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 2;
            }

            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: var(--radius-full);
                background-color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: var(--shadow-lg);
                border: 4px solid white;
                overflow: hidden;
            }

            .avatar-initials {
                font-size: 2.5rem;
                font-weight: 700;
                color: white;
                background: linear-gradient(135deg, var(--primary-color), #818cf8);
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                text-transform: uppercase;
            }

            .profile-content {
                padding: 5rem 2rem 2rem;
            }

            .profile-section {
                margin-bottom: 2rem;
            }

            .section-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--text-primary);
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 1px solid var(--card-border);
            }

            .profile-details {
                display: grid;
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            @media (min-width: 640px) {
                .profile-details {
                    grid-template-columns: 1fr 1fr;
                }
            }

            .detail-item {
                padding: 1rem;
                background-color: var(--light-bg);
                border-radius: var(--radius-md);
                transition: all 0.3s ease;
            }

            .detail-item:hover {
                transform: translateY(-3px);
                box-shadow: var(--shadow-md);
            }

            .detail-label {
                font-size: 0.75rem;
                font-weight: 500;
                color: var(--text-secondary);
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 0.5rem;
            }

            .detail-value {
                font-size: 1rem;
                font-weight: 500;
                color: var(--text-primary);
                word-break: break-word;
            }

            .detail-icon {
                display: flex;
                align-items: center;
                margin-bottom: 0.75rem;
            }

            .detail-icon i {
                width: 32px;
                height: 32px;
                border-radius: var(--radius-full);
                background-color: var(--primary-light);
                color: var(--primary-color);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.875rem;
            }

            .actions-container {
                display: flex;
                justify-content: center;
                margin-top: 2rem;
            }

            .action-button {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background-color: var(--primary-color);
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: var(--radius-md);
                border: none;
                cursor: pointer;
                font-size: 0.875rem;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                box-shadow: var(--shadow-md);
            }

            .action-button:hover {
                background-color: var(--primary-hover);
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .action-button i {
                font-size: 1rem;
            }

            @media (max-width: 640px) {
                .profile-header {
                    padding: 2rem 1.5rem 7rem;
                }

                .profile-content {
                    padding: 4.5rem 1.5rem 1.5rem;
                }

                .profile-avatar {
                    width: 100px;
                    height: 100px;
                }

                .profile-avatar-container {
                    bottom: -50px;
                }

                .avatar-initials {
                    font-size: 2rem;
                }
            }

            /* Animation for profile card */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .profile-card {
                animation: fadeInUp 0.5s ease forwards;
            }

            /* Animation for detail items */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            .detail-item {
                opacity: 0;
                animation: fadeIn 0.5s ease forwards;
            }

            .detail-item:nth-child(1) { animation-delay: 0.1s; }
            .detail-item:nth-child(2) { animation-delay: 0.2s; }
            .detail-item:nth-child(3) { animation-delay: 0.3s; }
            .detail-item:nth-child(4) { animation-delay: 0.4s; }
            .detail-item:nth-child(5) { animation-delay: 0.5s; }
            .detail-item:nth-child(6) { animation-delay: 0.6s; }
            .detail-item:nth-child(7) { animation-delay: 0.7s; }
            .detail-item:nth-child(8) { animation-delay: 0.8s; }
        </style>
    </head>
    <body>
        <div class="page-container">
            <!-- Improved Back Button -->
            <a href="javascript:history.back()" class="back-link">
                <div class="back-button">
                    <i class="fas fa-arrow-left"></i>
                    <span>Back</span>
                </div>
            </a>
            
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-cover-pattern"></div>
                    <h1 class="profile-title">${user.firstName} ${user.lastName}</h1>
                    <p class="profile-subtitle">${user.role.name}</p>
                    
                    <div class="profile-avatar-container">
                        <div class="profile-avatar">
                            <div class="avatar-initials">${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}</div>
                        </div>
                    </div>
                </div>

                <div class="profile-content">
                    <div class="profile-section">
                        <h2 class="section-title">Personal Information</h2>
                        
                        <div class="profile-details">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="detail-label">First Name</div>
                                <div class="detail-value">${user.firstName}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="detail-label">Last Name</div>
                                <div class="detail-value">${user.lastName}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="detail-label">Email Address</div>
                                <div class="detail-value">${user.emailAddress}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value">${formattedDob}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <div class="detail-label">Phone Number</div>
                                <div class="detail-value">${user.phoneNumber}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="detail-label">Created Time</div>
                                <div class="detail-value">${formattedCreatedAt}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-globe"></i>
                                </div>
                                <div class="detail-label">Country</div>
                                <div class="detail-value">${user.country.name}</div>
                            </div>
                            
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-id-badge"></i>
                                </div>
                                <div class="detail-label">Role</div>
                                <div class="detail-value">${user.role.name}</div>
                            </div>
                        </div>
                    </div>

                    <div class="actions-container">
                        <a href="forgot-password" class="action-button">
                            <i class="fas fa-key"></i>
                            Change Password
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>