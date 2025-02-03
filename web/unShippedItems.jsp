<%@page import="com.myshop.service.OrderService"%>
<%@page import="java.sql.Array"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.service.impl.TransactionServiceImpl"%>
<%@page import="com.myshop.beans.OrderBean"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>
<!DOCTYPE html "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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

        <div class="text-center" style="color: rgb(8, 193, 27);"><h1> Unshipped Orders</h1></div>
        <div class="container-fluid">
            <div class="table-responsive">
                <table class="table table-hover table-sm table-bordered">
                    <thead class="thead-dark table-bordered" style=" background-color: rgba(4, 80, 80, 0.978); font-size: 18px; color:white;">
                        <tr>
                            <th>Transaction ID</th>
                            <th>Product Id</th>
                            <th>Customer Email</th>
                            <th>Address</th>
                            <th>Quantity</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody style="background-color: white;">
                        <!-- get the product details with transactions ID -->
                        <%  OrderService orderDao  = new OrderServiceImpl();
                            List<OrderBean> orders = new ArrayList<>();
                            orders = orderDao.getAllOrders();
                            //System.out.println("Unshipped orders :"+orders.toString());
                            int count  = 0;
                            for(OrderBean order : orders){
                                String transId = order.getTransId();
                                String prodId = order.getProdId();
                                int qty = order.getQuantity();
                                double amount = order.getAmount();
                                int shipped  =  order.getShipped();
                                String userId = new TransactionServiceImpl().getUserId(transId);
                                String userAdd = new UserServiceImpl().getUserAddr(userId);
                                if(shipped == 0){
                                    count ++;                                
                        %>

                        <tr>
                            <td><%=transId%></td>
                            <td><a href="./updateProduct.jsp?prodid=<%=prodId%>"><%=prodId%></a></td>
                            <td><%=userId%></td>
                            <td><%=userAdd%></td>
                            <td><%=qty%></td>
                            <td>Rs.&nbsp;<%=amount%></td> 
                            <td><span class="badge">READY_TO_SHIP</span></td>
                            <td>
                                <a href="ShipmentSrv?orderid=<%=order.getTransId()%>&amount=<%=amount%>&prodid=<%=order.getProdId()%>&userid=<%=userId%>"  class="btn btn-primary">Shipped Now</a>
                            </td>
                        </tr>
                        <%  }
                          }
                           if(count == 0){
                        %>
                        

                        <tr style="background-color: grey; color: white; align-items: center; justify-content: center;">
                            <td colspan="8" class="text-center">No Orders Shipped Yet!</td>
                        </tr>
                        <!-- close the if body -->
                        <%}%>
                    </tbody>

                </table>
            </div>
        </div>
        <jsp:include page="footer.html" ></jsp:include>
    </body>
</html>