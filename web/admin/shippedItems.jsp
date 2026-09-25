<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.OrderItem"%>
<%@page import="com.myshop.beans.UserBean"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin - Shipped Orders</title>


    <!-- =====================================================
         BOOTSTRAP 5
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
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

            margin: 0;

            padding: 0;

            width: 100%;

            min-width: 320px;

            overflow-x: hidden;
        }


        body {

            background:
                linear-gradient(
                    135deg,
                    #eef9ee,
                    #f8fff8
                );

            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            color: #333;

            padding-top: 90px;

            min-height: 100vh;
        }


        /* =====================================================
           PAGE CONTAINER
           ===================================================== */

        .orders-container {

            width: 100%;

            max-width: 1250px;

            margin: 0 auto;

            padding:
                25px
                15px
                50px;
        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .page-header {

            background:
                linear-gradient(
                    135deg,
                    #198754,
                    #28a745
                );

            color: white;

            border-radius: 15px;

            padding:
                25px
                30px;

            margin-bottom: 25px;

            box-shadow:
                0 6px 20px
                rgba(0, 0, 0, 0.10);

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 15px;
        }


        .page-header-content h2 {

            margin: 0 0 6px;

            font-size: 28px;

            font-weight: 700;
        }


        .page-header-content p {

            margin: 0;

            font-size: 14px;

            opacity: 0.9;
        }


        .truck-icon {

            width: 60px;

            height: 60px;

            border-radius: 50%;

            background:
                rgba(255, 255, 255, 0.15);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 28px;

            flex-shrink: 0;
        }


        /* =====================================================
           ORDER COUNT
           ===================================================== */

        .order-count {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-top: 12px;

            padding:
                6px
                12px;

            background:
                rgba(255, 255, 255, 0.18);

            border-radius: 20px;

            font-size: 13px;

            font-weight: 600;
        }


        /* =====================================================
           ORDER CARD
           ===================================================== */

        .order-row {

            background: white;

            margin-bottom: 18px;

            padding: 20px;

            border-radius: 14px;

            border:
                1px solid
                #e5e9e5;

            box-shadow:
                0 4px 15px
                rgba(0, 0, 0, 0.07);

            transition:
                all 0.25s ease;
        }


        .order-row:hover {

            transform:
                translateY(-3px);

            box-shadow:
                0 8px 25px
                rgba(0, 0, 0, 0.10);
        }


        /* =====================================================
           ORDER COLUMNS
           ===================================================== */

        .order-section {

            height: 100%;

            padding:
                5px
                12px;
        }


        .order-section + .order-section {

            border-left:
                1px solid
                #eeeeee;
        }


        /* =====================================================
           SECTION TITLE
           ===================================================== */

        .section-title {

            display: flex;

            align-items: center;

            gap: 7px;

            color: #198754;

            font-size: 13px;

            font-weight: 700;

            text-transform: uppercase;

            margin-bottom: 8px;
        }


        .section-title i {

            font-size: 14px;
        }


        /* =====================================================
           ORDER INFORMATION
           ===================================================== */

        .order-id {

            font-size: 15px;

            font-weight: 700;

            color: #222;

            word-break: break-word;
        }


        .order-amount {

            color: #198754;

            font-size: 18px;

            font-weight: 700;

            margin-top: 8px;
        }


        .info-label {

            color: #777;

            font-size: 12px;

            font-weight: 600;
        }


        /* =====================================================
           PRODUCT LIST
           ===================================================== */

        .product-list {

            max-height: 140px;

            overflow-y: auto;

            padding-right: 5px;
        }


        .product-item {

            padding:
                7px
                0;

            border-bottom:
                1px solid
                #f0f0f0;

            font-size: 13px;

            line-height: 1.4;

            word-break: break-word;
        }


        .product-item:last-child {

            border-bottom: none;
        }


        .quantity {

            color: #777;

            font-weight: 600;

            white-space: nowrap;
        }


        /* =====================================================
           CUSTOMER
           ===================================================== */

        .customer-name {

            font-size: 15px;

            font-weight: 700;

            color: #222;

            margin-bottom: 5px;

            word-break: break-word;
        }


        .customer-info {

            font-size: 12px;

            color: #666;

            line-height: 1.6;

            word-break: break-word;
        }


        .customer-info i {

            width: 17px;

            color: #198754;
        }


        /* =====================================================
           STATUS
           ===================================================== */

        .status-wrapper {

            text-align: center;

            height: 100%;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;
        }


        .status {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            padding:
                7px
                13px;

            border-radius: 20px;

            color: white;

            font-size: 12px;

            font-weight: 700;

            white-space: nowrap;
        }


        .status-SHIPPED {

            background: #337ab7;
        }


        .status-OUT_FOR_DELIVERY {

            background: #0dcaf0;

            color: #073c4a;
        }


        .status-DELIVERED {

            background: #198754;
        }


        /* =====================================================
           DELIVERY BUTTON
           ===================================================== */

        .btn-deliver {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            margin-top: 15px;

            padding:
                9px
                14px;

            background:
                #212529;

            color: white;

            text-decoration: none;

            border-radius: 8px;

            font-size: 12px;

            font-weight: 600;

            transition:
                all 0.2s ease;
        }


        .btn-deliver:hover {

            background:
                #198754;

            color: white;

            transform:
                translateY(-1px);
        }


        .processed {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            margin-top: 15px;

            padding:
                7px
                12px;

            background:
                #f0f2f4;

            color: #777;

            border-radius: 20px;

            font-size: 12px;

            font-weight: 600;
        }


        /* =====================================================
           EMPTY STATE
           ===================================================== */

        .empty-state {

            background: white;

            border-radius: 15px;

            padding:
                60px
                20px;

            text-align: center;

            color: #777;

            box-shadow:
                0 4px 15px
                rgba(0, 0, 0, 0.06);
        }


        .empty-state-icon {

            width: 75px;

            height: 75px;

            margin:
                0
                auto
                20px;

            border-radius: 50%;

            background:
                #eef8f0;

            color:
                #198754;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 32px;
        }


        .empty-state h4 {

            color: #444;

            font-weight: 600;

            margin-bottom: 7px;
        }


        .empty-state p {

            margin: 0;

            font-size: 13px;
        }


        /* =====================================================
           TABLET
           ===================================================== */

        @media (max-width: 991px) {

            body {

                padding-top: 80px;
            }


            .orders-container {

                padding:
                    20px
                    12px
                    40px;
            }


            .page-header {

                padding:
                    20px
                    22px;
            }


            .page-header-content h2 {

                font-size: 24px;
            }


            .order-row {

                padding: 15px;
            }


            .order-section {

                padding:
                    5px
                    8px;
            }


            .order-section + .order-section {

                border-left: none;
            }


            .order-amount {

                font-size: 16px;
            }
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 767px) {

            body {

                padding-top: 70px;
            }


            .orders-container {

                padding:
                    15px
                    9px
                    35px;
            }


            .page-header {

                padding:
                    18px;

                border-radius: 12px;

                margin-bottom: 18px;
            }


            .page-header-content h2 {

                font-size: 21px;

                line-height: 1.3;
            }


            .page-header-content p {

                font-size: 12px;

                line-height: 1.5;
            }


            .truck-icon {

                width: 48px;

                height: 48px;

                font-size: 21px;
            }


            .order-count {

                font-size: 11px;

                padding:
                    5px
                    9px;
            }


            .order-row {

                padding:
                    14px;

                border-radius: 12px;

                margin-bottom: 14px;
            }


            .order-section {

                padding:
                    10px
                    2px;
            }


            .order-section + .order-section {

                border-top:
                    1px solid
                    #eeeeee;

                margin-top: 5px;

                padding-top: 15px;
            }


            .section-title {

                font-size: 11px;

                margin-bottom: 7px;
            }


            .order-id {

                font-size: 14px;
            }


            .order-amount {

                font-size: 16px;

                margin-top: 5px;
            }


            .product-list {

                max-height: none;

                overflow: visible;
            }


            .product-item {

                font-size: 12px;

                padding:
                    6px
                    0;
            }


            .customer-name {

                font-size: 14px;
            }


            .customer-info {

                font-size: 11px;

                line-height: 1.7;
            }


            .status-wrapper {

                min-height: 100px;
            }


            .status {

                font-size: 11px;

                padding:
                    6px
                    11px;
            }


            .btn-deliver {

                width: 100%;

                margin-top: 12px;

                min-height: 40px;

                font-size: 12px;
            }


            .processed {

                margin-top: 12px;
            }


            .empty-state {

                padding:
                    45px
                    15px;
            }
        }


        /* =====================================================
           SMALL MOBILE
           ===================================================== */

        @media (max-width: 380px) {

            .orders-container {

                padding-left: 6px;

                padding-right: 6px;
            }


            .page-header {

                padding: 15px;

                gap: 10px;
            }


            .page-header-content h2 {

                font-size: 19px;
            }


            .page-header-content p {

                font-size: 11px;
            }


            .truck-icon {

                width: 42px;

                height: 42px;

                font-size: 18px;
            }


            .order-row {

                padding: 12px;
            }


            .order-amount {

                font-size: 15px;
            }


            .product-item {

                font-size: 11px;
            }


            .customer-info {

                font-size: 10px;
            }


            .status {

                font-size: 10px;

                padding:
                    5px
                    9px;
            }


            .btn-deliver {

                font-size: 11px;
            }
        }


        /* =====================================================
           VERY SMALL DEVICES
           ===================================================== */

        @media (max-width: 320px) {

            .page-header-content h2 {

                font-size: 17px;
            }


            .truck-icon {

                display: none;
            }


            .order-row {

                padding: 10px;
            }
        }

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"></jsp:include>



<%
    /* =========================================================
       ADMIN SESSION CHECK
       ========================================================= */

    String userType =
            (String) session.getAttribute("role");


    if (userType == null ||
        !userType.equalsIgnoreCase("admin")) {

        response.sendRedirect("login.jsp");

        return;
    }


    /* =========================================================
       GET ORDERS
       ========================================================= */

    List<OrderDetails> orders =
            new OrderServiceImpl().getAllOrders();


    int count = 0;


    /*
     * Create service once instead of creating
     * ProductServiceImpl repeatedly inside the loop.
     */

    ProductServiceImpl productService =
            new ProductServiceImpl();


    UserServiceImpl userService =
            new UserServiceImpl();

%>



<!-- =========================================================
     MAIN CONTAINER
     ========================================================= -->

<div class="orders-container">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <div class="page-header">


        <div class="page-header-content">

            <h2>

                <i class="fa-solid fa-truck-fast"></i>

                Shipped Orders

            </h2>


            <p>

                Manage orders that are ready for delivery.

            </p>


            <div class="order-count">

                <i class="fa-solid fa-box"></i>

                <span id="orderCount">

                    Processing orders...

                </span>

            </div>

        </div>


        <div class="truck-icon">

            <i class="fa-solid fa-truck"></i>

        </div>


    </div>



<%
    /* =========================================================
       ORDER LOOP
       ========================================================= */

    for (OrderDetails order : orders) {


        String status =
                order.getStatus();


        /*
         * Show all orders except PLACED.
         */

        if (!"PLACED".equalsIgnoreCase(status)) {


            count++;


            String userId =
                    order.getUserId();


            UserBean user =
                    userService.getUserDetailsById(
                            userId
                    );

%>


    <!-- =====================================================
         ORDER CARD
         ===================================================== -->

    <div class="order-row">


        <div class="row g-0">


            <!-- =================================================
                 ORDER INFORMATION
                 ================================================= -->

            <div class="col-lg-3 col-md-6 col-12 order-section">


                <div class="section-title">

                    <i class="fa-solid fa-receipt"></i>

                    Order Information

                </div>


                <div class="info-label">

                    Order ID

                </div>


                <div class="order-id">

                    <%=order.getOrderId()%>

                </div>


                <div class="info-label mt-2">

                    Total Amount

                </div>


                <div class="order-amount">

                    &#8377; <%=order.getAmount()%>

                </div>


            </div>



            <!-- =================================================
                 PRODUCTS
                 ================================================= -->

            <div class="col-lg-3 col-md-6 col-12 order-section">


                <div class="section-title">

                    <i class="fa-solid fa-box-open"></i>

                    Products

                </div>


                <div class="product-list">


                    <%
                        if (order.getItems() != null &&
                            !order.getItems().isEmpty()) {


                            for (OrderItem item :
                                    order.getItems()) {


                                String productName =
                                        productService
                                        .getProductNameById(
                                            item.getProductId()
                                        );


                                if (productName == null ||
                                    productName.trim().isEmpty()) {

                                    productName =
                                            "Product";
                                }

                    %>


                        <div class="product-item">

                            <i class="fa-solid fa-cube" style="color:#198754;margin-right:5px;"></i>
                            <span class="text-black"><%=productName%></span>
                            

                            <span class="quantity">

                                (x<%=item.getQuantity()%>)

                            </span>

                        </div>


                    <%
                            }

                        } else {
                    %>


                        <div class="product-item text-muted">

                            No products found.

                        </div>


                    <%
                        }
                    %>


                </div>

            </div>



            <!-- =================================================
                 CUSTOMER
                 ================================================= -->

            <div class="col-lg-3 col-md-6 col-12 order-section">


                <div class="section-title">

                    <i class="fa-solid fa-user"></i>

                    Customer

                </div>


                <div class="customer-name">

                    <%= (user != null)
                        ? user.getName()
                        : "N/A" %>

                </div>


                <% if (user != null) { %>


                    <div class="customer-info">

                        <div>

                            <i class="fa-solid fa-envelope"></i>

                            <%=user.getEmail()%>

                        </div>


                        <div>

                            <i class="fa-solid fa-location-dot"></i>

                            <%=user.getAddress()%>

                        </div>

                    </div>


                <% } else { %>


                    <div class="customer-info">

                        Customer details not available.

                    </div>


                <% } %>


            </div>



            <!-- =================================================
                 STATUS + ACTION
                 ================================================= -->

            <div class="col-lg-3 col-md-6 col-12 order-section">


                <div class="status-wrapper">


                    <!-- STATUS -->

                    <%
                        String statusClass =
                                status != null
                                ? status
                                : "UNKNOWN";


                        String statusIcon =
                                "SHIPPED".equalsIgnoreCase(status)
                                ? "fa-box"
                                :
                                "OUT_FOR_DELIVERY"
                                .equalsIgnoreCase(status)
                                ? "fa-truck"
                                :
                                "DELIVERED"
                                .equalsIgnoreCase(status)
                                ? "fa-circle-check"
                                :
                                "fa-info-circle";
                    %>


                    <span
                        class="status status-<%=statusClass%>"
                    >

                        <i
                            class="fa-solid <%=statusIcon%>"
                        ></i>

                        <%=status != null
                            ? status.replace(
                                "_",
                                " "
                              )
                            : "UNKNOWN"%>

                    </span>



                    <!-- ACTION -->

                    <%
                        if (!"OUT_FOR_DELIVERY"
                                .equalsIgnoreCase(status)
                            &&
                            !"DELIVERED"
                                .equalsIgnoreCase(status)) {
                    %>


                        <a
                            href="<%=request.getContextPath()%>/OutForDeliverySrv?orderid=<%=order.getOrderId()%>&userid=<%=userId%>"
                            onclick="return confirmDelivery()"
                            class="btn-deliver"
                        >

                            <i class="fa-solid fa-truck-fast"></i>

                            Ready for Delivery

                        </a>


                    <%
                        } else {
                    %>


                        <span class="processed">

                            <i class="fa-solid fa-circle-check"></i>

                            Processed

                        </span>


                    <%
                        }
                    %>


                </div>

            </div>


        </div>

    </div>


<%
        }
    }
%>



<!-- =========================================================
     EMPTY STATE
     ========================================================= -->

<% if (count == 0) { %>


    <div class="empty-state">


        <div class="empty-state-icon">

            <i class="fa-solid fa-box-open"></i>

        </div>


        <h4>

            No Orders Found

        </h4>


        <p>

            There are currently no shipped orders to process.

        </p>


    </div>


<% } %>


</div>



<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"></jsp:include>



<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


/* =========================================================
   ORDER COUNT
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function() {

        const count =
            <%=count%>;


        const countElement =
            document.getElementById(
                "orderCount"
            );


        if (count === 0) {

            countElement.innerText =
                "No pending orders";

        } else if (count === 1) {

            countElement.innerText =
                "1 Order";

        } else {

            countElement.innerText =
                count + " Orders";

        }

    }
);


/* =========================================================
   DELIVERY CONFIRMATION
   ========================================================= */

function confirmDelivery() {

    return confirm(
        "Are you sure you want to mark this order as Out For Delivery?"
    );

}

</script>


</body>

</html>