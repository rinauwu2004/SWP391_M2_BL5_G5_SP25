/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vn.edu.fpt.controller;
import vn.edu.fpt.model.Answer;
import vn.edu.fpt.model.Quiz;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.dao.QuizDao;

/**
 *
 * @author Rinaaaa
 */
@MultipartConfig
public class ImportDocxQuestionController extends HttpServlet {

    public static class QuestionWithAnswers {

        private String content;
        private List<Answer> answers;

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public List<Answer> getAnswers() {
            return answers;
        }

        public void setAnswers(List<Answer> answers) {
            this.answers = answers;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            Part filePart = request.getPart("file");
            InputStream inputStream = filePart.getInputStream();

            List<QuestionWithAnswers> importedQuestions = new ArrayList<>();
            try (XWPFDocument doc = new XWPFDocument(inputStream)) {
                List<XWPFParagraph> paragraphs = doc.getParagraphs();

                QuestionWithAnswers currentQuestion = null;
                List<Answer> currentAnswers = new ArrayList<>();

                for (XWPFParagraph para : paragraphs) {
                    String text = para.getText().trim();
                    if (text.matches("^\\d+\\.\\s+.+")) {
                        if (currentQuestion != null) {
                            currentQuestion.setAnswers(new ArrayList<>(currentAnswers));
                            importedQuestions.add(currentQuestion);
                        }
                        currentQuestion = new QuestionWithAnswers();
                        currentQuestion.setContent(text.substring(text.indexOf('.') + 1).trim());
                        currentAnswers.clear();
                    } else if (text.matches("^[A-Za-z]\\..+")) {
                        Answer answer = new Answer();
                        boolean isCorrect = text.contains("✔") || text.contains("*") || text.toLowerCase().contains("[x]");
                        answer.setIsCorrect(isCorrect);
                        answer.setContent(text.replaceAll("(?i)\\[x\\]|✔|\\*", "").substring(2).trim());
                        currentAnswers.add(answer);
                    }
                }

                if (currentQuestion != null) {
                    currentQuestion.setAnswers(currentAnswers);
                    importedQuestions.add(currentQuestion);
                }
            }

            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.get(quizId);
            
            request.setAttribute("quiz", quiz);
            request.setAttribute("importedQuestions", importedQuestions);
            request.getRequestDispatcher("../createQuestion.jsp").forward(request, response);

        } catch (ServletException | IOException | NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/quiz/createQuestion?error=import_fail");
        }
    }
}