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

    String userId = (String) session.getAttribute("user_id");

    if (userId == null || userId.trim().isEmpty()) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message=Session Expired! Please Login Again!!"
        );

        return;
    }

    String contextPath = request.getContextPath();


    /* =========================================================
       TRANSACTION VARIABLES
       ========================================================= */

    int totalTransactions = 0;
    int successfulTransactions = 0;
    int failedTransactions = 0;

    double totalAmount = 0.0;


    /* =========================================================
       DATABASE VARIABLES
       ========================================================= */

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Transaction History | MYSHOP</title>


    <!-- =====================================================
         FAVICON
         ===================================================== -->

    <link rel="icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">

    <link rel="shortcut icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =====================================================
         GOOGLE FONT
         ===================================================== -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com">

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">


    <!-- =====================================================
         EXISTING CSS
         ===================================================== -->

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/css/transHist.css"/>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="transaction-page">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <div class="page-header">

        <div class="page-title-wrapper">

            <div class="page-icon">

                <i class="fa-solid fa-receipt"></i>

            </div>


            <div>

                <h1 class="page-title">
                    Transaction History
                </h1>

                <p class="page-subtitle">
                    View your PayU payment transactions
                </p>

            </div>

        </div>


        <a href="<%=request.getContextPath()%>/user/userProfile.jsp"
           class="back-btn">

            <i class="fa-solid fa-arrow-left"></i>

            Back to Profile

        </a>

    </div>


    <!-- =====================================================
         DATABASE PROCESSING
         ===================================================== -->

<%

    try {

        con = dbUtil.provideConnection();


        /* =====================================================
           STATISTICS FROM PAYMENTS_PAYU
           ===================================================== */

        String statsSql =

            "SELECT "

            + "COUNT(*) AS total, "

            + "SUM(CASE "
            + "WHEN UPPER(ISNULL(status,'')) = 'SUCCESS' "
            + "THEN 1 ELSE 0 END) AS success_count, "

            + "SUM(CASE "
            + "WHEN UPPER(ISNULL(status,'')) = 'FAILED' "
            + "THEN 1 ELSE 0 END) AS failed_count, "

            + "COALESCE(SUM("
            + "CASE "
            + "WHEN UPPER(ISNULL(status,'')) = 'SUCCESS' "
            + "THEN ISNULL(amount,0) "
            + "ELSE 0 "
            + "END"
            + "),0) AS total_amount "

            + "FROM dbo.PAYMENTS_PAYU "

            + "WHERE user_id = ?";


        ps = con.prepareStatement(statsSql);

        ps.setString(1, userId);

        rs = ps.executeQuery();


        if (rs.next()) {

            totalTransactions =
                rs.getInt("total");


            successfulTransactions =
                rs.getInt("success_count");


            failedTransactions =
                rs.getInt("failed_count");


            totalAmount =
                rs.getDouble("total_amount");
        }


        rs.close();
        rs = null;

        ps.close();
        ps = null;

%>


    <!-- =====================================================
         STATISTICS
         ===================================================== -->

    <div class="stats-grid">


        <!-- TOTAL -->

        <div class="stat-card">

            <div class="stat-icon">

                <i class="fa-solid fa-money-check-dollar"></i>

            </div>


            <div>

                <div class="stat-label">
                    Total Transactions
                </div>

                <div class="stat-value">
                    <%= totalTransactions %>
                </div>

            </div>

        </div>


        <!-- SUCCESS -->

        <div class="stat-card success">

            <div class="stat-icon">

                <i class="fa-solid fa-circle-check"></i>

            </div>


            <div>

                <div class="stat-label">
                    Successful
                </div>

                <div class="stat-value">
                    <%= successfulTransactions %>
                </div>

            </div>

        </div>


        <!-- FAILED -->

        <div class="stat-card failed">

            <div class="stat-icon">

                <i class="fa-solid fa-circle-xmark"></i>

            </div>


            <div>

                <div class="stat-label">
                    Failed
                </div>

                <div class="stat-value">
                    <%= failedTransactions %>
                </div>

            </div>

        </div>


        <!-- AMOUNT -->

        <div class="stat-card amount">

            <div class="stat-icon">

                <i class="fa-solid fa-indian-rupee-sign"></i>

            </div>


            <div>

                <div class="stat-label">
                    Successful Amount
                </div>

                <div class="stat-value">

                    &#8377;<%= String.format(
                        "%.2f",
                        totalAmount
                    ) %>

                </div>

            </div>

        </div>


    </div>


    <!-- =====================================================
         TRANSACTION CARD
         ===================================================== -->

    <div class="transaction-card">


        <!-- =================================================
             TABLE HEADER
             ================================================= -->

        <div class="table-header">

            <h3 class="table-heading">

                <i class="fa-solid fa-clock-rotate-left me-2"></i>

                Payment Transactions

            </h3>


            <div class="search-wrapper">

                <i class="fa-solid fa-search"></i>

                <input
                    type="text"
                    id="transactionSearch"
                    class="search-input"
                    placeholder="Search transaction..."
                    onkeyup="searchTransactions()">

            </div>

        </div>


<%

        /* =====================================================
           PAYMENTS_PAYU TRANSACTION QUERY
           ===================================================== */

        String transactionSql =

            "SELECT "

            + "p.payment_id1 AS payment_id, "

            + "p.order_id AS order_id, "

            + "p.user_id AS user_id, "

            + "p.txn_id AS payu_txn_id, "

            + "p.amount AS payu_amount, "

            + "p.status AS payu_status, "

            + "p.payu_hash AS payu_hash "

            + "FROM dbo.PAYMENTS_PAYU p "

            + "WHERE p.user_id = ? "

            + "ORDER BY p.payment_id1 DESC";


        ps = con.prepareStatement(transactionSql);

        ps.setString(1, userId);

        rs = ps.executeQuery();


        boolean hasTransactions = false;

%>


        <!-- =================================================
             DESKTOP TABLE
             ================================================= -->

        <div class="table-responsive desktop-transactions">

            <table class="transaction-table">

                <thead>

                    <tr>

                        <th>Order ID</th>

                        <th>Transaction ID</th>

                        <th>Payment ID</th>

                        <th>Payment Type</th>

                        <th>Amount</th>

                        <th>Status</th>

                        <th>Date</th>

                        <th>Action</th>

                    </tr>

                </thead>


                <tbody id="transactionTableBody">

<%

                    while (rs.next()) {

                        hasTransactions = true;


                        /* =================================================
                           FETCH PAYU DATA
                           ================================================= */

                        String orderId =
                            rs.getString("order_id");


                        String payuTxnId =
                            rs.getString("payu_txn_id");


                        String paymentId =
                            rs.getString("payment_id");


                        String payuStatus =
                            rs.getString("payu_status");


                        String payuHash =
                            rs.getString("payu_hash");


                        double amount =
                            rs.getDouble("payu_amount");


                        if (rs.wasNull()) {

                            amount = 0.0;

                        }


                        /* =================================================
                           STATUS
                           ================================================= */

                        String paymentStatus =
                            payuStatus;


                        if (paymentStatus == null
                                || paymentStatus.trim().isEmpty()) {

                            paymentStatus = "PENDING";
                        }


                        /* =================================================
                           STATUS STYLE
                           ================================================= */

                        String statusClass =
                            "pending";


                        String statusIcon =
                            "fa-clock";


                        if ("SUCCESS".equalsIgnoreCase(
                                paymentStatus)) {

                            statusClass =
                                "success";

                            statusIcon =
                                "fa-circle-check";

                        } else if ("FAILED".equalsIgnoreCase(
                                paymentStatus)) {

                            statusClass =
                                "failed";

                            statusIcon =
                                "fa-circle-xmark";
                        }


                        /* =================================================
                           PAYMENT TYPE

                           PAYMENTS_PAYU schema provided does not contain
                           a payment_type column, so do not invent one.
                           ================================================= */

                        String paymentType =
                            "PayU";


                        String paymentIcon =
                            "fa-credit-card";


                        /* =================================================
                           DATE

                           PAYMENTS_PAYU schema provided does not contain
                           a payment date/time column.
                           ================================================= */

                        String paymentDate =
                            "-";

%>


                    <tr class="transaction-row">


                        <!-- =================================================
                             ORDER ID
                             ================================================= -->

                        <td>

                            <a
                                href="<%=contextPath%>/user/orderDetails.jsp?userId=<%=userId%>&orderId=<%=orderId%>"
                                title="View Order"
                                class="order-id">

                                <span>

                                    <%= orderId == null
                                        ? "-"
                                        : orderId %>

                                </span>

                            </a>

                        </td>


                        <!-- =================================================
                             PAYU TRANSACTION ID
                             ================================================= -->

                        <td>

                            <span class="transaction-id">

                                <%= payuTxnId == null
                                    ? "-"
                                    : payuTxnId %>

                            </span>

                        </td>


                        <!-- =================================================
                             PAYMENT ID
                             ================================================= -->

                        <td>

                            <span class="payment-id">

                                <%= paymentId == null
                                    ? "-"
                                    : paymentId %>

                            </span>

                        </td>


                        <!-- =================================================
                             PAYMENT TYPE
                             ================================================= -->

                        <td>

                            <span class="payment-type">

                                <i class="fa-solid <%=paymentIcon%>"></i>

                                <%= paymentType %>

                            </span>

                        </td>


                        <!-- =================================================
                             AMOUNT
                             ================================================= -->

                        <td>

                            <span class="amount">

                                &#8377;<%= String.format(
                                    "%.2f",
                                    amount
                                ) %>

                            </span>

                        </td>


                        <!-- =================================================
                             STATUS
                             ================================================= -->

                        <td>

                            <span class="status <%=statusClass%>">

                                <i class="fa-solid <%=statusIcon%>"></i>

                                <%= paymentStatus %>

                            </span>


                            <% if (payuStatus != null
                                    && !payuStatus.trim().isEmpty()) { %>

                                <div class="payment-status-source">

                                    PayU:
                                    <%= payuStatus %>

                                </div>

                            <% } %>

                        </td>


                        <!-- =================================================
                             DATE
                             ================================================= -->

                        <td>

                            <%= paymentDate %>

                        </td>


                        <!-- =================================================
                             ACTION
                             ================================================= -->

                        <td>

                            <a
                                href="<%=contextPath%>/user/paymentReceipt.jsp?transactionId=<%=payuTxnId%>&userId=<%=userId%>&orderId=<%=orderId%>"
                                class="view-btn"
                                title="Payment Receipt">

                                <i class="fa-solid fa-eye"></i>

                            </a>

                        </td>


                    </tr>


<%

                    }

%>

                </tbody>

            </table>

        </div>


        <!-- =================================================
             MOBILE TRANSACTION CARDS
             ================================================= -->

        <div class="mobile-transactions"
             id="mobileTransactions">


<%

            /*
             * Execute PAYMENTS_PAYU query again for mobile view.
             */

            rs.close();
            rs = null;

            ps.close();
            ps = null;


            ps = con.prepareStatement(transactionSql);

            ps.setString(1, userId);

            rs = ps.executeQuery();


            while (rs.next()) {


                String orderId =
                    rs.getString("order_id");


                String payuTxnId =
                    rs.getString("payu_txn_id");


                String paymentId =
                    rs.getString("payment_id");


                double amount =
                    rs.getDouble("payu_amount");


                if (rs.wasNull()) {

                    amount = 0.0;
                }


                String payuStatus =
                    rs.getString("payu_status");


                String paymentStatus =
                    payuStatus;


                if (paymentStatus == null
                        || paymentStatus.trim().isEmpty()) {

                    paymentStatus =
                        "PENDING";
                }


                String statusClass =
                    "pending";


                String statusIcon =
                    "fa-clock";


                if ("SUCCESS".equalsIgnoreCase(
                        paymentStatus)) {

                    statusClass =
                        "success";

                    statusIcon =
                        "fa-circle-check";

                } else if ("FAILED".equalsIgnoreCase(
                        paymentStatus)) {

                    statusClass =
                        "failed";

                    statusIcon =
                        "fa-circle-xmark";
                }


                String paymentType =
                    "PayU";

%>


            <div class="mobile-transaction">


                <!-- =================================================
                     ORDER + STATUS
                     ================================================= -->

                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Order ID
                        </div>

                        <div class="mobile-value order-id">

                            <%= orderId == null
                                ? "-"
                                : orderId %>

                        </div>

                    </div>


                    <span class="status <%=statusClass%>">

                        <i class="fa-solid <%=statusIcon%>"></i>

                        <%=paymentStatus%>

                    </span>

                </div>


                <!-- =================================================
                     TRANSACTION ID + PAYMENT ID
                     ================================================= -->

                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Transaction ID
                        </div>

                        <div class="mobile-value payu-txn-id">

                            <%= payuTxnId == null
                                ? "-"
                                : payuTxnId %>

                        </div>

                    </div>


                    <div>

                        <div class="mobile-label">
                            Payment ID
                        </div>

                        <div class="mobile-value payment-id">

                            <%= paymentId == null
                                ? "-"
                                : paymentId %>

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     AMOUNT + PAYMENT TYPE
                     ================================================= -->

                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Amount
                        </div>

                        <div class="mobile-value amount">

                            &#8377;<%= String.format(
                                "%.2f",
                                amount
                            ) %>

                        </div>

                    </div>


                    <div>

                        <div class="mobile-label">
                            Payment Type
                        </div>

                        <div class="mobile-value">

                            <i class="fa-solid fa-credit-card"></i>

                            <%=paymentType%>

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     PAYU STATUS
                     ================================================= -->

                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            PayU Status
                        </div>

                        <div class="mobile-value">

                            <%= payuStatus == null
                                ? "-"
                                : payuStatus %>

                        </div>

                    </div>


                    <div>

                        <div class="mobile-label">
                            Payment ID
                        </div>

                        <div class="mobile-value payment-id">

                            <%= paymentId == null
                                ? "-"
                                : paymentId %>

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     DATE
                     ================================================= -->

                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Date
                        </div>

                        <div class="mobile-value">

                            -

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     ACTION
                     ================================================= -->

                <div class="text-end">

                    <a
                        href="<%=contextPath%>/user/orderDetails.jsp?userId=<%=userId%>&orderId=<%=orderId%>"
                        class="view-btn"
                        title="View Order">

                        <i class="fa-solid fa-eye"></i>

                    </a>

                </div>


            </div>


<%

            }

%>


        </div>


<%

        /* =====================================================
           EMPTY STATE
           ===================================================== */

        if (!hasTransactions) {

%>


        <div class="empty-state">

            <div class="empty-icon">

                <i class="fa-solid fa-receipt"></i>

            </div>


            <h4>
                No Transactions Found
            </h4>


            <p>
                Your PayU payment transactions will appear here.
            </p>

        </div>


<%

        }

%>


    </div>


<%

    } catch (Exception e) {

        e.printStackTrace();

%>


    <!-- =====================================================
         DATABASE ERROR
         ===================================================== -->

    <div class="alert alert-danger mt-4">

        <strong>
            Unable to load transaction history.
        </strong>

        <br>

        <small>
            Please check the PAYMENTS_PAYU table and database
            connection.
        </small>

        <!-- Development only -->
        <!--
        <br>
        <small>
            <%= e.getMessage() %>
        </small>
        -->

    </div>


<%

    } finally {


        try {

            if (rs != null)
                rs.close();

        } catch (Exception ignored) {}


        try {

            if (ps != null)
                ps.close();

        } catch (Exception ignored) {}


        try {

            if (con != null)
                con.close();

        } catch (Exception ignored) {}

    }

%>


</div>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"/>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


    /* =====================================================
       THEME
       ===================================================== */

    function applyTheme() {

        const theme =
            localStorage.getItem("myshop-theme");


        if (theme === "dark") {

            document.body.classList.add("dark-mode");

        } else {

            document.body.classList.remove("dark-mode");

        }
    }


    applyTheme();


    /* =====================================================
       SEARCH TRANSACTIONS
       ===================================================== */

    function searchTransactions() {

        const input =
            document.getElementById(
                "transactionSearch"
            );


        if (!input) {

            return;
        }


        const filter =
            input.value.toLowerCase();


        /* =================================================
           DESKTOP
           ================================================= */

        const rows =
            document.querySelectorAll(
                ".transaction-row"
            );


        rows.forEach(function(row) {

            const text =
                row.innerText.toLowerCase();


            if (text.includes(filter)) {

                row.style.display = "";

            } else {

                row.style.display = "none";

            }

        });


        /* =================================================
           MOBILE
           ================================================= */

        const cards =
            document.querySelectorAll(
                ".mobile-transaction"
            );


        cards.forEach(function(card) {

            const text =
                card.innerText.toLowerCase();


            if (text.includes(filter)) {

                card.style.display = "";

            } else {

                card.style.display = "none";

            }

        });

    }


</script>


</body>

</html>