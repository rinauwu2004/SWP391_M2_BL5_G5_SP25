///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package vn.edu.fpt.controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.sql.Date;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//import vn.edu.fpt.dao.CountryDao;
//import vn.edu.fpt.dao.UserDao;
//import vn.edu.fpt.model.Country;
//import vn.edu.fpt.model.User;
//
///**
// *
// * @author Rinaaaa
// */
//public class OTPVerificationController extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.getRequestDispatcher("OTPVerification.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        CountryDao countryDao = new CountryDao();
//        UserDao userDao = new UserDao();
//
//        String otp = request.getParameter("otp");
//        String otpStore = (String) session.getAttribute("otp");
//
//        if (otp == null || !otp.equals(otpStore)) {
//            request.setAttribute("otpInvalid", "Invalid OTP. Try again!!!");
//            request.getRequestDispatcher("/OTPVerification.jsp").forward(request, response);
//            return;
//        }
//
//        session.removeAttribute("otp");
//        session.removeAttribute("timeout");
//
//        String username = (String) session.getAttribute("username");
//        String passwordHash = (String) session.getAttribute("passwordHash");
//        String passwordSalt = (String) session.getAttribute("passwordSalt");
//        String firstName = (String) session.getAttribute("firstName");
//        String lastName = (String) session.getAttribute("lastName");
//        Date dob = (Date) session.getAttribute("dob");
//        Country country = (Country) session.getAttribute("country");
//        String phoneNumber = (String) session.getAttribute("phoneNumber");
//        String emailAddress = (String) session.getAttribute("email");
//        String address = (String) session.getAttribute("address");
//        
//        if (username == null || passwordHash == null || passwordSalt == null
//                || firstName == null || lastName == null || dob == null
//                || country == null || phoneNumber == null || emailAddress == null
//                || address == null) {
//            request.setAttribute("error", "Missing user data. Try again!!!");
//            request.getRequestDispatcher("/OTPVerification.jsp").forward(request, response);
//            return;
//        }
//
//        User user = new User();
//        user.setUsername(username);
//        user.setHashPassword(passwordHash);
//        user.setSaltPassword(passwordSalt);
//        user.setFirstName(firstName);
//        user.setLastName(lastName);
//        user.setDob(dob);
//        user.setCountry(country);
//        user.setPhoneNumber(phoneNumber);
//        user.setEmailAddress(emailAddress);
//        user.setAddress(address);
//
//        try {
//            userDao.addUser(user);
//            System.out.println("✅ User inserted successfully: " + username);
//            response.sendRedirect(request.getContextPath() + "/Signin.jsp");
//        } catch (Exception ex) {
//            System.out.println("❌ Error inserting user: " + ex.getMessage());
//            Logger.getLogger(OTPVerificationController.class.getName()).log(Level.SEVERE, null, ex);
//
//            request.setAttribute("error", "Something went wrong while creating your account. Please try again.");
//            request.getRequestDispatcher("OTPVerification.jsp").forward(request, response);
//        }
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
