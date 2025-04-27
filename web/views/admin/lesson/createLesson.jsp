<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Lesson</title>
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
                padding: 40px 30px;
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
                box-sizing: border-box;
                padding: 12px 18px;
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
    <body>

        <div class="notification">
            <c:import url="../../../notification.jsp" />
        </div>

        <div class="container">
            <h2>Create Lesson</h2>
            <form action="lesson-create" method="post">

                <input value="${param.subjectId}" name="subjectId" hidden="">
                <div class="form-group">
                    <label for="lessonName">Lesson Name</label>
                    <input type="text" id="lessonName" name="lessonName" placeholder="Enter lesson name" required />
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Enter lesson description" required></textarea>
                </div>


                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="viewLesson?id=${param.subjectId}">
                        <button type="button"  class="btn-back">Back</button>

                    </a>
                    <button type="submit" class="btn-save">Save</button>
                </div>
            </form>

        </div>

    </body>
</html>
