<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%@ page import="com.myshop.utility.idUtil" %>
<%@ page import="com.myshop.service.impl.*" %>
<%@ page import="com.myshop.beans.*" %>


<%
String userName =
        (String) session.getAttribute("username");

String password =
        (String) session.getAttribute("sessionId");

String userType =
        (String) session.getAttribute("role");

String userId =
        (String) session.getAttribute("user_id");

/* Support old session attribute */
if (userId == null) {
    userId =
        (String) session.getAttribute("userId");
}


/* ============================================================
   SESSION EXPIRED
   ============================================================ */

if (userName == null ||
    password == null ||
    userType == null ||
    userId == null) {

    String msg =
        URLEncoder.encode(
            "Your login session has expired. Please login again.",
            StandardCharsets.UTF_8.name()
        );

    response.sendRedirect(
        request.getContextPath()
        + "/login.jsp?message="
        + msg
    );

    return;
}


/* ============================================================
   CUSTOMER ACCESS
   ============================================================ */

if (!"CUSTOMER".equalsIgnoreCase(userType) &&
    !"USER".equalsIgnoreCase(userType)) {

    String msg =
        URLEncoder.encode(
            "Access denied. Please login with a customer account.",
            StandardCharsets.UTF_8.name()
        );

    response.sendRedirect(
        request.getContextPath()
        + "/login.jsp?message="
        + msg
    );

    return;
}


/* ============================================================
   REQUEST PARAMETERS
   ============================================================ */

String cartId =
        request.getParameter("cartId");

String message =
        request.getParameter("message");

String add =
        request.getParameter("add");

String pid =
        request.getParameter("pid");

String uid =
        request.getParameter("uid");


/* ============================================================
   CART SERVICE
   ============================================================ */

CartServiceImpl cart =
        new CartServiceImpl();


/* ============================================================
   USE SESSION USER ID IF UID NOT PROVIDED
   ============================================================ */

if (uid == null || uid.trim().isEmpty()) {

    uid = userId;

}


/* ============================================================
   CART ID
   ============================================================ */

if (cartId == null ||
    cartId.trim().isEmpty()) {

    cartId =
        (String) session.getAttribute("cartId");

}


/* ============================================================
   ADD / REMOVE PRODUCT
   ============================================================ */

if (add != null) {

    try {

        int addValue =
            Integer.parseInt(add);


        if (cartId == null ||
            cartId.trim().isEmpty()) {

            cartId =
                idUtil.generateUUIDCartId();

            session.setAttribute(
                "cartId",
                cartId
            );
        }


        int availableQuantity = 0;

        int currentQuantity = 0;


        if (request.getParameter("avail") != null) {

            availableQuantity =
                Integer.parseInt(
                    request.getParameter("avail")
                );

        }


        if (request.getParameter("qty") != null) {

            currentQuantity =
                Integer.parseInt(
                    request.getParameter("qty")
                );

        }


        /* ====================================================
           ADD
           ==================================================== */

        if (addValue == 1) {

            int newQuantity =
                currentQuantity + 1;


            if (newQuantity <= availableQuantity) {

                cart.addProductToCart(
                    uid,
                    cartId,
                    pid,
                    newQuantity
                );


                response.sendRedirect(
                    request.getContextPath()
                    + "/cartDetails.jsp?cartId="
                    + URLEncoder.encode(
                        cartId,
                        StandardCharsets.UTF_8.name()
                    )
                );

                return;

            } else {

                String msg =
                    URLEncoder.encode(
                        "Maximum available quantity reached.",
                        StandardCharsets.UTF_8.name()
                    );

                response.sendRedirect(
                    request.getContextPath()
                    + "/cartDetails.jsp?cartId="
                    + URLEncoder.encode(
                        cartId,
                        StandardCharsets.UTF_8.name()
                    )
                    + "&message="
                    + msg
                );

                return;
            }
        }


        /* ====================================================
           REMOVE
           ==================================================== */

        if (addValue == 0) {

            cart.removeProductFromCart(
                uid,
                cartId,
                pid
            );


            response.sendRedirect(
                request.getContextPath()
                + "/cartDetails.jsp?cartId="
                + URLEncoder.encode(
                    cartId,
                    StandardCharsets.UTF_8.name()
                )
            );

            return;
        }

    } catch (Exception e) {

        e.printStackTrace();

    }

}

%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>MYSHOP - Shopping Cart</title>

<link rel="shortcut icon"
      type="image/x-icon"
      href="<%=request.getContextPath()%>/favicon.ico">
<!-- =========================================================
     BOOTSTRAP
     ========================================================= -->

<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">


<!-- =========================================================
     BOOTSTRAP ICONS
     ========================================================= -->

<link
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
rel="stylesheet">


<!-- =========================================================
     FONT AWESOME
     ========================================================= -->

<link
rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


<!-- =========================================================
     SWEET ALERT
     ========================================================= -->

<script
src="https://cdn.jsdelivr.net/npm/sweetalert2@11">
</script>


<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cart.css"/>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp" />


<%
/* ============================================================
   LOAD CART
   ============================================================ */

CartServiceImpl carts =
        new CartServiceImpl();

List<CartBean> cartItems =
        carts.getAllCartItems(cartId);


ProductServiceImpl productService =
        new ProductServiceImpl();


double totalAmount =
        0;

double discount =
        0;

double payable =
        0;

int totalItems =
        0;

String prodId = "";

/* ============================================================
   CALCULATE CART
   ============================================================ */

if (cartItems != null) {

    for (CartBean item : cartItems) {

        ProductBean product =
            productService.getProductDetails(
                item.getProdId()
            );


        if (product != null) {

            int quantity =
                item.getQuantity();

            totalItems +=
                quantity;

            totalAmount +=
                quantity
                * product.getProdPrice();
            
            prodId = item.getProdId();

        }

    }

}


/* ============================================================
   DISCOUNT
   ============================================================ */

discount =
    totalAmount * 0.02;


/* ============================================================
   PAYABLE
   ============================================================ */

payable =
    totalAmount - discount;

%>


<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="cart-container">


    <% if (cartItems == null ||
           cartItems.isEmpty()) { %>


    <!-- =====================================================
         EMPTY CART
         ===================================================== -->

    <div class="empty-cart">


        <div class="empty-cart-icon">

            <i class="bi bi-cart-x"></i>

        </div>


        <h2>
            Your Cart is Empty
        </h2>


        <p>
            You haven't added any products yet.
        </p>


        <a
            href="<%=request.getContextPath()%>/user/userHome.jsp"
            class="checkout-btn d-inline-flex
                   align-items-center
                   justify-content-center
                   text-decoration-none"
            style="width:auto;padding:0 25px;">

            <i class="bi bi-shop"></i>&nbsp; Continue Shopping

        </a>


    </div>


    <% } else { %>


    <!-- =====================================================
         HEADING
         ===================================================== -->

    <div class="cart-heading">


        <div class="cart-heading-left">

            <h1>

                <i class="bi bi-cart3 me-2"></i>

                My Shopping Cart

            </h1>


            <p>
                Review your products before checkout.
            </p>

        </div>


        <div class="cart-count">

            <i class="bi bi-box-seam"></i>

            <span>
                <%=totalItems%>
                item<%=totalItems == 1 ? "" : "s"%>
            </span>

        </div>


    </div>


    <!-- =====================================================
         CART GRID
         ===================================================== -->

    <div class="cart-grid">


        <!-- =================================================
             PRODUCTS
             ================================================= -->

        <section class="products-wrapper">


            <%
            int quantity = 0;
            for (CartBean item : cartItems) {


                String productId =
                    item.getProdId();


                ProductBean product =
                    productService.getProductDetails(
                        productId
                    );


                if (product == null) {
                    continue;
                }


                quantity =
                    item.getQuantity();


                double itemAmount =
                    quantity
                    * product.getProdPrice();

            %>


            <!-- =============================================
                 PRODUCT
                 ============================================= -->

            <div
                class="product-card"
                id="row_<%=productId%>">


                <!-- IMAGE -->

                <div class="product-image">

                    <img
                        src="<%=request.getContextPath()%>/ShowImage?pid=<%=productId%>"
                        alt="<%=product.getProdName()%>"
                        onerror="
                            this.onerror=null;
                            this.src='<%=request.getContextPath()%>/images/noimage.jpg';
                        ">

                </div>


                <!-- INFO -->

                <div class="product-info">

                    <div
                        class="product-name"
                        title="<%=product.getProdName()%>">

                        <%=product.getProdName()%>

                    </div>


                    <div class="product-unit-price">

                        <strong>
                            ₹ <%=String.format(
                                "%.2f",
                                product.getProdPrice()
                            )%>
                        </strong>

                        / item

                    </div>

                </div>


                <!-- QUANTITY -->

                <div class="quantity-box">


                    <button
                        type="button"
                        class="quantity-btn"
                        onclick="
                            updateQty(
                                '<%=productId%>',
                                -1
                            )
                        "
                        title="Decrease">

                        <i class="bi bi-dash"></i>

                    </button>


                    <span
                        class="quantity-value"
                        id="qty_<%=productId%>">

                        <%=quantity%>

                    </span>


                    <button
                        type="button"
                        class="quantity-btn"
                        onclick="
                            updateQty(
                                '<%=productId%>',
                                1
                            )
                        "
                        title="Increase">

                        <i class="bi bi-plus"></i>

                    </button>


                </div>


                <!-- TOTAL -->

                <div class="item-total">

                    <span class="item-total-label">
                        Item Total
                    </span>

                    <span
                        class="item-total-price">

                        ₹
                        <span
                            id="amount_<%=productId%>">

                            <%=String.format(
                                "%.2f",
                                itemAmount
                            )%>

                        </span>

                    </span>

                </div>


                <!-- REMOVE -->

                <button
                    type="button"
                    class="remove-btn"
                    onclick="
                        removeItem(
                            '<%=productId%>'
                        )
                    "
                    title="Remove product">

                    <i class="bi bi-trash3"></i>

                </button>


            </div>


            <% } %>


        </section>


        <!-- =================================================
             PRICE SUMMARY
             ================================================= -->

        <aside>


            <div class="summary-card">


                <!-- HEADER -->

                <div class="summary-header">


                    <div class="summary-icon">

                        <i class="bi bi-receipt"></i>

                    </div>


                    <div class="summary-title">

                        Price Details

                    </div>


                </div>


                <!-- TOTAL -->

                <div class="summary-row">

                    <span>
                        Total Price
                    </span>

                    <strong>

                        ₹
                        <span id="cartTotal">

                            <%=String.format(
                                "%.2f",
                                totalAmount
                            )%>

                        </span>

                    </strong>

                </div>


                <!-- DISCOUNT -->

                <div
                    class="summary-row discount-row">

                    <span>
                        Discount (2%)
                    </span>

                    <strong>

                        − ₹
                        <span id="discount">

                            <%=String.format(
                                "%.2f",
                                discount
                            )%>

                        </span>

                    </strong>

                </div>


                <hr class="summary-divider">


                <!-- PAYABLE -->

                <div class="total-row">

                    <span class="total-label">

                        Payable Amount

                    </span>


                    <span class="total-value">

                        ₹
                        <span id="payable">

                            <%=String.format(
                                "%.2f",
                                payable
                            )%>

                        </span>

                    </span>

                </div>


                <!-- SHIPPING -->

                <div class="shipping-box">

                    <i class="bi bi-truck"></i>

                    <span>
                        Free shipping included
                    </span>

                </div>


                <!-- CHECKOUT -->

                <form
                    id="checkoutForm"
                    method="post"
                    action="<%=request.getContextPath()%>/PaymentServlet?userId=<%=userId%>&pid=<%=prodId%>&cartId=<%=cartId%>&qnty=<%=quantity%>">


                    <input
                        type="hidden"
                        name="amount"
                        id="hiddenAmount"
                        value="<%=String.format(
                            "%.2f",
                            payable
                        )%>">


                    <input
                        type="hidden"
                        name="pid"
                        value="<%=pid%>">


                    <button
                        type="submit"
                        id="checkoutButton"
                        class="checkout-btn">

                        <i class="bi bi-shield-lock-fill"></i>

                        &nbsp;

                        Proceed to Checkout

                    </button>


                </form>


                <!-- CONTINUE -->

                <a
                    href="<%=request.getContextPath()%>/user/userHome.jsp"
                    class="continue-btn">

                    <i class="bi bi-arrow-left"></i> Continue Shopping

                </a>


            </div>


        </aside>


    </div>


    <% } %>


</main>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html" />


<script>

/* ============================================================
   THEME
   ============================================================ */

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


/* ============================================================
   MESSAGE
   ============================================================ */

let messageTimer = null;


function showMessage(
    type,
    title,
    message,
    duration = 5000
) {


    const old =
        document.querySelector(
            ".myshop-message"
        );


    if (old) {

        old.remove();

    }


    if (messageTimer) {

        clearTimeout(
            messageTimer
        );

    }


    const iconMap = {

        error:
            "fa-solid fa-circle-xmark",

        success:
            "fa-solid fa-circle-check",

        warning:
            "fa-solid fa-circle-exclamation",

        info:
            "fa-solid fa-circle-info"

    };


    const box =
        document.createElement(
            "div"
        );


    box.className =
        "myshop-message " + type;


    const icon =
        document.createElement(
            "div"
        );


    icon.className =
        "message-icon";


    icon.innerHTML =
        '<i class="' +
        (
            iconMap[type]
            || iconMap.info
        ) +
        '"></i>';


    const content =
        document.createElement(
            "div"
        );


    content.className =
        "message-content";


    content.innerHTML =
        "<div class='message-title'>" +
        escapeHtml(title) +
        "</div>" +

        "<div class='message-text'>" +
        escapeHtml(message) +
        "</div>";


    const close =
        document.createElement(
            "button"
        );


    close.type =
        "button";


    close.className =
        "message-close";


    close.innerHTML =
        '<i class="fa-solid fa-xmark"></i>';


    close.onclick =
        function () {

            closeMessage();

        };


    box.appendChild(icon);

    box.appendChild(content);

    box.appendChild(close);


    document.body.appendChild(
        box
    );


    messageTimer =
        setTimeout(
            function () {

                closeMessage();

            },
            duration
        );

}


/* ============================================================
   CLOSE MESSAGE
   ============================================================ */

function closeMessage() {

    const box =
        document.querySelector(
            ".myshop-message"
        );


    if (!box) {

        return;

    }


    if (messageTimer) {

        clearTimeout(
            messageTimer
        );

        messageTimer = null;

    }


    box.classList.add(
        "hide"
    );


    setTimeout(
        function () {

            if (box.parentNode) {

                box.remove();

            }

        },
        300
    );

}


/* ============================================================
   ESCAPE HTML
   ============================================================ */

function escapeHtml(value) {

    const div =
        document.createElement(
            "div"
        );

    div.textContent =
        value;

    return div.innerHTML;

}


/* ============================================================
   SERVER MESSAGE
   ============================================================ */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        <% if (message != null &&
               !message.trim().isEmpty()) {

            String safeMessage =
                message
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "")
                    .replace("\n", "\\n");

        %>

        showMessage(
            "warning",
            "MYSHOP",
            "<%=safeMessage%>",
            5000
        );

        <% } %>

    }
);


/* ============================================================
   UPDATE QUANTITY
   ============================================================ */

function updateQty(
    pid,
    change
) {


    fetch(
        "<%=request.getContextPath()%>/UpdateToCart",
        {

            method:
                "POST",

            headers: {

                "Content-Type":
                    "application/x-www-form-urlencoded"

            },

            body:
                "pid=" +
                encodeURIComponent(pid) +

                "&change=" +
                encodeURIComponent(change) +

                "&cartId=" +
                encodeURIComponent(
                    "<%=cartId%>"
                )

        }

    )

    .then(
        function(response) {

            if (!response.ok) {

                throw new Error(
                    "Server error"
                );

            }

            return response.json();

        }

    )

    .then(
        function(data) {


            if (data.status === "success") {


                const qty =
                    document.getElementById(
                        "qty_" + pid
                    );


                const amount =
                    document.getElementById(
                        "amount_" + pid
                    );


                if (qty) {

                    qty.innerText =
                        data.qty;

                }


                if (amount) {

                    amount.innerText =
                        parseFloat(
                            data.amount
                        ).toFixed(2);

                }


                recalculateCart();


                showMessage(
                    "success",
                    "Cart Updated",
                    "Product quantity updated.",
                    1800
                );


            } else {


                showMessage(
                    "error",
                    "Update Failed",
                    data.message ||
                    "Unable to update quantity.",
                    3000
                );

            }

        }

    )

    .catch(
        function(error) {

            console.error(error);


            showMessage(
                "error",
                "Server Error",
                "Unable to update cart quantity.",
                3000
            );

        }
    );

}


/* ============================================================
   RECALCULATE
   ============================================================ */

function recalculateCart() {


    let total =
        0;


    document
        .querySelectorAll(
            "[id^='amount_']"
        )
        .forEach(
            function(element) {

                total +=
                    parseFloat(
                        element.innerText
                    ) || 0;

            }
        );


    const discount =
        total * 0.02;


    const payable =
        total - discount;


    const totalElement =
        document.getElementById(
            "cartTotal"
        );


    const discountElement =
        document.getElementById(
            "discount"
        );


    const payableElement =
        document.getElementById(
            "payable"
        );


    const hiddenAmount =
        document.getElementById(
            "hiddenAmount"
        );


    if (totalElement) {

        totalElement.innerText =
            total.toFixed(2);

    }


    if (discountElement) {

        discountElement.innerText =
            discount.toFixed(2);

    }


    if (payableElement) {

        payableElement.innerText =
            payable.toFixed(2);

    }


    if (hiddenAmount) {

        hiddenAmount.value =
            payable.toFixed(2);

    }

}


/* ============================================================
   REMOVE ITEM
   ============================================================ */

function removeItem(pid) {


    Swal.fire({

        title:
            "Remove Product?",

        text:
            "Do you want to remove this product from your cart?",

        icon:
            "warning",

        showCancelButton:
            true,

        confirmButtonColor:
            "#dc3545",

        cancelButtonColor:
            "#6c757d",

        confirmButtonText:
            "Yes, Remove",

        cancelButtonText:
            "Cancel",

        reverseButtons:
            true

    })

    .then(
        function(result) {


            if (!result.isConfirmed) {

                return;

            }


            const row =
                document.getElementById(
                    "row_" + pid
                );


            fetch(
                "<%=request.getContextPath()%>/RemoveCartSrv",
                {

                    method:
                        "POST",

                    headers: {

                        "Content-Type":
                            "application/x-www-form-urlencoded"

                    },

                    body:
                        "pid=" +
                        encodeURIComponent(pid) +

                        "&cartId=" +
                        encodeURIComponent(
                            "<%=cartId%>"
                        )

                }

            )

            .then(
                function(response) {

                    if (!response.ok) {

                        throw new Error(
                            "Server error"
                        );

                    }

                    return response.json();

                }

            )

            .then(
                function(data) {


                    if (data.status === "success") {


                        if (row) {

                            row.classList.add(
                                "remove-anim"
                            );

                        }


                        setTimeout(
                            function() {

                                if (row) {

                                    row.remove();

                                }


                                recalculateCart();


                                const remaining =
                                    document.querySelectorAll(
                                        ".product-card"
                                    ).length;


                                if (remaining === 0) {

                                    location.reload();

                                }

                            },
                            300
                        );


                        showMessage(
                            "success",
                            "Removed",
                            "Product removed from your cart.",
                            1800
                        );


                    } else {


                        showMessage(
                            "error",
                            "Remove Failed",
                            data.message ||
                            "Unable to remove product.",
                            3000
                        );

                    }

                }

            )

            .catch(
                function(error) {

                    console.error(error);


                    showMessage(
                        "error",
                        "Server Error",
                        "Unable to remove product.",
                        3000
                    );

                }
            );

        }
    );

}


/* ============================================================
   CHECKOUT
   ============================================================ */

const checkoutForm =
    document.getElementById(
        "checkoutForm"
    );


if (checkoutForm) {


    checkoutForm.addEventListener(
        "submit",
        function(event) {


            event.preventDefault();


            const payableElement =
                document.getElementById(
                    "payable"
                );


            if (!payableElement) {

                showMessage(
                    "error",
                    "Invalid Cart",
                    "Unable to calculate cart amount.",
                    3000
                );

                return;

            }


            const amount =
                parseFloat(
                    payableElement.innerText
                );


            if (
                isNaN(amount) ||
                amount <= 0
            ) {

                showMessage(
                    "error",
                    "Invalid Amount",
                    "Please check your cart before checkout.",
                    3000
                );

                return;

            }


            document.getElementById(
                "hiddenAmount"
            ).value =
                amount.toFixed(2);


            const button =
                document.getElementById(
                    "checkoutButton"
                );


            button.disabled =
                true;


            button.innerHTML =
                '<i class="bi bi-arrow-repeat"></i> Processing...';


            setTimeout(
                function() {

                    checkoutForm.submit();

                },
                350
            );

        }
    );

}


/* ============================================================
   SYNC THEME
   ============================================================ */

window.addEventListener(
    "storage",
    function(event) {

        if (
            event.key ===
            "myshop-theme"
        ) {

            applyTheme();

        }

    }
);

</script>


</body>

</html>