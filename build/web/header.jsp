<%@ page language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom CSS -->
   <link rel="stylesheet" href="css/main.css">
</head>
<body>

<%
    String userrole = (String) session.getAttribute("usertype");
    String username = (String) session.getAttribute("username");
    String id = session.getId();

    int cartCount = 0;
    Object cartObj = session.getAttribute("cartCount");
    if (cartObj != null) {
        try { cartCount = Integer.parseInt(cartObj.toString()); }
        catch (Exception e) { cartCount = 0; }
    }

    String homePage = "index.jsp";
    if ("customer".equalsIgnoreCase(userrole)) homePage = "userHome.jsp";
    else if ("admin".equalsIgnoreCase(userrole)) homePage = "adminHome.jsp";
    else if ("staff".equalsIgnoreCase(userrole)) homePage = "staffHome.jsp";
%>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top shadow-sm">
    <div class="container">

        <!-- LOGO -->
        <a class="navbar-brand d-flex align-items-center" href="<%= homePage %>">
            <img src="images/Myshop-logo.png" alt="MyShop" style="height:40px;width:80px;border-radius:50%;">
        </a>

        <!-- TOGGLER -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- MENU -->
        <div class="collapse navbar-collapse" id="navbarMenu">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link" href="adminViewProduct.jsp?id=<%=id%>">Products</a>
                </li>

                <!-- CATEGORY DROPDOWN -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        Category
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="<%= homePage %>?type=mobile">Mobiles</a></li>
                        <li><a class="dropdown-item" href="<%= homePage %>?type=tv">TVs</a></li>
                        <li><a class="dropdown-item" href="<%= homePage %>?type=laptop">Laptops</a></li>
                        <li><a class="dropdown-item" href="<%= homePage %>?type=camera">Cameras</a></li>
                        <li><a class="dropdown-item" href="<%= homePage %>?type=speaker">Speakers</a></li>
                        <li><a class="dropdown-item" href="<%= homePage %>?type=tablet">Tablets</a></li>
                    </ul>
                </li>

                <% if (userrole == null) { %>

                    <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp">Register</a></li>

                <% } else if ("customer".equalsIgnoreCase(userrole)) { %>

                    <li class="nav-item">
                        <a class="nav-link position-relative" href="cartDetails.jsp?id=<%=id%>">
                            <i class="bi bi-cart-fill"></i> Cart
                            <% if (cartCount > 0) { %>
                                <span class="badge bg-danger position-absolute top-0 start-100 translate-middle">
                                    <%= cartCount %>
                                </span>
                            <% } %>
                        </a>
                    </li>

                    <li class="nav-item"><a class="nav-link" href="orderDetails.jsp?id=<%=id%>">Orders</a></li>
                    <li class="nav-item"><a class="nav-link" href="userProfile.jsp?id=<%=id%>"><i class="bi bi-person-fill"></i> Profile</a></li>
                    <li class="nav-item"><a class="nav-link" href="./LogoutSrv"><i class="bi bi-box-arrow-right"></i> Logout</a></li>

                <% } else if ("staff".equalsIgnoreCase(userrole)) { %>

                    <li class="nav-item"><a class="nav-link" href="assignedDeliveries.jsp?id=<%=id%>">Assigned Deliveries</a></li>
                    <li class="nav-item"><a class="nav-link" href="updateDeliveryStatus.jsp?id=<%=id%>">Update Status</a></li>
                    <li class="nav-item"><a class="nav-link" href="staffProfile.jsp?id=<%=id%>">Profile</a></li>
                    <li class="nav-item"><a class="nav-link" href="./LogoutSrv">Logout</a></li>

                <% } else { %>

                    <!-- ADMIN -->
                    <li class="nav-item"><a class="nav-link" href="adminStock.jsp?id=<%=id%>">Stock</a></li>
                    <li class="nav-item"><a class="nav-link" href="shippedItems.jsp?id=<%=id%>">Shipped</a></li>
                    <li class="nav-item"><a class="nav-link" href="unShippedItems.jsp?id=<%=id%>">Orders</a></li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                                Manage Items
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="addProduct.jsp?id=<%=id%>">Add Product</a></li>
                            <li><a class="dropdown-item" href="removeProduct.jsp?id=<%=id%>">Remove Product</a></li>
                            <li><a class="dropdown-item" href="updateProductById.jsp?id=<%=id%>">Update Product</a></li>
                        </ul>
                    </li>

                    <li class="nav-item"><a class="nav-link" href="./LogoutSrv">Logout</a></li>

                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- SPACER -->
<div style="margin-top:90px;"></div>

<!-- HEADER SEARCH -->
<div class="text-center p-3 bg-success text-white">
    <h2 class="fw-bold">THE MYSHOP</h2>
    <h6>We are ready for fast and secure services</h6>

    <form class="d-flex justify-content-center mt-2" action="index.jsp" method="get">
        <input class="form-control w-50 me-2" type="search" name="search" placeholder="Search Items" required>
        <button class="btn btn-danger">Search</button>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
