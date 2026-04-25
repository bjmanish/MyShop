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

@WebServlet("/PaymentFailureServlet")
public class PaymentFailureServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String txnId = request.getParameter("txnid");

        PaymentDAO.updatePayment(txnId, "FAILED", "NA");
        new OrderServiceImpl().updateOrderStatus(txnId, "FAILER");

        request.setAttribute("msg", "Payment Failed ❌");
        request.getRequestDispatcher("user/failure.jsp").forward(request, response);
    }
}