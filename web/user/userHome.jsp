<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>MYSHOP - Home</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- SweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            background: linear-gradient(135deg, #1d2671, #c33764);
            min-height: 100vh;
        }

        .product-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            color: white;
            transition: 0.3s;
            padding: 15px;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.4);
        }

        .product-img {
            height: 180px;
            object-fit: contain;
            border-radius: 15px;
            background: white;
            padding: 10px;
        }

        .price {
            color: #00ff88;
            font-weight: bold;
        }

        .old-price {
            text-decoration: line-through;
            color: #ccc;
            font-size: 13px;
        }

        .discount {
            color: #00ff88;
            font-size: 13px;
        }

        .btn-custom {
            border-radius: 30px;
            font-weight: 500;
        }
        .full-description {
            transition: all 0.3s ease;
        }
    </style>

</head>

<body>

<jsp:include page="/header.jsp" />

<%
    String userName = (String) session.getAttribute("username");
    boolean isLoggedIn = (userName != null && !userName.trim().isEmpty());

    ProductServiceImpl prodDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<>();

    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String message = "All Products";

    if (search != null) {
        products = prodDao.searchAllProducts(search);
        message = "Results for '" + search + "'";
    } else if (type != null) {
        products = prodDao.getAllProductsByType(type);
        message = "Category: " + type;
    } else {
        products = prodDao.getAllProducts();
    }
%>

<div class="container mt-5 pt-5">
    <h3 class="text-center pt-5 text-white fw-bold"><%=message%></h3>

    <div class="row mt-4">

    <% for (ProductBean product : products) { 
        String desc = product.getProdInfo() != null ? product.getProdInfo() : "";
        String shortDesc = desc.substring(0, Math.min(desc.length(), 80));

        double price = product.getProdPrice();
        double oldPrice = price + 500;
        int discount = (int)((500/oldPrice)*100);
    %>

        <div class="col-md-3 col-sm-6 mb-4">
            <div class="product-card h-100 d-flex flex-column">
                <!-- IMAGE (JS WILL LOAD) -->
                <img data-src="<%=request.getContextPath()%>/ShowImage?pid=<%=product.getProdId()%>" class="product-img lazy-img mx-auto mb-2" 
                     src="<%=request.getContextPath()%>/images/loader.gif"
                     onerror="this.src='images/noimage.jpg'">
                <h6 class="text-truncate"><%=product.getProdName()%></h6>
                <p class="small">
                    <span class="short-description"><%=shortDesc%></span>
                    <span class="full-description" style="display:none;"><%=desc%></span>
                    <% if(desc.length() > 80){ %>
                        <a href="javascript:void(0);" onclick="toggleDescription(this)" style="color:#00ffcc; cursor:pointer;">Read More..</a>
                    <% } %>
                </p>

                <p>
                    <span class="price">₹ <%=price%></span>
                    <span class="old-price">₹ <%=oldPrice%></span>
                    <span class="discount">(<%=discount%>% OFF)</span>
                </p>

                <!-- BUTTONS -->
                <% if (isLoggedIn) { %>

                <a href="cartDetails.jsp?pid=<%=product.getProdId()%>&uid=<%=(String)session.getAttribute("user_id")%>&cartId=<%=(String)session.getAttribute("cartId")%>"
                       class="btn btn-success btn-sm w-100 mb-2 btn-custom">
                       Add To Cart
                    </a>

                    <a href="<%=request.getContextPath()%>/AddtoCart?pid=<%=product.getProdId()%>&uid=<%=(String)session.getAttribute("user_id")%>&pqty=1"
                       class="btn btn-warning btn-sm w-100 btn-custom">
                       Buy Now
                    </a>

                <% } else { %>

                    <a href="<%=request.getContextPath()%>/AddtoCart?pid=<%=product.getProdId()%>&guest=true"
                       class="btn btn-success btn-sm w-100 mb-2 btn-custom">
                       Add To Cart
                    </a>

                    <button onclick="showLoginAlert()" 
                        class="btn btn-warning btn-sm w-100 btn-custom">
                        Buy Now
                    </button>

                <% } %>

            </div>
        </div>

    <% } %>

    </div>
</div>

<jsp:include page="/footer.html" />

<!-- ================= JS SECTION ================= -->

<script>
    
document.addEventListener("DOMContentLoaded", function () {

    const images = document.querySelectorAll(".lazy-img");

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {

            if (entry.isIntersecting) {
                const img = entry.target;

                const realSrc = img.getAttribute("data-src");

                img.src = realSrc;

                img.onload = () => {
                    img.classList.add("loaded");
                };

                observer.unobserve(img);
            }

        });
    }, {
        rootMargin: "50px"
    });

    images.forEach(img => observer.observe(img));
});
    
    function showLoginAlert(){
        Swal.fire({
            icon: 'warning',
            title: 'Login Required',
            text: 'Please signup/login first to continue purchase!',
            confirmButtonText: 'Go to Login',
            cancelButtonText: 'Cancel',
            showCancelButton: true,
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "login.jsp";
            }
            // if cancelled → do nothing
        });
    }
    
function toggleDescription(link){
    var parent = link.parentElement;

    var shortDesc = parent.querySelector('.short-description');
    var fullDesc = parent.querySelector('.full-description');

    if(shortDesc.style.display === 'none'){
        shortDesc.style.display = 'inline';
        fullDesc.style.display = 'none';
        link.innerText = 'Read More..';
    } else {
        shortDesc.style.display = 'none';
        fullDesc.style.display = 'inline';
        link.innerText = 'Read Less';
    }
}
</script>

</body>
</html>