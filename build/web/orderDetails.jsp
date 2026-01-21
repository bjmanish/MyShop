<%@page import="java.sql.Date"%>
<%@page import="com.myshop.utility.DeliveryDate"%>
<%@page import="java.time.ZoneId"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="com.myshop.service.OrderService"%>
<%@page import="com.myshop.beans.OrderBean"%>
<%@page import="java.util.*"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>
<!DOCTYPE html "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>The MYSHOP - Order Details Page</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
       <!-- <link rel="stylesheet" href="./css/main.css"> -->
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6 ;">
        <!-- checking the admin credentials -->
        <% 
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");          
            
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");                
            }
            
            String message = request.getParameter("message");
            
            
        %>
        <jsp:include page="header.jsp" ></jsp:include>
        
        <% if( message != null){%>
            <div class="text-center" style="color: red;"><h6><%=message%></h6></div>
        <% }%>
        <div class="text-center" style="color: rgb(18, 9, 148);"><h1>Order Details</h1></div>
        <div class="container-fluid">
            <div class="table-responsive">
                <!-- get the product details with transactions ID -->
                        <%
                            OrderServiceImpl orderDAO = new OrderServiceImpl();          
                            List<OrderDetails> orders = orderDAO.getAllOrderDetails(userName);
                            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");                            
                        %>                        
                <table class="table table-hover table-sm table-bordered ">
                    <thead class="thead-dark" style=" background-color: rgba(4, 80, 80,0.9); font-size: 18px; color:white;">
                        <tr>
                            <th>Product Image</th>
                            <th>Order Id</th>
                            <th>Product Name</th>
<!--                            <th>Customer Details</th>-->
                            <th>Quantity</th>
                            <th>Amount</th>
                            <th>Order Date</th>
                            <th>Delivery Date</th>
                            <th>OTP</th> 
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody style="background-color: white;">
                        <%
                            for(OrderDetails order : orders) {
//                                order.getDeliveryDate().getClass().getName();
//                                java.util.Date deliveryDate = new java.util.Date(order.getDeliveryDate()); // convert sql.Date to util.Date
                                String status = order.getStatus();
                                String statusClass = order.getShipped() == 0 ? "bg-warning" : "bg-success";
                        %>
                        
                                <tr>
                                    <td><img src="./ShowImage?pid=<%=order.getProdId()%>" style="width: 50px; height: 50px;"></td>
                                    <td><%=order.getOrderId()%></td>
                                    <td><%=order.getProdName()%></td>
                                    <td><%=order.getQnty()%></td>
                                    <td>Rs. <%=order.getAmount()%></td>
                                    <td><%= sdf.format(order.getDatetime()) %></td>
                                    <td><%= sdf.format(order.getDeliveryDate()) %></td>
                                    <td><span class="badge"><%= orderDAO.getOtpByOrderId(order.getOrderId()) %></span></td>
                                    <td><span class="badge <%=statusClass%>"><%=status%></span></td>
                                </tr>
                        <%  } %>                        
                    </tbody>

                </table>
            </div>
        </div>
        <jsp:include page="footer.html" ></jsp:include>
    </body>
</html>
