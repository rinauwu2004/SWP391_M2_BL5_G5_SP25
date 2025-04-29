<%-- 
    Document   : createQuiz
    Created on : 28 Apr 2025, 10:36:23
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create New Quiz</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
            }

            body {
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
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

            .form-container {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 600px;
                padding: 32px;
            }

            h1 {
                font-size: 24px;
                font-weight: 600;
                color: #111827;
                margin-bottom: 24px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                font-size: 14px;
                font-weight: 500;
                color: #374151;
                margin-bottom: 8px;
            }

            input, textarea, select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #D1D5DB;
                border-radius: 6px;
                font-size: 14px;
                color: #111827;
            }

            textarea {
                min-height: 120px;
                resize: vertical;
            }

            input:focus, textarea:focus, select:focus {
                outline: none;
                border-color: #6366F1;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .form-row {
                display: flex;
                gap: 20px;
            }

            .form-row .form-group {
                flex: 1;
            }

            .button-group {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 24px;
            }

            .btn {
                padding: 10px 16px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-cancel {
                background-color: white;
                color: #374151;
                border: 1px solid #D1D5DB;
            }

            .btn-cancel:hover {
                background-color: #F9FAFB;
            }

            .btn-primary {
                background-color: #5850EC;
                color: white;
                border: none;
            }

            .btn-primary:hover {
                background-color: #4F46E5;
            }
        </style>
    </head>
    <body>
        <!-- Back Button -->
        <button class="back-button" onclick="window.history.back()">
            <div class="back-arrow"></div>
        </button>
        
        <div class="form-container">
            <h1>Create New Quiz</h1>
            <form action="<%=request.getContextPath()%>/quiz/create" method="post">
                <div class="form-group">
                    <label for="title">Title</label>
                    <input type="text" id="title" name="title" placeholder="Enter quiz title" required>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Enter quiz description"></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="timeLimit">Time Limit (minutes)</label>
                        <input type="number" id="timeLimit" name="timeLimit" placeholder="Enter time limit" min='1' step='1' required>
                    </div>

                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" required>
                            <option value="">Select status</option>>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="button-group">
                    <button type="button" class="btn btn-cancel" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Quiz</button>
                </div>
            </form>
        </div>
    </body>
</html>
