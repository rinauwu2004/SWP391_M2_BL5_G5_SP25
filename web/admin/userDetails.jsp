<%-- 
    Document   : userDetails
    Created on : Apr 20, 2025, 9:27:26 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="vn.edu.fpt.model.User"%>
<%@page import="vn.edu.fpt.model.Role"%>
<%@page import="vn.edu.fpt.model.UserStatus"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole_name().equals("Admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    User userDetails = (User) request.getAttribute("userDetails");
    List<Role> roles = (List<Role>) request.getAttribute("roles");
    List<Integer> userRoleIds = (List<Integer>) request.getAttribute("userRoleIds");
    List<UserStatus> statuses = (List<UserStatus>) request.getAttribute("statuses");
    
    // Format date of birth
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String dobFormatted = "";
    if (userDetails != null && userDetails.getDate_of_birth() != null) {
        dobFormatted = dateFormat.format(userDetails.getDate_of_birth());
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit User - QuizOnline</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-details.css">
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
                        <h1>Edit User</h1>
                        <ul class="breadcrumb">
                            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
                            <li>Edit User</li>
                        </ul>
                    </div>
                </div>
                
                <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <%= session.getAttribute("error") %>
                        <% session.removeAttribute("error"); %>
                    </div>
                </div>
                <% } %>
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-user-edit"></i> User Information</h3>
                    </div>
                    <div class="card-body">
                        <form id="editUserForm" action="${pageContext.request.contextPath}/admin/users/edit" method="post">
                            <input type="hidden" name="userId" value="<%= userDetails.getId() %>">
                            
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="firstName" class="required-field">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" value="<%= userDetails.getFirst_name() %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="lastName" class="required-field">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" value="<%= userDetails.getLast_name() %>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="username" class="required-field">Username</label>
                                <div class="input-wrapper">
                                    <input type="text" class="form-control restricted-field" id="username" name="username" 
                                           value="<%= userDetails.getUsername() %>" required readonly>
                                    <i class="fas fa-lock restricted-field-icon"></i>
                                </div>
                                <small>Unique username for login. Click to edit (requires confirmation).</small>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="email" class="required-field">Email Address</label>
                                    <div class="input-wrapper">
                                        <input type="email" class="form-control restricted-field" id="email" name="email" 
                                               value="<%= userDetails.getEmail_address() %>" required readonly>
                                        <i class="fas fa-lock restricted-field-icon"></i>
                                    </div>
                                    <small>Email address used for notifications. Click to edit (requires confirmation).</small>
                                </div>
                                <div class="form-group">
                                    <label for="dateOfBirth" class="required-field">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="<%= dobFormatted %>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" class="form-control" id="password" name="password" minlength="6">
                                <small>Leave blank to keep current password. New password must be at least 6 characters.</small>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="phone" class="required-field">Phone Number</label>
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control restricted-field" id="phone" name="phone" 
                                               value="<%= userDetails.getPhone_number() %>" required readonly>
                                        <i class="fas fa-lock restricted-field-icon"></i>
                                    </div>
                                    <small>Contact phone number. Click to edit (requires confirmation).</small>
                                </div>
                                <div class="form-group">
                                    <label for="address">Address</label>
                                    <input type="text" class="form-control" id="address" name="address" value="<%= userDetails.getAddress() != null ? userDetails.getAddress() : "" %>">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="statusId" class="required-field">Status</label>
                                <select class="form-control" id="statusId" name="statusId" required>
                                    <option value="1" <%= userDetails.getStatus_id() == 1 ? "selected" : "" %>>Active</option>
                                    <option value="2" <%= userDetails.getStatus_id() == 2 ? "selected" : "" %>>Inactive</option>
                                    <option value="3" <%= userDetails.getStatus_id() == 3 ? "selected" : "" %>>Suspended</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="required-field">Role(s)</label>
                                <div class="role-selection-container">
                                    <% if (roles != null) { 
                                        for (Role r : roles) { 
                                            // Skip Admin role (role_id = 1)
                                            if (r.getId() != 1) { 
                                                boolean isChecked = userRoleIds != null && userRoleIds.contains(r.getId());
                                            %>
                                                <div class="role-option">
                                                    <input type="checkbox" id="role<%= r.getId() %>" name="roleIds" value="<%= r.getId() %>" 
                                                            class="role-checkbox" <%= isChecked ? "checked" : "" %>>
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
                            
                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
            
            <div id="confirmEditModal" class="modal-confirm">
                <div class="modal-confirm-content">
                    <div class="modal-confirm-header">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h2 class="modal-confirm-title">Confirm Edit</h2>
                    </div>
                    <div class="modal-confirm-body">
                        <p id="confirmModalText">Are you sure you want to edit this field?</p>
                        <p>This information is used for identity verification.</p>
                    </div>
                    <div class="modal-confirm-footer">
                        <button type="button" class="btn btn-secondary btn-modal" id="cancelEditBtn">Cancel</button>
                        <button type="button" class="btn btn-primary btn-modal" id="confirmEditBtn">Yes, Edit</button>
                    </div>
                </div>
            </div>
            
            <div id="loadingOverlay" class="loading-overlay">
                <div class="spinner"></div>
            </div>
        </div>
        
        <script src="${pageContext.request.contextPath}/js/admin-common.js"></script>
        <script src="${pageContext.request.contextPath}/js/user-details.js"></script>
    </body>
</html>
