package com.myshop.srv;

import com.myshop.beans.OrderBean;
import com.myshop.service.PaymentDAO;
import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.ProductServiceImpl;
import com.myshop.service.impl.TransactionServiceImpl;
import com.myshop.utility.dbUtil;
import com.myshop.utility.idUtil;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    private static final String MERCHANT_KEY = "BKsQan";
    private static final String SALT = "FcZc8BBAYCDO2TPpHO40MXwaetl2Hfcy";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        String urlContext = "http://localhost:2025/MyShop";
        
        SimpleDateFormat sdf = new SimpleDateFormat("YYYY:MM:DD hh:mm:ss");
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        sdf.format(timestamp);

        try {
            // =============================
            // 1. GET DATA FROM REQUEST
            // =============================
            String userId = (String) session.getAttribute("user_id");
            String pid = request.getParameter("pid");
            System.out.println("product id "+pid);
            
            
//            String firstname = request.getParameter("name");
            String email = (String) session.getAttribute("username");
            String firstname = (String) session.getAttribute("username");
            String cartId = request.getParameter("cartId");

            double amountDouble = Double.parseDouble(request.getParameter("amount"));
            String amount = String.format("%.2f", amountDouble);

            String orderId = idUtil.generateUUIDOrderId();
            String txnid = "TXN" + System.currentTimeMillis();

            String product = new ProductServiceImpl().getProdInfo(pid);

            String surl = urlContext+"/PaymentSuccessServlet";
            String furl = urlContext+"/PaymentFailureServlet";

            System.out.println("User: " + userId +"| Product: " + product + " | Amount: " + amount);

            // =============================
            // 2. VALIDATION
            // =============================
            if (userId == null || userId.isEmpty() ||
                product == null || product.isEmpty()) {

                System.out.println("Invalid data, redirecting back to cart");

                request.getRequestDispatcher(
                        "user/cart.jsp?cartId=" + cartId + "&uid=" + userId
                ).forward(request, response);

                return; // 🔥 STOP execution
            }

            // =============================
            // 3. GENERATE HASH
            // =============================
            String hashString = MERCHANT_KEY + "|" + txnid + "|" + amount + "|" +
                    product + "|" + firstname + "|" + email +
                    "|||||||||||" + SALT;

            System.out.println("HASH STRING = [" + hashString + "]");

            String hash = generateHash(hashString);

            System.out.println("Generated Hash: " + hash);
            
            OrderBean order = new OrderBean();
            order.setUserId(userId);
            order.setProdId(pid);
            order.setTransId(txnid);
            order.setShipped(0);
            order.setStatus("PENDING");
//            order.setQuantity(0);
            order.setAmount(amountDouble);
            order.setOrderDate(timestamp);
            

            // =============================
            // 4. SAVE PAYMENT (PENDING)
            // =============================
            PaymentDAO.savePayment(orderId, userId, txnid, amountDouble, "PENDING", hash);            
//            new OrderServiceImpl().addOrder(order);
            new OrderServiceImpl().paymentSuccess(cartId, orderId, userId, cartId, amountDouble);
            new TransactionServiceImpl().addTransaction(txnid, orderId, userId, amountDouble, "PENDING", timestamp);
            System.out.println("Payment saved in DB");

            // =============================
            // 5. SEND DATA TO JSP (PayU Redirect)
            // =============================
            request.setAttribute("hash", hash);
            request.setAttribute("txnid", txnid);
            request.setAttribute("key", MERCHANT_KEY);
            request.setAttribute("amount", amount);
            request.setAttribute("productinfo", product);
            request.setAttribute("phone", "6206848898");
            request.setAttribute("firstname", firstname);
            request.setAttribute("email", email);
            request.setAttribute("surl", surl);
            request.setAttribute("furl", furl);

            System.out.println("Forwarding to payuRedirect.jsp");

            // ✅ ONLY FORWARD (NO REDIRECT)
            RequestDispatcher rd = request.getRequestDispatcher("user/payuRedirect.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // =============================
            // ERROR HANDLING
            // =============================
            request.setAttribute("error", "Payment initialization failed");

            request.getRequestDispatcher(request.getContextPath()+"/user/cart.jsp").forward(request, response);
        }
    }

    // =============================
    // HASH GENERATION METHOD
    // =============================
    private String generateHash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] bytes = md.digest(input.getBytes("UTF-8"));

            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b)); // ✅ FIXED (2-digit hex)
            }

            return sb.toString();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}