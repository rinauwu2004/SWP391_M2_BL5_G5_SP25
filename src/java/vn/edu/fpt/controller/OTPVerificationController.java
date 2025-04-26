/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Rinaaaa
 */
public class OTPVerificationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/OTPVerification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String otpPurpose = (String) session.getAttribute("otpPurpose");

        String otp = request.getParameter("otp");
        String otpStore = (String) session.getAttribute("otp");

        Integer attemptCount = (Integer) session.getAttribute("attemptCount");
        if (attemptCount == null) {
            attemptCount = 0;
        }
        long currentTime = System.currentTimeMillis();

        // Check OTP
        if (otp == null || !otp.equals(otpStore)) {
            attemptCount++;
            session.setAttribute("attemptCount", attemptCount);

            if (attemptCount >= 5) {
                session.setAttribute("lockTime", currentTime);
                session.removeAttribute("otp");
                session.removeAttribute("timeout");
                session.removeAttribute("attemptCount");
                session.setAttribute("error", "Unable to verify your account.");
                response.sendRedirect(request.getContextPath() + "/" + otpPurpose);
                return;
            }

            request.setAttribute("otpInvalid", "Invalid OTP. Try again!!!");
            request.getRequestDispatcher("/OTPVerification.jsp").forward(request, response);
            return;
        }

        session.removeAttribute("otp");
        session.removeAttribute("timeout");
        session.removeAttribute("attemptCount");
        session.removeAttribute("lockTime");

        session.setAttribute("otpVerified", true);

        switch (otpPurpose) {
            case "signup" -> response.sendRedirect(request.getContextPath() + "/user/create");
            case "forgot-password" -> response.sendRedirect(request.getContextPath() + "/user/forgot-password");
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles OTP verification only.";
    }
}
