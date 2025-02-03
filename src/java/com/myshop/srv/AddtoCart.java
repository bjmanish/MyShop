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

    private static final long serialVersionUID = 1L;

    public AddtoCart() {
        super();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession  session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String userType = (String) session.getAttribute("usertype");
        //System.out.println("data:" +userName+""+ password+"" +userType);
        if(userName == null || password == null || userType == null || !userType.equalsIgnoreCase("customer")){
            response.sendRedirect("login.jsp?message=Session Expired!! Please Login And Continue to Purchase.");
            return;
        }
        
        String status = null;
        
        String userId = request.getParameter("uid");
        String prodId = request.getParameter("pid");
        int pQty = Integer.parseInt(request.getParameter("pqty"));
       // System.out.println("data:" +userId+""+ prodId+"" +pQty);
        if(userId == null || prodId == null || pQty < 0){
            response.sendRedirect("login.jsp?message=Please Login and then continue to shopping.");
            return;
        }
        CartServiceImpl cart = new CartServiceImpl();
        ProductServiceImpl productDao = new ProductServiceImpl();
        ProductBean product = productDao.getProductDetails(prodId);
        int availableQty = product.getProdQuantity();
        int cartQty = cart.getProductCount(userId, prodId);
        
        pQty += cartQty;
                
        if(pQty == cartQty){
            status = cart.removeProductFromCart(userId, prodId);
            response.sendRedirect("userHome.jsp?message="+status);
            
        }else if(availableQty < pQty){
            
            if(availableQty == 0){
                status = "Product is out of Stock!";
            }else{
                cart.updateProductToCart(userId, prodId, pQty);
                
                status = "Only "+ availableQty +" no of "+ product.getProdName()
                        + " are available in the shop! So we are adding only "+ availableQty
                        + " products into your cart "+ "";
            }
            
            DemandBean demandBean = new DemandBean(userName, product.getProdId(), pQty - availableQty);
            DemandServiceImpl demands = new DemandServiceImpl();
            boolean flag = demands.addProduct(demandBean);
            
            if(flag){
                status += "<br/>Later, We will Mail you when "+ product.getProdName()
                        + " will be available into the Stores!";
            }
                        
        }else{            
            status = cart.updateProductToCart(userId, prodId, pQty);
            response.sendRedirect("userHome.jsp?message="+status);
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
