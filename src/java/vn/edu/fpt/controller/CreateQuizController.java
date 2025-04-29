/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package vn.edu.fpt.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Quiz;
import vn.edu.fpt.model.User;
import static vn.edu.fpt.util.RandomQuizCode.generateRandomCode;

/**
 *
 * @author Rinaaaa
 */
public class CreateQuizController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User teacher = (User) session.getAttribute("user");
        if (teacher == null || teacher.getRole() == null 
                || !teacher.getRole().getName().equals("Teacher")) {
            String message = "You do not have right to access this page";
            request.setAttribute("errorMessage", message);
            request.getRequestDispatcher("../errorPage.jsp").forward(request, response);
        }
        
        request.getRequestDispatcher("../createQuiz.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        QuizDao quizDao = new QuizDao();
        User teacher = (User) session.getAttribute("user");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String code = "";
        
        try {
            do {
                code = generateRandomCode();
            }
            while (quizDao.isCodeExists(code));
        } catch (SQLException ex) {
            Logger.getLogger(CreateQuizController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        int timeLimit = Integer.parseInt(request.getParameter("timeLimit"));
        String status = request.getParameter("status").isEmpty() ? null : request.getParameter("status");
        
        if (timeLimit <= 0) {
            String message = "Time limit cannot less than or equal to 0.";
            request.setAttribute("errorMessage", message);
            request.getRequestDispatcher("../createQuiz.jsp").forward(request, response);
        }
        
        Quiz quiz = new Quiz();
        quiz.setTeacher(teacher);
        quiz.setTitle(title);
        quiz.setDescription(description);
        quiz.setTimeLimit(timeLimit);
        quiz.setStatus(status);
        quiz.setCode(code);
        quizDao.create(quiz);
        
        quiz = quizDao.get(code);
        
        request.setAttribute("quiz", quiz);
        request.getRequestDispatcher("../createQuestion.jsp").forward(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
