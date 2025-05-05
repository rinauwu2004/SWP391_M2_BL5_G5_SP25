<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

            .mt-3 {
                max-width: 500px;
                margin: 20px auto;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                background-color: #fff;
            }

            .form-control {
                display: block;
                width: 100%;
                padding: 10px 12px;
                margin-bottom: 15px !important;
                font-size: 14px;
                line-height: 1.5;
                color: #495057;
                background-color: #f8f9fa;
                border: 1px solid #ced4da;
                border-radius: 4px;
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }

            .form-control:focus {
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

            .import-btn {
                display: inline-block;
                font-weight: 500;
                text-align: center;
                white-space: nowrap;
                vertical-align: middle;
                user-select: none;
                border: 1px solid transparent;
                padding: 10px 20px;
                font-size: 14px;
                line-height: 1.5;
                border-radius: 4px;
                color: #fff;
                background-color: #28a745;
                border-color: #28a745;
                transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out,
                    border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
                cursor: pointer;
                width: 100%;
            }

            .import-btn:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

            .import-btn:focus {
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.5);
                outline: 0;
            }

            input[type="file"]::file-selector-button {
                margin-right: 10px;
                border: none;
                background: #e9ecef;
                padding: 8px 16px;
                border-radius: 4px;
                color: #495057;
                cursor: pointer;
                transition: background .2s ease-in-out;
            }

            input[type="file"]::file-selector-button:hover {
                background: #dde0e3;
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

        <!-- Add Save Quiz button at the top -->
        <div style="position: absolute; top:  2rem; right: 1.5rem;">
            <button type="button" class="btn btn-primary" onclick="document.getElementById('quizForm').submit();">
                Save Quiz
            </button>
        </div>

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
                                        <c:set var="now" value="${requestScope.time}" />
                                        <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="quiz-info-item" style="margin-top: 2.5rem;">
                            <div class="quiz-info-label">Import Question</div>
                            <c:if test="${not empty error}">
                                <p style="margin-top: 0.5rem; color:red; text-align: center; font-size: 14px;">${error}</p>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/quiz/importDocx" method="post" enctype="multipart/form-data" class="mt-3">
                                <input type="hidden" id="quizId" name="quizId" value="${quiz.id}">
                                <input type="file" name="file" accept=".docx" class="form-control mb-2" required>
                                <button type="submit" class="import-btn">Import from file (.docx)</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Questions and Answers -->
                <div class="col-md-8">
                    <form id="quizForm" action="<%=request.getContextPath()%>/quiz/createQuestion" method="post">
                        <input type="hidden" id="quiz" name="quiz" value="${quiz.id}">
                        <div id="questionsContainer">

                            <c:if test="${not empty importedQuestions}">
                                <c:forEach var="q" items="${importedQuestions}" varStatus="qStatus">
                                    <div class="question-panel" data-question-id="${qStatus.index + 1}">
                                        <div class="question-header">Question ${qStatus.index + 1}</div>
                                        <input type="text" name="question_${qStatus.index + 1}" class="question-input" value="${q.content}">

                                        <div class="answers-container">
                                            <c:forEach var="a" items="${q.answers}" varStatus="aStatus">
                                                <div class="answer-item">
                                                    <input type="checkbox" name="correct_${qStatus.index + 1}_${aStatus.index + 1}" class="answer-checkbox" <c:if test="${a.isCorrect}">checked</c:if>>
                                                    <input type="text" name="answer_${qStatus.index + 1}_${aStatus.index + 1}" class="answer-input" value="${a.content}">
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <c:if test="${empty importedQuestions}">
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
                            </c:if>
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
        <script>
            // Update init value after importing
            questionCounter = ${fn:length(importedQuestions)};
            <c:forEach var="q" items="${importedQuestions}" varStatus="qStatus">
                answerCounters[${qStatus.index + 1}] = ${fn:length(q.answers)};
            </c:forEach>
        </script>
    </body>
</html>