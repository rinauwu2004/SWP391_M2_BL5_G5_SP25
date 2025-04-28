<%-- 
    Document   : editModule
    Created on : Apr 26, 2025, 11:14:20 PM
    Author     : trung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Module</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />

        <style>
            body {
                background-color: #f5f6fa;
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .container {
                width: 100%;
                max-width: 500px;
                background: #fff;
                border-radius: 12px;
                padding: 40px 30px; /* padding trái phải 30px */
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
                animation: fadeIn 0.5s ease-in-out;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            h2 {
                font-weight: 700;
                text-align: center;
                margin-bottom: 30px;
                color: #333;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #555;
            }
            input[type="text"],
            textarea,
            select {
                width: 100%;
                box-sizing: border-box; /* thêm box-sizing để padding không phá layout */
                padding: 12px 18px; /* padding bên trong input */
                border: 1px solid #ccc;
                border-radius: 10px;
                font-size: 15px;
                background: #fafafa;
                transition: border-color 0.3s;
                outline: none;
            }
            input[type="text"]:focus,
            textarea:focus,
            select:focus {
                border-color: #727CF5;
                background: #fff;
            }
            textarea {
                resize: vertical;
                min-height: 120px;
            }
            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 30px;
            }
            .btn-back, .btn-save {
                padding: 10px 24px;
                border-radius: 10px;
                border: none;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.3s, transform 0.2s;
            }
            .btn-back {
                background-color: #f0f0f0;
                color: #333;
            }
            .btn-save {
                background-color: #727CF5;
                color: white;
            }
            .btn-back:hover {
                background-color: #e0e0e0;
            }
            .btn-save:hover {
                background-color: #5a63d4;
            }
            .btn-back:active,
            .btn-save:active {
                transform: scale(0.97);
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
            <h3 class="mb-4">Edit Module</h3>

            <form action="editModule" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="id" value="${module.id}" />
                <input name="lessonId" value="${param.lessonId}" hidden="">

                <div class="mb-3">
                    <label for="name" class="form-label">Module Name</label>
                    <input type="text" class="form-control" id="name" name="name" value="${module.name}" required>
                    <div class="invalid-feedback">
                        Please enter module name.
                    </div>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Module Description</label>
                    <textarea class="form-control" id="description" name="description" rows="4" required>${module.description}</textarea>
                    <div class="invalid-feedback">
                        Please enter module description.
                    </div>
                </div>

                <div class="mb-3">
                    <label for="url" class="form-label">Module URL (optional)</label>
                    <input type="url" class="form-control" id="url" name="url" value="${module.url}">
                </div>

                <div class="d-flex justify-content-between">
                    <a href="module-list?id=${param.lessonId}" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-save"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Bootstrap form validation
            (function () {
                'use strict'
                const forms = document.querySelectorAll('.needs-validation')
                Array.from(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        form.classList.add('was-validated')
                    }, false)
                })
            })();
        </script>
    </body>
</html>
