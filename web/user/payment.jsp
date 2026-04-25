<%@page import="com.myshop.utility.idUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String userId = (String) session.getAttribute("user_id");
String email = (String) session.getAttribute("username");
String name = (String) session.getAttribute("name");
if (userId == null) {
    response.sendRedirect("login.jsp");
}
double amount = Double.parseDouble(request.getParameter("amount"));
String pid = request.getParameter("pid");
//String paymentId = idUtil.generateTransactionId();
//String orderId = idUtil.generateUUIDOrderId();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MyShop - Secure Payment</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<!-- Bootstrap 5 JS (Required for modal) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
body {
    min-height: 100vh;
    background: linear-gradient(135deg, #1d2671, #c33764);
    display: flex;
    align-items: center;
    justify-content: center;
}

.payment-card {
    max-width: 420px;
    padding: 25px;
    border-radius: 18px;
    background: white;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}

.title {
    text-align: center;
    font-weight: 600;
}

.input-group-text {
    background: #f1f1f1;
}

.btn-pay {
    border-radius: 10px;
    padding: 12px;
    font-weight: 600;
    background: linear-gradient(45deg, #00c6ff, #0072ff);
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
}

/* Disabled */
.btn-pay:disabled {
    background: #ccc !important;
    cursor: not-allowed;
    opacity: 0.7;
    position: relative;
}

/* Tooltip */
.btn-pay:disabled:hover::after {
    content: "🚫 Fill all details";
    position: absolute;
    top: -35px;
    left: 50%;
    transform: translateX(-50%);
    background: black;
    color: white;
    font-size: 12px;
    padding: 5px 10px;
    border-radius: 6px;
}

/* Remove hover */
.btn-pay:disabled:hover {
    transform: none;
    box-shadow: none;
}

/* Input validation */
input:invalid { border: 1px solid red; }
input:valid { border: 1px solid green; }

.otp-box {
    width: 50px;
    font-size: 20px;
}
@keyframes shake {
  0% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  50% { transform: translateX(5px); }
  75% { transform: translateX(-5px); }
  100% { transform: translateX(0); }
}

.otp-error {
  animation: shake 0.3s;
  border: 1px solid red !important;
}
</style>
</head>

<body>

<div class="payment-card">

<h4 class="title text-success">
<i class="bi bi-wallet2"></i> Secure Payment
</h4>

    <form method="post" action="<%=request.getContextPath()%>/PaymentServlet">

<input type="hidden" name="user_id" value="<%=userId%>">
<input type="hidden" name="productinfo" value="<%=pid%>">
<input type="hidden" name="firstname" value="<%=name%>">
<input type="hidden" name="email" value="<%=email%>">
<input type="hidden" name="amount" value="<%=amount%>">

<!-- Pay Button -->
<button type="submit" id="payBtn" class="btn btn-pay w-100 text-white">
<span id="btnText">Fill Details</span>
</button>

</form>
</div>

</div>
</div>
</div>

</body>
</html>