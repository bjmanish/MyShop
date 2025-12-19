<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MYSHOP - Admin Dashboard</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f0f4f8;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            height: calc(100vh - 70px);
            width: 220px;
            position: fixed;
            top: 70px;
            left: 0;
            background-color: #343a40;
            padding-top: 20px;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .sidebar a {
            color: #adb5bd;
            display: block;
            padding: 12px 20px;
            text-decoration: none;
        }

        .sidebar a:hover,
        .sidebar .active {
            background-color: #0d6efd;
            color: #fff;
        }

        /* Sidebar collapsed */
        .sidebar-collapsed {
            width: 0;
            overflow: hidden;
        }

        /* Content */
        .content {
            margin-left: 220px;
            padding: 30px;
            transition: all 0.3s ease;
        }

        .content-collapsed {
            margin-left: 0;
        }

        /* Cards */
        .card-hover:hover {
            transform: scale(1.05);
            transition: 0.3s;
        }

        /* Toggle button */
        .sidebar-toggle-btn {
            position: fixed;
            top: 15px;
            left: 15px;
            z-index: 1100;
            background-color: #0d6efd;
            border: none;
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
        }

        @media (min-width: 992px) {
            .sidebar-toggle-btn {
                display: none;
            }
        }

        .footer {
            margin-top: 50px;
        }
    </style>
</head>
<body>

<%
    String userName = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("usertype");
    String userid = session.getId();

    if (userName == null || userType == null || !userType.equalsIgnoreCase("admin") || userid==null) {
        response.sendRedirect("login.jsp?error=access_denied");
        return;
    }
%>

<%@ include file="header.jsp" %>

<button class="sidebar-toggle-btn" id="sidebarToggle">
    <i class="bi bi-list"></i>
</button>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <h5 class="text-light text-center mb-3">MYSHOP Admin</h5>
    <a href="#" class="active"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
    <a href="adminViewProduct.jsp?id=<%=userid%>"><i class="bi bi-box-seam me-2"></i>View Products</a>
    <a href="FetchProductSrv"><i class="bi bi-plus-circle me-2"></i>Add Product</a>
    <a href="addStaff.jsp<%=userid%>"><i class="bi bi-person-plus me-2"></i>Add Staff</a>
    <a href="viewStaff.jsp<%=userid%>"><i class="bi bi-people me-2"></i>View Staff</a>
    <a href="LogoutSrv"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
</div>

<!-- Content -->
<div class="content" id="mainContent">

    <h2 class="mb-2">Welcome, <%= userName %> 👋</h2>
    <p class="text-muted">Manage your shop efficiently</p>

    <div class="row g-4 mt-3">
        <div class="col-md-3 col-sm-6">
            <a href="adminViewProduct.jsp<%=id%>" class="text-decoration-none">
                <div class="card card-hover text-center shadow p-3">
                    <i class="bi bi-box-seam display-5 text-primary"></i>
                    <h6 class="mt-2">View Products</h6>
                </div>
            </a>
        </div>

        <div class="col-md-3 col-sm-6">
            <a href="FetchProductSrv" class="text-decoration-none">
                <div class="card card-hover text-center shadow p-3">
                    <i class="bi bi-plus-circle display-5 text-success"></i>
                    <h6 class="mt-2">Add Product</h6>
                </div>
            </a>
        </div>

        <div class="col-md-3 col-sm-6">
            <a href="addStaff.jsp<%=id%>" class="text-decoration-none">
                <div class="card card-hover text-center shadow p-3">
                    <i class="bi bi-person-plus display-5 text-warning"></i>
                    <h6 class="mt-2">Add Staff</h6>
                </div>
            </a>
        </div>

        <div class="col-md-3 col-sm-6">
            <a href="viewStaff.jsp<%=id%>" class="text-decoration-none">
                <div class="card card-hover text-center shadow p-3">
                    <i class="bi bi-people display-5 text-danger"></i>
                    <h6 class="mt-2">View Staff</h6>
                </div>
            </a>
        </div>
    </div>

    <div class="footer">
        <%@ include file="footer.html" %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const sidebar = document.getElementById("sidebar");
    const content = document.getElementById("mainContent");

    document.getElementById("sidebarToggle").onclick = () => {
        sidebar.classList.toggle("sidebar-collapsed");
        content.classList.toggle("content-collapsed");
    };
</script>

</body>
</html>
