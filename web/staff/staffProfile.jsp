<%@page import="com.myshop.service.StaffService"%>
<%@page import="com.myshop.beans.StaffBean"%>
<%@page import="com.myshop.service.impl.StaffServiceImpl"%>

<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>MYSHOP - Staff Profile</title>


    <!-- =====================================================
         FAVICON
         ===================================================== -->

    <link rel="icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">


    <!-- =====================================================
         BOOTSTRAP 5
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =====================================================
         GOOGLE FONT
         ===================================================== -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com">

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/staffp.css"/>

</head>


<body>


<%
    /* =========================================================
       SESSION VALIDATION
       ========================================================= */

    String userName =
        (String) session.getAttribute("username");

    String userType =
        (String) session.getAttribute("role");

    String userId =
        (String) session.getAttribute("user_id");


    if (userName == null
            || userType == null
            || userId == null
            || userId.trim().isEmpty()
            || (
                !"STAFF".equalsIgnoreCase(userType)
                &&
                !"DELIVERY".equalsIgnoreCase(userType)
            )) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message=Session Expired! Please Login Again!!"
        );

        return;

    }


    /* =========================================================
       FETCH STAFF
       ========================================================= */

    StaffService dao =
        new StaffServiceImpl();


    StaffBean staff = dao.getStaffDetails(userName);

    if (staff == null) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message=Staff profile not found"
        );

        return;

    }

%>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="profile-page">


    <!-- =====================================================
         BREADCRUMB
         ===================================================== -->

    <div class="breadcrumb-card">

        <nav aria-label="breadcrumb">

            <ol class="breadcrumb">

                <li class="breadcrumb-item">

                    <a href="<%=request.getContextPath()%>/index.jsp">

                        <i class="fa-solid fa-house me-1"></i>

                        Home

                    </a>

                </li>


                <li class="breadcrumb-item active"
                    aria-current="page">

                    Staff Profile

                </li>

            </ol>

        </nav>

    </div>


    <!-- =====================================================
         PROFILE GRID
         ===================================================== -->

    <div class="profile-grid">


        <!-- =================================================
             LEFT SIDE
             ================================================= -->

        <div>


            <!-- PROFILE -->

            <div class="glass-card profile-card">


                <div class="profile-icon">

                    <i class="fa-solid fa-user"></i>

                </div>


                <div class="profile-image-wrapper">

                    <img
                        class="profile-image"
                        src="<%=request.getContextPath()%>/showProfileImg?uid=<%=staff.getStaffId()%>"
                        alt="<%=staff.getName() %>"
                        onerror="this.src='<%=request.getContextPath()%>/images/noimage.jpg';"
                    >

                </div>


                <div class="hello-text">

                    Hello

                </div>


                <div class="staff-name">

                    <%=staff.getName()%>

                </div>


                <div class="staff-role">

                    <i class="fa-solid fa-id-badge"></i>

                    <%=userType%>

                </div>


            </div>


            <!-- QUICK LINKS -->

            <div class="glass-card quick-links">


                <div class="quick-title">

                    <i class="fa-solid fa-bars me-1"></i>

                    Quick Links

                </div>


                <a
                    href="<%=request.getContextPath()%>/staff/staffProfile.jsp"
                    class="quick-link"
                >

                    <i class="fa-solid fa-user"></i>

                    My Profile

                </a>


                <a
                    href="<%=request.getContextPath()%>/staff/pendingDeliveries.jsp?id=<%=userId%>"
                    class="quick-link"
                >

                    <i class="fa-solid fa-truck"></i>

                    Pending Deliveries

                </a>


                <a
                    href="<%=request.getContextPath()%>/staff/deliveryHistory.jsp"
                    class="quick-link"
                >

                    <i class="fa-solid fa-clock-rotate-left"></i>

                    Delivery History

                </a>


                <a
                    href="<%=request.getContextPath()%>/staff/updateDelivery.jsp"
                    class="quick-link"
                >

                    <i class="fa-solid fa-pen-to-square"></i>

                    Update Delivery

                </a>


                <a
                    href="<%=request.getContextPath()%>/LogoutSrv"
                    class="quick-link"
                >

                    <i class="fa-solid fa-right-from-bracket"></i>

                    Logout

                </a>


            </div>


        </div>


        <!-- =================================================
             RIGHT SIDE
             ================================================= -->

        <div class="glass-card details-card">


            <div class="details-title">


                <div class="details-title-icon">

                    <i class="fa-solid fa-address-card"></i>

                </div>


                <div>

                    <h2>
                        Staff Information
                    </h2>

                    <p>
                        Your registered staff account details
                    </p>

                </div>


            </div>


            <!-- FULL NAME -->

            <div class="info-row">

                <div class="info-label">

                    <i class="fa-solid fa-user"></i>

                    Full Name

                </div>


                <div class="info-value">

                    <%=staff.getName()%>

                </div>

            </div>


            <!-- STAFF ID -->

            <div class="info-row">

                <div class="info-label">

                    <i class="fa-solid fa-id-card"></i>

                    Staff ID

                </div>


                <div class="info-value">

                    <span class="staff-id">

                        <%=staff.getStaffId()%>

                    </span>

                </div>

            </div>


            <!-- MOBILE -->

            <div class="info-row">

                <div class="info-label">

                    <i class="fa-solid fa-phone"></i>

                    Phone

                </div>


                <div class="info-value">

                    <%=staff.getMobile()%>

                </div>

            </div>


            <!-- EMAIL -->

            <div class="info-row">

                <div class="info-label">

                    <i class="fa-solid fa-envelope"></i>

                    Email

                </div>


                <div class="info-value">

                    <%=userName%>

                </div>

            </div>


            <!-- ROLE -->

            <div class="info-row">

                <div class="info-label">

                    <i class="fa-solid fa-user-shield"></i>

                    Role

                </div>


                <div class="info-value">

                    <%=userType%>

                </div>

            </div>


        </div>


    </div>


</div>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"/>


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<!-- =========================================================
     THEME
     ========================================================= -->

<script>

    function applyTheme() {

        const theme =
            localStorage.getItem("myshop-theme");

        if (theme === "dark") {

            document.body.classList.add(
                "dark-mode"
            );

        }

    }


    applyTheme();

</script>


</body>

</html>