<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@ page language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- BOOTSTRAP -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<style>

/* BACKGROUND */
body {
    background: linear-gradient(135deg, #141e30, #243b55);
    transition: 0.3s;
}

/* DARK MODE */
.dark-mode {
    background: #000 !important;
    color: #fff !important;
}

/* NAVBAR */
.modern-nav {
    background: rgba(0,0,0,0.7);
    backdrop-filter: blur(10px);
    transition: 0.3s;
    z-index: 10000;
}

/* SCROLL EFFECT */
.nav-scrolled {
    padding: 5px 0;
    background: black !important;
}

/* LOGO */
.logo {
    font-weight: bold;
    color: white !important;
}

/* SEARCH */
.search-box input {
    width: 280px;
    border-radius: 20px;
}

/* NAV LINKS */
.nav-link {
    color: white !important;
}

/* NOTIFICATION */
.notif-badge {
    position: absolute;
    top: 0;
    right: -5px;
    background: red;
    color: white;
    font-size: 10px;
    padding: 2px 5px;
    border-radius: 50%;
}

/* MOBILE MENU */
#mobileMenu {
    position: fixed;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: #111;
    padding: 20px;
    transition: 0.3s;
    z-index: 2000;
}

#mobileMenu.active {
    left: 0;
}

#mobileMenu a {
    display: block;
    padding: 15px;
    color: white;
    font-size: 18px;
    text-decoration: none;
}

/* OVERLAY */
#menuOverlay {
    position: fixed;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    display: none;
    z-index: -1500;
}

#menuOverlay.active {
    display: block;
}

</style>

</head>
<body>

<%
String role = (String) session.getAttribute("role");
String name = (String) session.getAttribute("name");
String userId = (String)session.getAttribute("user_id");
int cartCount = new CartServiceImpl().getCartCount(userId);
System.out.println("cart qnty :"+cartCount);
String homePage = "index.jsp";
if ("customer".equalsIgnoreCase(role)) homePage = "userHome.jsp";
else if ("admin".equalsIgnoreCase(role)) homePage = "adminHome.jsp";
else if ("staff".equalsIgnoreCase(role) || "delivery".equalsIgnoreCase(role)) homePage = "staffHome.jsp";
%>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg modern-nav fixed-top" id="navbar">
<div class="container">

<a class="navbar-brand logo" href="<%=homePage%>">
<i class="bi bi-bag-heart-fill"></i> MYSHOP
</a>

<!-- SEARCH -->
<div class="search-box d-none d-lg-flex mx-3">
<input type="text" class="form-control" placeholder="Search products...">
</div>

<!-- TOGGLE -->
<button class="navbar-toggler text-white" id="navToggleBtn">
<i class="bi bi-list"></i>
</button>

<!-- MENU -->
<div class="collapse navbar-collapse" id="menu">
<ul class="navbar-nav ms-auto align-items-lg-center gap-lg-3">

<!-- ? -->
<li class="nav-item position-relative">
<a class="nav-link"><i class="bi bi-bell"></i><span class="notif-badge">3</span></a>
</li>

<!-- ? -->
<li class="nav-item">
<a class="nav-link" id="themeToggle"><i class="bi bi-moon"></i></a>
</li>

<% if (role == null) { %>

<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">Home</a></li>
<li class="nav-item position-relative">
<a class="nav-link"onclick="handleCartClick()">
<i class="bi bi-cart3"></i>
<span class="notif-badge" id="cartCount">
<%= ( (cartCount != 0) ? cartCount : 0 )%>
</span>
</a>
</li>

<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/login.jsp">Login</a></li>

<% } else { %>

<%--<li class="nav-item"><a class="nav-link" href="<%=homePage%>">Home</a></li>--%>
<!-- ? CART (NEW - ADDED) -->
<li class="nav-item position-relative">
<a class="nav-link" href="cart.jsp?cartId=<%=(String)session.getAttribute("cartId")%>&uid=<%=userId%>" onclick="handleCartClick()">
<i class="bi bi-cart3"></i>
<span class="notif-badge" id="cartCount">
<%= ( (cartCount != 0) ? cartCount : 0 )%>
</span>
</a>
</li>
<li class="nav-item"><a class="nav-link" href="userProfile.jsp">Welcome <%=name%></a></li>
<li class="nav-item"><a class="nav-link" href="#" onclick="openLogoutModal()">Logout</a></li>

<% } %>

</ul>
</div>
</div>
</nav>

<!-- MOBILE MENU -->
<div id="mobileMenu">

<div class="d-flex justify-content-between">
<h4>Menu</h4>
<button id="closeMenu" class="btn btn-light btn-sm">X</button>
</div>

<input type="text" class="form-control my-3" placeholder="Search...">

<a href="<%=homePage%>">Home</a>
<a href="#">Orders</a>
<a href="userProfile.jsp">Profile</a>
<a href="#" onclick="openLogoutModal()">Logout</a>

</div>

<!-- OVERLAY -->
<div id="menuOverlay"></div>

<!-- LOGOUT MODAL -->
<div class="modal fade" id="logoutModal">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content text-center">

<div class="modal-header">
<h5>Confirm Logout</h5>
<button class="btn-close" data-bs-dismiss="modal"></button>
</div>

<div class="modal-body">
<p>Are you sure you want to logout?</p>
</div>

<div class="modal-footer justify-content-center">
<button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
<button class="btn btn-danger" onclick="confirmLogout()">Logout</button>
</div>

</div>
</div>
</div>

<script>

// MOBILE MENU
const toggleBtn = document.getElementById("navToggleBtn");
const mobileMenu = document.getElementById("mobileMenu");
const overlay = document.getElementById("menuOverlay");
const closeBtn = document.getElementById("closeMenu");

toggleBtn.onclick = () => {
    mobileMenu.classList.add("active");
    overlay.classList.add("active");
};

closeBtn.onclick = closeMenu;
overlay.onclick = closeMenu;

function closeMenu(){
    mobileMenu.classList.remove("active");
    overlay.classList.remove("active");
}

// DARK MODE
document.getElementById("themeToggle").onclick = () => {
    document.body.classList.toggle("dark-mode");
};

// SCROLL NAVBAR
window.addEventListener("scroll", () => {
    document.getElementById("navbar")
    .classList.toggle("nav-scrolled", window.scrollY > 50);
});

// LOGOUT
function openLogoutModal() {
    new bootstrap.Modal(document.getElementById('logoutModal')).show();
}

function confirmLogout() {
    window.location.href = "<%=request.getContextPath()%>/LogoutSrv";
}

</script>

</body>
</html>