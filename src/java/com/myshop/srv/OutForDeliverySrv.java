package com.myshop.srv;

import com.myshop.beans.AssignOrder;
import com.myshop.beans.StaffBean;
import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.StaffServiceImpl;
import com.myshop.utility.idUtil;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "OutForDeliverySrv", urlPatterns = {"/OutForDeliverySrv"})
public class OutForDeliverySrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("user_id");
        String password = (String) session.getAttribute("sessionId");

        // ✅ Session validation
        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        String userId = request.getParameter("userid");
        String prodId = request.getParameter("prodid");
        String orderId = request.getParameter("orderid");

        // ✅ Always set status from backend (not from request)
        String status = "OUT_FOR_DELIVERY";

        // ✅ Generate 6-digit OTP
        Random rand = new Random();
        String otp = String.format("%06d", rand.nextInt(1000000));
        LocalDateTime otpTime = LocalDateTime.now();

        // ✅ Assign random staff
        StaffServiceImpl staffService = new StaffServiceImpl();
        List<StaffBean> staffList = staffService.getAllStaffs();

        String staffId = null;

        if (staffList != null && !staffList.isEmpty()) {
            StaffBean assignedStaff = staffList.get(rand.nextInt(staffList.size()));
            staffId = assignedStaff.getStaffId();
        } else {
            // fallback (important)
            staffId = "STF-101";
        }
        String asignId = idUtil.generateAssignId();
        // ✅ Create AssignOrder object
        AssignOrder assignOrder = new AssignOrder(asignId, orderId, staffId);

        // ✅ Update order + assign
        OrderServiceImpl orderService = new OrderServiceImpl();
        boolean success = orderService.outForDelivery(userId, orderId, prodId, assignOrder);

        // ✅ Redirect response
        if (success) {
            response.sendRedirect("admin/shippedItems.jsp?message=" +
                    URLEncoder.encode("Order is Out for Delivery 🚚 | OTP: " + otp, "UTF-8"));
        } else {
            response.sendRedirect("admin/shippedItems.jsp?message=" +
                    URLEncoder.encode("Failed to move order to Out for Delivery!", "UTF-8"));
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
        return "Moves shipped order to Out For Delivery, assigns staff, and generates OTP.";
    }
}