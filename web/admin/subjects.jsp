<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Subject Management - QuizMaster</title>
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

            /* Search Form Styles */
            .search-form {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
                background-color: #fff;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .search-form select,
            .search-form input[type="text"] {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 0.9rem;
            }

            .search-form select {
                min-width: 150px;
            }

            .search-form input[type="text"] {
                flex: 1;
            }

            /* Subject Table Styles */
            .subject-table-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .subject-table {
                width: 100%;
                border-collapse: collapse;
            }

            .subject-table th,
            .subject-table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }

            .subject-table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #2c3e50;
            }

            .subject-table tr:hover {
                background-color: #f5f7fb;
            }

            .subject-table td:last-child {
                text-align: center;
            }

            .subject-actions {
                display: flex;
                justify-content: center;
                gap: 10px;
            }

            .action-view,
            .action-edit,
            .action-delete {
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 4px;
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .action-view {
                background-color: #3498db;
            }

            .action-view:hover {
                background-color: #2980b9;
            }

            .action-edit {
                background-color: #f39c12;
            }

            .action-edit:hover {
                background-color: #d35400;
            }

            .action-delete {
                background-color: #e74c3c;
            }

            .action-delete:hover {
                background-color: #c0392b;
            }

            /* Status Badge Styles */
            .status-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: 500;
            }

            .status-active {
                background-color: #e8f7f0;
                color: #27ae60;
            }

            .status-inactive {
                background-color: #f8eae7;
                color: #e74c3c;
            }

            /* Pagination Styles */
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
            }

            .pagination-list {
                display: flex;
                list-style: none;
                gap: 5px;
            }

            .pagination-item a,
            .pagination-item span {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 36px;
                height: 36px;
                border-radius: 4px;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .pagination-item a {
                background-color: #fff;
                color: #2c3e50;
                border: 1px solid #ddd;
            }

            .pagination-item a:hover {
                background-color: #f5f7fb;
            }

            .pagination-item.active span {
                background-color: #3498db;
                color: white;
            }

            .pagination-item.disabled span {
                background-color: #f5f7fb;
                color: #bdc3c7;
                cursor: not-allowed;
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

                .search-form {
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
                        <a href="<%=request.getContextPath()%>/admin/subjects" class="active">
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
                        <a href="<%=request.getContextPath()%>/admin/profile">
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
                <h1 class="page-title">Subject Management</h1>
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

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    <div class="alert-icon"><i class="fas fa-exclamation-circle"></i></div>
                    <div class="alert-message">${sessionScope.error}</div>
                    <button class="alert-close" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <!-- Search Form -->
            <form action="<%=request.getContextPath()%>/admin/subjects" method="post" class="search-form">
                <input type="hidden" name="action" value="search">
                <select name="searchBy" id="searchBy">
                    <option value="all" ${searchBy eq 'all' ? 'selected' : ''}>All Fields</option>
                    <option value="code" ${searchBy eq 'code' ? 'selected' : ''}>Code</option>
                    <option value="name" ${searchBy eq 'name' ? 'selected' : ''}>Name</option>
                </select>
                <input type="text" name="searchTerm" id="searchTerm" placeholder="Search subjects..." value="${searchTerm}">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
                <c:if test="${isSearch}">
                    <a href="<%=request.getContextPath()%>/admin/subjects" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Clear
                    </a>
                </c:if>
            </form>

            <!-- Subjects Table -->
            <div class="subject-table-card">
                <table class="subject-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty subjects}">
                                <tr>
                                    <td colspan="7" style="text-align: center;">No subjects found</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="subject" items="${subjects}">
                                    <tr>
                                        <td>${subject.id}</td>
                                        <td>${subject.code}</td>
                                        <td>${subject.name}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${subject.description.length() > 50}">
                                                    ${subject.description.substring(0, 50)}...
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
                                        <td><fmt:formatDate value="${subject.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td>
                                            <div class="subject-actions">
                                                <a href="<%=request.getContextPath()%>/admin/subjects?action=view&id=${subject.id}" class="action-view" title="View Subject">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <ul class="pagination-list">
                        <!-- Previous Page -->
                        <li class="pagination-item ${currentPage == 1 ? 'disabled' : ''}">
                            <c:choose>
                                <c:when test="${currentPage == 1}">
                                    <span><i class="fas fa-chevron-left"></i></span>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${isSearch}">
                                            <a href="<%=request.getContextPath()%>/admin/subjects?action=search&searchBy=${searchBy}&searchTerm=${searchTerm}&page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<%=request.getContextPath()%>/admin/subjects?page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <li class="pagination-item active">
                                        <span>${i}</span>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="pagination-item">
                                        <c:choose>
                                            <c:when test="${isSearch}">
                                                <a href="<%=request.getContextPath()%>/admin/subjects?action=search&searchBy=${searchBy}&searchTerm=${searchTerm}&page=${i}">${i}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="<%=request.getContextPath()%>/admin/subjects?page=${i}">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next Page -->
                        <li class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <c:choose>
                                <c:when test="${currentPage == totalPages}">
                                    <span><i class="fas fa-chevron-right"></i></span>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${isSearch}">
                                            <a href="<%=request.getContextPath()%>/admin/subjects?action=search&searchBy=${searchBy}&searchTerm=${searchTerm}&page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<%=request.getContextPath()%>/admin/subjects?page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </ul>
                </div>
            </c:if>
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
