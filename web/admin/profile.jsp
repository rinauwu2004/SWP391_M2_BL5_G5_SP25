<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Profile - QuizMaster</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() + "/css/styles.css" %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fb;
                color: #333;
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar Styles */
            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: #ecf0f1;
                display: flex;
                flex-direction: column;
                position: fixed;
                height: 100vh;
                overflow-y: auto;
                transition: all 0.3s ease;
            }

            .sidebar-header {
                padding: 20px;
                background-color: #1a2530;
                text-align: center;
            }

            .logo {
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                color: #ecf0f1;
                font-size: 1.5rem;
                font-weight: bold;
            }

            .logo-icon {
                margin-right: 10px;
                font-size: 1.8rem;
                color: #3498db;
            }

            .user-info {
                display: flex;
                align-items: center;
                padding: 20px;
                border-bottom: 1px solid #34495e;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #3498db;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
            }

            .user-details {
                flex: 1;
            }

            .user-name {
                font-weight: bold;
                font-size: 0.9rem;
            }

            .user-role {
                font-size: 0.8rem;
                color: #bdc3c7;
            }

            .sidebar-menu {
                padding: 20px 0;
                flex: 1;
            }

            .menu-label {
                padding: 0 20px;
                margin-bottom: 10px;
                font-size: 0.8rem;
                color: #bdc3c7;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .sidebar-menu ul {
                list-style: none;
            }

            .sidebar-menu li {
                margin-bottom: 5px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                text-decoration: none;
                color: #ecf0f1;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .sidebar-menu a:hover {
                background-color: #34495e;
            }

            .sidebar-menu a.active {
                background-color: #3498db;
                color: #fff;
                border-left: 4px solid #2980b9;
            }

            .menu-icon {
                margin-right: 10px;
                width: 20px;
                text-align: center;
            }

            /* Main Content Styles */
            .main-content {
                flex: 1;
                margin-left: 250px;
                padding: 20px;
                transition: all 0.3s ease;
            }

            /* Header Styles */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                background-color: #fff;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .page-title {
                font-size: 1.5rem;
                font-weight: bold;
                color: #2c3e50;
            }

            .header-actions {
                display: flex;
                gap: 10px;
            }

            .btn {
                padding: 8px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .btn-primary {
                background-color: #3498db;
                color: white;
            }

            .btn-primary:hover {
                background-color: #2980b9;
            }

            .btn-secondary {
                background-color: #ecf0f1;
                color: #2c3e50;
            }

            .btn-secondary:hover {
                background-color: #bdc3c7;
            }

            /* Profile Card Styles */
            .profile-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .profile-header {
                background-color: #3498db;
                color: white;
                padding: 20px;
                text-align: center;
                position: relative;
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                background-color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 15px;
                border: 4px solid rgba(255, 255, 255, 0.3);
                font-size: 3rem;
                color: #3498db;
            }

            .profile-name {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 5px;
            }

            .profile-role {
                font-size: 1rem;
                opacity: 0.9;
            }

            .profile-content {
                padding: 20px;
            }

            /* Form Styles */
            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 0.9rem;
                transition: border-color 0.3s ease;
            }

            .form-control:focus {
                border-color: #3498db;
                outline: none;
            }

            .form-row {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
            }

            .form-col {
                flex: 1;
            }

            .required::after {
                content: " *";
                color: #e74c3c;
            }

            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 30px;
            }

            /* Password Section Styles */
            .password-section {
                margin-top: 30px;
                border-top: 1px solid #eee;
                padding-top: 30px;
            }

            .section-title {
                font-size: 1.2rem;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 20px;
            }

            /* Alert Styles */
            .alert {
                padding: 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-success {
                background-color: #e8f7f0;
                color: #27ae60;
                border-left: 4px solid #27ae60;
            }

            .alert-error {
                background-color: #f8eae7;
                color: #e74c3c;
                border-left: 4px solid #e74c3c;
            }

            .alert-icon {
                font-size: 1.2rem;
            }

            .alert-message {
                flex: 1;
            }

            .alert-close {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 1.2rem;
                color: inherit;
                opacity: 0.7;
            }

            .alert-close:hover {
                opacity: 1;
            }

            /* Responsive Styles */
            @media (max-width: 768px) {
                .sidebar {
                    width: 70px;
                }

                .logo-text,
                .user-details,
                .menu-label {
                    display: none;
                }

                .main-content {
                    margin-left: 70px;
                }

                .sidebar-menu a {
                    justify-content: center;
                    padding: 15px;
                }

                .menu-icon {
                    margin-right: 0;
                }

                .user-info {
                    justify-content: center;
                }

                .user-avatar {
                    margin-right: 0;
                }

                .form-row {
                    flex-direction: column;
                    gap: 0;
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
                        <a href="<%=request.getContextPath()%>/admin/home">
                            <span class="menu-icon"><i class="fas fa-tachometer-alt"></i></span>
                            Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/users">
                            <span class="menu-icon"><i class="fas fa-users"></i></span>
                            Users
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/quizzes">
                            <span class="menu-icon"><i class="fas fa-clipboard-list"></i></span>
                            Quizzes
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/subjects">
                            <span class="menu-icon"><i class="fas fa-book"></i></span>
                            Subjects
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/reports">
                            <span class="menu-icon"><i class="fas fa-chart-bar"></i></span>
                            Reports
                        </a>
                    </li>
                </ul>

                <div class="menu-label">Account</div>
                <ul>
                    <li>
                        <a href="<%=request.getContextPath()%>/admin/profile" class="active">
                            <span class="menu-icon"><i class="fas fa-user-cog"></i></span>
                            Profile
                        </a>
                    </li>
                    <li>
                        <a href="<%=request.getContextPath()%>/signout">
                            <span class="menu-icon"><i class="fas fa-sign-out-alt"></i></span>
                            Sign Out
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <div class="header">
                <h1 class="page-title">My Profile</h1>
                <div class="header-actions">
                    <a href="<%=request.getContextPath()%>/admin/home" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success">
                    <div class="alert-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="alert-message">${sessionScope.message}</div>
                    <button class="alert-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
                <c:remove var="message" scope="session" />
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <div class="alert-icon"><i class="fas fa-exclamation-circle"></i></div>
                    <div class="alert-message">${error}</div>
                    <button class="alert-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:if>

            <!-- Profile Card -->
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2 class="profile-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</h2>
                    <p class="profile-role">${sessionScope.user.role.name}</p>
                </div>

                <div class="profile-content">
                    <form action="<%=request.getContextPath()%>/admin/profile" method="post">
                        <!-- Personal Information -->
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="firstName" class="form-label required">First Name</label>
                                    <input type="text" id="firstName" name="firstName" class="form-control" value="${formData.firstName}" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="lastName" class="form-label required">Last Name</label>
                                    <input type="text" id="lastName" name="lastName" class="form-control" value="${formData.lastName}" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" id="email" class="form-control" value="${formData.email}" disabled>
                            <small>Email address cannot be changed</small>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="dob" class="form-label required">Date of Birth</label>
                                    <input type="date" id="dob" name="dob" class="form-control" value="${formData.dob}" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" class="form-control" value="${formData.phone}">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" id="address" name="address" class="form-control" value="${formData.address}">
                        </div>

                        <div class="form-group">
                            <label for="countryId" class="form-label required">Country</label>
                            <select id="countryId" name="countryId" class="form-control" required>
                                <c:forEach var="country" items="${countries}">
                                    <option value="${country.id}" ${formData.countryId eq country.id.toString() ? 'selected' : ''}>${country.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                       
                        <div class="form-actions">
                            <button type="reset" class="btn btn-secondary">
                                <i class="fas fa-undo"></i> Reset
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <script>
            // Close alert messages after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    alert.style.display = 'none';
                });
            }, 5000);
        </script>
    </body>
</html>
