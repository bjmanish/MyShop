package com.myshop.srv;

import com.myshop.beans.DemandBean;
import com.myshop.beans.ProductBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.DemandServiceImpl;
import com.myshop.service.impl.ProductServiceImpl;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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

        int pQty = 0;
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

        // ✅ Get cartId if not exists
        if (cartId == null) {
            cartId = cartService.getCartId(userId);
            session.setAttribute("cartId", cartId);
        }

        ProductServiceImpl productService = new ProductServiceImpl();
        ProductBean product = productService.getProductDetails(prodId);

        int availableQty = product.getProdQuantity();
        int existingQty = cartService.getProductCount(userId, prodId);

        int totalQty = existingQty + pQty;

        String status;

        // ✅ OUT OF STOCK
        if (availableQty == 0) {
            status = "Product is Out of Stock!";
        }

        // ✅ IF REQUEST EXCEEDS STOCK
        else if (totalQty > availableQty) {

            cartService.updateProductToCart(userId, cartId, prodId, availableQty);

            int demandQty = totalQty - availableQty;

            DemandBean demand = new DemandBean(userName, prodId, demandQty);
            DemandServiceImpl demandService = new DemandServiceImpl();
            demandService.addProduct(demand);

            status = "Only " + availableQty + " items available. Added maximum to cart.";
        }

        // ✅ NORMAL FLOW
        else {
            if (existingQty > 0) {
                status = cartService.updateProductToCart(userId, cartId, prodId, totalQty);
            } else {
                status = cartService.addProductToCart(userId, cartId, prodId, pQty);
            }
        }

        // ✅ FINAL REDIRECT (always)
        response.sendRedirect("user/userHome.jsp?message=" + status);
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