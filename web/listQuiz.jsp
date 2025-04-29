<%-- 
    Document   : listQuiz
    Created on : 29 Apr 2025, 02:34:04
    Author     : Rinaaaa
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Quizzes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            }

            .back-button {
                position: absolute;
                top: 20px;
                left: 20px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #f3f4f6;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            .back-button:hover {
                background-color: #e5e7eb;
                transform: translateY(-2px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .back-button:active {
                transform: translateY(0);
            }

            .back-arrow {
                width: 10px;
                height: 10px;
                border: solid #4b5563;
                border-width: 0 2px 2px 0;
                transform: rotate(135deg);
                margin: 1px 0px 0px 3px;
            }

            .container {
                max-width: 1200px;
                margin: 40px auto;
            }

            .card {
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                border: none;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .header h1 {
                font-size: 24px;
                font-weight: 600;
                margin: 0;
            }

            .create-btn {
                background-color: #2563eb;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
            }

            .create-btn:hover {
                background-color: #1d4ed8;
            }

            .table {
                margin-bottom: 0;
            }

            .table th {
                font-weight: 500;
                color: #4b5563;
                border-bottom: 1px solid #e5e7eb;
                padding: 12px 16px;
            }

            .table td {
                padding: 16px;
                vertical-align: middle;
                border-bottom: 1px solid #e5e7eb;
            }

            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
            }

            .status-active {
                background-color: #dcfce7;
                color: #166534;
            }

            .status-draft {
                background-color: #fef9c3;
                color: #854d0e;
            }

            .status-inactive {
                background-color: #fee2e2;
                color: #b91c1c;
            }

            .action-btn {
                color: #2563eb;
                background: none;
                border: none;
                padding: 5px;
                cursor: pointer;
            }

            .action-btn.delete {
                color: #ef4444;
            }

            .action-btn:hover {
                opacity: 0.8;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                overflow: auto;
            }

            .modal-content {
                background-color: #fff;
                margin: 15% auto;
                max-width: 450px;
                border-radius: 8px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
                animation: modalFadeIn 0.3s;
            }

            @keyframes modalFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 20px;
                border-bottom: 1px solid #e5e7eb;
            }

            .modal-header h4 {
                margin: 0;
                font-size: 18px;
                font-weight: 600;
                color: #1f2937;
            }

            .close-modal {
                font-size: 24px;
                font-weight: 600;
                color: #6b7280;
                cursor: pointer;
            }

            .close-modal:hover {
                color: #1f2937;
            }

            .modal-body {
                padding: 20px;
            }

            .modal-body p {
                margin: 0 0 8px;
                font-size: 16px;
                color: #1f2937;
            }

            .warning-text {
                color: #dc2626;
                font-size: 14px;
            }

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                padding: 16px 20px;
                border-top: 1px solid #e5e7eb;
            }

            .btn-cancel {
                padding: 8px 16px;
                background-color: white;
                color: #4b5563;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-cancel:hover {
                background-color: #f3f4f6;
            }

            .btn-delete {
                padding: 8px 16px;
                background-color: #dc2626;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-delete:hover {
                background-color: #b91c1c;
            }
        </style>
    </head>
    <body>
        <!-- Back Button -->
        <button class="back-button" onclick="window.location.href='<%=request.getContextPath()%>/home'">
            <div class="back-arrow"></div>
        </button>

        <c:if test="${not empty error}">
            <p style="margin-top: 5px; color:red; text-align: center; font-size: 14px;">${error}</p>
        </c:if>

        <div class="container">
            <div class="card">
                <div class="card-body p-4">
                    <div class="header">
                        <h1>My Quizzes</h1>
                        <button class="create-btn" onclick="window.location.href = '<%=request.getContextPath()%>/quiz/create';">
                            <i class="fas fa-plus"></i> Create Quiz
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th>Code</th>
                                    <th>Time Limit</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="quiz" items="${quizzes}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td>${quiz.title}</td>
                                        <td>${quiz.description}</td>
                                        <td>${quiz.code}</td>
                                        <td>${quiz.timeLimit} mins</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${quiz.status eq 'Active'}">
                                                    <span class="status-badge status-active">${quiz.status}</span>
                                                </c:when>
                                                <c:when test="${quiz.status eq 'Draft'}">
                                                    <span class="status-badge status-draft">${quiz.status}</span>
                                                </c:when>
                                                <c:when test="${quiz.status eq 'Inactive'}">
                                                    <span class="status-badge status-inactive">${quiz.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${quiz.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${quiz.createdAt}</td>
                                        <td>
                                            <button class="action-btn view" title="View">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-btn edit" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="action-btn delete" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div id="deleteConfirmationModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h4>Delete Quiz</h4>
                    <span class="close-modal">&times;</span>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this quiz?</p>
                    <p class="warning-text">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button id="cancelDeleteBtn" class="btn-cancel">Cancel</button>
                    <button id="confirmDeleteBtn" class="btn-delete">Delete</button>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // JavaScript for Delete Confirmation Modal
            document.addEventListener('DOMContentLoaded', function() {
                // Get the modal
                const modal = document.getElementById('deleteConfirmationModal');

                // Get all delete buttons
                const deleteButtons = document.querySelectorAll('.action-btn.delete');

                // Get the close button
                const closeButton = document.querySelector('.close-modal');

                // Get the cancel button
                const cancelButton = document.getElementById('cancelDeleteBtn');

                // Get the confirm delete button
                const confirmDeleteButton = document.getElementById('confirmDeleteBtn');

                // Variable to store the quiz ID to be deleted
                let quizToDelete = null;

                // Function to open the modal
                function openModal(quizId) {
                    modal.style.display = 'block';
                    quizToDelete = quizId;
                    document.body.style.overflow = 'hidden'; // Prevent scrolling
                }

                // Function to close the modal
                function closeModal() {
                    modal.style.display = 'none';
                    quizToDelete = null;
                    document.body.style.overflow = 'auto'; // Enable scrolling
                }

                // Add click event to all delete buttons
                deleteButtons.forEach(button => {
                    button.addEventListener('click', function(e) {
                        e.preventDefault();
                        // Get the quiz ID from data attribute or parent row
                        const quizId = this.getAttribute('data-quiz-id') || 
                                      this.closest('tr').getAttribute('data-quiz-id');
                        openModal(quizId);
                    });
                });

                // Close the modal when clicking the close button
                closeButton.addEventListener('click', closeModal);

                // Close the modal when clicking the cancel button
                cancelButton.addEventListener('click', closeModal);

                // Handle the delete confirmation
                confirmDeleteButton.addEventListener('click', function() {
                    if (quizToDelete) {
                        // Submit the delete form or make an AJAX request
                        // Example:
                        window.location.href = '<%=request.getContextPath()%>/quiz/delete?id=' + quizToDelete;

                        // Or using a form submission:
                        // document.getElementById('deleteForm-' + quizToDelete).submit();

                        // Or using fetch API for AJAX:
                        /*
                        fetch('<%=request.getContextPath()%>/quiz/delete?id=' + quizToDelete, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            }
                        })
                        .then(response => {
                            if (response.ok) {
                                // Reload the page or remove the row from the table
                                window.location.reload();
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        });
                        */
                    }
                    closeModal();
                });

                // Close the modal if the user clicks outside of it
                window.addEventListener('click', function(event) {
                    if (event.target === modal) {
                        closeModal();
                    }
                });
            });
        </script>
    </body>
</html>