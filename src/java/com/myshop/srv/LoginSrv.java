package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.utility.PasswordEncryption;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginSrv", urlPatterns = {"/LoginSrv"})
public class LoginSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public LoginSrv() {
        super();
    }
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("usertype");
        
        String status = "Login Denied! Invalid username or password.";
        if(userType.equals("admin")){
            //Login as Admin
            if(password.equals("admin") && userName.equals("admin123@gmail.com")){
                //Valid
                //RequestDispatcher rd = request.getRequestDispatcher("adminViewProduct.jsp");
                HttpSession session = request.getSession();
                session.setAttribute("username", userName);
                session.setAttribute("password", password);
                session.setAttribute("usertype", userType);
                //rd.forward(request, response);
                response.sendRedirect("adminHome.jsp");
            }else{
                //Invalid
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
                rd.forward(request, response);
            }
        }else{
            //Login as customer
          //  System.out.println("Input Password: "+password);
                        
            UserServiceImpl udao = new UserServiceImpl();
            status = udao.isValidCredential(userName, password);
            if(status.equalsIgnoreCase("valid")){
                //valid user
                UserBean user = udao.getUserDetails(userName, password);
                HttpSession session = request.getSession();
                //session.setAttribute("userdata", user);
                
                session.setAttribute("username", userName);
                session.setAttribute("password", password);
                session.setAttribute("usertype", userType);
                response.sendRedirect("userHome.jsp?message= "+status);
                
                return;
            }else{
                //Invalid
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
                rd.forward(request, response);
                return;
            }
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
