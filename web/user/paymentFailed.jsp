<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userName =
            (String) session.getAttribute("username");

    String password =
            (String) session.getAttribute("sessionId");

    String userId =
            (String) session.getAttribute("user_id");


    /* =========================================================
       SESSION CHECK
       ========================================================= */

    if (userName == null ||
        password == null ||
        userId == null) {

        String sessionMessage =
                java.net.URLEncoder.encode(
                        "Your login session has expired. Please login again.",
                        "UTF-8"
                );

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?message="
                + sessionMessage
        );

        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Payment Failed | MyShop</title>

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            font-family: Arial, Helvetica, sans-serif;
            /*background: #f4f6f9;*/
            transition: background 0.3s ease, color 0.3s ease;
        }

        .payment-container {
            width: 100%;
            max-width: 520px;
        }

        .box {
            width: 100%;
            padding: 40px 35px;
            background: #ffffff;
            border-radius: 18px;
            text-align: center;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.10);
            border: 1px solid #eeeeee;
        }

        /* Failed Icon */
        .fail-icon-wrapper {
            width: 90px;
            height: 90px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: #ffe5e5;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .fail-icon {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            background: #dc3545;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
        }

        h2 {
            margin-top: 10px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .message {
            color: #666666;
            font-size: 15px;
            margin-bottom: 25px;
        }

        .transaction-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 25px;
            text-align: left;
        }

        .transaction-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #e5e5e5;
        }

        .transaction-row:last-child {
            border-bottom: none;
        }

        .transaction-label {
            font-weight: 600;
            color: #555555;
        }

        .transaction-value {
            color: #333333;
            text-align: right;
            word-break: break-word;
        }

        .status-failed {
            color: #dc3545;
            font-weight: 700;
        }

        .btn {
            min-width: 120px;
            margin: 5px;
            border-radius: 7px;
            padding: 10px 18px;
            font-weight: 600;
        }

        .btn-warning {
            color: #ffffff;
            background: #f0ad4e;
            border-color: #eea236;
        }

        .btn-warning:hover {
            color: #ffffff;
            background: #ec971f;
        }

        .btn-default {
            background: #ffffff;
        }

        .help-text {
            margin-top: 25px;
            color: #888888;
            font-size: 13px;
        }

        /* Mobile */
        @media (max-width: 480px) {

            body {
                padding: 15px;
            }

            .box {
                padding: 30px 20px;
                border-radius: 14px;
            }

            .fail-icon-wrapper {
                width: 75px;
                height: 75px;
            }

            .fail-icon {
                width: 48px;
                height: 48px;
                font-size: 28px;
            }

            h2 {
                font-size: 24px;
            }

            .message {
                font-size: 14px;
            }

            .transaction-row {
                display: block;
            }

            .transaction-label {
                display: block;
                margin-bottom: 5px;
            }

            .transaction-value {
                text-align: left;
                display: block;
            }

            .action-buttons {
                display: flex;
                flex-direction: column;
            }

            .action-buttons .btn {
                width: 100%;
                margin: 5px 0;
            }
        }

        /* Dark Mode */
        @media (prefers-color-scheme: dark) {

            body {
                background: #121212;
                color: #eeeeee;
            }

            .box {
                background: #1e1e1e;
                border-color: #333333;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.45);
            }

            .fail-icon-wrapper {
                background: #3a1c20;
            }

            .message {
                color: #bdbdbd;
            }

            .transaction-box {
                background: #292929;
            }

            .transaction-row {
                border-color: #3c3c3c;
            }

            .transaction-label {
                color: #bbbbbb;
            }

            .transaction-value {
                color: #eeeeee;
            }

            .btn-default {
                color: #eeeeee;
                background: #292929;
                border-color: #555555;
            }

            .btn-default:hover {
                color: #ffffff;
                background: #333333;
            }

            .help-text {
                color: #888888;
            }
        }
    </style>
</head>

<body>

<div class="payment-container">

    <div class="box">

        <!-- Failed Icon -->
        <div class="fail-icon-wrapper">
            <div class="fail-icon">
                ×
            </div>
        </div>

        <h2 class="text-danger">
            Payment Failed
        </h2>

        <p class="message">
            Unfortunately, your payment could not be completed.
            Please try again or choose another payment method.
        </p>

        <!-- Transaction Details -->
        <div class="transaction-box">

            <div class="transaction-row">
                <span class="transaction-label">
                    Transaction ID
                </span>

                <span class="transaction-value">
                    ${txnId}
                </span>
            </div>

            <div class="transaction-row">
                <span class="transaction-label">
                    Status
                </span>

                <span class="transaction-value status-failed">
                    ${paymentStatus}
                </span>
            </div>

        </div>

        <!-- Buttons -->
        <div class="action-buttons">

            <a href="<%=request.getContextPath()%>/user/cart.jsp"
               class="btn btn-warning">
                Try Again
            </a>

            <a href="<%=request.getContextPath()%>/user/userHome.jsp"
               class="btn btn-default">
                Go Home
            </a>

        </div>

        <p class="help-text">
            If money was deducted from your account, please wait for
            the payment status to be updated before trying again.
        </p>

    </div>

</div>

</body>
</html>