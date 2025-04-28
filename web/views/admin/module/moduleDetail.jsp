<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Module Details</title>
        <style>
            .detail-container {
                background: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                font-family: Arial, sans-serif;
                width: 800px;
                margin: 30px auto;
            }
            .detail-header {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 20px;
            }
            .detail-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .label {
                font-weight: bold;
                width: 180px;
            }
            .value {
                flex: 1;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
                padding: 4px 10px;
                border-radius: 12px;
                display: inline-block;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
                padding: 4px 10px;
                border-radius: 12px;
                display: inline-block;
            }
            .description {
                margin-top: 20px;
                line-height: 1.5;
            }
            .back-btn {
                margin-top: 20px;
                display: inline-block;
                padding: 8px 16px;
                background-color: #727CF5;
                color: white;
                text-decoration: none;
                border-radius: 8px;
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

        <div class="detail-container">
            <div class="detail-header">Module Details</div>

            <!-- Module Information -->
            <div class="detail-row">
                <div class="label">Module Name:</div>
                <div class="value"><b>${module.name}</b></div>

                <div class="label">Module URL:</div>
                <div class="value">
                    <a href="${module.url}" target="_blank">${module.url}</a>
                </div>
            </div>

          

         

            <div class="detail-row">
                <div class="label">Module Description:</div>
            </div>
            <div class="description">${module.description}</div>

            <!-- Lesson Information -->
            <div class="detail-header" style="margin-top: 40px;">Lesson Details</div>

            <div class="detail-row">
                <div class="label">Lesson Name:</div>
                <div class="value">${module.lessonId.name}</div>

                <div class="label">Lesson Created At:</div>
                <div class="value">
                    <c:if test="${not empty module.lessonId.createdAt}">
                        ${module.lessonId.createdAt}
                    </c:if>
                    <c:if test="${empty module.lessonId.createdAt}">
                        N/A
                    </c:if>
                </div>
            </div>

            <div class="detail-row">
                <div class="label">Lesson Modified At:</div>
                <div class="value">
                    <c:if test="${not empty module.lessonId.modifiedAt}">
                        ${module.lessonId.modifiedAt}
                    </c:if>
                    <c:if test="${empty module.lessonId.modifiedAt}">
                        N/A
                    </c:if>
                </div>
            </div>

            <div class="detail-row">
                <div class="label">Lesson Description:</div>
            </div>
            <div class="description">${module.lessonId.description}</div>

            <!-- Subject Information -->
            <div class="detail-header" style="margin-top: 40px;">Subject Details</div>

            <div class="detail-row">
                <div class="label">Subject Code:</div>
                <div class="value">${module.lessonId.subjectId.code}</div>

                <div class="label">Subject Name:</div>
                <div class="value">${module.lessonId.subjectId.name}</div>
            </div>

            <div class="detail-row">
                <div class="label">Subject Created At:</div>
                <div class="value">
                    <c:if test="${not empty module.lessonId.subjectId.createdAt}">
                        ${module.lessonId.subjectId.createdAt}
                    </c:if>
                    <c:if test="${empty module.lessonId.subjectId.createdAt}">
                        N/A
                    </c:if>
                </div>

                <div class="label">Subject Modified At:</div>
                <div class="value">
                    <c:if test="${not empty module.lessonId.subjectId.modifiedAt}">
                        ${module.lessonId.subjectId.modifiedAt}
                    </c:if>
                    <c:if test="${empty module.lessonId.subjectId.modifiedAt}">
                        N/A
                    </c:if>
                </div>
            </div>

            <div class="detail-row">
                <div class="label">Subject Status:</div>
                <div class="value">
                    <c:choose>
                        <c:when test="${module.lessonId.subjectId.status}">
                            <span class="status-active">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-inactive">Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="detail-row">
                <div class="label">Subject Description:</div>
            </div>
            <div class="description">${module.lessonId.subjectId.description}</div>

            <!-- Back Button -->
            <a href="javascript:history.back()" class="back-btn">← Back to List</a>
        </div>

    </body>
</html>
