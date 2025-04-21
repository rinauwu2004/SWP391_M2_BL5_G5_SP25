<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QuizOnline - Login</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <div class="floating-shapes">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
        
        <div class="login-container">
            <div class="logo">
                <h1>Quiz<span>Online</span></h1>
            </div>
            
            <div class="error-message" id="error" style="display: ${empty error ? 'none' : 'block'}">
                ${error}
            </div>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="usernameOrEmail">Username or Email</label>
                    <i class="fas fa-user"></i>
                    <input type="text" id="usernameOrEmail" name="usernameOrEmail" class="input-field" placeholder="Enter your username or email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password" class="input-field" placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="btn-login">Sign In</button>
                
                <div class="form-footer">
                    <p>Forgot your password? <a href="#">Reset here</a></p>
                </div>
            </form>
        </div>
        
        <script src="${pageContext.request.contextPath}/js/login.js"></script>
    </body>
</html>
