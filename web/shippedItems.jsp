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
            String password = (String)session.getAttribute("password");
            String userType = (String)session.getAttribute("usertype");
            
            if (userType == null || !userType.equals("admin")) {
                response.sendRedirect("login.jsp?error=access_denied");
                return;
            }
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");
                return;
            }            

        %>
        <jsp:include page="header.jsp" ></jsp:include>

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
                        </tr>
                    </thead>

                    <tbody style="background-color: white;">
                        <!-- get the product details with transactions ID -->
                        <%
                            List<OrderBean> orders = new OrderServiceImpl().getAllOrders();
                            int count  = 0;
                            for(OrderBean order : orders){
                                String transId = order.getTransId();
                                String prodId = order.getProdId();
                                int shipped  =  order.getShipped();
                                double amount = order.getAmount();
                                int qty = order.getQuantity();
                                String userId = new TransactionServiceImpl().getUserId(transId);
                                String userAdd = new UserServiceImpl().getUserAddr(userId);
                                if(shipped != 0){
                                    count ++;                                
                        %>
                        <tr>
                            <td><%=transId %></td>
                            <td><a href="./updateProduct.jsp?prodid=<%=prodId%>"><%=prodId%></a></td>
                            <td><%=userId%></td>
                            <td><%=userAdd%></td>
                            <td><%=qty%></td>
                            <td>Rs.<%=order.getAmount()%></td>
                            <td><span class="badge badge-success">SHIPPED</span></td>
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
        <jsp:include page="footer.html" ></jsp:include>
    </body>
</html>