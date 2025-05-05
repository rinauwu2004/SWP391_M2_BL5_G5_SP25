/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.LessonDAO;
import vn.edu.fpt.model.Lesson;

@WebServlet(name = "LessonEditServlet", urlPatterns = {"/lesson-edit"})
public class LessonEditServlet extends HttpServlet {

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
            out.println("<title>Servlet LessonEditServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LessonEditServlet at " + request.getContextPath() + "</h1>");
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
        int id = Integer.parseInt(request.getParameter("id"));
        LessonDAO lessonDao = new LessonDAO();
        Lesson lesson = lessonDao.getLessonById(id);
        request.setAttribute("lesson", lesson);
        request.getRequestDispatcher("views/admin/lesson/editLesson.jsp").forward(request, response);
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

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String lessonName = request.getParameter("lessonName");
            String description = request.getParameter("description");
            int status = Integer.parseInt(request.getParameter("status"));

            LessonDAO lessonDAO = new LessonDAO();
            boolean isUpdate = lessonDAO.updateLesson(id, lessonName, description, status);

            if (isUpdate) {
                session.setAttribute("message", "Edit lesson successfully.");
                            response.sendRedirect("viewLesson?id=" + request.getParameter("subjectId"));
return;
            } else {
                session.setAttribute("error", "Edit lesson false.");

            }
            response.sendRedirect("lesson-edit?id=" + id);

        } catch (Exception e) {
            e.printStackTrace();
           session.setAttribute("error", "An error occurred while updating the lesson.");
            response.sendRedirect("lesson-edit?id=" + request.getParameter("id"));
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
