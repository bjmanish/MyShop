package com.myshop.srv;

import com.myshop.beans.ProductBean;
import com.myshop.service.impl.ProductServiceImpl;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "AddProductSrv", urlPatterns = {"/AddProductSrv"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class AddProductSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Validate admin session
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied!");
            return;
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again to Continue!");
            return;
        }

        // Initialize response message
        String status;

        try {
            // Retrieve form data
            String prodName = request.getParameter("productName");
            String prodType = request.getParameter("productCategory");
            String prodInfo = request.getParameter("productDescription");
            double prodPrice = Double.parseDouble(request.getParameter("productPrice"));
            int prodQuantity = Integer.parseInt(request.getParameter("productQuantity"));
            Part part = request.getPart("productImage");
            //InputStream prodImage  = request.getInputStream("productImage");
            //System.out.println("Data: "+prodName+"/"+prodType+"/"+prodInfo+"/"+prodPrice+"/"+prodQuantity+"/"+part);
            
            // Validate product image
            InputStream prodImage = null;
            if (part != null && part.getSize() > 0) {
                prodImage = part.getInputStream();
            } else {
                status = "Please provide a valid product image.";
                response.sendRedirect("addProduct.jsp?message="+status);
                return;
            }
           // BufferedImage bufferedImage = ImageIO.read(prodImage);

            // Create ProductBean object
            ProductBean product = new ProductBean();
            product.setProdName(prodName);
            product.setProdType(prodType);
            product.setProdInfo(prodInfo);
            product.setProdPrice(prodPrice);
            product.setProdQuantity(prodQuantity);
            product.setProdImage(prodImage);

            // Call service layer to add the product
            ProductServiceImpl productService = new ProductServiceImpl();
            status = productService.addProduct(product);

        } catch (IOException | NumberFormatException | ServletException e) {
            status = "Error occurred while adding the product: " + e.getMessage();
        }

        // Forward to the addProduct page with status message
        response.sendRedirect("addProduct.jsp?message="+status);
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
