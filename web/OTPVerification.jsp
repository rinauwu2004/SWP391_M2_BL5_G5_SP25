<%-- 
    Document   : OTPVerification
    Created on : 20 Apr 2025, 14:42:42
    Author     : Rinaaaa
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Email Verification</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }

            body {
                display: flex;
                min-height: 100vh;
                align-items: center;
                justify-content: center;
                background-color: #e5e7eb;
            }

            .verification-card {
                width: 100%;
                max-width: 400px;
                padding: 32px;
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                text-align: center;
            }

            .icon-container {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 48px;
                height: 48px;
                margin: 0 auto 16px;
            }

            h2 {
                margin-bottom: 8px;
                font-size: 20px;
                font-weight: 600;
                color: #171717;
            }

            .text-secondary {
                font-size: 14px;
                color: #525252;
                margin-bottom: 4px;
            }

            .email {
                font-size: 14px;
                font-weight: 500;
                color: #171717;
                margin-bottom: 16px;
            }

            .expiry {
                font-size: 14px;
                color: #525252;
                margin-bottom: 24px;
            }

            .code-inputs {
                display: flex;
                gap: 8px;
                justify-content: center;
                margin-bottom: 24px;
            }

            .code-input {
                width: 40px;
                height: 40px;
                text-align: center;
                font-size: 16px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                outline: none;
            }

            .code-input:focus {
                border-color: #171717;
                box-shadow: 0 0 0 2px rgba(23, 23, 23, 0.2);
            }

            .verify-button {
                width: 100%;
                padding: 12px;
                background-color: #171717;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                margin-bottom: 24px;
                transition: background-color 0.2s;
            }

            .verify-button:hover {
                background-color: #000000;
            }

            .resend-text {
                font-size: 14px;
                color: #525252;
            }

            .resend-link {
                color: #171717;
                text-decoration: none;
                cursor: pointer;
                margin-left: 4px;
            }

            .resend-link:hover {
                text-decoration: underline;
            }

            .timer-expiring {
                color: #e53e3e;
            }
        </style>
    </head>
    <body>
        <div class="verification-card">
            <div class="icon-container">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                </svg>
            </div>

            <h2>Email Verification</h2>
            <p class="text-secondary">We sent a verification code to your email</p>

            <p class="email">
                <c:out value="${sessionScope.email}" default=""/>
            </p>

            <c:if test="${not empty error}">
                <div style="color:red;">${error}</div>
            </c:if>
            <c:if test="${not empty otpInvalid}">
                <div style="color:red;">${otpInvalid}</div>
            </c:if>

            <p class="expiry">Code expires in: <span id="countdown">--:--</span></p>

            <form action="<%=request.getContextPath()%>/verify" method="post" id="verificationForm">
                <div class="code-inputs">
                    <c:forEach begin="0" end="5" var="i">
                        <input type="text" class="code-input" name="code${i}" maxlength="1" autocomplete="off">
                    </c:forEach>
                </div>
                <input type="hidden" id="otp" name="otp"> 
                <button type="submit" class="verify-button">Verify</button>
            </form>

            <p class="resend-text">
                Didn't receive the code?
                <a href="<%= request.getContextPath() %>/resend?page=OTPVerification.jsp" class="resend-link" id="resendLink">Resend</a>
            </p>
        </div>

        <script>
            // JavaScript for handling input behavior
            document.addEventListener('DOMContentLoaded', function () {
                const inputs = document.querySelectorAll('.code-input');

                // Auto-focus first input
                inputs[0].focus();

                inputs.forEach((input, index) => {
                    // Move to next input when a digit is entered
                    input.addEventListener('input', function () {
                        if (this.value.length === 1) {
                            if (index < inputs.length - 1) {
                                inputs[index + 1].focus();
                            }
                        }
                    });

                    // Handle backspace to go to previous input
                    input.addEventListener('keydown', function (e) {
                        if (e.key === 'Backspace' && !this.value && index > 0) {
                            inputs[index - 1].focus();
                        }
                    });

                    // Only allow numbers
                    input.addEventListener('input', function () {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    });
                });

                // Handle paste event on the first input
                inputs[0].addEventListener('paste', function (e) {
                    e.preventDefault();
                    const pastedText = (e.clipboardData || window.clipboardData).getData('text');
                    const digits = pastedText.replace(/[^0-9]/g, '').split('').slice(0, 6);

                    digits.forEach((digit, i) => {
                        if (i < inputs.length) {
                            inputs[i].value = digit;
                        }
                    });

                    // Focus the appropriate input after paste
                    const nextEmptyIndex = Array.from(inputs).findIndex(input => !input.value);
                    if (nextEmptyIndex !== -1) {
                        inputs[nextEmptyIndex].focus();
                    } else {
                        inputs[inputs.length - 1].focus();
                    }
                });

                // Countdown timer implementation
                const countdownElement = document.getElementById('countdown');
                const form = document.getElementById('verificationForm');
                const resendLink = document.getElementById('resendLink');

                // Get timeout value from session using EL
                const timeoutMinutes = ${sessionScope.timeout};

                // Calculate total seconds
                let timeLeftInSeconds = timeoutMinutes * 60;

                // Update the countdown every second
                const countdownTimer = setInterval(function () {
                    // Calculate minutes and seconds
                    const minutes = Math.floor(timeLeftInSeconds / 60);
                    const seconds = timeLeftInSeconds % 60;

                    // Format the time as MM:SS
                    const formattedTime =
                            String(minutes).padStart(2, '0') + ':' +
                            String(seconds).padStart(2, '0');

                    // Update the countdown display
                    countdownElement.textContent = formattedTime;

                    // Add warning color when less than 1 minute remains
                    if (timeLeftInSeconds <= 60) {
                        countdownElement.classList.add('timer-expiring');
                    }

                    // Check if timer has reached zero
                    if (timeLeftInSeconds <= 0) {
                        clearInterval(countdownTimer);

                        // Disable the form inputs and submit button
                        Array.from(inputs).forEach(input => {
                            input.disabled = true;
                        });
                        form.querySelector('button[type="submit"]').disabled = true;

                        // Show message that code has expired
                        countdownElement.textContent = "00:00";
                        alert("Verification code has expired. Please request a new code.");
                    }

                    // Decrement the timer
                    timeLeftInSeconds--;
                }, 1000);

                // Reset timer when resend is clicked
                resendLink.addEventListener('click', function (e) {
                    // This will be handled by the server, but we can reset the UI immediately
                    timeLeftInSeconds = timeoutMinutes * 60;
                    countdownElement.classList.remove('timer-expiring');

                    // Re-enable form if it was disabled
                    Array.from(inputs).forEach(input => {
                        input.disabled = false;
                        input.value = '';
                    });
                    form.querySelector('button[type="submit"]').disabled = false;
                    inputs[0].focus();

                    // Note: The actual resend will be handled by the server
                    // This is just for immediate UI feedback
                });

                // Before submit
                form.addEventListener('submit', function (e) {
                    let otpCode = '';
                    inputs.forEach(input => {
                        otpCode += input.value;
                    });
                    document.getElementById('otp').value = otpCode;
                });
            });
        </script>
    </body>
</html>