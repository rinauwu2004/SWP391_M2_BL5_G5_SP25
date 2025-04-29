<%-- 
    Document   : ResetPassword
    Created on : 27 Apr 2025, 03:03:42
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reset Password</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --default-font-family: 'Roboto', -apple-system, BlinkMacSystemFont, "Segoe UI", Ubuntu, "Helvetica Neue", Helvetica, Arial, "PingFang SC", "Hiragino Sans GB", "Microsoft Yahei UI", "Microsoft Yahei", "Source Han Sans CN", sans-serif;
                --primary-color: #2563eb;
                --text-dark: #111827;
                --text-medium: #374151;
                --text-light: #4b5563;
                --text-lighter: #6b7280;
                --border-color: #d1d5db;
                --background-light: #f9fafb;
                --background-white: #ffffff;
                --border-radius-sm: 8px;
                --border-radius-md: 12px;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow-md: 0 10px 15px 0 rgba(0, 0, 0, 0.1);
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: var(--default-font-family);
                background-color: var(--background-light);
            }

            input,
            select,
            textarea,
            button {
                outline: 0;
                font-family: var(--default-font-family);
            }

            button {
                cursor: pointer;
                border: none;
            }

            .main-container {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                flex-wrap: nowrap;
                position: relative;
                width: 100%;
                max-width: 1440px;
                margin: 0 auto;
                background: var(--background-white);
                border: 2px solid #ced4da;
                overflow: hidden;
                border-radius: var(--border-radius-sm);
            }

            .group {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                flex-wrap: nowrap;
                flex-shrink: 0;
                position: relative;
                width: 100%;
                background: rgba(0, 0, 0, 0);
            }

            .group-2 {
                flex-shrink: 0;
                position: relative;
                width: 100%;
                min-height: 100vh;
                background: var(--background-light);
                z-index: 1;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .section {
                position: relative;
                width: 448px;
                background: var(--background-white);
                z-index: 2;
                overflow: visible;
                border-radius: var(--border-radius-md);
                box-shadow: var(--shadow-md);
                padding: 30px;
            }

            .box {
                position: relative;
                width: 100%;
                margin-bottom: 25px;
                background: rgba(0, 0, 0, 0);
                z-index: 3;
                text-align: center;
                margin-top: -10px; /* Move title higher */
            }

            .box-2 {
                display: flex;
                align-items: center;
                justify-content: center;
                flex-wrap: nowrap;
                position: relative;
                width: 31.5px;
                height: 36px;
                margin: 0 auto;
                z-index: 4;
                overflow: hidden;
            }

            .text {
                display: flex;
                align-items: flex-start;
                justify-content: center;
                position: relative;
                width: 100%;
                margin-top: 10px;
                color: var(--text-dark);
                font-size: 30px;
                font-weight: 700;
                line-height: 30px;
                text-align: center;
                white-space: nowrap;
                z-index: 5;
            }

            .text-2 {
                display: flex;
                align-items: flex-start;
                justify-content: center;
                position: relative;
                width: 100%;
                margin-top: 11px;
                color: var(--text-light);
                font-size: 14px;
                font-weight: 400;
                line-height: 14px;
                text-align: center;
                white-space: nowrap;
                z-index: 6;
            }

            .wrapper {
                position: relative;
                width: 100%;
                z-index: 7;
            }

            .group-3 {
                position: relative;
                width: 100%;
                margin-bottom: 16px;
                z-index: 8;
            }

            .section-2 {
                position: relative;
                width: 100%;
                height: 20px;
                margin-bottom: 4px;
                z-index: 9;
            }

            .text-3 {
                display: flex;
                align-items: flex-start;
                justify-content: flex-start;
                position: relative;
                height: 16px;
                color: var(--text-medium);
                font-size: 14px;
                font-weight: 500;
                line-height: 16px;
                text-align: left;
                white-space: nowrap;
                z-index: 10;
            }

            .wrapper-2 {
                position: relative;
                width: 100%;
                height: auto;
                margin-bottom: 5px;
                z-index: 11;
            }

            .group-4 {
                position: absolute;
                width: 30px;
                height: 42px;
                top: 0;
                right: 10px; /* Move eye icon to the left */
                z-index: 13;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .wrapper-3 {
                display: flex;
                align-items: center;
                justify-content: center;
                flex-wrap: nowrap;
                position: relative;
                width: 18px;
                height: 16px;
                z-index: 14;
                cursor: pointer;
            }

            .section-3 {
                flex-shrink: 0;
                position: relative;
                width: 18px;
                height: 16px;
                background: rgba(0, 0, 0, 0);
                z-index: 15;
                overflow: hidden;
            }

            .img {
                position: relative;
                width: 18px;
                height: 14px;
                background-size: 100% 100%;
                z-index: 16;
                cursor: pointer;
            }

            .box-3 {
                position: relative;
                width: 100%;
                height: 42px;
                padding: 0 40px 0 12px;
                background: var(--background-white);
                border: 1px solid var(--border-color);
                z-index: 12;
                border-radius: var(--border-radius-sm);
                box-shadow: var(--shadow-sm);
                font-size: 14px;
            }

            .text-4 {
                display: block;
                position: relative;
                height: 14px;
                color: var(--text-lighter);
                font-size: 12px;
                font-weight: 400;
                line-height: 12px;
                text-align: left;
                white-space: nowrap;
                z-index: 17;
            }

            .section-4 {
                position: relative;
                width: 100%;
                margin-bottom: 16px;
                z-index: 18;
            }

            .wrapper-4 {
                position: relative;
                width: 100%;
                height: 20px;
                margin-bottom: 4px;
                z-index: 19;
            }

            .text-5 {
                display: flex;
                align-items: flex-start;
                justify-content: flex-start;
                position: relative;
                height: 16px;
                color: var(--text-medium);
                font-size: 14px;
                font-weight: 500;
                line-height: 16px;
                text-align: left;
                white-space: nowrap;
                z-index: 20;
            }

            .wrapper-5 {
                position: relative;
                width: 100%;
                height: auto;
                z-index: 21;
            }

            .group-5 {
                position: absolute;
                width: 30px;
                height: 42px;
                top: 0;
                right: 10px; /* Move eye icon to the left */
                z-index: 23;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .group-6 {
                display: flex;
                align-items: center;
                justify-content: center;
                flex-wrap: nowrap;
                position: relative;
                width: 18px;
                height: 16px;
                z-index: 24;
                cursor: pointer;
            }

            .section-5 {
                flex-shrink: 0;
                position: relative;
                width: 18px;
                height: 16px;
                background: rgba(0, 0, 0, 0);
                z-index: 25;
                overflow: hidden;
            }

            .img-2 {
                position: relative;
                width: 18px;
                height: 14px;
                background-size: 100% 100%;
                z-index: 26;
                cursor: pointer;
            }

            .group-7 {
                position: relative;
                width: 100%;
                height: 42px;
                padding: 0 40px 0 12px;
                background: var(--background-white);
                border: 1px solid var(--border-color);
                z-index: 22;
                border-radius: var(--border-radius-sm);
                box-shadow: var(--shadow-sm);
                font-size: 14px;
            }

            .box-4 {
                position: relative;
                width: 100%;
                height: 46px;
                background: var(--primary-color);
                border: 1px solid rgba(0, 0, 0, 0);
                z-index: 27;
                border-radius: var(--border-radius-sm);
                box-shadow: var(--shadow-sm);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .text-6 {
                color: var(--background-white);
                font-size: 14px;
                font-weight: 500;
                line-height: 16px;
                text-align: center;
                white-space: nowrap;
                z-index: 28;
            }

            .img, .img-2 {
                background: url(../img/eye.png) no-repeat center;
                background-size: 100%;
            }

            .img.showing, .img-2.showing {
                background: url(../img/hidden.png) no-repeat center;
                background-size: 100%;
            }

            .validation-group {
                display: flex;
                align-items: center;
                margin-top: 4px;
                min-height: 16px;
                padding-left: 4px;
                gap: 8px;
            }

            .error-message {
                color: #dc2626;
                font-size: 14px;
                line-height: 18px;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .section {
                    width: 90%;
                    max-width: 448px;
                    margin: 20px;
                }
            }

            @media (max-width: 480px) {
                .section {
                    width: 95%;
                    padding: 20px;
                }

                .text {
                    font-size: 24px;
                    line-height: 24px;
                }
            }
        </style>
    </head>
    <body>
        <main class="main-container">
            <div class="group">
                <div class="group-2">
                    <section class="section">
                        <header class="box">
                            <div class="box-2"></div>
                            <h1 class="text">Change New Password</h1>
                            <p class="text-2">Enter your new password below</p>
                        </header>

                        <form action="<%=request.getContextPath()%>/user/forgot-password" class="wrapper" id="resetPasswordForm" method="POST">
                            <div class="group-3">
                                <div class="section-2">
                                    <label for="newPassword" class="text-3">New Password</label>
                                </div>
                                <div class="wrapper-2">
                                    <div class="group-4">
                                        <div class="wrapper-3">
                                            <div class="section-3">
                                                <div class="img" id="toggleNewPassword"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="password" id="newPassword" name="newPassword" class="box-3" placeholder="New Password" required>
                                    
                                </div>
                                <div class="validation-group">
                                    <span id="newPasswordStatus" class="input-status"></span>
                                    <div id="newPasswordError" class="error-message"></div>
                                </div>
                            </div>

                            <div class="section-4">
                                <div class="wrapper-4">
                                    <label for="confirmPassword" class="text-5">Confirm New Password</label>
                                </div>
                                <div class="wrapper-5">
                                    <div class="group-5">
                                        <div class="group-6">
                                            <div class="section-5">
                                                <div class="img-2" id="toggleConfirmPassword"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="password" id="confirmPassword" class="group-7" placeholder="Confirm Password" required>
                                </div>
                                <div class="validation-group">
                                    <span id="confirmPasswordStatus" class="input-status"></span>
                                    <div id="confirmPasswordError" class="error-message"></div>
                                </div>
                            </div>

                            <button type="submit" class="box-4">
                                <span class="text-6">Reset Password</span>
                            </button>
                        </form>
                    </section>
                </div>
            </div>
        </main>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const resetPasswordForm = document.getElementById('resetPasswordForm');
                const newPasswordInput = document.getElementById('newPassword');
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const toggleNewPassword = document.getElementById('toggleNewPassword');
                const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');

                const touchedFields = {};
                const validFields = {};

                function togglePasswordVisibility(inputElement, toggleElement) {
                    if (inputElement.type === 'password') {
                        inputElement.type = 'text';
                        toggleElement.classList.add('showing');
                    } else {
                        inputElement.type = 'password';
                        toggleElement.classList.remove('showing');
                    }
                }

                toggleNewPassword.addEventListener('click', function () {
                    togglePasswordVisibility(newPasswordInput, toggleNewPassword);
                });

                toggleConfirmPassword.addEventListener('click', function () {
                    togglePasswordVisibility(confirmPasswordInput, toggleConfirmPassword);
                });

                function showError(id, message) {
                    document.getElementById(id + "Error").innerText = message;
                    const statusIcon = document.getElementById(id + "Status");
                    statusIcon.innerText = "❌";
                    statusIcon.classList.add("invalid");
                    statusIcon.classList.remove("valid");
                    document.getElementById(id).classList.add("invalid");
                    validFields[id] = false;
                }

                function clearError(id) {
                    document.getElementById(id + "Error").innerText = "";
                    const statusIcon = document.getElementById(id + "Status");
                    statusIcon.innerText = "";
                    statusIcon.classList.add("valid");
                    statusIcon.classList.remove("invalid");
                    document.getElementById(id).classList.remove("invalid");
                    validFields[id] = true;
                }

                function validateNewPassword() {
                    const pw = newPasswordInput.value;
                    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d_.]{8,}$/;

                    if (!pw) {
                        showError('newPassword', "This field is required.");
                    } else if (!regex.test(pw)) {
                        showError('newPassword', "Password must be at least 8 characters, include uppercase, lowercase and number.");
                    } else {
                        clearError('newPassword');
                    }
                }

                function validateConfirmPassword() {
                    const pw = newPasswordInput.value;
                    const cpw = confirmPasswordInput.value;

                    if (!cpw) {
                        showError('confirmPassword', "This field is required.");
                    } else if (pw !== cpw) {
                        showError('confirmPassword', "Passwords do not match.");
                    } else {
                        clearError('confirmPassword');
                    }
                }

                newPasswordInput.addEventListener('blur', function () {
                    touchedFields['newPassword'] = true;
                    validateNewPassword();
                });

                confirmPasswordInput.addEventListener('blur', function () {
                    touchedFields['confirmPassword'] = true;
                    validateConfirmPassword();
                });

                resetPasswordForm.addEventListener('submit', function (event) {
                    event.preventDefault();

                    validateNewPassword();
                    validateConfirmPassword();

                    if (validFields['newPassword'] && validFields['confirmPassword']) {
                        resetPasswordForm.submit();
                    } else {
                        alert('Please correct the errors before submitting.');
                    }
                });
            });
        </script>
    </body>
</html>