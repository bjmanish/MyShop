<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <title>View Products</title>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <!-- Bootstrap 3 -->
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <!-- jQuery -->
    <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js">
    </script>

    <!-- Bootstrap JS -->
    <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js">
    </script>


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
            margin: 10px;
            padding: 10px;
            overflow-x: hidden;
        }

        body {

            background: linear-gradient(
                135deg,
                #111827,
                #1f2937
            );

            color: white;

            font-family:
                Arial,
                Helvetica,
                sans-serif;
        }


        /* =====================================================
           PRODUCT CONTAINER
        ===================================================== */

        .product-container {

            width: 100%;

            padding-top: 30px;

            padding-bottom: 35px;

            /*margin: 0 auto;*/
        }


        .product-container h4 {

            margin-top: 50px;

            margin-bottom: 25px;

            padding: 0 10px;

            font-weight: bold;

            line-height: 1.5;

            word-break: break-word;
        }


        /* =====================================================
           PRODUCT ROW
        ===================================================== */

        .product-row {

            display: flex;

            flex-wrap: wrap;

            width: 100%;

            margin-left: -7px;

            margin-right: -7px;
        }


        .product-column {

            padding-left: 7px;

            padding-right: 7px;

            margin-bottom: 25px;

            display: flex;
        }


        /* =====================================================
           PRODUCT CARD
        ===================================================== */

        .product-card {

            background: rgba(
                255,
                255,
                255,
                0.10
            );

            backdrop-filter: blur(15px);

            -webkit-backdrop-filter: blur(15px);

            border-radius: 20px;

            padding: 15px;

            width: 100%;

            min-height: 100%;

            display: flex;

            flex-direction: column;

            border: 1px solid rgba(
                255,
                255,
                255,
                0.08
            );

            transition:
                transform 0.3s ease,
                box-shadow 0.3s ease;
        }


        .product-card:hover {

            transform: translateY(-6px);

            box-shadow:
                0 10px 30px
                rgba(0, 0, 0, 0.40);
        }


        /* =====================================================
           PRODUCT IMAGE
        ===================================================== */

        .product-img {

            width: 100%;

            height: 180px;

            object-fit: contain;

            display: block;

            background: white;

            padding: 10px;

            border-radius: 15px;

            flex-shrink: 0;
        }


        /* =====================================================
           PRODUCT NAME
        ===================================================== */

        .product-card h6 {

            font-size: 16px;

            font-weight: 600;

            line-height: 1.4;

            margin-top: 12px;

            margin-bottom: 8px;

            word-break: break-word;

            overflow-wrap: anywhere;
        }


        /* =====================================================
           PRODUCT DESCRIPTION
        ===================================================== */

        .product-card p {

            line-height: 1.5;

            word-break: break-word;

            overflow-wrap: anywhere;
        }


        .short-description,
        .full-description {

            word-break: break-word;

            overflow-wrap: anywhere;
        }


        .read-more {

            color: #00ffcc;

            cursor: pointer;

            text-decoration: none;

            white-space: nowrap;

            font-size: 12px;
        }


        .read-more:hover {

            color: #ffffff;

            text-decoration: underline;
        }


        /* =====================================================
           PRICE
        ===================================================== */

        .price {

            color: #00ff88;

            font-weight: bold;

            font-size: 17px;
        }


        .old-price {

            text-decoration: line-through;

            color: #cccccc;

            font-size: 13px;

            margin-left: 5px;
        }


        .discount {

            color: #00ff88;

            font-size: 13px;

            margin-left: 3px;
        }


        /* =====================================================
           BUTTON AREA
        ===================================================== */

        .btn-custom {

            width: 100%;

            margin-top: auto;

            padding-top: 5px;
        }


        .btn-custom .btn {

            width: 100%;

            border-radius: 30px;

            font-weight: 500;

            min-height: 34px;

            font-size: 14px;

            margin-bottom: 8px;

            transition:
                transform 0.2s ease;
        }


        .btn-custom .btn:hover {

            transform: scale(1.02);
        }


        /* =====================================================
           TABLET
        ===================================================== */

        @media (max-width: 991px) {

            .product-container {

                padding-top: 30px;

                padding-left: 10px;

                padding-right: 10px;
            }


            .product-img {

                height: 170px;
            }


            .product-card {

                padding: 13px;

                border-radius: 17px;
            }


            .product-card h6 {

                font-size: 15px;
            }


            .product-card p {

                font-size: 13px;
            }


            .price {

                font-size: 16px;
            }

        }


        /* =====================================================
           MOBILE
        ===================================================== */

        @media (max-width: 767px) {

            html,
            body {

                width: 100%;

                min-width: 320px;

                margin: 0;

                padding: 0;

                overflow-x: hidden;
            }


            /*
             * IMPORTANT:
             * Header.jsp is above this container.
             *
             * Keep enough top padding so the first
             * product row does not go underneath
             * the mobile header.
             */

            .product-container {

                width: 100%;

                padding-top: 75px;

                padding-left: 8px;

                padding-right: 8px;

                padding-bottom: 25px;

                margin: 0;
            }


            .product-container h4 {

                font-size: 18px;

                margin-top: 0;

                margin-bottom: 18px;

                padding: 0 5px;

                line-height: 1.4;
            }


            .product-row {

                width: 100%;

                margin-left: -4px;

                margin-right: -4px;
            }


            .product-column {

                padding-left: 4px;

                padding-right: 4px;

                margin-bottom: 15px;

                display: flex;
            }


            .product-card {

                width: 100%;

                padding: 10px;

                border-radius: 15px;

                min-height: 100%;

                overflow: hidden;
            }


            .product-img {

                width: 100%;

                height: 145px;

                padding: 7px;

                border-radius: 12px;
            }


            .product-card h6 {

                font-size: 14px;

                margin-top: 9px;

                margin-bottom: 6px;

                line-height: 1.35;
            }


            .product-card p {

                font-size: 12px;

                line-height: 1.45;

                margin-bottom: 8px;
            }


            .price {

                font-size: 15px;
            }


            .old-price {

                font-size: 11px;

                margin-left: 3px;
            }


            .discount {

                font-size: 11px;

                margin-left: 2px;
            }


            .read-more {

                font-size: 11px;
            }


            .btn-custom {

                width: 100%;

                padding-top: 2px;
            }


            .btn-custom .btn {

                width: 100%;

                min-height: 34px;

                padding: 7px 8px;

                font-size: 12px;

                margin-bottom: 5px;
            }

        }


        /* =====================================================
           SMALL MOBILE
        ===================================================== */

        @media (max-width: 480px) {

            .product-container {

                /*
                 * Header-safe spacing.
                 *
                 * IMPORTANT:
                 * No "margin: 100px 50px".
                 */

                padding-top: 70px;

                padding-left: 6px;

                padding-right: 6px;

                padding-bottom: 20px;

                margin: 0;
            }


            .product-container h4 {

                font-size: 16px;

                margin-bottom: 15px;

                padding: 0 4px;
            }


            .product-row {

                margin-left: -3px;

                margin-right: -3px;
            }


            .product-column {

                padding-left: 3px;

                padding-right: 3px;

                margin-bottom: 12px;
            }


            .product-card {

                padding: 8px;

                border-radius: 12px;
            }


            .product-img {

                height: 120px;

                padding: 5px;

                border-radius: 10px;
            }


            .product-card h6 {

                font-size: 12px;

                margin-top: 7px;

                margin-bottom: 5px;

                line-height: 1.3;
            }


            .product-card p {

                font-size: 10px;

                line-height: 1.4;

                margin-bottom: 6px;
            }


            .price {

                font-size: 13px;
            }


            .old-price,
            .discount {

                font-size: 9px;
            }


            .read-more {

                font-size: 10px;
            }


            .btn-custom .btn {

                font-size: 10px;

                padding: 6px 5px;

                min-height: 32px;
            }

        }


        /* =====================================================
           VERY SMALL MOBILE
        ===================================================== */

        @media (max-width: 360px) {

            .product-container {

                padding-top: 65px;

                padding-left: 5px;

                padding-right: 5px;
            }


            .product-container h4 {

                font-size: 15px;

                margin-bottom: 12px;
            }


            .product-row {

                margin-left: -2px;

                margin-right: -2px;
            }


            .product-column {

                padding-left: 2px;

                padding-right: 2px;

                margin-bottom: 10px;
            }


            .product-card {

                padding: 7px;

                border-radius: 11px;
            }


            .product-img {

                height: 105px;

                padding: 4px;
            }


            .product-card h6 {

                font-size: 11px;
            }


            .product-card p {

                font-size: 9px;
            }


            .price {

                font-size: 12px;
            }


            .old-price,
            .discount {

                font-size: 8px;
            }


            .btn-custom .btn {

                font-size: 9px;

                padding: 5px 3px;

                min-height: 30px;
            }

        }

    </style>

</head>


<body>


<%

    /* =====================================================
       USER SESSION CHECK
    ===================================================== */

    String userName =
        (String) session.getAttribute("username");

    String sid =
        (String) session.getAttribute("sessionId");

    String userType =
        (String) session.getAttribute("role");


    System.out.println(
        "Session ID: " + session.getId()
    );


    if (userType == null ||
        !userType.equalsIgnoreCase("admin")) {

        response.sendRedirect(
            "login.jsp?message=Access Denied, Login as admin!!"
        );

        return;

    }


    if (userName == null ||
        sid == null) {

        response.sendRedirect(
            "login.jsp?message=Session Expired, Login Again!!"
        );

        return;

    }


    /* =====================================================
       PRODUCT SERVICE
    ===================================================== */

    ProductServiceImpl prodDao =
        new ProductServiceImpl();


    List<ProductBean> products =
        new ArrayList<>();


    String search =
        request.getParameter("search");


    String type =
        request.getParameter("type");


    String message =
        "All Products";


    /* =====================================================
       SEARCH
    ===================================================== */

    if (search != null &&
        !search.trim().isEmpty()) {

        products =
            prodDao.searchAllProducts(search);


        message =
            "Showing Results for '" +
            search +
            "'";

    }


    /* =====================================================
       TYPE FILTER
    ===================================================== */

    else if (type != null &&
             !type.trim().isEmpty()) {

        products =
            prodDao.getAllProductsByType(type);


        message =
            "Showing Results for '" +
            type +
            "'";

    }


    /* =====================================================
       ALL PRODUCTS
    ===================================================== */

    else {

        products =
            prodDao.getAllProducts();

    }


    /* =====================================================
       NO RESULT
    ===================================================== */

    if (products == null ||
        products.isEmpty()) {

        message =
            "No items found for the search '" +
            (search != null
                ? search
                : type) +
            "'";


        /*
         * Preserve your original behavior:
         * show all products when search has no result.
         */

        products =
            prodDao.getAllProducts();

    }

%>


<!-- =====================================================
     HEADER
===================================================== -->

<jsp:include page="/header.jsp" />


<!-- =====================================================
     MAIN PRODUCT CONTAINER
===================================================== -->

<div class="container-fluid product-container">


    <!-- PAGE TITLE -->

    <h4 class="text-center fw-bold">

        <%=message%>

    </h4>


    <!-- =================================================
         PRODUCT ROW
    ================================================= -->

    <div class="row product-row">


<%

    if (products != null &&
        !products.isEmpty()) {


        for (ProductBean product : products) {


            /* =============================================
               DESCRIPTION
            ============================================= */

            String desc =
                product.getProdInfo() != null
                ? product.getProdInfo()
                : "";


            String shortDesc =
                desc.substring(
                    0,
                    Math.min(
                        desc.length(),
                        80
                    )
                );


            /* =============================================
               PRICE
            ============================================= */

            double price =
                product.getProdPrice();


            double oldPrice =
                price + 500;


            int discount =
                (int)
                ((500 / oldPrice) * 100);

%>


        <!-- =============================================
             PRODUCT COLUMN

             Desktop:
             col-lg-3  = 4 products

             Tablet:
             col-md-4  = 3 products

             Small:
             col-sm-6  = 2 products

             Mobile:
             col-xs-6  = 2 products
        ============================================= -->
        <% for(int i=1; i<=10; i++){ %>
        <div class="
            col-lg-3
            col-md-4
            col-sm-6
            col-xs-6
            product-column
        ">


            <!-- PRODUCT CARD -->
            
            

            <div class="product-card">


                <!-- =====================================
                     PRODUCT IMAGE
                ====================================== -->

                <img

                    data-src="<%=request.getContextPath()%>/ShowImage?pid=<%=product.getProdId()%>"

                    src="<%=request.getContextPath()%>/images/loader.gif"

                    class="product-img lazy-img"

                    alt="<%=product.getProdName()%>"

                    loading="lazy"

                    onerror="
                        this.onerror=null;
                        this.src='<%=request.getContextPath()%>/images/noimage.jpg';
                    "
                >


                <!-- =====================================
                     PRODUCT NAME
                ====================================== -->

                <h6
                    class="text-truncate"
                    title="<%=product.getProdName()%>"
                >

                    <%=product.getProdName()%>

                </h6>


                <!-- =====================================
                     DESCRIPTION
                ====================================== -->

                <p class="small">


                    <!-- SHORT DESCRIPTION -->

                    <span class="short-description">

                        <%=shortDesc%>

                    </span>


                    <!-- FULL DESCRIPTION -->

                    <span
                        class="full-description"
                        style="display:none;"
                    >

                        <%=desc%>

                    </span>


                    <!-- READ MORE -->

                    <% if(desc.length() > 80){ %>

                        <a
                            href="javascript:void(0);"
                            class="read-more"
                            onclick="toggleDescription(this)"
                        >

                            Read More..

                        </a>

                    <% } %>


                </p>


                <!-- =====================================
                     PRICE
                ====================================== -->

                <p>

                    <span class="price">

                        ₹ <%=price%>

                    </span>


                    <span class="old-price">

                        ₹ <%=oldPrice%>

                    </span>


                    <span class="discount">

                        (<%=discount%>% OFF)

                    </span>

                </p>


                <!-- =====================================
                     BUTTONS
                ====================================== -->

                <div class="btn-custom">


                    <!-- UPDATE PRODUCT -->

                    <a
                        href="updateProduct.jsp?pid=<%=product.getProdId()%>&userid=<%=userName%>"
                        class="btn btn-success"
                    >

                        Update Product

                    </a>


                    <!-- REMOVE PRODUCT -->

                    <a
                        href="removeProduct.jsp?prodid=<%=product.getProdId()%>&userid=<%=userName%>"
                        class="btn btn-warning"
                    >

                        Remove Product

                    </a>


                </div>


            </div>
           

        </div>
        <%}%>                 

<%

        }

    }

%>


    </div>

</div>


<!-- =====================================================
     FOOTER
===================================================== -->

<jsp:include page="/footer.html" />


<!-- =====================================================
     JAVASCRIPT
===================================================== -->

<script>


/* =====================================================
   LAZY LOAD PRODUCT IMAGES
===================================================== */

document.addEventListener(
    "DOMContentLoaded",
    function () {


        const images =
            document.querySelectorAll(
                ".lazy-img"
            );


        if (
            "IntersectionObserver"
            in window
        ) {


            const observer =
                new IntersectionObserver(

                    function (
                        entries,
                        observer
                    ) {


                        entries.forEach(
                            function (entry) {


                                if (
                                    entry.isIntersecting
                                ) {


                                    const img =
                                        entry.target;


                                    const realSrc =
                                        img.getAttribute(
                                            "data-src"
                                        );


                                    if (realSrc) {

                                        img.src =
                                            realSrc;

                                    }


                                    img.onload =
                                        function () {

                                            img.classList.add(
                                                "loaded"
                                            );

                                        };


                                    observer.unobserve(
                                        img
                                    );

                                }

                            }
                        );

                    },

                    {
                        rootMargin: "150px"
                    }

                );


            images.forEach(
                function (img) {

                    observer.observe(img);

                }
            );


        }

        else {


            /* =========================================
               FALLBACK FOR OLDER BROWSERS
            ========================================= */

            images.forEach(
                function (img) {

                    img.src =
                        img.getAttribute(
                            "data-src"
                        );

                }
            );

        }

    }
);


/* =====================================================
   DESCRIPTION TOGGLE
===================================================== */

function toggleDescription(link) {


    const parent =
        link.parentElement;


    const shortDesc =
        parent.querySelector(
            ".short-description"
        );


    const fullDesc =
        parent.querySelector(
            ".full-description"
        );


    if (
        shortDesc.style.display ===
        "none"
    ) {


        /* SHOW SHORT */

        shortDesc.style.display =
            "inline";


        /* HIDE FULL */

        fullDesc.style.display =
            "none";


        link.innerText =
            "Read More..";

    }

    else {


        /* HIDE SHORT */

        shortDesc.style.display =
            "none";


        /* SHOW FULL */

        fullDesc.style.display =
            "inline";


        link.innerText =
            "Read Less";

    }

}

</script>


</body>

</html>