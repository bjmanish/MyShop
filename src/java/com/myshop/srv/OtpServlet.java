package com.myshop.srv;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Base64;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.annotation.WebServlet;

@WebServlet(name = "OtpServlet", urlPatterns = {"/OtpServlet"})
public class OtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    // In-memory storage for OTPs (use database in production)
    private Map<String, OtpData> otpStorage = new HashMap<>();
    
    // Twilio credentials
    private static final String ACCOUNT_SID = "USfeee95dedcfaefb43effffeeed5ee574";
    private static final String AUTH_TOKEN = "ATXZ41J81ZS46WYRQUC761SH";
    private static final String TWILIO_PHONE = "+919128801544"; // Your Twilio phone number
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String phoneNumber = request.getParameter("phone");
        String countryCode = request.getParameter("countryCode");
        String fullNumber = countryCode + phoneNumber;
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            if ("send".equals(action)) {
                // Generate random 6-digit OTP
                String otp = generateOTP();
                
                // Store OTP with phone number and timestamp
                otpStorage.put(fullNumber, new OtpData(otp, System.currentTimeMillis()));
                
                // Send SMS using Twilio API
                boolean smsSent = sendTwilioSMS(fullNumber, otp);
                
                if (smsSent) {
                    out.print("{\"status\": \"success\", \"message\": \"OTP sent successfully\"}");
                } else {
                    out.print("{\"status\": \"error\", \"message\": \"Failed to send OTP. Please try again.\"}");
                }
                
            } else if ("verify".equals(action)) {
                String enteredOtp = request.getParameter("otp");
                OtpData otpData = otpStorage.get(fullNumber);
                
                if (otpData != null && otpData.isValid() && otpData.getOtp().equals(enteredOtp)) {
                    // OTP is correct and not expired
                    otpStorage.remove(fullNumber); // Remove used OTP
                    out.print("{\"status\": \"success\", \"message\": \"Phone number verified\"}");
                } else {
                    // OTP is incorrect or expired
                    out.print("{\"status\": \"error\", \"message\": \"Invalid or expired OTP\"}");
                }
            }
        } catch (Exception e) {
            out.print("{\"status\": \"error\", \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private boolean sendTwilioSMS(String phoneNumber, String otp) {
        try {
            String message = "Your verification code is: " + otp + ". Valid for 10 minutes.";
            
            String url = "https://api.twilio.com/2010-04-01/Accounts/" + ACCOUNT_SID + "/Messages.json";
            
            String params = "To=" + URLEncoder.encode(phoneNumber, "UTF-8") +
                           "&From=" + URLEncoder.encode(TWILIO_PHONE, "UTF-8") +
                           "&Body=" + URLEncoder.encode(message, "UTF-8");
            
            // Create authentication
            String auth = ACCOUNT_SID + ":" + AUTH_TOKEN;
            String encoding = Base64.getEncoder().encodeToString(auth.getBytes());
            
            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);
            connection.setRequestProperty("Authorization", "Basic " + encoding);
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = params.getBytes("UTF-8");
                os.write(input, 0, input.length);
            }
            
            int responseCode = connection.getResponseCode();
            return responseCode == 201; // Created
            
        } catch (Exception e) {
            System.err.println("Twilio SMS failed: " + e.getMessage());
            return false;
        }
    }
    
    // Inner class to store OTP data with expiration
    private class OtpData {
        private String otp;
        private long timestamp;
        
        public OtpData(String otp, long timestamp) {
            this.otp = otp;
            this.timestamp = timestamp;
        }
        
        public String getOtp() {
            return otp;
        }
        
        public boolean isValid() {
            // OTP valid for 10 minutes
            return (System.currentTimeMillis() - timestamp) < 10 * 60 * 1000;
        }
    }
}