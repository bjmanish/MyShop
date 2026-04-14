<%@ page language="java"%>
<%@page import="com.myshop.utility.idUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.myshop.service.impl.*"%>
<%@page import="com.myshop.beans.*"%>

<!DOCTYPE html>
<html>
<head>
<title>MyShop Cart</title>

<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f5f5f5; }

.container { max-width:1100px; }

/* LEFT CART */
.cart-card {
    background:white;
    border-radius:10px;
    padding:10px;
    margin-bottom:10px;
    display:flex;
    align-items:center;
    gap:10px;
}

/* IMAGE */
.cart-img {
    width:60px;
    height:60px;
    object-fit:contain;
    border-radius:8px;
    background:#fff;
}

/* QTY BUTTON */
.qty-btn {
    border:none;
    padding:3px 8px;
    background:#ddd;
    cursor:pointer;
    font-size:12px;
}

/* RIGHT PANEL */
.card {
    border-radius:10px;
}

/* REMOVE ANIMATION */
.remove-anim {
    transition:0.4s;
    opacity:0;
    transform:translateX(50px);
}
</style>
</head>

<body>

<jsp:include page="/header.jsp" />

<%
String userId = request.getParameter("uid");
String cartId = request.getParameter("cartId");

CartServiceImpl carts = new CartServiceImpl();
List<CartBean> cartItems = carts.getAllCartItems(cartId);

double totalAmount = 0;
double discount = 0;
%>

<div class="container mt-5">

<div class="row mt-5">

<!-- ================= LEFT SIDE ================= -->
<div class="col-md-8">

<h5 class="mb-3 mt-5">? My Cart</h5>

<%
for(CartBean item : cartItems){

    String prodId = item.getProdId();

    ProductServiceImpl products = new ProductServiceImpl();
    ProductBean product = products.getProductDetails(prodId);

    int qty = item.getQuantity();
    double amount = qty * product.getProdPrice();
    totalAmount += amount;
    
//    double oldPrice = amount + 500;
    discount = (totalAmount*0.02);
    
    
%>

<div class="cart-card" id="row_<%=prodId%>">

    <!-- IMAGE FIXED -->
    <img src="<%=request.getContextPath()%>/ShowImage?pid=<%=prodId%>" 
         class="cart-img"
         onerror="this.src='<%=request.getContextPath()%>/images/noimage.jpg'">

    <!-- DETAILS -->
    <div style="flex:1;">
        <h6><%=product.getProdName()%></h6>
        <p>&#x20B9; <%=product.getProdPrice()%></p>
    </div>

    <!-- QTY -->
    <div>
        <button class="qty-btn" onclick="updateQty('<%=prodId%>', -1)">-</button>
        <span id="qty_<%=prodId%>"><%=qty%></span>
        <button class="qty-btn" onclick="updateQty('<%=prodId%>', 1)">+</button>
    </div>

    <!-- AMOUNT -->
    <div style="min-width:80px;">
        &#x20B9; <span id="amount_<%=prodId%>"><%=amount%></span>
    </div>

    <!-- REMOVE -->
    <button class="btn btn-danger btn-sm" onclick="removeItem('<%=prodId%>', this)">&#10060; </button>

</div>

<% } %>

</div>

<!-- ================= RIGHT SIDE ================= -->
<div class="col-md-3 mt-5">

<!-- PRICE DETAILS -->
<div class="card p-3 mb-3">
    <h6><i class="bi bi-cash"></i> Price Details</h6>
    <hr>

    <p>Total Items: <%=cartItems.size()%></p>
    <p>Total Price: &#x20B9; <span id="cartTotal"><%=totalAmount%></span></p>

    <p class="text-success">Discount: &#x20B9; <span id="finalTotal"><%=discount%></span></p>

    <hr>

    <h5>Total Payable: &#x20B9; <span id="finalTotal"><%=totalAmount - discount %></span></h5>
</div>

<!-- COUPON -->
<div class="card p-3 mb-3">
    <h6><i class="bi bi-ticket-alt"></i> Apply Coupon</h6>

    <input type="text" id="coupon" class="form-control form-control-sm" placeholder="Enter Code">
    <button class="btn btn-primary btn-sm mt-2 w-100" onclick="applyCoupon()">Apply</button>
</div>

<!-- ACTION -->
<div class="card p-3">

    <a href="payment.jsp?userId=<%=userId%>&cartId=<%=cartId%>&amount=<%=totalAmount%>" 
       class="btn btn-success w-100 mb-2">
        <i class="bi bi-cash"></i> Checkout
    </a>

    <a href="userHome.jsp" class="btn btn-dark w-100">
        Continue Shopping
    </a>

</div>

</div>

</div>
</div>

<jsp:include page="/footer.html" />

<!-- JS -->
<script>

// ? UPDATE QTY
function updateQty(pid, change){
fetch("UpdateCartQtySrv",{
method:"POST",
headers:{"Content-Type":"application/x-www-form-urlencoded"},
body:"pid="+pid+"&change="+change
})
.then(res=>res.json())
.then(data=>{
document.getElementById("qty_"+pid).innerText = data.qty;
document.getElementById("amount_"+pid).innerText = data.amount;
document.getElementById("cartTotal").innerText = data.total;
document.getElementById("finalTotal").innerText = data.total;
});
}

// ? REMOVE ITEM
function removeItem(pid, btn){

let row = document.getElementById("row_"+pid);
row.classList.add("remove-anim");

setTimeout(()=>{ row.remove(); },400);

fetch("RemoveCartSrv",{
method:"POST",
headers:{"Content-Type":"application/x-www-form-urlencoded"},
body:"pid="+pid
});
}

// ? COUPON
function applyCoupon(){

let code = document.getElementById("coupon").value;

fetch("CouponSrv",{
method:"POST",
headers:{"Content-Type":"application/x-www-form-urlencoded"},
body:"code="+code
})
.then(res=>res.json())
.then(data=>{
if(data.success){
document.getElementById("cartTotal").innerText = data.newTotal;
document.getElementById("finalTotal").innerText = data.newTotal;
alert("Coupon Applied ?");
}else{
alert("Invalid Coupon ?");
}
});
}

</script>

</body>
</html>