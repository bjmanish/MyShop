package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.myshop.beans.OrderDetails;
import com.myshop.service.OrderService;
import com.myshop.beans.OrderBean;
import java.util.List;
import com.myshop.service.impl.OrderServiceImpl;

public final class orderDetails_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n");
      out.write("<html lang=\"en\">\n");
      out.write("    <head>\n");
      out.write("        <meta charset=\"utf-8\">\n");
      out.write("        <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n");
      out.write("        <title>The MYSHOP - Order Details Page</title>\n");
      out.write("        <meta name=\"description\" content=\"\">\n");
      out.write("        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n");
      out.write("       <!-- <link rel=\"stylesheet\" href=\"./css/main.css\"> -->\n");
      out.write("        <!-- Bootstrap CSS -->\n");
      out.write("        <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css\">\n");
      out.write("        <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js\"></script>\n");
      out.write("        <script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js\"></script>\n");
      out.write("    </head>\n");
      out.write("    <body style=\"background-color: #E6F9E6 ;\">\n");
      out.write("        <!-- checking the admin credentials -->\n");
      out.write("        ");
 
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");
            //String userType = (String)session.getAttribute("usertype");
            
            
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");                
            }
            
            String message = request.getParameter("message");
            
            OrderServiceImpl orderDAO = new OrderServiceImpl();            
            System.out.println("userName: "+userName+" "+orderDAO.getOrderByUserId(userName));
            List<OrderBean> orders = orderDAO.getOrderByUserId(userName);
        
      out.write("\n");
      out.write("        ");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "header.jsp", out, false);
      out.write("\n");
      out.write("        \n");
      out.write("        ");
if(message!=null){
      out.write("\n");
      out.write("            <div class=\"text-center\" style=\"color: red\"><h6>");
      out.print(message);
      out.write("</h6></div>\n");
      out.write("        ");
}
      out.write("\n");
      out.write("        <div class=\"text-center\" style=\"color: rgb(18, 9, 148);\"><h1>Order Details</h1></div>\n");
      out.write("        <div class=\"container-fluid\">\n");
      out.write("            <div class=\"table-responsive\">\n");
      out.write("                <table class=\"table table-hover table-sm table-bordered \">\n");
      out.write("                    <thead class=\"thead-dark\" style=\" background-color: rgba(4, 80, 80, 0.978); font-size: 18px; color:white;\">\n");
      out.write("                        <tr>\n");
      out.write("                            <th>Product Image</th>\n");
      out.write("                            <th>Order Id</th>\n");
      out.write("                            <th>Product Name</th>\n");
      out.write("<!--                            <th>Customer Details</th>-->\n");
      out.write("                            <th>Quantity</th>\n");
      out.write("                            <th>Amount</th>\n");
      out.write("                            <th>Time</th>\n");
      out.write("                            <th>Status</th>\n");
      out.write("                        </tr>\n");
      out.write("                    </thead>\n");
      out.write("\n");
      out.write("                    <tbody style=\"background-color: white;\">\n");
      out.write("                        <!-- get the product details with transactions ID -->\n");
      out.write("                        ");

                            for(OrderBean order : orders){
                        
      out.write("\n");
      out.write("                        <tr>\n");
      out.write("                            <td><img src=\"./ShowImage?pid=");
      out.print(order.getProdId());
      out.write("\"style=\"width: 50px; height: 50px;\"></td>\n");
      out.write("                            <td>");
      out.print(order.getOrderId());
      out.write("</td>\n");
      out.write("                            <td>");
      out.print(order.getProdName() );
      out.write("</td>\n");
      out.write("\n");
      out.write("                            <td>");
      out.print(order.getQnty());
      out.write("</td>\n");
      out.write("                            <td>");
      out.print(order.getAmount() );
      out.write("</td>\n");
      out.write("                            <td>");
      out.print(order.getDatetime() );
      out.write("</td>\n");
      out.write("                            <td><span class=\"badge badge-success\">");
      out.print(order.getShipped() == 0 ? "ORDER_PLACED" : "ORDER_SHIPPED" );
      out.write("</span></td>\n");
      out.write("                        </tr>\n");
      out.write("                        \n");
      out.write("                        ");
}
      out.write("\n");
      out.write("                        \n");
      out.write("                    </tbody>\n");
      out.write("\n");
      out.write("                </table>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("        ");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "footer.html", out, false);
      out.write("\n");
      out.write("    </body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
