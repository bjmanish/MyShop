<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Failed</title>

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
        .fail-icon {
            font-size: 60px;
            color: red;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="col-md-6 col-md-offset-3 box">

        <div class="fail-icon">?</div>

        <h2 class="text-danger">Payment Failed</h2>

        <p><strong>Transaction ID:</strong> ${param.txnid}</p>
        <p><strong>Status:</strong> ${param.status}</p>

        <hr>

        <a href="checkout.jsp" class="btn btn-warning">Try Again</a>
        <a href="userHome.jsp" class="btn btn-default">Go Home</a>

    </div>
</div>

</body>
</html>