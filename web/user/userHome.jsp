<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="java.util.*"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>

<!DOCTYPE html>
<html>
<head>
<title>MyShop - Home</title>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.6.2/css/bootstrap.min.css">-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

<style>
body { background:#f1f3f6; }

.product-card {
    border-radius:10px;
    transition:0.3s;
    background:#fff;
}
.product-card:hover {
    transform:translateY(-5px);
    box-shadow:0 4px 20px rgba(0,0,0,0.2);
}

.product-img {
    height:180px;
    object-fit:contain;
}

.price { color:#28a745; font-weight:bold; }

.old-price {
    text-decoration: line-through;
    color:gray;
    font-size:13px;
}

.discount {
    color:green;
    font-size:13px;
}

.cart-badge {
    position:absolute;
    top:10px;
    right:10px;
    background:red;
    color:#fff;
    padding:3px 7px;
    border-radius:50%;
}

.search-box {
    width:50%;
    margin:auto;
}

</style>
</head>

<body>

<jsp:include page="/header.jsp"/>

<%
String userName = (String)session.getAttribute("username");
String userType = (String)session.getAttribute("role");
String user_id = (String)session.getAttribute("user_id");

if(userType == null || !userType.equalsIgnoreCase("customer")){
    response.sendRedirect("login.jsp");
    return;
}

ProductServiceImpl dao = new ProductServiceImpl();
List<ProductBean> products = dao.getAllProducts();
%>

<!-- ? SEARCH 
<div class="container mt-4">
    <input type="text" id="searchBox" class="form-control search-box" placeholder="Search products...">
</div>-->

<!-- CATEGORY FILTER -->
<div class="text-center mt-3">
    <a href="?type=mobile" class="btn btn-outline-primary btn-sm">Mobiles</a>
    <a href="?type=laptop" class="btn btn-outline-success btn-sm">Laptops</a>
    <a href="?type=Electronics" class="btn btn-outline-danger btn-sm">Watches</a>
</div>

<div class="container mt-4">
<div class="row" id="productContainer">

<%
for(ProductBean p : products){
int cartQty = new CartServiceImpl().getCartItemCount(user_id, p.getProdId());

// Fake discount logic
double price = p.getProdPrice();
double oldPrice = price + 500;
int discount = (int)((500/oldPrice)*100);
%>

<div class="col-md-3 mb-4 product-item">

<div class="card product-card p-2 text-center position-relative">

<% if(cartQty > 0){ %>
<span class="cart-badge">?</span>
<% } %>

<img src="<%=request.getContextPath()%>/ShowImage?pid=<%=p.getProdId()%>" class="product-img" onerror="this.src='../images/noimage.jpg';" >

<h6><%=p.getProdName()%></h6>

<p> <%=p.getProdInfo()%> </p>

<p>
<span class="price">&#8377; <%=price%></span>
<span class="old-price">&#8377; <%=oldPrice%></span>
<span class="discount">(<%=discount%>% OFF)</span>
</p>

<button class="btn btn-sm btn-success addCartBtn"
    data-id="<%=p.getProdId()%>">
    Add to Cart
</button>

<button class="btn btn-sm btn-outline-danger mt-1">
    Wishlist
</button>

</div>
</div>

<% } %>

</div>
</div>

<script>

// ? LIVE SEARCH FILTER
$("#searchBox").on("keyup", function(){
    var value = $(this).val().toLowerCase();
    $(".product-item").filter(function(){
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
});

// ? AJAX ADD TO CART
$(".addCartBtn").click(function(){
    var pid = $(this).data("id");

    $.ajax({
        url: "AddtoCart",
        method: "GET",
        data: { pid: pid, pqty:1 },
        success: function(){
            alert("Added to cart!");
            location.reload();
        }
    });
});

</script>

<jsp:include page="/footer.html" />

</body>
</html>