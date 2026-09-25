<%@page import="com.myshop.utility.dbUtil"%>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    /* =========================================================
       SESSION
       ========================================================= */

    String userId =
        (String) session.getAttribute("user_id");

    if (userId == null) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message=Session Expired! Please Login Again!!"
        );

        return;
    }


    /* =========================================================
       TRANSACTION ID
       ========================================================= */

    String transactionId =
        request.getParameter("transactionId");

    if (transactionId == null ||
        transactionId.trim().isEmpty()) {

        response.sendRedirect(
            "transactionHistory.jsp"
        );

        return;
    }


    /* =========================================================
       PAYMENT DATA
       ========================================================= */

    String orderId = "-";
    String paymentStatus = "PENDING";
    String paymentType = "-";
    String customerId = userId;

    String customerName = "-";
    String customerEmail = "-";
    String customerMobile = "-";
    String customerAdd = "-";
    String custPincode = "-";
    String shippingAddress = "-";
    String billingAddress = "-";

    double paymentAmount = 0;

    Timestamp paymentDate = null;


    /* =========================================================
       DATABASE CONNECTION
       ========================================================= */

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        con = dbUtil.provideConnection();


        /* =====================================================
           GET PAYMENT DETAILS
           ===================================================== */

        /*
         * PAYMENTS_PAYU is now the source of payment/transaction data.
         * Current table columns:
         * payment_id1, order_id, user_id, txn_id, amount, status, payu_hash
         */
        String paymentSql =
            "SELECT "
            + "p.payment_id1, "
            + "p.order_id, "
            + "p.user_id, "
            + "p.txn_id, "
            + "p.amount, "
            + "p.status, "
            + "p.payu_hash "
            + "FROM dbo.PAYMENTS_PAYU p "
            + "WHERE p.txn_id = ? "
            + "AND p.user_id = ?";


        ps = con.prepareStatement(paymentSql);

        ps.setString(1, transactionId);
        ps.setString(2, userId);

        rs = ps.executeQuery();


        if (rs.next()) {

            orderId =
                rs.getString("order_id");

            paymentAmount =
                rs.getDouble("amount");

            paymentStatus =
                rs.getString("status");

            /* PAYMENTS_PAYU does not currently contain payment_type. */
            paymentType = "PayU";

            /* PAYMENTS_PAYU does not currently contain payment_time. */
            paymentDate = null;

            customerId =
                rs.getString("user_id");

        }


        rs.close();
        ps.close();


        /* =====================================================
           GET CUSTOMER DETAILS
           ===================================================== */

        String customerSql =
            "SELECT "
            + "name, email, mobile, address, pincode "
            + "FROM [USER] "
            + "WHERE user_id = ?";


        ps = con.prepareStatement(customerSql);

        ps.setString(1, customerId);

        rs = ps.executeQuery();


        if (rs.next()) {

            customerName = rs.getString("name");
            customerEmail = rs.getString("email");
            customerMobile = rs.getString("mobile");
            customerAdd = rs.getString("address");
            custPincode = rs.getString("pincode"); 
            billingAddress = (customerAdd == null ? "" : customerAdd)
                + (custPincode == null || custPincode.trim().isEmpty() ? "" : " - " + custPincode);
            shippingAddress = (customerAdd == null ? "" : customerAdd)
                + (custPincode == null || custPincode.trim().isEmpty() ? "" : " - " + custPincode);
        }


        rs.close();
        ps.close();


        /* =====================================================
           STATUS UI
           ===================================================== */

        String statusClass = "pending";

        String statusIcon =
            "fa-clock";

        String statusTitle =
            "Payment Pending";

        String statusMessage =
            "Your payment is currently pending.";


        if ("SUCCESS".equalsIgnoreCase(
                paymentStatus)) {

            statusClass = "success";

            statusIcon =
                "fa-circle-check";

            statusTitle =
                "Payment Successful";

            statusMessage =
                "Your payment has been completed successfully.";

        } else if ("FAILED".equalsIgnoreCase(
                    paymentStatus)) {

            statusClass = "failed";

            statusIcon =
                "fa-circle-xmark";

            statusTitle =
                "Payment Failed";

            statusMessage =
                "Unfortunately, this payment was unsuccessful.";

        }


        /* =====================================================
           DATE
           ===================================================== */

        String formattedDate = "-";

        if (paymentDate != null) {

            formattedDate =
                new SimpleDateFormat(
                    "dd MMM yyyy, hh:mm a"
                ).format(paymentDate);

        }


        /* =====================================================
           RECEIPT NUMBER
           ===================================================== */

        String receiptNumber =
            "RCP-"
            + orderId.replaceAll("[^a-zA-Z0-9]", "")
            + "-"
            + transactionId.substring(
                Math.max(
                    0,
                    transactionId.length() - 6
                )
            );

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>
        Payment Receipt | MYSHOP
    </title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =====================================================
         QR CODE
         ===================================================== -->

    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js">
    </script>


    <!-- =====================================================
         GOOGLE FONT
         ===================================================== -->

    <link
        rel="preconnect"
        href="https://fonts.googleapis.com">

    <link
        rel="preconnect"
        href="https://fonts.gstatic.com">

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">


    <style>

        /* =====================================================
           THEME
           ===================================================== */

        :root {

            --bg: #f1f5f9;

            --card: #ffffff;

            --text: #172033;

            --muted: #64748b;

            --border: #e2e8f0;

            --primary: #2563eb;

            --primary-light: #eff6ff;

            --success: #16a34a;

            --success-bg: #f0fdf4;

            --danger: #dc2626;

            --danger-bg: #fef2f2;

            --warning: #d97706;

            --warning-bg: #fffbeb;

            --header:
                linear-gradient(
                    135deg,
                    #172b43,
                    #213d5c
                );

            --shadow:
                0 15px 45px
                rgba(15, 23, 42, 0.10);
        }


        body.dark-mode {

            --bg: #070b14;

            --card: #111827;

            --text: #f8fafc;

            --muted: #94a3b8;

            --border:
                rgba(255,255,255,0.08);

            --primary: #60a5fa;

            --primary-light:
                rgba(96,165,250,0.12);

            --success: #4ade80;

            --success-bg:
                rgba(34,197,94,0.10);

            --danger: #f87171;

            --danger-bg:
                rgba(239,68,68,0.10);

            --warning: #fbbf24;

            --warning-bg:
                rgba(245,158,11,0.10);

            --header:
                linear-gradient(
                    135deg,
                    #0b1627,
                    #142b45
                );

            --shadow:
                0 15px 45px
                rgba(0,0,0,0.30);
        }


        /* =====================================================
           BODY
           ===================================================== */

        * {
            box-sizing: border-box;
        }


        body {

            margin: 0;

            background: var(--bg);

            color: var(--text);

            font-family: "Inter", sans-serif;

        }


        /* =====================================================
           RECEIPT HEADER
           ===================================================== */

        .receipt-header {

            background: var(--header);

            color: white;

            padding: 25px 30px;

        }


        .receipt-header-inner {

            max-width: 1100px;

            margin: auto;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

        }


        .brand {

            display: flex;

            align-items: center;

            gap: 14px;

        }


        .brand-logo {

            width: 55px;

            height: 55px;

            border-radius: 15px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #60a5fa
                );

            font-size: 25px;

            box-shadow:
                0 8px 25px
                rgba(0,0,0,0.20);

        }


        .brand-name {

            font-size: 27px;

            font-weight: 800;

            margin: 0;

            letter-spacing: -1px;

        }


        .brand-name span {

            color: #60a5fa;

        }


        .brand-tagline {

            margin: 2px 0 0;

            color: #bfdbfe;

            font-size: 12px;

        }


        .receipt-title {

            text-align: right;

        }


        .receipt-title h1 {

            margin: 0;

            font-size: 27px;

            font-weight: 800;

        }


        .receipt-title p {

            margin: 4px 0 0;

            color: #bfdbfe;

            font-size: 13px;

        }


        /* =====================================================
           PAGE
           ===================================================== */

        .receipt-page {

            max-width: 1100px;

            margin: 35px auto 60px;

            padding: 0 18px;

        }


        /* =====================================================
           RECEIPT CARD
           ===================================================== */

        .receipt-card {

            background: var(--card);

            border-radius: 22px;

            box-shadow: var(--shadow);

            overflow: hidden;

            border: 1px solid var(--border);

        }


        .receipt-body {

            padding: 35px;

        }


        /* =====================================================
           STATUS
           ===================================================== */

        .status-section {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 25px;

            padding-bottom: 25px;

            border-bottom: 1px solid var(--border);

        }


        .status-left {

            display: flex;

            align-items: center;

            gap: 18px;

        }


        .status-icon {

            width: 58px;

            height: 58px;

            min-width: 58px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 25px;

        }


        .status-icon.success {

            color: var(--success);

            background: var(--success-bg);

        }


        .status-icon.failed {

            color: var(--danger);

            background: var(--danger-bg);

        }


        .status-icon.pending {

            color: var(--warning);

            background: var(--warning-bg);

        }


        .status-title {

            margin: 0;

            font-size: 21px;

            font-weight: 800;

        }


        .status-message {

            margin: 4px 0 0;

            color: var(--muted);

            font-size: 13px;

        }


        .receipt-number {

            text-align: right;

        }


        .receipt-number span {

            display: block;

            color: var(--muted);

            font-size: 11px;

        }


        .receipt-number strong {

            display: block;

            margin-top: 3px;

            font-size: 15px;

            font-family: monospace;

        }


        .generated-date {

            color: var(--muted);

            font-size: 11px;

            margin-top: 5px;

        }


        /* =====================================================
           DETAILS + QR
           ===================================================== */

        .details-section {

            display: grid;

            grid-template-columns:
                1fr 300px;

            gap: 35px;

            padding: 28px 0;

        }


        .details-list {

            display: flex;

            flex-direction: column;

            gap: 17px;

        }


        .detail-row {

            display: grid;

            grid-template-columns:
                180px 20px 1fr;

            align-items: center;

            gap: 8px;

        }


        .detail-label {

            display: flex;

            align-items: center;

            gap: 10px;

            color: var(--muted);

            font-size: 13px;

        }


        .detail-label i {

            width: 20px;

            color: var(--primary);

            text-align: center;

        }


        .detail-colon {

            color: var(--muted);

        }


        .detail-value {

            color: var(--text);

            font-size: 13px;

            font-weight: 700;

            word-break: break-word;

        }


        /* =====================================================
           QR
           ===================================================== */

        .qr-section {

            border-left: 1px dashed var(--border);

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            padding-left: 25px;

        }


        .qr-section h4 {

            margin: 0 0 4px;

            font-size: 16px;

            font-weight: 800;

        }


        .qr-subtitle {

            color: var(--muted);

            font-size: 12px;

            margin-bottom: 13px;

        }


        #paymentQR {

            width: 190px;

            height: 190px;

            padding: 10px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: white;

            border: 1px solid #dbe3ec;

            border-radius: 12px;

        }


        #paymentQR img {

            max-width: 100%;

            max-height: 100%;

        }


        .qr-transaction {

            width: 100%;

            margin-top: 12px;

            padding: 10px;

            text-align: center;

            border-radius: 9px;

            background: var(--primary-light);

        }


        .qr-transaction small {

            display: block;

            color: var(--muted);

            font-size: 10px;

        }


        .qr-transaction strong {

            display: block;

            margin-top: 3px;

            color: var(--primary);

            font-family: monospace;

            font-size: 11px;

            word-break: break-all;

        }


        /* =====================================================
           CUSTOMER
           ===================================================== */

        .customer-section {

            border-top: 1px solid var(--border);

            padding-top: 25px;

            margin-bottom: 25px;

        }


        .section-heading {

            margin: 0 0 18px;

            font-size: 16px;

            font-weight: 800;

        }


        .customer-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 15px;

        }


        .customer-box {

            padding: 15px;

            border-radius: 13px;

            background: var(--bg);

            border: 1px solid var(--border);

        }


        .customer-box-label {

            color: var(--muted);

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: .4px;

            margin-bottom: 5px;

        }


        .customer-box-value {

            color: var(--text);

            font-size: 13px;

            font-weight: 700;

            word-break: break-word;

        }


        /* =====================================================
           ITEMS
           ===================================================== */

        .items-section {

            border-top: 1px solid var(--border);

            padding-top: 25px;

        }


        .items-table-wrapper {

            overflow-x: auto;

            border: 1px solid var(--border);

            border-radius: 14px;

        }


        .items-table {

            width: 100%;

            border-collapse: collapse;

            min-width: 650px;

        }


        .items-table thead {

            background: var(--bg);

        }


        .items-table th {

            padding: 13px 15px;

            color: var(--muted);

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: .4px;

            text-align: left;

        }


        .items-table td {

            padding: 14px 15px;

            border-top: 1px solid var(--border);

            color: var(--text);

            font-size: 12px;

        }


        .product-name {

            font-weight: 700;

        }


        .item-price {

            font-weight: 600;

        }


        .total-row td {

            background: var(--primary-light);

            color: var(--primary);

            font-size: 14px;

            font-weight: 800;

        }


        .total-row td:last-child {

            text-align: right;

            font-size: 16px;

        }


        /* =====================================================
           THANK YOU
           ===================================================== */

        .thank-you {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 25px;

            margin-top: 30px;

            padding-top: 25px;

            border-top: 1px solid var(--border);

        }


        .thank-text h3 {

            margin: 0;

            color: var(--primary);

            font-size: 28px;

            font-style: italic;

            font-weight: 700;

        }


        .thank-text p {

            margin: 7px 0 0;

            color: var(--muted);

            font-size: 12px;

            line-height: 1.6;

        }


        .trust-badge {

            display: flex;

            align-items: center;

            gap: 12px;

        }


        .trust-icon {

            width: 60px;

            height: 60px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            border: 2px solid var(--primary);

            color: var(--primary);

            font-size: 22px;

        }


        .trust-text strong {

            display: block;

            color: var(--text);

            font-size: 13px;

        }


        .trust-text span {

            color: var(--muted);

            font-size: 11px;

        }


        /* =====================================================
           ACTIONS
           ===================================================== */

        .receipt-actions {

            display: flex;

            justify-content: center;

            gap: 15px;

            margin-top: 25px;

        }


        .receipt-btn {

            min-width: 150px;

            padding: 12px 18px;

            border-radius: 11px;

            border: 1px solid var(--border);

            background: var(--card);

            color: var(--text);

            text-decoration: none;

            font-size: 13px;

            font-weight: 600;

            cursor: pointer;

            transition: .25s;

        }


        .receipt-btn:hover {

            transform: translateY(-2px);

            border-color: var(--primary);

            color: var(--primary);

        }


        .receipt-btn.primary {

            background: var(--primary);

            border-color: var(--primary);

            color: white;

        }


        .receipt-btn.primary:hover {

            background: #1d4ed8;

            color: white;

        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .receipt-footer {

            background: #172b43;

            color: #cbd5e1;

            padding: 20px;

        }


        .receipt-footer-inner {

            max-width: 1100px;

            margin: auto;

            display: flex;

            align-items: center;

            justify-content: space-between;

        }


        .receipt-footer p {

            margin: 0;

            font-size: 11px;

        }


        .receipt-social {

            display: flex;

            gap: 15px;

        }


        .receipt-social a {

            color: white;

            text-decoration: none;

            font-size: 14px;

        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 850px) {

            .details-section {

                grid-template-columns: 1fr;

            }


            .qr-section {

                border-left: none;

                border-top: 1px dashed var(--border);

                padding:
                    25px 0 0;

            }


            .customer-grid {

                grid-template-columns: 1fr;

            }

        }


        @media (max-width: 650px) {

            .receipt-header {

                padding: 20px 15px;

            }


            .receipt-header-inner {

                align-items: flex-start;

                flex-direction: column;

            }


            .receipt-title {

                text-align: left;

            }


            .receipt-title h1 {

                font-size: 22px;

            }


            .brand-name {

                font-size: 23px;

            }


            .receipt-page {

                margin-top: 20px;

                padding: 0 10px;

            }


            .receipt-body {

                padding: 20px 15px;

            }


            .status-section {

                align-items: flex-start;

                flex-direction: column;

            }


            .receipt-number {

                text-align: left;

            }


            .detail-row {

                grid-template-columns:
                    135px 12px 1fr;

                gap: 4px;

            }


            .detail-label {

                font-size: 11px;

            }


            .detail-value {

                font-size: 11px;

            }


            .thank-you {

                align-items: flex-start;

                flex-direction: column;

            }


            .receipt-actions {

                flex-direction: column;

            }


            .receipt-btn {

                width: 100%;

            }


            .receipt-footer-inner {

                flex-direction: column;

                gap: 12px;

                text-align: center;

            }

        }


        /* =====================================================
           PRINT
           ===================================================== */

        @media print {

            @page {

                size: A4;

                margin: 10mm;

            }


            body {

                background: white !important;

            }


            .receipt-header {

                print-color-adjust: exact;

                -webkit-print-color-adjust: exact;

            }


            .receipt-card {

                box-shadow: none;

                border: 1px solid #ddd;

            }


            .receipt-actions {

                display: none !important;

            }


            .receipt-footer {

                display: none !important;

            }


            .receipt-page {

                margin: 10px auto;

                max-width: 100%;

            }


            .receipt-body {

                padding: 25px;

            }

        }
        
        /* =====================================================
   ADDRESS SECTION
   ===================================================== */

.address-section {

    border-top: 1px solid var(--border);

    padding-top: 25px;

    margin-top: 5px;

}


.address-grid {

    display: grid;

    grid-template-columns: 1fr 1fr;

    gap: 20px;

}


.address-card {

    position: relative;

    padding: 20px;

    border-radius: 15px;

    background: var(--bg);

    border: 1px solid var(--border);

    transition: 0.25s ease;

}


.address-card:hover {

    transform: translateY(-2px);

    border-color: var(--primary);

}


.address-card-header {

    display: flex;

    align-items: center;

    gap: 10px;

    margin-bottom: 14px;

}


.address-card-icon {

    width: 38px;

    height: 38px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 10px;

    background: var(--primary-light);

    color: var(--primary);

}


.address-card-title {

    margin: 0;

    color: var(--text);

    font-size: 14px;

    font-weight: 800;

}


.address-card-subtitle {

    margin: 2px 0 0;

    color: var(--muted);

    font-size: 10px;

}


.address-text {

    color: var(--text);

    font-size: 12px;

    line-height: 1.7;

    min-height: 45px;

    word-break: break-word;

}


.pincode-row {

    display: flex;

    align-items: center;

    gap: 7px;

    margin-top: 12px;

    padding-top: 10px;

    border-top: 1px dashed var(--border);

    color: var(--muted);

    font-size: 11px;

}


.pincode-row strong {

    color: var(--text);

}


/* =====================================================
   SIGNATURE
   ===================================================== */

.signature-section {

    display: flex;

    justify-content: flex-end;

    margin-top: 30px;

    padding-top: 25px;

    border-top: 1px solid var(--border);

}


.signature-box {

    width: 250px;

    text-align: center;

}


.signature-writing {

    height: 55px;

    display: flex;

    align-items: flex-end;

    justify-content: center;

    color: var(--primary);

    font-family: "Brush Script MT",
                 "Segoe Script",
                 cursive;

    font-size: 27px;

    font-style: italic;

    font-weight: 600;

}


.signature-line {

    width: 100%;

    border-bottom: 1px solid var(--text);

    margin-bottom: 8px;

}


.signature-authorized {

    color: var(--text);

    font-size: 12px;

    font-weight: 800;

}


.signature-company {

    margin-top: 3px;

    color: var(--primary);

    font-size: 12px;

    font-weight: 700;

}


.signature-note {

    margin-top: 5px;

    color: var(--muted);

    font-size: 9px;

}


/* =====================================================
   ADDRESS + SIGNATURE MOBILE
   ===================================================== */

@media (max-width: 700px) {

    .address-grid {

        grid-template-columns: 1fr;

        gap: 14px;

    }


    .signature-section {

        justify-content: center;

    }


    .signature-box {

        width: 220px;

    }

}


/* =====================================================
   PRINT
   ===================================================== */

@media print {

    .address-card {

        break-inside: avoid;

    }

    .signature-section {

        break-inside: avoid;

    }

}

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<header class="receipt-header">

    <div class="receipt-header-inner">


        <div class="brand">

            <div class="brand-logo">

                <i class="fa-solid fa-bag-shopping"></i>

            </div>


            <div>

                <h2 class="brand-name">

                    MY<span>SHOP</span>

                </h2>

                <p class="brand-tagline">

                    Shop More, Live Better

                </p>

            </div>

        </div>


        <div class="receipt-title">

            <h1>
                Payment Receipt
            </h1>

            <p>
                Thank you for shopping with us!
            </p>

        </div>

    </div>

</header>


<!-- =========================================================
     RECEIPT
     ========================================================= -->

<main class="receipt-page">


    <div class="receipt-card">


        <div class="receipt-body">


            <!-- =================================================
                 STATUS
                 ================================================= -->

            <div class="status-section">


                <div class="status-left">


                    <div class="status-icon <%= statusClass %>">

                        <i class="fa-solid <%= statusIcon %>"></i>

                    </div>


                    <div>

                        <h2 class="status-title">

                            <%= statusTitle %>

                        </h2>

                        <p class="status-message">

                            <%= statusMessage %>

                        </p>

                    </div>

                </div>


                <div class="receipt-number">

                    <span>
                        Receipt No:
                    </span>

                    <strong>
                        <%= receiptNumber %>
                    </strong>

                    <div class="generated-date">

                        Generated on:
                        <%= formattedDate %>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 PAYMENT DETAILS + QR
                 ================================================= -->

            <div class="details-section">


                <div class="details-list">


                    <div class="detail-row">

                        <div class="detail-label">

                            <i class="fa-solid fa-bag-shopping"></i>

                            Order ID

                        </div>

                        <div class="detail-colon">
                            :
                        </div>

                        <div class="detail-value">
                            <%= orderId %>
                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-label">

                            <i class="fa-solid fa-receipt"></i>

                            Transaction ID

                        </div>

                        <div class="detail-colon">
                            :
                        </div>

                        <div class="detail-value">
                            <%= transactionId %>
                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-label">

                            <i class="fa-solid fa-credit-card"></i>

                            Payment Method

                        </div>

                        <div class="detail-colon">
                            :
                        </div>

                        <div class="detail-value">
                            <%= paymentType %>
                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-label">

                            <i class="fa-solid fa-indian-rupee-sign"></i>

                            Amount Paid

                        </div>

                        <div class="detail-colon">
                            :
                        </div>

                        <div class="detail-value">

                            <% if(statusClass.equalsIgnoreCase("SUCCESS") ) {%>
                                        &#8377;<%= String.format("%.2f",paymentAmount) %>
                                    <%}else{%>
                                        &#8377; <%=String.format("%.2f",00.00)%>
                                    <%}%>

                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-label">

                            <i class="fa-solid fa-calendar-days"></i>

                            Payment Date

                        </div>

                        <div class="detail-colon">
                            :
                        </div>

                        <div class="detail-value">
                            <%= formattedDate %>
                        </div>

                    </div>


                </div>


                <!-- QR CODE -->

                <div class="qr-section">


                    <h4>
                        Scan QR Code
                    </h4>

                    <div class="qr-subtitle">
                        Verify this payment
                    </div>


                    <div id="paymentQR"></div>


                    <div class="qr-transaction">

                        <small>
                            Transaction ID
                        </small>

                        <strong>
                            <%= transactionId %>
                        </strong>

                    </div>


                </div>

            </div>


            <!-- =================================================
                 CUSTOMER
                 ================================================= -->

            <div class="customer-section">

                <h3 class="section-heading">

                    <i class="fa-solid fa-user me-2"></i>

                    Customer Details

                </h3>


                <div class="customer-grid">


                    <div class="customer-box">

                        <div class="customer-box-label">
                            Customer Name
                        </div>

                        <div class="customer-box-value">
                            <%= customerName %>
                        </div>

                    </div>


                    <div class="customer-box">

                        <div class="customer-box-label">
                            Email
                        </div>

                        <div class="customer-box-value">
                            <%= customerEmail %>
                        </div>

                    </div>


                    <div class="customer-box">

                        <div class="customer-box-label">
                            Mobile
                        </div>

                        <div class="customer-box-value">
                            <%= customerMobile %>
                        </div>

                    </div>


                </div>

            </div>

           <!-- =========================================================
     SHIPPING & BILLING ADDRESS
     ========================================================= -->

<div class="address-section">

    <h3 class="section-heading">

        <i class="fa-solid fa-location-dot me-2"></i>

        Address Details

    </h3>


    <div class="address-grid">


        <!-- =================================================
             SHIPPING ADDRESS
             ================================================= -->

        <div class="address-card">

            <div class="address-card-header">

                <div class="address-card-icon">

                    <i class="fa-solid fa-truck-fast"></i>

                </div>

                <div>

                    <h4 class="address-card-title">
                        Shipping Address
                    </h4>

                    <p class="address-card-subtitle">
                        Delivery destination
                    </p>

                </div>

            </div>


            <div class="address-text">

                <strong>
                    <%= customerName %>
                </strong>

                <br>

                <%= shippingAddress == null ||
                    shippingAddress.trim().isEmpty()
                    ? "-"
                    : shippingAddress %>

            </div>


            <div class="pincode-row">

                <i class="fa-solid fa-location-dot"></i>

                <span>
                    Pincode:
                </span>

                <strong>
                    <%= custPincode == null ||
                        custPincode.trim().isEmpty()
                        ? "-"
                        : custPincode %>
                </strong>

            </div>

        </div>


        <!-- =================================================
             BILLING ADDRESS
             ================================================= -->

        <div class="address-card">

            <div class="address-card-header">

                <div class="address-card-icon">

                    <i class="fa-solid fa-file-invoice"></i>

                </div>

                <div>

                    <h4 class="address-card-title">
                        Billing Address
                    </h4>

                    <p class="address-card-subtitle">
                        Payment billing information
                    </p>

                </div>

            </div>


            <div class="address-text">

                <strong>
                    <%= customerName %>
                </strong>

                <br>

                <%= billingAddress == null ||
                    billingAddress.trim().isEmpty()
                    ? "-"
                    : billingAddress %>

            </div>


            <div class="pincode-row">

                <i class="fa-solid fa-location-dot"></i>

                <span>
                    Pincode:
                </span>

                <strong>
                    <%= custPincode == null ||
                        custPincode.trim().isEmpty()
                        ? "-"
                        : custPincode %>
                </strong>

            </div>

        </div>


    </div>

</div>

            <!-- =================================================
                 ITEMS
                 ================================================= -->

            <div class="items-section">


                <h3 class="section-heading">

                    <i class="fa-solid fa-box-open me-2"></i>

                    Order Details

                </h3>


                <div class="items-table-wrapper">

                    <table class="items-table">


                        <thead>

                            <tr>

                                <th>
                                    #
                                </th>

                                <th>
                                    Item Name
                                </th>

                                <th>
                                    Qty
                                </th>

                                <th>
                                    Price
                                </th>

                                <th>
                                    Total
                                </th>

                            </tr>

                        </thead>


                        <tbody>


<%

    /* =========================================================
       GET ORDER ITEMS
       ========================================================= */

    /*
     * Order items are read from ORDER_ITEMS.
     * Expected columns:
     * ORDER_ITEMS(order_id, product_id, quantity)
     * PRODUCTS(product_id, pname, pprice)
     */
    String itemSql =
        "SELECT "
        + "oi.prodid, "
        + "oi.amount, "
        + "oi.quantity, "
        + "p.pname, "
        + "p.pprice "
        + "FROM dbo.ORDERS oi "
        + "JOIN dbo.PRODUCTS p "
        + "ON oi.prodId = p.pid "
        + "WHERE oi.orderId = ?";


    ps = con.prepareStatement(
        itemSql
    );

    ps.setString(1, orderId);

    rs = ps.executeQuery();


    int itemNumber = 1;

    double calculatedTotal = 0;


    while (rs.next()) {

        String productId =
            rs.getString("prodid");
        
        Double amount = rs.getDouble("amount");

        String productName =
            rs.getString("pname");

        int quantity =
            rs.getInt("quantity");

        double price =
            rs.getDouble("pprice");

        double itemTotal =
            quantity * price;

        calculatedTotal += itemTotal;

%>


                            <tr>

                                <td>
                                    <%= itemNumber++ %>
                                </td>

                                <td class="product-name">

                                    <%= productName %>

                                </td>

                                <td>
                                    <%= quantity %>
                                </td>

                                <td class="item-price">

                                    &#8377;<%= String.format(
                                        "%.2f",
                                        price
                                    ) %>

                                </td>

                                <td class="item-price">

                                    &#8377;<%= String.format(
                                        "%.2f",
                                        amount+"(-2%)"
                                    ) %>

                                </td>

                            </tr>


<%

    }


    rs.close();
    ps.close();

%>


                            <!-- TOTAL -->

                            <tr class="total-row">

                                <td colspan="4">

                                    Total Amount Paid

                                </td>

                                <td>
                                    <% if(statusClass.equalsIgnoreCase("SUCCESS") ) {%>
                                        &#8377;<%= String.format("%.2f",paymentAmount) %>
                                    <%}else{%>
                                        &#8377; <%=String.format("%.2f",00.00)%>
                                    <%}%>

                                </td>

                            </tr>


                        </tbody>

                    </table>

                </div>

            </div>


            <!-- =================================================
                 THANK YOU
                 ================================================= -->

            <div class="thank-you">


                <div class="thank-text">

                    <h3>
                        Thank You!
                    </h3>

                    <p>

                        We appreciate your purchase.<br>

                        Visit again at
                        <strong>MYSHOP</strong>.

                    </p>

                </div>


                <div class="trust-badge">

                    <div class="trust-icon">

                        <i class="fa-solid fa-shield-halved"></i>

                    </div>


                    <div class="trust-text">

                        <strong>
                            Safe. Secure. Reliable.
                        </strong>

                        <span>
                            Your Trust, Our Priority.
                        </span>

                    </div>

                </div>


            </div>


        </div>


    </div>


    <!-- =====================================================
         ACTION BUTTONS
         ===================================================== -->

    <div class="receipt-actions">


        <button
            type="button"
            class="receipt-btn"
            onclick="window.print()">

            <i class="fa-solid fa-print me-2"></i>

            Print Receipt

        </button>


        <button
            type="button"
            class="receipt-btn primary"
            onclick="downloadReceipt()">

            <i class="fa-solid fa-download me-2"></i>

            Download PDF

        </button>


        <a
            href="transHist.jsp"
            class="receipt-btn text-center">

            <i class="fa-solid fa-arrow-left me-2"></i>

            Back to Transactions

        </a>


    </div>


</main>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<footer class="receipt-footer">

    <div class="receipt-footer-inner">

        <p>

            © <span id="receiptYear"></span>
            MYSHOP. All rights reserved.

        </p>


        <div class="receipt-social">

            <a href="#">
                <i class="fa-brands fa-facebook-f"></i>
            </a>

            <a href="#">
                <i class="fa-brands fa-instagram"></i>
            </a>

            <a href="#">
                <i class="fa-brands fa-x-twitter"></i>
            </a>

            <a href="#">
                <i class="fa-brands fa-youtube"></i>
            </a>

        </div>

    </div>

</footer>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>

    /* =====================================================
       YEAR
       ===================================================== */

    document.getElementById(
        "receiptYear"
    ).innerText =
        new Date().getFullYear();


    /* =====================================================
       QR CODE
       ===================================================== */

    const qrData =
        "MYSHOP PAYMENT RECEIPT"
        + "\n"
        + "Order ID: <%= orderId %>"
        + "\n"
        + "Transaction ID: <%= transactionId %>"
        + "\n"
        + "Payment Type: <%= paymentType %>"
        + "\n"
        + "Amount: INR <%= String.format("%.2f", paymentAmount) %>"
        + "\n"
        + "Status: <%= paymentStatus %>"
        + "\n"
        + "Date: <%= formattedDate %>";


    new QRCode(
        document.getElementById(
            "paymentQR"
        ),
        {
            text: qrData,

            width: 170,

            height: 170,

            colorDark: "#111827",

            colorLight: "#ffffff",

            correctLevel:
                QRCode.CorrectLevel.H
        }
    );


    /* =====================================================
       DOWNLOAD PDF
       ===================================================== */

    function downloadReceipt() {

        /*
         * Browser print dialog supports
         * "Save as PDF".
         */

        window.print();

    }


    /* =====================================================
       THEME
       ===================================================== */

    function applyTheme() {

        const theme =
            localStorage.getItem(
                "myshop-theme"
            );

        if (theme === "dark") {

            document.body.classList.add(
                "dark-mode"
            );

        } else {

            document.body.classList.remove(
                "dark-mode"
            );

        }

    }


    applyTheme();

</script>


</body>

</html>


<%

    } catch (Exception e) {

%>

    <div style="
        max-width:700px;
        margin:50px auto;
        padding:25px;
        background:#fee2e2;
        color:#991b1b;
        border-radius:12px;
        font-family:Arial;
    ">

        <h3>
            Unable to Generate Receipt
        </h3>

        <p>
            Please check your transaction information
            and database configuration.
        </p>

        <!-- Development -->
        <small>
            <%= e.getMessage() %>
        </small>

    </div>

<%

    } finally {

        try {
            if (rs != null) rs.close();
        } catch (Exception ignored) {}

        try {
            if (ps != null) ps.close();
        } catch (Exception ignored) {}

        try {
            if (con != null) con.close();
        } catch (Exception ignored) {}

    }

%>