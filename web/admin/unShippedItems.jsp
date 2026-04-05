<%@page import="com.myshop.beans.OrderItem"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="com.myshop.beans.UserBean"%>
<%@page import="com.myshop.beans.OrderBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>

<!DOCTYPE html "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html5/loose.dtd">
<html lang="en">
<head>
    <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>The MYSHOP - Admin Home Unshipped Orders Page</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
       <!-- <link rel="stylesheet" href="./css/main.css"> -->
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>

<body style="background-color: #E6F9E6 ;">

<%
    // ? Session Check
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

<jsp:include page="/header.jsp"></jsp:include>

<div class="text-center" style="color: rgb(8, 193, 27);">
    <h1>Unshipped Orders</h1>
</div>

<div class="container-fluid">
<div class="table-responsive">

<table class="table table-hover table-bordered">
<thead style="background-color:#045050; color:white;">
<tr>
    <th>Order ID</th>
    <th>Products</th>
    <th>Customer Email</th>
    <th>Address</th>
    <th>Quantity</th>
    <th>Total Amount</th>
    <th>Status</th>
    <th>Action</th>
</tr>
</thead>

<tbody style="background-color:white;">

<%
    OrderServiceImpl orderDao = new OrderServiceImpl();
    List<OrderDetails> orders = orderDao.getAllOrders();
//    System.out.println("Order Details : "+orders.toString());
    UserServiceImpl userService = new UserServiceImpl();
    
    int count = 0;

    for (OrderDetails order : orders) {

        // Only unshipped / placed orders
        if ("PLACED".equalsIgnoreCase(order.getStatus())) {

            count++;

            String userId = order.getUserId(); // ? STRING
            UserBean user = userService.getUserDetailsById(Integer.parseInt(userId));
//            System.out.println("User Details by id: "+user.toString());
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

    <!-- STATUS -->
    <td>
        <span class="label label-warning">READY TO SHIP</span>
    </td>

    <!-- ACTION -->
    <td>
        <a href="<%=request.getContextPath()%>ShipmentSrv?orderid=<%=order.getOrderId()%>&amount=<%=order.getAmount()%>&userid=<%=userId%>"
           class="btn btn-success btn-sm">
           Ship Now
        </a>
    </td>
</tr>

<%
        }
    }

    if (count == 0) {
%>

<tr style="background-color:grey; color:white;">
    <td colspan="8" class="text-center">No Unshipped Orders Found!</td>
</tr>

<% } %>

</tbody>
</table>

</div>
</div>

<jsp:include page="/footer.html"></jsp:include>

</body>
</html>