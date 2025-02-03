package com.myshop.srv;

import com.myshop.utility.MailMessage;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(name = "FanMessage", urlPatterns = {"/FanMessage"})
public class FanMessage extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public FanMessage() {
        super();
    }

    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String comments = request.getParameter("comments");
        
        String htmlTextMessage = "" + "<html>" + "<body>"
                + "<h2style='color=black;'>Message to THE MYSHOP</h2> " + ""
                + "Fans Message Received !!<br/><br/> Name: " + name + "," + "<br/><br/> Email Id: " + email
		+ "<br><br/>" + "Comment: " + "<span style='color:grey;'>" + comments + "</span>"
		+ "<br/><br/>We are glad that fans are choosing us! <br/><br/>Thanks & Regards<br/><br/>Auto Generated Mail"
		+ "</body>" + "</html>";
        
        String message = MailMessage.sendMessage("themyshop2025@gmail.com", "Fans Message | "+ name + " | " + email, htmlTextMessage);
        
        if("SUCCESS".equals(message)){
            message = "Comments sent SuccessFully";
        }else{
            message = "Failed: Please Configure mailer.email.email and password in application.properties first";
        }
        
        RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
        rd.include(request, response);
        
        response.getWriter().print("<script>alert('"+message+"')</script>");
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
