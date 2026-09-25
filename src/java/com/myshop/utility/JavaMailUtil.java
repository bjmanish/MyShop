package com.myshop.utility;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
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


/**
 * Utility class for sending MYSHOP emails.
 *
 * Supports:
 *  - Plain text welcome email
 *  - HTML emails
 *  - HTML emails with PDF attachments
 *
 * SMTP configuration is loaded from application.properties:
 *
 * mailer.email=your-email@gmail.com
 * mailer.password=your-app-password
 */
public class JavaMailUtil {

    private static final Logger LOGGER =
            Logger.getLogger(JavaMailUtil.class.getName());

    // =========================================================
    // SMTP CONFIGURATION
    // =========================================================

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "465";

    private static final int SMTP_CONNECTION_TIMEOUT = 10000;
    private static final int SMTP_TIMEOUT = 15000;
    private static final int SMTP_WRITE_TIMEOUT = 15000;


    // =========================================================
    // PRIVATE CONSTRUCTOR
    // =========================================================

    private JavaMailUtil() {
        // Utility class
    }


    // =========================================================
    // LOAD MAIL CONFIGURATION
    // =========================================================

    private static MailConfiguration loadMailConfiguration() {

        try {

            ResourceBundle rb =
                    ResourceBundle.getBundle("application");

            String emailId =
                    rb.getString("mailer.email").trim();

            String password =
                    rb.getString("mailer.password").trim();

            if (emailId.isEmpty()) {
                throw new IllegalStateException(
                        "mailer.email is empty in application.properties"
                );
            }

            if (password.isEmpty()) {
                throw new IllegalStateException(
                        "mailer.password is empty in application.properties"
                );
            }

            return new MailConfiguration(emailId, password);

        } catch (Exception e) {

            LOGGER.log(
                    Level.SEVERE,
                    "Unable to load mail configuration.",
                    e
            );

            throw e;
        }
    }


    // =========================================================
    // SMTP PROPERTIES
    // =========================================================

    private static Properties createMailProperties() {

        Properties properties = new Properties();

        properties.put(
                "mail.smtp.host",
                SMTP_HOST
        );

        properties.put(
                "mail.smtp.port",
                SMTP_PORT
        );

        properties.put(
                "mail.smtp.auth",
                "true"
        );

        // SSL
        properties.put(
                "mail.smtp.socketFactory.port",
                SMTP_PORT
        );

        properties.put(
                "mail.smtp.socketFactory.class",
                "javax.net.ssl.SSLSocketFactory"
        );

        properties.put(
                "mail.smtp.socketFactory.fallback",
                "false"
        );

        // Timeouts
        properties.put(
                "mail.smtp.connectiontimeout",
                String.valueOf(SMTP_CONNECTION_TIMEOUT)
        );

        properties.put(
                "mail.smtp.timeout",
                String.valueOf(SMTP_TIMEOUT)
        );

        properties.put(
                "mail.smtp.writetimeout",
                String.valueOf(SMTP_WRITE_TIMEOUT)
        );

        // UTF-8
        properties.put(
                "mail.mime.charset",
                StandardCharsets.UTF_8.name()
        );

        return properties;
    }


    // =========================================================
    // CREATE MAIL SESSION
    // =========================================================

    private static Session createMailSession(
            MailConfiguration configuration) {

        Properties properties =
                createMailProperties();

        Session session =
                Session.getInstance(
                        properties,
                        new MyAuthenticator(
                                configuration.email,
                                configuration.password
                        )
                );

        return session;
    }


    // =========================================================
    // SIMPLE WELCOME EMAIL
    // =========================================================

    public static void sendMail(
            String recipientMailId)
            throws MessagingException, UnsupportedEncodingException {

        validateEmail(recipientMailId);

        System.out.println(
                "Preparing to send welcome email to: "
                + recipientMailId
        );

        MailConfiguration configuration =
                loadMailConfiguration();

        Session session =
                createMailSession(configuration);

        Message message =
                prepareWelcomeMessage(
                        session,
                        configuration.email,
                        recipientMailId
                );

        Transport.send(message);

        System.out.println(
                "Welcome email sent successfully to: "
                + recipientMailId
        );
    }


    // =========================================================
    // WELCOME MESSAGE
    // =========================================================

    private static Message prepareWelcomeMessage(
            Session session,
            String fromEmail,
            String recipientEmail)
            throws MessagingException, UnsupportedEncodingException {

        MimeMessage message =
                new MimeMessage(session);

        message.setFrom(
                new InternetAddress(
                        fromEmail,
                        "THE MYSHOP STORE",
                        StandardCharsets.UTF_8.name()
                )
        );

        message.setRecipient(
                Message.RecipientType.TO,
                new InternetAddress(recipientEmail)
        );

        message.setSubject(
                "Welcome to THE MYSHOP STORE",
                StandardCharsets.UTF_8.name()
        );

        message.setText(
                "Hey! " + recipientEmail
                + ",\n\n"
                + "Thank you for signing up with THE MYSHOP STORE."
                + "\n\n"
                + "We are happy to have you with us.",
                StandardCharsets.UTF_8.name()
        );

        return message;
    }


    // =========================================================
    // HTML EMAIL
    // =========================================================

    protected static void sendMail(
            String recipient,
            String subject,
            String htmlTextMessage)
            throws MessagingException, UnsupportedEncodingException {

        validateEmail(recipient);

        if (subject == null || subject.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Email subject cannot be empty."
            );
        }

        if (htmlTextMessage == null
                || htmlTextMessage.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Email message cannot be empty."
            );
        }

        System.out.println(
                "Preparing HTML email..."
        );

        MailConfiguration configuration =
                loadMailConfiguration();

        Session session =
                createMailSession(configuration);

        Message message =
                prepareHtmlMessage(
                        session,
                        configuration.email,
                        recipient,
                        subject,
                        htmlTextMessage
                );

        Transport.send(message);

        System.out.println(
                "HTML email sent successfully to: "
                + recipient
        );
    }


    // =========================================================
    // PREPARE HTML MESSAGE
    // =========================================================

    private static Message prepareHtmlMessage(
            Session session,
            String fromEmail,
            String recipientEmail,
            String subject,
            String htmlTextMessage)
            throws MessagingException, UnsupportedEncodingException {

        MimeMessage message =
                new MimeMessage(session);

        message.setFrom(
                new InternetAddress(
                        fromEmail,
                        "THE MYSHOP STORE",
                        StandardCharsets.UTF_8.name()
                )
        );

        message.setRecipient(
                Message.RecipientType.TO,
                new InternetAddress(recipientEmail)
        );

        message.setSubject(
                subject,
                StandardCharsets.UTF_8.name()
        );

        message.setContent(
                htmlTextMessage,
                "text/html; charset=UTF-8"
        );

        message.setHeader(
                "X-Mailer",
                "THE MYSHOP STORE"
        );

        message.setHeader(
                "X-Priority",
                "3"
        );

        return message;
    }


    // =========================================================
    // EMAIL WITH PDF ATTACHMENT
    // =========================================================

    private static Message prepareMessageWithAttachment(
            Session session,
            String from,
            String to,
            String subject,
            String htmlText,
            byte[] pdfBytes,
            String fileName)
            throws MessagingException, UnsupportedEncodingException {

        if (pdfBytes == null || pdfBytes.length == 0) {

            throw new IllegalArgumentException(
                    "PDF attachment cannot be empty."
            );
        }

        if (fileName == null
                || fileName.trim().isEmpty()) {

            fileName = "MYSHOP-document.pdf";
        }

        MimeMessage message =
                new MimeMessage(session);

        message.setFrom(
                new InternetAddress(
                        from,
                        "THE MYSHOP STORE",
                        StandardCharsets.UTF_8.name()
                )
        );

        message.setRecipient(
                Message.RecipientType.TO,
                new InternetAddress(to)
        );

        message.setSubject(
                subject,
                StandardCharsets.UTF_8.name()
        );


        // -----------------------------------------------------
        // HTML BODY
        // -----------------------------------------------------

        BodyPart htmlPart =
                new MimeBodyPart();

        htmlPart.setContent(
                htmlText,
                "text/html; charset=UTF-8"
        );


        // -----------------------------------------------------
        // PDF ATTACHMENT
        // -----------------------------------------------------

        BodyPart attachmentPart =
                new MimeBodyPart();

        ByteArrayDataSource dataSource =
                new ByteArrayDataSource(
                        pdfBytes,
                        "application/pdf"
                );

        attachmentPart.setDataHandler(
                new DataHandler(dataSource)
        );

        attachmentPart.setFileName(
                fileName
        );


        // -----------------------------------------------------
        // MULTIPART
        // -----------------------------------------------------

        Multipart multipart =
                new MimeMultipart();

        multipart.addBodyPart(htmlPart);
        multipart.addBodyPart(attachmentPart);

        message.setContent(multipart);

        message.setHeader(
                "X-Mailer",
                "THE MYSHOP STORE"
        );

        return message;
    }


    // =========================================================
    // SEND EMAIL WITH ATTACHMENT
    // =========================================================

    protected static void sendMailWithAttach(
            String recipient,
            String subject,
            String htmlTextMessage,
            byte[] pdfBytes,
            String fileName)
            throws MessagingException, UnsupportedEncodingException {

        validateEmail(recipient);

        if (subject == null
                || subject.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Email subject cannot be empty."
            );
        }

        System.out.println(
                "Preparing email with attachment..."
        );

        MailConfiguration configuration =
                loadMailConfiguration();

        Session session =
                createMailSession(configuration);

        Message message =
                prepareMessageWithAttachment(
                        session,
                        configuration.email,
                        recipient,
                        subject,
                        htmlTextMessage,
                        pdfBytes,
                        fileName
                );

        Transport.send(message);

        System.out.println(
                "Email with attachment sent successfully to: "
                + recipient
        );
    }


    // =========================================================
    // EMAIL VALIDATION
    // =========================================================

    private static void validateEmail(
            String email)
            throws MessagingException {

        if (email == null
                || email.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Recipient email cannot be empty."
            );
        }

        InternetAddress address =
                new InternetAddress(email);

        address.validate();
    }


    // =========================================================
    // MAIL CONFIGURATION HOLDER
    // =========================================================

    private static class MailConfiguration {

        private final String email;
        private final String password;

        private MailConfiguration(
                String email,
                String password) {

            this.email = email;
            this.password = password;
        }
    }
}


/**
 * Gmail SMTP authentication.
 */
class MyAuthenticator
        extends javax.mail.Authenticator {

    private final String username;
    private final String password;

    public MyAuthenticator(
            String username,
            String password) {

        this.username = username;
        this.password = password;
    }

    @Override
    protected PasswordAuthentication
            getPasswordAuthentication() {

        return new PasswordAuthentication(
                username,
                password
        );
    }
}