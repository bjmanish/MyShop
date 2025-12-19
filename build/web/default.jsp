<%@ page import="java.util.List" %>
<%@ page import="com.myshop.beans.ProductBean" %>
<%@page language="Java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta >/
    <title>Products</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <!--<link rel="stylesheet" href="./css/main.css">-->
    <style>
    .product-row {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
    }

    .card {
        flex: 1 1 calc(33.333% - 15px); /* 3 cards per row */
        box-sizing: border-box;
        border: 1px solid #ddd;
        border-radius: 10px;
        background: #fff;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        padding: 15px;
        min-height: 400px; /* fixed height */
        transition: 0.3s;
    }

    .card:hover {
        box-shadow: 0px 0px 12px rgba(0,0,0,0.2);
    }

    .card img {
        max-height: 150px;
        object-fit: contain;
        margin: 0 auto 10px auto;
    }

    .card-title {
        font-size: 16px;
        font-weight: bold;
        height: 40px;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .card-price {
        color: green;
        font-size: 18px;
        font-weight: bold;
        margin-top: 5px;
    }

    .card-info {
        flex-grow: 1;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-top: 5px;
    }

    .btn-add {
        margin-top: 10px;
    }

    @media screen and (max-width: 768px) {
        .card {
            flex: 1 1 calc(50% - 15px);
        }
    }

    @media screen and (max-width: 480px) {
        .card {
            flex: 1 1 100%;
        }
    }
</style>

    
</head>
<body>
<div class="container">
    <h2>Products</h2>

    <!-- Search & Filter -->
    <form method="get" action="FetchProductSrv" class="form-inline" style="margin-bottom:20px;">
        <input type="text" name="search" placeholder="Search" value="<%= request.getAttribute("search") %>" class="form-control">
        <select name="category" class="form-control">
            <option value="">All Categories</option>
            <option value="electronics" <%= "electronics".equals(request.getAttribute("category")) ? "selected" : "" %>>Electronics</option>
            <option value="jewelery" <%= "jewelery".equals(request.getAttribute("category")) ? "selected" : "" %>>Jewelery</option>
            <option value="men's clothing" <%= "men's clothing".equals(request.getAttribute("category")) ? "selected" : "" %>>Men's Clothing</option>
            <option value="women's clothing" <%= "women's clothing".equals(request.getAttribute("category")) ? "selected" : "" %>>Women's Clothing</option>
        </select>
        <button type="submit" class="btn btn-primary">Filter</button>
    </form>

    <div class="product-row">
<%
//    List<String> images = (List<String>)request.getAttribute("image");
    List<ProductBean> products = (List<ProductBean>) request.getAttribute("products");
    if (products != null && !products.isEmpty()) {
        for (ProductBean p : products) {
//        String image = (String)request.getAttribute("image");
%>
    <div class="card">
        <div class="card-title"><%= p.getProdName() %></div>
        <div class="card-price">&#8377; <%= p.getProdPrice() %></div>
        <div class="card-info">
            <p>Category: <%= p.getProdType() %></p>
            <p><%= p.getProdInfo().length() > 80 ? p.getProdInfo().substring(0, 80) + "..." : p.getProdInfo() %></p>
        </div>
        <form action="AddProductSrv" method="post">
            <input type="hidden" name="productId" value="<%= p.getProdId() %>">
            <input type="hidden" name="productName" value="<%= p.getProdName() %>">
            <input type="hidden" name="productPrice" value="<%= p.getProdPrice() %>">
            <input type="hidden" name="productCategory" value="<%= p.getProdType() %>">
            <input type="hidden" name="productDescription" value="<%= p.getProdInfo() %>">
            <!--<input type="hidden" name="productImage" value="">-->
            <button type="submit" class="btn btn-success btn-add">Add to DB</button>
        </form>
    </div>
<%}
        
    } else {
%>
    <p>No products found.</p>
<%
    }
%>
</div>

    <!-- Pagination -->
    <ul class="pagination">
        <%
            int currentPage = (int) request.getAttribute("currentPage");
            int totalPages = (int) request.getAttribute("totalPages");
            for (int i = 1; i <= totalPages; i++) {
                String active = (i == currentPage) ? "active" : "";
        %>
        <li class="<%= active %>">
            <a href="FetchProductSrv?page=<%= i %>&search=<%= request.getAttribute("search") %>&category=<%= request.getAttribute("category") %>">
                <%= i %>
            </a>
        </li>
        <% } %>
    </ul>
</div>
</body>
</html>
