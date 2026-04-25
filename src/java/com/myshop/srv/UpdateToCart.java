package com.myshop.srv;

import com.myshop.beans.ProductBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.ProductServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UpdateToCart", urlPatterns = {"/UpdateToCart"})
public class UpdateToCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("user_id");
        String cartId = request.getParameter("cartId");
        try {

            // =============================
            // GET PARAMETERS
            // =============================
            String pid = request.getParameter("pid");
            int change = Integer.parseInt(request.getParameter("change"));

            CartServiceImpl cartService = new CartServiceImpl();
            ProductServiceImpl productService = new ProductServiceImpl();

            ProductBean product = productService.getProductDetails(pid);

            // =============================
            // GET CURRENT QTY FROM DB
            // =============================
            int currentQty = cartService.getCartItemCount(cartId, pid);
                
            if (currentQty == 0) {
                cartService.updateProductToCart(userId, cartId, pid, currentQty);
                out.print("{");
                out.print("\"status\":\"No Item in Cart\",");
                out.print("\"qty\":" + currentQty + ",");
                out.print("\"amount\":" + 0 + ",");
                out.print("\"total\":" +change);
                out.print("}");
                return ;
            }
            
            int newQty = currentQty + change;

            

            // =============================
            // STOCK CHECK
            // =============================
            if (newQty > product.getProdQuantity()) {
                newQty = product.getProdQuantity();
            }

            // =============================
            // UPDATE DB
            // =============================
            cartService.updateProductToCart(userId, cartId, pid, newQty);

            double itemTotal = newQty * product.getProdPrice();

            // =============================
            // CALCULATE CART TOTAL
            // =============================
            double cartTotal = cartService.getCartCount(userId);

            // =============================
            // RETURN JSON
            // =============================
            out.print("{");
            out.print("\"status\":\"success\",");
            out.print("\"qty\":" + newQty + ",");
            out.print("\"amount\":" + itemTotal + ",");
            out.print("\"total\":" + cartTotal);
            out.print("}");

        } catch (Exception e) {

            e.printStackTrace();

            out.print("{\"status\":\"error\"}");
        }
    }
}