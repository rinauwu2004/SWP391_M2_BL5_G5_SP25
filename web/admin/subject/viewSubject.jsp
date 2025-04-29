<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Subject Details</title>
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
                width: 150px;
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
            <div class="detail-header">Subject Details</div>

            <div class="detail-row">
                <div class="label">Subject Code:</div>
                <div class="value">${subject.code}</div>

                <div class="label">Created At:</div>
                <div class="value">${subject.createdAt}</div>
            </div>

            <div class="detail-row">
                <div class="label">Subject Name:</div>
                <div class="value"><b>${subject.name}</b></div>

                <div class="label">Modified At:</div>
                <div class="value">${subject.modifiedAt}</div>
            </div>

            <div class="detail-row">
                <div class="label">Status:</div>
                <div class="value">
                    <c:choose>
                        <c:when test="${subject.status}">
                            <span class="status-active">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-inactive">Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="detail-row">
                <div class="label">Description</div>
            </div>
            <div class="description">${subject.description}</div>

            <a href="list-subject" class="back-btn">← Back to List</a>
        </div>
    </body>
</html>
