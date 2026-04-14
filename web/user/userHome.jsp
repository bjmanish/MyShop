<%@page import="com.myshop.service.impl.*"%>
<%@page import="com.myshop.beans.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<title>MyShop - Home</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- SweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
body {
    background: linear-gradient(135deg, #1d2671, #c33764);
    min-height: 100vh;
}

/* Product Card */
.product-card {
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(20px);
    border-radius: 20px;
    color: white;
    transition: 0.3s;
    padding: 15px;
    height: 100%;
}

.product-card:hover {
    transform: translateY(-10px) scale(1.02);
    box-shadow: 0 15px 40px rgba(0,0,0,0.5);
}

/* Image */
.product-img {
    height: 180px;
    object-fit: contain;
    border-radius: 12px;
    background: white;
    padding: 10px;
}

/* Price */
.price { color: #00ff88; font-weight: bold; }
.old-price { text-decoration: line-through; color: #ccc; font-size: 13px; }

/* Button */
.btn-custom {
    border-radius: 30px;
    font-weight: 500;
}

/* Toast */
.toast-msg {
    position: fixed;
    bottom: 20px;
    right: 20px;
    background: #28a745;
    color: white;
    padding: 12px 20px;
    border-radius: 10px;
    z-index: 9999;
}
</style>
</head>

<body>

<jsp:include page="/header.jsp" />

<%
String userName = (String) session.getAttribute("user_Id");
boolean isLoggedIn = (userName != null);

ProductServiceImpl prodDao = new ProductServiceImpl();
List<ProductBean> products = prodDao.getAllProducts();
%>

<div class="container mt-5 pt-5">

<h3 class="text-center text-white fw-bold mb-4">Explore Products</h3>

<div class="row g-4">

<% for(ProductBean product : products){

    String desc = product.getProdInfo() != null ? product.getProdInfo() : "";
    String shortDesc = desc.substring(0, Math.min(desc.length(), 70));

    double price = product.getProdPrice();
    double oldPrice = price + 500;
%>

<div class="col-lg-3 col-md-4 col-sm-6">

<div class="product-card d-flex flex-column">

<img src="<%=request.getContextPath()%>/ShowImage?pid=<%=product.getProdId()%>"
     class="product-img mb-3">

<h6><%=product.getProdName()%></h6>

<p class="small">
    <%=shortDesc%>...
</p>

<p>
    <span class="price">&#x20B9; <%=price%></span>
    <span class="old-price">&#x20B9; <%=oldPrice%></span>
</p>

<div class="mt-auto">

<% if(isLoggedIn){ %>

<button class="btn btn-success w-100 mb-2 btn-custom"
        onclick="addToCart('<%=product.getProdId()%>', this)">
    Add to Cart
</button>

<button class="btn btn-warning w-100 btn-custom"
        onclick="buyNow('<%=product.getProdId()%>')">
    Buy Now
</button>

<% } else { %>

<button onclick="showLoginAlert()" 
        class="btn btn-success w-100 mb-2 btn-custom">
    Add to Cart
</button>

<button onclick="showLoginAlert()" 
        class="btn btn-warning w-100 btn-custom">
    Buy Now
</button>

<% } %>

</div>

</div>
</div>

<% } %>

</div>
</div>

<jsp:include page="/footer.html" />

<!-- JS -->
<script>

// ? Add to Cart AJAX
function addToCart(pid, btn){

    btn.disabled = true;
    btn.innerText = "Adding...";

    fetch("<%=request.getContextPath()%>/AddtoCart", {
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"pid="+pid+"&pqty=1"
    })
    .then(res=>res.text())
    .then(()=>{
        btn.innerText = "Added";
        showToast("Added to Cart ");

        setTimeout(()=>{
            btn.disabled = false;
            btn.innerText = "Add to Cart";
        },1500);
    });
}

// ? Buy Now
function buyNow(pid){
    window.location.href = "<%=request.getContextPath()%>/AddtoCart?pid="+pid+"&pqty=1&buyNow=true";
}

// ? Toast
function showToast(msg){
    let toast = document.createElement("div");
    toast.className = "toast-msg";
    toast.innerText = msg;

    document.body.appendChild(toast);

    setTimeout(()=>toast.remove(),2000);
}

// ? Login Alert
function showLoginAlert(){
    Swal.fire({
        icon: 'warning',
        title: 'Login Required',
        text: 'Please login first',
        confirmButtonText: 'Login'
    }).then(()=>{
        window.location.href="login.jsp";
    });
}
</script>

</body>
</html>