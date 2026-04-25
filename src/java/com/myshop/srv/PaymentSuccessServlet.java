/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.srv;

import com.myshop.service.PaymentDAO;
import com.myshop.service.impl.OrderServiceImpl;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String txnId = request.getParameter("txnid");
        String paymentMode = request.getParameter("mode");

        // Update DB
        PaymentDAO.updatePayment(txnId, "SUCCESS", paymentMode);

        // Update Order
//        .updatePaymentStatus(txnId, "SUCCESS");
        new OrderServiceImpl().paymentSuccess(paymentMode, txnId, txnId, txnId, 0);

        request.setAttribute("msg", "Payment Successful ✅");
        request.getRequestDispatcher("user/success.jsp").forward(request, response);
    }
}