<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Delivery Staff - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

    <style>
        body {
            background-color: #E6F9E6;
        }
        .staff-container {
            margin-top: 80px;
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 2px 4px 10px rgba(0, 0, 0, 0.1);
            transition: 0.3s;
            text-align: center;
        }
        .card:hover {
            transform: scale(1.05);
        }
        .card i {
            font-size: 40px;
            margin-bottom: 10px;
        }
    </style>
</head>

<body style="background-color: #E6F9E6;">

    <%-- Session Validation --%>
    <%
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");

        if (userType == null || !userType.equals("staff")) {
            response.sendRedirect("login.jsp?error=access_denied");
            return;
        }
    %>

    <%@ include file="header.jsp" %>

    <div class="container staff-container">
        <div class="text-center">
            <h1>Delivery Staff Dashboard</h1>
            <p class="lead">Welcome, userName! Manage your deliveries efficiently.</p>
        </div>

        <div class="row">
            <!-- View Pending Deliveries -->
            <div class="col-md-4">
                <div class="card">
                    <i class="glyphicon glyphicon-hourglass text-warning"></i>
                    <h4>Pending Deliveries</h4>
                    <a href="pendingDeliveries.jsp" class="btn btn-warning btn-block">View</a>
                </div>
            </div>

            <!-- Update Delivery Status -->
            <div class="col-md-4">
                <div class="card">
                    <i class="glyphicon glyphicon-ok text-success"></i>
                    <h4>Update Delivery Status</h4>
                    <a href="updateDelivery.jsp" class="btn btn-success btn-block">Update</a>
                </div>
            </div>

            <!-- View Delivery History -->
            <div class="col-md-4">
                <div class="card">
                    <i class="glyphicon glyphicon-list text-primary"></i>
                    <h4>Delivery History</h4>
                    <a href="deliveryHistory.jsp" class="btn btn-primary btn-block">View</a>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.html" %>

</body>
</html>
