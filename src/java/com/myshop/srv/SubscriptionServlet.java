package com.myshop.srv;



import com.myshop.utility.MailMessage;
import com.myshop.utility.dbUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.HttpServletRequest;

@WebServlet("/SubscriptionServlet")
public class SubscriptionServlet extends HttpServlet {

    

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Please enter your email address.\"}"
            );
            return;
        }

        email = email.trim().toLowerCase();

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Please enter a valid email address.\"}"
            );
            return;
        }

        String checkSql =
                "SELECT status FROM SUBSCRIPTIONS WHERE email = ?";

        String insertSql =
                "INSERT INTO SUBSCRIPTIONS (email, status) VALUES (?, 'ACTIVE')";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            try (Connection con = dbUtil.provideConnection();
                 PreparedStatement checkPs = con.prepareStatement(checkSql)) {

                checkPs.setString(1, email);

                try (ResultSet rs = checkPs.executeQuery()) {

                    if (rs.next()) {

                        String status = rs.getString("status");

                        if ("ACTIVE".equalsIgnoreCase(status)) {
                            response.getWriter().write(
                                    "{\"success\":false,\"message\":\"This email is already subscribed.\"}"
                            );
                            return;
                        }

                        String updateSql =
                                "UPDATE SUBSCRIPTIONS " +
                                "SET status = 'ACTIVE', subscribed_at = CURRENT_TIMESTAMP " +
                                "WHERE email = ?";

                        try (PreparedStatement updatePs =
                                     con.prepareStatement(updateSql)) {

                            updatePs.setString(1, email);
                            updatePs.executeUpdate();
                        }

                    } else {

                        try (PreparedStatement insertPs =
                                     con.prepareStatement(insertSql)) {

                            insertPs.setString(1, email);
                            insertPs.executeUpdate();
                        }
                    }
                }
            }

            /*
             * Send subscription confirmation email.
             * Email failure should not make the subscription fail.
             */
            try {
                MailMessage.subscriptionWelcome(email);
            } catch (Exception mailException) {
                mailException.printStackTrace();
            }

            response.getWriter().write(
                    "{\"success\":true,\"message\":\"You have successfully subscribed to MYSHOP.\"}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Unable to subscribe right now. Please try again.\"}"
            );
        }
    }
}