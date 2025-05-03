<%--
    Document   : viewUser
    Created on : Apr 30, 2025, 3:00:00 AM
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
        <title>View User - QuizMaster Admin</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar Styles */
            .sidebar {
                width: 250px;
                background-color: #1f2937;
                color: #f9fafb;
                position: fixed;
                height: 100vh;
                overflow-y: auto;
                transition: all 0.3s;
                z-index: 1000;
            }

            .sidebar-header {
                padding: 20px;
                border-bottom: 1px solid #374151;
            }

            .sidebar .logo {
                display: flex;
                align-items: center;
                font-weight: 700;
                font-size: 1.5rem;
                color: #f9fafb;
                text-decoration: none;
                margin-bottom: 10px;
            }

            .sidebar .logo-icon {
                margin-right: 8px;
                font-size: 1.8rem;
            }

            .user-info {
                display: flex;
                align-items: center;
                padding: 15px 20px;
                border-bottom: 1px solid #374151;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #4f46e5;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                margin-right: 10px;
            }

            .user-details {
                flex: 1;
            }

            .user-name {
                font-weight: 500;
                color: #f9fafb;
                font-size: 0.9rem;
            }

            .user-role {
                color: #9ca3af;
                font-size: 0.8rem;
            }

            .sidebar-menu {
                padding: 20px 0;
            }

            .menu-label {
                padding: 0 20px;
                font-size: 0.75rem;
                text-transform: uppercase;
                color: #9ca3af;
                margin-bottom: 10px;
                letter-spacing: 0.05em;
            }

            .sidebar-menu ul {
                list-style: none;
            }

            .sidebar-menu ul li {
                margin-bottom: 5px;
            }

            .sidebar-menu ul li a {
                display: flex;
                align-items: center;
                padding: 10px 20px;
                color: #d1d5db;
                text-decoration: none;
                transition: all 0.3s;
                font-weight: 500;
            }

            .sidebar-menu ul li a:hover {
                background-color: #374151;
                color: #f9fafb;
            }

            .sidebar-menu ul li a.active {
                background-color: #4f46e5;
                color: #f9fafb;
            }

            .menu-icon {
                margin-right: 10px;
                width: 20px;
                text-align: center;
            }

            .sidebar-footer {
                padding: 15px 20px;
                border-top: 1px solid #374151;
                position: absolute;
                bottom: 0;
                width: 100%;
            }

            .logout-btn {
                display: flex;
                align-items: center;
                color: #d1d5db;
                text-decoration: none;
                transition: color 0.3s;
                font-weight: 500;
            }

            .logout-btn:hover {
                color: #f9fafb;
            }

            .logout-icon {
                margin-right: 10px;
            }

            /* Main Content Styles */
            .main-content {
                flex: 1;
                margin-left: 250px;
                padding: 20px;
                transition: all 0.3s;
            }

            /* Mobile Toggle Button */
            .mobile-toggle {
                display: none;
                position: fixed;
                top: 15px;
                left: 15px;
                z-index: 999;
            }

            .toggle-btn {
                background-color: #4f46e5;
                color: white;
                border: none;
                border-radius: 4px;
                width: 40px;
                height: 40px;
                font-size: 1.2rem;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .toggle-btn:hover {
                background-color: #4338ca;
            }

            /* View User Styles */
            .view-user-section {
                padding: 40px 0;
            }

            .view-user-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }

            .view-user-title {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
            }

            .view-user-actions {
                display: flex;
                gap: 10px;
            }

            .user-profile-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 30px;
                margin-bottom: 30px;
            }

            .user-profile-header {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
            }

            /* Override sidebar user avatar styles for the profile */
            .user-profile-header .user-avatar {
                width: 100px !important;
                height: 100px !important;
                border-radius: 50%;
                background-color: #4f46e5;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem !important;
                margin-right: 20px;
            }

            /* Override sidebar user info styles for the profile */
            .user-profile-header .user-info {
                flex: 1;
                padding: 0 !important;
                border-bottom: none !important;
            }

            .user-profile-header .user-name {
                font-size: 1.5rem !important;
                font-weight: 700 !important;
                color: #111827 !important;
                margin-bottom: 5px;
            }

            .user-username {
                font-size: 1rem;
                color: #6b7280;
                margin-bottom: 10px;
            }

            .user-status {
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
                background-color: #f3f4f6;
                color: #4b5563;
            }

            .user-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }

            .detail-group {
                margin-bottom: 20px;
            }

            .detail-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: #6b7280;
                margin-bottom: 5px;
            }

            .detail-value {
                font-size: 1rem;
                color: #111827;
            }

            .user-activity-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 30px;
                margin-bottom: 30px;
            }

            .user-activity-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
            }

            .activity-list {
                list-style: none;
            }

            .activity-item {
                display: flex;
                align-items: flex-start;
                padding: 15px 0;
                border-bottom: 1px solid #e5e7eb;
            }

            .activity-icon {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: #eff6ff;
                color: #3b82f6;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
            }

            .activity-content {
                flex: 1;
            }

            .activity-text {
                font-size: 0.875rem;
                color: #111827;
                margin-bottom: 5px;
            }

            .activity-time {
                font-size: 0.75rem;
                color: #6b7280;
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

            .btn-success {
                background-color: #10b981;
                color: white;
                border: 1px solid #10b981;
            }

            .btn-success:hover {
                background-color: #059669;
                border-color: #059669;
            }

            .status-banned {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .user-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }

            .detail-group {
                margin-bottom: 20px;
            }

            .detail-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: #6b7280;
                margin-bottom: 5px;
            }

            .detail-value {
                font-size: 1rem;
                color: #111827;
            }

            .user-activity-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 30px;
                margin-bottom: 30px;
            }

            .user-activity-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
            }

            .activity-list {
                list-style: none;
            }

            .activity-item {
                display: flex;
                align-items: flex-start;
                padding: 15px 0;
                border-bottom: 1px solid #e5e7eb;
            }

            .activity-icon {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: #eff6ff;
                color: #3b82f6;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
            }

            .activity-content {
                flex: 1;
            }

            .activity-text {
                font-size: 0.875rem;
                color: #111827;
                margin-bottom: 5px;
            }

            .activity-time {
                font-size: 0.75rem;
                color: #6b7280;
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
            @media (max-width: 992px) {
                .sidebar {
                    width: 70px;
                    overflow: visible;
                }

                .sidebar .logo-text,
                .sidebar .user-details,
                .menu-label,
                .sidebar-menu ul li a span:not(.menu-icon) {
                    display: none;
                }

                .sidebar-menu ul li a {
                    justify-content: center;
                    padding: 15px;
                }

                .menu-icon {
                    margin-right: 0;
                    font-size: 1.2rem;
                }

                .sidebar-footer {
                    display: flex;
                    justify-content: center;
                    padding: 15px 0;
                }

                .logout-icon {
                    margin-right: 0;
                }

                .main-content {
                    margin-left: 70px;
                }

                /* Ensure profile elements still display correctly */
                .user-profile-header .user-info {
                    display: block !important;
                }
            }

            @media (max-width: 768px) {
                .view-user-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }

                .user-profile-header {
                    flex-direction: column;
                    align-items: center;
                    text-align: center;
                }

                .user-profile-header .user-avatar {
                    margin-right: 0;
                    margin-bottom: 15px;
                }

                .user-details {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 576px) {
                .sidebar {
                    width: 0;
                    transform: translateX(-100%);
                }

                .sidebar.active {
                    width: 250px;
                    transform: translateX(0);
                }

                .sidebar.active .logo-text,
                .sidebar.active .user-details,
                .sidebar.active .menu-label,
                .sidebar.active .sidebar-menu ul li a span:not(.menu-icon) {
                    display: inline-block;
                }

                .sidebar.active .sidebar-menu ul li a {
                    justify-content: flex-start;
                    padding: 10px 20px;
                }

                .sidebar.active .menu-icon {
                    margin-right: 10px;
                    font-size: 1rem;
                }

                .mobile-toggle {
                    display: block;
                }

                .main-content {
                    margin-left: 0;
                }

                .view-user-actions {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%=request.getContextPath()%>/admin/home" class="logo">
                    <span class="logo-icon"><i class="fas fa-puzzle-piece"></i></span>
                    <span class="logo-text">QuizMaster</span>
                </a>
            </div>

            <!-- User Info -->
            <div class="user-info">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="user-details">
                    <div class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                    <div class="user-role">${sessionScope.user.role.name}</div>
                </div>
            </div>

           <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%=request.getContextPath()%>/admin/home" class="logo">
                    <span class="logo-icon"><i class="fas fa-puzzle-piece"></i></span>
                    <span class="logo-text">QuizMaster</span>
                </a>
            </div>

            <!-- User Info -->
            <div class="user-info">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="user-details">
                    <div class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                    <div class="user-role">${sessionScope.user.role.name}</div>
                </div>
            </div>

            <!-- Sidebar Menu -->
            <div class="sidebar-menu">
                <div class="menu-label">Main</div>
                <ul>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/home" class="DASHBOARD_ACTIVE">
                            <span class="menu-icon"><i class="fas fa-tachometer-alt"></i></span>
                            Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/users" class="USERS_ACTIVE">
                            <span class="menu-icon"><i class="fas fa-users"></i></span>
                            Users
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/quizzes" class="QUIZZES_ACTIVE">
                            <span class="menu-icon"><i class="fas fa-clipboard-list"></i></span>
                            Quizzes
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/subjects" class="SUBJECTS_ACTIVE">
                            <span class="menu-icon"><i class="fas fa-book"></i></span>
                            Subjects
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/reports" class="REPORTS_ACTIVE">
                            <span class="menu-icon"><i class="fas fa-chart-bar"></i></span>
                            Reports
                        </a>
                    </li>
                </ul>

                <div class="menu-label">Account</div>
                <ul>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/profile" class="PROFILE_ACTIVE">
                            <span class="menu-icon"><i class="fas fa-user-cog"></i></span>
                            Profile
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Sidebar Footer -->
            <div class="sidebar-footer">
                <a href="<%=request.getContextPath()%>/signout" class="logout-btn">
                    <span class="logout-icon"><i class="fas fa-sign-out-alt"></i></span>
                    Logout
                </a>
            </div>
        </aside>


        <!-- Main Content -->
        <main class="main-content">
            <!-- Mobile Toggle Button -->
            <div class="mobile-toggle">
                <button id="sidebar-toggle" class="toggle-btn">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <!-- View User Content -->
            <section class="view-user-section">
                <div class="view-user-header">
                    <h1 class="view-user-title">User Profile</h1>
                    <div class="view-user-actions">
                        <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Users
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/users?action=edit&id=${user.id}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit User
                        </a>
                        <c:choose>
                            <c:when test="${user.status.name eq 'Inactive'}">
                                <a href="<%=request.getContextPath()%>/admin/users?action=unban&id=${user.id}" class="btn btn-success" onclick="return confirm('Are you sure you want to activate this user?')">
                                    <i class="fas fa-user-check"></i> Activate User
                                </a>
                            </c:when>
                            <c:when test="${user.status.name eq 'Active'}">
                                <a href="<%=request.getContextPath()%>/admin/users?action=ban&id=${user.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to deactivate this user?')">
                                    <i class="fas fa-user-slash"></i> Deactivate User
                                </a>
                            </c:when>
                        </c:choose>
                    </div>
                </div>

                <!-- User Profile Card -->
                <div class="user-profile-card">
                    <div class="user-profile-header">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-info">
                            <h2 class="user-name">${user.firstName} ${user.lastName}</h2>
                            <p class="user-username">@${user.username}</p>
                            <c:choose>
                                <c:when test="${user.status.name eq 'Active'}">
                                    <span class="user-status status-active">Active</span>
                                </c:when>
                                <c:when test="${user.status.name eq 'Inactive'}">
                                    <span class="user-status status-inactive">Inactive</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="user-status status-inactive">${user.status.name}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="user-details">
                        <div>
                            <div class="detail-group">
                                <div class="detail-label">Email Address</div>
                                <div class="detail-value">${user.emailAddress}</div>
                            </div>

                            <div class="detail-group">
                                <div class="detail-label">Phone Number</div>
                                <div class="detail-value">${not empty user.phoneNumber ? user.phoneNumber : 'Not provided'}</div>
                            </div>

                            <div class="detail-group">
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value"><fmt:formatDate value="${user.dob}" pattern="MMMM dd, yyyy" /></div>
                            </div>
                        </div>

                        <div>
                            <div class="detail-group">
                                <div class="detail-label">Role</div>
                                <div class="detail-value">${user.role.name}</div>
                            </div>

                            <div class="detail-group">
                                <div class="detail-label">Country</div>
                                <div class="detail-value">${user.country.name}</div>
                            </div>

                            <div class="detail-group">
                                <div class="detail-label">Address</div>
                                <div class="detail-value">${not empty user.address ? user.address : 'Not provided'}</div>
                            </div>
                        </div>

                        <div>
                            <div class="detail-group">
                                <div class="detail-label">Account Created</div>
                                <div class="detail-value"><fmt:formatDate value="${user.createdAt}" pattern="MMMM dd, yyyy 'at' hh:mm a" /></div>
                            </div>

                            <div class="detail-group">
                                <div class="detail-label">User ID</div>
                                <div class="detail-value">${user.id}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Activity Card -->
                <div class="user-activity-card">
                    <h3 class="user-activity-title">Recent Activity</h3>

                    <ul class="activity-list">
                        <li class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-sign-in-alt"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">User account created</div>
                                <div class="activity-time"><fmt:formatDate value="${user.createdAt}" pattern="MMMM dd, yyyy 'at' hh:mm a" /></div>
                            </div>
                        </li>
                        <!-- More activity items would be added here from the database -->
                    </ul>
                </div>
            </section>

            <!-- Footer -->
            <footer>
                <div class="footer-bottom">
                    <p>&copy; <c:set var="now" value="<%= new java.util.Date() %>" />
                        <fmt:formatDate value="${now}" pattern="yyyy" /> QuizMaster. All rights reserved.</p>
                </div>
            </footer>
        </main>

        <!-- Sidebar Toggle JavaScript -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const sidebarToggle = document.getElementById('sidebar-toggle');
                const sidebar = document.querySelector('.sidebar');

                sidebarToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                });

                // Close sidebar when clicking outside on mobile
                document.addEventListener('click', function(event) {
                    const isClickInsideSidebar = sidebar.contains(event.target);
                    const isClickOnToggle = sidebarToggle.contains(event.target);

                    if (!isClickInsideSidebar && !isClickOnToggle && window.innerWidth <= 576 && sidebar.classList.contains('active')) {
                        sidebar.classList.remove('active');
                    }
                });
            });
        </script>
    </body>
</html>
