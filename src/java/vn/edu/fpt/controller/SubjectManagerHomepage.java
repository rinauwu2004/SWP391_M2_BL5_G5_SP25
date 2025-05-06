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
import java.util.List;
import vn.edu.fpt.dao.SubjectDAO;
import vn.edu.fpt.dao.LessonDAO;
import vn.edu.fpt.dao.ModuleDAO;
import vn.edu.fpt.model.Subject;
import vn.edu.fpt.model.User;

/**
 *
 * @author Rinaaaa
 */
public class SubjectManagerHomepage extends HttpServlet {

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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is a Subject Manager
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is a Subject Manager
        if (!"Subject Manager".equals(user.getRole().getName())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get statistics for dashboard
        SubjectDAO subjectDAO = new SubjectDAO();
        LessonDAO lessonDAO = new LessonDAO();

        // Get total subjects count
        int totalSubjects = subjectDAO.countAllSubjects();
        request.setAttribute("totalSubjects", totalSubjects);

        // Get active subjects count
        int activeSubjects = subjectDAO.countActiveSubjects();
        request.setAttribute("activeSubjects", activeSubjects);

        // Get total lessons count (across all subjects)
        int totalLessons = 0;
        List<Subject> allSubjects = subjectDAO.getAllSubjects();
        for (Subject subject : allSubjects) {
            totalLessons += lessonDAO.countLessonBySubjectId(subject.getId(), null, null);
        }
        request.setAttribute("totalLessons", totalLessons);

        // Get total modules count
        // Since there's no direct method to count all modules, we'll set a placeholder
        // In a real implementation, you would add a method to ModuleDAO to count all modules
        request.setAttribute("totalModules", 0);

        // Get recent subjects (limit to 5)
        List<Subject> recentSubjects = subjectDAO.getSubjectsWithPagination(0, 5);
        request.setAttribute("recentSubjects", recentSubjects);

        request.getRequestDispatcher("../submanager/homepage.jsp").forward(request, response);
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
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
