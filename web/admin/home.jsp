<%--
    Document   : home
    Created on : Apr 30, 2025, 1:00:00 AM
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
        <title>Admin Dashboard - QuizMaster</title>
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

            /* Admin Dashboard Styles */
            .admin-dashboard {
                padding: 40px 0;
            }

            .admin-dashboard-title {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 30px;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                text-align: center;
                transition: transform 0.3s, box-shadow 0.3s;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .stat-icon {
                font-size: 2.5rem;
                margin-bottom: 15px;
                color: #4f46e5;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 0.875rem;
                color: #6b7280;
            }

            .charts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .chart-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
            }

            .chart-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
                text-align: center;
            }

            .chart-container {
                position: relative;
                height: 300px;
            }

            .quick-links {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
                margin-bottom: 30px;
            }

            .quick-links-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 20px;
            }

            .quick-links-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .quick-link {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 15px;
                border-radius: 8px;
                background-color: #f9fafb;
                text-decoration: none;
                transition: all 0.3s;
            }

            .quick-link:hover {
                background-color: #f3f4f6;
                transform: translateY(-3px);
            }

            .quick-link-icon {
                font-size: 2rem;
                color: #4f46e5;
                margin-bottom: 10px;
            }

            .quick-link-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: #111827;
                text-align: center;
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

                .charts-grid {
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

                .stats-grid {
                    grid-template-columns: 1fr 1fr;
                }
            }
        </style>
    </head>
    <body>
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

            <!-- Admin Dashboard Content -->
            <section class="admin-dashboard">
                <h1 class="admin-dashboard-title">Admin Dashboard</h1>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-chalkboard-teacher"></i>
                        </div>
                        <div class="stat-value">${totalTeachers}</div>
                        <div class="stat-label">Teachers</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <div class="stat-value">${totalStudents}</div>
                        <div class="stat-label">Students</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-question-circle"></i>
                        </div>
                        <div class="stat-value">${totalQuizzes}</div>
                        <div class="stat-label">Quizzes</div>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="quick-links">
                    <h2 class="quick-links-title">Quick Links</h2>
                    <div class="quick-links-grid">
                        <a href="<%=request.getContextPath()%>/admin/users?action=create" class="quick-link">
                            <div class="quick-link-icon">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="quick-link-label">Add New User</div>
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/users" class="quick-link">
                            <div class="quick-link-icon">
                                <i class="fas fa-user-cog"></i>
                            </div>
                            <div class="quick-link-label">Manage Users</div>
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/quizzes" class="quick-link">
                            <div class="quick-link-icon">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <div class="quick-link-label">Manage Quizzes</div>
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/subjects" class="quick-link">
                            <div class="quick-link-icon">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="quick-link-label">Manage Subjects</div>
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/reports" class="quick-link">
                            <div class="quick-link-icon">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <div class="quick-link-label">View Reports</div>
                        </a>
                    </div>
                </div>

                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <h3 class="chart-title">User Registration Trend</h3>
                        <div class="chart-container">
                            <canvas id="userRegistrationChart"></canvas>
                        </div>
                    </div>
                    <div class="chart-card">
                        <h3 class="chart-title">User Distribution</h3>
                        <div class="chart-container">
                            <canvas id="userDistributionChart"></canvas>
                        </div>
                    </div>
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

        <!-- Charts JavaScript -->
        <script>
            // User Registration Trend Chart
            const registrationCtx = document.getElementById('userRegistrationChart').getContext('2d');
            const registrationChart = new Chart(registrationCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'New Users ${currentYear}',
                        data: ${monthlyRegistrations},
                        backgroundColor: 'rgba(79, 70, 229, 0.2)',
                        borderColor: 'rgba(79, 70, 229, 1)',
                        borderWidth: 2,
                        tension: 0.3,
                        pointBackgroundColor: 'rgba(79, 70, 229, 1)',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });

            // User Distribution Chart
            const distributionCtx = document.getElementById('userDistributionChart').getContext('2d');
            const distributionChart = new Chart(distributionCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Students', 'Teachers', 'Admins'],
                    datasets: [{
                        data: [${totalStudents}, ${totalTeachers}, ${totalUsers - totalStudents - totalTeachers}],
                        backgroundColor: [
                            'rgba(79, 70, 229, 0.8)',
                            'rgba(245, 158, 11, 0.8)',
                            'rgba(239, 68, 68, 0.8)'
                        ],
                        borderColor: [
                            'rgba(79, 70, 229, 1)',
                            'rgba(245, 158, 11, 1)',
                            'rgba(239, 68, 68, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        </script>
    </body>
</html>
