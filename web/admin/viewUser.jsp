<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.beans.UserDetails"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page session="true"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>All Users - MyShop</title>

    <!-- Bootstrap 5 -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Font Awesome -->
    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
        rel="stylesheet">

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 20px 0 40px;
            background: linear-gradient(135deg, #f5f7fa, #e9eef5);
            font-family: Arial, Helvetica, sans-serif;
            min-height: 100vh;
        }

        .main-container {
            max-width: 1400px;
            margin: 60px auto;
            padding: 0 15px;
        }

        /* ==============================
           PAGE HEADER
        ============================== */

        .page-header {
            background: linear-gradient(135deg, #1d2671, #c33764);
            color: white;
            padding: 25px 30px;
            border-radius: 18px;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .page-header h2 {
            margin: 0;
            font-weight: 700;
        }

        .page-header p {
            margin: 6px 0 0;
            opacity: 0.9;
        }

        /* ==============================
           SEARCH CARD
        ============================== */

        .search-card {
            background: rgba(255,255,255,0.95);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .search-wrapper {
            position: relative;
        }

        .search-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #777;
        }

        #searchInput {
            width: 100%;
            padding-left: 42px;
            height: 48px;
            border-radius: 12px;
        }

        /* ==============================
           SUMMARY
        ============================== */

        .summary-card {
            background: white;
            border-radius: 14px;
            padding: 15px 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.07);
        }

        .summary-icon {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #eef2ff;
            color: #3949ab;
            font-size: 20px;
        }

        .summary-number {
            font-size: 22px;
            font-weight: 700;
        }

        .summary-label {
            color: #777;
            font-size: 13px;
        }

        /* ==============================
           TABLE CARD
        ============================== */

        .table-card {
            background: white;
            border-radius: 16px;
            padding: 15px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .table-responsive {
            border-radius: 12px;
        }

        table {
            margin-bottom: 0 !important;
        }

        thead th {
            white-space: nowrap;
            font-size: 13px;
            vertical-align: middle;
            padding: 14px 10px !important;
        }

        tbody td {
            font-size: 13px;
            vertical-align: middle;
            padding: 12px 8px !important;
        }

        tbody tr {
            transition: 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f8f9ff;
            transform: scale(1.002);
        }

        /* ==============================
           PROFILE IMAGE
        ============================== */

        .profile-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 12px;
            border: 2px solid #eee;
        }

        /* ==============================
           BADGES
        ============================== */

        .role-badge,
        .status-badge,
        .vehicle-badge,
        .license-badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .role-admin {
            background: #fce4ec;
            color: #ad1457;
        }

        .role-delivery {
            background: #e3f2fd;
            color: #1565c0;
        }

        .role-customer {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .role-other {
            background: #eeeeee;
            color: #555;
        }

        .status-active {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .status-inactive {
            background: #ffebee;
            color: #c62828;
        }

        .status-other {
            background: #fff3e0;
            color: #ef6c00;
        }

        .vehicle-badge {
            background: #f3e5f5;
            color: #6a1b9a;
        }

        .license-yes {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .license-no {
            background: #ffebee;
            color: #c62828;
        }

        /* ==============================
           ACTION BUTTONS
        ============================== */

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 6px;
            flex-wrap: wrap;
        }

        .action-buttons .btn {
            border-radius: 8px;
            font-size: 12px;
        }

        /* ==============================
           MOBILE USER CARD
        ============================== */

        .mobile-user-list {
            display: none;
        }

        .user-card {
            background: white;
            border-radius: 16px;
            padding: 18px;
            margin-bottom: 15px;
            box-shadow: 0 5px 18px rgba(0,0,0,0.08);
        }

        .user-card-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 15px;
        }

        .mobile-profile-img {
            width: 65px;
            height: 65px;
            object-fit: cover;
            border-radius: 14px;
            border: 2px solid #eee;
            flex-shrink: 0;
        }

        .user-card-name {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 3px;
        }

        .user-card-email {
            color: #777;
            font-size: 12px;
            word-break: break-word;
        }

        .user-info-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            padding: 9px 0;
            border-bottom: 1px solid #eee;
        }

        .user-info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #777;
            font-size: 12px;
            font-weight: 600;
        }

        .info-value {
            font-size: 12px;
            font-weight: 600;
            text-align: right;
            word-break: break-word;
        }

        .mobile-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
        }

        .mobile-actions .btn {
            flex: 1;
            border-radius: 9px;
        }

        /* ==============================
           NO DATA
        ============================== */

        .no-data {
            padding: 35px !important;
            color: #dc3545;
            font-weight: 600;
        }

        .no-data i {
            font-size: 35px;
            margin-bottom: 10px;
        }

        /* ==============================
           RESPONSIVE
        ============================== */

        @media (max-width: 991px) {

            .main-container {
                margin-top: 20px;
            }

            .table-card {
                padding: 10px;
            }

            thead th,
            tbody td {
                font-size: 12px;
            }

            .profile-img {
                width: 50px;
                height: 50px;
            }
        }

        @media (max-width: 767px) {

            body {
                padding: 10px 0 30px;
            }

            .main-container {
                margin: 15px auto;
                padding: 0 10px;
            }

            .page-header {
                padding: 20px;
                border-radius: 14px;
            }

            .page-header h2 {
                font-size: 22px;
            }

            .page-header p {
                font-size: 13px;
            }

            .search-card {
                padding: 12px;
            }

            .summary-card {
                padding: 13px;
            }

            /* Hide desktop table */
            .desktop-user-table {
                display: none;
            }

            /* Show mobile cards */
            .mobile-user-list {
                display: block;
            }

            .table-card {
                background: transparent;
                box-shadow: none;
                padding: 0;
            }

        }

        @media (max-width: 400px) {

            .page-header h2 {
                font-size: 19px;
            }

            .user-card {
                padding: 14px;
            }

            .user-card-name {
                font-size: 15px;
            }

            .mobile-profile-img {
                width: 55px;
                height: 55px;
            }

        }

    </style>

</head>

<body>

<%
    /* ============================================
       SESSION VALIDATION
    ============================================ */

    String userName = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("role");

    if (userName == null ||
        userType == null ||
        !userType.equalsIgnoreCase("admin")) {

        response.sendRedirect("login.jsp?error=access_denied");
        return;
    }

    /* ============================================
       FETCH ALL USERS
    ============================================ */

    List<UserDetails> userList = new ArrayList<>();

    UserServiceImpl sdao = new UserServiceImpl();

    userList = sdao.getAllUsers();

    int totalUsers = (userList != null) ? userList.size() : 0;
%>

<!-- Header -->
<jsp:include page="/header.jsp" />


<div class="main-container">

    <!-- ============================
         PAGE HEADER
    ============================= -->

    <div class="page-header">

        <h2>
            <i class="fa-solid fa-users me-2"></i>
            All Users
        </h2>

        <p>
            Manage and view all registered users, staff and administrators.
        </p>

    </div>


    <!-- ============================
         SEARCH
    ============================= -->

    <div class="search-card">

        <div class="search-wrapper">

            <i class="fa-solid fa-magnifying-glass"></i>

            <input
                type="text"
                id="searchInput"
                class="form-control"
                placeholder="Search by ID, name, email, mobile, role, vehicle or status">

        </div>

    </div>


    <!-- ============================
         USER COUNT
    ============================= -->

    <div class="summary-card">

        <div class="d-flex align-items-center gap-3">

            <div class="summary-icon">
                <i class="fa-solid fa-users"></i>
            </div>

            <div>

                <div class="summary-number text-black" id="userCount">
                    <%= totalUsers %>
                </div>

                <div class="summary-label">
                    Total Users
                </div>

            </div>

        </div>

    </div>


    <!-- ============================
         DESKTOP / TABLET TABLE
    ============================= -->

    <div class="table-card desktop-user-table">

        <div class="table-responsive">

            <table class="table table-bordered table-hover align-middle text-center">

                <thead class="table-dark">

                <tr>

                    <th>Profile</th>

                    <th>ID</th>

                    <th>Name</th>

                    <th>Email</th>

                    <th>Mobile</th>

                    <th>Role</th>

                    <th>Vehicle</th>

                    <th>License</th>

                    <th>Status</th>

                    <th>Action</th>

                </tr>

                </thead>


                <tbody id="staffTable">

                <%
                    if (userList != null && !userList.isEmpty()) {

                        for (UserDetails staff : userList) {

                            String vehicle =
                                staff.getVehicle_type() != null &&
                                !staff.getVehicle_type().trim().isEmpty()
                                ? staff.getVehicle_type()
                                : "NO";

                            String license =
                                staff.getLicense_number() != null &&
                                !staff.getLicense_number().trim().isEmpty()
                                ? "YES"
                                : "NO";

                            String role =
                                staff.getRoleName() != null
                                ? staff.getRoleName()
                                : "UNKNOWN";

                            String status =
                                staff.getStatus() != null
                                ? staff.getStatus()
                                : "UNKNOWN";

                            String searchData =
                                (staff.getUserId() != null ? staff.getUserId() : "") + " " +
                                (staff.getName() != null ? staff.getName() : "") + " " +
                                (staff.getEmail() != null ? staff.getEmail() : "") + " " +
                                (staff.getMobile() != null ? staff.getMobile() : "") + " " +
                                role + " " +
                                vehicle + " " +
                                license + " " +
                                status;

                            String roleClass = "role-other";

                            if ("ADMIN".equalsIgnoreCase(role)) {
                                roleClass = "role-admin";
                            }
                            else if ("DELIVERY".equalsIgnoreCase(role) ||
                                     "STAFF".equalsIgnoreCase(role)) {
                                roleClass = "role-delivery";
                            }
                            else if ("CUSTOMER".equalsIgnoreCase(role)) {
                                roleClass = "role-customer";
                            }

                            String statusClass = "status-other";

                            if ("ACTIVE".equalsIgnoreCase(status) ||
                                "AVAILABLE".equalsIgnoreCase(status) ||
                                "ONLINE".equalsIgnoreCase(status)) {

                                statusClass = "status-active";

                            }
                            else if ("INACTIVE".equalsIgnoreCase(status) ||
                                     "DISABLED".equalsIgnoreCase(status) ||
                                     "BLOCKED".equalsIgnoreCase(status)) {

                                statusClass = "status-inactive";
                            }
                %>

                <tr data-search="<%= searchData.toLowerCase().replace("\"", "&quot;") %>">

                    <!-- Profile -->

                    <td>

                        <img
                            src="<%=request.getContextPath()%>/showProfileImg?uid=<%= staff.getUserId() %>"
                            alt="Profile"
                            class="profile-img"
                            onerror="this.onerror=null; this.src='<%=request.getContextPath()%>/images/noimage.jpg';">

                    </td>


                    <!-- ID -->

                    <td>
                        <strong>
                            <%= staff.getUserId() %>
                        </strong>
                    </td>


                    <!-- Name -->

                    <td>
                        <%= staff.getName() %>
                    </td>


                    <!-- Email -->

                    <td>
                        <%= staff.getEmail() %>
                    </td>


                    <!-- Mobile -->

                    <td>
                        <%= staff.getMobile() %>
                    </td>


                    <!-- Role -->

                    <td>

                        <span class="role-badge <%= roleClass %>">

                            <i class="fa-solid fa-user-tag me-1"></i>

                            <%= role %>

                        </span>

                    </td>


                    <!-- Vehicle -->

                    <td>

                        <% if ("NO".equalsIgnoreCase(vehicle)) { %>

                            <span class="text-muted">
                                <i class="fa-solid fa-minus"></i>
                            </span>

                        <% } else { %>

                            <span class="vehicle-badge">

                                <i class="fa-solid fa-car me-1"></i>

                                <%= vehicle %>

                            </span>

                        <% } %>

                    </td>


                    <!-- License -->

                    <td>

                        <% if ("YES".equalsIgnoreCase(license)) { %>

                            <span class="license-badge license-yes">

                                <i class="fa-solid fa-check me-1"></i>
                                YES

                            </span>

                        <% } else { %>

                            <span class="license-badge license-no">

                                <i class="fa-solid fa-xmark me-1"></i>
                                NO

                            </span>

                        <% } %>

                    </td>


                    <!-- Status -->

                    <td>

                        <span class="status-badge <%= statusClass %>">

                            <%= status %>

                        </span>

                    </td>


                    <!-- Actions -->

                    <td>

                        <div class="action-buttons">

                            <a
                                href="editStaff.jsp?id=<%= staff.getUserId() %>"
                                class="btn btn-sm btn-primary">

                                <i class="fa-solid fa-pen-to-square"></i>

                                Edit

                            </a>


                            <a
                                href="deleteStaff?id=<%= staff.getUserId() %>"
                                class="btn btn-sm btn-danger"
                                onclick="return confirm('Are you sure you want to delete this user?');">

                                <i class="fa-solid fa-trash"></i>

                                Delete

                            </a>

                        </div>

                    </td>

                </tr>

                <%
                        }
                    }
                %>


                <!-- No Data -->

                <tr id="noDataRow" style="display:none;">

                    <td colspan="10" class="no-data text-center">

                        <div>
                            <i class="fa-solid fa-user-slash d-block"></i>
                        </div>

                        No users found.

                    </td>

                </tr>

                </tbody>

            </table>

        </div>

    </div>


    <!-- ============================
         MOBILE USER CARDS
    ============================= -->

    <div class="mobile-user-list" id="mobileUserList">

        <%
            if (userList != null && !userList.isEmpty()) {

                for (UserDetails staff : userList) {

                    String vehicle =
                        staff.getVehicle_type() != null &&
                        !staff.getVehicle_type().trim().isEmpty()
                        ? staff.getVehicle_type()
                        : "NO";

                    String license =
                        staff.getLicense_number() != null &&
                        !staff.getLicense_number().trim().isEmpty()
                        ? "YES"
                        : "NO";

                    String role =
                        staff.getRoleName() != null
                        ? staff.getRoleName()
                        : "UNKNOWN";

                    String status =
                        staff.getStatus() != null
                        ? staff.getStatus()
                        : "UNKNOWN";

                    String roleClass = "role-other";

                    if ("ADMIN".equalsIgnoreCase(role)) {
                        roleClass = "role-admin";
                    }
                    else if ("DELIVERY".equalsIgnoreCase(role) ||
                             "STAFF".equalsIgnoreCase(role)) {
                        roleClass = "role-delivery";
                    }
                    else if ("CUSTOMER".equalsIgnoreCase(role)) {
                        roleClass = "role-customer";
                    }

                    String statusClass = "status-other";

                    if ("ACTIVE".equalsIgnoreCase(status) ||
                        "AVAILABLE".equalsIgnoreCase(status) ||
                        "ONLINE".equalsIgnoreCase(status)) {

                        statusClass = "status-active";

                    }
                    else if ("INACTIVE".equalsIgnoreCase(status) ||
                             "DISABLED".equalsIgnoreCase(status) ||
                             "BLOCKED".equalsIgnoreCase(status)) {

                        statusClass = "status-inactive";
                    }
        %>


        <div
            class="user-card"
            data-search="<%= (
                (staff.getUserId() != null ? staff.getUserId() : "") + " " +
                (staff.getName() != null ? staff.getName() : "") + " " +
                (staff.getEmail() != null ? staff.getEmail() : "") + " " +
                (staff.getMobile() != null ? staff.getMobile() : "") + " " +
                role + " " +
                vehicle + " " +
                license + " " +
                status
            ).toLowerCase().replace("\"", "&quot;") %>">


            <!-- Card Header -->

            <div class="user-card-header">

                <img
                    src="<%=request.getContextPath()%>/showProfileImg?uid=<%= staff.getUserId() %>"
                    alt="Profile"
                    class="mobile-profile-img"
                    onerror="this.onerror=null; this.src='<%=request.getContextPath()%>/images/noimage.jpg';">


                <div>

                    <div class="user-card-name">
                        <%= staff.getName() %>
                    </div>

                    <div class="user-card-email">
                        <%= staff.getEmail() %>
                    </div>

                    <div class="mt-1">

                        <span class="role-badge <%= roleClass %>">
                            <%= role %>
                        </span>

                    </div>

                </div>

            </div>


            <!-- ID -->

            <div class="user-info-row">

                <span class="info-label">
                    <i class="fa-solid fa-id-card me-1"></i>
                    User ID
                </span>

                <span class="info-value">
                    <%= staff.getUserId() %>
                </span>

            </div>


            <!-- Mobile -->

            <div class="user-info-row">

                <span class="info-label">
                    <i class="fa-solid fa-phone me-1"></i>
                    Mobile
                </span>

                <span class="info-value">
                    <%= staff.getMobile() %>
                </span>

            </div>


            <!-- Vehicle -->

            <div class="user-info-row">

                <span class="info-label">
                    <i class="fa-solid fa-car me-1"></i>
                    Vehicle
                </span>

                <span class="info-value">

                    <% if ("NO".equalsIgnoreCase(vehicle)) { %>

                        NO

                    <% } else { %>

                        <span class="vehicle-badge">
                            <%= vehicle %>
                        </span>

                    <% } %>

                </span>

            </div>


            <!-- License -->

            <div class="user-info-row">

                <span class="info-label">
                    <i class="fa-solid fa-id-card-clip me-1"></i>
                    License
                </span>

                <span class="info-value">

                    <% if ("YES".equalsIgnoreCase(license)) { %>

                        <span class="license-badge license-yes">
                            YES
                        </span>

                    <% } else { %>

                        <span class="license-badge license-no">
                            NO
                        </span>

                    <% } %>

                </span>

            </div>


            <!-- Status -->

            <div class="user-info-row">

                <span class="info-label">
                    <i class="fa-solid fa-circle-info me-1"></i>
                    Status
                </span>

                <span class="info-value">

                    <span class="status-badge <%= statusClass %>">
                        <%= status %>
                    </span>

                </span>

            </div>


            <!-- Actions -->

            <div class="mobile-actions">

                <a
                    href="editStaff.jsp?id=<%= staff.getUserId() %>"
                    class="btn btn-primary">

                    <i class="fa-solid fa-pen-to-square"></i>
                    Edit

                </a>


                <a
                    href="deleteStaff?id=<%= staff.getUserId() %>"
                    class="btn btn-danger"
                    onclick="return confirm('Are you sure you want to delete this user?');">

                    <i class="fa-solid fa-trash"></i>
                    Delete

                </a>

            </div>

        </div>


        <%
                }
            }
        %>


        <!-- Mobile No Data -->

        <div
            id="mobileNoData"
            class="user-card text-center text-danger"
            style="display:none;">

            <i class="fa-solid fa-user-slash fa-2x mb-2"></i>

            <div class="fw-bold">
                No users found
            </div>

        </div>

    </div>

</div>


<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js">
</script>


<script>

    /* =========================================
       SEARCH ALL USERS
    ========================================= */

    const searchInput = document.getElementById("searchInput");

    const tableBody = document.getElementById("staffTable");

    const noDataRow = document.getElementById("noDataRow");

    const mobileUserList =
        document.getElementById("mobileUserList");

    const mobileNoData =
        document.getElementById("mobileNoData");

    const userCount =
        document.getElementById("userCount");


    searchInput.addEventListener("input", function () {

        const filter =
            this.value.trim().toLowerCase();


        /* ============================
           DESKTOP TABLE SEARCH
        ============================ */

        const rows =
            tableBody.querySelectorAll(
                "tr:not(#noDataRow)"
            );

        let visibleCount = 0;


        rows.forEach(function (row) {

            const searchText =
                row.getAttribute("data-search") || "";


            if (searchText.includes(filter)) {

                row.style.display = "";

                visibleCount++;

            }
            else {

                row.style.display = "none";

            }

        });


        if (visibleCount === 0) {

            noDataRow.style.display = "";

        }
        else {

            noDataRow.style.display = "none";

        }


        /* ============================
           MOBILE SEARCH
        ============================ */

        const cards =
            mobileUserList.querySelectorAll(
                ".user-card:not(#mobileNoData)"
            );

        let mobileVisibleCount = 0;


        cards.forEach(function (card) {

            const searchText =
                card.getAttribute("data-search") || "";


            if (searchText.includes(filter)) {

                card.style.display = "";

                mobileVisibleCount++;

            }
            else {

                card.style.display = "none";

            }

        });


        if (mobileVisibleCount === 0) {

            mobileNoData.style.display = "";

        }
        else {

            mobileNoData.style.display = "none";

        }


        /* ============================
           UPDATE COUNT
        ============================ */

        userCount.textContent = visibleCount;

    });


    /* =========================================
       INITIAL COUNT
    ========================================= */

    userCount.textContent =
        tableBody.querySelectorAll(
            "tr:not(#noDataRow)"
        ).length;

</script>


<jsp:include page="/footer.html" />

</body>

</html>