<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.beans.OrderBean"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Details | MYSHOP</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- BOOTSTRAP 5 (MATCH header.jsp) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body style="background-color:#E6F9E6;">

<%
    String username = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("usertype");

    if (username == null || userType == null) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }

    String message = request.getParameter("message");
%>

<jsp:include page="header.jsp" />

<% if (message != null) { %>
    <div class="alert alert-danger text-center"><%= message %></div>
<% } %>

<div class="container mt-4">
    <h2 class="text-center text-primary mb-3">Order Details</h2>

    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">
            <thead class="table-dark">
                <tr>
                    <th>Order ID</th>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Amount (₹)</th>
                    <th>Order Time</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
                <%
                    OrderServiceImpl orderDAO = new OrderServiceImpl();
                    List<OrderBean> orders = orderDAO.getAllOrders();

                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");

                    if (orders == null || orders.isEmpty()) {
                %>
                    <tr>
                        <td colspan="6" class="text-danger fw-bold">No Orders Found</td>
                    </tr>
                <%
                    } else {
                        for (OrderBean order : orders) {
                %>
                    <tr>
                        <td><%= order.getTransId() %></td>
                        <td><%= order.getProdId() %></td>
                        <td><%= order.getQuantity() %></td>
                        <td><%= order.getAmount() %></td>
                        <td><%= sdf.format(order.getDeliveryDate())%></td>
                        <td>
                            <span class="badge bg-info">
                                <%= order.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.html" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
