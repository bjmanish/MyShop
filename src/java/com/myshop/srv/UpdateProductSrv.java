package com.myshop.srv;

import com.myshop.beans.ProductBean;
import com.myshop.service.impl.ProductServiceImpl;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UpdateProductSrv", urlPatterns = {"/UpdateProductSrv"})
public class UpdateProductSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // ✅ SESSION VALIDATION
        String userType = (String) session.getAttribute("role");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("sessionId");

        if (userType == null || !userType.equalsIgnoreCase("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied!");
            return;
        }

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired!");
            return;
        }

        // ✅ GET PARAMETERS
        String prodId = request.getParameter("pid");
        String prodName = request.getParameter("name");
        String prodType = request.getParameter("type");
        String prodInfo = request.getParameter("info");

        double prodPrice = 0;
        int prodQuantity = 0;

        try {
            prodPrice = Double.parseDouble(request.getParameter("price"));
            prodQuantity = Integer.parseInt(request.getParameter("quantity"));
        } catch (Exception e) {
            response.sendRedirect("updateProduct.jsp?pid=" + prodId + "&message=Invalid Input");
            return;
        }

        // ✅ VALIDATION
        if (prodId == null || prodId.trim().isEmpty()) {
            response.sendRedirect("adminViewProduct.jsp?message=Invalid Product ID");
            return;
        }

        // ✅ SET DATA
        ProductBean product = new ProductBean();
        product.setProdId(prodId);
        product.setProdName(prodName);
        product.setProdType(prodType);
        product.setProdInfo(prodInfo);
        product.setProdPrice(prodPrice);
        product.setProdQuantity(prodQuantity);

        // ✅ UPDATE (WITHOUT IMAGE)
        ProductServiceImpl dao = new ProductServiceImpl();
        String status = dao.updateProductWithoutImage(prodId, product);

        // 🔥 FIXED REDIRECT (IMPORTANT)
        response.sendRedirect("admin/updateProduct.jsp?pid=" + prodId + "&message=" + status);
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