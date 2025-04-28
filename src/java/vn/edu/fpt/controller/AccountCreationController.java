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
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.Country;
import vn.edu.fpt.model.Role;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class AccountCreationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        createAccount(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        createAccount(request, response);
    }

    private void createAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");

        if (otpVerified == null || !otpVerified) {
            session.setAttribute("error", "Please verify OTP first.");
            response.sendRedirect(request.getContextPath() + "/signup");
            return;
        }

        try {
            Role role = (Role) session.getAttribute("role");
            String username = (String) session.getAttribute("username");
            String passwordHash = (String) session.getAttribute("passwordHash");
            String passwordSalt = (String) session.getAttribute("passwordSalt");
            String firstName = (String) session.getAttribute("firstName");
            String lastName = (String) session.getAttribute("lastName");
            Date dob = (Date) session.getAttribute("dob");
            Country country = (Country) session.getAttribute("country");
            String phoneNumber = (String) session.getAttribute("phoneNumber");
            String emailAddress = (String) session.getAttribute("email");
            String address = (String) session.getAttribute("address");

            if (username == null || passwordHash == null || passwordSalt == null
                    || firstName == null || lastName == null || dob == null
                    || country == null || phoneNumber == null || emailAddress == null
                    || address == null || role == null) {
                request.setAttribute("error", "Missing user data. Try again!!!");
                request.getRequestDispatcher("/Signup.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setHashPassword(passwordHash);
            user.setSaltPassword(passwordSalt);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setDob(dob);
            user.setCountry(country);
            user.setPhoneNumber(phoneNumber);
            user.setEmailAddress(emailAddress);
            user.setAddress(address);
            user.setRole(role);

            UserDao userDao = new UserDao();
            userDao.addUser(user);

            // Sau khi tạo thành công: clear session data
            session.invalidate();

            request.setAttribute("message", "Sign up successfully. Now you can sign in!");
            request.getRequestDispatcher("/Signin.jsp").forward(request, response);
        } catch (ServletException | IOException ex) {
            Logger.getLogger(AccountCreationController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Something went wrong while creating your account. Please try again.");
            request.getRequestDispatcher("/Signup.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles account creation after OTP verification.";
    }
}
