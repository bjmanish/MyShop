/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.srv;

import com.myshop.service.impl.CartServiceImpl;
import com.myshop.utility.dbUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RemoveCartSrv", urlPatterns = {"/RemoveCartSrv"})
public class RemoveCartSrv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");

        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("user_id");

        if (userId == null) {
            out.write("{\"status\":\"error\",\"message\":\"Login required\"}");
            return;
        }

        String productId = request.getParameter("pid");
        String cartId = request.getParameter("cartId");
//        try (Connection con = dbUtil.provideConnection()) {
//
//            // ✅ Remove item from cart
//            PreparedStatement ps = con.prepareStatement("DELETE FROM CART_ITEMS WHERE cart_id=? AND product_id=?");
//
//            ps.setString(1, userId);
//            ps.setString(2, cartId);
//
////            int rows = 
//
//            if (ps.executeUpdate() > 0) {
//                PreparedStatement ps1 = con.prepareStatement("DELETE FROM CART WHERE user_id=? AND product_id=?");
//                ps1.setString(1, userId);
//                ps1.setString(2, productId);
//                
//                if(ps1.executeUpdate() > 0)               
//                    out.write("{\"status\":\"success\",\"message\":\"Item removed\"}");
//            } else {
//                out.write("{\"status\":\"error\",\"message\":\"Item not found\"}");
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            out.write("{\"status\":\"error\",\"message\":\"Server error\"}");
//        }
           CartServiceImpl cartService = new CartServiceImpl();
           
           String status = "FAILED";
           
           status = cartService.removeProductFromCart(userId, cartId, productId);
           
            if("SUCCESS".equalsIgnoreCase(status) ){
                session.setAttribute("cartCount", cartService.getCartCount(userId));
//               cartService.removeProduct(userId, productId);
               out.write("{\"status\":\"success\",\"message\":\"Item removed\"}");
            }else {
                out.write("{\"status\":\"error\",\"message\":\"Item not found\"}");
            }
           


    }
}
