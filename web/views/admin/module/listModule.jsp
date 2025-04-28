<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Module Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
        <style>
            .action-icons i {
                margin: 0 5px;
                cursor: pointer;
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
    <body class="p-4">

        <div class="notification">
            <c:import url="../../../notification.jsp" />
        </div>

        <div class="container">
            <h3 class="mb-4">Module Management (Lesson: ${lessonName})</h3>

            <form action="module-list" method="get">
                <input type="hidden" name="id" value="${lessonId}" />
                <div class="d-flex justify-content-between mb-3">
                    <input type="text" name="search" value="${search}" class="form-control w-50" placeholder="Search modules...">
                    <div>
                        <button type="submit" class="btn btn-success me-2">Search</button>
                        <a href="addModule?lessonId=${lessonId}" class="btn btn-primary">+ Add Module</a>
                    </div>
                </div>
            </form>

            <!-- Table Content Here -->
            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>URL</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${listModule}">
                        <tr>
                            <td>${m.id}</td>
                            <td>${m.name}</td>
                            <td>${m.description}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty m.url}">
                                        <a href="${m.url}" target="_blank">View Content</a>
                                    </c:when>
                                    <c:otherwise>
                                        No URL
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-icons">
                                <a href="viewModule?id=${m.id}"><i class="bi bi-eye"></i></a>
                                <a href="editModule?id=${m.id}&lessonId=${param.id}"><i class="bi bi-pencil-square text-success"></i></a>
                                <a href="#" class="delete-btn" data-id="${m.id}" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal">
                                    <i class="bi bi-trash text-danger"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination -->
            <nav>
                <ul class="pagination justify-content-end">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?lessonId=${lessonId}&page=${currentPage - 1}&search=${param.search}">«</a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?lessonId=${lessonId}&page=${i}&search=${param.search}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?lessonId=${lessonId}&page=${currentPage + 1}&search=${param.search}">»</a>
                        </li>
                    </c:if>
                </ul>
            </nav>


            <!-- Delete Confirmation Modal -->
            <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <form action="deleteModule" method="get">
                            <input name="lessonId" value="${lessonId}" hidden=""> 
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteConfirmLabel">Confirm Deletion</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to delete module with ID = <span id="moduleIdToDelete"></span>?
                                <input type="hidden" name="id" id="moduleIdInput">
                            </div>
                            <div class="modal-footer">
                                <a href="list-module?id=${lessonId}">
                                    <button type="button" class="btn btn-secondary">Cancel</button>
                                </a>
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const deleteButtons = document.querySelectorAll('.delete-btn');

                    deleteButtons.forEach(button => {
                        button.addEventListener('click', function (e) {
                            e.preventDefault();
                            const id = this.getAttribute('data-id');

                            if (id) {
                                document.getElementById('moduleIdToDelete').textContent = id;
                                document.getElementById('moduleIdInput').value = id;
                                const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                                modal.show();
                            }
                        });
                    });
                });
            </script>

        </div>
    </body>
</html>
