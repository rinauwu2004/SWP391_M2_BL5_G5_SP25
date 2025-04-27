/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Rinaaaa
 */
public class JavaMail {
    public static void sendOTP(String email, String otp) {
        final String fromEmail = "daivdhe181300@fpt.edu.vn";
        final String password = "yazv tqpc ewhy gbyk";

        Properties pop = new Properties();
        pop.put("mail.smtp.host", "smtp.gmail.com");
        pop.put("mail.smtp.port", "587");
        pop.put("mail.smtp.auth", "true");
        pop.put("mail.smtp.starttls.enable", "true");

        Session session;
        session = Session.getInstance(pop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Verification your account");
            message.setText("Your OTP code: " + otp + "\nPlease do not share this code with anyone. OTP is valid for 5 minutes.");

            Transport.send(message);
        } catch (MessagingException ex) {
            Logger.getLogger(JavaMail.class.getName()).log(Level.SEVERE, "Error! Cannot send email!", ex);
        }
    }
    
    public static String createOTP(){
        final String OTP_CHARACTER = "1234567890";
        final int OTP_LENGTH = 6;
        
        StringBuilder otp = new StringBuilder();
        Random random = new  Random();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(OTP_CHARACTER.charAt(random.nextInt(OTP_CHARACTER.length())));
        }
        return otp.toString();
    }
}
