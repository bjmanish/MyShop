<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <style>
        body {
            background: #f4f6f9;
        }
        .box {
            margin-top: 100px;
            padding: 30px;
            background: white;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .success-icon {
            font-size: 60px;
            color: green;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="col-md-6 col-md-offset-3 box">

        <div class="success-icon">?</div>

        <h2 class="text-success">Payment Successful</h2>

        <p><strong>Transaction ID:</strong> ${param.txnid}</p>
        <p><strong>Amount:</strong> ? ${param.amount}</p>
        <p><strong>Status:</strong> ${param.status}</p>

        <hr>

        <a href="userHome.jsp" class="btn btn-primary">Go to Home</a>
        <a href="orders.jsp" class="btn btn-success">View Orders</a>

    </div>
</div>

</body>
</html>