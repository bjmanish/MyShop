package com.myshop.srv;

import com.myshop.beans.AssignOrder;
import com.myshop.beans.OrderDetails;
import com.myshop.beans.StaffBean;
import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.StaffServiceImpl;
import com.myshop.utility.DeliveryDate;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "OutForDeliverySrv", urlPatterns = {"/OutForDeliverySrv"})
public class OutForDeliverySrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public OutForDeliverySrv() {
        super();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        // Session validation
        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        String userId = request.getParameter("userid");
        String prodId = request.getParameter("prodid");
        String orderId = request.getParameter("orderid");
        String status = request.getParameter("status");
        // Step 1: Update order status to "OUT_FOR_DELIVERY"
//        String status = new OrderServiceImpl().outForDelivery(userId, orderId, prodId);

        // Step 2: Generate OTP for customer verification
        String otp = String.format("%06d", new Random().nextInt(999999));
        LocalDateTime otpTime = LocalDateTime.now();

        // Step 3: Assign a random staff member
        StaffServiceImpl staffService = new StaffServiceImpl();
        List<StaffBean> staffList = staffService.getAllStaffs();
        String staffId = "";
        if (!staffList.isEmpty()) {
            StaffBean assignedStaff = staffList.get(new Random().nextInt(staffList.size()));
            staffId = assignedStaff.getStaffId();
        }
        
        Timestamp deliveryDate = new OrderServiceImpl().getDeliveryDateByOrderId(orderId);
        
        AssignOrder assignOrd = new AssignOrder(orderId, staffId, deliveryDate, status, otp, otpTime);
        boolean success = new OrderServiceImpl().assignOrder(assignOrd);

        // Step 6: Redirect with message
        if (success || "SUCCESS".equalsIgnoreCase(status)) {
            response.sendRedirect("shippedItems.jsp?message=" + 
                URLEncoder.encode("Order moved to 'Out For Delivery'. OTP: " + otp, "UTF-8"));
        } else {
            response.sendRedirect("shippedItems.jsp?message=" + 
                URLEncoder.encode("Failed to update order status.", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Moves shipped order to 'Out For Delivery' stage, assigns staff, and generates OTP.";
    }
}
