<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Subject Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <style>
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
    <body class="p-4">
        <!-- Back Button -->
        <button class="back-button" onclick="window.history.back()">
            <div class="back-arrow"></div>
        </button>
    </body>
</html>
