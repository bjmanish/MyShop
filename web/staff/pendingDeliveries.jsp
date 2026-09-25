<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>

<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Order Details | MYSHOP</title>


    <!-- FAVICON -->

    <link rel="icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">


    <!-- BOOTSTRAP -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- FONT AWESOME -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- GOOGLE FONT -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com">

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">
    
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/pending.css"/>

</head>


<body>


<%
    /* =========================================================
       SESSION
       ========================================================= */

    String username =
        (String) session.getAttribute("username");

    String userType =
        (String) session.getAttribute("role");

    String userId =
        (String) session.getAttribute("user_id");


    if (username == null
            || userType == null
            || userId == null
            || userId.trim().isEmpty()) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?error=session_expired"
        );

        return;
    }


    String message =
        request.getParameter("message");


    String requestedOrderId =
        request.getParameter("orderId");


    /* =========================================================
       FETCH ORDERS
       ========================================================= */

    OrderServiceImpl orderDAO =
        new OrderServiceImpl();


    List<OrderDetails> orders =
        orderDAO.getAllOrders();


    SimpleDateFormat sdf =
        new SimpleDateFormat(
            "dd-MM-yyyy HH:mm"
        );

%>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="order-page">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <div class="order-header">


        <div class="title-area">

            <div class="title-icon">

                <i class="fa-solid fa-box-open"></i>

            </div>


            <div>

                <h1>
                    Order Details
                </h1>

                <p>
                    View your order items and delivery status.
                </p>

            </div>

        </div>


        <a
            href="<%=request.getContextPath()%>/staff/staffHome.jsp"
            class="back-btn"
        >

            <i class="fa-solid fa-arrow-left"></i>

            Back to Home

        </a>


    </div>


    <!-- =====================================================
         MESSAGE
         ===================================================== -->

<%

    if (message != null
            && !message.trim().isEmpty()) {

%>

    <div
        class="alert alert-danger message-alert text-center"
    >

        <i class="fa-solid fa-circle-exclamation me-2"></i>

        <%=message%>

    </div>

<%

    }

%>


    <!-- =====================================================
         ORDER CARD
         ===================================================== -->

    <div class="order-card">


<%

    if (orders == null
            || orders.isEmpty()) {

%>


        <!-- =================================================
             EMPTY STATE
             ================================================= -->

        <div class="empty-state">

            <div class="empty-icon">

                <i class="fa-solid fa-box-open"></i>

            </div>


            <h4>
                No Orders Found
            </h4>


            <p>
                Your orders will appear here after you place an order.
            </p>

        </div>


<%

    } else {

%>


        <!-- =================================================
             DESKTOP
             ================================================= -->

        <div class="desktop-orders table-responsive">

            <table class="order-table">

                <thead>

                    <tr>

                        <th>
                            Order ID
                        </th>

                        <th>
                            Product
                        </th>

                        <th>
                            Quantity
                        </th>

                        <th>
                            Amount
                        </th>

                        <th>
                            Order Time
                        </th>

                        <th>
                            Status
                        </th>

                    </tr>

                </thead>


                <tbody>


<%

        boolean foundOrder =
            false;


        for (OrderDetails order :
                orders) {


            /*
             * If orderId is supplied, display only
             * that order.
             */

            if (requestedOrderId != null
                    && !requestedOrderId.trim().isEmpty()
                    && !requestedOrderId.equals(
                        String.valueOf(
                            order.getOrderId()
                        )
                    )) {

                continue;

            }


            foundOrder = true;


            String status =
                order.getStatus();


            if (status == null
                    || status.trim().isEmpty()) {

                status = "PENDING";

            }


            String statusClass =
                "status-default";


            String statusIcon =
                "fa-clock";


            if ("DELIVERED".equalsIgnoreCase(status)) {

                statusClass =
                    "status-delivered";

                statusIcon =
                    "fa-circle-check";

            } else if (
                "SHIPPED".equalsIgnoreCase(status)
                ||
                "OUT_FOR_DELIVERY".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-shipped";

                statusIcon =
                    "fa-truck-fast";

            } else if (
                "PENDING".equalsIgnoreCase(status)
                ||
                "PLACED".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-pending";

                statusIcon =
                    "fa-clock";

            } else if (
                "CANCELLED".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-cancelled";

                statusIcon =
                    "fa-circle-xmark";

            }

%>


                    <tr>


                        <!-- ORDER ID -->

                        <td>

                            <span class="order-id">

                                <%=order.getOrderId()%>

                            </span>

                        </td>


                        <!-- PRODUCT -->

                        <td>

                            <span class="product-id">

                                <i class="fa-solid fa-box"></i>

                                <%=order.getProdId()%>

                            </span>

                        </td>


                        <!-- QUANTITY -->

                        <td>

                            <strong>
                                <%=order.getQnty()%>
                            </strong>

                        </td>


                        <!-- AMOUNT -->

                        <td>

                            <span class="amount">

                                &#8377;<%=String.format(
                                    "%.2f",
                                    order.getAmount()
                                )%>

                            </span>

                        </td>


                        <!-- DATE -->

                        <td>

<%

                        if (order.getDeliveryDate() != null) {

%>

                            <%=sdf.format(
                                order.getDeliveryDate()
                            )%>

<%

                        } else {

%>

                            -

<%

                        }

%>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <span
                                class="status <%=statusClass%>"
                            >

                                <i
                                    class="fa-solid <%=statusIcon%>"
                                ></i>

                                <%=status.replace(
                                    "_",
                                    " "
                                )%>

                            </span>

                        </td>


                    </tr>


<%

        }


        if (!foundOrder) {

%>


                    <tr>

                        <td
                            colspan="6"
                            class="text-center py-5"
                        >

                            <i
                                class="fa-solid fa-box-open mb-3"
                                style="font-size:35px;color:#aaa;"
                            ></i>

                            <br>

                            No details found for
                            Order ID:

                            <strong>
                                <%=requestedOrderId%>
                            </strong>

                        </td>

                    </tr>


<%

        }

%>


                </tbody>

            </table>

        </div>


        <!-- =================================================
             MOBILE
             ================================================= -->

        <div class="mobile-orders">


<%

        for (OrderDetails order :
                orders) {


            if (requestedOrderId != null
                    && !requestedOrderId.trim().isEmpty()
                    && !requestedOrderId.equals(
                        String.valueOf(
                            order.getOrderId()
                        )
                    )) {

                continue;

            }


            String status =
                order.getStatus();


            if (status == null
                    || status.trim().isEmpty()) {

                status = "PENDING";

            }


            String statusClass =
                "status-default";


            String statusIcon =
                "fa-clock";


            if ("DELIVERED".equalsIgnoreCase(status)) {

                statusClass =
                    "status-delivered";

                statusIcon =
                    "fa-circle-check";

            } else if (
                "SHIPPED".equalsIgnoreCase(status)
                ||
                "OUT_FOR_DELIVERY".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-shipped";

                statusIcon =
                    "fa-truck-fast";

            } else if (
                "PENDING".equalsIgnoreCase(status)
                ||
                "PLACED".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-pending";

                statusIcon =
                    "fa-clock";

            } else if (
                "CANCELLED".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-cancelled";

                statusIcon =
                    "fa-circle-xmark";

            }

%>


            <div class="order-mobile-card">


                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Order ID
                        </div>

                        <div class="mobile-value">

                            <span class="order-id">
                                <%=order.getOrderId()%>
                            </span>

                        </div>

                    </div>


                    <span
                        class="status <%=statusClass%>"
                    >

                        <i
                            class="fa-solid <%=statusIcon%>"
                        ></i>

                        <%=status.replace(
                            "_",
                            " "
                        )%>

                    </span>

                </div>


                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Product
                        </div>

                        <div class="mobile-value">

                            <%=order.getProdId()%>

                        </div>

                    </div>


                    <div>

                        <div class="mobile-label">
                            Quantity
                        </div>

                        <div class="mobile-value">

                            <%=order.getQnty()%>

                        </div>

                    </div>

                </div>


                <div class="mobile-row">

                    <div>

                        <div class="mobile-label">
                            Amount
                        </div>

                        <div class="mobile-value amount">

                            &#8377;<%=String.format(
                                "%.2f",
                                order.getAmount()
                            )%>

                        </div>

                    </div>


                    <div>

                        <div class="mobile-label">
                            Date
                        </div>

                        <div class="mobile-value">

<%

                            if (order.getDeliveryDate() != null) {

%>

                                <%=sdf.format(
                                    order.getDeliveryDate()
                                )%>

<%

                            } else {

%>

                                -

<%

                            }

%>

                        </div>

                    </div>

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


</div>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"/>


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js">
</script>


<!-- =========================================================
     THEME
     ========================================================= -->

<script>

    function applyTheme() {

        const theme =
            localStorage.getItem("myshop-theme");

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