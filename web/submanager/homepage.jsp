<%-- 
    Document   : homepage
    Created on : 6 May 2025, 13:35:19
    Author     : Rinaaaa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Subject Manager Dashboard - QuizMaster</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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

            /* Dashboard Styles */
            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
            }

            .welcome-message {
                font-size: 1.5rem;
                font-weight: 600;
                color: #111827;
            }

            .date-display {
                font-size: 0.875rem;
                color: #6b7280;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                transition: transform 0.3s, box-shadow 0.3s;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .stat-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }

            .stat-title {
                font-size: 0.875rem;
                color: #6b7280;
            }

            .stat-icon {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
            }

            .icon-subjects {
                background-color: #e0f2fe;
                color: #0284c7;
            }

            .icon-lessons {
                background-color: #fef3c7;
                color: #d97706;
            }

            .icon-modules {
                background-color: #dcfce7;
                color: #16a34a;
            }

            .icon-active {
                background-color: #f3e8ff;
                color: #9333ea;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 5px;
            }

            .stat-description {
                font-size: 0.875rem;
                color: #6b7280;
            }

            .content-section {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                margin-bottom: 30px;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .section-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
            }

            .view-all {
                font-size: 0.875rem;
                color: #4f46e5;
                text-decoration: none;
                font-weight: 500;
            }

            .view-all:hover {
                text-decoration: underline;
            }

            .subject-table {
                width: 100%;
                border-collapse: collapse;
            }

            .subject-table th {
                text-align: left;
                padding: 12px 16px;
                font-size: 0.875rem;
                font-weight: 500;
                color: #6b7280;
                border-bottom: 1px solid #e5e7eb;
            }

            .subject-table td {
                padding: 12px 16px;
                font-size: 0.875rem;
                border-bottom: 1px solid #e5e7eb;
            }

            .subject-table tr:last-child td {
                border-bottom: none;
            }

            .subject-table tr:hover {
                background-color: #f9fafb;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                padding: 2px 8px;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 500;
            }

            .status-active {
                background-color: #dcfce7;
                color: #16a34a;
            }

            .status-inactive {
                background-color: #fee2e2;
                color: #dc2626;
            }

            .quick-actions {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }

            .action-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                text-align: center;
                transition: transform 0.3s, box-shadow 0.3s;
                text-decoration: none;
                color: #111827;
            }

            .action-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .action-icon {
                width: 50px;
                height: 50px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                margin: 0 auto 15px;
            }

            .action-title {
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .action-description {
                font-size: 0.875rem;
                color: #6b7280;
            }

            /* Footer Styles */
            footer {
                background-color: #1f2937;
                color: #f9fafb;
                padding: 20px 0;
                margin-top: auto;
            }

            .footer-bottom {
                text-align: center;
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
                .user-details,
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
            }

            @media (max-width: 768px) {
                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .quick-actions {
                    grid-template-columns: repeat(2, 1fr);
                }

                .subject-table th:nth-child(3),
                .subject-table td:nth-child(3) {
                    display: none;
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

                .stats-grid {
                    grid-template-columns: 1fr;
                }

                .quick-actions {
                    grid-template-columns: 1fr;
                }

                .dashboard-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .subject-table th:nth-child(4),
                .subject-table td:nth-child(4) {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%=request.getContextPath()%>/subjectmanager/home" class="logo">
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
                        <a href="<%=request.getContextPath()%>/subject-manager/home" class="active">
                            <span class="menu-icon"><i class="fas fa-home"></i></span>
                            Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/list-subject">
                            <span class="menu-icon"><i class="fa-solid fa-book"></i></span>
                            Subjects
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/subject-manager/lessons">
                            <span class="menu-icon"><i class="fa-solid fa-bookmark"></i></span>
                            Lessons
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/subject-manager/modules">
                            <span class="menu-icon"><i class="fa-solid fa-cube"></i></span>
                            Modules
                        </a>
                    </li>
                </ul>

                <div class="menu-label">Account</div>
                <ul>
                    <li>
                        <a href="<%=request.getContextPath()%>/user/view-profile">
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

            <!-- Dashboard Content -->
            <div class="dashboard-header">
                <div>
                    <h1 class="welcome-message">Welcome back, ${sessionScope.user.firstName}!</h1>
                    <p class="date-display">
                        <c:set var="now" value="<%= new java.util.Date() %>" />
                        <fmt:formatDate value="${now}" pattern="EEEE, MMMM d, yyyy" />
                    </p>
                </div>
                <a href="<%=request.getContextPath()%>/addSubject" class="btn btn-primary">
                    <i class="fas fa-plus mr-2"></i> Add New Subject
                </a>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Total Subjects</div>
                        <div class="stat-icon icon-subjects">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                    <div class="stat-value">${totalSubjects}</div>
                    <div class="stat-description">All subjects in the system</div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Active Subjects</div>
                        <div class="stat-icon icon-active">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="stat-value">${activeSubjects}</div>
                    <div class="stat-description">Currently active subjects</div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Total Lessons</div>
                        <div class="stat-icon icon-lessons">
                            <i class="fas fa-bookmark"></i>
                        </div>
                    </div>
                    <div class="stat-value">${totalLessons}</div>
                    <div class="stat-description">Lessons across all subjects</div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Total Modules</div>
                        <div class="stat-icon icon-modules">
                            <i class="fas fa-cube"></i>
                        </div>
                    </div>
                    <div class="stat-value">${totalModules}</div>
                    <div class="stat-description">Modules across all lessons</div>
                </div>
            </div>

            <!-- Recent Subjects -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Recent Subjects</h2>
                    <a href="<%=request.getContextPath()%>/list-subject" class="view-all">View All</a>
                </div>

                <table class="subject-table">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${recentSubjects}" var="subject">
                            <tr>
                                <td>${subject.code}</td>
                                <td>${subject.name}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty subject.description}">
                                            <span class="text-muted">No description</span>
                                        </c:when>
                                        <c:when test="${fn:length(subject.description) > 50}">
                                            ${fn:substring(subject.description, 0, 50)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${subject.description}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${subject.status}">
                                            <span class="status-badge status-active">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${subject.createdAt}" pattern="MMM d, yyyy" /></td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/editSubject?id=${subject.id}" class="btn btn-sm btn-outline">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty recentSubjects}">
                            <tr>
                                <td colspan="6" class="text-center">No subjects found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Quick Actions -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Quick Actions</h2>
                </div>

                <div class="quick-actions">
                    <a href="<%=request.getContextPath()%>/list-subject" class="action-card">
                        <div class="action-icon icon-subjects">
                            <i class="fas fa-book"></i>
                        </div>
                        <h3 class="action-title">Manage Subjects</h3>
                        <p class="action-description">View, add, edit or delete subjects</p>
                    </a>

                    <a href="#" class="action-card">
                        <div class="action-icon icon-lessons">
                            <i class="fas fa-bookmark"></i>
                        </div>
                        <h3 class="action-title">Manage Lessons</h3>
                        <p class="action-description">Organize lessons for your subjects</p>
                    </a>

                    <a href="#" class="action-card">
                        <div class="action-icon icon-modules">
                            <i class="fas fa-cube"></i>
                        </div>
                        <h3 class="action-title">Manage Modules</h3>
                        <p class="action-description">Create and organize learning modules</p>
                    </a>

                    <a href="<%=request.getContextPath()%>/user/view-profile" class="action-card">
                        <div class="action-icon" style="background-color: #e0f2fe; color: #0284c7;">
                            <i class="fas fa-user-cog"></i>
                        </div>
                        <h3 class="action-title">Profile Settings</h3>
                        <p class="action-description">Update your profile information</p>
                    </a>
                </div>
            </div>

            <footer>
                <div class="footer-bottom">
                    <p>&copy; <c:set var="now" value="<%= new java.util.Date() %>" />
                        <fmt:formatDate value="${now}" pattern="yyyy" /> QuizMaster. All rights reserved.</p>
                </div>
            </footer>
        </main>

        <!-- Sidebar Toggle JavaScript -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const sidebarToggle = document.getElementById('sidebar-toggle');
                const sidebar = document.querySelector('.sidebar');

                sidebarToggle.addEventListener('click', function () {
                    sidebar.classList.toggle('active');
                });

                // Close sidebar when clicking outside on mobile
                document.addEventListener('click', function (event) {
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