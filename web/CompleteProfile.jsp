<%-- 
    Document   : CompleteProfile
    Created on : 26 Apr 2025, 16:27:00
    Author     : Rinaaaa
--%>

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pikaday/css/pikaday.css"/>
        <script src="https://cdn.jsdelivr.net/npm/pikaday/pikaday.js"></script>
        <title>Create Account</title>
        <style>
            * {
                box-sizing: border-box;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
                    Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
            }

            body {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                background-color: #f5f5f5;
            }

            .form-container {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 40px;
                width: 100%;
                max-width: 500px;
            }

            h1 {
                text-align: center;
                margin-top: 0;
                margin-bottom: 10px;
                font-size: 24px;
                font-weight: 600;
            }

            .subtitle {
                text-align: center;
                margin-bottom: 30px;
                color: #666;
                font-size: 14px;
            }

            .form-row {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                flex: 1;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-size: 14px;
            }

            input,
            select,
            textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            textarea {
                min-height: 80px;
                resize: vertical;
            }

            input[readonly] {
                background-color: #f0f0f0;
                pointer-events: none;
                user-select: none;
                color: #888;
            }

            .phone-input {
                display: flex;
                border: 1px solid #ddd;
                border-radius: 4px;
                overflow: hidden;
            }

            .phone-input input {
                border: none;
                border-radius: 0;
            }

            .prefix-code {
                width: 50px;
                background-color: #f9f9f9;
                text-align: center;
                border-right: 1px solid #ddd !important;
                padding: 10px 5px;
            }

            .submit-btn {
                width: 100%;
                padding: 12px;
                background-color: #222;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
            }

            .login-link {
                text-align: center;
                font-size: 14px;
            }

            .login-link a {
                text-decoration: underline;
            }

            .input-wrapper {
                position: relative;
            }

            .input-wrapper input {
            }

            .input-status {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 14px;
                color: gray;
            }

            .input-status.valid {
                color: green;
            }

            .input-wrapper input.invalid {
                border-color: red;
            }

            .input-status.invalid {
                color: red;
            }

            .error-message {
                color: red;
                font-size: 13px;
                margin-top: 3px;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h1>Complete your account information</h1>
            <p class="subtitle">
                Please fill in your information to create an account
            </p>

            <form action="<%=request.getContextPath()%>/complete-profile" method="post">
                <input type="hidden" id="role" name="role" value="${param.role}">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <div class="input-wrapper">
                            <input type="text" id="firstName" name="firstName" value="${sessionScope.tempUser.firstName}" readonly />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <div class="input-wrapper">
                            <input type="text" id="lastName" name="lastName" value="${sessionScope.tempUser.lastName}" readonly />
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-wrapper">
                            <input type="text" id="username" name="username" placeholder="Username" required />
                            <span class="input-status" id="usernameStatus"></span>
                        </div>
                        <div class="error-message" id="usernameError"></div>
                    </div>
                    <div class="form-group">
                        <label for="birthdate">Birthdate</label>
                        <div class="input-wrapper">
                            <input type="text" id="birthdate" name="birthdate" placeholder="yyyy-mm-dd" required />
                            <span class="input-status" id="birthdateStatus"></span>
                        </div>
                        <div class="error-message" id="birthdateError"></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-wrapper">
                            <input type="password" id="password" name="password" placeholder="Password" required />
                            <span class="input-status" id="passwordStatus"></span>
                        </div>
                        <div class="error-message" id="passwordError"></div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <div class="input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required />
                            <span class="input-status" id="confirmPasswordStatus"></span>
                        </div>
                        <div class="error-message" id="confirmPasswordError"></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="input-wrapper">
                            <input type="email" id="email" name="email" value="${sessionScope.tempUser.emailAddress}" readonly />
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="country">Country</label>
                        <select id="country" name="country" class="form-control" onchange="onCountryChange()" required>
                            <option value="">Select Country</option>
                            <c:forEach var="c" items="${countries}">
                                <option value="${c.code}" data-prefix="${c.prefix}">${c.name}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message" id="countryError"></div>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <div class="input-wrapper phone-input">
                            <input type="text" class="prefix-code" id="prefixCode" name="prefixCode" value="" disabled />
                            <input type="tel" id="phone" name="phone" placeholder="Phone number" required />
                            <span class="input-status" id="phoneStatus"></span>
                        </div>
                        <div class="error-message" id="phoneError"></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="address">Address</label>
                        <div class="input-wrapper">
                            <input type="text" id="address" name="address" class="form-control" placeholder="Enter your address" required />
                        </div>
                    </div>
                </div>

                <button type="submit" class="submit-btn">Complete Profile</button>
            </form>
        </div>

        <script>
            <%--Pikaday--%>
            var picker = new Pikaday({
                field: document.getElementById('birthdate'),
                minDate: new Date(1900, 0, 1),
                maxDate: new Date(),
                yearRange: [1900, 2025],
                onSelect: function (date) {
                    var month = date.getMonth() + 1;
                    var day = date.getDate();
                    var year = date.getFullYear();
                    month = month < 10 ? '0' + month : month;
                    day = day < 10 ? '0' + day : day;
                    var formattedDate = year + '-' + month + '-' + day;
                    document.getElementById('birthdate').value = formattedDate;
                }
            });

            <%--Phone prefix--%>
            function onCountryChange() {
                const countrySelect = document.getElementById("country");
                const countryCode = countrySelect.value;
                const prefix = countrySelect.options[countrySelect.selectedIndex].getAttribute("data-prefix");

                document.getElementById("prefixCode").value = prefix;
            }

            <%--Validation--%>
            const touchedFields = {};
            const validFields = {};

            function showError(id, message) {
                document.getElementById(id + "Error").innerText = message;
                document.getElementById(id + "Status").innerText = "";
                document.getElementById(id + "Status").classList.add("invalid");
                validFields[id] = false;
            }

            function clearError(id) {
                document.getElementById(id + "Error").innerText = "";
                document.getElementById(id + "Status").innerText = "";
                document.getElementById(id + "Status").classList.remove("invalid");
                validFields[id] = true;
                updateStatusIcon(id);
            }

            function updateStatusIcon(id) {
                const icon = document.getElementById(id + "Status");
                const input = document.getElementById(id);

                if (touchedFields[id] && validFields[id]) {
                    icon.innerText = "✔";
                    icon.classList.add("valid");
                    icon.classList.remove("invalid");
                    input.classList.remove("invalid");
                } else if (touchedFields[id] && !validFields[id]) {
                    icon.innerText = "❌";
                    icon.classList.add("invalid");
                    icon.classList.remove("valid");
                    input.classList.add("invalid");
                } else {
                    icon.innerText = "";
                    icon.classList.remove("valid");
                    icon.classList.remove("invalid");
                    input.classList.remove("invalid");
                }
            }

            function validateUsername() {
                const username = document.getElementById("username").value;
                const regex = /^[A-Za-z0-9_.]{5,}$/;
                return regex.test(username);
            }

            function validatePhone() {
                const phone = document.getElementById("phone").value;
                const regex = /^[0-9]{9,15}$/;
                return regex.test(phone);
            }

            function validatePassword() {
                const pw = document.getElementById("password").value;
                const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d_.]{8,}$/;
                return regex.test(pw);
            }

            function validateConfirmPassword() {
                const pw = document.getElementById("password").value;
                const cpw = document.getElementById("confirmPassword").value;
                if (!cpw) {
                    showError("confirmPassword", "This field is required.");
                    validFields["confirmPassword"] = false;
                } else if (pw !== cpw) {
                    showError("confirmPassword", "Passwords do not match.");
                    validFields["confirmPassword"] = false;
                } else {
                    clearError("confirmPassword");
                    validFields["confirmPassword"] = true;
                }
            }

            function validateBirthdate() {
                const bd = document.getElementById("birthdate").value.trim();
                const regex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/;

                if (!bd) {
                    showError("birthdate", "This field is required.");
                    validFields["birthdate"] = false;
                    return;
                }

                if (!regex.test(bd)) {
                    showError("birthdate", "Birthdate must follow yyyy-mm-dd format.");
                    validFields["birthdate"] = false;
                    return;
                }

                const parts = bd.split("-");
                const year = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10);
                const day = parseInt(parts[2], 10);
                const inputDate = new Date(year, month - 1, day);

                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (inputDate >= today) {
                    showError("birthdate", "Birthdate must be in the past.");
                    validFields["birthdate"] = false;
                    return;
                }

                clearError("birthdate");
                validFields["birthdate"] = true;
            }

            function validateField(fieldId, validationFn, errorMessage) {
                const value = document.getElementById(fieldId).value.trim();
                if (!value) {
                    showError(fieldId, "This field is required.");
                    validFields[fieldId] = false;
                } else if (validationFn && !validationFn(value)) {
                    showError(fieldId, errorMessage);
                    validFields[fieldId] = false;
                } else {
                    clearError(fieldId);
                    validFields[fieldId] = true;
                }
            }

            function autoEnhanceInputs() {
                const inputs = document.querySelectorAll("input:not([type=checkbox]), textarea");
                inputs.forEach(input => {
                    const id = input.id;
                    if (!id)
                        return;

                    const wrapper = input.closest(".input-wrapper");
                    if (!wrapper)
                        return;

                    if (!wrapper.querySelector(".input-status")) {
                        const status = document.createElement("span");
                        status.className = "input-status";
                        status.id = id + "Status";
                        wrapper.appendChild(status);
                    }

                    const parentGroup = wrapper.closest(".form-group");
                    if (parentGroup && !parentGroup.querySelector(".error-message")) {
                        const error = document.createElement("div");
                        error.className = "error-message";
                        error.id = id + "Error";
                        parentGroup.appendChild(error);
                    }
                });
            }

            window.addEventListener("DOMContentLoaded", () => {
                autoEnhanceInputs();

                document.getElementById("username").addEventListener("blur", () => {
                    touchedFields["username"] = true;
                    validateField("username", validateUsername, "Username must have at least 5 letters.");
                    if (validFields["username"]) {
                        const input = document.getElementById("username");
                        const value = input.value;

                        fetch("/SWP391_M2_BL5_G5_SP25/signup?check=username&value=" + encodeURIComponent(value))
                                .then(res => res.json())
                                .then(data => {
                                    if (input.value !== value) {
                                        return;
                                    }

                                    input.disabled = false;
                                    input.style.color = "";

                                    if (!data.valid) {
                                        showError("username", data.message);
                                        validFields["username"] = false;
                                    } else {
                                        clearError("username");
                                        validFields["username"] = true;
                                    }
                                })
                                .catch(() => {
                                    input.disabled = false;
                                    input.style.color = "";
                                    showError("username", "Unable to check uniqueness.");
                                    validFields["username"] = false;
                                });
                    }
                });

                document.getElementById("phone").addEventListener("blur", () => {
                    touchedFields["phone"] = true;
                    validateField("phone", validatePhone, "Phone number must be between 9 and 15 digits.");
                    if (validFields["phone"]) {
                        const input = document.getElementById("phone");
                        const value = input.value;

                        fetch("/SWP391_M2_BL5_G5_SP25/signup?check=phone&value=" + encodeURIComponent(value))
                                .then(res => res.json())
                                .then(data => {
                                    if (input.value !== value) {
                                        return;
                                    }

                                    input.disabled = false;
                                    input.style.color = "";

                                    if (!data.valid) {
                                        showError("phone", data.message);
                                        validFields["phone"] = false;
                                    } else {
                                        clearError("phone");
                                        validFields["phone"] = true;
                                    }
                                })
                                .catch(() => {
                                    input.disabled = false;
                                    input.style.color = "";
                                    showError("phone", "Unable to check uniqueness.");
                                    validFields["phone"] = false;
                                });
                    }
                });

                document.getElementById("password").addEventListener("blur", () => {
                    touchedFields["password"] = true;
                    validateField("password", validatePassword, "Password must be at least 8 characters, and contain at least one uppercase, one lowercase and one number.");
                });

                document.getElementById("confirmPassword").addEventListener("blur", () => {
                    touchedFields["confirmPassword"] = true;
                    validateConfirmPassword();
                });

                document.getElementById("birthdate").addEventListener("blur", () => {
                    touchedFields["birthdate"] = true;
                    validateBirthdate();
                });

                document.querySelector("form").addEventListener("submit", e => {
                    let allValid = true;

                    for (let fieldId in validFields) {
                        if (validFields.hasOwnProperty(fieldId) && !validFields[fieldId]) {
                            allValid = false;
                            break;
                        }
                    }
                    if (!allValid) {
                        e.preventDefault();
                        alert("Please correct the errors before submitting the form.");
                    }
                });
            });
        </script>
    </body>
</html>