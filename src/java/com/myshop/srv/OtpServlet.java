package com.myshop.srv;

import com.myshop.service.impl.OrderServiceImpl;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.annotation.WebServlet;

@WebServlet(name = "OtpServlet", urlPatterns = {"/OtpServlet"})
public class OtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Thread-safe OTP storage
    private Map<String, OtpData> otpStorage = new ConcurrentHashMap<>();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String phone = request.getParameter("phone");
        String countryCode = request.getParameter("countryCode");
        
//        String paymentId = request.getParameter("payment_id");
//        String user_id = request.getParameter

        // For testing (if phone not sent)
        if (phone == null || phone.isEmpty()) {
            phone = "9999999999";
        }
        if (countryCode == null || countryCode.isEmpty()) {
            countryCode = "+91";
        }

        String fullNumber = countryCode + phone;

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {

            // ================= SEND OTP =================
            if ("send".equals(action)) {

                String otp = generateOTP();

                // Store OTP with timestamp
                otpStorage.put(fullNumber, new OtpData(otp, System.currentTimeMillis()));

                // 🔥 TEST MODE (print OTP in console)
                System.out.println("=================================");
                System.out.println(" TEST OTP for " + fullNumber + " = " + otp);
                System.out.println("=================================");

                // Return success + OTP (for testing UI)
                out.print("{\"status\":\"success\",\"otp\":\"" + otp + "\"}");
            }

            // ================= VERIFY OTP =================
            else if ("verify".equals(action)) {

                String enteredOtp = request.getParameter("otp");

                OtpData data = otpStorage.get(fullNumber);

                if (data == null) {
                    out.print("{\"status\":\"error\",\"message\":\"OTP not found\"}");
                }
                else if (!data.isValid()) {
                    otpStorage.remove(fullNumber);
                    out.print("{\"status\":\"error\",\"message\":\"OTP expired\"}");
                }
                else if (data.getOtp().equals(enteredOtp)) {

                    // Success
                    otpStorage.remove(fullNumber);
                    
//                    new OrderServiceImpl().paymentSuccess(phone, serialVersionUID);

                    out.print("{\"status\":\"success\",\"message\":\"OTP verified\"}");
                }
                else {
                    out.print("{\"status\":\"error\",\"message\":\"Invalid OTP\"}");
                }
            }

            else {
                out.print("{\"status\":\"error\",\"message\":\"Invalid action\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\",\"message\":\"Server error\"}");
        }

        out.flush();
    }

    // ✅ Generate 4-digit OTP (for your UI)
    private String generateOTP() {
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000);
        return String.valueOf(otp);
    }

    // OTP Data class
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
            // ⏱ 30 seconds expiry
            return (System.currentTimeMillis() - timestamp) < 30000;
        }
    }
}