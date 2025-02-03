<%@ page import="com.myshop.service.impl.CartServiceImpl" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>

<!DOCTYPE html>
<html>
<head>
    <title>Header</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body>

    <!-- Header Section -->
    <div class="container-fluid text-center" style="margin-top: 45px; background-color: #33cc33; color: white; padding: 5px;">
        <h2>THE MYSHOP</h2>
        <h6>We are ready for fast and secure services</h6>
        <form class="form-inline" action="index.jsp" method="get">
            <div class="input-group">
                <input type="text" class="form-control" size="50" name="search" placeholder="Search Items" required>
                <div class="input-group-btn">
                    <button type="submit" class="btn btn-danger">Search</button>
                </div>
            </div>
        </form>
    </div>

    <%
        String userrole = (String) session.getAttribute("usertype");
        String username = (String) session.getAttribute("username");
        int cartCount = 0;
        String homePage = "index.jsp"; // Default for guests

        if (userrole != null) {
            if ("customer".equalsIgnoreCase(userrole)) {
                homePage = "userHome.jsp";
                if (username != null) {
                    cartCount = new CartServiceImpl().getCartCount(username);
                }
            } else if ("admin".equalsIgnoreCase(userrole)) {
                homePage = "adminHome.jsp";
            } else if ("staff".equalsIgnoreCase(userrole)) {
                homePage = "staffHome.jsp";
            }
        }
    %>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <!-- Navbar Header -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbarMenu">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="<%= homePage %>">
                    <span class="glyphicon glyphicon-home"></span> MYSHOP
                </a>
            </div>

            <!-- Navbar Links -->
            <div class="collapse navbar-collapse" id="navbarMenu">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="adminViewProduct.jsp">Products</a></li>

                    <!-- Categories Dropdown -->
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Category <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= homePage %>?type=mobile">Mobiles</a></li>
                            <li><a href="<%= homePage %>?type=tv">TVs</a></li>
                            <li><a href="<%= homePage %>?type=laptop">Laptops</a></li>
                            <li><a href="<%= homePage %>?type=camera">Cameras</a></li>
                            <li><a href="<%= homePage %>?type=speaker">Speakers</a></li>
                            <li><a href="<%= homePage %>?type=tablet">Tablets</a></li>
                        </ul>
                    </li>

                    <!-- User-Specific Links -->
                    <% if (userrole == null) { %>
                        <!-- Guest Links -->
                        <li><a href="login.jsp">Login</a></li>
                        <li><a href="register.jsp">Register</a></li>
                    <% } else if ("customer".equalsIgnoreCase(userrole)) { %>
                        <!-- Customer Links -->
                        <li>
                            <a href="cartDetails.jsp">
                                <span class="glyphicon glyphicon-shopping-cart"></span> Cart 
                                <% if (cartCount > 0) { %>
                                    <span class="badge" style="background-color: red; margin-left: 5px;"><%= cartCount %></span>
                                <% } %>
                            </a>
                        </li>
                        <li><a href="orderDetails.jsp">Orders</a></li>
                        <li>
                            <a href="userProfile.jsp">
                                <span class="glyphicon glyphicon-user"></span> Profile
                            </a>
                        </li>
                        <li><a href="./LogoutSrv">Logout</a></li>
                    <% } else if ("staff".equalsIgnoreCase(userrole)) { %>
                        <!-- Delivery Staff Links -->
                        <li><a href="assignedDeliveries.jsp"><span class="glyphicon glyphicon-list-alt"></span> Assigned Deliveries</a></li>
                        <li><a href="updateDeliveryStatus.jsp"><span class="glyphicon glyphicon-ok"></span> Update Delivery Status</a></li>
                        <li><a href="staffProfile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
                        <li><a href="./LogoutSrv"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
                    <% } else { %>
                        <!-- Admin Links -->
                        <li><a href="adminStock.jsp">Stock</a></li>
                        <li><a href="shippedItems.jsp">Shipped</a></li>
                        <li><a href="unShippedItems.jsp">Orders</a></li>
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Manage Items <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="addProduct.jsp">Add Product</a></li>
                                <li><a href="removeProduct.jsp">Remove Product</a></li>
                                <li><a href="updateProductById.jsp">Update Product</a></li>
                            </ul>
                        </li>
                        <li><a href="./LogoutSrv"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

</body>
</html>
