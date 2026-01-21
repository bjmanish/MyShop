package com.myshop.utility;

import java.util.Properties;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.activation.DataHandler;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;
import javax.servlet.http.HttpSession;

class MyAuthenticator extends javax.mail.Authenticator {

    private String username, password;

    public MyAuthenticator(String username, String password) {
        this.username = username;
        this.password = password;
    }

    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        PasswordAuthentication pwdAuth = new PasswordAuthentication(this.username, this.password);
        return pwdAuth;
    }

}

public class JavaMailUtil {
	public static void sendMail(String recipientMailId) throws MessagingException {

		System.out.println("Preparing to send Mail");
		Properties prop = new Properties();
		//String host = "smtp.gmail.com";
		prop = new Properties();
                prop.put("mail.smtp.host", "smtp.gmail.com");
                prop.put("mail.smtp.port", "465");
                prop.put("mail.smtp.auth", "true");
                prop.put("mail.smtp.socketFactory.port", "465");
                prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

		ResourceBundle rb = ResourceBundle.getBundle("application");

		String emailId = rb.getString("mailer.email");
		String passWord = rb.getString("mailer.password");

		prop.put("mail.user", emailId);
		prop.put("mail.password", passWord);

		Session session = Session.getInstance(prop, new MyAuthenticator(emailId, passWord));
                Message message = prepareMessage(session, emailId, recipientMailId);

		Transport.send(message);

		System.out.println("Message Sent Successfully!");
	}

	private static Message prepareMessage(Session session, String myAccountEmail, String recipientEmail) {

		try {

			Message message = new MimeMessage(session);

			message.setFrom(new InternetAddress(myAccountEmail));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
			message.setSubject("Welcome to MYSHOP Electronics");
			message.setText("Hey! " + recipientEmail + ", Thanks  for Signing Up with us!");
			return message;

		} catch (MessagingException exception) {
			Logger.getLogger(JavaMailUtil.class.getName()).log(Level.SEVERE, null, exception);
		}
		return null;

	}

	protected static void sendMail(String recipient, String subject, String htmlTextMessage) throws MessagingException {

		System.out.println("Preparing to send Mail");
		Properties prop = new Properties();
		prop = new Properties();
                prop.put("mail.smtp.host", "smtp.gmail.com");
                prop.put("mail.smtp.port", "465");
                prop.put("mail.smtp.auth", "true");
                prop.put("mail.smtp.socketFactory.port", "465");
                prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

		ResourceBundle rb = ResourceBundle.getBundle("application");

		String emailId = rb.getString("mailer.email");
		String passWord = rb.getString("mailer.password");

                prop.put("mail.user", emailId);
		prop.put("mail.password", passWord);

		Session session = Session.getInstance(prop, new MyAuthenticator(emailId, passWord));

		Message message = prepareMessage(session, emailId, recipient, subject, htmlTextMessage);

		Transport.send(message);

		System.out.println("Message Sent Successfully!");

	}
        
        
	private static Message prepareMessage(Session session, String myAccountEmail, String recipientEmail, String subject,String htmlTextMessage) {
		try {

			Message message = new MimeMessage(session);

			message.setFrom(new InternetAddress(myAccountEmail));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
			message.setSubject(subject);
			message.setContent(htmlTextMessage, "text/html");
			return message;

		} catch (MessagingException exception) {
			Logger.getLogger(JavaMailUtil.class.getName()).log(Level.SEVERE, null, exception);
		}
		return null;

	}
        
        
        private static Message prepareMessageWithAttachment(Session session, String from, String to, String subject, String text, byte[] pdfBytes, String fileName) throws MessagingException {

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(subject);

            // HTML Body
            BodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(text, "text/html; charset=UTF-8");

            // PDF Attachment
            BodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.setDataHandler(new DataHandler(new ByteArrayDataSource(pdfBytes, "application/pdf")));
            attachmentPart.setFileName(fileName);

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(htmlPart);
            multipart.addBodyPart(attachmentPart);

            message.setContent(multipart);

        return message;
    }
        
        protected static void sendMailWithAttach(String recipient, String subject, String htmlTextMessage,byte[] pdfBytes, String fileName) throws MessagingException {

		System.out.println("Preparing to send Mail");
		Properties prop = new Properties();
		prop = new Properties();
                prop.put("mail.smtp.host", "smtp.gmail.com");
                prop.put("mail.smtp.port", "465");
                prop.put("mail.smtp.auth", "true");
                prop.put("mail.smtp.socketFactory.port", "465");
                prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

		ResourceBundle rb = ResourceBundle.getBundle("application");

		String emailId = rb.getString("mailer.email");
		String passWord = rb.getString("mailer.password");

                prop.put("mail.user", emailId);
		prop.put("mail.password", passWord);

		Session session = Session.getInstance(prop, new MyAuthenticator(emailId, passWord));

		Message message = prepareMessageWithAttachment(session, emailId, recipient, subject, htmlTextMessage, pdfBytes, fileName);

		Transport.send(message);

		System.out.println("Message Sent Successfully!");

	}
        
        
        
        
}
