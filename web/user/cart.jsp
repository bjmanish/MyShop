<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.*"%>
<%@page import="com.myshop.service.impl.*"%>
<%@page import="com.myshop.beans.*"%>

<!DOCTYPE html>
<html>
<head>
<title>MyShop Cart</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
body { background:#f5f5f5; }
.container { max-width:1100px; }

.cart-card{
    background:white;
    border-radius:10px;
    padding:10px;
    margin-bottom:10px;
    display:flex;
    align-items:center;
    gap:10px;
}

.cart-img{
    width:60px;
    height:60px;
    object-fit:contain;
}

.qty-btn{
    border:none;
    padding:3px 8px;
    background:#ddd;
    cursor:pointer;
}

.remove-anim{
    transition: all 0.4s ease;
    opacity:0;
    transform: translateX(100px);
}
</style>
</head>

<body>

<jsp:include page="/header.jsp" />

<%
String cartId = request.getParameter("cartId");
String prodId = "";
CartServiceImpl carts = new CartServiceImpl();
List<CartBean> cartItems = carts.getAllCartItems(cartId);

double totalAmount = 0;
double discount = 0;

// ✅ CALCULATE TOTAL ONLY ONCE
if(cartItems != null){
    for(CartBean item : cartItems){
        ProductBean product = new ProductServiceImpl().getProductDetails(item.getProdId());
        totalAmount += item.getQuantity() * product.getProdPrice();
    }
}
discount = totalAmount * 0.02;
%>

<div class="container mt-5">
<div class="row mt-5">

<!-- LEFT -->
<div class="col-md-8">

<div class="mt-4 fs-4 fw-bold text-warning mb-4">🛒 My Cart</div>

<% if(cartItems == null || cartItems.size() == 0){ %>

    <!-- ✅ EMPTY CART -->
    <div class="text-center mt-5">
        <h3 class="text-success">No items in cart 🛒</h3>
        <!--<a href="userHome.jsp" class="btn btn-dark mt-3">Continue Shopping</a>-->
    </div>

<% } else { 

    for(CartBean item : cartItems){

        String pid = item.getProdId();
        prodId= pid;
        ProductBean product = new ProductServiceImpl().getProductDetails(pid);

        int qty = item.getQuantity();
        double amount = qty * product.getProdPrice();
%>

<div class="cart-card" id="row_<%=pid%>">

<img src="<%=request.getContextPath()%>/ShowImage?pid=<%=pid%>"
     class="cart-img"
     onerror="this.src='<%=request.getContextPath()%>/images/noimage.jpg'">

<div style="flex:1;">
    <h6><%=product.getProdName()%></h6>
    <p>₹ <%=product.getProdPrice()%></p>
</div>

<div>
    <button class="qty-btn" onclick="updateQty('<%=pid%>', -1)">-</button>
    <span id="qty_<%=pid%>"><%=qty%></span>
    <button class="qty-btn" onclick="updateQty('<%=pid%>', 1)">+</button>
</div>

<div>
    ₹ <span id="amount_<%=pid%>"><%=amount%></span>
</div>

<button class="btn btn-danger btn-sm" onclick="removeItem('<%=pid%>')">❌</button>

</div>

<% } } %>

</div>

<!-- RIGHT -->
<% if(cartItems != null && cartItems.size() > 0){ %>
<div class="col-md-4 mt-4">

<div class="card p-3 mb-3">
<h6>Price Details</h6>
<hr>

<p>Total Price: ₹ <span id="cartTotal"><%=totalAmount%></span></p>
<p class="text-success">Discount: ₹ <span id="discount"><%=discount%></span></p>

<hr>

<h5>Payable: ₹ <span id="payable"><%=totalAmount-discount%></span></h5>
</div>

<div class="card p-3">
    <form id="checkoutForm" method="post" action="<%=request.getContextPath()%>/PaymentServlet?pid=<%=prodId%>&cartId="<%=cartId%>>
    
    <input type="hidden" name="amount" id="hiddenAmount" value="<%=totalAmount-discount%>">
    <input type="hidden" name="pid" id="hiddenProdId" value="<%=prodId%>">
    <button class="btn btn-success w-100" onclick="handleCheckout()">Checkout</button>

</form>

<!--<button class="btn btn-success w-100" onclick="handleCheckout()">Checkout</button>-->

<a href="userHome.jsp" class="btn btn-dark w-100 mt-2">Continue</a>

</div>

</div>
<% } %>

</div>
</div>

<jsp:include page="/footer.html" />

<!-- ================= JS ================= -->
<script>

// 🔥 RECALCULATE TOTAL
function recalculateCart(){
    let total = 0;

    document.querySelectorAll("[id^='amount_']").forEach(el=>{
        total += parseFloat(el.innerText);
    });

    let discount = total * 0.02;
    let payable = total - discount;

    document.getElementById("cartTotal").innerText = total.toFixed(2);
    document.getElementById("discount").innerText = discount.toFixed(2);
    document.getElementById("payable").innerText = payable.toFixed(2);

    document.getElementById("hiddenAmount").value = payable.toFixed(2);
}


// ➕➖ UPDATE QTY
function updateQty(pid, change){

fetch("<%=request.getContextPath()%>/UpdateToCart",{
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:"pid="+pid+"&change="+change+"&cartId=<%=cartId%>"
})
.then(res=>res.json())
.then(data=>{

    if(data.status==="success"){

        document.getElementById("qty_"+pid).innerText = data.qty;
        document.getElementById("amount_"+pid).innerText = data.amount;

        recalculateCart();

    }else{
        Swal.fire("Error","Qty update failed","error");
    }
});
}


// ❌ REMOVE ITEM
function removeItem(pid){

let row = document.getElementById("row_"+pid);

fetch("<%=request.getContextPath()%>/RemoveCartSrv",{
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:"pid="+pid+"&cartId=<%=cartId%>"
})
.then(res=>res.json())
.then(res=>{

    if(res.status==="success"){

        row.classList.add("remove-anim");

        setTimeout(()=>{
            row.remove();
            recalculateCart();

            if(document.querySelectorAll(".cart-card").length===0){
                document.querySelector(".container").innerHTML =
                    "<h3 class='text-center mt-5 text-success'>Cart Empty 🛒</h3>";
            }

        },400);

        Swal.fire("Removed","Item removed","success");

    }else{
        Swal.fire("Error","Remove failed","error");
    }
});
}

function handleCheckout(){

    let totalItems = document.querySelectorAll(".cart-card").length;

    // ❌ Empty cart check
    if(totalItems === 0){
        Swal.fire({
            icon: "warning",
            title: "Cart Empty",
            text: "Please add items before checkout"
        });
        return;
    }

    // 💰 Get payable amount
    let amount = document.getElementById("payable").innerText;

    if(!amount || parseFloat(amount) <= 0){
        Swal.fire({
            icon: "error",
            title: "Invalid Amount",
            text: "Something went wrong with total calculation"
        });
        return;
    }

    // 🔄 Disable button to prevent double click
    let btn = event.target;
    btn.disabled = true;
    btn.innerHTML = "Processing... ⏳";

    // 🔥 Update hidden field
    document.getElementById("hiddenAmount").value = amount;

    // ✅ Submit form
    setTimeout(()=>{
        btn.closest("form").submit();
    }, 500);
}

</script>

</body>
</html>