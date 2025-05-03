/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.dao.SubjectDAO;
import vn.edu.fpt.dao.TestDao;
import vn.edu.fpt.dao.UserDao;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class AdminReportServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is an admin (assuming role id 1 is admin)
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get statistics for report
        UserDao userDao = new UserDao();
        QuizDao quizDao = new QuizDao();
        SubjectDAO subjectDao = new SubjectDAO();
        TestDao testDao = new TestDao();

        // Get counts
        int totalStudents = userDao.countUsersByRole("Student");
        int totalTeachers = userDao.countUsersByRole("Teacher");
        int totalQuizzes = quizDao.countAllQuizzes();
        int totalSubjects = subjectDao.countAllSubjects();
        int totalTests = testDao.countAllTests();
        int totalTestAttempts = testDao.countAllTestAttempts();

        // Get active and inactive user counts (only students and teachers)
        int activeUsers = userDao.countStudentTeachersByStatusId(1);  // Status ID 1 is "Active"
        int inactiveUsers = userDao.countStudentTeachersByStatusId(2); // Status ID 2 is "Inactive"

        // Get current year for test attempts trend
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        int[] monthlyTestAttempts = testDao.getTestAttemptsByMonth(currentYear);

        // Convert monthly test attempts to JSON for chart
        StringBuilder testAttemptsJson = new StringBuilder("[");
        for (int i = 0; i < monthlyTestAttempts.length; i++) {
            testAttemptsJson.append(monthlyTestAttempts[i]);
            if (i < monthlyTestAttempts.length - 1) {
                testAttemptsJson.append(", ");
            }
        }
        testAttemptsJson.append("]");

        // Get all subject names for the subject distribution chart
        List<String> subjectNames = subjectDao.getAllSubjectNames();

        // Convert subject names to JSON array
        StringBuilder subjectNamesJson = new StringBuilder("[");
        for (int i = 0; i < subjectNames.size(); i++) {
            subjectNamesJson.append("\"").append(subjectNames.get(i)).append("\"");
            if (i < subjectNames.size() - 1) {
                subjectNamesJson.append(", ");
            }
        }
        subjectNamesJson.append("]");

        // Generate balanced counts for each subject (in a real application, you would get actual counts)
        StringBuilder subjectCountsJson = new StringBuilder("[");
        for (int i = 0; i < subjectNames.size(); i++) {
            // Use a fixed count for demonstration to ensure balanced chart
            int count = 5; // All subjects have the same count for balanced comparison
            subjectCountsJson.append(count);
            if (i < subjectNames.size() - 1) {
                subjectCountsJson.append(", ");
            }
        }
        subjectCountsJson.append("]");

        // Set attributes for the JSP
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalTeachers", totalTeachers);
        request.setAttribute("totalQuizzes", totalQuizzes);
        request.setAttribute("totalSubjects", totalSubjects);
        request.setAttribute("totalTests", totalTests);
        request.setAttribute("totalTestAttempts", totalTestAttempts);
        request.setAttribute("currentYear", currentYear);
        request.setAttribute("monthlyTestAttempts", testAttemptsJson.toString());
        request.setAttribute("subjectNames", subjectNamesJson.toString());
        request.setAttribute("subjectCounts", subjectCountsJson.toString());
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("inactiveUsers", inactiveUsers);

        // Forward to the report JSP
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Report Servlet - Displays admin reports";
    }// </editor-fold>
}
