<%--
    Document   : editUser
    Created on : Apr 30, 2025, 2:30:00 AM
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
        <title>Edit User - QuizMaster Admin</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

            /* Form Styles */
            .edit-user-section {
                padding: 40px 0;
            }

            .edit-user-title {
                font-size: 2rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 30px;
            }

            .form-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 30px;
                margin-bottom: 30px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                font-size: 0.875rem;
                font-weight: 500;
                color: #374151;
                margin-bottom: 8px;
            }

            .form-label .required {
                color: #ef4444;
                margin-left: 4px;
            }

            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 0.875rem;
                color: #111827;
                transition: border-color 0.3s, box-shadow 0.3s;
            }

            .form-control:focus {
                outline: none;
                border-color: #4f46e5;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

            .form-control[readonly] {
                background-color: #f3f4f6;
                cursor: not-allowed;
            }

            .form-row {
                display: flex;
                gap: 20px;
            }

            .form-row .form-group {
                flex: 1;
            }

            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 30px;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 6px;
                margin-bottom: 20px;
            }

            .alert-danger {
                background-color: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .form-help-text {
                font-size: 0.75rem;
                color: #6b7280;
                margin-top: 4px;
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

                .form-row {
                    flex-direction: column;
                    gap: 0;
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

            <!-- Edit User Form -->
            <section class="edit-user-section">
                <h1 class="edit-user-title">Edit User: ${user.username}</h1>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>

                <div class="form-card">
                    <form action="<%=request.getContextPath()%>/admin/users" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${user.id}">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" id="username" name="username" class="form-control" value="${user.username}" readonly>
                                <p class="form-help-text">Username cannot be changed.</p>
                            </div>

                            <div class="form-group">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" id="email" name="email" class="form-control" value="${user.emailAddress}" readonly>
                                <p class="form-help-text">Email address cannot be changed.</p>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName" class="form-label">First Name<span class="required">*</span></label>
                                <input type="text" id="firstName" name="firstName" class="form-control" value="${formData.firstName != null ? formData.firstName : user.firstName}" required>
                            </div>

                            <div class="form-group">
                                <label for="lastName" class="form-label">Last Name<span class="required">*</span></label>
                                <input type="text" id="lastName" name="lastName" class="form-control" value="${formData.lastName != null ? formData.lastName : user.lastName}" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="dob" class="form-label">Date of Birth<span class="required">*</span></label>
                                <input type="date" id="dob" name="dob" class="form-control" value="${formData.dob != null ? formData.dob : '<fmt:formatDate value="${user.dob}" pattern="yyyy-MM-dd" />'}" required>
                                <p class="form-help-text">Students must be older than 10 years. Teachers must be older than 20 years.</p>
                            </div>

                            <div class="form-group">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="${formData.phone != null ? formData.phone : user.phoneNumber}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" id="address" name="address" class="form-control" value="${formData.address != null ? formData.address : user.address}">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="roleId" class="form-label">Role<span class="required">*</span></label>
                                <select id="roleId" name="roleId" class="form-control" required readonly>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.id}" ${formData.roleId != null ? (formData.roleId eq role.id ? 'selected' : '') : (user.role.id eq role.id ? 'selected' : '')}>${role.name}</option>
                                    </c:forEach>
                                </select>
                                <p class="form-help-text">Only Student and Teacher roles are available.</p>
                            </div>

                            <div class="form-group">
                                <label for="statusId" class="form-label">Status<span class="required">*</span></label>
                                <select id="statusId" name="statusId" class="form-control" required>
                                    <c:forEach var="status" items="${statuses}">
                                        <option value="${status.id}" ${formData.statusId != null ? (formData.statusId eq status.id ? 'selected' : '') : (user.status.id eq status.id ? 'selected' : '')}>${status.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="countryId" class="form-label">Country<span class="required">*</span></label>
                                <select id="countryId" name="countryId" class="form-control" required>
                                    <c:forEach var="country" items="${countries}">
                                        <option value="${country.id}" ${formData.countryId != null ? (formData.countryId eq country.id ? 'selected' : '') : (user.country.id eq country.id ? 'selected' : '')}>${country.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-outline">Cancel</a>
                            <button type="submit" class="btn btn-primary">Update User</button>
                        </div>
                    </form>
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
    </body>
</html>
