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
    <body class="">
        <c:import url="../sidebar.jsp" />
        <div class="notification">
            <c:import url="../../../notification.jsp" />
        </div>
        <main class="main-content">
            <div class="container">
                <h3 class="mb-4">Subject Management</h3>
                <form action="list-subject" method="get">
                    <div class="d-flex justify-content-between mb-3">
                        <input type="text" name="search" value="${search}" class="form-control w-50" placeholder="Search subjects...">
                        <select name="status" class="form-select w-25">
                            <option value="">Status Filter</option>
                            <option value="1" ${status == '1' ? 'selected' : ''}>Active</option>
                            <option value="0" ${status == '0' ? 'selected' : ''}>Inactive</option>
                        </select>


                        <div>
                            <button type="submit" class="btn btn-success me-2">Search</button>


                            <a href="addSubject" class="btn btn-primary">+ Add Subject</a>
                        </div>
                    </div>
                </form>


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
                                    <!-- Nút Xóa -->
                                    <a href="#" class="delete-btn" data-id="${s.id}" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal">
                                        <i class="bi bi-trash text-danger"></i>
                                    </a>

                                    <a href="viewLesson?id=${s.id}&name=${s.code}" class="btn btn-outline-primary btn-sm">
                                        <i class="bi bi-journal-bookmark-fill"></i> View Lesson
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>




                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


                <!-- Modal Xác nhận Xóa -->
                <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <form action="deleteSubject" method="get">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="deleteConfirmLabel">Confirm Deletion</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <div class="modal-body">
                                    Are you sure you want to delete subject with ID = <span id="subjectIdToDelete"></span>?
                                    <input type="hidden" name="id" id="subjectIdInput">
                                </div>

                                <div class="modal-footer">
                                    <a href="list-subject">
                                        <button type="button" class="btn btn-secondary" >Cancel</button>

                                    </a>
                                    <button type="submit" class="btn btn-danger">Delete</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const deleteButtons = document.querySelectorAll('.delete-btn');

                        deleteButtons.forEach(button => {
                            button.addEventListener('click', function (e) {
                                e.preventDefault();
                                const id = this.getAttribute('data-id');

                                if (id) {
                                    document.getElementById('subjectIdToDelete').textContent = id;

                                    document.getElementById('subjectIdInput').value = id;

                                    const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                                    modal.show();
                                }
                            });
                        });
                    });

                </script>




                <!-- Pagination -->
                <!-- Pagination -->
                <nav>
                    <style>
nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.btn-back {
    margin-right: 10px;
}
.pagination {
    margin-bottom: 0;
}
</style>

                    <a href="subjectmanager/home" class="btn btn-back">← Back to Home</a>
                    <ul class="pagination justify-content-end">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}">«</a>
                            </li>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${param.search}&status=${param.status}">${i}</a>
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
        </div>
        <!-- Bootstrap Icons CDN -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        </body>
        </html>
