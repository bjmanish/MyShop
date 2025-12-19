package com.myshop.srv;

import com.myshop.beans.StaffBean;
import com.myshop.service.impl.StaffServiceImpl;
import com.myshop.utility.PasswordEncryption;
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


@WebServlet(name = "AddStaffSrv", urlPatterns = {"/AddStaffSrv"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Max File size 5MB
public class AddStaffSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public AddStaffSrv() {
        super();
    }

    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session  = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String userType = (String) session.getAttribute("usertype");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?error=access_denied");
            return;
        }
        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }
        
        System.out.println("session: "+session.toString());
        
        String status = "";
        
        try{
            String staffName = request.getParameter("username");
            String mobileNo = request.getParameter("mobile");
            String emailId = request.getParameter("email");
            
            String passwd = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            System.out.println("staffName:"+staffName+" emailId:"+emailId+" password:"+passwd+" confirmPassword:"+confirmPassword);
            //Get the uploaded profile image
            Part file = request.getPart("profileImage");
            System.out.println("images :"+file);
            //validate the profile image
            InputStream staffImage = null;
            if(file !=null && file.getSize() > 0){
                staffImage = file.getInputStream();
            }else{
                status = "Please Provide a valid Profile Image.";                
//                RequestDispatcher rd = request.getRequestDispatcher("addStaff.jsp?message="+status);
//                rd.forward(request, response);
                response.sendRedirect("addStaff.jsp?message="+status);
                return;
            }
            System.out.println("staff Image:"+ staffImage);
            
            
            if(passwd != null && passwd.equals(confirmPassword)){
                
                passwd = PasswordEncryption.getEncryptedPassword(passwd);
                System.out.println("password: "+passwd);
                
                // Create StaffBean and call registerStaff
                StaffBean staff = new StaffBean();
                staff.setStaffName(staffName);
                staff.setStaffId(emailId);
                staff.setMobile(mobileNo);
                staff.setPassword(passwd);
                
                System.out.println("staff:"+staff.toString());
                // Assuming registerUser accepts InputStream for image
                StaffServiceImpl dao = new StaffServiceImpl();
                status = dao.registerStaff(staff, staffImage);               
                System.out.println("status: "+status);
                response.sendRedirect("adminHome.jsp?message="+status);
                
            }else{
                status = "password not matching!";
                response.sendRedirect("addStaff.jsp?message=" + status);
            }            
            
        }catch(IOException | ServletException e){
            System.out.println("Error in db :"+e.getMessage());
//            e.getMessage();
//            return;
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
