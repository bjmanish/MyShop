<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MYSHOP - Admin Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>

/* SIDEBAR */
.sidebar {
    height: calc(100vh - 56px);
    width: 220px;
    position: fixed;
    top: 56px;
    left: 0;
    background-color: #343a40;
    padding-top: 15px;
    transition: transform 0.3s ease;
    z-index: 1000;
}

/* MOBILE HIDDEN */
.sidebar-hidden {
    transform: translateX(-100%);
}

/* ACTIVE */
.sidebar.active {
    transform: translateX(0);
}

/* SIDEBAR LINKS */
.sidebar a {
    color: #adb5bd;
    display: block;
    padding: 12px 20px;
    text-decoration: none;
}

.sidebar a:hover,
.sidebar .active-link {
    background-color: #0d6efd;
    color: #fff;
}

/* TOGGLE BUTTON */
.toggle-btn {
    background: #0d6efd;
    border: none;
    color: white;
    padding: 6px 10px;
    border-radius: 6px;
}

/* CONTENT */
.content {
    margin-left: 220px;
    padding: 30px;
    transition: 0.3s;
}

.content-full {
    margin-left: 0;
}

/* OVERLAY */
#overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.4);
    display: none;
    z-index: 999;
}

#overlay.active {
    display: block;
}

/* CARDS */
.card-hover:hover {
    transform: scale(1.05);
    transition: 0.3s;
}

/* MOBILE */
@media (max-width: 768px) {

    .sidebar {
        transform: translateX(-100%);
    }

    .content {
        margin-left: 0;
    }
}

</style>
</head>

<body>

<%
String userName = (String) session.getAttribute("username");
String userType = (String) session.getAttribute("role");
String userid = userName;
String sid = (String)session.getAttribute("sessionId");

if (userName == null || userType == null || !userType.equalsIgnoreCase("admin") || sid==null) {
    response.sendRedirect("login.jsp?error=access_denied");
    return;
}
%>

<%@ include file="/header.jsp" %>

<!-- OVERLAY -->
<div id="overlay mt-5"></div>

<!-- SIDEBAR -->
<div class="sidebar" id="sidebar">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center px-3 mb-3">
        <h5 class="text-light m-0">MYSHOP</h5>
        <button class="toggle-btn" id="sidebarToggle">
            <i class="bi bi-list"></i>
        </button>
    </div>

    <a href="#" class="active-link"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
    <a href="adminViewProduct.jsp?id=<%=userid%>"><i class="bi bi-box-seam me-2"></i>View Products</a>
    <a href="addProduct.jsp?id=<%=userid%>"><i class="bi bi-plus-circle me-2"></i>Add Product</a>
    <a href="addStaff.jsp?id=<%=userid%>"><i class="bi bi-person-plus me-2"></i>Add Staff</a>
    <a href="viewStaff.jsp?id=<%=userid%>"><i class="bi bi-people me-2"></i>View Staff</a>
    <a href="viewUser.jsp?id=<%=userid%>"><i class="bi bi-people me-2"></i>Manage User</a>
    <a href="<%=request.getContextPath()%>/LogoutSrv"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>

</div>

<!-- CONTENT -->
<div class="content mt-5" id="mainContent">

<h2 class="mb-2 text-white">Welcome, <%= userName %> 👋</h2>
<p class="text-white">Manage your shop efficiently</p>

<div class="row g-4 mt-3">

<div class="col-md-3 col-sm-6">
<a href="adminViewProduct.jsp?id=<%=userid%>" class="text-decoration-none">
<div class="card card-hover text-center shadow p-3">
<i class="bi bi-box-seam display-5 text-primary"></i>
<h6 class="mt-2">View Products</h6>
</div>
</a>
</div>

<div class="col-md-3 col-sm-6">
<a href="addProduct.jsp?id=<%=userid%>" class="text-decoration-none">
<div class="card card-hover text-center shadow p-3">
<i class="bi bi-plus-circle display-5 text-success"></i>
<h6 class="mt-2">Add Product</h6>
</div>
</a>
</div>

<div class="col-md-3 col-sm-6">
<a href="addStaff.jsp?id=<%=userid%>" class="text-decoration-none">
<div class="card card-hover text-center shadow p-3">
<i class="bi bi-person-plus display-5 text-warning"></i>
<h6 class="mt-2">Add Staff</h6>
</div>
</a>
</div>

<div class="col-md-3 col-sm-6">
<a href="viewStaff.jsp?id=<%=userid%>" class="text-decoration-none">
<div class="card card-hover text-center shadow p-3">
<i class="bi bi-people display-5 text-danger"></i>
<h6 class="mt-2">View Staff</h6>
</div>
</a>
</div>

</div>

<div class="footer">
<jsp:include page="/footer.html" />
</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>

const sidebar = document.getElementById("sidebar");
const toggleBtn = document.getElementById("sidebarToggle");
const overlay = document.getElementById("overlay");

let startX = 0;
let endX = 0;

/* OPEN */
function openSidebar(){
    sidebar.classList.add("active");
    overlay.classList.add("active");
}

/* CLOSE */
function closeSidebar(){
    sidebar.classList.remove("active");
    overlay.classList.remove("active");
}

/* BUTTON */
toggleBtn.onclick = () => {
    if(sidebar.classList.contains("active")){
        closeSidebar();
    } else {
        openSidebar();
    }
};

/* OVERLAY CLICK */
overlay.onclick = closeSidebar;

/* TOUCH START */
document.addEventListener("touchstart", (e) => {
    startX = e.touches[0].clientX;
});

/* TOUCH END */
document.addEventListener("touchend", (e) => {
    endX = e.changedTouches[0].clientX;

    let diff = endX - startX;

    if(diff > 70) openSidebar();     // swipe right
    if(diff < -70) closeSidebar();   // swipe left
});

</script>

</body>
</html>