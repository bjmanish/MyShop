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

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>The MYSHOP - Order Details Page</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<style>

/* ? FIX HEADER OVERLAP (IMPORTANT) */
body {
    padding-top: 110px !important;
}

/* SMALL SPACING */
.page-content {
    margin-top: 10px;
}

</style>

</head>

<body>

<%
    String userName = (String)session.getAttribute("username");
    String password = (String)session.getAttribute("sessionId");          

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?error=session_expired");                
    }

    String message = request.getParameter("message");
%>

<!-- HEADER -->
<jsp:include page="/header.jsp"></jsp:include>

<!-- MAIN CONTENT -->
<div class="container page-content">

    <% if(message != null){ %>
        <div class="text-center text-danger">
            <h4><%=message%></h4>
        </div>
    <% } %>

    <!-- TITLE -->
    <div class="text-center" style="color: rgb(18, 9, 148); margin-bottom:20px;">
        <h1>Order Details</h1>
    </div>

    <div class="table-responsive">

        <%
            OrderServiceImpl orderDAO = new OrderServiceImpl();          
            List<OrderDetails> orders = orderDAO.getAllOrderDetails(userName);
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");                            
        %>    

        <table class="table table-hover table-bordered">

            <thead style="background-color: rgba(4, 80, 80,0.9); color:white;">
                <tr>
                    <th>Product Image</th>
                    <th>Order Id</th>
                    <th>Product Name</th>
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

                        String status = order.getStatus();
                        int shipped = status.equals("PLACED") ? 0 : 1;
                        String statusClass = shipped == 0 ? "label label-warning" : "label label-success";
                %>

                <tr>
                    <td>
                        <img src="./ShowImage?pid=<%=order.getProdId()%>" 
                             style="width:50px;height:50px;">
                    </td>

                    <td><%=order.getOrderId()%></td>
                    <td><%=order.getProdName()%></td>
                    <td><%=order.getQnty()%></td>
                    <td>Rs. <%=order.getAmount()%></td>
                    <td><%= sdf.format(order.getDatetime()) %></td>
                    <td><%= sdf.format(order.getDeliveryDate()) %></td>

                    <td>
                        <span class="label label-info">
                            <%= orderDAO.getOtpByOrderId(order.getOrderId()) %>
                        </span>
                    </td>

                    <td>
                        <span class="<%=statusClass%>">
                            <%=status%>
                        </span>
                    </td>
                </tr>

                <% } %>

            </tbody>

        </table>
    </div>
</div>

<!-- FOOTER -->
<jsp:include page="/footer.html"></jsp:include>

<!-- ? AUTO HEADER HEIGHT FIX (BEST PRACTICE) -->
<script>
window.onload = function() {
    const nav = document.getElementById("navbar");
    if(nav){
        document.body.style.paddingTop = nav.offsetHeight + "px";
    }
};
</script>

</body>
</html>