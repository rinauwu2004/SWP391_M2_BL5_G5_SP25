/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller.module;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.dao.ModuleDAO;
import vn.edu.fpt.model.ModuleClass;

@WebServlet(name = "EditModuleServlet", urlPatterns = {"/editModule"})
public class EditModuleServlet extends HttpServlet {

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
            out.println("<title>Servlet EditModuleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditModuleServlet at " + request.getContextPath() + "</h1>");
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

        ModuleDAO moduleDao = new ModuleDAO();
        ModuleClass module = moduleDao.getModuleById(id);
        request.setAttribute("module", module);

        request.getRequestDispatcher("views/admin/module/editModule.jsp").forward(request, response);

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
        HttpSession session = request.getSession();

        String idParam = request.getParameter("id");
        String lessonIdParam = request.getParameter("lessonId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String url = request.getParameter("url");

        try {
            int id = Integer.parseInt(idParam);
            int lessonId = Integer.parseInt(lessonIdParam);

            ModuleDAO moduleDAO = new ModuleDAO();
            boolean isUpdate = moduleDAO.updateModule(id, name, description, url);

            if (isUpdate) {
                session.setAttribute("message", "Edit module successfully.");
            } else {
                session.setAttribute("error", "Edit module false.");

            }

            response.sendRedirect("module-list?id=" + lessonId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid module or lesson ID!");
            response.sendRedirect("editModule?id=" + request.getParameter("id")+"&lessonId=" + request.getParameter("lessonId"));
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while updating the module.");
            response.sendRedirect("editModule?id=" + request.getParameter("id")+"&lessonId=" + request.getParameter("lessonId"));
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
