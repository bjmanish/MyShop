<%@page import="com.myshop.utility.idUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String userId = (String) session.getAttribute("user_id");
if (userId == null) {
    response.sendRedirect("login.jsp");
}
double amount = Double.parseDouble(request.getParameter("amount"));
String paymentId = idUtil.generateTransactionId();
String orderId = idUtil.generateUUIDOrderId();
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

<form>

<input type="hidden" name="user_id" value="<%=userId%>">
<input type="hidden" name="payment_id" value="<%=paymentId%>">
<input type="hidden" name="amount" value="<%=amount%>">
<input type="hidden" name="order_id" value="<%=orderId%>">

<div class="mb-3 input-group">
<span class="input-group-text"><i class="bi bi-person"></i></span>
<input type="text" class="form-control required-field" placeholder="Card Holder Name">
</div>

<div class="mb-3 input-group">
<span class="input-group-text"><i class="bi bi-credit-card"></i></span>
<input type="text" class="form-control required-field" placeholder="Card Number">
</div>

<div class="row">
<div class="col-6 mb-3 input-group">
<span class="input-group-text"><i class="bi bi-calendar"></i></span>
<input type="number" class="form-control required-field" placeholder="MM">
</div>

<div class="col-6 mb-3 input-group">
<span class="input-group-text"><i class="bi bi-calendar2"></i></span>
<input type="number" class="form-control required-field" placeholder="YYYY">
</div>
</div>

<div class="mb-3 input-group">
<span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
<input type="password" class="form-control required-field" placeholder="CVV">
</div>

<!-- Pay Button -->
<button type="button" id="payBtn" class="btn btn-pay w-100 text-white" onclick="openOtpModal()" disabled>
<span id="btnText">🚫 Fill Details</span>
</button>

</form>
</div>

<!-- OTP Modal -->
<div class="modal fade" id="otpModal">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content text-center p-4">

<h5><i class="bi bi-key"></i> OTP Verification</h5>

<div class="d-flex justify-content-center mb-3">
<input class="otp-box form-control mx-1">
<input class="otp-box form-control mx-1">
<input class="otp-box form-control mx-1">
<input class="otp-box form-control mx-1">
</div>

<p id="timer">00:30</p>
<!--<p class="otp-error"></p>-->
<div id="loader" style="display:none;">
<div class="spinner-border text-primary"></div>
<p>Verifying...</p>
</div>

<button class="btn btn-success w-100 mb-2" onclick="verifyOtp()">Verify & Pay</button>
<button class="btn btn-link" onclick="resendOtp()">Resend OTP</button>

</div>
</div>
</div>

<script>
let timeLeft = 30, timerInterval;

// 👉 Static test number (you can replace with dynamic user phone later)
const phone = "9999999999";
const countryCode = "+91";

// ================= OPEN OTP MODAL =================
function openOtpModal(){

    fetch("<%=request.getContextPath()%>/OtpServlet", {
        method:"POST",
        headers: {"Content-Type":"application/x-www-form-urlencoded"},
        body: "action=send&phone="+phone+"&countryCode="+countryCode
    })
    .then(res => res.json())
    .then(data => {
        if(data.status === "success"){
            console.log("OTP:", data.otp); // 🔥 check console
            // alert("TEST OTP: " + data.otp); // optional
        } else {
            alert("Failed to send OTP");
        }
    });

    new bootstrap.Modal(document.getElementById('otpModal')).show();
    startTimer();
}

// ================= TIMER =================
function startTimer(){
    timeLeft = 30;
    clearInterval(timerInterval);

    timerInterval = setInterval(()=>{
        timeLeft--;

        document.getElementById("timer").innerText =
            "00:" + (timeLeft < 10 ? "0" : "") + timeLeft;

        if(timeLeft <= 0){
            clearInterval(timerInterval);
            document.getElementById("timer").innerText = "Expired ❌";
        }
    },1000);
}

// ================= OTP AUTO FOCUS =================
document.querySelectorAll(".otp-box").forEach((input,i,arr)=>{
    input.addEventListener("keyup",(e)=>{
        if(input.value && i < 3) arr[i+1].focus();
        if(e.key==="Backspace" && i>0) arr[i-1].focus();
    });
});

// ================= VERIFY OTP =================
function verifyOtp(){

    let otp = "";
    document.querySelectorAll(".otp-box").forEach(i => otp += i.value);

    if(otp.length !== 4){
        alert("Enter valid OTP");
        return;
    }

    // ❌ Prevent verify if expired
    if(timeLeft <= 0){
        alert("OTP Expired ❌");
        return;
    }

    document.getElementById("loader").style.display = "block";

    fetch("<%=request.getContextPath()%>/OtpServlet", {
        method:"POST",
        headers: {"Content-Type":"application/x-www-form-urlencoded"},
        body:"action=verify&otp="+otp+"&phone="+phone+"&countryCode="+countryCode
    })
    .then(res => res.json())
    .then(data => {

        document.getElementById("loader").style.display = "none";

        if(data.status === "success"){
            alert("Payment Successful ✅");
            fetch("<%=request.getContextPath()%>/OrderSrv", {
                method:"POST",
                headers:{"Content-Type":"application/x-www-form-urlencoded"},
                body:"cartId=<%=request.getParameter("cartId")%>&amount=<%=request.getParameter("amount")%>&userId=<%=request.getParameter("uid")%>"
            })
            .then(res=>res.json())
            .then(data=>{
                if(data.status==="success"){
                    window.location.href="orderSuccess.jsp?orderId="+data.orderId;
                }
            });
        } else {
            inputs.forEach(input => {
                input.classList.add("otp-error");
                input.value = "";
            });
            setTimeout(() => {
                inputs.forEach(input => input.classList.remove("otp-error"));
            }, 300);
//            inputs[0].focus();

        }
    });
}

// ================= RESEND OTP =================
function resendOtp(){

    fetch("<%=request.getContextPath()%>/OtpServlet", {
        method:"POST",
        headers: {"Content-Type":"application/x-www-form-urlencoded"},
        body: "action=send&phone="+phone+"&countryCode="+countryCode
    })
    .then(res => res.json())
    .then(data => {
        if(data.status === "success"){
            console.log("New OTP:", data.otp);
            alert("OTP Resent ✅");
        }
    });

    startTimer();
}

// Enable/Disable Button
const inputs=document.querySelectorAll(".required-field");
const btn=document.getElementById("payBtn");

function checkInputs(){
let ok=true;
inputs.forEach(i=>{ if(!i.value.trim()) ok=false; });

btn.disabled=!ok;
document.getElementById("btnText").innerHTML=
ok ? 'Pay <i class="bi bi-currency-rupee"></i> <%=amount%>' : '🚫 Fill Details';
}

inputs.forEach(i=>i.addEventListener("input",checkInputs));
</script>

</body>
</html>