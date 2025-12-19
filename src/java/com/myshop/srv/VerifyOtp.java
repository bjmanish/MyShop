package com.myshop.srv;

import com.myshop.service.impl.UserServiceImpl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VerifyOtp extends HttpServlet {

    private static final long serialVersionUID = 1L;


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int enteredOtp = Integer.parseInt(request.getParameter("otp"));
        int sessionOtp = (int) request.getSession().getAttribute("otp");
        String mobile = (String) request.getSession().getAttribute("mobile");
        String email = (String) request.getSession().getAttribute("email");

        if(enteredOtp == sessionOtp){
            // Update mobile_verified = 1
            UserServiceImpl dao = new UserServiceImpl();
            dao.verifyMobile(mobile, email);

            request.getSession().removeAttribute("otp");
            request.getSession().removeAttribute("mobile");

            response.sendRedirect("login.jsp?msg=Mobile Verified! Registration Complete");
        } else {
            response.sendRedirect("verifyOtp.jsp?msg=Invalid OTP, try again");
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
