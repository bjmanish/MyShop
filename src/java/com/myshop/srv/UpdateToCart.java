package com.myshop.srv;

import com.myshop.beans.DemandBean;
import com.myshop.beans.ProductBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.DemandServiceImpl;
import com.myshop.service.impl.ProductServiceImpl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "UpdateToCart", urlPatterns = {"/UpdateToCart"})
public class UpdateToCart extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public UpdateToCart() {
        super();
    }

    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
	}
        
        // login Check Successfull
        String userId = userName;
        String prodId = request.getParameter("pid");
        int pQty = Integer.parseInt(request.getParameter("pqty"));
        CartServiceImpl cart = new CartServiceImpl();
        ProductServiceImpl productDao = new ProductServiceImpl();
        ProductBean product = productDao.getProductDetails(prodId);
        int availableQty = product.getProdQuantity();
        PrintWriter pw = response.getWriter();
        response.setContentType("text/html");
        String status ;
        if (availableQty < pQty) {
            //String status = cart.updateProductToCart(userId, prodId, availableQty);
            status = "Only " + availableQty + " no of " + product.getProdName()
                    + " are available in the shop! So we are adding only " + availableQty + " products into Your Cart"+ "";
            
            DemandBean demandBean = new DemandBean(userName, product.getProdId(), pQty - availableQty);
            DemandServiceImpl demand = new DemandServiceImpl();
            boolean flag = demand.addProduct(demandBean);
            if (flag)
                status += "<br/>Later, We Will Mail You when " + product.getProdName()+ " will be available into the Store!";
            response.sendRedirect("cartDetails.jsp?message="+status);
        } else {
            status = cart.updateProductToCart(userId, prodId, pQty);
            response.sendRedirect("cartDetails.jsp?message="+status);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
