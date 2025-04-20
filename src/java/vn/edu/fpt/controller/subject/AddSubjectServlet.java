/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller.subject;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.SubjectDAO;
import vn.edu.fpt.model.Subject;

@WebServlet(name = "AddSubjectServlet", urlPatterns = {"/addSubject"})
public class AddSubjectServlet extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddSubjectServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddSubjectServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        request.getRequestDispatcher("views/admin/subject/addSubject.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String code = request.getParameter("code");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String statusStr = request.getParameter("status");

            if (code == null || code.trim().isEmpty()
                    || name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Code and Name are required.");
                request.getRequestDispatcher("views/admin/subject/listSubject.jsp").forward(request, response);
                return;
            }

            Subject subject = new Subject();
            subject.setCode(code.trim());
            subject.setName(name.trim());
            subject.setDescription(description != null ? description.trim() : null);
            subject.setStatus(statusStr != null ? Boolean.parseBoolean(statusStr) : true);
            subject.setCreatedAt(new java.util.Date());
            subject.setModifiedAt(new java.util.Date());

            SubjectDAO dao = new SubjectDAO();
            boolean isAdd = dao.addSubject(subject);

            if (isAdd) {
                HttpSession session = request.getSession();
                session.setAttribute("message", "Subject created successfully.");
                response.sendRedirect("list-subject");

            } else {
                request.setAttribute("error", "Subject creation failed");
                request.getRequestDispatcher("views/admin/subject/listSubject.jsp").forward(request, response);

            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid subject data: " + e.getMessage());
            request.getRequestDispatcher("views/admin/subject/listSubject.jsp").forward(request, response);
        } catch (RuntimeException e) {
            request.setAttribute("error", "Failed to add subject: " + e.getMessage());
            request.getRequestDispatcher("views/admin/subject/listSubject.jsp").forward(request, response);
        }
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
