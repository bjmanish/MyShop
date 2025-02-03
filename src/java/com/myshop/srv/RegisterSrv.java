package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.utility.PasswordEncryption;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "RegisterSrv", urlPatterns = {"/RegisterSrv"})

@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Max File size 5MB
public class RegisterSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {        
        HttpSession session = request.getSession();
        String status = "";
        try{
            String userName = request.getParameter("username");
            String mobileNo = request.getParameter("mobile");
            String emailId = request.getParameter("email");
            String address = request.getParameter("address");
            int pinCode = Integer.parseInt(request.getParameter("pincode"));
            
            //System.out.println("user pincode: "+pinCode);

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            
            //Get the uploaded profile image
            Part filePart = request.getPart("profileImage");
            
            //validate the profile image
            InputStream prodImage = null;
            if(filePart !=null && filePart.getSize() > 0){
                prodImage = filePart.getInputStream();
            }else{
                status = "Please Provide a valid Profile Image.";
                response.sendRedirect("register.jsp?message="+status);
                return;
            }
            //System.out.println("user data:"+ prodImage);
            if(password != null && password.equals(confirmPassword)){
                
                password = PasswordEncryption.getEncryptedPassword(password);
               // System.out.println("password: "+password);
                
                // Create UserBean and call registerUser
                UserBean user = new UserBean();
                user.setName(userName);
                user.setEmail(emailId);
                user.setMobile(mobileNo);
                user.setAddress(address);
                user.setPincode(pinCode);
                user.setPassword(password);
                
               // System.out.println("user Data: "+user.toString());
                // Assuming registerUser accepts InputStream for image
                UserServiceImpl dao = new UserServiceImpl();
                status = dao.registerUser(user, prodImage);
                
               // System.out.println("status "+ status);
                
                session.setAttribute("userName", userName);
                session.setAttribute("Email", emailId);
                response.sendRedirect("login.jsp?message="+status);
                
            }else{
                status = "password not matching!";
                RequestDispatcher rd = request.getRequestDispatcher("register.jsp?message=" + status);
                rd.forward(request, response);
                return;
            }            
            
        }catch(IOException | ServletException e){
            e.getMessage();
            return;
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
