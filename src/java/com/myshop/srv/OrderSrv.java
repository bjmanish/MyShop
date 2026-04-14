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

        HttpSession session = request.getSession();

        String userId = (String) session.getAttribute("user_id");

        if (userId == null) {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Session expired\"}");
            return;
        }

        try(Connection con = dbUtil.provideConnection();) {

            // ✅ Get Data
            String cartId = request.getParameter("cartId");
            double amount = Double.parseDouble(request.getParameter("amount"));
            
            String orderId = idUtil.generateUUIDOrderId();
            String paymentId = idUtil.generateTransactionId();
            String userId1 = (String)request.getAttribute("user_id");          
            
            TransactionBean trans = new TransactionBean();
            
            trans.setTransId(paymentId);
            trans.setUserName(userId);
            trans.setOrderId(orderId);
            trans.setTransAmount(amount);
            SimpleDateFormat sdf = new SimpleDateFormat("YYYY:MM:DD hh:mm:ss");
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            sdf.format(timestamp);
            trans.setTransDateTime(timestamp);          
            
            // ✅ Generate Order ID
//            String orderId = idUtil.generateTransactionId();
            boolean addTrans = new TransactionServiceImpl().addTransaction(trans);
                
            if(addTrans == true){
                String paymentStatus = new OrderServiceImpl().paymentSuccess(paymentId, userId, cartId, amount);
            }
            
            // ✅ RESPONSE JSON (IMPORTANT)
            response.setContentType("application/json");

            PrintWriter out = response.getWriter();
            out.write("{\"status\":\"success\",\"orderId\":\"" + orderId + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\"}");
        }
    }
}