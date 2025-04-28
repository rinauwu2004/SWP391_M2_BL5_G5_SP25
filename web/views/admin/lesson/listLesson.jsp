<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>   
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lesson Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 1200px;
                margin: 20px auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .title h1 {
                margin: 0;
                font-size: 24px;
                display: inline-block;
            }

            .title .code {
                display: block;
                font-size: 14px;
                color: #666;
            }

            .add-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
            }

            .add-btn:hover {
                background-color: #0056b3;
            }

            .filter-section {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .search-bar {
                flex: 1;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }

            .filter {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }

            .lesson-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }

            .lesson-table th,
            .lesson-table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            .lesson-table th {
                background-color: #f9f9f9;
                font-weight: bold;
            }

            .status {
                padding: 5px 10px;
                border-radius: 12px;
                font-size: 12px;
            }

            .status.active {
                background-color: #d4edda;
                color: #155724;
            }

            .status.inactive {
                background-color: #f8d7da;
                color: #721c24;
            }

            .action-btn {
                background: none;
                border: none;
                cursor: pointer;
                margin-right: 5px;
                font-size: 16px;
            }

            .view-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 12px;
            }

            .view-btn:hover {
                background-color: #0056b3;
            }

            .pagination {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 14px;
            }

            .page-controls button {
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                padding: 5px 10px;
                margin: 0 2px;
                cursor: pointer;
                border-radius: 5px;
            }

            .page-controls button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .page-controls button:hover {
                background-color: #e9ecef;
            }
            .notification {
                position: absolute;
                top: 20px;
                right: 20px;
                color: #333;
                padding: 15px;
                z-index: 1000;
            }
        </style>
    </head>
    <body>
        
        
         <div class="notification">
            <c:import url="../../../notification.jsp" />
        </div>

        <div class="container">
            <div class="header">
                <div class="title">
                    <h1>Lesson</h1>
                    <span class="code">SWP391</span>
                </div>
                <a href="lesson-create?subjectId=${param.id}" class="add-btn">
                    + Add New Lesson

                </a>

            </div>

            <form action="viewLesson" method="get" class="filter-section">
                <input name="id" value="${param.id}" hidden="">
                <input type="text" name="search" placeholder="Search lessons..." class="search-bar">
                <select name="status" class="filter">
                    <option value="">Filter by Status</option> 
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                </select>
                <button type="submit">Apply</button>
            </form>


            <table class="lesson-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="lesson" items="${listLesson}">
                        <tr>
                            <td>LSN${lesson.id}</td>
                            <td>${lesson.name}</td>
                            <td>
                                <span class="status ${lesson.status == 1 ? 'active' : 'inactive'}">
                                    ${lesson.status == 1 ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                            <td>
                                <a href="lesson-view-detail?id=${lesson.id}">
                                    <button class="action-btn"><i class="fas fa-eye"></i></button>
                                </a>
                                <a href="lesson-edit?id=${lesson.id}">
                                    <button class="action-btn"><i class="fas fa-pen text-success"></i></button>
                                </a>
<button class="action-btn text-danger" onclick="confirmDelete(${lesson.id})">
        <i class="fas fa-trash"></i>
    </button>

                                <a href="module-list?id=${lesson.id}">
                                    <button class="view-btn">View Module</button>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                </tbody>
            </table>

            <div class="pagination">
                <span>Page ${currentPage} of ${totalPages}</span>
                <div class="page-controls">
                    <c:if test="${currentPage > 1}">
                        <a href="viewLesson?id=${idParam}&search=${search}&status=${status}&page=${currentPage - 1}">
                            <button>&lt;</button>
                        </a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="viewLesson?id=${idParam}&search=${search}&status=${status}&page=${i}">
                            <button class="${i == currentPage ? 'active' : ''}">${i}</button>
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="viewLesson?id=${idParam}&search=${search}&status=${status}&page=${currentPage + 1}">
                            <button>&gt;</button>
                        </a>
                    </c:if>
                </div>
            </div>
                
                
                
                
                
                <script>
    function confirmDelete(lessonId) {
        if (confirm("Are you sure you want to delete this lesson?")) {
            // Nếu người dùng xác nhận, tiến hành xóa
            window.location.href = "lesson-delete?id=" + lessonId +"&subjectId=${param.id}";
        }
    }
</script>


        </div>
    </body>
</html>