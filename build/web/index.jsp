<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.*"%>
<%--<%@ page language="java" contentType="text/html; charset=UTF-8"%>--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <!--<meta charset="UTF-8">-->
    <title>THE MYSHOP</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/x-icon" href="Myshop-logo.png">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/main.css">
</head>
<body style="background-color: #E6F9E6;">

<%
    // User validation
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    String userType = (String) session.getAttribute("usertype");
//    String id = session.getId();
//    if (userType == null || userName == null || password == null || !"customer".equals(userType)) {
//        response.sendRedirect("login.jsp?message=Please login as a customer");
//        return;
//    }

    // Product fetching
    ProductServiceImpl prodDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<>();

    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String message = "All Products";

    if (search != null) {
        products = prodDao.searchAllProducts(search);
        message = "Showing results for '" + search + "'";
    } else if (type != null) {
        products = prodDao.getAllProductsByType(type);
        message = "Showing results for '" + type + "'";
    } else {
        products = prodDao.getAllProducts();
    }

    if (products.isEmpty()) {
        message = "No items found for '" + (search != null ? search : type) + "'";
    }

    // Load cart once for optimization
    CartServiceImpl cartService = new CartServiceImpl();
    Map<Integer, Integer> cartMap = new HashMap<>();
    for (ProductBean p : products) {
        int qty = cartService.getCartItemCount(userName, p.getProdId());
//        cartMap.put(userName,p.getProdId());
    }
%>

<!-- Header -->
<jsp:include page="header.jsp" />

<div class="container my-3">
    <div class="text-center fw-bold text-dark"><%=message%></div>
    <div class="row g-2 mt-3">

        <%
        for (ProductBean product : products) {
            int cartQty = cartMap.getOrDefault(product.getProdId(), 0);
            String description = product.getProdInfo() != null ? product.getProdInfo() : "";
            String shortDescription = description.substring(0, Math.min(description.length(), 100));
        %>

        <div class="col-md-4 col-sm-5">
            <div class="card h-100 shadow-sm border-0">
                <img src="./ShowImage?pid=<%=product.getProdId()%>" 
                     class="card-img-top p-3" alt="Product" style="height:180px; object-fit:contain; border-radius: 100%;">

                <div class="card-body d-flex flex-column">
                    <h6 class="card-title text-truncate"><%=product.getProdName()%></h6>
                    
                    <p class="card-text small text-muted">
                        <span class="short-description"><%= shortDescription %></span>
                        <% if (description.length() > 100) { %>
                            <span class="full-description d-none"><%= description %></span>
                            <a href="#" class="read-more fw-bold text-primary" 
                               onclick="toggleDescription(this); return false;">Read More..</a>
                        <% } %>
                    </p>

                    <p class="fw-bold text-success">&#8377; <%=product.getProdPrice()%></p>

                    <form class="mt-auto" method="post">
                        <% if (cartQty == 0) { %>
                            <button type="submit" 
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" 
                                class="btn btn-sm btn-success w-100 mb-2">Add To Cart</button>
                            <button type="submit" 
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" 
                                class="btn btn-sm btn-primary w-100">Buy Now</button>
                        <% } else { %>
                            <button type="submit" 
                                formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" 
                                class="btn btn-sm btn-danger w-100 mb-2">Remove From Cart</button>
                            <button type="submit" 
                                formaction="cartDetails.jsp" 
                                class="btn btn-sm btn-warning w-100">Checkout</button>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>

        <% } %>

    </div>
</div>

<!-- Footer -->
<%@ include file="footer.html" %>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
function toggleDescription(link) {
    const parent = link.closest(".card-text");
    const shortDesc = parent.querySelector(".short-description");
    const fullDesc = parent.querySelector(".full-description");

    if (shortDesc.classList.contains("d-none")) {
        shortDesc.classList.remove("d-none");
        fullDesc.classList.add("d-none");
        link.innerText = "Read More..";
    } else {
        shortDesc.classList.add("d-none");
        fullDesc.classList.remove("d-none");
        link.innerText = "Read Less";
    }
}
</script>

</body>
</html>
