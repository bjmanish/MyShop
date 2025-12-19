package com.myshop.srv;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

public class SendOTPSrv extends HttpServlet {

    // Twilio credentials (from your Twilio console)
    public static final String ACCOUNT_SID = "ACafbe576707e8483501ca3c13fd24f63e";
    public static final String AUTH_TOKEN = "d49ecf4f3386c292a62bb4b2f4ce0ee5";

    // Twilio WhatsApp sandbox number
    public static final String FROM_WHATSAPP = "whatsapp:+14155238886";

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String mobile = (String) session.getAttribute("mobile");
        String email  = (String) session.getAttribute("email");
        // If mobile is not found in session, handle error
        if (mobile == null || mobile.isEmpty()) {
            response.getWriter().println("<script>alert('Mobile number not found in session!'); history.back();</script>");
            return;
        }

        // Generate random 6-digit OTP
        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        try {
            // Initialize Twilio
            Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

            // Send WhatsApp message via Twilio API
            Message message = Message.creator(
                    new PhoneNumber("whatsapp:+91" + mobile), // To user's WhatsApp
                    new PhoneNumber(FROM_WHATSAPP),           // From your Twilio sandbox WhatsApp
                    "Your MyShop OTP is: " + otp + "\nDo not share this code with anyone."
            ).create();

            // Store OTP in session for later verification
//            System.out.println("from servlet otp:"+otp+" email:"+email);
            session.setAttribute("otp", otp);
            session.setAttribute("email", email);
            // Notify user
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('OTP sent successfully via WhatsApp!'); window.location='verifyMobile.jsp';</script>");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Error sending OTP: " + e.getMessage() + "'); history.back();</script>");
        }
    }
}
