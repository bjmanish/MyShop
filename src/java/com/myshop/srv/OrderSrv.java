package com.myshop.srv;

import com.myshop.beans.TransactionBean;
import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.TransactionServiceImpl;
import com.myshop.utility.dbUtil;
import com.myshop.utility.idUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "OrderSrv", urlPatterns = {"/OrderSrv"})
public class OrderSrv extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("application/json");
    PrintWriter out = response.getWriter();

    HttpSession session = request.getSession();
    String userId = (String) session.getAttribute("user_id");

    if (userId == null) {
        out.write("{\"status\":\"error\",\"message\":\"Session expired\"}");
        return;
    }

    Connection con = null;

    try {
        con = dbUtil.provideConnection();
        con.setAutoCommit(false); // 🔥 TRANSACTION START

        // ✅ Get Data
        String cartId = request.getParameter("cartId");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentId = request.getParameter("paymentId");
        String orderId = request.getParameter("orderId");
        
        // ================= STEP 1: CREATE ORDER =================
        OrderServiceImpl orderService = new OrderServiceImpl();

        String orderStatus = orderService.paymentSuccess(
                paymentId, orderId, userId, cartId, amount
        );

        if (orderStatus == null) {
            throw new Exception("Order creation failed");
        }

        // ================= STEP 2: INSERT PAYMENT =================
        TransactionBean trans = new TransactionBean();

        trans.setTransId(paymentId);
        trans.setUserName(userId);
        trans.setOrderId(orderId);
        trans.setTransAmount(amount);
        trans.setTransDateTime(new Timestamp(System.currentTimeMillis()));

        boolean addTrans = new TransactionServiceImpl().addTransaction(trans, con);

        if (addTrans == true) {
            String status = "PLACED";
            orderService.updateOrderStatus(orderId, status);
        }else{
            throw new Exception("Transaction failed");
        }
        // ================= COMMIT =================
        con.commit();

        out.write("{\"status\":\"success\",\"orderId\":\"" + orderId + "\"}");

    } catch (Exception e) {
        e.printStackTrace();

        try {
            if (con != null) con.rollback(); // ❌ rollback on error
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        out.write("{\"status\":\"error\",\"message\":\"Something went wrong\"}");

    } finally {
        try {
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
}