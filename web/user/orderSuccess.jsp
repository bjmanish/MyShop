<!DOCTYPE html>
<html>
<head>
<title>Order Success - MyShop</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<!-- SweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
body{
    background: linear-gradient(135deg,#1d2671,#c33764);
    height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    font-family: 'Segoe UI', sans-serif;
}

/* Glass Card */
.success-card{
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(20px);
    padding:40px;
    border-radius:20px;
    text-align:center;
    color:white;
    box-shadow:0 15px 50px rgba(0,0,0,0.5);
    width:90%;
    max-width:450px;
    animation: fadeIn 0.6s ease-in-out;
}

/* Animation */
@keyframes fadeIn{
    from{opacity:0; transform:scale(0.9);}
    to{opacity:1; transform:scale(1);}
}

/* Checkmark */
.checkmark{
    font-size:80px;
    color:#00ff88;
    animation: pop 0.5s ease;
}

@keyframes pop{
    0%{transform:scale(0);}
    100%{transform:scale(1);}
}

/* Order ID Box */
.order-id{
    background:white;
    color:black;
    padding:12px;
    border-radius:10px;
    font-weight:bold;
    letter-spacing:1px;
    margin-top:10px;
}

/* Buttons */
.btn-custom{
    border-radius:30px;
    padding:10px 20px;
    margin:10px;
    transition:0.3s;
}

.btn-custom:hover{
    transform:scale(1.05);
}

/* Countdown */
.timer{
    margin-top:15px;
    font-size:14px;
    color:#ccc;
}
</style>
</head>

<body>

<%
String orderId = request.getParameter("orderId");
String amount = request.getParameter("amount");
%>

<div class="success-card">

    <!-- ? Icon -->
    <div class="checkmark"><i class="bi bi-box-seam"></i> </div>

    <!-- Title -->
    <h2 class="mt-3">Order Placed Successfully <i class="bi bi-cash"></i> </h2>

    <p class="mt-2">Thank you for shopping with MyShop!</p>

    <!-- Order ID -->
    <p>Your Order ID:</p>
    <div class="order-id">
        <%= orderId != null ? orderId : "N/A" %>
    </div>

    <!-- Amount -->
    <% if(amount != null){ %>
        <p class="mt-3">Amount Paid: ? <b><%= amount %></b></p>
    <% } %>

    <!-- Countdown -->
    <div class="timer">
        Redirecting to home in <span id="count">5</span> sec...
    </div>

    <!-- Buttons -->
    <div class="mt-4">

        <a href="userHome.jsp" class="btn btn-primary btn-custom">
            <i class="bi bi-cart3"></i> Continue Shopping
        </a>

        <a href="orderDetails.jsp?orderId=<%=orderId%>" class="btn btn-success btn-custom">
            <i class="bi bi-box-seam"></i>  View Orders
        </a>

    </div>

</div>

<script>
// ? SweetAlert Popup
window.onload = function(){
    Swal.fire({
        icon: 'success',
        title: 'Order Confirmed!',
        text: 'Your order has been placed successfully.',
        timer: 2000,
        showConfirmButton: false
    });
}

// ?? Auto Redirect Countdown
let sec = 60;
let countEl = document.getElementById("count");

let timer = setInterval(()=>{
    sec--;
    countEl.innerText = sec;

    if(sec <= 0){
        clearInterval(timer);
        window.location.href = "userHome.jsp";
    }
},1000);
</script>

</body>
</html>