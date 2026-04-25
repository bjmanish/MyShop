<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>View Products</title>
<!--        <meta charset="utf-8">-->
        <meta name="viewport" content="width=device-width, initial-scale=1">
<!--        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">-->
        <!--<link rel="stylesheet" href="../css/main.css">-->
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>      
    
    <style>
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

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String sid = (String) session.getAttribute("sessionId");
	String userType = (String) session.getAttribute("role");
//        System.out.println("view product admin details; "+userName+" userrole "+userType+" pass: "+password);
        System.out.println(session.getId());
	if(userType == null || !userType.equalsIgnoreCase("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");
	}else if (userName == null || sid == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
	}else{
            ProductServiceImpl prodDao = new ProductServiceImpl();
            List<ProductBean> products = new ArrayList<>();

            String search = request.getParameter("search");
            String type = request.getParameter("type");
            String message = "All Products";
            if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
            } else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
            } else {
		products = prodDao.getAllProducts();
            }
            if (products.isEmpty()) {
            	message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
            }
	%>

	<jsp:include page="/header.jsp" />

	
        <div class="container pt-5">
            <h4 class="text-center text-white fw-bold pt-5 mt-5"><%=message%></h4>
            <div class="row mt-4">

            <%
            for (ProductBean product : products) {
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
                     onerror="this.src='<%=request.getContextPath()%>/images/noimage.jpg'">
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

                <a href="updateProduct.jsp?pid=<%=product.getProdId()%>&userid=<%=userName %>"
                    class="btn btn-success btn-sm w-100 mb-2 btn-custom">Update Product
                </a>

                    <a href="removeProduct.jsp?prodid=<%=product.getProdId()%>&userid=<%=userName%>"
                       class="btn btn-warning btn-sm w-100 btn-custom">Remove Product
                    </a>
            </div>
        </div>

            <% } } %>
            <!-- ENd of Product Items List -->
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