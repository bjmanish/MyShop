<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>  
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>The MYSHOP - Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

    <style>
        
        .admin-container {
            margin-top: 80px;
        }
        .admin-card {
            margin-bottom: 20px;
            text-align: center;
            border-radius: 10px;
            padding: 20px;
            transition: 0.3s;
            box-shadow: 2px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .admin-card:hover {
            transform: scale(1.05);
        }
        .admin-card i {
            font-size: 40px;
            margin-bottom: 10px;
        }
    </style>
</head>

<body style="background-color: #E6F9E6;">

    <%-- Admin Session Validation --%>
    <%
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String userType = (String) session.getAttribute("usertype");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?error=access_denied");
            return;
        }
        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }
    %>

    <%@ include file="header.jsp" %>

    <div class="container admin-container">
        <div class="text-center">
            <h1>Admin Dashboard</h1>
            <p class="lead">Welcome, <%= userName %>! Manage your shop efficiently.</p>
        </div>

        <div class="row">
            <div class="col-md-3">
                <div class="panel panel-info admin-card">
                    <i class="glyphicon glyphicon-eye-open text-info"></i>
                    <h4>View Products</h4>
                    <a href="adminViewProduct.jsp" class="btn btn-info btn-block">Go</a>
                </div>
            </div>

            <div class="col-md-3">
                <div class="panel panel-success admin-card">
                    <i class="glyphicon glyphicon-plus-sign text-success"></i>
                    <h4>Add Product</h4>
                    <a href="addProduct.jsp" class="btn btn-success btn-block">Go</a>
                </div>
            </div>

            <div class="col-md-3">
                <div class="panel panel-primary admin-card">
                    <i class="glyphicon glyphicon-user text-primary"></i>
                    <h4>Add Delivery Staff</h4>
                    <a href="addStaff.jsp" class="btn btn-primary btn-block">Go</a>
                </div>
            </div>

            <div class="col-md-3">
                <div class="panel panel-primary admin-card">
                    <i class="glyphicon glyphicon-eye-open text-warning"></i>
                    <h4>View Delivery Staff</h4>
                    <a href="viewStaff.jsp" class="btn btn-warning btn-block">Go</a>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.html" %>

</body>
</html>
