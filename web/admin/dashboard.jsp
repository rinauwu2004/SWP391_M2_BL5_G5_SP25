<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="vn.edu.fpt.model.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole_name().equals("Admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - QuizOnline</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
    </head>
    <body>
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <h3>Quiz<span>Online</span></h3>
            </div>
            
            <div class="sidebar-menu">
                <a href="#" class="menu-item active">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="menu-item ">
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
                    <h1>Dashboard</h1>
                    <ul class="breadcrumb">
                        <li><a href="#">Home</a></li>
                        <li>Dashboard</li>
                    </ul>
                </div>
                
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon stat-users">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-details">
                            <h3>845</h3>
                            <p>Total Users</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon stat-quizzes">
                            <i class="fas fa-question-circle"></i>
                        </div>
                        <div class="stat-details">
                            <h3>156</h3>
                            <p>Total Quizzes</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon stat-subjects">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-details">
                            <h3>42</h3>
                            <p>Active Subjects</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon stat-results">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div class="stat-details">
                            <h3>2,830</h3>
                            <p>Quiz Attempts</p>
                        </div>
                    </div>
                </div>
                
                <div class="data-section">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Recent Quiz Results</h3>
                            <button class="btn-more">
                                View All <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                        <div class="card-body">
                            <table class="recent-table">
                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Quiz</th>
                                        <th>Score</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>John Smith</td>
                                        <td>Java Programming Basics</td>
                                        <td>85%</td>
                                        <td><span class="badge badge-success">Passed</span></td>
                                        <td>15 Apr 2023</td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn-icon btn-view"><i class="fas fa-eye"></i></button>
                                                <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
                                                <button class="btn-icon btn-delete"><i class="fas fa-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Sarah Johnson</td>
                                        <td>Database Design</td>
                                        <td>92%</td>
                                        <td><span class="badge badge-success">Passed</span></td>
                                        <td>14 Apr 2023</td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn-icon btn-view"><i class="fas fa-eye"></i></button>
                                                <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
                                                <button class="btn-icon btn-delete"><i class="fas fa-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Michael Brown</td>
                                        <td>Web Development</td>
                                        <td>68%</td>
                                        <td><span class="badge badge-warning">Average</span></td>
                                        <td>14 Apr 2023</td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn-icon btn-view"><i class="fas fa-eye"></i></button>
                                                <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
                                                <button class="btn-icon btn-delete"><i class="fas fa-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Emily Davis</td>
                                        <td>Network Security</td>
                                        <td>45%</td>
                                        <td><span class="badge badge-danger">Failed</span></td>
                                        <td>13 Apr 2023</td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn-icon btn-view"><i class="fas fa-eye"></i></button>
                                                <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
                                                <button class="btn-icon btn-delete"><i class="fas fa-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>David Wilson</td>
                                        <td>Software Engineering</td>
                                        <td>78%</td>
                                        <td><span class="badge badge-success">Passed</span></td>
                                        <td>12 Apr 2023</td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn-icon btn-view"><i class="fas fa-eye"></i></button>
                                                <button class="btn-icon btn-edit"><i class="fas fa-pencil-alt"></i></button>
                                                <button class="btn-icon btn-delete"><i class="fas fa-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Quick Actions</h3>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions">
                                <a href="#" class="action-btn">
                                    <div class="action-icon action-users">
                                        <i class="fas fa-user-plus"></i>
                                    </div>
                                    <div class="action-text">
                                        <h4>Add New User</h4>
                                        <p>Create accounts for students, teachers</p>
                                    </div>
                                </a>
                                
                                <a href="#" class="action-btn">
                                    <div class="action-icon action-quizzes">
                                        <i class="fas fa-plus-circle"></i>
                                    </div>
                                    <div class="action-text">
                                        <h4>Create New Quiz</h4>
                                        <p>Design questions and set parameters</p>
                                    </div>
                                </a>
                                
                                <a href="#" class="action-btn">
                                    <div class="action-icon action-subjects">
                                        <i class="fas fa-book-medical"></i>
                                    </div>
                                    <div class="action-text">
                                        <h4>Add New Subject</h4>
                                        <p>Set up a new course or subject</p>
                                    </div>
                                </a>
                                
                                <a href="#" class="action-btn">
                                    <div class="action-icon action-quizzes">
                                        <i class="fas fa-file-export"></i>
                                    </div>
                                    <div class="action-text">
                                        <h4>Export Reports</h4>
                                        <p>Download statistics and data</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
        
        <script src="${pageContext.request.contextPath}/js/admin-dashboard.js"></script>
    </body>
</html>
