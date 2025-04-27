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
import java.util.List;
import vn.edu.fpt.dao.LessonDAO;
import vn.edu.fpt.model.Lesson;

@WebServlet(name = "ViewLessonServlet", urlPatterns = {"/viewLesson"})
public class ViewLessonServlet extends HttpServlet {

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
            out.println("<title>Servlet ViewLessonServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewLessonServlet at " + request.getContextPath() + "</h1>");
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
    String idParam = request.getParameter("id");
    String search = request.getParameter("search");
    String statusParam = request.getParameter("status");
    String pageParam = request.getParameter("page");

    int page = 1;
    int pageSize = 5; // mỗi trang 5

    if (pageParam != null && !pageParam.isEmpty()) {
        page = Integer.parseInt(pageParam);
    }

    LessonDAO lessonDao = new LessonDAO();
    List<Lesson> listLesson;
    int totalLessons;
    int totalPages;

    Integer status = null;
    if (statusParam != null && !statusParam.isEmpty()) {
        status = Integer.parseInt(statusParam);
    }

    totalLessons = lessonDao.countLessonBySubjectId(Integer.parseInt(idParam), search, status);
    totalPages = (int) Math.ceil((double) totalLessons / pageSize);

    int offset = (page - 1) * pageSize;
    listLesson = lessonDao.searchLessonBySubjectIdWithPagination(Integer.parseInt(idParam), search, status, offset, pageSize);

    request.setAttribute("listLesson", listLesson);
    request.setAttribute("search", search);
    request.setAttribute("status", statusParam);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("idParam", idParam);

    request.getRequestDispatcher("views/admin/lesson/listLesson.jsp").forward(request, response);
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
        return "Short description";
    }// </editor-fold>

}
