<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Subject Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <style>
            .status-active {
                background-color: #d4edda;
                color: #155724;
                padding: 2px 8px;
                border-radius: 10px;
                font-size: 0.9rem;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
                padding: 2px 8px;
                border-radius: 10px;
                font-size: 0.9rem;
            }
            .action-icons i {
                margin: 0 5px;
                cursor: pointer;
            }
        </style>
    </head>
    <body class="p-4">
            <h3 class="mb-4">Subject Management</h3>
            <div class="d-flex justify-content-between mb-3">
                <input type="text" class="form-control w-50" place holder="Search subjects...">
                <select class="form-select w-25">
                    <option>Status Filter</option>
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                </select>
                <a href="addSubject" class="btn btn-primary">+ Add Subject</a>
            </div>

            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Code</th>
                        <th>Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${listSubject}">
                        <tr>
                            <td>${s.id}</td>
                            <td>${s.code}</td>
                            <td>${s.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${s.status}">
                                        <span class="status-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="action-icons">
                                <a href="viewSubject?id=${s.id}"><i class="bi bi-eye"></i></a>
                                <a href="editSubject?id=${s.id}"><i class="bi bi-pencil-square text-success"></i></a>
                                <a href="deleteSubject?id=${s.id}" onclick="return confirm('Are you sure?')">
                                    <i class="bi bi-trash text-danger"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination -->
            <!-- Pagination -->
            <nav>
                <ul class="pagination justify-content-end">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}">«</a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}">»</a>
                        </li>
                    </c:if>
                </ul>
            </nav>

        </div>

        <!-- Bootstrap Icons CDN -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    </body>
</html>
