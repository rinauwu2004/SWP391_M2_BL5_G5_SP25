<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="vn.edu.fpt.model.User"%>
<%@page import="vn.edu.fpt.model.Role"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole_name().equals("Admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    List<User> users = (List<User>) request.getAttribute("users");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    String search = (String) request.getAttribute("search");
    String roleFilter = (String) request.getAttribute("roleFilter");
    String statusFilter = (String) request.getAttribute("statusFilter");
    List<Role> roles = (List<Role>) request.getAttribute("roles");
    
    // Calculate the starting index for STT (sequence number)
    int startIndex = (currentPage - 1) * 10 + 1;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Management - QuizOnline</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-management.css">
    </head>
    <body>
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <h3>Quiz<span>Online</span></h3>
            </div>
            <div class="sidebar-menu">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="menu-item active">
                    <i class="fas fa-users"></i>
                    <span>User Management</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reports & Analytics</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-cog"></i>
                    <span>System Settings</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
        <div class="content-wrapper" id="content">
            <div class="topbar">
                <button id="sidebarToggle" class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
                <div class="search-bar">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search...">
                </div>
                <div class="user-profile">
                    <img src="https://ui-avatars.com/api/?name=<%=user.getFirst_name()%>+<%=user.getLast_name()%>&background=3498db&color=fff" alt="Profile">
                    <div class="user-info">
                        <span class="user-name"><%=user.getFirst_name()%> <%=user.getLast_name()%></span>
                        <span class="user-role"><%=user.getRole_name()%></span>
                    </div>
                </div>
            </div>
            <main>
                <div class="page-header">
                    <div>
                        <h1>User Management</h1>
                        <ul class="breadcrumb">
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                            <li>User Management</li>
                        </ul>
                    </div>
                    <button onclick="openModal()" class="btn-create">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </div>
                <% if (session.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= session.getAttribute("message") %>
                    <% session.removeAttribute("message"); %>
                </div>
                <% } %>
                <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= session.getAttribute("error") %>
                    <% session.removeAttribute("error"); %>
                </div>
                <% } %>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">User List</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/users" method="get" class="search-filters">
                            <div class="filter-group">
                                <label for="search">Search</label>
                                <input type="text" id="search" name="search" placeholder="Name, email or username..." class="filter-input" value="<%= search != null ? search : "" %>">
                            </div>
                            <div class="filter-group">
                                <label for="roleFilter">Role</label>
                                <select id="roleFilter" name="roleFilter" class="filter-select">
                                    <option value="" <%= roleFilter == null || roleFilter.isEmpty() ? "selected" : "" %>>All Roles</option>
                                    <% if (roles != null) { 
                                        for (Role r : roles) { %>
                                            <option value="<%= r.getId() %>" <%= roleFilter != null && roleFilter.equals(String.valueOf(r.getId())) ? "selected" : "" %>><%= r.getName() %></option>
                                        <% }
                                    } %>
                                </select>
                            </div>
                            <div class="filter-group">
                                <label for="statusFilter">Status</label>
                                <select id="statusFilter" name="statusFilter" class="filter-select">
                                    <option value="" <%= statusFilter == null || statusFilter.isEmpty() ? "selected" : "" %>>All Status</option>
                                    <option value="Active" <%= "Active".equals(statusFilter) ? "selected" : "" %>>Active</option>
                                    <option value="Inactive" <%= "Inactive".equals(statusFilter) ? "selected" : "" %>>Inactive</option>
                                    <option value="Suspend" <%= "Suspend".equals(statusFilter) ? "selected" : "" %>>Suspended</option>
                                </select>
                            </div>
                            <div class="filter-actions">
                                <button type="submit" class="btn-filter">
                                    <i class="fas fa-filter"></i> Apply Filters
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn-clear">
                                    <i class="fas fa-times"></i> Clear
                                </a>
                            </div>
                        </form>
                        <div class="table-container">
                            <table class="user-table">
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">STT</th>
                                        <th>Full Name</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th style="width: 100px; text-align: center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (users != null && !users.isEmpty()) { %>
                                        <% for (int i = 0; i < users.size(); i++) { %>
                                            <% User u = users.get(i); %>
                                            <tr>
                                                <td><%= startIndex + i %></td>
                                                <td class="user-name"><%= u.getFirst_name() %> <%= u.getLast_name() %></td>
                                                <td><%= u.getUsername() %></td>
                                                <td class="user-email"><%= u.getEmail_address() %></td>
                                                <td class="user-phone"><%= u.getPhone_number() != null ? u.getPhone_number() : "-" %></td>
                                                <td>
                                                    <div class="role-badges">
                                                        <%
                                                        String[] userRolesList = u.getRole_name().split(", ");
                                                        for (String role : userRolesList) {
                                                        %>
                                                            <span class="role-badge" data-role="<%= role %>"><%= role %></span>
                                                        <%
                                                        }
                                                        %>
                                                    </div>
                                                </td>
                                                <td>
                                                    <% if ("Active".equalsIgnoreCase(u.getStatus_name())) { %>
                                                        <span class="status-badge status-active">Active</span>
                                                    <% } else if ("Inactive".equalsIgnoreCase(u.getStatus_name())) { %>
                                                        <span class="status-badge status-inactive">Inactive</span>
                                                    <% } else { %>
                                                        <span class="status-badge status-suspended">Suspended</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=<%= u.getId() %>" class="btn-icon btn-edit" title="Edit">
                                                            <i class="fas fa-pencil-alt"></i>
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="toggleStatus">
                                                            <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                            <input type="hidden" name="newStatus" value="<%= "Active".equalsIgnoreCase(u.getStatus_name()) ? "Inactive" : "Active" %>">
                                                            <input type="hidden" name="page" value="<%= currentPage %>">
                                                            <input type="hidden" name="search" value="<%= search != null ? search : "" %>">
                                                            <input type="hidden" name="roleFilter" value="<%= roleFilter != null ? roleFilter : "" %>">
                                                            <input type="hidden" name="statusFilter" value="<%= statusFilter != null ? statusFilter : "" %>">
                                                            <% if ("Active".equalsIgnoreCase(u.getStatus_name())) { %>
                                                                <button type="submit" class="btn-icon btn-ban" title="Deactivate User">
                                                                    <i class="fas fa-ban"></i>
                                                                </button>
                                                            <% } else { %>
                                                                <button type="submit" class="btn-icon btn-activate" title="Activate User">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                            <% } %>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="8" class="no-data">
                                                <i class="fas fa-user-slash"></i>
                                                No users found with the specified criteria.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% if (totalPages > 1) { %>
                            <ul class="pagination">
                                <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage - 1 %><%= search != null && !search.isEmpty() ? "&search=" + search : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&roleFilter=" + roleFilter : "" %><%= statusFilter != null && !statusFilter.isEmpty() ? "&statusFilter=" + statusFilter : "" %>">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <% for (int i = 1; i <= totalPages; i++) { %>
                                    <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=<%= i %><%= search != null && !search.isEmpty() ? "&search=" + search : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&roleFilter=" + roleFilter : "" %><%= statusFilter != null && !statusFilter.isEmpty() ? "&statusFilter=" + statusFilter : "" %>">
                                            <%= i %>
                                        </a>
                                    </li>
                                <% } %>
                                <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage + 1 %><%= search != null && !search.isEmpty() ? "&search=" + search : "" %><%= roleFilter != null && !roleFilter.isEmpty() ? "&roleFilter=" + roleFilter : "" %><%= statusFilter != null && !statusFilter.isEmpty() ? "&statusFilter=" + statusFilter : "" %>">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        <% } %>
                    </div>
                </div>
            </main>
            <!-- Create Account Modal -->
            <div id="createAccountModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2 class="modal-title"><i class="fas fa-user-plus"></i> Create New Account</h2>
                        <button type="button" class="modal-close" onclick="closeModal()">&times;</button>
                    </div>
                    <form id="createAccountForm" action="${pageContext.request.contextPath}/addusers" method="post">
                        <div class="modal-body">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="firstName" class="required-field">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                                </div>
                                <div class="form-group">
                                    <label for="lastName" class="required-field">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="username" class="required-field">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                                <small>Choose a unique username for login</small>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="email" class="required-field">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                    <small>Choose a unique email for login</small>
                                </div>
                                <div class="form-group">
                                    <label for="dateOfBirth" class="required-field">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="password" class="required-field">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required minlength="6">
                                <small>Password must be at least 6 characters long</small>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="phone" class="required-field">Phone Number</label>
                                    <input type="text" class="form-control" id="phone" name="phone" required>
                                </div>
                                <div class="form-group">
                                    <label for="address">Address</label>
                                    <input type="text" class="form-control" id="address" name="address">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="required-field">Role(s)</label>
                                <div class="role-selection-container">
                                    <% if (roles != null) { 
                                        for (Role r : roles) { 
                                            // Skip Admin role (role_id = 1)
                                            if (r.getId() != 1) { %>
                                                <div class="role-option">
                                                    <input type="checkbox" id="role<%= r.getId() %>" name="roleIds" value="<%= r.getId() %>" class="role-checkbox">
                                                    <label for="role<%= r.getId() %>" class="role-label <%= r.getName().replace(" ", "").toLowerCase() %>-role">
                                                        <i class="role-icon fas 
                                                            <% if (r.getName().equals("Teacher")) { %>fa-chalkboard-teacher
                                                            <% } else if (r.getName().equals("Student")) { %>fa-user-graduate
                                                            <% } else if (r.getName().equals("Subject Manager")) { %>fa-tasks
                                                            <% } else { %>fa-user-tie<% } %>">
                                                        </i>
                                                        <%= r.getName() %>
                                                    </label>
                                                </div>
                                            <% }
                                        }
                                    } %>
                                </div>
                                <small>Select at least one role for the user</small>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Create Account</button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- Loading Overlay -->
            <div id="loadingOverlay" class="loading-overlay">
                <div class="spinner"></div>
            </div>
        </div>
        
        <script src="${pageContext.request.contextPath}/js/admin-common.js"></script>
        <script src="${pageContext.request.contextPath}/js/user-management.js"></script>
    </body>
</html>
