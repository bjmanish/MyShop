package com.myshop.srv;

import com.myshop.service.PaymentDAO;
import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.TransactionServiceImpl;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PaymentFailureServlet")
public class PaymentFailureServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String txnId = request.getParameter("txnid");
        String status = request.getParameter("status");

        // Default values
        if (txnId == null || txnId.trim().isEmpty()) {
            txnId = "N/A";
        }

        if (status == null || status.trim().isEmpty()) {
            status = "FAILED";
        }

        /*
         * IMPORTANT:
         * Do NOT invalidate the user's login session here.
         *
         * Payment failure should only update payment/order information.
         */

        try {

            // Update payment status
            PaymentDAO.updatePayment(
                    txnId,
                    "FAILED",
                    "NA"
            );
            
            new TransactionServiceImpl().updatePayment(
                    txnId,
                    "FAILED",
                    "NA"
            );
            
            // Update order status
            new OrderServiceImpl().updateOrderStatus(
                    txnId,
                    "FAILED"
            );

        } catch (Exception e) {

            e.printStackTrace();

            // Don't destroy the login session if database update fails
        }

        /*
         * Preserve the existing login session.
         */
        HttpSession session = request.getSession(true);

        if (session != null) {

            session.setAttribute(
                    "paymentStatus",
                    "FAILED"
            );

            session.setAttribute(
                    "paymentMessage",
                    "Payment Failed ❌"
            );

            session.setAttribute(
                    "failedTxnId",
                    txnId
            );
            
            session.setAttribute("user", request.getSession());
        }

        /*
         * Send transaction information to JSP.
         */
        request.setAttribute("txnId", txnId);
        request.setAttribute("paymentStatus", "FAILED");

        request.getRequestDispatcher(
                "/user/paymentfailed.jsp"
        ).forward(request, response);
    }
}