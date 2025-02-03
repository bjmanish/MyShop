<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="com.myshop.beans.CartBean"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
    <head>
        <title>THE MYSHOP - Cart Details Page</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body style="background-color: #E6F9E6;">
        
        <!-- Checking user credentials -->
        
        <%
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");
            String userType = (String)session.getAttribute("usertype");
            
            if (userType == null || !userType.equalsIgnoreCase("customer")) {
                response.sendRedirect("login.jsp?error=access_denied");
                return;
            }
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");
                return;
            }
            
            String message = request.getParameter("message");
            
            String adds = request.getParameter("add");
            if(adds != null){
                
                int add = Integer.parseInt(adds);
                String uid = request.getParameter("uid");
                String pid = request.getParameter("pid");
                int avail = Integer.parseInt(request.getParameter("avail"));
                int cartQty = Integer.parseInt(request.getParameter("qty"));
                
                CartServiceImpl cart = new CartServiceImpl();
                if(add == 1){
                    //Add Product into the cart
                    cartQty +=1;
                    if(cartQty <= avail){
                        cart.addProductToCart(uid, 1, pid);
                    }else{
                        response.sendRedirect("./AddtoCart?pid=" + pid + "&pqty=" + cartQty);
                    }
                }else if(add == 0){
                    // Remove Product from cart
                    cart.removeProductFromCart(uid, pid);
                }
            }            
        %>
        
        <!-- get details to how many data will be add to cart -->

        <jsp:include page="header.jsp" ></jsp:include>
        <%if( message != null){%>
        <div class="text-center" style="color: red; font-weight: 500; font-size: 16px;"><p><%=message%></p></div>
        <%}%>
        <div class="text-center" style="color: darkslategray;">
            <h1>Cart Items</h1>
        </div>

<div class="container">
    <div class="row">
        <%  
            CartServiceImpl carts = new CartServiceImpl();
            List<CartBean> cartItems = carts.getAllCartItems(userName);
            double totalAmount = 0;
            
            for(CartBean item : cartItems){
                String prodId = item.getProdId();
                int prodQty = item.getQuantity();
                ProductServiceImpl products = new ProductServiceImpl();
                ProductBean product = products.getProductDetails(prodId);
                double currAmount = product.getProdPrice() * prodQty;
                totalAmount += currAmount;

                if(prodQty > 0){
        %>
        <!-- Card for each product -->
        <div class="col-md-4">
            <div class="card mb-3 shadow" style="border-radius: 10px;">
                <img src="./ShowImage?pid=<%=product.getProdId() %>" class="card-img-top" style="height: 180px; object-fit: cover;">
                <div class="card-body">
                    <h5 class="card-title"><%=product.getProdName()%></h5>
                    <p class="card-text">Price: <span>?</span><%=product.getProdPrice()%></p>
                    <p class="card-text">Total: ?<%=currAmount%></p>

                    <!-- Quantity Update Form -->
                    <form action="./UpdateCart" method="post" class="d-flex align-items-center">
                        <input type="number" name="pqty" value="<%=prodQty%>" min="1" max="<%=product.getProdQuantity()%>" class="form-control" style="max-width: 80px; display: inline;">
                        <input type="hidden" name="pid" value="<%=product.getProdId()%>">
                        <input type="hidden" name="uid" value="<%=userName%>">
                        <button type="submit" class="btn btn-primary btn-sm">Update</button>
                    </form>

                    <!-- Add and Remove Icons -->
                    <div class="mt-2">
                        <a href="cartDetails1.jsp?add=1&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQty%>" class="btn btn-success btn-sm">
                            <i class="fa fa-plus"></i> Add
                        </a>
                        <a href="cartDetails1.jsp?add=0&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQty%>" class="btn btn-danger btn-sm">
                            <i class="fa fa-minus"></i> Remove
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%  
                }
            }
        %>
    </div>

    <!-- Total Amount Section -->
    <div class="card p-3 text-center mt-4">
        <h4>Total Amount to Pay: ?<%=totalAmount%></h4>
        <div class="d-flex justify-content-center mt-3">
            <form method="post">
                <button formaction="userHome.jsp" class="btn btn-dark">Cancel</button>
            </form>
            <% if(totalAmount != 0){ %>
            <form method="post">
                <button formaction="payment.jsp?amount=<%=totalAmount%>" class="btn btn-success">Pay Now</button>
            </form>
            <% } %>
        </div>
    </div>
</div>
        
        <jsp:include page="footer.html"></jsp:include>

    </body>
</html>
