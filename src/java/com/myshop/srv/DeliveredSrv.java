package com.myshop.srv;

import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.beans.AssignOrder;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "DeliveredSrv", urlPatterns = {"/DeliveredSrv"})
public class DeliveredSrv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String staffEmail = (String) session.getAttribute("username");
        if (staffEmail == null) {
            response.sendRedirect("login.jsp?message=Session expired! Please login again.");
            return;
        }
        int assignId = Integer.parseInt(request.getParameter("aId"));
        String orderId = request.getParameter("orderid");
        String staffId = request.getParameter("staffid");
        String enteredOtp = request.getParameter("otp");
        
         System.out.println("Assign ID:"+assignId);
        if (orderId == null || staffId == null || enteredOtp == null) {
            response.sendRedirect("assignedDeliveries.jsp?message=" +
                    URLEncoder.encode("Invalid request parameters!", "UTF-8"));
            return;
        }

        // ✅ Get original OTP from DB
        String dbOtp = new OrderServiceImpl().getOtpByAssignId(assignId);
        System.out.println("DB OTP : "+ dbOtp);
        System.out.println("user OTP : "+ enteredOtp);
        
        if (enteredOtp.equals(dbOtp)) {
            // ✅ Update delivery status in AssignOrder
            String updateStatus = new OrderServiceImpl().markOrderAsDelivered(assignId, staffId);

            if ("SUCCESS".equalsIgnoreCase(updateStatus)) {
                new OrderServiceImpl().updateOrderStatus(orderId, "DELIVERED");
                response.sendRedirect("assignedDeliveries.jsp?message=" +URLEncoder.encode("OTP verified! Order marked as Delivered successfully!", "UTF-8"));
            } else {
                response.sendRedirect("assignedDeliveries.jsp?message=" +
                        URLEncoder.encode("Failed to update order delivery status.", "UTF-8"));
            }
        } else {
            // ❌ Wrong OTP
            response.sendRedirect("assignedDeliveries.jsp?message=" +
                    URLEncoder.encode("Invalid OTP! Please check and try again.", "UTF-8"));
        }
    }
}
