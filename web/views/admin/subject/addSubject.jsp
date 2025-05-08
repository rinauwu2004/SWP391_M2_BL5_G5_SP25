<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Add New Subject</title>
        <style>
            
            .form-container {
                background: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.08);
                max-width: 600px;
                margin: auto;
            }
            .form-container h2 {
                font-size: 24px;
                margin-bottom: 5px;
            }
            .form-container p {
                color: #666;
                margin-bottom: 20px;
            }
            label {
                font-weight: bold;
                display: block;
                margin-top: 15px;
            }
            input[type="text"], textarea, select {
                width: 100%;
                padding: 10px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 8px;
            }
            textarea {
                resize: vertical;
                height: 100px;
            }
            .form-actions {
                margin-top: 25px;
                display: flex;
                justify-content: space-between;
            }
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                text-decoration: none;
                font-weight: bold;
            }
            .btn-back {
                background-color: #f1f1f1;
                color: #333;
            }
            .btn-submit {
                background-color: #727CF5;
                color: white;
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
           <c:import url="../sidebar.jsp" />
        <div class="notification">
            <c:import url="../../../notification.jsp" />
        </div>
 <main class="main-content">

        <div class="form-container">
            <h2>Add New Subject</h2>
            <p>Enter the details for the new subject below</p>

            <form action="addSubject" method="post">
                <label for="code">Subject Code</label>
                <input type="text" id="code" name="code" required />

                <label for="name">Subject Name</label>
                <input type="text" id="name" name="name" required />

                <label for="status">Status</label>
                <select id="status" name="status">
                    <option value="true" selected>Active</option>
                    <option value="false">Inactive</option>
                </select>

                <label for="description">Description</label>
                <textarea id="description" name="description"></textarea>

                <div class="form-actions">
                    <a href="list-subject" class="btn btn-back">← Back to Subject List</a>
                    <button type="submit" class="btn btn-submit">Add Subject</button>
                </div>
            </form>
        </div>
      </div>
    </body>
</html>
