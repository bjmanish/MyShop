<%@page import="com.myshop.beans.OrderItem"%>
<%@page import="com.myshop.beans.UserBean"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="com.myshop.service.impl.TransactionServiceImpl"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>
<%@page import="com.myshop.beans.OrderBean"%>
<%@page import="java.util.List"%>
<!DOCTYPE html "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>The MYSHOP - Admin Home shipped Orders Page</title>
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
            String password = (String)session.getAttribute("sessionId");
            String userType = (String)session.getAttribute("role");
            
            if (userType == null || !userType.equalsIgnoreCase("admin")) {
                response.sendRedirect("login.jsp?error=access_denied");
                return;
            }
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");
                return;
            }            

        %>
        <jsp:include page="/header.jsp" ></jsp:include>

        <div class="text-center" style="color: rgb(8, 193, 27);"><h1>Shipped Orders</h1></div>
        <div class="container-fluid">
            <div class="table-responsive">
                <table class="table table-hover table-sm">
                    <thead class="thead-dark" style=" background-color: rgba(4, 80, 80, 0.978); font-size: 18px; color:white;">
                        <tr>
                            <th>Transaction ID</th>
                            <th>Product Id</th>
                            <th>Customer Name</th>
                            <th>Address</th>
                            <th>Quantity</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>ACTION</th>
                        </tr>
                    </thead>

                    <tbody style="background-color: white;">
                        <!-- get the product details with transactions ID -->
                        <%
                            List<OrderDetails> orders = new OrderServiceImpl().getAllOrders();
                            System.out.println("Order Details from shipped page: "+orders.toString());
                            int count  = 0;
                            for(OrderDetails order : orders){
                                String transId = order.getOrderId();
                                String prodId = order.getProdId();
                                String status = order.getStatus();
                                int shipped  =  order.getShipped();
                                double amount = order.getAmount();
                                int qty = order.getQnty();
                                String userId = order.getUserId(); // ? STRING
                                UserBean user = new UserServiceImpl().getUserDetailsById(Integer.parseInt(userId));
                              System.out.println("User Details by id: "+user.toString());
                                if(status != "PLACED"){
                                    count ++;                                
                        %>
                        <tr>
                            <td><%=order.getOrderId()%></td>

                            <!-- PRODUCTS -->
                            <td>
                                <% for (OrderItem item : order.getItems()) { %>
                                    <b><%=item.getProductName()%></b><br/>
                                    <small>(ID: <%=item.getProductId()%>)</small><br/><br/>
                                <% } %>
                            </td>

                            <!-- USER -->
                            <td>
                                <%= (user != null) ? user.getEmail() : "N/A" %> <br/>
                                <small>(Name: <%= user.getName() %>)</small><br/><br/>
                            </td>
                            <td><%= (user != null) ? user.getAddress() : "N/A" %></td>

                            <!-- QUANTITY -->
                            <td>
                                <% for (OrderItem item : order.getItems()) { %>
                                    <%=item.getQuantity()%><br/>
                                <% } %>
                            </td>

                            <!-- AMOUNT -->
                            <td><span style="font-weight:bold;">&#8377; <%=order.getAmount()%></span> </td>
                            <td><span class="badge badge-success"><%=order.getStatus() %></span></td>
                            <td>
                                <% if(! ("OUT_FOR_DELIVERY".equalsIgnoreCase(order.getStatus()) || "DELIVERED".equalsIgnoreCase(order.getStatus()) )){    %>
                                    <a href="<%=request.getContextPath()%>OutForDeliverySrv?orderid=<%= order.getOrderId()%>&userid=<%= userId %>&prodid=<%= order.getProdId() %>&status=OUT_FOR_DELIVERY"
                                        onclick="return confirm('Mark this order as Ready for Delivery?');">
                                            <span class="badge bg-dark">READY FOR DELIVERED</span>
                                    </a>
                                <%}else{%>
                                    <p style="text-align: center;">-<p>  
                                <%}%>
                            </td>
                        </tr>
                        <%
                                }
                            }   
                            if(count == 0){
                        %>
                        
                        <tr style="background-color: grey; color: white;">
                            <td colspan="7" class="text-center">No Orders Shipped Yet!</td>
                        </tr>
                        <%}%>
                    </tbody>

                </table>
            </div>
        </div>
        <jsp:include page="/footer.html" ></jsp:include>
    </body>
</html>