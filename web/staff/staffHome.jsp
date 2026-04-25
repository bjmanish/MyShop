<%@ page language="java"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Delivery Staff - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap CSS -->
<!--    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>-->

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
        String userType = (String) session.getAttribute("role");
        String userName = (String) session.getAttribute("username");
        String userId = (String)session.getAttribute("sessionId");
//        System.out.println("userType: "+userType+" userName: "+ userName+" id: "+userId+"password: "+(String)session.getAttribute("password"));
        if (userType == null || !userType.equalsIgnoreCase("DELIVERY") || userId.isEmpty()) {
            response.sendRedirect("login.jsp?error=access_denied");
            return;
        }
    %>

    <jsp:include page="/header.jsp" />

    <div class="container staff-container mt-5 pt-5">
        <div class="text-center pd-5 mt-5 text-white">
            <h1>Delivery Staff Dashboard</h1>
            <p class="lead text-success text-bold fw-bold">Welcome, userName! Manage your deliveries efficiently.</p>
        </div>

        <div class="row">
            <!-- View Pending Deliveries -->
            <div class="col-md-4">
                <div class="card">
                    <i class="glyphicon glyphicon-hourglass text-warning"></i>
                    <h4>Pending Deliveries</h4>
                    <a href="pendingDeliveries.jsp?id+<%=userId%>" class="btn btn-warning btn-block">View</a>
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

    <jsp:include page="/footer.html" />

</body>
</html>
