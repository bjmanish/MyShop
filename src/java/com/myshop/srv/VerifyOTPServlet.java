package com.myshop.srv;

import com.myshop.service.impl.UserServiceImpl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VerifyOTPServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession();

            // 🛡️ Check if session exists
            if (session == null) {
                out.println("<script>alert('Session expired! Please try again.'); window.location='verifyMobile.jsp';</script>");
                return;
            }

            // 🧩 Get session attributes
            String enteredOtp = request.getParameter("otp");
            String sessionOtp = (String) session.getAttribute("otp");
            String mobile = (String) session.getAttribute("mobile");
            String email = (String) session.getAttribute("email");
//            System.out.println("email:"+email+" mobile:"+mobile+" sessionOTP:"+sessionOtp+" userOTP:"+enteredOtp);
            // 🧠 Validate data
            if (enteredOtp == null || sessionOtp == null || mobile == null || email == null) {
                out.println("<script>alert('Missing data! Please restart the verification.'); window.location='verifyMobile.jsp';</script>");
                return;
            }

            // ✅ OTP matched
            if (enteredOtp.equals(sessionOtp)) {
                try {
                    UserServiceImpl userService = new UserServiceImpl();
                    userService.verifyMobile(mobile, email);

                    // Remove OTP from session (for security)
                    session.removeAttribute("otp");

                    response.sendRedirect("userProfile.jsp?message=Mobile Verified Successfully!");
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<script>alert('Error updating verification status. Please try again.'); window.location='verifyMobile.jsp';</script>");
                }
            } else {
                // ❌ Invalid OTP
                out.println("<script>alert('Invalid OTP! Try again.'); window.location='verifyMobile.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Something went wrong. Please try again later.'); window.location='verifyMobile.jsp';</script>");
        } finally {
            out.close();
        }
    }
}
