<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.OrderItem"%>
<%@page import="com.myshop.beans.UserBean"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
<title>Admin - Shipped Orders</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">-->

<style>
body{
    background:#eef9ee;
    padding-top:100px;
}

/* Card Row Style */
.order-row{
    background:white;
    margin-bottom:15px;
    padding:15px;
    border-radius:10px;
    box-shadow:0 3px 10px rgba(0,0,0,0.1);
}

/* Status */
.status{
    padding:5px 10px;
    border-radius:5px;
    color:white;
}
.status-SHIPPED{background:#337ab7;}
.status-OUT_FOR_DELIVERY{background:#5bc0de;}
.status-DELIVERED{background:#5cb85c;}

/* Button */
.btn-deliver{
    background:#222;
    color:white;
    padding:6px 10px;
    border-radius:5px;
}
</style>

</head>

<body>

<jsp:include page="/header.jsp"></jsp:include>

<%
String userType = (String)session.getAttribute("role");

if(userType == null || !userType.equalsIgnoreCase("admin")){
    response.sendRedirect("login.jsp");
    return;
}

List<OrderDetails> orders = new OrderServiceImpl().getAllOrders();
int count = 0;
%>

<div class="container">

    <h2 class="text-center text-success"><i class="bi bi-truck"></i> Shipped Orders</h2>

<%
for(OrderDetails order : orders){

    String status = order.getStatus();

    if(!"PLACED".equalsIgnoreCase(status)){  // ? FIXED
        count++;

        String userId = order.getUserId();
        UserBean user = new UserServiceImpl().getUserDetailsById(userId);
%>

<div class="order-row">

<div class="row">

<!-- ORDER INFO -->
<div class="col-md-3">
    <b>Order ID:</b> <%=order.getOrderId()%><br>
    <b>Amount:</b> ? <%=order.getAmount()%>
</div>

<!-- PRODUCTS -->
<div class="col-md-3">
    <b>Products:</b><br>
    <% for(OrderItem item : order.getItems()){ %>
        <%= new ProductServiceImpl().getProductNameById(item.getProductId()) %>
        (x<%=item.getQuantity()%>)<br>
    <% } %>
</div>

<!-- USER -->
<div class="col-md-3">
    <b>Customer:</b><br>
    <%= (user!=null)? user.getName():"N/A" %><br>
    <small><%= (user!=null)? user.getEmail():"" %></small><br>
    <small><%= (user!=null)? user.getAddress():"" %></small>
</div>

<!-- STATUS + ACTION -->
<div class="col-md-3 text-center">

<span class="status status-<%=status%>">
    <%=status%>
</span>

<br><br>

<% if(!("OUT_FOR_DELIVERY".equalsIgnoreCase(status) || "DELIVERED".equalsIgnoreCase(status))){ %>

<a href="<%=request.getContextPath()%>/OutForDeliverySrv?orderid=<%=order.getOrderId()%>&userid=<%=userId%>"
   onclick="return confirm('Mark as Out For Delivery?')"
   class="btn-deliver">
   ? Ready for Delivery
</a>

<% } else { %>
    <span class="text-muted">? Processed</span>
<% } %>

</div>

</div>

</div>

<% } } %>

<% if(count == 0){ %>
<div class="text-center text-muted">
    <h4>No Orders Found</h4>
</div>
<% } %>

</div>

<jsp:include page="/footer.html"></jsp:include>

</body>
</html>