<%@page import="com.myshop.beans.UserLoginActivity"%>
<%@page import="com.myshop.service.impl.UserLoginActivityServiceImpl"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    /* =====================================================
       ADMIN SESSION VALIDATION
       ===================================================== */

    String role =
            (String) session.getAttribute("role");

    String userId =
            (String) session.getAttribute("user_id");

    String username =
            (String) session.getAttribute("username");

    if (userId == null
            || role == null
            || !role.equalsIgnoreCase("ADMIN")) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message=Unauthorized Access"
        );

        return;
    }


    /* =====================================================
       SERVICE
       ===================================================== */

    UserLoginActivityServiceImpl service =
            new UserLoginActivityServiceImpl();


    /* =====================================================
       LOGIN HISTORY
       ===================================================== */

    List<UserLoginActivity> loginHistory =
            service.getLoginHistory();


    /* =====================================================
       STATISTICS
       ===================================================== */

    int totalLogins =
            service.getTotalLogins();

    int onlineUsers =
            service.getOnlineUsers();

    int todayUsers =
            service.getTodayUsers();


    int logoutUsers = 0;

    if (loginHistory != null) {

        for (UserLoginActivity activity : loginHistory) {

            if ("LOGOUT".equalsIgnoreCase(activity.getLoginStatus())
                   || "FORCE_LOGOUT".equalsIgnoreCase(activity.getLoginStatus())){

                logoutUsers++;
            }
        }
    }


    DateTimeFormatter formatter =
            DateTimeFormatter.ofPattern(
                "dd-MM-yyyy HH:mm:ss"
            );
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>User Activity | MyShop</title>


    <!-- =================================================
         FAVICON
         ================================================= -->

    <link
        rel="icon"
        type="image/x-icon"
        href="<%=request.getContextPath()%>/favicon.ico">

    <link
        rel="shortcut icon"
        type="image/x-icon"
        href="<%=request.getContextPath()%>/favicon.ico">


    <!-- =================================================
         BOOTSTRAP
         ================================================= -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =================================================
         FONT AWESOME
         ================================================= -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
        rel="stylesheet">


    <!-- =================================================
         GOOGLE FONT
         ================================================= -->

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet">


    <!-- =================================================
         USER ACTIVITY CSS
         ================================================= -->

    <link
        rel="stylesheet"
        href="<%=request.getContextPath()%>/css/userActivity.css">


    <!-- =================================================
         THEME INITIALIZATION
         ================================================= -->

    <script>

        (function () {

            const theme =
                localStorage.getItem("myshop-theme");

            if (theme === "dark") {

                document.documentElement
                    .setAttribute(
                        "data-theme",
                        "dark"
                    );

            } else if (theme === "light") {

                document.documentElement
                    .setAttribute(
                        "data-theme",
                        "light"
                    );
            }

        })();

    </script>

</head>


<body>


<!-- =====================================================
     COMMON MYSHOP HEADER
     ===================================================== -->
     <jsp:include page="/header.jsp"/>



<div class="page-wrapper">
   
    <!-- =================================================
         BREADCRUMB
         ================================================= -->

    <div class="modern-breadcrumb">

        <a
            href="<%=request.getContextPath()%>/admin/adminHome.jsp">

            <i class="fa-solid fa-house"></i>

            <!--<span>-->
                Admin
            <!--</span>-->

        </a>


        <i class="fa-solid fa-chevron-right"></i>


        <span>
            User Activity
        </span>

    </div>


    <!-- =================================================
         MODERN PAGE HEADER
         ================================================= -->

    <div class="page-header">


        <!-- TITLE -->

        <div class="page-title">

            <h2>

                <i class="fa-solid fa-user-clock"></i>

                User Activity

            </h2>


            <p>

                Monitor user login, logout and active
                application sessions.

            </p>

        </div>


        <!-- ACTIONS -->

        <div class="header-actions">


            <!-- LIVE STATUS -->

            <div class="live-status">

                <span class="live-dot"></span>

                Live Monitoring

            </div>


            <!-- APPLICATION STATUS -->

            <a
                href="<%=request.getContextPath()%>/admin/applicationStatus.jsp"
                class="back-btn">

                <i class="fa-solid fa-chart-line"></i>

                Application Status

            </a>


            <!-- ADMIN -->

            <div class="admin-badge">

                <i class="fa-solid fa-user-shield"></i>

                <%= username != null
                        ? username
                        : "Administrator" %>

            </div>

        </div>

    </div>


    <!-- =================================================
         STATISTICS
         ================================================= -->

    <div class="stats-grid">


        <!-- TOTAL LOGIN -->

        <div class="stat-card">

            <div class="stat-icon">

                <i class="fa-solid fa-right-to-bracket"></i>

            </div>


            <div class="stat-info">

                <small>
                    Total Logins
                </small>

                <h3>
                    <%= totalLogins %>
                </h3>

            </div>

        </div>


        <!-- ONLINE -->

        <div class="stat-card">

            <div class="stat-icon">

                <i class="fa-solid fa-signal"></i>

            </div>


            <div class="stat-info">

                <small>
                    Currently Online
                </small>

                <h3>
                    <%= onlineUsers %>
                </h3>

            </div>

        </div>


        <!-- TODAY -->

        <div class="stat-card">

            <div class="stat-icon">

                <i class="fa-solid fa-calendar-day"></i>

            </div>


            <div class="stat-info">

                <small>
                    Today's Users
                </small>

                <h3>
                    <%= todayUsers %>
                </h3>

            </div>

        </div>


        <!-- LOGOUT -->

        <div class="stat-card">

            <div class="stat-icon">

                <i class="fa-solid fa-right-from-bracket"></i>

            </div>


            <div class="stat-info">

                <small>
                    Logout Records
                </small>

                <h3>
                    <%= logoutUsers %>
                </h3>

            </div>

        </div>

    </div>


    <!-- =================================================
         FILTER PANEL
         ================================================= -->

    <div class="filter-panel">


        <div class="filter-heading">

            <div class="filter-title">

                <i class="fa-solid fa-filter"></i>

                Filter Activity

            </div>


            <div class="filter-hint">

                Search without refreshing the page

            </div>

        </div>


        <div class="filter-grid">


            <!-- SEARCH -->

            <div class="filter-group">

                <label>
                    Search User / ID / IP
                </label>

                <input
                    type="text"
                    id="searchInput"
                    class="filter-control"
                    placeholder="Search user ID, username or IP address...">

            </div>


            <!-- ROLE -->

            <div class="filter-group">

                <label>
                    Role
                </label>

                <select
                    id="roleFilter"
                    class="filter-control">

                    <option value="">
                        All Roles
                    </option>

                    <option value="ADMIN">
                        ADMIN
                    </option>

                    <option value="CUSTOMER">
                        CUSTOMER
                    </option>

                    <option value="STAFF">
                        STAFF
                    </option>

                    <option value="DELIVERY">
                        DELIVERY
                    </option>

                </select>

            </div>


            <!-- STATUS -->

            <div class="filter-group">

                <label>
                    Status
                </label>

                <select
                    id="statusFilter"
                    class="filter-control">

                    <option value="">
                        All Status
                    </option>

                    <option value="ACTIVE">
                        ACTIVE
                    </option>

                    <option value="LOGOUT">
                        LOGOUT
                    </option>

                    <option value="EXPIRED">
                        EXPIRED
                    </option>

                    <option value="FORCE_LOGOUT">
                        FORCE LOGOUT
                    </option>

                </select>

            </div>


            <!-- CLEAR -->

            <div class="filter-group clear-filter-group">

                <button
                    type="button"
                    id="clearFilters"
                    class="clear-btn">

                    <i class="fa-solid fa-rotate-left"></i>

                    Clear

                </button>

            </div>

        </div>

    </div>


    <!-- =================================================
         ACTIVITY TABLE
         ================================================= -->

    <div class="table-panel">


        <!-- TABLE HEADER -->

        <div class="table-header">


            <div class="table-heading">


                <div class="table-heading-icon">

                    <i class="fa-solid fa-list-check"></i>

                </div>


                <div>

                    <h5>
                        Login Activity
                    </h5>

                    <div class="record-count">

                        Showing

                        <strong id="visibleCount">
                            0
                        </strong>

                        records

                    </div>

                </div>

            </div>


            <div class="latest-badge">

                <i class="fa-solid fa-clock"></i>

                Latest 100 Records

            </div>

        </div>


        <!-- =================================================
             TABLE
             ================================================= -->

        <div class="table-wrapper">

            <table
                class="activity-table"
                id="activityTable">


                <thead>

                    <tr>

                        <th>
                            #
                        </th>

                        <th>
                            User
                        </th>

                        <th>
                            Role
                        </th>

                        <th>
                            Login Time
                        </th>

                        <th>
                            Logout Time
                        </th>

                        <th>
                            IP Address
                        </th>

                        <th>
                            Browser / Device
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                </thead>


                <tbody id="activityBody">


                <%
                    if (loginHistory == null
                            || loginHistory.isEmpty()) {
                %>


                    <tr>

                        <td
                            colspan="9"
                            class="empty-state">

                            <i
                                class="fa-solid fa-user-clock">
                            </i>

                            <div>

                                No user activity found.

                            </div>

                        </td>

                    </tr>


                <%
                    } else {

                        int counter = 1;

                        for (
                            UserLoginActivity activity
                            : loginHistory
                        ) {


                            String displayName =
                                    activity.getUsername();


                            if (displayName == null
                                    || displayName
                                        .trim()
                                        .isEmpty()) {

                                displayName =
                                        activity.getUserId();
                            }


                            String firstLetter =
                                    displayName
                                        .substring(0, 1)
                                        .toUpperCase();


                            String activityRole =
                                    activity.getRoleName();


                            if (activityRole == null
                                    || activityRole
                                        .trim()
                                        .isEmpty()) {

                                activityRole =
                                        "USER";
                            }


                            String activityStatus =
                                    activity.getLoginStatus();


                            if (activityStatus == null
                                    || activityStatus
                                        .trim()
                                        .isEmpty()) {

                                activityStatus =
                                        "UNKNOWN";
                            }


                            String ipAddress =
                                    activity.getIpAddress();


                            String userAgent =
                                    activity.getUserAgent();

                %>


                    <tr
                        class="activity-row"
                        data-user="<%=displayName%>"
                        data-userid="<%=activity.getUserId()%>"
                        data-loginid="<%=activity.getLoginId()%>"
                        data-role="<%=activityRole%>"
                        data-status="<%=activityStatus%>"
                        data-ip="<%=ipAddress != null
                                ? ipAddress
                                : ""%>">


                        <!-- NUMBER -->

                        <td>

                            <strong>
                                <%= counter++ %>
                            </strong>

                        </td>


                        <!-- USER -->

                        <td>

                            <div class="user-cell">


                                <div class="user-avatar">

                                    <%= firstLetter %>

                                </div>


                                <div class="user-details">

                                    <strong>

                                        <%= displayName %>

                                    </strong>


                                    <small>

                                        <span class="badge text-success ">Login Id: <%=activity.getLoginId() %></span>

                                    </small>

                                </div>

                            </div>

                        </td>


                        <!-- ROLE -->

                        <td>

                            <span class="role-badge">

                                <%= activityRole %>

                            </span>

                        </td>


                        <!-- LOGIN -->

                        <td>

                            <%
                                if (activity.getLoginTime()
                                        != null) {
                            %>

                                <%= activity
                                        .getLoginTime()
                                        .format(formatter) %>

                            <%
                                } else {
                            %>

                                -

                            <%
                                }
                            %>

                        </td>


                        <!-- LOGOUT -->

                        <td>

                            <%
                                if (activity.getLogoutTime()
                                        != null) {
                            %>

                                <%= activity
                                        .getLogoutTime()
                                        .format(formatter) %>

                            <%
                                } else {
                            %>

                                <span
                                    class="active-time-text">

                                    Active

                                </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- IP -->

                        <td>

                            <span class="ip-address">

                                <%= ipAddress != null
                                        ? ipAddress
                                        : "-" %>

                            </span>

                        </td>


                        <!-- BROWSER -->

                        <td>

                            <div
                                class="browser-cell"
                                title="<%= userAgent != null
                                        ? userAgent
                                        : "-" %>">

                                <%= userAgent != null
                                        ? userAgent
                                        : "-" %>

                            </div>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <%
                                if ("ACTIVE"
                                        .equalsIgnoreCase(
                                            activityStatus)) {
                            %>

                                <span
                                    class="status-badge status-active">

                                    <span
                                        class="status-dot">
                                    </span>

                                    ACTIVE

                                </span>


                            <%
                                } else if (
                                    "FORCE_LOGOUT"
                                    .equalsIgnoreCase(
                                        activityStatus)) {
                            %>

                                <span
                                    class="status-badge status-force">

                                    <span
                                        class="status-dot">
                                    </span>

                                    FORCE LOGOUT

                                </span>


                            <%
                                } else if (
                                    "EXPIRED"
                                    .equalsIgnoreCase(
                                        activityStatus)) {
                            %>

                                <span
                                    class="status-badge status-expired">

                                    <span
                                        class="status-dot">
                                    </span>

                                    EXPIRED

                                </span>


                            <%
                                } else {
                            %>

                                <span
                                    class="status-badge status-logout">

                                    <span
                                        class="status-dot">
                                    </span>

                                    <%= activityStatus %>

                                </span>

                            <%
                                }
                            %>

                        </td>


                        <!-- =================================================
                             ACTION
                             ================================================= -->

                        <td>

                            <%
                                if ("ACTIVE"
                                        .equalsIgnoreCase(
                                            activityStatus)) {
                            %>

                                <button
                                    type="button"
                                    class="force-logout-btn"
                                    onclick="forceLogout(
                                        this,
                                        <%=activity.getLoginId()%>,
                                        '<%=displayName.replace("'", "\\'")%>'
                                    )">

                                    <i
                                        class="fa-solid fa-power-off">
                                    </i>

                                    Force Logout

                                </button>

                            <%
                                } else {
                            %>

                                <span class="no-action">

                                    <i
                                        class="fa-solid fa-circle-check">
                                    </i>

                                    Completed

                                </span>

                            <%
                                }
                            %>

                        </td>

                    </tr>


                <%
                        }
                    }
                %>


                </tbody>

            </table>

        </div>

    </div>


</div>


<!-- =====================================================
     FORCE LOGOUT CONFIRMATION MODAL
     ===================================================== -->

<div
    class="modal fade"
    id="forceLogoutModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered">

        <div class="modal-content force-logout-modal">


            <div class="modal-header">

                <div class="modal-title-wrapper">

                    <div class="modal-danger-icon">

                        <i
                            class="fa-solid fa-power-off">
                        </i>

                    </div>


                    <div>

                        <h5 class="modal-title">
                            Force Logout
                        </h5>

                        <small>
                            Terminate active user session
                        </small>

                    </div>

                </div>


                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal"
                    aria-label="Close">
                </button>

            </div>


            <div class="modal-body">

                <div class="force-warning-box">

                    <i
                        class="fa-solid fa-triangle-exclamation">
                    </i>

                    <div>

                        <strong>
                            Confirm session termination
                        </strong>

                        <p>
                            You are about to force logout:
                        </p>

                        <span
                            id="forceLogoutUsername"
                            class="force-user-name">
                        </span>

                    </div>

                </div>


                <p class="force-info-text">

                    The user's active session will be terminated
                    and the activity will be recorded as
                    <strong>FORCE LOGOUT</strong>.

                </p>


                <input
                    type="hidden"
                    id="forceLogoutLoginId">

            </div>


            <div class="modal-footer">

                <button
                    type="button"
                    class="modal-cancel-btn"
                    data-bs-dismiss="modal">

                    Cancel

                </button>


                <button
                    type="button"
                    id="confirmForceLogout"
                    class="modal-force-btn">

                    <i
                        class="fa-solid fa-power-off">
                    </i>

                    Force Logout

                </button>

            </div>

        </div>

    </div>

</div>


<!-- =====================================================
     NOTIFICATION
     ===================================================== -->

<div
    id="activityNotification"
    class="activity-notification">

    <div class="notification-icon">

        <i
            id="notificationIcon"
            class="fa-solid fa-circle-check">
        </i>

    </div>


    <div class="notification-content">

        <strong id="notificationTitle">
            Success
        </strong>

        <span id="notificationMessage">
            Operation completed successfully.
        </span>

    </div>


    <button
        type="button"
        class="notification-close"
        onclick="hideNotification()">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>


<!-- =====================================================
     BOOTSTRAP JS
     ===================================================== -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script>


/* =========================================================
   ELEMENTS
   ========================================================= */

const searchInput =
    document.getElementById(
        "searchInput"
    );


const roleFilter =
    document.getElementById(
        "roleFilter"
    );


const statusFilter =
    document.getElementById(
        "statusFilter"
    );


const clearFilters =
    document.getElementById(
        "clearFilters"
    );


const rows =
    document.querySelectorAll(
        ".activity-row"
    );


const visibleCount =
    document.getElementById(
        "visibleCount"
    );


/* =========================================================
   FILTER FUNCTION
   ========================================================= */

function filterActivity() {

    const search =
        searchInput.value
            .toLowerCase()
            .trim();


    const selectedRole =
        roleFilter.value
            .toLowerCase();


    const selectedStatus =
        statusFilter.value
            .toLowerCase();


    let count = 0;


    rows.forEach(function(row) {

        const user =
            (
                row.dataset.user
                || ""
            ).toLowerCase();


        const userId =
            (
                row.dataset.userid
                || ""
            ).toLowerCase();


        const role =
            (
                row.dataset.role
                || ""
            ).toLowerCase();


        const status =
            (
                row.dataset.status
                || ""
            ).toLowerCase();


        const ip =
            (
                row.dataset.ip
                || ""
            ).toLowerCase();


        const matchesSearch =
            search === ""
            ||
            user.includes(search)
            ||
            userId.includes(search)
            ||
            ip.includes(search);


        const matchesRole =
            selectedRole === ""
            ||
            role === selectedRole;


        const matchesStatus =
            selectedStatus === ""
            ||
            status === selectedStatus;


        if (
            matchesSearch
            &&
            matchesRole
            &&
            matchesStatus
        ) {

            row.style.display =
                "";

            count++;

        } else {

            row.style.display =
                "none";
        }

    });


    visibleCount.textContent =
        count;
}


/* =========================================================
   SEARCH
   ========================================================= */

searchInput.addEventListener(
    "input",
    filterActivity
);


/* =========================================================
   ROLE
   ========================================================= */

roleFilter.addEventListener(
    "change",
    filterActivity
);


/* =========================================================
   STATUS
   ========================================================= */

statusFilter.addEventListener(
    "change",
    filterActivity
);


/* =========================================================
   CLEAR
   ========================================================= */

clearFilters.addEventListener(
    "click",
    function() {

        searchInput.value =
            "";

        roleFilter.value =
            "";

        statusFilter.value =
            "";

        filterActivity();
    }
);


/* =========================================================
   INITIAL COUNT
   ========================================================= */

filterActivity();


/* =========================================================
   FORCE LOGOUT MODAL
   ========================================================= */

let selectedLoginId =
    null;


let selectedLogoutButton =
    null;


function forceLogout(
    button,
    loginId,
    username
) {

    selectedLoginId =
        loginId;

    selectedLogoutButton =
        button;


    document.getElementById(
        "forceLogoutLoginId"
    ).value =
        loginId;


    document.getElementById(
        "forceLogoutUsername"
    ).textContent =
        username;


    const modalElement =
        document.getElementById(
            "forceLogoutModal"
        );


    const modal =
        bootstrap.Modal.getOrCreateInstance(
            modalElement
        );


    modal.show();
}


/* =========================================================
   CONFIRM FORCE LOGOUT
   ========================================================= */

document.getElementById(
    "confirmForceLogout"
).addEventListener(
    "click",
    function() {

        if (!selectedLoginId) {

            return;
        }


        const confirmButton =
            this;


        confirmButton.disabled =
            true;


        confirmButton.innerHTML =
            '<i class="fa-solid fa-spinner fa-spin"></i> Processing...';


        fetch(
            "<%=request.getContextPath()%>/ForceLogoutSrv",
            {
                method:
                    "POST",

                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded"
                },

                body:
                    "loginId="+ encodeURIComponent(selectedLoginId)
            }
        )
        .then(function(response) {

            return response.json();

        })
        .then(function(data) {

            if (data.success) {


                const modalElement =
                    document.getElementById(
                        "forceLogoutModal"
                    );


                const modal =
                    bootstrap.Modal
                        .getOrCreateInstance(
                            modalElement
                        );


                modal.hide();


                if (selectedLogoutButton) {

                    selectedLogoutButton
                        .classList.add(
                            "force-logout-success"
                        );


                    selectedLogoutButton
                        .innerHTML =
                        '<i class="fa-solid fa-circle-check"></i> Logged Out';

                    selectedLogoutButton.disabled =
                        true;
                }


                showNotification(
                    "success",
                    "Force Logout Successful",
                    data.message
                    ||
                    "User has been force logged out."
                );


                setTimeout(
                    function() {

                        window.location.reload();

                    },
                    1200
                );


            } else {

                showNotification(
                    "error",
                    "Force Logout Failed",
                    data.message
                    ||
                    "Unable to force logout user."
                );
            }

        })
        .catch(function(error) {

            console.error(
                "Force logout error:",
                error
            );


            showNotification(
                "error",
                "Server Error",
                "Unable to connect to the server."
            );

        })
        .finally(function() {

            confirmButton.disabled =
                false;


            confirmButton.innerHTML =
                '<i class="fa-solid fa-power-off"></i> Force Logout';

        });

    }
);


/* =========================================================
   NOTIFICATION
   ========================================================= */

let notificationTimer =
    null;


function showNotification(
    type,
    title,
    message
) {

    const notification =
        document.getElementById(
            "activityNotification"
        );


    const icon =
        document.getElementById(
            "notificationIcon"
        );


    const titleElement =
        document.getElementById(
            "notificationTitle"
        );


    const messageElement =
        document.getElementById(
            "notificationMessage"
        );


    notification.classList.remove(
        "notification-success",
        "notification-error"
    );


    if (type === "success") {

        notification.classList.add(
            "notification-success"
        );


        icon.className =
            "fa-solid fa-circle-check";

    } else {

        notification.classList.add(
            "notification-error"
        );


        icon.className =
            "fa-solid fa-circle-exclamation";
    }


    titleElement.textContent =
        title;


    messageElement.textContent =
        message;


    notification.classList.add(
        "show"
    );


    clearTimeout(
        notificationTimer
    );


    notificationTimer =
        setTimeout(
            hideNotification,
            5000
        );
}


function hideNotification() {

    const notification =
        document.getElementById(
            "activityNotification"
        );


    notification.classList.remove(
        "show"
    );
}


/* =========================================================
   AUTO REFRESH
   ========================================================= */

setTimeout(
    function() {

        window.location.reload();

    },
    30000
);

</script>


</body>

</html>