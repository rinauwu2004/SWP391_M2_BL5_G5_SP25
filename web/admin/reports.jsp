<%--
    Document   : reports
    Created on : May 1, 2025, 10:00:00 AM
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
        <title>Reports - QuizMaster Admin</title>
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
                background-color: #f0f4f8;
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

            /* Report Styles */
            .report-header {
                margin-bottom: 40px;
                position: relative;
                padding-bottom: 15px;
            }

            .report-header:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, #4f46e5, #8b5cf6);
                border-radius: 2px;
            }

            .report-title {
                font-size: 2.25rem;
                font-weight: 800;
                color: #1e293b;
                margin-bottom: 12px;
                letter-spacing: -0.5px;
            }

            .report-description {
                color: #64748b;
                font-size: 1.1rem;
                max-width: 700px;
                line-height: 1.5;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 24px;
                margin-bottom: 40px;
            }

            .stat-card {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                padding: 24px;
                display: flex;
                flex-direction: column;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: 1px solid rgba(0, 0, 0, 0.05);
                overflow: hidden;
                position: relative;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
            }

            .stat-card.students::before {
                background: linear-gradient(90deg, #3b82f6, #60a5fa);
            }

            .stat-card.teachers::before {
                background: linear-gradient(90deg, #10b981, #34d399);
            }

            .stat-card.quizzes::before {
                background: linear-gradient(90deg, #f59e0b, #fbbf24);
            }

            .stat-card.subjects::before {
                background: linear-gradient(90deg, #8b5cf6, #a78bfa);
            }

            .stat-card.tests::before {
                background: linear-gradient(90deg, #ef4444, #f87171);
            }

            .stat-card.attempts::before {
                background: linear-gradient(90deg, #f97316, #fb923c);
            }

            .stat-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .stat-title {
                font-size: 1.1rem;
                font-weight: 600;
                color: #475569;
            }

            .stat-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.4rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }

            .icon-students {
                background: linear-gradient(135deg, #3b82f6, #60a5fa);
                color: white;
            }

            .icon-teachers {
                background: linear-gradient(135deg, #10b981, #34d399);
                color: white;
            }

            .icon-quizzes {
                background: linear-gradient(135deg, #f59e0b, #fbbf24);
                color: white;
            }

            .icon-subjects {
                background: linear-gradient(135deg, #8b5cf6, #a78bfa);
                color: white;
            }

            .icon-tests {
                background: linear-gradient(135deg, #ef4444, #f87171);
                color: white;
            }

            .icon-attempts {
                background: linear-gradient(135deg, #f97316, #fb923c);
                color: white;
            }

            .stat-value {
                font-size: 2.5rem;
                font-weight: 800;
                color: #1e293b;
                margin-bottom: 8px;
                letter-spacing: -0.5px;
            }

            .stat-description {
                font-size: 0.95rem;
                color: #64748b;
                margin-bottom: 20px;
            }

            .chart-container {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                padding: 28px;
                margin-bottom: 30px;
                border: 1px solid rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .chart-container:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            }

            .chart-header {
                margin-bottom: 24px;
                position: relative;
                padding-bottom: 15px;
                border-bottom: 1px solid #e2e8f0;
            }

            .chart-title {
                font-size: 1.4rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 8px;
            }

            .chart-description {
                font-size: 1rem;
                color: #64748b;
                max-width: 600px;
            }

            .chart-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
                gap: 24px;
            }

            .chart-wrapper {
                position: relative;
                height: 320px;
                margin-bottom: 20px;
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

                .chart-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 768px) {
                .stats-grid {
                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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

            <!-- Report Content -->
            <section class="report-section">
                <div class="report-header">
                    <h1 class="report-title">System Reports</h1>
                    <p class="report-description">Comprehensive statistics and analytics about the QuizMaster platform.</p>
                </div>

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <!-- Users Comparison Stat -->
                    <div class="stat-card students">
                        <div class="stat-header">
                            <div class="stat-title">User Distribution</div>
                            <div class="stat-icon icon-students">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalStudents + totalTeachers}</div>
                        <div class="stat-description">Total users on the platform</div>
                        <div class="chart-wrapper">
                            <canvas id="usersComparisonChart"></canvas>
                        </div>
                    </div>

                    <!-- User Status Stat -->
                    <div class="stat-card teachers">
                        <div class="stat-header">
                            <div class="stat-title">User Status</div>
                            <div class="stat-icon icon-teachers">
                                <i class="fas fa-user-shield"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalStudents + totalTeachers}</div>
                        <div class="stat-description">Distribution by status</div>
                        <div class="chart-wrapper">
                            <canvas id="userStatusChart"></canvas>
                        </div>
                    </div>

                    <!-- Content Comparison Stat -->
                    <div class="stat-card quizzes">
                        <div class="stat-header">
                            <div class="stat-title">Content Comparison</div>
                            <div class="stat-icon icon-quizzes">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalQuizzes + totalSubjects}</div>
                        <div class="stat-description">Quizzes vs Subjects</div>
                        <div class="chart-wrapper">
                            <canvas id="contentComparisonChart"></canvas>
                        </div>
                    </div>

                    <!-- Subject Distribution Stat -->
                    <div class="stat-card subjects">
                        <div class="stat-header">
                            <div class="stat-title">Subject Categories</div>
                            <div class="stat-icon icon-subjects">
                                <i class="fas fa-book"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalSubjects}</div>
                        <div class="stat-description">Distribution by category</div>
                        <div class="chart-wrapper">
                            <canvas id="subjectDistributionChart"></canvas>
                        </div>
                    </div>

                    <!-- Test Performance Stat -->
                    <div class="stat-card tests">
                        <div class="stat-header">
                            <div class="stat-title">Test Performance</div>
                            <div class="stat-icon icon-tests">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalTests}</div>
                        <div class="stat-description">Performance metrics</div>
                        <div class="chart-wrapper">
                            <canvas id="testPerformanceChart"></canvas>
                        </div>
                    </div>

                    <!-- Test Results Stat -->
                    <div class="stat-card attempts">
                        <div class="stat-header">
                            <div class="stat-title">Test Results</div>
                            <div class="stat-icon icon-attempts">
                                <i class="fas fa-tasks"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalTestAttempts}</div>
                        <div class="stat-description">Distribution by result</div>
                        <div class="chart-wrapper">
                            <canvas id="testResultsChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Test Attempts Trend Chart -->
                <div class="chart-container">
                    <div class="chart-header">
                        <h2 class="chart-title">Test Attempts Trend (${currentYear})</h2>
                        <p class="chart-description">Monthly distribution of test attempts throughout the year</p>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="testAttemptsTrendChart"></canvas>
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

        <!-- Chart.js Scripts -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Sidebar Toggle
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

                // Chart Colors
                const chartColors = {
                    blue: '#3b82f6',
                    green: '#10b981',
                    yellow: '#f59e0b',
                    purple: '#8b5cf6',
                    red: '#ef4444',
                    orange: '#f97316',
                    lightBlue: 'rgba(59, 130, 246, 0.2)',
                    lightGreen: 'rgba(16, 185, 129, 0.2)',
                    lightYellow: 'rgba(245, 158, 11, 0.2)',
                    lightPurple: 'rgba(139, 92, 246, 0.2)',
                    lightRed: 'rgba(239, 68, 68, 0.2)',
                    lightOrange: 'rgba(249, 115, 22, 0.2)'
                };

                // Chart Gradients
                const createGradient = (ctx, color1, color2) => {
                    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                    gradient.addColorStop(0, color1);
                    gradient.addColorStop(1, color2);
                    return gradient;
                };

                // Generate color gradients for a variable number of items
                const generateColorGradients = (ctx, count) => {
                    // Base colors for gradients
                    const baseColors = [
                        ['#3b82f6', '#60a5fa'], // Blue
                        ['#10b981', '#34d399'], // Green
                        ['#f59e0b', '#fbbf24'], // Yellow
                        ['#8b5cf6', '#a78bfa'], // Purple
                        ['#ef4444', '#f87171'], // Red
                        ['#f97316', '#fb923c'], // Orange
                        ['#06b6d4', '#22d3ee'], // Cyan
                        ['#ec4899', '#f472b6'], // Pink
                        ['#6366f1', '#818cf8'], // Indigo
                        ['#14b8a6', '#2dd4bf']  // Teal
                    ];

                    // If we need more colors than we have base colors, we'll cycle through them
                    const gradients = [];
                    for (let i = 0; i < count; i++) {
                        const colorPair = baseColors[i % baseColors.length];
                        gradients.push(createGradient(ctx, colorPair[0], colorPair[1]));
                    }

                    return gradients;
                };

                // Chart Global Options
                Chart.defaults.font.family = '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif';
                Chart.defaults.font.size = 13;
                Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(17, 24, 39, 0.9)';
                Chart.defaults.plugins.tooltip.padding = 12;
                Chart.defaults.plugins.tooltip.cornerRadius = 8;
                Chart.defaults.plugins.tooltip.titleFont = { size: 14, weight: 'bold' };
                Chart.defaults.plugins.tooltip.bodyFont = { size: 13 };
                Chart.defaults.plugins.tooltip.displayColors = true;
                Chart.defaults.plugins.tooltip.boxPadding = 6;

                // Users Comparison Chart (Students vs Teachers)
                const usersComparisonCtx = document.getElementById('usersComparisonChart').getContext('2d');
                new Chart(usersComparisonCtx, {
                    type: 'pie',
                    data: {
                        labels: ['Students', 'Teachers'],
                        datasets: [{
                            data: [${totalStudents}, ${totalTeachers}],
                            backgroundColor: [
                                createGradient(usersComparisonCtx, '#3b82f6', '#60a5fa'),
                                createGradient(usersComparisonCtx, '#10b981', '#34d399')
                            ],
                            borderColor: ['#3b82f6', '#10b981'],
                            borderWidth: 2,
                            hoverOffset: 15,
                            hoverBorderWidth: 3,
                            hoverBorderColor: '#ffffff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'bottom',
                                labels: {
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 15
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = Math.round((value / total) * 100);
                                        return `${label}: ${value} (${percentage}%)`;
                                    }
                                }
                            },
                            title: {
                                display: true,
                                text: 'User Distribution',
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 10
                                }
                            }
                        },
                        animation: {
                            animateScale: true,
                            animateRotate: true,
                            delay: 500
                        }
                    }
                });

                // Active vs Inactive Users Chart
                const userStatusCtx = document.getElementById('userStatusChart').getContext('2d');
                // Using actual data from the database
                const activeUsers = ${activeUsers};
                const inactiveUsers = ${inactiveUsers};

                new Chart(userStatusCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Active Students & Teachers', 'Inactive Students & Teachers'],
                        datasets: [{
                            data: [activeUsers, inactiveUsers],
                            backgroundColor: [
                                createGradient(userStatusCtx, '#10b981', '#34d399'),
                                createGradient(userStatusCtx, '#ef4444', '#f87171')
                            ],
                            borderColor: ['#10b981', '#ef4444'],
                            borderWidth: 2,
                            borderRadius: 4,
                            hoverOffset: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: {
                            legend: {
                                display: true,
                                position: 'bottom',
                                labels: {
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 15
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = Math.round((value / total) * 100);
                                        return `${label}: ${value} (${percentage}%)`;
                                    }
                                }
                            },
                            title: {
                                display: true,
                                text: 'Student & Teacher Status',
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 10
                                }
                            }
                        },
                        animation: {
                            animateScale: true,
                            animateRotate: true,
                            delay: 500
                        }
                    }
                });

                // Quizzes vs Subjects Comparison Chart
                const contentComparisonCtx = document.getElementById('contentComparisonChart').getContext('2d');
                new Chart(contentComparisonCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Quizzes', 'Subjects'],
                        datasets: [{
                            label: 'Count',
                            data: [${totalQuizzes}, ${totalSubjects}],
                            backgroundColor: [
                                createGradient(contentComparisonCtx, '#f59e0b', '#fbbf24'),
                                createGradient(contentComparisonCtx, '#8b5cf6', '#a78bfa')
                            ],
                            borderColor: ['#f59e0b', '#8b5cf6'],
                            borderWidth: 0,
                            borderRadius: 6,
                            borderSkipped: false,
                            hoverBackgroundColor: [
                                createGradient(contentComparisonCtx, '#f59e0b', '#fcd34d'),
                                createGradient(contentComparisonCtx, '#8b5cf6', '#c4b5fd')
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: 'y',  // Horizontal bar chart
                        scales: {
                            y: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    }
                                }
                            },
                            x: {
                                beginAtZero: true,
                                grid: {
                                    display: true,
                                    color: 'rgba(226, 232, 240, 0.5)'
                                },
                                ticks: {
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            title: {
                                display: true,
                                text: 'Quizzes vs Subjects',
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 10
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return `${context.dataset.label}: ${context.raw}`;
                                    }
                                }
                            }
                        },
                        animation: {
                            delay: function(context) {
                                return context.dataIndex * 300;
                            },
                            duration: 1000,
                            easing: 'easeOutQuart'
                        }
                    }
                });

                // Subject Distribution Chart with actual data from database
                const subjectDistributionCtx = document.getElementById('subjectDistributionChart').getContext('2d');

                // Get subject names and counts from server
                const subjectCategories = ${subjectNames};
                const subjectCounts = ${subjectCounts};

                new Chart(subjectDistributionCtx, {
                    type: 'bar',
                    data: {
                        labels: subjectCategories,
                        datasets: [{
                            label: 'Number of Subjects',
                            data: subjectCounts,
                            backgroundColor: generateColorGradients(subjectDistributionCtx, subjectCategories.length),
                            borderWidth: 1,
                            borderColor: '#ffffff',
                            borderRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            title: {
                                display: true,
                                text: 'Subject Categories',
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 10
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = Math.round((value / total) * 100);
                                        return `${label}: ${value} (${percentage}%)`;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(226, 232, 240, 0.5)'
                                },
                                ticks: {
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    font: {
                                        size: 12,
                                        weight: 'bold'
                                    }
                                }
                            }
                        },
                        animation: {
                            animateRotate: true,
                            animateScale: true,
                            duration: 1000,
                            easing: 'easeOutQuart'
                        }
                    }
                });

                // Tests vs Attempts Comparison Chart
                const testPerformanceCtx = document.getElementById('testPerformanceChart').getContext('2d');

                // Calculate average attempts per test
                const avgAttemptsPerTest = ${totalTests} > 0 ? Math.round(${totalTestAttempts} / ${totalTests} * 10) / 10 : 0;

                new Chart(testPerformanceCtx, {
                    type: 'radar',
                    data: {
                        labels: ['Tests', 'Test Attempts', 'Avg Attempts/Test', 'Completion Rate', 'Success Rate'],
                        datasets: [{
                            label: 'Test Metrics',
                            data: [
                                ${totalTests},
                                ${totalTestAttempts},
                                avgAttemptsPerTest,
                                85, // Dummy completion rate (85%)
                                75  // Dummy success rate (75%)
                            ],
                            backgroundColor: 'rgba(239, 68, 68, 0.2)',
                            borderColor: '#ef4444',
                            borderWidth: 2,
                            pointBackgroundColor: '#ffffff',
                            pointBorderColor: '#ef4444',
                            pointHoverBackgroundColor: '#ef4444',
                            pointHoverBorderColor: '#ffffff',
                            pointRadius: 5,
                            pointHoverRadius: 7
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            r: {
                                angleLines: {
                                    color: 'rgba(226, 232, 240, 0.5)'
                                },
                                grid: {
                                    color: 'rgba(226, 232, 240, 0.5)'
                                },
                                pointLabels: {
                                    font: {
                                        size: 12,
                                        weight: 'bold'
                                    }
                                },
                                suggestedMin: 0
                            }
                        },
                        plugins: {
                            legend: {
                                display: true,
                                position: 'bottom',
                                labels: {
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 15
                                }
                            },
                            title: {
                                display: true,
                                text: 'Test Performance Metrics',
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 10
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        return `${label}: ${value}`;
                                    }
                                }
                            }
                        },
                        animation: {
                            animateRotate: true,
                            animateScale: true,
                            duration: 1000,
                            easing: 'easeOutQuart'
                        }
                    }
                });

                // Test Attempts by Result Chart
                const testResultsCtx = document.getElementById('testResultsChart').getContext('2d');

                // Dummy data for test attempt results (replace with actual data)
                const passedAttempts = Math.round(${totalTestAttempts} * 0.7);  // 70% passed
                const failedAttempts = Math.round(${totalTestAttempts} * 0.2);  // 20% failed
                const incompleteAttempts = ${totalTestAttempts} - passedAttempts - failedAttempts; // 10% incomplete

                new Chart(testResultsCtx, {
                    type: 'pie',
                    data: {
                        labels: ['Passed', 'Failed', 'Incomplete'],
                        datasets: [{
                            data: [passedAttempts, failedAttempts, incompleteAttempts],
                            backgroundColor: [
                                createGradient(testResultsCtx, '#10b981', '#34d399'), // Green for passed
                                createGradient(testResultsCtx, '#ef4444', '#f87171'), // Red for failed
                                createGradient(testResultsCtx, '#f59e0b', '#fbbf24')  // Yellow for incomplete
                            ],
                            borderColor: ['#10b981', '#ef4444', '#f59e0b'],
                            borderWidth: 2,
                            hoverOffset: 15
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'bottom',
                                labels: {
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 15
                                }
                            },
                            title: {
                                display: true,
                                text: 'Test Attempts by Result',
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 10
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = Math.round((value / total) * 100);
                                        return `${label}: ${value} (${percentage}%)`;
                                    }
                                }
                            }
                        },
                        animation: {
                            animateScale: true,
                            animateRotate: true,
                            duration: 1000,
                            easing: 'easeOutQuart'
                        }
                    }
                });

                // Test Attempts Trend Chart with Comparison Data
                const trendCtx = document.getElementById('testAttemptsTrendChart').getContext('2d');

                // Generate dummy data for passed and failed attempts (replace with actual data)
                const passedAttemptsData = [];
                const failedAttemptsData = [];
                const monthlyData = ${monthlyTestAttempts};

                for (let i = 0; i < monthlyData.length; i++) {
                    // Assume 70% pass rate for demonstration
                    passedAttemptsData.push(Math.round(monthlyData[i] * 0.7));
                    // Assume 30% fail rate for demonstration
                    failedAttemptsData.push(Math.round(monthlyData[i] * 0.3));
                }

                new Chart(trendCtx, {
                    type: 'line',
                    data: {
                        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                        datasets: [
                            {
                                label: 'Total Attempts',
                                data: monthlyData,
                                backgroundColor: 'rgba(249, 115, 22, 0.1)',
                                borderColor: '#f97316',
                                borderWidth: 3,
                                tension: 0.4,
                                fill: true,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#f97316',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                pointHoverRadius: 8,
                                pointHoverBackgroundColor: '#ffffff',
                                pointHoverBorderColor: '#f97316',
                                pointHoverBorderWidth: 3,
                                order: 1
                            },
                            {
                                label: 'Passed Attempts',
                                data: passedAttemptsData,
                                backgroundColor: 'rgba(16, 185, 129, 0.1)',
                                borderColor: '#10b981',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: true,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#10b981',
                                pointBorderWidth: 2,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                pointHoverBackgroundColor: '#ffffff',
                                pointHoverBorderColor: '#10b981',
                                pointHoverBorderWidth: 2,
                                order: 2
                            },
                            {
                                label: 'Failed Attempts',
                                data: failedAttemptsData,
                                backgroundColor: 'rgba(239, 68, 68, 0.1)',
                                borderColor: '#ef4444',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: true,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#ef4444',
                                pointBorderWidth: 2,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                pointHoverBackgroundColor: '#ffffff',
                                pointHoverBorderColor: '#ef4444',
                                pointHoverBorderWidth: 2,
                                order: 3
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    display: true,
                                    color: 'rgba(226, 232, 240, 0.5)'
                                },
                                ticks: {
                                    font: {
                                        size: 12
                                    },
                                    callback: function(value) {
                                        return value.toLocaleString();
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Number of Attempts',
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    padding: {
                                        top: 10,
                                        bottom: 10
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    font: {
                                        size: 12
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Month',
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    padding: {
                                        top: 10,
                                        bottom: 0
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top',
                                labels: {
                                    font: {
                                        size: 13,
                                        weight: 'bold'
                                    },
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 20
                                }
                            },
                            title: {
                                display: true,
                                text: 'Test Attempts Trend ' + ${currentYear},
                                font: {
                                    size: 16,
                                    weight: 'bold'
                                },
                                padding: {
                                    top: 10,
                                    bottom: 20
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    title: function(context) {
                                        return context[0].label + ' ' + ${currentYear};
                                    },
                                    label: function(context) {
                                        return context.dataset.label + ': ' + context.raw.toLocaleString();
                                    },
                                    footer: function(context) {
                                        // Calculate percentage for passed and failed attempts
                                        if (context[0].datasetIndex > 0) { // Only for passed or failed datasets
                                            const value = context[0].raw;
                                            const totalValue = monthlyData[context[0].dataIndex];
                                            if (totalValue > 0) {
                                                const percentage = Math.round((value / totalValue) * 100);
                                                return `${percentage}% of total attempts`;
                                            }
                                        }
                                        return '';
                                    }
                                }
                            }
                        },
                        interaction: {
                            mode: 'index',
                            intersect: false
                        },
                        animation: {
                            duration: 1500,
                            easing: 'easeOutQuart'
                        }
                    }
                });
            });
        </script>
    </body>
</html>
