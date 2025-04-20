<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Edit Subject</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f8f9fc;
                padding: 40px;
                position: relative;
            }
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

        <div class="notification">
            <c:import url="../../../notification.jsp" />
        </div>

        <div class="form-container">
            <h2>Edit Subject</h2>
            <p>Modify the details for the subject below</p>

            <!-- Form for editing the subject -->
            <form action="editSubject" method="post">
                <!-- Hidden input to hold the ID of the subject being edited -->
                <input type="hidden" name="id" value="${subject.id}" />

                <label for="code">Subject Code</label>
                <input type="text" id="code" name="code" value="${subject.code}" required />

                <label for="name">Subject Name</label>
                <input type="text" id="name" name="name" value="${subject.name}" required />

                <label for="description">Description</label>
                <textarea id="description" name="description">${subject.description}</textarea>

                <label for="status">Status</label>
                <select id="status" name="status">
                    <option value="true" ${subject.status == 'true' ? 'selected' : ''}>Active</option>
                    <option value="false" ${subject.status == 'false' ? 'selected' : ''}>Inactive</option>
                </select>
                <div class="form-actions">
                    <a href="list-subject" class="btn btn-back">← Back to Subject List</a>
                    <button type="submit" class="btn btn-submit">Save Changes</button>
                </div>
            </form>
        </div>
    </body>
</html>
