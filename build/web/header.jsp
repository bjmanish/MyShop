<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    String name = (String) session.getAttribute("name");
    String userId = (String) session.getAttribute("user_id");
    String cartId = (String) session.getAttribute("cartId");

    int cartCount = 0;

    try {
        if (userId != null && !userId.trim().isEmpty()) {
            cartCount = new CartServiceImpl().getCartCount(userId);
        }
    } catch (Exception e) {
        cartCount = 0;
    }


    /* =========================================================
       ROLE BASED URLS
       ========================================================= */

    String homePage =
        request.getContextPath() + "/index.jsp";

    String profile = request.getContextPath()+"";


    if ("customer".equalsIgnoreCase(role)) {

        homePage =
            request.getContextPath() + "/user/userHome.jsp";

        profile =
            request.getContextPath() + "/user/userProfile.jsp";


    } else if ("admin".equalsIgnoreCase(role)) {

        homePage =
            request.getContextPath() + "/admin/adminHome.jsp";
        
//        profile = request.getContextPath() + "/admin/applicationStatus.jsp";
        
        profile = request.getContextPath() + "/admin/userActivity.jsp";


    } else if ("staff".equalsIgnoreCase(role)
            || "delivery".equalsIgnoreCase(role)
            ) {

        homePage =
            request.getContextPath() + "/staff/staffHome.jsp";

        profile =
            request.getContextPath() + "/staff/staffProfile.jsp";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

<!-- =========================================================
     BOOTSTRAP CSS
     ========================================================= -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<!-- =========================================================
     BOOTSTRAP ICONS
     ========================================================= -->

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css"/>

</head>

<body>

<!-- =========================================================
     NAVBAR
     ========================================================= -->

<nav
    class="navbar navbar-expand-lg modern-nav fixed-top"
    id="navbar">

    <div class="container">


        <!-- =================================================
             LOGO
             ================================================= -->

        <a
            class="navbar-brand logo"
            href="<%=homePage%>">

            <i class="bi bi-bag-heart-fill"></i>

            <span>MYSHOP</span>

        </a>


        <!-- =================================================
             DESKTOP SEARCH
             ================================================= -->

        <form
            class="search-box d-none d-lg-flex mx-3"
            action="<%=request.getContextPath()%>/index.jsp"
            method="get">

            <input
                type="search"
                name="search"
                class="form-control"
                placeholder="Search products..."
                value="<%=request.getParameter("search") != null
                    ? request.getParameter("search")
                    : ""%>">

        </form>


        <!-- =================================================
             CONTROLS
             ================================================= -->

        <div
            class="d-flex align-items-center gap-2">


            <!-- THEME BUTTON -->

            <button
                type="button"
                class="theme-btn"
                id="themeToggle"
                title="Change theme">

                <i
                    class="bi bi-moon-fill"
                    id="themeIcon">
                </i>

            </button>


            <!-- MOBILE MENU -->

            <button
                type="button"
                class="navbar-toggler border-0"
                id="navToggleBtn"
                aria-label="Open menu">

                <i
                    class="bi bi-list"
                    style="
                        font-size:16px;
                        color:var(--nav-text);
                    ">
                </i>

            </button>

        </div>


        <!-- =================================================
             DESKTOP MENU
             ================================================= -->

        <div
            class="d-none d-lg-block"
            id="menu">

            <ul
                class="navbar-nav
                       ms-auto
                       align-items-center
                       flex-row">


                <!-- =================================================
                     NOTIFICATION
                     ================================================= -->

                <li
                    class="nav-item position-relative">

                    <a
                        class="nav-link"
                        href="#">

                        <i class="bi bi-bell"></i>

                        <span class="notif-badge">

                            3

                        </span>

                    </a>

                </li>


                <% if (role == null) { %>


                    <!-- =================================================
                         GUEST HOME
                         ================================================= -->

                    <li class="nav-item">

                        <a
                            class="nav-link"
                            href="<%=request.getContextPath()%>/index.jsp">

                            <i class="bi bi-house"></i>

                            <span>Home</span>

                        </a>

                    </li>


                    <!-- =================================================
                         GUEST CART
                         ================================================= -->

                    <li
                        class="nav-item position-relative">

                        <a
                            class="nav-link"
                            href="#"
                            onclick="handleGuestCart(event)">

                            <i class="bi bi-cart3"></i>

                            <span>Cart</span>

                            <span
                                class="notif-badge"
                                id="cartCount">

                                <%=cartCount%>

                            </span>

                        </a>

                    </li>


                    <!-- =================================================
                         LOGIN
                         ================================================= -->

                    <li class="nav-item">

                        <a
                            class="nav-link"
                            href="<%=request.getContextPath()%>/login.jsp">

                            <i
                                class="bi bi-box-arrow-in-right">
                            </i>

                            <span>Login</span>

                        </a>

                    </li>


                <% } else { %>


                    <!-- =================================================
                         CUSTOMER
                         ================================================= -->

                    <% if ("customer".equalsIgnoreCase(role)) { %>


                        <!-- HOME -->

                        <li class="nav-item">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/user/userHome.jsp">

                                <i class="bi bi-house"></i>

                                <span>Home</span>

                            </a>

                        </li>


                        <!-- CART -->

                        <li
                            class="nav-item position-relative">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/user/cart.jsp?cartId=<%=cartId%>&uid=<%=userId%>">

                                <i class="bi bi-cart3"></i>

                                <span>Cart</span>

                                <span
                                    class="notif-badge"
                                    id="cartCount">

                                    <%=cartCount%>

                                </span>

                            </a>

                        </li>


                        <!-- ORDERS -->

                        <li class="nav-item">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/user/orderDetails.jsp?userId=<%=userId%>">

                                <i class="bi bi-truck"></i>

                                <span>Orders</span>

                            </a>

                        </li>


                    <!-- =================================================
                         ADMIN
                         ================================================= -->

                    <% } else if ("admin".equalsIgnoreCase(role)) { %>


                        <!-- HOME -->

                        <li class="nav-item">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/admin/adminHome.jsp">

                                <i class="bi bi-house"></i>

                                <span>Home</span>

                            </a>

                        </li>


                        <!-- ORDERS -->

                        <li class="nav-item">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/admin/shippedItems.jsp?uid=<%=userId%>">

                                <i class="bi bi-box-seam"></i>

                                <span>Orders</span>

                            </a>

                        </li>


                    <!-- =================================================
                         STAFF / DELIVERY
                         ================================================= -->

                    <% } else if ("staff".equalsIgnoreCase(role)
                            || "delivery".equalsIgnoreCase(role)
                            || "DELIVERY_STAFF".equalsIgnoreCase(role)
                            ) { %>


                        <!-- HOME -->

                        <li class="nav-item">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/staff/staffHome.jsp">

                                <i class="bi bi-house"></i>

                                <span>Home</span>

                            </a>

                        </li>


                        <!-- ASSIGN ORDER -->

                        <li class="nav-item">

                            <a
                                class="nav-link"
                                href="<%=request.getContextPath()%>/staff/assignOrder.jsp?uId=<%=userId%>">

                                <i class="bi bi-box-seam"></i>

                                <span>Assign Order</span>

                            </a>

                        </li>


                    <% } %>


                    <!-- =================================================
                         PROFILE
                         ================================================= -->

                    <li class="nav-item">

                        <a
                            class="nav-link"
                            href="<%=profile%>">

                            <i
                                class="bi bi-person-circle">
                            </i>

                          <%-- <span>
                                Welcome <%=name%>
                            </span>  --%>

                        </a>

                    </li>


                    <!-- =================================================
                         LOGOUT
                         ================================================= -->

                    <li class="nav-item">

                        <a
                            class="nav-link"
                            href="#"
                            onclick="openLogoutModal(); return false;">

                            <i
                                class="bi bi-box-arrow-right">
                            </i>

                            <span>Logout</span>

                        </a>

                    </li>


                <% } %>


            </ul>

        </div>

    </div>

</nav>


<!-- =========================================================
     MOBILE MENU
     ========================================================= -->

<div id="mobileMenu">


    <!-- MOBILE HEADER -->

    <div
        class="d-flex
               justify-content-between
               align-items-center">

        <h4 class="fw-bold m-0">

            <i class="bi bi-bag-heart-fill"></i>

            MYSHOP

        </h4>


        <button
            type="button"
            id="closeMenu"
            class="mobile-close">

            <i class="bi bi-x-lg"></i>

        </button>

    </div>


    <!-- MOBILE SEARCH -->

    <form
        action="<%=request.getContextPath()%>/index.jsp"
        method="get">

        <input
            type="search"
            name="search"
            class="form-control mobile-search my-4"
            placeholder="Search products..."
            value="<%=request.getParameter("search") != null
                ? request.getParameter("search")
                : ""%>">

    </form>


    <% if (role == null) { %>


        <!-- GUEST -->

        <a
            href="<%=request.getContextPath()%>/index.jsp">

            <i class="bi bi-house"></i>

            <span>Home</span>

        </a>


        <a
            href="#"
            onclick="handleGuestCart(event)">

            <i class="bi bi-cart3"></i>

            <span>Cart</span>

        </a>


        <a
            href="<%=request.getContextPath()%>/login.jsp">

            <i
                class="bi bi-box-arrow-in-right">
            </i>

            <span>Login</span>

        </a>


    <% } else { %>


        <!-- =================================================
             CUSTOMER MOBILE
             ================================================= -->

        <% if ("customer".equalsIgnoreCase(role)) { %>


            <a
                href="<%=request.getContextPath()%>/user/userHome.jsp">

                <i class="bi bi-house"></i>

                <span>Home</span>

            </a>


            <a
                href="<%=request.getContextPath()%>/user/cart.jsp?cartId=<%=cartId%>&uid=<%=userId%>">

                <i class="bi bi-cart3"></i>

                <span>
                    Cart (<%=cartCount%>)
                </span>

            </a>


            <a
                href="<%=request.getContextPath()%>/orderDetails.jsp?userId=<%=userId%>&orderId=<%=session.getAttribute("orderId")%>">

                <i class="bi bi-truck"></i>

                <span>Orders</span>

            </a>


        <!-- =================================================
             ADMIN MOBILE
             ================================================= -->

        <% } else if ("admin".equalsIgnoreCase(role)) { %>


            <a
                href="<%=request.getContextPath()%>/admin/adminHome.jsp">

                <i class="bi bi-house"></i>

                <span>Home</span>

            </a>


            <a
                href="<%=request.getContextPath()%>/admin/shippedItems.jsp?uid=<%=userId%>">

                <i class="bi bi-box-seam"></i>

                <span>Orders</span>

            </a>


        <!-- =================================================
             STAFF MOBILE
             ================================================= -->

        <% } else if ("staff".equalsIgnoreCase(role)
                || "delivery".equalsIgnoreCase(role)
                || "DELIVERY_STAFF".equalsIgnoreCase(role)
                ) { %>


            <a
                href="<%=request.getContextPath()%>/staff/staffHome.jsp">

                <i class="bi bi-house"></i>

                <span>Home</span>

            </a>


            <a
                href="<%=request.getContextPath()%>/staff/assignOrder.jsp?uId=<%=userId%>">

                <i class="bi bi-box-seam"></i>

                <span>Assign Order</span>

            </a>


        <% } %>


        <!-- PROFILE -->

        <a href="<%=profile%>">

            <i
                class="bi bi-person-circle">
            </i>

            <span>Profile</span>

        </a>


        <!-- LOGOUT -->

        <a
            href="#"
            onclick="openLogoutModal(); return false;">

            <i
                class="bi bi-box-arrow-right">
            </i>

            <span>Logout</span>

        </a>


    <% } %>


    <!-- MOBILE THEME -->

    <a
        href="#"
        onclick="toggleTheme(); return false;">

        <i class="bi bi-circle-half"></i>

        <span>Change Theme</span>

    </a>

</div>


<!-- =========================================================
     OVERLAY
     ========================================================= -->

<div id="menuOverlay"></div>


<!-- =========================================================
     LOGOUT MODAL
     ========================================================= -->

<%
    if (userId != null && !userId.trim().isEmpty()) {
%>

<div
    class="modal fade"
    id="logoutModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered">

        <div
            class="modal-content logout-modal-content">


            <div class="modal-header">

                <h5 class="modal-title">

                    <i
                        class="bi bi-box-arrow-right">
                    </i>

                    Confirm Logout

                </h5>


                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal">
                </button>

            </div>


            <div
                class="modal-body text-center">

                <i
                    class="bi bi-question-circle"
                    style="font-size:45px;">
                </i>


                <p class="mt-3 mb-0">

                    Are you sure you want to logout?

                </p>

            </div>


            <div
                class="modal-footer
                       justify-content-center">

                <button
                    type="button"
                    class="btn btn-secondary"
                    data-bs-dismiss="modal">

                    Cancel

                </button>


                <button
                    type="button"
                    class="btn btn-danger"
                    onclick="confirmLogout()">

                    Logout

                </button>

            </div>

        </div>

    </div>

</div>

<%
    }
%>


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script>

/* =========================================================
   THEME
   ========================================================= */

function applyTheme() {

    const savedTheme =
        localStorage.getItem("myshop-theme") || "light";


    if (savedTheme === "dark") {

        document.body.classList.add(
            "dark-mode"
        );

    } else {

        document.body.classList.remove(
            "dark-mode"
        );
    }


    updateThemeIcon();
}


/* =========================================================
   UPDATE THEME ICON
   ========================================================= */

function updateThemeIcon() {

    const icon =
        document.getElementById(
            "themeIcon"
        );


    if (!icon) {
        return;
    }


    if (
        document.body.classList.contains(
            "dark-mode"
        )
    ) {

        icon.className =
            "bi bi-sun-fill";

        icon.title =
            "Switch to light mode";

    } else {

        icon.className =
            "bi bi-moon-fill";

        icon.title =
            "Switch to dark mode";
    }
}


/* =========================================================
   TOGGLE THEME
   ========================================================= */

function toggleTheme() {

    const isDark =
        document.body.classList.contains(
            "dark-mode"
        );


    if (isDark) {

        document.body.classList.remove(
            "dark-mode"
        );

        localStorage.setItem(
            "myshop-theme",
            "light"
        );

    } else {

        document.body.classList.add(
            "dark-mode"
        );

        localStorage.setItem(
            "myshop-theme",
            "dark"
        );
    }


    updateThemeIcon();
}


/* =========================================================
   INITIALIZE
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        applyTheme();


        const themeToggle =
            document.getElementById(
                "themeToggle"
            );


        if (themeToggle) {

            themeToggle.addEventListener(
                "click",
                function () {

                    toggleTheme();

                }
            );
        }

    }
);


/* =========================================================
   MOBILE MENU
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const toggleBtn =
            document.getElementById(
                "navToggleBtn"
            );

        const mobileMenu =
            document.getElementById(
                "mobileMenu"
            );

        const overlay =
            document.getElementById(
                "menuOverlay"
            );

        const closeBtn =
            document.getElementById(
                "closeMenu"
            );


        if (
            toggleBtn &&
            mobileMenu &&
            overlay
        ) {

            toggleBtn.addEventListener(
                "click",
                function () {

                    mobileMenu.classList.add(
                        "active"
                    );

                    overlay.classList.add(
                        "active"
                    );

                    document.body.style.overflow =
                        "hidden";

                }
            );
        }


        if (closeBtn) {

            closeBtn.addEventListener(
                "click",
                closeMenu
            );
        }


        if (overlay) {

            overlay.addEventListener(
                "click",
                closeMenu
            );
        }


        function closeMenu() {

            if (mobileMenu) {

                mobileMenu.classList.remove(
                    "active"
                );
            }


            if (overlay) {

                overlay.classList.remove(
                    "active"
                );
            }


            document.body.style.overflow =
                "";
        }

    }
);


/* =========================================================
   GUEST CART
   ========================================================= */

function handleGuestCart(event) {

    if (event) {

        event.preventDefault();

    }


    if (
        typeof showLoginAlert ===
        "function"
    ) {

        showLoginAlert();

    } else {

        window.location.href =
            "<%=request.getContextPath()%>/login.jsp";
    }
}


/* =========================================================
   CART COUNT
   ========================================================= */

function loadCartCount() {

    const badge =
        document.getElementById(
            "cartCount"
        );


    if (!badge) {
        return;
    }


    fetch(
        "<%=request.getContextPath()%>/cartCount"
    )
    .then(function(response) {

        if (!response.ok) {

            throw new Error(
                "Cart count request failed"
            );
        }

        return response.text();

    })
    .then(function(count) {

        badge.innerText =
            count;

    })
    .catch(function(error) {

        console.log(
            "Cart count:",
            error
        );

    });
}


/* =========================================================
   SCROLL NAVBAR
   ========================================================= */

window.addEventListener(
    "scroll",
    function () {

        const navbar =
            document.getElementById(
                "navbar"
            );


        if (!navbar) {
            return;
        }


        if (window.scrollY > 50) {

            navbar.classList.add(
                "nav-scrolled"
            );

        } else {

            navbar.classList.remove(
                "nav-scrolled"
            );
        }

    }
);


/* =========================================================
   LOGOUT MODAL
   ========================================================= */

function openLogoutModal() {

    const modalElement =
        document.getElementById(
            "logoutModal"
        );


    if (!modalElement) {
        return;
    }


    if (
        typeof bootstrap !==
        "undefined"
    ) {

        const modal =
            bootstrap.Modal.getOrCreateInstance(
                modalElement
            );

        modal.show();

    } else {

        confirmLogout();
    }
}


/* =========================================================
   CONFIRM LOGOUT
   ========================================================= */

function confirmLogout() {

    window.location.href =
        "<%=request.getContextPath()%>/LogoutSrv";
}


/* =========================================================
   THEME SYNC BETWEEN TABS
   ========================================================= */

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