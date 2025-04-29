<%-- 
    Document   : ViewProfileDetails
    Created on : 27 Apr 2025, 04:50:00
    Author     : Rinaaaa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <style>
            @import url("https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css");
            * {
                -webkit-font-smoothing: antialiased;
                box-sizing: border-box;
            }

            html,
            body {
                margin: 0px;
                height: 100%;
            }

            button:focus-visible {
                outline: 2px solid #4a90e2 !important;
                outline: -webkit-focus-ring-color auto 5px !important;
            }
            a {
                text-decoration: none;
            }

            .view-profile-detail {
                display: inline-flex;
                flex-direction: column;
                align-items: flex-start;
                position: relative;
                background-color: #ffffff;
                border: 2px solid;
                border-color: #ced4da;
                width: 100%;
            }

            .view-profile-detail .body {
                display: inline-flex;
                flex-direction: column;
                align-items: flex-start;
                position: relative;
                flex: 0 0 auto;
                border: 0px none;
                width: 100%;
            }
            
            .view-profile-detail .div-wrapper {
                position: relative;
                width: 768px;
                height: 610px;
                top: 32px;
                left: 336px;
                border: 0px none;
            }

            .view-profile-detail .div {
                position: relative;
                width: 1440px;
                height: 1440px;
                background-color: #f9fafb;
                border: 0px none;
                width: 100%;
            }

            .view-profile-detail .div-2 {
                position: relative;
                width: 736px;
                height: 610px;
                top: 305px;
                left: 32px;
                background-color: #ffffff;
                border-radius: 12px;
                border: 0px none;
                box-shadow: 0px 1px 2px #0000000d;
            }

            .view-profile-detail .div-3 {
                position: absolute;
                width: 672px;
                height: 129px;
                top: 32px;
                left: 32px;
                border-bottom-width: 1px;
                border-bottom-style: solid;
                border-color: #e5e7eb;
            }

            .view-profile-detail .div-4 {
                position: relative;
                width: 181px;
                height: 56px;
                top: 20px;
                left: 120px;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper {
                position: absolute;
                width: 172px;
                top: 2px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 24px;
                letter-spacing: 0;
                line-height: 24px;
                white-space: nowrap;
            }

            .view-profile-detail .text-wrapper-2 {
                position: absolute;
                width: 176px;
                top: 34px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .div-5 {
                position: absolute;
                width: 672px;
                height: 280px;
                top: 193px;
                left: 32px;
                border: 0px none;
            }

            .view-profile-detail .div-6 {
                position: absolute;
                width: 672px;
                height: 52px;
                top: 0;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .div-7 {
                position: absolute;
                width: 324px;
                height: 52px;
                top: 0;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .label {
                position: absolute;
                width: 324px;
                height: 20px;
                top: 0;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper-3 {
                position: absolute;
                width: 71px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-4 {
                width: 39px;
                position: absolute;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .div-8 {
                position: absolute;
                width: 324px;
                height: 52px;
                top: 0;
                left: 348px;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper-5 {
                position: absolute;
                width: 70px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-6 {
                width: 73px;
                position: absolute;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .div-9 {
                position: absolute;
                width: 672px;
                height: 52px;
                top: 76px;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .label-2 {
                position: absolute;
                width: 672px;
                height: 20px;
                top: 0;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper-7 {
                position: absolute;
                width: 92px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-8 {
                position: absolute;
                width: 220px;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .div-10 {
                position: absolute;
                width: 672px;
                height: 52px;
                top: 152px;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper-9 {
                position: absolute;
                width: 98px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-10 {
                position: absolute;
                width: 134px;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .text-wrapper-11 {
                position: absolute;
                width: 83px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-12 {
                position: absolute;
                width: 111px;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .div-11 {
                position: absolute;
                width: 672px;
                height: 52px;
                top: 228px;
                left: 0;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper-13 {
                position: absolute;
                width: 53px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-14 {
                position: absolute;
                width: 102px;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .text-wrapper-15 {
                position: absolute;
                width: 87px;
                top: 1px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #6b7280;
                font-size: 14px;
                letter-spacing: 0;
                line-height: normal;
            }

            .view-profile-detail .text-wrapper-16 {
                width: 148px;
                position: absolute;
                top: 30px;
                left: 0;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #111827;
                font-size: 16px;
                letter-spacing: 0;
                line-height: 16px;
                white-space: nowrap;
            }

            .view-profile-detail .button-wrapper {
                position: absolute;
                width: 672px;
                height: 73px;
                top: 505px;
                left: 32px;
                border-top-width: 1px;
                border-top-style: solid;
                border-color: #e5e7eb;
            }

            .view-profile-detail .button {
                all: unset;
                box-sizing: border-box;
                position: relative;
                width: 194px;
                height: 40px;
                top: 33px;
                background-color: #2563eb;
                border-radius: 8px;
                border: 0px none;
            }

            .view-profile-detail .text-wrapper-17 {
                position: absolute;
                width: 134px;
                top: 10px;
                left: 40px;
                font-family: "Rubik-Regular", Helvetica;
                font-weight: 400;
                color: #ffffff;
                font-size: 16px;
                text-align: center;
                letter-spacing: 0;
                line-height: normal;
                white-space: nowrap;
            }

            .view-profile-detail .i {
                position: absolute;
                width: 16px;
                height: 16px;
                top: 12px;
                left: 16px;
                border: 0px none;
            }

            .view-profile-detail .svg {
                display: flex;
                width: 16px;
                height: 16px;
                align-items: center;
                justify-content: center;
                position: relative;
            }

            .view-profile-detail .frame {
                position: relative;
                width: 16px;
                height: 16px;
            }
        </style>
    </head>
    <body>
        <div class="view-profile-detail">
            <div class="body">
                <div class="div">
                    <div class="div-wrapper">
                        <div class="div-2">
                            <div class="div-3">
                                <div class="div-4">
                                    <div class="text-wrapper">${user.firstName} ${user.lastName}</div>
                                </div>
                            </div>
                            <div class="div-5">
                                <div class="div-6">
                                    <div class="div-7">
                                        <div class="label"><div class="text-wrapper-3">First Name</div></div>
                                        <div class="text-wrapper-4">${user.firstName}</div>
                                    </div>
                                    <div class="div-8">
                                        <div class="label"><div class="text-wrapper-5">Last Name</div></div>
                                        <div class="text-wrapper-6">${user.lastName}</div>
                                    </div>
                                </div>
                                <div class="div-9">
                                    <div class="label-2"><div class="text-wrapper-7">Email Address</div></div>
                                    <div class="text-wrapper-8">${user.emailAddress}</div>
                                </div>
                                <div class="div-10">
                                    <div class="div-7">
                                        <div class="label"><div class="text-wrapper-9">Phone Number</div></div>
                                        <div class="text-wrapper-10">${user.phoneNumber}</div>
                                    </div>
                                    <div class="div-8">
                                        <div class="label"><div class="text-wrapper-11">Date of Birth</div></div>
                                        <div class="text-wrapper-12">${formattedDob}</div>
                                    </div>
                                </div>
                                <div class="div-11">
                                    <div class="div-7">
                                        <div class="label"><div class="text-wrapper-13">Country</div></div>
                                        <div class="text-wrapper-14">${user.country.name}</div>
                                    </div>
                                    <div class="div-8">
                                        <div class="label"><div class="text-wrapper-15">Created Time</div></div>
                                        <div class="text-wrapper-16">${formattedCreatedAt}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="button-wrapper">
                                <button class="button">
                                    <a href="forgot-password" class="text-wrapper-17">Change Password</a>
                                    <div class="i">
                                        <div class="svg"><img class="frame" src="../img/key.svg" /></div>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>