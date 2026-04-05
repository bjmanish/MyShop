package com.myshop.srv;

import com.myshop.service.impl.ProductServiceImpl;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ShowImage", urlPatterns = {"/ShowImage"})
public class ShowImage extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public ShowImage() {
        super();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        byte [] image = null;
        try {
            String prodId = request.getParameter("pid");
//            System.out.println("PID: " + prodId);

            ProductServiceImpl dao = new ProductServiceImpl();
            image = dao.getProductImage(prodId);

            // ✅ If DB image not found → load fallback
            if (image == null || image.length == 0) {

                String path = request.getServletContext().getRealPath("/images/noimage.jpg");
                File file = new File(path);

//                System.out.println("Fallback path: " + path);

                BufferedImage img = ImageIO.read(file);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                ImageIO.write(img, "jpg", baos);

                image = baos.toByteArray();
            }

//            System.out.println("Final Image Size: " + image.length);

            // ✅ MUST
            response.setContentType("image/jpeg");
            response.setContentLength(image.length);

            try (ServletOutputStream out = response.getOutputStream()) {
                out.write(image);
                out.flush();
            }

        } catch (Exception e) {
            e.printStackTrace();

            // VERY IMPORTANT DEBUG RESPONSE
            response.setContentType("text/plain");
            response.getWriter().print("ERROR: " + e.getMessage());
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
