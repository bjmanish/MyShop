<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String userName = (String) session.getAttribute("username");
String userId = (String) session.getAttribute("user_id");

boolean isLoggedIn =
        userName != null &&
        !userName.trim().isEmpty();
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1">
    
    <link rel="icon"
      type="image/x-icon"
      href="<%=request.getContextPath()%>/favicon.ico">

<link rel="shortcut icon"
      type="image/x-icon"
      href="<%=request.getContextPath()%>/favicon.ico">

    <title>MYSHOP - Home</title>
   

    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         BOOTSTRAP ICONS
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
        rel="stylesheet">


    <!-- =====================================================
         SWEET ALERT
         ===================================================== -->

    <script
        src="https://cdn.jsdelivr.net/npm/sweetalert2@11">
    </script>


    <!-- =====================================================
         PREVENT THEME FLASH
         ===================================================== -->

    <script>

        (function () {

            const theme =
                localStorage.getItem("myshop-theme");

            if (theme === "dark") {

                document.documentElement
                    .classList.add("dark-loading");

            }

        })();

    </script>


    <!-- =====================================================
         PAGE CSS
         ===================================================== -->

    <style>

    /* =====================================================
       THEME VARIABLES
       ===================================================== */

    :root {

        --page-bg:
            linear-gradient(135deg, #f5f7fa, #e4e8f0);

        --text-color: #212529;

        --secondary-text: #6c757d;

        --card-bg: rgba(255,255,255,0.88);

        --card-border: rgba(0,0,0,0.08);

        --image-bg: #ffffff;

        --old-price: #777;

        --description-link: #5148ff;

        --shadow:
            0 10px 30px rgba(0,0,0,0.12);
    }


    /* =====================================================
       DARK
       ===================================================== */

    body.dark-mode {

        --page-bg:
            linear-gradient(135deg, #0f172a, #111827);

        --text-color: #f8fafc;

        --secondary-text: #cbd5e1;

        --card-bg: rgba(255,255,255,0.08);

        --card-border: rgba(255,255,255,0.12);

        --image-bg: #ffffff;

        --old-price: #cbd5e1;

        --description-link: #67e8f9;

        --shadow:
            0 10px 35px rgba(0,0,0,0.45);
    }


    /* =====================================================
       BODY
       ===================================================== */

    html,
    body {

        margin: 0;

        padding: 0;

        min-height: 100%;

        background: var(--page-bg);

        color: var(--text-color);

        transition:
            background 0.35s ease,
            color 0.35s ease;
    }


    /* =====================================================
       THEME FLASH PROTECTION
       ===================================================== */

    html.dark-loading body {

        background:
            linear-gradient(135deg, #0f172a, #111827);

        color: #f8fafc;
    }


    /* =====================================================
       PRODUCT AREA
       ===================================================== */

    .products-container {

        padding-top: 90px;

        padding-bottom: 40px;
    }


    /* =====================================================
       PAGE TITLE
       ===================================================== */

    .page-title {

        color: var(--text-color);

        font-weight: 800;

        transition: color 0.35s ease;
    }


    /* =====================================================
       PRODUCT CARD
       ===================================================== */

    .product-card {

        background: var(--card-bg);

        backdrop-filter: blur(15px);

        -webkit-backdrop-filter: blur(15px);

        border:

            1px solid

            var(--card-border);

        border-radius: 20px;

        color: var(--text-color);

        transition:

            transform 0.3s ease,

            box-shadow 0.3s ease,

            background 0.35s ease,

            border 0.35s ease;

        padding: 15px;

        overflow: hidden;

        box-shadow: var(--shadow);
    }


    .product-card:hover {

        transform: translateY(-8px);

        box-shadow:
            0 18px 40px rgba(0,0,0,0.22);
    }


    /* =====================================================
       PRODUCT IMAGE
       ===================================================== */

    .product-img {

        width: calc(100% - 20px);

        height: 180px;

        object-fit: contain;

        border-radius: 15px;

        background: var(--image-bg);

        padding: 10px;

        transition:

            transform 0.3s ease,

            box-shadow 0.3s ease;
    }


    .product-card:hover .product-img {

        transform: scale(1.03);
    }


    /* =====================================================
       PRODUCT NAME
       ===================================================== */

    .product-name {

        color: var(--text-color);

        font-weight: 700;

        transition: color 0.35s ease;
    }


    /* =====================================================
       DESCRIPTION
       ===================================================== */

    .product-description {

        color: var(--secondary-text);

        line-height: 1.5;

        transition: color 0.35s ease;
    }


    .description-link {

        color: var(--description-link);

        cursor: pointer;

        text-decoration: none;

        font-weight: 600;
    }


    .description-link:hover {

        text-decoration: underline;
    }


    /* =====================================================
       PRICE
       ===================================================== */

    .price {

        color: #00b86b;

        font-weight: 800;

        font-size: 18px;
    }


    .old-price {

        text-decoration: line-through;

        color: var(--old-price);

        font-size: 13px;
    }


    .discount {

        color: #00b86b;

        font-size: 13px;

        font-weight: 600;
    }


    /* =====================================================
       BUTTONS
       ===================================================== */

    .btn-custom {

        border-radius: 30px;

        font-weight: 600;

        transition:

            transform 0.2s ease,

            box-shadow 0.2s ease;
    }


    .btn-custom:hover {

        transform: translateY(-2px);

        box-shadow:
            0 5px 15px rgba(0,0,0,0.20);
    }


    /* =====================================================
       MOBILE
       ===================================================== */

    @media (max-width: 767px) {

        .products-container {

            padding-top: 100px;
        }

        .product-img {

            height: 150px;
        }

        .product-card {

            padding: 12px;

            border-radius: 16px;
        }

        .price {

            font-size: 16px;
        }
    }


    @media (max-width: 400px) {

        .product-img {

            height: 130px;
        }

        .product-card {

            padding: 10px;
        }
    }

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp" />


<!-- =========================================================
     PRODUCT DATA
     ========================================================= -->

<%

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


if (search != null &&
        !search.trim().isEmpty()) {

    products =
        prodDao.searchAllProducts(search);

    message =
        "Results for '" +
        search +
        "'";

} else if (type != null &&
           !type.trim().isEmpty()) {

    products =
        prodDao.getAllProductsByType(type);

    message =
        "Category: " +
        type;

} else {

    products =
        prodDao.getAllProducts();

}

%>


<!-- =========================================================
     PRODUCT SECTION
     ========================================================= -->

<div class="container products-container">

    <h3
        class="text-center page-title mb-4">

        <%=message%>

    </h3>


    <div class="row g-3 g-md-4">


        <% for (ProductBean product : products) {

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

            double price =
                product.getProdPrice();

            double oldPrice =
                price + 500;

            int discount =
                oldPrice > 0
                ? (int)((500 / oldPrice) * 100)
                : 0;

        %>


        <!-- =================================================
             PRODUCT
             ================================================= -->
         <% for(int i=1; i<=10; i++){ %>
        <div class="col-6 col-md-4 col-lg-3">

            <div
                class="product-card h-100 d-flex flex-column">


                <!-- IMAGE -->

                <img

                    data-src="<%=request.getContextPath()%>/ShowImage?pid=<%=product.getProdId()%>"

                    src="images/loader.gif"

                    class="product-img lazy-img mx-auto mb-3"

                    alt="<%=product.getProdName()%>"

                    loading="lazy"

                    onerror="this.src='images/noimage.jpg';">


                <!-- NAME -->

                <h6
                    class="product-name text-truncate">

                    <%=product.getProdName()%>

                </h6>


                <!-- DESCRIPTION -->

                <p
                    class="small product-description flex-grow-1">

                    <span
                        class="short-description">

                        <%=shortDesc%>

                    </span>


                    <span
                        class="full-description"
                        style="display:none;">

                        <%=desc%>

                    </span>


                    <% if (desc.length() > 80) { %>

                        <a
                            href="javascript:void(0);"
                            class="description-link"
                            onclick="toggleDescription(this)">

                            Read More..

                        </a>

                    <% } %>

                </p>


                <!-- PRICE -->

                <p class="mb-3">

                    <span class="price">

                        &#8377; <%=price%>

                    </span>

                    &nbsp;

                    <span class="old-price">

                        &#8377; <%=oldPrice%>

                    </span>

                    &nbsp;

                    <span class="discount">

                        (<%=discount%>% OFF)

                    </span>

                </p>


                <!-- =================================================
                     LOGGED IN
                     ================================================= -->

                <% if (isLoggedIn) { %>


                    <!-- ADD TO CART -->

                    <a

                        href="<%=request.getContextPath()%>/AddtoCart?pid=<%=product.getProdId()%>"

                        class="btn btn-success btn-sm w-100 mb-2 btn-custom">

                        <i class="bi bi-cart-plus"></i>

                        Add To Cart

                    </a>


                    <!-- BUY NOW -->

                    <a

                        href="<%=request.getContextPath()%>/AddtoCart?prodid=<%=product.getProdId()%>&userid=<%=userId%>"

                        class="btn btn-warning btn-sm w-100 btn-custom">

                        <i class="bi bi-lightning-fill"></i>

                        Buy Now

                    </a>


                <% } else { %>


                    <!-- =================================================
                         GUEST
                         ================================================= -->

                    <button

                        type="button"

                        onclick="showLoginAlert()"

                        class="btn btn-success btn-sm w-100 mb-2 btn-custom">

                        <i class="bi bi-cart-plus"></i>

                        Add To Cart

                    </button>


                    <button

                        type="button"

                        onclick="showLoginAlert()"

                        class="btn btn-warning btn-sm w-100 btn-custom">

                        <i class="bi bi-lightning-fill"></i>

                        Buy Now

                    </button>


                <% } %>


            </div>

        </div>


        <% }} %>


        <!-- NO PRODUCTS -->

        <% if (products == null || products.isEmpty()) { %>

            <div class="col-12">

                <div
                    class="text-center py-5">

                    <i
                        class="bi bi-box-seam"
                        style="font-size:60px;">
                    </i>

                    <h4 class="mt-3">

                        No products found

                    </h4>

                    <p>

                        Try another search or category.

                    </p>

                </div>

            </div>

        <% } %>


    </div>

</div>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html" />


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<!-- =========================================================
     PRODUCT JAVASCRIPT
     ========================================================= -->

<script>

/* =========================================================
   LAZY IMAGE LOADING
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const images =
            document.querySelectorAll(".lazy-img");


        if ("IntersectionObserver" in window) {

            const observer =
                new IntersectionObserver(

                    function (entries, observer) {

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


                                    observer.unobserve(img);

                                }

                            }
                        );

                    },
                    {
                        rootMargin: "100px"
                    }
                );


            images.forEach(
                function (img) {

                    observer.observe(img);

                }
            );


        } else {

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


/* =========================================================
   LOGIN ALERT
   ========================================================= */

function showLoginAlert() {

    Swal.fire({

        icon: "warning",

        title: "Login Required",

        text:
            "Please signup/login first to continue purchase!",

        confirmButtonText:
            "Go to Login",

        cancelButtonText:
            "Cancel",

        showCancelButton:
            true,

        reverseButtons:
            true

    }).then(
        function (result) {

            if (result.isConfirmed) {

                window.location.href =
                    "<%=request.getContextPath()%>/login.jsp";

            }

        }
    );
}


/* =========================================================
   DESCRIPTION TOGGLE
   ========================================================= */

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
        fullDesc.style.display ===
        "none"
    ) {

        shortDesc.style.display =
            "none";

        fullDesc.style.display =
            "inline";

        link.innerText =
            "Read Less";

    } else {

        shortDesc.style.display =
            "inline";

        fullDesc.style.display =
            "none";

        link.innerText =
            "Read More..";

    }

}

</script>


</body>

</html>