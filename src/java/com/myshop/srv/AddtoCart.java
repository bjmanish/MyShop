package com.myshop.srv;

import com.myshop.beans.ProductBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.ProductServiceImpl;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "AddtoCart", urlPatterns = {"/AddtoCart"})
public class AddtoCart extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String userName = (String) session.getAttribute("username");
        String userType = (String) session.getAttribute("role");
        String cartId = (String) session.getAttribute("cartId");

        // ✅ Session validation
        if (userName == null || userType == null || !"customer".equalsIgnoreCase(userType)) {
            response.sendRedirect("login.jsp?message=Please login first!");
            return;
        }

        // ✅ Get parameters
        String userId = request.getParameter("uid");
        String prodId = request.getParameter("pid");

        int pQty;
        try {
            pQty = Integer.parseInt(request.getParameter("pqty"));
        } catch (Exception e) {
            response.sendRedirect("user/userHome.jsp?message=Invalid Quantity!");
            return;
        }

        if (pQty <= 0) {
            response.sendRedirect("user/userHome.jsp?message=Quantity must be greater than 0!");
            return;
        }

        CartServiceImpl cartService = new CartServiceImpl();

        try {

            // ✅ STEP 1: Get/Create Cart
            if (cartId == null || cartId.isEmpty()) {
                cartId = cartService.getOrCreateCart(userId);
                session.setAttribute("cartId", cartId);
            }

            // ✅ STEP 2: Get product details
            ProductServiceImpl productService = new ProductServiceImpl();
            ProductBean product = productService.getProductDetails(prodId);

            int availableQty = product.getProdQuantity();

            if (availableQty == 0) {
                response.sendRedirect("user/userHome.jsp?message=Product is Out of Stock!");
                return;
            }

            // ✅ STEP 3: Add product directly (service handles everything now)
            String status = cartService.addProductToCart(userId, cartId, prodId, pQty);

            // ✅ Redirect
            response.sendRedirect("user/userHome.jsp?message=" + status);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/userHome.jsp?message=Something went wrong!");
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
}