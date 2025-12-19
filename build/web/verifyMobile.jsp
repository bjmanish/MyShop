<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%   
//    session = request.getSession();
    String sessionOtp = (String) session.getAttribute("otp");
    String sessionMobile = (String) session.getAttribute("mobile");
    String email = (String) session.getAttribute("email");
    String msg = "";
    System.out.println("from jsp "+sessionOtp+ " email: "+email);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verify Mobile - MyShop</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    
<div class="container mt-5">
    <div class="card shadow-sm p-4 mx-auto" style="max-width: 400px; border-radius: 10px;">
        <h4 class="text-center mb-3 text-primary">Mobile Number Verification</h4>
        <p class="text-center text-muted">
            <% if (sessionMobile != null) { %>
                OTP has been sent to your WhatsApp number: <b><%= sessionMobile %></b>
            <% } else { %>
                No mobile number found in session.
            <% } %>
        </p>

        <% if (!msg.isEmpty()) { %>
            <div class="alert alert-info text-center"><%= msg %></div>
        <% } %>

        <form method="get" class="mt-3" action="VerifyOTPServlet">
            <div class="mb-3">
                <label class="form-label">Enter OTP</label>
                <input type="text" name="otp" class="form-control" maxlength="6" required>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" name="verify" class="btn btn-primary">Verify OTP</button>
            </div>
        </form>

        <div class="text-center mt-3">
            <a href="SendOTPSrv" method="post">
                <button type="submit" class="btn btn-link">Resend OTP</button>
            </a>
        </div>
    </div>
</div>
</body>
</html>
