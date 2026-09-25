<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta http-equiv="X-UA-Compatible"
          content="IE=edge">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Delivery Staff - Dashboard | MyShop</title>


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

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/staff.css"/>

</head>


<body>


<%-- =========================================================
     SESSION VALIDATION
     ========================================================= --%>

<%

    String userType =
        (String) session.getAttribute("role");


    String userName =
        (String) session.getAttribute("username");
    
    String name =
        (String) session.getAttribute("name");

    String userId =
        (String) session.getAttribute("user_id");


    /*
     * Validate session safely.
     */

    if (userType == null
            || userId == null
            || userId.trim().isEmpty()
            || (
                !userType.equalsIgnoreCase("DELIVERY")
                &&
                !userType.equalsIgnoreCase("STAFF")
            )) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?error=access_denied"
        );

        return;
    }


    /*
     * Fallback username.
     */

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Staff";

    }

%>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="staff-container">


    <!-- =====================================================
         DASHBOARD HEADER
         ===================================================== -->

    <div class="dashboard-header">


        <div class="dashboard-icon">

            <i class="fa-solid fa-truck-fast"></i>

        </div>


        <h1>
            Delivery Staff Dashboard
        </h1>


        <p>

            Welcome,
            <span class="welcome-name">
                <%= name %>
            </span>

            — manage your deliveries efficiently.

        </p>


    </div>


    <!-- =====================================================
         DASHBOARD CARDS
         ===================================================== -->

    <div class="dashboard-grid">


        <!-- =================================================
             PENDING DELIVERIES
             ================================================= -->

        <div class="dashboard-card card-pending">


            <div class="card-icon">

                <i class="fa-solid fa-hourglass-half"></i>

            </div>


            <h3>
                Pending Deliveries
            </h3>


            <p>
                View orders that are currently
                waiting for delivery.
            </p>


            <a
                href="<%=request.getContextPath()%>/staff/pendingDeliveries.jsp?id=<%=userId%>"
                class="dashboard-btn btn-pending"
            >

                <i class="fa-solid fa-eye me-2"></i>

                View Pending

            </a>


        </div>


        <!-- =================================================
             UPDATE DELIVERY STATUS
             ================================================= -->

        <div class="dashboard-card card-update">


            <div class="card-icon">

                <i class="fa-solid fa-truck-arrow-right"></i>

            </div>


            <h3>
                Update Delivery Status
            </h3>


            <p>
                Update the current status of
                your assigned deliveries.
            </p>


            <a
                href="<%=request.getContextPath()%>/staff/updateDelivery.jsp"
                class="dashboard-btn btn-update"
            >

                <i class="fa-solid fa-pen-to-square me-2"></i>

                Update Status

            </a>


        </div>


        <!-- =================================================
             DELIVERY HISTORY
             ================================================= -->

        <div class="dashboard-card card-history">


            <div class="card-icon">

                <i class="fa-solid fa-clock-rotate-left"></i>

            </div>


            <h3>
                Delivery History
            </h3>


            <p>
                View your completed and previous
                delivery records.
            </p>


            <a
                href="<%=request.getContextPath()%>/staff/deliveryHistory.jsp"
                class="dashboard-btn btn-history"
            >

                <i class="fa-solid fa-list me-2"></i>

                View History

            </a>


        </div>


    </div>


    <!-- =====================================================
         USER INFORMATION
         ===================================================== -->

    <div class="user-info">

        <i class="fa-solid fa-user-circle"></i>

        Logged in as:

        <strong>
            <%= userName %>
        </strong>

        <span>|</span>

        Staff ID:

        <strong>
            <%= userId %>
        </strong>

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

        } else {

            document.body.classList.remove(
                "dark-mode"
            );

        }

    }


    applyTheme();

</script>


</body>

</html>