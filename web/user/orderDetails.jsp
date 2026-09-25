<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="java.util.*"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Orders - MyShop</title>


    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">


    <!-- SweetAlert -->
    <script
        src="https://cdn.jsdelivr.net/npm/sweetalert2@11">
    </script>


<style>

/* =========================================================
   GLOBAL
========================================================= */

*{
    box-sizing:border-box;
}

html,
body{
    width:100%;
    min-width:320px;
    margin:0;
    padding:0;
    overflow-x:hidden;
}

body{

    /*
     * Header space
     */
    padding-top:105px;

    padding-bottom:40px;

    background:
        linear-gradient(
            135deg,
            #eef2ff 0%,
            #f8fafc 45%,
            #eef2ff 100%
        );

    color:#172033;

    font-family:
        -apple-system,
        BlinkMacSystemFont,
        "Segoe UI",
        Roboto,
        Arial,
        sans-serif;
}


/* =========================================================
   MAIN
========================================================= */

.orders-page{

    width:100%;

    max-width:1250px;

    margin:0 auto;

    padding:
        0 18px;
}


/* =========================================================
   PAGE HEADER
========================================================= */

.page-header{

    position:relative;

    overflow:hidden;

    width:100%;

    margin-bottom:22px;

    padding:27px 30px;

    border-radius:22px;

    color:#ffffff;

    background:
        linear-gradient(
            135deg,
            #0f172a 0%,
            #1e1b4b 45%,
            #6d28d9 100%
        );

    box-shadow:
        0 15px 40px
        rgba(15,23,42,.20);
}

.page-header::before{

    content:"";

    position:absolute;

    width:230px;
    height:230px;

    right:-90px;
    top:-120px;

    border-radius:50%;

    background:
        rgba(255,255,255,.08);
}

.page-header::after{

    content:"";

    position:absolute;

    width:130px;
    height:130px;

    right:180px;
    bottom:-100px;

    border-radius:50%;

    background:
        rgba(129,140,248,.15);
}

.page-header-content{

    position:relative;

    z-index:2;
}

.page-header h1{

    margin:0;

    font-size:30px;

    font-weight:750;

    letter-spacing:-.5px;
}

.page-header p{

    margin:7px 0 0;

    color:
        rgba(255,255,255,.72);

    font-size:13px;
}

.order-count{

    display:inline-flex;

    align-items:center;

    gap:7px;

    margin-top:15px;

    padding:7px 13px;

    border-radius:30px;

    background:
        rgba(255,255,255,.10);

    border:
        1px solid
        rgba(255,255,255,.15);

    font-size:10px;

    font-weight:650;
}


/* =========================================================
   EMPTY
========================================================= */

.empty-orders{

    width:100%;

    padding:65px 20px;

    text-align:center;

    background:#ffffff;

    border-radius:20px;

    box-shadow:
        0 10px 35px
        rgba(15,23,42,.08);
}

.empty-icon{

    width:82px;
    height:82px;

    margin:0 auto 18px;

    display:flex;

    align-items:center;
    justify-content:center;

    border-radius:50%;

    color:#6366f1;

    background:#eef2ff;

    font-size:36px;
}

.empty-orders h3{

    margin:0 0 7px;

    font-size:21px;

    font-weight:700;
}

.empty-orders p{

    margin:0;

    color:#64748b;

    font-size:13px;
}


/* =========================================================
   ORDER CARD
========================================================= */

.order-card{

    width:100%;

    margin-bottom:22px;

    overflow:hidden;

    background:#ffffff;

    border:
        1px solid #e7eaf0;

    border-radius:20px;

    box-shadow:
        0 8px 30px
        rgba(15,23,42,.07);

    transition:
        transform .25s ease,
        box-shadow .25s ease;
}

.order-card:hover{

    transform:translateY(-2px);

    box-shadow:
        0 14px 38px
        rgba(15,23,42,.11);
}


/* =========================================================
   ORDER HEADER
========================================================= */

.order-top{

    width:100%;

    display:flex;

    align-items:center;

    justify-content:space-between;

    gap:15px;

    padding:14px 22px;

    background:#fbfcfe;

    border-bottom:
        1px solid #edf0f4;
}

.order-id{

    min-width:0;

    color:#64748b;

    font-size:11px;

    font-weight:600;
}

.order-id strong{

    color:#111827;

    font-size:14px;
}

.order-date{

    flex-shrink:0;

    color:#64748b;

    font-size:11px;
}


/* =========================================================
   TEST BADGE
========================================================= */

.test-badge{

    display:inline-flex;

    align-items:center;

    gap:4px;

    margin-left:7px;

    padding:4px 8px;

    border-radius:20px;

    color:#92400e;

    background:#fef3c7;

    font-size:8px;

    font-weight:750;

    text-transform:uppercase;
}


/* =========================================================
   PRODUCT SECTION
========================================================= */

.product-section{

    width:100%;

    padding:25px;
}


/* =========================================================
   PRODUCT CARD
========================================================= */

.product-card{

    /*
     * IMPORTANT:
     *
     * Column 1:
     * Product information
     *
     * Column 2:
     * Current status
     */
    display:grid;

    grid-template-columns:
        minmax(0,1fr)
        250px;

    gap:25px;

    width:100%;

    padding:20px;

    border:
        1px solid #e9edf3;

    border-radius:17px;

    background:
        linear-gradient(
            145deg,
            #ffffff,
            #f8fafc
        );

    box-shadow:
        0 4px 15px
        rgba(15,23,42,.035);
}


/* =========================================================
   PRODUCT TOP
========================================================= */

.product-top{

    display:grid;

    grid-template-columns:
        145px
        minmax(0,1fr);

    gap:20px;

    width:100%;

    min-width:0;

    align-items:start;
}


/* =========================================================
   IMAGE
========================================================= */

.product-image{

    width:145px;
    height:145px;

    display:flex;

    align-items:center;
    justify-content:center;

    overflow:hidden;

    border-radius:15px;

    background:#f8fafc;

    border:
        1px solid #e5e7eb;
}

.product-image img{

    width:100%;
    height:100%;

    padding:12px;

    object-fit:contain;

    display:block;
}


/* =========================================================
   PRODUCT DETAILS
========================================================= */

.product-details{

    width:100%;

    min-width:0;
}

.product-name{

    width:100%;

    margin:0 0 16px;

    color:#111827;

    font-size:21px;

    font-weight:750;

    line-height:1.3;

    overflow-wrap:anywhere;

    word-break:break-word;
}


/* =========================================================
   DETAIL GRID
========================================================= */

.details-grid{

    display:grid;

    grid-template-columns:
        repeat(2,minmax(0,1fr));

    gap:9px;

    width:100%;
}

.detail-box{

    min-width:0;

    overflow:hidden;

    padding:10px 12px;

    border-radius:10px;

    background:#f8fafc;

    border:
        1px solid #edf0f4;
}

.detail-label{

    display:block;

    margin-bottom:4px;

    color:#94a3b8;

    font-size:8px;

    font-weight:750;

    letter-spacing:.4px;

    text-transform:uppercase;
}

.detail-value{

    display:block;

    min-width:0;

    overflow:hidden;

    text-overflow:ellipsis;

    white-space:nowrap;

    color:#334155;

    font-size:12px;

    font-weight:650;
}

.amount{

    color:#059669;

    font-size:15px;
}


/* =========================================================
   CURRENT STATUS
   DESKTOP FIX
========================================================= */

.status-panel{

    /*
     * Never allow this box to shrink
     * into the product details.
     */
    width:100%;

    min-width:0;

    min-height:145px;

    display:flex;

    flex-direction:column;

    align-items:center;

    justify-content:center;

    padding:20px;

    border-radius:15px;

    background:
        linear-gradient(
            145deg,
            #f8fafc,
            #eef2f7
        );

    border:
        1px solid #e2e8f0;

    text-align:center;
}

.status-label{

    margin-bottom:11px;

    color:#94a3b8;

    font-size:9px;

    font-weight:750;

    letter-spacing:.5px;

    text-transform:uppercase;
}

.status-badge{

    display:inline-flex;

    align-items:center;

    justify-content:center;

    gap:6px;

    max-width:100%;

    padding:8px 15px;

    border-radius:30px;

    font-size:10px;

    font-weight:750;

    white-space:nowrap;
}


/* =========================================================
   STATUS COLORS
========================================================= */

.status-PLACED{

    color:#92400e;

    background:#fef3c7;
}

.status-CONFIRMED{

    color:#075985;

    background:#e0f2fe;
}

.status-SHIPPED{

    color:#1e40af;

    background:#dbeafe;
}

.status-OUT_FOR_DELIVERY{

    color:#155e75;

    background:#cffafe;
}

.status-DELIVERED{

    color:#166534;

    background:#dcfce7;
}

.status-CANCELLED{

    color:#991b1b;

    background:#fee2e2;
}


/* =========================================================
   ACTION BUTTONS
========================================================= */

.action-buttons{

    display:flex;

    flex-wrap:wrap;

    gap:8px;

    margin-top:15px;
}

.action-buttons a,
.action-buttons button{

    display:inline-flex;

    align-items:center;

    justify-content:center;

    gap:5px;

    padding:8px 12px;

    border:0;

    border-radius:9px;

    font-size:10px;

    font-weight:700;

    text-decoration:none;

    cursor:pointer;

    transition:
        transform .2s ease,
        box-shadow .2s ease;
}

.action-buttons a:hover,
.action-buttons button:hover{

    transform:translateY(-1px);
}

.track-btn{

    color:#ffffff;

    background:
        linear-gradient(
            135deg,
            #2563eb,
            #4f46e5
        );
}

.track-btn:hover{

    color:#ffffff;

    box-shadow:
        0 5px 15px
        rgba(37,99,235,.25);
}

.cancel-btn{

    color:#dc2626;

    background:#fee2e2;
}

.cancel-btn:hover{

    color:#b91c1c;

    background:#fecaca;
}


/* =========================================================
   PROGRESS SECTION
========================================================= */

.progress-section{

    width:100%;

    padding:
        22px 30px 30px;

    border-top:
        1px solid #eef0f4;

    background:#fcfdff;
}

.progress-title{

    display:flex;

    align-items:center;

    gap:7px;

    margin-bottom:28px;

    color:#334155;

    font-size:12px;

    font-weight:750;
}

.progress-title i{

    color:#6366f1;

    font-size:16px;
}

.progress-track{

    position:relative;

    display:flex;

    width:100%;
}

.progress-line{

    position:absolute;

    z-index:0;

    left:10%;

    right:10%;

    top:15px;

    height:4px;

    overflow:hidden;

    border-radius:10px;

    background:#e5e7eb;
}

.progress-fill{

    height:100%;

    border-radius:10px;

    background:
        linear-gradient(
            90deg,
            #10b981,
            #22c55e
        );

    transition:
        width .7s ease;
}

.progress-step{

    position:relative;

    z-index:2;

    flex:1;

    min-width:0;

    text-align:center;
}

.progress-circle{

    width:31px;
    height:31px;

    margin:0 auto;

    display:flex;

    align-items:center;
    justify-content:center;

    border-radius:50%;

    color:#94a3b8;

    background:#ffffff;

    border:
        2px solid #d1d5db;

    font-size:10px;

    font-weight:750;

    box-shadow:
        0 2px 7px
        rgba(15,23,42,.08);
}

.progress-circle.done{

    color:#ffffff;

    background:#16a34a;

    border-color:#16a34a;
}

.progress-label{

    display:block;

    margin-top:8px;

    padding:0 3px;

    color:#94a3b8;

    font-size:8px;

    font-weight:700;

    line-height:1.3;

    text-transform:uppercase;
}

.progress-label.done{

    color:#334155;
}

.truck{

    position:absolute;

    z-index:5;

    top:-27px;

    color:#2563eb;

    font-size:17px;

    transform:
        translateX(-50%);

    transition:
        left .7s ease;
}


/* =========================================================
   RATING
========================================================= */

.rating-section{

    display:flex;

    align-items:center;

    justify-content:center;

    gap:10px;

    padding:12px 15px;

    border-top:
        1px solid #eef0f4;

    background:#ffffff;
}

.rating-title{

    color:#64748b;

    font-size:10px;

    font-weight:650;
}

.stars{

    display:flex;

    gap:3px;
}

.stars i{

    color:#cbd5e1;

    font-size:18px;

    cursor:pointer;

    transition:
        color .15s ease,
        transform .15s ease;
}

.stars i:hover{

    color:#fbbf24;

    transform:scale(1.15);
}


/* =========================================================
   LARGE DESKTOP
========================================================= */

@media(min-width:1200px){

    .product-card{

        grid-template-columns:
            minmax(0,1fr)
            270px;

        gap:30px;

        padding:22px;
    }

    .product-top{

        grid-template-columns:
            150px
            minmax(0,1fr);

        gap:22px;
    }

    .product-image{

        width:150px;
        height:150px;
    }

    .status-panel{

        min-height:150px;
    }
}


/* =========================================================
   TABLET
========================================================= */

@media(max-width:1100px) and (min-width:768px){

    .product-card{

        grid-template-columns:
            minmax(0,1fr)
            200px;

        gap:15px;

        padding:15px;
    }

    .product-top{

        grid-template-columns:
            110px
            minmax(0,1fr);

        gap:15px;
    }

    .product-image{

        width:110px;
        height:110px;
    }

    .product-name{

        font-size:17px;

        margin-bottom:12px;
    }

    .detail-box{

        padding:8px 9px;
    }

    .detail-value{

        font-size:10px;
    }

    .amount{

        font-size:13px;
    }

    .status-panel{

        min-height:110px;

        padding:12px;
    }

    .status-badge{

        font-size:9px;

        padding:7px 10px;
    }
}


/* =========================================================
   MOBILE
========================================================= */

@media(max-width:767px){

    html,
    body{

        width:100%;

        min-width:320px;

        overflow-x:hidden;
    }

    body{

        /*
         * Header-safe mobile spacing
         */
        padding-top:78px;

        padding-bottom:25px;
    }

    .orders-page{

        width:100%;

        padding:
            0 7px;
    }


    /* PAGE HEADER */

    .page-header{

        padding:18px;

        margin-bottom:15px;

        border-radius:16px;
    }

    .page-header h1{

        font-size:21px;
    }

    .page-header p{

        margin-top:5px;

        font-size:10px;

        line-height:1.5;
    }

    .order-count{

        margin-top:11px;

        padding:6px 10px;

        font-size:8px;
    }


    /* ORDER CARD */

    .order-card{

        margin-bottom:15px;

        border-radius:15px;
    }


    /* ORDER HEADER */

    .order-top{

        padding:11px 12px;

        align-items:flex-start;

        gap:8px;
    }

    .order-id{

        font-size:8px;

        min-width:0;
    }

    .order-id strong{

        font-size:10px;
    }

    .order-date{

        font-size:8px;

        text-align:right;
    }

    .test-badge{

        margin-left:3px;

        padding:3px 5px;

        font-size:6px;
    }


    /* PRODUCT SECTION */

    .product-section{

        padding:10px;
    }


    /* PRODUCT CARD */

    .product-card{

        /*
         * Remove desktop columns.
         */
        display:block;

        width:100%;

        padding:10px;

        border-radius:12px;
    }


    /* PRODUCT */

    .product-top{

        display:flex;

        align-items:flex-start;

        gap:10px;

        width:100%;
    }


    /* IMAGE */

    .product-image{

        width:80px;

        height:80px;

        flex:
            0 0 80px;

        border-radius:10px;
    }

    .product-image img{

        padding:6px;
    }


    /* DETAILS */

    .product-details{

        flex:1;

        min-width:0;

        width:auto;
    }

    .product-name{

        margin:0 0 8px;

        font-size:14px;

        line-height:1.3;
    }


    .details-grid{

        grid-template-columns:
            repeat(2,minmax(0,1fr));

        gap:5px;
    }

    .detail-box{

        padding:7px;

        border-radius:7px;
    }

    .detail-label{

        margin-bottom:2px;

        font-size:6px;
    }

    .detail-value{

        font-size:8px;
    }

    .amount{

        font-size:10px;
    }


    /* =====================================================
       STATUS
    ===================================================== */

    .status-panel{

        /*
         * Important:
         * Full width below product information.
         */
        width:100%;

        min-width:0;

        min-height:auto;

        margin-top:10px;

        padding:9px 10px;

        display:flex;

        flex-direction:row;

        align-items:center;

        justify-content:space-between;

        gap:10px;

        border-radius:9px;

        text-align:left;
    }

    .status-label{

        margin:0;

        font-size:7px;

        white-space:nowrap;
    }

    .status-badge{

        padding:5px 9px;

        font-size:7px;
    }


    /* ACTIONS */

    .action-buttons{

        margin-top:8px;

        gap:5px;
    }

    .action-buttons a,
    .action-buttons button{

        padding:7px 9px;

        font-size:8px;

        border-radius:7px;
    }


    /* PROGRESS */

    .progress-section{

        padding:
            14px 8px 18px;

        overflow:hidden;
    }

    .progress-title{

        margin-bottom:22px;

        font-size:9px;
    }

    .progress-title i{

        font-size:12px;
    }

    .progress-line{

        left:9%;

        right:9%;

        top:12px;

        height:3px;
    }

    .progress-circle{

        width:24px;

        height:24px;

        font-size:7px;
    }

    .progress-label{

        margin-top:7px;

        padding:0 2px;

        font-size:5.5px;
    }

    .truck{

        top:-21px;

        font-size:13px;
    }


    /* RATING */

    .rating-section{

        padding:9px;

        gap:6px;
    }

    .rating-title{

        font-size:8px;
    }

    .stars i{

        font-size:16px;
    }
}


/* =========================================================
   SMALL MOBILE
========================================================= */

@media(max-width:480px){

    body{

        padding-top:72px;
    }

    .orders-page{

        padding:
            0 5px;
    }

    .page-header{

        padding:15px;

        border-radius:14px;
    }

    .page-header h1{

        font-size:18px;
    }

    .page-header p{

        font-size:9px;
    }

    .product-card{

        padding:8px;
    }

    .product-top{

        gap:8px;
    }

    .product-image{

        width:68px;

        height:68px;

        flex:
            0 0 68px;
    }

    .product-name{

        font-size:12px;

        margin-bottom:6px;
    }

    .details-grid{

        gap:4px;
    }

    .detail-box{

        padding:6px;
    }

    .detail-label{

        font-size:5.5px;
    }

    .detail-value{

        font-size:7.5px;
    }

    .amount{

        font-size:9px;
    }

    .status-panel{

        margin-top:8px;

        padding:8px;
    }

    .status-label{

        font-size:6px;
    }

    .status-badge{

        padding:4px 7px;

        font-size:6.5px;
    }

    .progress-circle{

        width:21px;

        height:21px;

        font-size:6px;
    }

    .progress-label{

        font-size:4.5px;
    }

    .truck{

        font-size:11px;

        top:-19px;
    }
}


/* =========================================================
   VERY SMALL MOBILE
========================================================= */

@media(max-width:360px){

    .page-header h1{

        font-size:16px;
    }

    .product-image{

        width:62px;

        height:62px;

        flex:
            0 0 62px;
    }

    .product-name{

        font-size:11px;
    }

    .detail-value{

        font-size:7px;
    }

    .status-label{

        font-size:5.5px;
    }

    .status-badge{

        font-size:6px;

        padding:4px 6px;
    }

    .action-buttons a,
    .action-buttons button{

        padding:6px;

        font-size:7px;
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
   SESSION
========================================================= */

String userId =
    (String)session.getAttribute("user_id");

if(userId == null){

    response.sendRedirect("login.jsp");

    return;
}


/* =========================================================
   LOAD ORDERS
========================================================= */

OrderServiceImpl dao =
    new OrderServiceImpl();

List<OrderDetails> orders =
    dao.getAllOrderDetails(userId);

SimpleDateFormat sdf =
    new SimpleDateFormat("dd-MM-yyyy");


/* =========================================================
   TEST PRODUCT
========================================================= */

OrderDetails testOrder = null;

if(orders != null &&
   !orders.isEmpty()){

    /*
     * Only first product/order is used.
     */
    testOrder =
        orders.get(0);
}

%>


<!-- =========================================================
     MAIN PAGE
========================================================= -->

<div class="orders-page">


    <!-- =====================================================
         PAGE HEADER
    ===================================================== -->

    <div class="page-header">

        <div class="page-header-content">

            <h1>

                <i class="bi bi-bag-check-fill"></i>

                My Orders

            </h1>


            <p>

                View your order details and track your delivery.

            </p>


            <div class="order-count">

                <i class="bi bi-flask"></i>

                UI TEST MODE ? Product Card × 5

            </div>

        </div>

    </div>


<%
/* =========================================================
   NO DATA
========================================================= */

if(testOrder == null){

%>


    <div class="empty-orders">

        <div class="empty-icon">

            <i class="bi bi-bag-x"></i>

        </div>


        <h3>
            No Orders Found
        </h3>


        <p>

            There are no orders available for this user.

        </p>

    </div>


<%
}
else{


/* =========================================================
   TEST LOOP
   SAME PRODUCT CARD = 5 TIMES
========================================================= */

for(int testIndex = 1;
    testIndex <= 5;
    testIndex++){


    OrderDetails order =
        testOrder;


    String status =
        order.getStatus();


    if(status == null ||
       status.trim().isEmpty()){

        status = "PLACED";
    }


    status =
        status.trim().toUpperCase();


    String[] steps = {

        "PLACED",
        "CONFIRMED",
        "SHIPPED",
        "OUT FOR DELIVERY",
        "DELIVERED"

    };


    int currentIndex =
        Arrays.asList(steps)
              .indexOf(status);


    if(currentIndex < 0){

        currentIndex = 0;
    }


    boolean cancelled =
        "CANCELLED".equals(status);


    int progress =
        currentIndex * 25;


    if("DELIVERED".equals(status)){

        progress = 100;
    }

%>


    <!-- =====================================================
         ORDER CARD
    ===================================================== -->

    <div class="order-card">


        <!-- =================================================
             ORDER HEADER
        ================================================= -->

        <div class="order-top">


            <div class="order-id">

                <i class="bi bi-receipt"></i>

                Order ID:

                <strong>
                    <%=order.getOrderId()%>
                </strong>


                <span class="test-badge">

                    <i class="bi bi-flask"></i>

                    TEST <%=testIndex%>/5

                </span>

            </div>


            <div class="order-date">

                <%

                if(order.getDatetime() != null){

                %>

                    <i class="bi bi-calendar3"></i>

                    <%=sdf.format(order.getDatetime())%>

                <%

                }
                else{

                %>

                    Date N/A

                <%

                }

                %>

            </div>


        </div>


        <!-- =================================================
             PRODUCT SECTION
        ================================================= -->

        <div class="product-section">


            <!-- =================================================
                 PRODUCT CARD
            ================================================= -->

            <div class="product-card">


                <!-- =============================================
                     LEFT SIDE
                     
                     IMAGE + PRODUCT DETAILS
                ============================================== -->

                <div class="product-top">


                    <!-- PRODUCT IMAGE -->

                    <div class="product-image">

                        <img

                            src="<%=request.getContextPath()%>/ShowImage?pid=<%=order.getProdId()%>"

                            alt="Product"

                            onerror="
                                this.onerror=null;
                                this.src='<%=request.getContextPath()%>/images/noimage.jpg';
                            "

                        >

                    </div>


                    <!-- PRODUCT DETAILS -->

                    <div class="product-details">


                        <h2 class="product-name">

                            <%=order.getProdName()%>

                        </h2>


                        <!-- DETAILS -->

                        <div class="details-grid">


                            <!-- QUANTITY -->

                            <div class="detail-box">

                                <span class="detail-label">

                                    Quantity

                                </span>


                                <span class="detail-value">

                                    <i class="bi bi-box-seam"></i>

                                    <%=order.getQnty()%>

                                </span>

                            </div>


                            <!-- AMOUNT -->

                            <div class="detail-box">

                                <span class="detail-label">

                                    Amount

                                </span>


                                <span class="detail-value amount">

                                    &#8377; <%=order.getAmount()%>

                                </span>

                            </div>


                            <!-- ORDER DATE -->

                            <div class="detail-box">

                                <span class="detail-label">

                                    Order Date

                                </span>


                                <span class="detail-value">

                                <%

                                if(order.getDatetime() != null){

                                %>

                                    <%=sdf.format(order.getDatetime())%>

                                <%

                                }
                                else{

                                %>

                                    N/A

                                <%

                                }

                                %>

                                </span>

                            </div>


                            <!-- DELIVERY DATE -->

                            <div class="detail-box">

                                <span class="detail-label">

                                    Delivery Date

                                </span>


                                <span class="detail-value">

                                <%

                                if(order.getDeliveryDate() != null){

                                %>

                                    <%=sdf.format(order.getDeliveryDate())%>

                                <%

                                }
                                else{

                                %>

                                    N/A

                                <%

                                }

                                %>

                                </span>

                            </div>


                        </div>


                        <!-- =========================================
                             ACTIONS
                        ========================================== -->

                        <div class="action-buttons">


                            <!-- TRACK -->

                            <a

                                href="trackOrder.jsp?orderId=<%=order.getOrderId()%>"

                                class="track-btn"

                            >

                                <i class="bi bi-truck"></i>

                                Track Order

                            </a>


                            <!-- CANCEL -->

                            <%

                            if(
                                status.equals("PLACED") ||
                                status.equals("CONFIRMED")
                            ){

                            %>


                            <button

                                type="button"

                                class="cancel-btn"

                                onclick="
                                    cancelOrder(
                                        '<%=order.getOrderId()%>'
                                    )
                                "

                            >

                                <i class="bi bi-x-circle"></i>

                                Cancel

                            </button>


                            <%

                            }

                            %>


                        </div>


                    </div>


                </div>


                <!-- =============================================
                     RIGHT SIDE
                     
                     CURRENT STATUS
                ============================================== -->

                <div class="status-panel">


                    <span class="status-label">

                        Current Status

                    </span>


                    <span class="
                        status-badge
                        status-<%=status%>
                    ">


                    <%

                    if(status.equals("PLACED")){

                    %>

                        <i class="bi bi-clock-fill"></i>

                    <%

                    }
                    else if(status.equals("CONFIRMED")){

                    %>

                        <i class="bi bi-check-circle-fill"></i>

                    <%

                    }
                    else if(status.equals("SHIPPED")){

                    %>

                        <i class="bi bi-box-seam-fill"></i>

                    <%

                    }
                    else if(status.equalsIgnoreCase("OUT FOR DELIVERY")){

                    %>

                        <i class="bi bi-truck"></i>

                    <%

                    }
                    else if(status.equals("DELIVERED")){

                    %>

                        <i class="bi bi-check2-circle"></i>

                    <%

                    }
                    else if(status.equals("CANCELLED")){

                    %>

                        <i class="bi bi-x-circle-fill"></i>

                    <%

                    }

                    %>


                        <%=status.replace("_"," ")%>


                    </span>


                </div>


            </div>


        </div>


        <!-- =================================================
             PROGRESS
        ================================================= -->

        <%

        if(!cancelled){

        %>


        <div class="progress-section">


            <div class="progress-title">

                <i class="bi bi-activity"></i>

                Order Progress

            </div>


            <div class="progress-track">


                <!-- PROGRESS LINE -->

                <div class="progress-line">

                    <div

                        class="progress-fill"

                        style="
                            width:<%=progress%>%;
                        "

                    ></div>

                </div>


                <!-- TRUCK -->

                <div

                    class="truck"

                    style="
                        left:<%=currentIndex * 25%>%;
                    "

                >

                    <i class="bi bi-truck"></i>

                </div>


<%

for(int i = 0;
    i < steps.length;
    i++){


    boolean done =
        i <= currentIndex;

%>


                <div class="progress-step">


                    <div class="
                        progress-circle
                        <%=done ? "done" : ""%>
                    ">


                    <%

                    if(done){

                    %>

                        <i class="bi bi-check"></i>

                    <%

                    }
                    else{

                    %>

                        <%=i + 1%>

                    <%

                    }

                    %>


                    </div>


                    <span class="
                        progress-label
                        <%=done ? "done" : ""%>
                    ">

                        <%=steps[i].replace("_"," ")%>

                    </span>


                </div>


<%

}

%>


            </div>


        </div>


<%

}


/* =========================================================
   RATING
========================================================= */

if(status.equals("DELIVERED")){

%>


        <div class="rating-section">


            <span class="rating-title">

                <i class="bi bi-star"></i>

                Rate Product:

            </span>


            <div class="stars">


                <i
                    class="bi bi-star-fill"
                    onclick="
                        rate(
                            '<%=order.getProdId()%>',
                            1
                        )
                    "
                    title="1 Star"
                ></i>


                <i
                    class="bi bi-star-fill"
                    onclick="
                        rate(
                            '<%=order.getProdId()%>',
                            2
                        )
                    "
                    title="2 Stars"
                ></i>


                <i
                    class="bi bi-star-fill"
                    onclick="
                        rate(
                            '<%=order.getProdId()%>',
                            3
                        )
                    "
                    title="3 Stars"
                ></i>


                <i
                    class="bi bi-star-fill"
                    onclick="
                        rate(
                            '<%=order.getProdId()%>',
                            4
                        )
                    "
                    title="4 Stars"
                ></i>


                <i
                    class="bi bi-star-fill"
                    onclick="
                        rate(
                            '<%=order.getProdId()%>',
                            5
                        )
                    "
                    title="5 Stars"
                ></i>


            </div>


        </div>


<%

}


/* =========================================================
   END ORDER CARD
========================================================= */

%>


    </div>


<%

} // END 5-TIMES TEST LOOP

}

%>


</div>


<!-- =========================================================
     JAVASCRIPT
========================================================= -->

<script>


/* =========================================================
   CANCEL ORDER
========================================================= */

function cancelOrder(orderId){

    Swal.fire({

        title:"Cancel Order?",

        text:
            "Are you sure you want to cancel this order?",

        icon:"warning",

        showCancelButton:true,

        confirmButtonText:
            "Yes, Cancel",

        cancelButtonText:
            "Keep Order",

        confirmButtonColor:
            "#dc2626",

        cancelButtonColor:
            "#64748b",

        reverseButtons:true

    })
    .then(function(result){

        if(!result.isConfirmed){

            return;
        }


        Swal.fire({

            title:"Cancelling...",

            text:"Please wait.",

            allowOutsideClick:false,

            allowEscapeKey:false,

            didOpen:function(){

                Swal.showLoading();

            }

        });


        fetch(

            "CancelOrderSrv",

            {

                method:"POST",

                headers:{
                    "Content-Type":
                        "application/x-www-form-urlencoded"
                },

                body:
                    "orderId=" +
                    encodeURIComponent(orderId)

            }

        )

        .then(function(response){

            if(!response.ok){

                throw new Error(
                    "HTTP " +
                    response.status
                );
            }

            return response.json();

        })

        .then(function(data){

            if(data.status === "success"){

                Swal.fire({

                    title:"Order Cancelled",

                    text:
                        "Order cancelled successfully.",

                    icon:"success",

                    confirmButtonColor:
                        "#16a34a"

                })
                .then(function(){

                    location.reload();

                });

            }
            else{

                Swal.fire({

                    title:"Unable to Cancel",

                    text:
                        data.message ||
                        "Order could not be cancelled.",

                    icon:"error"

                });

            }

        })

        .catch(function(error){

            console.error(
                "Cancel Order Error:",
                error
            );


            Swal.fire({

                title:"Error",

                text:
                    "Unable to cancel the order.",

                icon:"error"

            });

        });

    });

}


/* =========================================================
   RATE PRODUCT
========================================================= */

function rate(pid, stars){

    fetch(

        "RateProductSrv",

        {

            method:"POST",

            headers:{
                "Content-Type":
                    "application/x-www-form-urlencoded"
            },

            body:
                "pid=" +
                encodeURIComponent(pid) +
                "&rating=" +
                encodeURIComponent(stars)

        }

    )

    .then(function(response){

        if(!response.ok){

            throw new Error(
                "HTTP " +
                response.status
            );
        }

        return response.json();

    })

    .then(function(data){

        if(data.status === "success"){

            Swal.fire({

                title:"Thank You!",

                text:
                    "Your rating has been submitted.",

                icon:"success",

                timer:1800,

                showConfirmButton:false

            });

        }
        else{

            Swal.fire({

                title:"Rating Failed",

                text:
                    data.message ||
                    "Unable to submit rating.",

                icon:"error"

            });

        }

    })

    .catch(function(error){

        console.error(
            "Rating Error:",
            error
        );


        Swal.fire({

            title:"Error",

            text:
                "Unable to submit rating.",

            icon:"error"

        });

    });

}


/* =========================================================
   OPTIONAL AUTO REFRESH
========================================================= */

///*
setInterval(function(){

    location.reload();

},1000*60);



</script>


<!-- =========================================================
     FOOTER
========================================================= -->

<jsp:include page="/footer.html"></jsp:include>


</body>

</html>