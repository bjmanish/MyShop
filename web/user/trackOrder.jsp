<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.myshop.utility.dbUtil" %>

<%
    /* =====================================================
       GET ORDER ID
    ===================================================== */

    String orderId = request.getParameter("orderId");

    if (orderId == null || orderId.trim().isEmpty()) {
        response.sendRedirect("user/orderDetails.jsp");
        return;
    }


    /* =====================================================
       DATABASE
    ===================================================== */

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;


    List<String> statusList =
        new ArrayList<>();

    Map<String, String> timeMap =
        new HashMap<>();


    try {

        con = dbUtil.provideConnection();


        /* =================================================
           GET STATUS HISTORY
        ================================================= */

        ps = con.prepareStatement(

            "SELECT status, " +
            "FORMAT(status_time,'dd-MM-yyyy HH:mm:ss') AS time " +
            "FROM ORDER_STATUS_HISTORY " +
            "WHERE orderid=? " +
            "ORDER BY status_time"

        );


        ps.setString(1, orderId);


        rs = ps.executeQuery();


        while (rs.next()) {

            String status =
                rs.getString("status");


            String time =
                rs.getString("time");


            if (status != null) {

                status =
                    status.trim().toUpperCase();

                statusList.add(status);

                timeMap.put(
                    status,
                    time
                );
            }
        }

    }
    catch(Exception e) {

        e.printStackTrace();

    }
    finally {

        try {
            if(rs != null) rs.close();
        }
        catch(Exception ignored) {}

        try {
            if(ps != null) ps.close();
        }
        catch(Exception ignored) {}

        try {
            if(con != null) con.close();
        }
        catch(Exception ignored) {}
    }


    /* =====================================================
       ORDER TRACKING STEPS
    ===================================================== */

    String[] steps = {

        "PLACED",
        "CONFIRMED",
        "SHIPPED",
        "OUT_FOR_DELIVERY",
        "DELIVERED"

    };


    /* =====================================================
       FIND CURRENT STATUS
    ===================================================== */

    String currentStatus =
        statusList.isEmpty()
        ? "PLACED"
        : statusList.get(
            statusList.size() - 1
        );


    boolean cancelled =
        "CANCELLED".equalsIgnoreCase(
            currentStatus
        );


    int currentIndex =
        Arrays.asList(steps)
              .indexOf(currentStatus);


    if(currentIndex < 0) {

        currentIndex = 0;

    }


    int progress =
        currentIndex * 25;


    if("DELIVERED".equalsIgnoreCase(
        currentStatus)) {

        progress = 100;

    }


    if(progress < 0) {
        progress = 0;
    }


    if(progress > 100) {
        progress = 100;
    }

%>


<!DOCTYPE html>

<html lang="en">


<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        Track Order - MyShop
    </title>


    <!-- Bootstrap -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">


    <style>


        /* =====================================================
           GLOBAL
        ===================================================== */

        * {
            box-sizing: border-box;
        }


        html,
        body {

            width: 100%;

            min-width: 320px;

            margin: 0;

            padding: 0;

            overflow-x: hidden;
        }


        body {

            min-height: 100vh;

            padding: 30px 15px 50px;

            font-family:
                -apple-system,
                BlinkMacSystemFont,
                "Segoe UI",
                Roboto,
                Arial,
                sans-serif;

            color: #172033;

            background:
                linear-gradient(
                    135deg,
                    #eef2ff 0%,
                    #f8fafc 45%,
                    #f1f5f9 100%
                );
        }


        /* =====================================================
           MAIN CONTAINER
        ===================================================== */

        .tracking-page {

            width: 100%;

            max-width: 1000px;

            margin: 0 auto;
        }


        /* =====================================================
           BACK BUTTON
        ===================================================== */

        .back-button {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-bottom: 15px;

            padding: 8px 14px;

            border-radius: 10px;

            color: #334155;

            background: #ffffff;

            border: 1px solid #e5e7eb;

            text-decoration: none;

            font-size: 12px;

            font-weight: 600;

            box-shadow:
                0 3px 12px
                rgba(15,23,42,.05);

            transition:
                .2s ease;
        }


        .back-button:hover {

            color: #4f46e5;

            transform: translateX(-2px);

            text-decoration: none;
        }


        /* =====================================================
           HEADER CARD
        ===================================================== */

        .tracking-header {

            position: relative;

            overflow: hidden;

            padding: 28px 30px;

            border-radius: 22px;

            color: #ffffff;

            background:
                linear-gradient(
                    135deg,
                    #111827,
                    #312e81,
                    #6d28d9
                );

            box-shadow:
                0 15px 40px
                rgba(49,46,129,.20);

            margin-bottom: 20px;
        }


        .tracking-header:after {

            content: "";

            position: absolute;

            width: 220px;

            height: 220px;

            right: -80px;

            top: -100px;

            border-radius: 50%;

            background:
                rgba(255,255,255,.08);
        }


        .tracking-header-content {

            position: relative;

            z-index: 2;
        }


        .tracking-header h1 {

            margin: 0;

            font-size: 27px;

            font-weight: 750;
        }


        .tracking-header p {

            margin: 8px 0 0;

            color:
                rgba(255,255,255,.72);

            font-size: 13px;
        }


        .order-id-box {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            margin-top: 18px;

            padding: 8px 13px;

            border-radius: 30px;

            background:
                rgba(255,255,255,.10);

            border:
                1px solid
                rgba(255,255,255,.15);

            font-size: 12px;
        }


        .order-id-box strong {

            color: #ffffff;

            letter-spacing: .3px;
        }


        /* =====================================================
           CURRENT STATUS CARD
        ===================================================== */

        .current-status {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;

            padding: 18px 22px;

            margin-bottom: 20px;

            background: #ffffff;

            border-radius: 16px;

            border:
                1px solid #e8ebf0;

            box-shadow:
                0 7px 25px
                rgba(15,23,42,.06);
        }


        .current-status-left {

            display: flex;

            align-items: center;

            gap: 13px;

            min-width: 0;
        }


        .status-icon {

            width: 45px;

            height: 45px;

            flex: 0 0 45px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 13px;

            font-size: 20px;

            color: #ffffff;

            background:
                linear-gradient(
                    135deg,
                    #4f46e5,
                    #7c3aed
                );
        }


        .status-text {

            min-width: 0;
        }


        .status-text small {

            display: block;

            margin-bottom: 3px;

            color: #94a3b8;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: .5px;
        }


        .status-text strong {

            display: block;

            color: #172033;

            font-size: 16px;

            overflow-wrap: anywhere;
        }


        .status-time {

            color: #64748b;

            font-size: 11px;

            text-align: right;
        }


        /* =====================================================
           MAIN TRACKING CARD
        ===================================================== */

        .tracking-card {

            background: #ffffff;

            border-radius: 20px;

            overflow: hidden;

            border:
                1px solid #e7eaf0;

            box-shadow:
                0 10px 35px
                rgba(15,23,42,.07);
        }


        .tracking-card-header {

            padding: 18px 25px;

            border-bottom:
                1px solid #eef0f4;
        }


        .tracking-card-header h3 {

            margin: 0;

            font-size: 15px;

            font-weight: 750;

            color: #1e293b;
        }


        .tracking-card-header p {

            margin: 4px 0 0;

            font-size: 11px;

            color: #94a3b8;
        }


        /* =====================================================
           PROGRESS AREA
        ===================================================== */

        .progress-area {

            padding: 45px 40px 35px;
        }


        .progress-track {

            position: relative;

            display: flex;

            justify-content: space-between;

            width: 100%;
        }


        /* Background line */

        .progress-track:before {

            content: "";

            position: absolute;

            left: 10%;

            right: 10%;

            top: 16px;

            height: 4px;

            border-radius: 10px;

            background: #e5e7eb;

            z-index: 0;
        }


        /* Completed line */

        .progress-fill {

            position: absolute;

            left: 10%;

            top: 16px;

            height: 4px;

            border-radius: 10px;

            background:
                linear-gradient(
                    90deg,
                    #10b981,
                    #22c55e
                );

            z-index: 1;

            transition:
                width .7s ease;
        }


        .step {

            position: relative;

            z-index: 2;

            flex: 1;

            text-align: center;

            min-width: 0;
        }


        .circle {

            width: 34px;

            height: 34px;

            margin: 0 auto;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            color: #94a3b8;

            background: #ffffff;

            border:
                2px solid #d1d5db;

            font-size: 11px;

            font-weight: 700;

            box-shadow:
                0 2px 7px
                rgba(15,23,42,.08);
        }


        .circle.active {

            color: #ffffff;

            background: #16a34a;

            border-color: #16a34a;
        }


        .step-label {

            display: block;

            margin-top: 10px;

            color: #94a3b8;

            font-size: 9px;

            font-weight: 700;

            line-height: 1.3;

            text-transform: uppercase;
        }


        .step-label.active-label {

            color: #334155;
        }


        /* =====================================================
           TRUCK
        ===================================================== */

        .moving-truck {

            position: absolute;

            z-index: 5;

            top: -11px;

            color: #2563eb;

            font-size: 18px;

            transform:
                translateX(-50%);

            transition:
                left .7s ease;

            filter:
                drop-shadow(
                    0 2px 3px
                    rgba(37,99,235,.25)
                );
        }


        /* =====================================================
           TIMELINE
        ===================================================== */

        .timeline-section {

            padding: 25px;

            border-top:
                1px solid #eef0f4;
        }


        .timeline-title {

            display: flex;

            align-items: center;

            gap: 8px;

            margin-bottom: 18px;

            color: #334155;

            font-size: 14px;

            font-weight: 750;
        }


        .timeline-title i {

            color: #6366f1;

            font-size: 17px;
        }


        .timeline {

            position: relative;

            padding-left: 25px;
        }


        .timeline:before {

            content: "";

            position: absolute;

            left: 7px;

            top: 5px;

            bottom: 5px;

            width: 2px;

            background: #e5e7eb;
        }


        .timeline-item {

            position: relative;

            padding: 0 0 20px 15px;
        }


        .timeline-item:last-child {

            padding-bottom: 0;
        }


        .timeline-dot {

            position: absolute;

            left: -25px;

            top: 1px;

            width: 16px;

            height: 16px;

            border-radius: 50%;

            background: #16a34a;

            border:
                3px solid #dcfce7;
        }


        .timeline-content {

            padding: 12px 14px;

            border-radius: 11px;

            background: #f8fafc;

            border:
                1px solid #edf0f4;
        }


        .timeline-status {

            color: #334155;

            font-size: 12px;

            font-weight: 750;
        }


        .timeline-time {

            display: block;

            margin-top: 4px;

            color: #94a3b8;

            font-size: 10px;
        }


        /* =====================================================
           CANCELLED
        ===================================================== */

        .cancelled-card {

            padding: 25px;

            text-align: center;

            background:
                #fff7f7;

            border-top:
                1px solid #fee2e2;
        }


        .cancelled-icon {

            width: 55px;

            height: 55px;

            margin: 0 auto 12px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background: #fee2e2;

            color: #dc2626;

            font-size: 25px;
        }


        .cancelled-card h4 {

            margin: 0 0 5px;

            color: #991b1b;

            font-weight: 750;
        }


        .cancelled-card p {

            margin: 0;

            color: #b91c1c;

            font-size: 12px;
        }


        /* =====================================================
           NO HISTORY
        ===================================================== */

        .no-history {

            padding: 35px 20px;

            text-align: center;

            color: #94a3b8;
        }


        .no-history i {

            display: block;

            margin-bottom: 8px;

            font-size: 30px;
        }


        /* =====================================================
           TABLET
        ===================================================== */

        @media (max-width: 767px) {

            body {

                padding:
                    20px 10px 35px;
            }


            .tracking-page {

                width: 100%;
            }


            .tracking-header {

                padding: 22px 20px;

                border-radius: 17px;
            }


            .tracking-header h1 {

                font-size: 22px;
            }


            .tracking-header p {

                font-size: 11px;
            }


            .current-status {

                padding: 14px;

                border-radius: 14px;
            }


            .status-icon {

                width: 40px;

                height: 40px;

                flex-basis: 40px;

                font-size: 17px;
            }


            .status-text strong {

                font-size: 14px;
            }


            .status-time {

                font-size: 9px;
            }


            .tracking-card {

                border-radius: 16px;
            }


            .progress-area {

                padding:
                    35px 15px 28px;

                overflow: hidden;
            }


            .progress-track {

                min-width: 0;
            }


            .progress-track:before {

                left: 9%;

                right: 9%;

                top: 13px;

                height: 3px;
            }


            .progress-fill {

                left: 9%;

                top: 13px;

                height: 3px;
            }


            .circle {

                width: 27px;

                height: 27px;

                font-size: 9px;
            }


            .step-label {

                margin-top: 8px;

                font-size: 6px;

                padding:
                    0 2px;
            }


            .moving-truck {

                top: -9px;

                font-size: 14px;
            }


            .timeline-section {

                padding: 18px 15px;
            }


            .timeline-title {

                font-size: 12px;

                margin-bottom: 15px;
            }


            .timeline-content {

                padding: 10px 11px;
            }


            .timeline-status {

                font-size: 11px;
            }


            .timeline-time {

                font-size: 9px;
            }

        }


        /* =====================================================
           SMALL MOBILE
        ===================================================== */

        @media (max-width: 480px) {

            body {

                padding:
                    12px 6px 25px;
            }


            .back-button {

                margin-bottom: 10px;

                padding: 7px 11px;

                font-size: 10px;
            }


            .tracking-header {

                padding: 17px;

                margin-bottom: 12px;

                border-radius: 14px;
            }


            .tracking-header h1 {

                font-size: 18px;
            }


            .tracking-header p {

                font-size: 10px;

                margin-top: 5px;
            }


            .order-id-box {

                margin-top: 12px;

                padding: 6px 10px;

                font-size: 9px;
            }


            .current-status {

                margin-bottom: 12px;

                padding: 11px;

                gap: 8px;
            }


            .status-icon {

                width: 35px;

                height: 35px;

                flex-basis: 35px;

                border-radius: 9px;

                font-size: 15px;
            }


            .status-text small {

                font-size: 7px;
            }


            .status-text strong {

                font-size: 11px;
            }


            .status-time {

                font-size: 8px;
            }


            .tracking-card {

                border-radius: 14px;
            }


            .tracking-card-header {

                padding: 13px 14px;
            }


            .tracking-card-header h3 {

                font-size: 12px;
            }


            .tracking-card-header p {

                font-size: 9px;
            }


            .progress-area {

                padding:
                    28px 6px 24px;
            }


            .progress-track:before {

                left: 8%;

                right: 8%;

                top: 11px;

                height: 2px;
            }


            .progress-fill {

                left: 8%;

                top: 11px;

                height: 2px;
            }


            .circle {

                width: 23px;

                height: 23px;

                font-size: 7px;

                border-width: 1.5px;
            }


            .step-label {

                margin-top: 6px;

                font-size: 5px;

                letter-spacing: 0;
            }


            .moving-truck {

                top: -8px;

                font-size: 11px;
            }


            .timeline-section {

                padding:
                    15px 11px;
            }


            .timeline-title {

                font-size: 10px;
            }


            .timeline {

                padding-left: 21px;
            }


            .timeline:before {

                left: 5px;
            }


            .timeline-item {

                padding-left: 10px;

                padding-bottom: 12px;
            }


            .timeline-dot {

                left: -21px;

                width: 13px;

                height: 13px;

                border-width: 2px;
            }


            .timeline-status {

                font-size: 10px;
            }


            .timeline-time {

                font-size: 8px;
            }


            .cancelled-card {

                padding: 22px 15px;
            }


            .cancelled-icon {

                width: 45px;

                height: 45px;

                font-size: 20px;
            }


            .cancelled-card h4 {

                font-size: 15px;
            }


            .cancelled-card p {

                font-size: 10px;
            }

        }


        /* =====================================================
           VERY SMALL
        ===================================================== */

        @media (max-width: 360px) {

            .tracking-header h1 {

                font-size: 16px;
            }


            .current-status {

                padding: 9px;
            }


            .status-icon {

                width: 32px;

                height: 32px;

                flex-basis: 32px;

                font-size: 13px;
            }


            .status-text strong {

                font-size: 10px;
            }


            .status-time {

                font-size: 7px;
            }


            .circle {

                width: 21px;

                height: 21px;

                font-size: 6px;
            }


            .step-label {

                font-size: 4.5px;
            }


            .progress-area {

                padding-left: 3px;

                padding-right: 3px;
            }

        }

    </style>

</head>


<body>


<div class="tracking-page">


    <!-- =================================================
         BACK BUTTON
    ================================================= -->

    <a
        href="orderDetails.jsp?orderId=<%=orderId%>"
        class="back-button"
    >

        <i class="bi bi-arrow-left"></i>

        Back to Orders

    </a>


    <!-- =================================================
         PAGE HEADER
    ================================================= -->

    <div class="tracking-header">

        <div class="tracking-header-content">


            <h1>

                <i class="bi bi-box-seam"></i>

                Order Tracking

            </h1>


            <p>

                Follow the delivery progress of your order
                in real time.

            </p>


            <div class="order-id-box">

                <i class="bi bi-receipt"></i>

                Order ID:

                <strong>
                    <%=orderId%>
                </strong>

            </div>


        </div>

    </div>


    <!-- =================================================
         CURRENT STATUS
    ================================================= -->

    <div class="current-status">


        <div class="current-status-left">


            <div class="status-icon">


                <%
                    if(cancelled) {
                %>

                    <i class="bi bi-x-circle-fill"></i>

                <%
                    }
                    else if(
                        "DELIVERED".equals(currentStatus)
                    ) {
                %>

                    <i class="bi bi-check-circle-fill"></i>

                <%
                    }
                    else if(
                        "OUT_FOR_DELIVERY".equals(currentStatus)
                    ) {
                %>

                    <i class="bi bi-truck"></i>

                <%
                    }
                    else if(
                        "SHIPPED".equals(currentStatus)
                    ) {
                %>

                    <i class="bi bi-box-seam-fill"></i>

                <%
                    }
                    else {
                %>

                    <i class="bi bi-clock-fill"></i>

                <%
                    }
                %>


            </div>


            <div class="status-text">

                <small>
                    Current Status
                </small>

                <strong>

                    <%=currentStatus.replace("_"," ")%>

                </strong>

            </div>


        </div>


        <%
            if(
                !statusList.isEmpty() &&
                timeMap.get(currentStatus) != null
            ) {
        %>

        <div class="status-time">

            <i class="bi bi-clock"></i>

            <%=timeMap.get(currentStatus)%>

        </div>

        <%
            }
        %>


    </div>


    <!-- =================================================
         TRACKING CARD
    ================================================= -->

    <div class="tracking-card">


        <!-- CARD HEADER -->

        <div class="tracking-card-header">

            <h3>

                <i class="bi bi-activity"></i>

                Delivery Progress

            </h3>


            <p>

                Your order journey from placement to delivery

            </p>

        </div>


<%

    if(cancelled) {

%>


        <!-- =================================================
             CANCELLED
        ================================================= -->

        <div class="cancelled-card">


            <div class="cancelled-icon">

                <i class="bi bi-x-lg"></i>

            </div>


            <h4>
                Order Cancelled
            </h4>


            <p>
                This order is no longer in the delivery process.
            </p>


        </div>


<%

    }

    else {

%>


        <!-- =================================================
             PROGRESS
        ================================================= -->

        <div class="progress-area">


            <div class="progress-track">


                <!-- BACKGROUND LINE -->

                <div></div>


                <!-- COMPLETED LINE -->

                <div

                    class="progress-fill"

                    style="
                        width:
                        <%=progress * 0.8%>%;
                    "

                ></div>


                <!-- TRUCK -->

                <div

                    class="moving-truck"

                    style="
                        left:
                        <%=10 + (currentIndex * 20)%>%;
                    "

                >

                    <i class="bi bi-truck"></i>

                </div>


<%

        for(int i = 0;
            i < steps.length;
            i++) {


            boolean active =
                statusList.contains(
                    steps[i]
                );

%>


                <!-- STEP -->

                <div class="step">


                    <div
                        class="circle <%=active ? "active" : ""%>"
                    >


                        <%
                            if(active) {
                        %>

                            <i class="bi bi-check"></i>

                        <%
                            }
                            else {
                        %>

                            <%=i + 1%>

                        <%
                            }
                        %>


                    </div>


                    <span
                        class="step-label <%=active ? "active-label" : ""%>"
                    >

                        <%=steps[i].replace("_"," ")%>

                    </span>


                </div>


<%

        }

%>


            </div>


        </div>


        <!-- =================================================
             STATUS TIMELINE
        ================================================= -->

        <div class="timeline-section">


            <div class="timeline-title">

                <i class="bi bi-clock-history"></i>

                Order History

            </div>


<%

        if(statusList.isEmpty()) {

%>


            <div class="no-history">

                <i class="bi bi-clock-history"></i>

                No tracking history available yet.

            </div>


<%

        }
        else {

%>


            <div class="timeline">


<%

            for(String status : statusList) {

%>


                <div class="timeline-item">


                    <div class="timeline-dot"></div>


                    <div class="timeline-content">


                        <div class="timeline-status">

                            <i class="bi bi-check-circle-fill text-success"></i>

                            <%=status.replace("_"," ")%>

                        </div>


                        <span class="timeline-time">

                            <i class="bi bi-clock"></i>

                            <%=timeMap.get(status)%>

                        </span>


                    </div>


                </div>


<%

            }

%>


            </div>


<%

        }

%>


        </div>


<%

    }

%>


    </div>


</div>


<!-- =====================================================
     JAVASCRIPT
===================================================== -->

<script>


/*
 * Auto refresh order tracking.
 *
 * This keeps the page updated when the admin/staff
 * changes the order status.
 */

setInterval(function() {

    location.reload();

}, 1000*30);


</script>


</body>

</html>