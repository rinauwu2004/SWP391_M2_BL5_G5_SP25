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
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.edu.fpt.dao.AnswerDao;
import vn.edu.fpt.dao.QuestionDao;
import vn.edu.fpt.dao.QuizDao;
import vn.edu.fpt.model.Answer;
import vn.edu.fpt.model.Question;
import vn.edu.fpt.model.Quiz;

/**
 *
 * @author Rinaaaa
 */
public class CreateQuestionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("../createQuestion.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            QuestionDao questionDao = new QuestionDao();
            AnswerDao answerDao = new AnswerDao();
            QuizDao quizDao = new QuizDao();
            
            String quizId = request.getParameter("quiz");
            Quiz quiz = quizDao.get(Integer.parseInt(quizId));
            
            Map<String, String> questions = new LinkedHashMap<>();
            Map<String, List<AnswerTemp>> answers = new LinkedHashMap<>();
            
            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                String value = request.getParameter(paramName);

                if (paramName.startsWith("question_")) {
                    String questionId = paramName.substring("question_".length());
                    questions.put(questionId, value);
                } else if (paramName.startsWith("answer_")) {
                    String remain = paramName.substring("answer_".length());
                    String[] parts = remain.split("_"); // parts[0]: questionId, parts[1]: answerIndex
                    if (parts.length == 2) {
                        String questionId = parts[0];
                        String answerIndex = parts[1];

                        AnswerTemp answer = new AnswerTemp();
                        answer.content = value;
                        answer.isCorrect = request.getParameter("correct_" + questionId + "_" + answerIndex) != null;

                        answers.computeIfAbsent(questionId, k -> new ArrayList<>()).add(answer);
                    }
                }
            }
            
            for (String questionKey : questions.keySet()) {
                String questionContent = questions.get(questionKey);

                Question question = new Question();
                question.setQuiz(quiz);
                question.setContent(questionContent);
                questionDao.create(question);
                question = questionDao.get(questionContent);

                List<AnswerTemp> answerList = answers.get(questionKey);
                if (answerList != null) {
                    for (AnswerTemp temp : answerList) {
                        Answer answer = new Answer();
                        answer.setContent(temp.content);
                        answer.setIsCorrect(temp.isCorrect);
                        answer.setQuestion(question);
                        answerDao.create(answer);
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/quiz/list");
        } catch (IOException ex) {
            Logger.getLogger(CreateQuestionController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect(request.getContextPath() + "/quiz/list?error=error_create_question");
        }
    }
    
    private static class AnswerTemp {
        String content;
        boolean isCorrect;
    }
}
