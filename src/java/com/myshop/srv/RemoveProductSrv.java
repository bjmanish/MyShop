package com.myshop.srv;

import com.myshop.service.impl.ProductServiceImpl;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RemoveProductSrv", urlPatterns = {"/RemoveProductSrv"})
public class RemoveProductSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public RemoveProductSrv() {
        super();
    }
    
    

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session  = request.getSession();
        
        String username = (String)session.getAttribute("username");
        String password = (String)session.getAttribute("password");
        String usertype = (String)session.getAttribute("usertype");
            
        if(usertype == null || !usertype.equals("admin")){
            response.sendRedirect("login.jsp?message=Access Denied! Please Login as Admin.");
        }else if(username == null || password == null){
            response.sendRedirect("login.jsp?message=Session Expired!. Please Login Again.");
        }
        
        String prodId = request.getParameter("prodid");
        //System.out.println("prodID: "+prodId);
        //ProductServiceImpl product = new ProductServiceImpl();
        
        String status = new ProductServiceImpl().removeProduct(prodId);
        
        RequestDispatcher rd = request.getRequestDispatcher("removeProduct.jsp?message="+status);
        rd.forward(request, response);
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
