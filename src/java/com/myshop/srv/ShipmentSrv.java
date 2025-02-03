package com.myshop.srv;

import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.utility.MailMessage;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "ShipmentSrv", urlPatterns = {"/ShipmentSrv"})
public class ShipmentSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public ShipmentSrv() {
        super();
    }

    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            HttpSession session = request.getSession();
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");
            String userType = (String)session.getAttribute("usertype");
            
            if (userType == null || !userType.equals("admin")) {
                response.sendRedirect("login.jsp?error=access_denied");
                return;
            }
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");
            }
            
            String userId = request.getParameter("userid");
            String prodId = request.getParameter("prodid");
            String orderId = request.getParameter("orderid");
            //System.out.println(request.getParameter("amount")+" orderId:"+orderId);
            Double amount = Double.parseDouble(request.getParameter("amount"));
            
            String status = new OrderServiceImpl().shipNow(orderId, prodId);
            
            String pageName = "shippedItems.jsp";
            
            if(status.equalsIgnoreCase("FAILURE")){
                pageName  = "unShippedItems.jsp";
            }else{
                MailMessage.orderShipped(userId, new UserServiceImpl().getFirstName(userId) , orderId, amount);
            }
            PrintWriter pw = response.getWriter();
            RequestDispatcher rd = request.getRequestDispatcher(pageName);
            rd.include(request, response);
            pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
            
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
