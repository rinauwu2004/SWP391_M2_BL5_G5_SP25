/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.SubjectDAO;
import vn.edu.fpt.model.Subject;
import vn.edu.fpt.model.User;

/**
 *
 * @author ADMIN
 */
public class AdminSubjectServlet extends HttpServlet {

    private static final int SUBJECTS_PER_PAGE = 10;

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

        // Check if user is logged in and is an admin
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is an admin
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: list subjects
            listSubjects(request, response);
        } else {
            switch (action) {
                case "view":
                    viewSubject(request, response);
                    break;
                case "search":
                    searchSubjects(request, response);
                    break;
                default:
                    listSubjects(request, response);
                    break;
            }
        }
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is an admin
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Check if user is an admin
        if (user.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: list subjects
            listSubjects(request, response);
        } else {
            switch (action) {
                case "search":
                    searchSubjects(request, response);
                    break;
                default:
                    listSubjects(request, response);
                    break;
            }
        }
    }

    private void listSubjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get page number from request parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page number, use default
                page = 1;
            }
        }

        // Calculate offset for pagination
        int offset = (page - 1) * SUBJECTS_PER_PAGE;

        // Get subjects from database
        SubjectDAO subjectDao = new SubjectDAO();
        List<Subject> subjects = subjectDao.getSubjectsWithPagination(offset, SUBJECTS_PER_PAGE);
        int totalSubjects = subjectDao.countAllSubjects();
        int totalPages = (int) Math.ceil((double) totalSubjects / SUBJECTS_PER_PAGE);

        // Set attributes for the JSP
        request.setAttribute("subjects", subjects);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSubjects", totalSubjects);

        // Forward to the subject management JSP
        request.getRequestDispatcher("/admin/subjects.jsp").forward(request, response);
    }

    private void viewSubject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get subject ID from request parameter
        String subjectIdParam = request.getParameter("id");
        if (subjectIdParam == null || subjectIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(subjectIdParam);

            // Get subject from database
            SubjectDAO subjectDao = new SubjectDAO();
            Subject subject = subjectDao.getSubjectById(subjectId);

            if (subject == null) {
                // Subject not found
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                return;
            }

            // Set attributes for the JSP
            request.setAttribute("subject", subject);

            // Create an empty list for related quizzes (to be implemented later)
            List<Object> relatedQuizzes = new ArrayList<>();
            request.setAttribute("relatedQuizzes", relatedQuizzes);

            // Forward to the view subject JSP
            request.getRequestDispatcher("/admin/viewSubject.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Invalid subject ID format
            response.sendRedirect(request.getContextPath() + "/admin/subjects");
        }
    }

    private void searchSubjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get search parameters
        String searchTerm = request.getParameter("searchTerm");
        String searchBy = request.getParameter("searchBy");

        if (searchTerm == null || searchTerm.trim().isEmpty() || searchBy == null || searchBy.trim().isEmpty()) {
            // Invalid search parameters, show all subjects
            listSubjects(request, response);
            return;
        }

        // Get page number from request parameter
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page number, use default
                page = 1;
            }
        }

        // Calculate offset for pagination
        int offset = (page - 1) * SUBJECTS_PER_PAGE;

        // Search subjects in database
        SubjectDAO subjectDao = new SubjectDAO();
        List<Subject> subjects = subjectDao.searchSubjects(searchTerm, searchBy, offset, SUBJECTS_PER_PAGE);
        int totalSubjects = subjectDao.countSearchResults(searchTerm, searchBy);
        int totalPages = (int) Math.ceil((double) totalSubjects / SUBJECTS_PER_PAGE);

        // Set attributes for the JSP
        request.setAttribute("subjects", subjects);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSubjects", totalSubjects);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("isSearch", true);

        // Forward to the subject management JSP
        request.getRequestDispatcher("/admin/subjects.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Subject Management Servlet - Manages subjects in the admin panel";
    }
}
