<%@page import="com.myshop.service.impl.*"%>
<%@page import="com.myshop.beans.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>MyShop - Home</title>

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <link rel="shortcut icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">

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
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- =====================================================
         SWEET ALERT
         ===================================================== -->

    <script
        src="https://cdn.jsdelivr.net/npm/sweetalert2@11">
    </script>


    <!-- =====================================================
         THEME FLASH PROTECTION
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
           LIGHT THEME
           ===================================================== */

        :root {

            --body-bg:
                linear-gradient(
                    135deg,
                    #f8fafc,
                    #e2e8f0
                );

            --body-text:
                #212529;

            --heading:
                #111827;

            --card-bg:
                #ffffff;

            --card-text:
                #212529;

            --card-border:
                #e5e7eb;

            --description:
                #6b7280;

            --old-price:
                #888888;

            --shadow:
                0 8px 25px
                rgba(0,0,0,0.10);
        }


        /* =====================================================
           DARK THEME
           ===================================================== */

        body.dark-mode {

            --body-bg:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #111827
                );

            --body-text:
                #f8fafc;

            --heading:
                #ffffff;

            --card-bg:
                #1e293b;

            --card-text:
                #f8fafc;

            --card-border:
                #334155;

            --description:
                #cbd5e1;

            --old-price:
                #94a3b8;

            --shadow:
                0 12px 35px
                rgba(0,0,0,0.45);
        }


        /* =====================================================
           BODY
           ===================================================== */

        html,
        body {

            margin-top: 80px;

            padding: 0;

            min-height: 100%;
        }


        body {

            min-height: 100vh;

            background:
                var(--body-bg) !important;

            color:
                var(--body-text) !important;

            transition:
                background 0.3s ease,
                color 0.3s ease;
        }


        /* =====================================================
           REMOVE LOADING
           ===================================================== */

        html.dark-loading {

            background:
                #0f172a;
        }


        /* =====================================================
           HOME CONTAINER
           ===================================================== */

        .home-container {

            min-height: 500px;

            padding-top: 40px;

            padding-bottom: 60px;
        }


        /* =====================================================
           TITLE
           ===================================================== */

        .home-title {

            color:
                var(--heading) !important;

            font-weight: 700;

            font-size: 28px;
        }


        /* =====================================================
           PRODUCT CARD
           ===================================================== */

        .product-card {

            height: 100%;

            padding: 15px;

            background:
                var(--card-bg) !important;

            color:
                var(--card-text) !important;

            border:
                1px solid
                var(--card-border);

            border-radius: 20px;

            box-shadow:
                var(--shadow);

            transition:
                all 0.3s ease;
        }


        .product-card:hover {

            transform:
                translateY(-8px);

            box-shadow:
                0 18px 40px
                rgba(0,0,0,0.25);
        }


        /* =====================================================
           IMAGE
           ===================================================== */

        .product-img {

            width: 100%;

            height: 180px;

            object-fit: contain;

            background:
                #ffffff !important;

            border-radius: 12px;

            padding: 10px;
        }


        /* =====================================================
           PRODUCT NAME
           ===================================================== */

        .product-name {

            color:
                var(--heading) !important;

            font-weight: 600;

            font-size: 16px;

            margin-bottom: 8px;
        }


        /* =====================================================
           DESCRIPTION
           ===================================================== */

        .product-description {

            color:
                var(--description) !important;

            font-size: 14px;

            min-height: 42px;
        }


        /* =====================================================
           PRICE
           ===================================================== */

        .price {

            color:
                #16a34a !important;

            font-size: 18px;

            font-weight: 700;
        }


        .old-price {

            color:
                var(--old-price) !important;

            text-decoration:
                line-through;

            font-size: 13px;

            margin-left: 6px;
        }


        /* =====================================================
           BUTTONS
           ===================================================== */

        .btn-custom {

            border-radius:
                30px !important;

            font-weight: 600;

            padding:
                9px 15px;
        }


        /* =====================================================
           NO PRODUCTS
           ===================================================== */

        .no-products {

            background:
                var(--card-bg);

            color:
                var(--description);

            border:
                1px solid
                var(--card-border);

            border-radius:
                20px;

            padding:
                50px;

            text-align:
                center;
        }


        .no-products h5 {

            color:
                var(--heading);
        }


        /* =====================================================
           TOAST
           ===================================================== */

        .toast-msg {

            position:
                fixed;

            bottom:
                20px;

            right:
                20px;

            background:
                #198754;

            color:
                #ffffff !important;

            padding:
                12px 20px;

            border-radius:
                10px;

            z-index:
                99999;

            box-shadow:
                0 5px 20px
                rgba(0,0,0,0.3);
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 576px) {

            .home-container {

                padding-top:
                    25px;
            }


            .home-title {

                font-size:
                    22px;
            }


            .product-card {

                padding:
                    12px;

                border-radius:
                    16px;
            }


            .product-img {

                height:
                    150px;
            }


            .product-name {

                font-size:
                    14px;
            }


            .product-description {

                font-size:
                    12px;
            }


            .price {

                font-size:
                    16px;
            }


            .old-price {

                font-size:
                    11px;
            }

        }

    </style>

</head>


<body>


    <!-- =====================================================
         APPLY THEME
         ===================================================== -->

    <script>

        (function () {

            const theme =
                localStorage.getItem("myshop-theme");

            if (theme === "dark") {

                document.body
                    .classList.add("dark-mode");

            }

            document.documentElement
                .classList.remove("dark-loading");

        })();

    </script>


    <!-- =====================================================
         HEADER
         ===================================================== -->

    <jsp:include page="/header.jsp"/>


    <%

        String userId =
            (String) session.getAttribute("user_id");

        boolean isLoggedIn =
            userId != null &&
            !userId.trim().isEmpty();


        ProductServiceImpl prodDao =
            new ProductServiceImpl();


        List<ProductBean> products =
            prodDao.getAllProducts();


        /*
         * =====================================================
         * CART PRODUCT CHECK
         * =====================================================
         *
         * Store product IDs that already exist in the
         * logged-in user's cart.
         *
         * Example:
         *
         * cartProductIds = [P001, P005, P009]
         *
         * Then when displaying P005:
         *
         * productInCart = true
         *
         */

        Set<String> cartProductIds =
            new HashSet<>();


        String cartId =
            (String) session.getAttribute("cartId");


        if (isLoggedIn) {

            try {

                CartServiceImpl cartService =
                    new CartServiceImpl();


                /*
                 * If cartId is not available in session,
                 * get/create it for this user.
                 */

                if (cartId == null ||
                    cartId.trim().isEmpty()) {

                    cartId =
                        cartService.getOrCreateCart(
                            userId
                        );

                    session.setAttribute(
                        "cartId",
                        cartId
                    );
                }


                /*
                 * Get all cart items.
                 */

                if (cartId != null &&
                    !cartId.trim().isEmpty()) {

                    List<CartBean> cartItems =
                        cartService.getAllCartItems(
                            cartId
                        );


                    if (cartItems != null) {

                        for (CartBean item :
                             cartItems) {

                            if (item != null &&
                                item.getProdId() != null &&
                                !item.getProdId()
                                    .trim()
                                    .isEmpty()) {


                                /*
                                 * Only consider the product
                                 * as present when quantity > 0.
                                 */

                                if (item.getQuantity() > 0) {

                                    cartProductIds.add(
                                        item.getProdId()
                                            .trim()
                                    );
                                }

                            }

                        }

                    }

                }

            } catch (Exception e) {

                /*
                 * Do not break the home page if cart
                 * lookup fails.
                 */

                System.err.println(
                    "Unable to load cart products: "
                    + e.getMessage()
                );

            }

        }

    %>


    <!-- =====================================================
         HOME
         ===================================================== -->

    <main class="container home-container">


        <h3 class="text-center home-title mb-4">

            Explore Products

        </h3>


        <div class="row g-4">


            <%

                if (products != null &&
                    !products.isEmpty()) {


                    for (ProductBean product :
                         products) {


                        String desc =
                            product.getProdInfo() != null
                            ? product.getProdInfo()
                            : "";


                        String shortDesc =
                            desc.substring(
                                0,
                                Math.min(
                                    desc.length(),
                                    70
                                )
                            );


                        double price =
                            product.getProdPrice();


                        double oldPrice =
                            price + 500;


                        /*
                         * =================================================
                         * PRODUCT ID
                         * =================================================
                         */

                        String productId =
                            product.getProdId();


                        /*
                         * =================================================
                         * CHECK IF PRODUCT EXISTS IN CART
                         * =================================================
                         */

                        boolean productInCart =
                            productId != null
                            &&
                            cartProductIds.contains(
                                productId.trim()
                            );

            %>


            <!-- =================================================
                 PRODUCT
                 ================================================= -->

            <% for (int i = 1; i <= 10; i++) { %>


            <div
                class="col-xl-3
                       col-lg-3
                       col-md-4
                       col-sm-6
                       col-12">


                <div
                    class="product-card
                           d-flex
                           flex-column">


                    <!-- IMAGE -->

                    <img
                        src="<%=request.getContextPath()%>/ShowImage?pid=<%=product.getProdId()%>"
                        class="product-img mb-3"
                        alt="<%=product.getProdName()%>"
                        loading="lazy">


                    <!-- NAME -->

                    <h6 class="product-name">

                        <%=product.getProdName()%>

                    </h6>


                    <!-- DESCRIPTION -->

                    <p class="product-description">

                        <%=shortDesc%><%=desc.length() > 70 ? "..." : ""%>

                    </p>


                    <!-- PRICE -->

                    <p class="mb-3">

                        <span class="price">

                            &#8377;
                            <%=price%>

                        </span>


                        <span class="old-price">

                            &#8377;
                            <%=oldPrice%>

                        </span>

                    </p>


                    <!-- =================================================
                         BUTTONS
                         ================================================= -->

                    <div class="mt-auto">


                        <%

                            if (isLoggedIn) {

                                /*
                                 * =================================================
                                 * PRODUCT ALREADY IN CART
                                 * =================================================
                                 */

                                if (productInCart) {

                        %>


                        <button
                            type="button"
                            class="btn btn-primary
                                   w-100
                                   mb-2
                                   btn-custom"
                            onclick="goToCart()">

                            <i class="bi bi-cart-check me-1"></i>

                            Go to Cart

                        </button>


                        <%

                                } else {

                                    /*
                                     * =================================================
                                     * PRODUCT NOT IN CART
                                     * =================================================
                                     */

                        %>


                        <button
                            type="button"
                            class="btn btn-success
                                   w-100
                                   mb-2
                                   btn-custom"
                            onclick="addToCart(
                                '<%=product.getProdId()%>',
                                this
                            )">

                            <i class="bi bi-cart-plus me-1"></i>

                            Add to Cart

                        </button>


                        <%

                                }

                        %>


                        <!-- =================================================
                             BUY NOW
                             ================================================= -->

                        <button
                            type="button"
                            class="btn btn-warning
                                   w-100
                                   btn-custom"
                            onclick="buyNow(
                                '<%=product.getProdId()%>',
                                '<%=price%>'
                            )">

                            <i class="bi bi-lightning-charge me-1"></i>

                            Buy Now

                        </button>


                        <%

                            } else {

                        %>


                        <!-- =================================================
                             NOT LOGGED IN
                             ================================================= -->

                        <button
                            type="button"
                            class="btn btn-success
                                   w-100
                                   mb-2
                                   btn-custom"
                            onclick="showLoginAlert()">

                            <i class="bi bi-cart-plus me-1"></i>

                            Add to Cart

                        </button>


                        <button
                            type="button"
                            class="btn btn-warning
                                   w-100
                                   btn-custom"
                            onclick="showLoginAlert()">

                            <i class="bi bi-lightning-charge me-1"></i>

                            Buy Now

                        </button>


                        <%

                            }

                        %>


                    </div>


                </div>

            </div>


            <%

                    }

                }


            } else {

            %>


            <!-- =================================================
                 NO PRODUCTS
                 ================================================= -->

            <div class="col-12">

                <div class="no-products">

                    <h5>

                        No Products Available

                    </h5>


                    <p class="mb-0">

                        Please check again later.

                    </p>

                </div>

            </div>


            <%

                }

            %>


        </div>

    </main>


    <!-- =====================================================
         FOOTER
         ===================================================== -->

    <jsp:include page="/footer.html"/>


    <!-- =====================================================
         BOOTSTRAP JS
         ===================================================== -->

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>


    <!-- =====================================================
         PAGE JAVASCRIPT
         ===================================================== -->

    <script>


        /* =================================================
           ADD TO CART
           ================================================= */

        function addToCart(pid, btn) {


            if (!btn) {

                return;

            }


            btn.disabled = true;


            /*
             * Save the current button text.
             * This is only used if the request fails.
             */

            const oldText =
                btn.innerHTML;


            btn.innerHTML =
                '<span class="spinner-border spinner-border-sm me-1"></span> Adding...';


            fetch(
                "<%=request.getContextPath()%>/AddtoCart",
                {

                    method: "POST",

                    headers: {

                        "Content-Type":
                            "application/x-www-form-urlencoded"

                    },

                    body:
                        "pid=" +
                        encodeURIComponent(pid) +
                        "&pqty=1"

                }
            )


            .then(function(response) {


                if (!response.ok) {

                    throw new Error(
                        "Add to cart failed"
                    );

                }


                return response.text();

            })


            .then(function(response) {


                console.log(
                    "AddtoCart:",
                    response
                );


                /*
                 * =================================================
                 * SUCCESS
                 * =================================================
                 *
                 * Do NOT restore Add to Cart.
                 *
                 * Change the button permanently to Go to Cart.
                 */

                btn.disabled = false;


                btn.classList.remove(
                    "btn-success"
                );


                btn.classList.add(
                    "btn-primary"
                );


                btn.innerHTML =
                    '<i class="bi bi-cart-check me-1"></i> Go to Cart';


                /*
                 * Replace the old Add to Cart action.
                 */

                btn.onclick =
                    function () {

                        goToCart();

                    };


                showToast(
                    "Product added to cart"
                );


                /*
                 * Update header cart count if
                 * loadCartCount() exists.
                 */

                if (
                    typeof loadCartCount ===
                    "function"
                ) {

                    loadCartCount();

                }


            })


            .catch(function(error) {


                console.error(
                    error
                );


                /*
                 * Restore the original button
                 * only when adding fails.
                 */

                btn.disabled = false;


                btn.innerHTML =
                    oldText;


                Swal.fire({

                    icon: "error",

                    title: "Error",

                    text:
                        "Unable to add product to cart."

                });

            });

        }


        /* =================================================
           GO TO CART
           ================================================= */

        function goToCart() {


            /*
             * Change this path if your actual
             * cart JSP is somewhere else.
             */

            window.location.href =
                "<%=request.getContextPath()%>/user/cart.jsp?cartId=<%=cartId%>&uid=<%=userId%>";

        }


        /* =================================================
           BUY NOW
           ================================================= */

        function buyNow(pid, price) {


            fetch(
                "<%=request.getContextPath()%>/PaymentServlet",
                {

                    method: "POST",

                    headers: {

                        "Content-Type":
                            "application/x-www-form-urlencoded"

                    },

                    body:
                        "pid=" +
                        encodeURIComponent(pid) +

                        "&pqty=1" +

                        "&amount=" +
                        encodeURIComponent(price) +

                        "&buyNow=true"

                }

            )


            .then(function(response) {


                console.log(
                    "Payment response:",
                    response.status
                );


            })


            .catch(function(error) {


                console.error(
                    "Buy Now:",
                    error
                );


                Swal.fire({

                    icon: "error",

                    title: "Payment Error",

                    text:
                        "Unable to continue with payment."

                });

            });

        }


        /* =================================================
           TOAST
           ================================================= */

        function showToast(message) {


            const toast =
                document.createElement("div");


            toast.className =
                "toast-msg";


            toast.innerText =
                message;


            document.body.appendChild(
                toast
            );


            setTimeout(function() {

                toast.remove();

            }, 2000);

        }


        /* =================================================
           LOGIN ALERT
           ================================================= */

        function showLoginAlert() {


            Swal.fire({

                icon: "warning",

                title: "Login Required",

                text:
                    "Please login first",

                confirmButtonText:
                    "Login"

            })


            .then(function() {


                window.location.href =
                    "<%=request.getContextPath()%>/login.jsp";

            });

        }


    </script>


</body>

</html>
