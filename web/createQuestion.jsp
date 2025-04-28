<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quiz Creator</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f9fafb;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

            .quiz-container {
                max-width: 1200px;
                margin: 2rem auto;
            }

            .quiz-info-panel {
                background-color: white;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                height: fit-content;
            }

            .quiz-info-item {
                margin-bottom: 1rem;
            }

            .quiz-info-label {
                font-weight: 600;
                color: #4b5563;
                margin-bottom: 0.25rem;
            }

            .quiz-info-value {
                color: #1f2937;
            }

            .import-btn {
                background-color: #eff6ff;
                color: #2563eb;
                border: none;
                border-radius: 6px;
                padding: 0.75rem 1rem;
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                transition: background-color 0.2s;
            }

            .import-btn:hover {
                background-color: #dbeafe;
            }

            .question-panel {
                background-color: white;
                border-radius: 8px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                position: relative;
            }

            .question-header {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: #111827;
            }

            .question-input {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid #e5e7eb;
                border-radius: 6px;
                margin-bottom: 1.5rem;
            }

            .answer-item {
                display: flex;
                align-items: center;
                margin-bottom: 0.75rem;
                padding: 0.5rem;
                border: 1px solid #e5e7eb;
                border-radius: 6px;
                position: relative;
            }

            .answer-checkbox {
                margin-right: 0.75rem;
                width: 18px;
                height: 18px;
            }

            .answer-input {
                flex-grow: 1;
                border: none;
                padding: 0.5rem;
                outline: none;
            }

            .add-answer-btn {
                background-color: #f3f4f6;
                color: #4b5563;
                border: 1px dashed #d1d5db;
                border-radius: 6px;
                padding: 0.5rem 1rem;
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .add-answer-btn:hover {
                background-color: #e5e7eb;
            }

            .add-question-btn {
                background-color: white;
                color: #4b5563;
                border: 1px dashed #d1d5db;
                border-radius: 8px;
                padding: 1rem;
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
            }

            .add-question-btn:hover {
                background-color: #f9fafb;
            }

            .delete-btn {
                background: none;
                border: none;
                color: #ef4444;
                cursor: pointer;
                padding: 0.25rem;
                margin-left: 0.5rem;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .delete-btn:hover {
                background-color: #fee2e2;
            }

            .delete-question-btn {
                position: absolute;
                top: 1rem;
                right: 1rem;
            }

            .status-badge {
                display: inline-block;
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.875rem;
                font-weight: 500;
            }

            .status-active {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status-draft {
                background-color: #e5e7eb;
                color: #4b5563;
            }
        </style>
    </head>
    <body>
        <!-- Back Button -->
        <button class="back-button" onclick="window.history.back()">
            <div class="back-arrow"></div>
        </button>
        
        <div class="quiz-container">
            <div class="row g-4">
                <!-- Left Column - Quiz Information -->
                <div class="col-md-4">
                    <div class="quiz-info-panel">
                        <h2 class="mb-4">Quiz Information</h2>

                        <div class="quiz-info-item">
                            <div class="quiz-info-label">Title</div>
                            <div class="quiz-info-value">
                                <c:out value="${quiz.title}"/>
                            </div>
                        </div>

                        <div class="quiz-info-item">
                            <div class="quiz-info-label">Description</div>
                            <div class="quiz-info-value">
                                <c:out value="${quiz.description}"/>
                            </div>
                        </div>

                        <div class="quiz-info-item">
                            <div class="quiz-info-label">Time Limit</div>
                            <div class="quiz-info-value">
                                <c:out value="${quiz.timeLimit}"/> minutes
                            </div>
                        </div>

                        <div class="quiz-info-item">
                            <div class="quiz-info-label">Status</div>
                            <div class="quiz-info-value">
                                <span class="status-badge ${quiz.status == 'Active' ? 'status-active' : 'status-draft'}">
                                    <c:out value="${quiz.status}"/>
                                </span>
                            </div>
                        </div>

                        <div class="quiz-info-item">
                            <div class="quiz-info-label">Created At</div>
                            <div class="quiz-info-value">
                                <c:choose>
                                    <c:when test="${quiz.createdAt != null}">
                                        <fmt:formatDate value="${quiz.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button class="import-btn">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-upload" viewBox="0 0 16 16">
                                <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                                <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z"/>
                                </svg>
                                Import from file (.docx)
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Questions and Answers -->
                <div class="col-md-8">
                    <form id="quizForm" action="<%=request.getContextPath()%>/quiz/createQuestion" method="post">
                        <input type="hidden" id="quiz" name="quiz" value="${quiz.id}">
                        <div id="questionsContainer">
                            <!-- Question 1 -->
                            <div class="question-panel" data-question-id="1">
                                <div class="question-header">Question 1</div>
                                <button type="button" class="delete-btn delete-question-btn" onclick="deleteQuestion(this)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                    </svg>
                                </button>
                                <input type="text" name="question_1" class="question-input" placeholder="Enter your question here">

                                <div class="answers-container">
                                    <!-- Answer 1 -->
                                    <div class="answer-item">
                                        <input type="checkbox" name="correct_1_1" class="answer-checkbox" id="answer_1_1">
                                        <input type="text" name="answer_1_1" class="answer-input" placeholder="Enter answer option 1">
                                        <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                            </svg>
                                        </button>
                                    </div>

                                    <!-- Answer 2 -->
                                    <div class="answer-item">
                                        <input type="checkbox" name="correct_1_2" class="answer-checkbox" id="answer_1_2">
                                        <input type="text" name="answer_1_2" class="answer-input" placeholder="Enter answer option 2">
                                        <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                            </svg>
                                        </button>
                                    </div>

                                    <!-- Answer 3 -->
                                    <div class="answer-item">
                                        <input type="checkbox" name="correct_1_3" class="answer-checkbox" id="answer_1_3">
                                        <input type="text" name="answer_1_3" class="answer-input" placeholder="Enter answer option 3">
                                        <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                            </svg>
                                        </button>
                                    </div>

                                    <!-- Answer 4 -->
                                    <div class="answer-item">
                                        <input type="checkbox" name="correct_1_4" class="answer-checkbox" id="answer_1_4">
                                        <input type="text" name="answer_1_4" class="answer-input" placeholder="Enter answer option 4">
                                        <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <button type="button" class="add-answer-btn" onclick="addAnswer(1)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus" viewBox="0 0 16 16">
                                    <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                                    </svg>
                                    Add Answer Option
                                </button>
                            </div>
                        </div>

                        <button type="button" id="addQuestionBtn" class="add-question-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus" viewBox="0 0 16 16">
                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                            </svg>
                            Add New Question
                        </button>

                        <div class="d-flex justify-content-end mt-4">
                            <button type="submit" class="btn btn-primary">Save Quiz</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script src="<%= request.getContextPath() + "/js/createQuestion.js" %>"></script>
    </body>
</html>