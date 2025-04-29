<%-- 
    Document   : subjectManagement
    Created on : Apr 24, 2025, 8:58:32 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Subject"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    int currentPage = (request.getAttribute("currentPage") != null) ? (int) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null) ? (int) request.getAttribute("totalPages") : 1;
    String search = (String) request.getAttribute("search");
    int startIndex = (currentPage - 1) * 10 + 1;
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject Management - QuizOnline</title>
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
            <a href="${pageContext.request.contextPath}/admin/quizmanagement" class="menu-item">
                <i class="fas fa-question-circle"></i>
                <span>Quiz Management</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="menu-item">
                <i class="fas fa-users"></i>
                <span>User Management</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/subjectmanager" class="menu-item active">
                <i class="fas fa-book"></i>
                <span>Subject Management</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
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
        </div>
        <main>
            <div class="page-header">
                <div>
                    <h1>Subject Management</h1>
                    <ul class="breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Home</a></li>
                        <li>Subject Management</li>
                    </ul>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Subject List</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/subjectmanager" method="get" class="search-filters">
                        <div class="filter-group">
                            <label for="search">Search</label>
                            <input type="text" id="search" name="search" placeholder="Subject name..." class="filter-input" value="<%= search != null ? search : "" %>">
                        </div>
                        <div class="filter-actions">
                            <button type="submit" class="btn-filter">
                                <i class="fas fa-filter"></i> Apply Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/subjectmanager" class="btn-clear">
                                <i class="fas fa-times"></i> Clear
                            </a>
                        </div>
                    </form>
                    <div class="table-container">
                        <table class="user-table">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">STT</th>
                                    <th>ID</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (subjects != null && !subjects.isEmpty()) { %>
                                    <% for (int i = 0; i < subjects.size(); i++) { %>
                                        <% Subject s = subjects.get(i); %>
                                        <tr>
                                            <td><%= startIndex + i %></td>
                                            <td><%= s.getId() %></td>
                                            <td><%= s.getCode() %></td>
                                            <td><%= s.getName() %></td>
                                            <td>
                                                <span class="desc-short" style="cursor:pointer; color:#3498db;" onclick="this.innerText=this.getAttribute('data-full')" data-full="<%= s.getDescription() != null ? s.getDescription().replace("\"","&quot;").replace("'","&#39;") : "-" %>">
                                                    <%= (s.getDescription() != null && s.getDescription().length() > 30) ?
                                                        s.getDescription().substring(0, 30) + "..." :
                                                        (s.getDescription() != null ? s.getDescription() : "-") %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if (s.isStatus()) { %>
                                                    <span class="status-badge status-active">Active</span>
                                                <% } else { %>
                                                    <span class="status-badge status-inactive">Inactive</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="6" class="no-data">
                                            <i class="fas fa-book-dead"></i>
                                            No subjects found with the specified criteria.
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% if (totalPages > 1) { %>
                        <ul class="pagination">
                            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                                <a class="page-link" href="${pageContext.request.contextPath}/subjectmanager?page=<%= currentPage - 1 %><%= search != null && !search.isEmpty() ? "&search=" + search : "" %>">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            <% for (int i = 1; i <= totalPages; i++) { %>
                                <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                    <a class="page-link" href="${pageContext.request.contextPath}/subjectmanager?page=<%= i %><%= search != null && !search.isEmpty() ? "&search=" + search : "" %>"><%= i %></a>
                                </li>
                            <% } %>
                            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                <a class="page-link" href="${pageContext.request.contextPath}/subjectmanager?page=<%= currentPage + 1 %><%= search != null && !search.isEmpty() ? "&search=" + search : "" %>">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/admin-common.js"></script>
</body>
</html>
