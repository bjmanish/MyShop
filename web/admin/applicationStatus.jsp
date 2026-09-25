<%@page import="com.myshop.beans.UserLoginActivity"%>
<%@page import="com.myshop.service.impl.UserLoginActivityServiceImpl"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Collections"%>

<%
/* =========================================================
   ADMIN SESSION
   ========================================================= */

String role = (String) session.getAttribute("role");
String userId = (String) session.getAttribute("user_id");
String username = (String) session.getAttribute("username");

if (userId == null
        || role == null
        || !role.equalsIgnoreCase("ADMIN")) {

    response.sendRedirect(
        request.getContextPath()
        + "/login.jsp?message=Unauthorized Access"
    );

    return;
}


/* =========================================================
   SERVICE
   ========================================================= */

UserLoginActivityServiceImpl service =
        new UserLoginActivityServiceImpl();


/* =========================================================
   STATISTICS
   ========================================================= */

int totalUsers = service.getTotalUsers();

int onlineUsers = service.getOnlineUsers();

int todayUsers = service.getTodayUsers();

int totalLogins = service.getTotalLogins();

int customerCount = service.getCustomerCount();

int staffCount = service.getStaffCount();

int adminCount = service.getAdminCount();


/* =========================================================
   ACTIVE USERS
   ========================================================= */

List<UserLoginActivity> activeUsers =
        service.getActiveUsers();


/* =========================================================
   LOGIN HISTORY
   ========================================================= */

List<UserLoginActivity> loginHistory =
        service.getLoginHistory();


/* =========================================================
   DATE FORMATTER
   ========================================================= */

DateTimeFormatter formatter =
        DateTimeFormatter.ofPattern(
            "dd-MM-yyyy HH:mm:ss"
        );


/* =========================================================
   CHART DATA
   ========================================================= */

/*
 * LOGIN STATUS COUNTS
 */

int activeCount = 0;
int logoutCount = 0;
int expiredCount = 0;
int forceLogoutCount = 0;

if (loginHistory != null) {

    for (UserLoginActivity activity : loginHistory) {

        String status = activity.getLoginStatus();

        if (status == null) {
            continue;
        }

        if ("ACTIVE".equalsIgnoreCase(status)) {

            activeCount++;

        } else if ("LOGOUT".equalsIgnoreCase(status)) {

            logoutCount++;

        } else if ("EXPIRED".equalsIgnoreCase(status)) {

            expiredCount++;

        } else if ("FORCE_LOGOUT".equalsIgnoreCase(status)) {

            forceLogoutCount++;
        }
    }
}


/*
 * SITE VISITS BY DATE
 */

Map<LocalDate, Integer> visitMap =
        new HashMap<LocalDate, Integer>();

if (loginHistory != null) {

    for (UserLoginActivity activity : loginHistory) {

        if (activity.getLoginTime() == null) {
            continue;
        }

        LocalDate date =
                activity.getLoginTime().toLocalDate();

        Integer count = visitMap.get(date);

        if (count == null) {
            visitMap.put(date, 1);
        } else {
            visitMap.put(date, count + 1);
        }
    }
}


/*
 * SORT DATES
 */

List<LocalDate> visitDates =
        new ArrayList<LocalDate>(visitMap.keySet());

Collections.sort(visitDates);


/*
 * CREATE JAVASCRIPT DATA
 */

StringBuilder visitLabels =
        new StringBuilder();

StringBuilder visitValues =
        new StringBuilder();

for (LocalDate date : visitDates) {

    if (visitLabels.length() > 0) {
        visitLabels.append(",");
        visitValues.append(",");
    }

    visitLabels.append("\"")
               .append(date.toString())
               .append("\"");

    visitValues.append(
        visitMap.get(date)
    );
}

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>Application Status | MyShop</title>


    <!-- =====================================================
         FAVICON
         ===================================================== -->

    <link
        rel="icon"
        type="image/x-icon"
        href="<%=request.getContextPath()%>/favicon.ico">


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
        rel="stylesheet">


    <!-- =====================================================
         GOOGLE FONT
         ===================================================== -->

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet">


    <!-- =====================================================
         CHART JS
         ===================================================== -->

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <<link rel="stylesheet" href="<%=request.getContextPath()%>/css/status.css"/>
    
</head>


<body>


<!-- =====================================================
     COMMON HEADER
     ===================================================== -->

<jsp:include page="/header.jsp"/>


<div class="page-wrapper">


    <!-- =================================================
         BREADCRUMB
         ================================================= -->

    <div class="breadcrumb-modern">

        <a href="<%=request.getContextPath()%>/admin/adminHome.jsp">

            <i class="fa-solid fa-house"></i>

            Admin

        </a>

        <i class="fa-solid fa-chevron-right"></i>

        <span>
            Application Status
        </span>

    </div>


    <!-- =================================================
         HEADER
         ================================================= -->

    <div class="modern-header">

        <div class="header-title">

            <div class="header-icon">

                <i class="fa-solid fa-chart-line"></i>

            </div>

            <div>

                <h1>
                    Application Status
                </h1>

                <p>
                    Monitor MyShop users, site visits,
                    sessions and login activity.
                </p>

            </div>

        </div>


        <div class="header-actions">

            <div class="live-indicator">

                <span class="live-dot"></span>

                Live Monitoring

            </div>


            <a
                href="<%=request.getContextPath()%>/admin/adminHome.jsp"
                class="home-btn">

                <i class="fa-solid fa-house"></i>

                Admin Home

            </a>


            <div class="admin-user">

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


        <!-- TOTAL USERS -->

        <div class="stat-card">

            <div class="stat-icon">

                <i class="fa-solid fa-users"></i>

            </div>

            <div class="stat-info">

                <small>
                    Total Users
                </small>

                <h3>
                    <%= totalUsers %>
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
                    Online Now
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


        <!-- TOTAL LOGINS -->

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

    </div>


    <!-- =================================================
         CHARTS
         ================================================= -->

    <div class="charts-grid">


        <!-- =================================================
             USERS BY ROLE
             ================================================= -->

        <div class="modern-panel">

            <div class="panel-header">

                <div class="panel-heading">

                    <div class="panel-heading-icon">

                        <i class="fa-solid fa-users-gear"></i>

                    </div>

                    <div>

                        <h5>
                            Users by Role
                        </h5>

                        <small>
                            Registered user distribution
                        </small>

                    </div>

                </div>

            </div>


            <div class="panel-body">

                <div class="chart-container">

                    <canvas id="roleChart"></canvas>

                </div>

            </div>

        </div>


        <!-- =================================================
             SITE VISITS
             ================================================= -->

        <div class="modern-panel">

            <div class="panel-header">

                <div class="panel-heading">

                    <div class="panel-heading-icon">

                        <i class="fa-solid fa-chart-line"></i>

                    </div>

                    <div>

                        <h5>
                            Site Visits
                        </h5>

                        <small>
                            Login activity by date
                        </small>

                    </div>

                </div>

            </div>


            <div class="panel-body">

                <div class="chart-container large">

                    <canvas id="siteVisitChart"></canvas>

                </div>

            </div>

        </div>


        <!-- =================================================
             LOGIN STATUS
             ================================================= -->

        <div class="modern-panel">

            <div class="panel-header">

                <div class="panel-heading">

                    <div class="panel-heading-icon">

                        <i class="fa-solid fa-chart-pie"></i>

                    </div>

                    <div>

                        <h5>
                            Login Status
                        </h5>

                        <small>
                            Session status distribution
                        </small>

                    </div>

                </div>

            </div>


            <div class="panel-body">

                <div class="chart-container">

                    <canvas id="statusChart"></canvas>

                </div>

            </div>

        </div>


        <!-- =================================================
             ONLINE USERS BY ROLE
             ================================================= -->

        <div class="modern-panel">

            <div class="panel-header">

                <div class="panel-heading">

                    <div class="panel-heading-icon">

                        <i class="fa-solid fa-signal"></i>

                    </div>

                    <div>

                        <h5>
                            Online Users
                        </h5>

                        <small>
                            Current active sessions
                        </small>

                    </div>

                </div>


                <span class="online-badge">

                    <span class="online-dot"></span>

                    <%= onlineUsers %> Online

                </span>

            </div>


            <div class="panel-body">

                <div class="chart-container">

                    <canvas id="onlineRoleChart"></canvas>

                </div>

            </div>

        </div>


    </div>


    <!-- =================================================
         CURRENTLY ONLINE USERS
         ================================================= -->

    <div class="modern-panel online-panel">

        <div class="panel-header">

            <div class="panel-heading">

                <div class="panel-heading-icon">

                    <i class="fa-solid fa-user-check"></i>

                </div>

                <div>

                    <h5>
                        Currently Online
                    </h5>

                    <small>
                        Active application sessions
                    </small>

                </div>

            </div>


            <span class="online-badge">

                <span class="online-dot"></span>

                <%= onlineUsers %> Online

            </span>

        </div>


        <div class="panel-body">

            <div class="online-list">


                <%

                if (activeUsers == null
                        || activeUsers.isEmpty()) {

                %>


                    <div class="empty-state">

                        <div class="empty-state-icon">

                            <i class="fa-solid fa-user-slash"></i>

                        </div>

                        <strong>
                            No users currently online
                        </strong>

                        <small>
                            Active sessions will appear here.
                        </small>

                    </div>


                <%

                } else {

                    for (UserLoginActivity user
                            : activeUsers) {


                        String displayName =
                                user.getUsername();


                        if (displayName == null
                                || displayName
                                .trim()
                                .isEmpty()) {

                            displayName =
                                    user.getUserId();
                        }


                        String firstLetter =
                                displayName
                                .substring(0, 1)
                                .toUpperCase();

                %>


                    <div class="user-item">


                        <div class="user-avatar">

                            <%= firstLetter %>

                        </div>


                        <div class="user-info">

                            <strong>

                                <%= displayName %>

                            </strong>

                            <small>

                                <%= user.getRoleName() != null
                                        ? user.getRoleName()
                                        : "USER" %>

                                &nbsp; ? &nbsp;

                                <%= user.getIpAddress() != null
                                        ? user.getIpAddress()
                                        : "Unknown IP" %>

                            </small>

                        </div>


                        <span class="online-badge">

                            <span class="online-dot"></span>

                            Active

                        </span>


                    </div>


                <%

                    }

                }

                %>


            </div>

        </div>

    </div>


    <!-- =================================================
         LOGIN HISTORY
         ================================================= -->

    <div class="history-panel">


        <div class="history-header">

            <div class="panel-heading">

                <div class="panel-heading-icon">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                </div>

                <div>

                    <h5>
                        Login Activity
                    </h5>

                    <small>
                        Latest application login sessions
                    </small>

                </div>

            </div>


            <div class="refresh-info">

                <i class="fa-solid fa-rotate"></i>

                Auto refresh:

                <strong>
                    30 seconds
                </strong>

            </div>

        </div>


        <div class="table-wrapper">

            <table class="activity-table">

                <thead>

                    <tr>

                        <th>#</th>

                        <th>User ID</th>

                        <th>User</th>

                        <th>Role</th>

                        <th>Login Time</th>

                        <th>Logout Time</th>

                        <th>IP Address</th>

                        <th>Status</th>

                    </tr>

                </thead>


                <tbody>


                <%

                if (loginHistory == null
                        || loginHistory.isEmpty()) {

                %>


                    <tr>

                        <td
                            colspan="8"
                            class="empty-state">

                            <div
                                class="empty-state-icon">

                                <i class="fa-solid fa-database"></i>

                            </div>

                            <strong>
                                No login activity found
                            </strong>

                            <small>
                                User login records will appear here.
                            </small>

                        </td>

                    </tr>


                <%

                } else {

                    int counter = 1;

                    for (UserLoginActivity activity
                            : loginHistory) {

                %>


                    <tr>


                        <!-- NUMBER -->

                        <td>

                            <strong>
                                <%= counter++ %>
                            </strong>

                        </td>


                        <!-- USER ID -->

                        <td>

                            <strong>
                                <%= activity.getUserId() %>
                            </strong>
                            <br/>
                            <small><span class="role-badge">Login Id: <%=activity.getLoginId() %></span></small>

                        </td>


                        <!-- USER -->

                        <td>

                            <%= activity.getUsername() != null
                                    ? activity.getUsername()
                                    : "-" %>

                        </td>


                        <!-- ROLE -->

                        <td>

                            <span class="role-badge">

                                <%= activity.getRoleName() != null
                                        ? activity.getRoleName()
                                        : "USER" %>

                            </span>

                        </td>


                        <!-- LOGIN TIME -->

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


                        <!-- LOGOUT TIME -->

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
                                    class="text-success fw-bold">

                                    Active

                                </span>

                            <%

                            }

                            %>

                        </td>


                        <!-- IP -->

                        <td>

                            <%= activity.getIpAddress() != null
                                    ? activity.getIpAddress()
                                    : "-" %>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <%

                            String status =
                                    activity.getLoginStatus();


                            if ("ACTIVE"
                                    .equalsIgnoreCase(status)) {

                            %>

                                <span
                                    class="status-badge status-active">

                                    <span
                                        class="status-dot">
                                    </span>

                                    ACTIVE

                                </span>


                            <%

                            } else if ("EXPIRED"
                                    .equalsIgnoreCase(status)) {

                            %>

                                <span
                                    class="status-badge status-expired">

                                    <span
                                        class="status-dot">
                                    </span>

                                    EXPIRED

                                </span>


                            <%

                            } else if ("FORCE_LOGOUT"
                                    .equalsIgnoreCase(status)) {

                            %>

                                <span
                                    class="status-badge status-force">

                                    <span
                                        class="status-dot">
                                    </span>

                                    FORCE LOGOUT

                                </span>


                            <%

                            } else {

                            %>

                                <span
                                    class="status-badge status-logout">

                                    <span
                                        class="status-dot">
                                    </span>

                                    LOGOUT

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


        <!-- =================================================
             REFRESH BAR
             ================================================= -->

        <div class="refresh-bar">

            <i class="fa-solid fa-arrows-rotate"></i>

            Page automatically refreshes every 30 seconds

            <div class="refresh-progress">

                <span></span>

            </div>

        </div>

    </div>


</div>


<!-- =====================================================
     CHART JAVASCRIPT
     ===================================================== -->

<script>

document.addEventListener(
    "DOMContentLoaded",
    function () {


    /* =====================================================
       COMMON CHART OPTIONS
       ===================================================== */

    const commonLegend = {

        position: "bottom",

        labels: {

            padding: 18,

            usePointStyle: true,

            font: {
                family: "Inter",
                size: 11
            }

        }

    };


    /* =====================================================
       1. USERS BY ROLE
       ===================================================== */

    const roleCanvas =
        document.getElementById("roleChart");


    if (roleCanvas) {

        new Chart(
            roleCanvas,
            {

                type: "doughnut",

                data: {

                    labels: [

                        "Customers",

                        "Staff / Delivery",

                        "Administrators"

                    ],

                    datasets: [{

                        data: [

                            <%= customerCount %>,

                            <%= staffCount %>,

                            <%= adminCount %>

                        ],

                        borderWidth: 3,

                        hoverOffset: 8

                    }]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    cutout: "65%",

                    plugins: {

                        legend: commonLegend,

                        tooltip: {

                            callbacks: {

                                label:
                                    function(context) {

                                    return " "
                                        + context.label
                                        + ": "
                                        + context.raw
                                        + " users";

                                }

                            }

                        }

                    }

                }

            }
        );

    }


    /* =====================================================
       2. SITE VISITS
       ===================================================== */

    const siteVisitCanvas =
        document.getElementById(
            "siteVisitChart"
        );


    if (siteVisitCanvas) {

        new Chart(
            siteVisitCanvas,
            {

                type: "line",

                data: {

                    labels: [

                        <%= visitLabels.toString() %>

                    ],

                    datasets: [{

                        label: "Site Visits",

                        data: [

                            <%= visitValues.toString() %>

                        ],

                        tension: 0.35,

                        fill: true,

                        borderWidth: 3,

                        pointRadius: 4,

                        pointHoverRadius: 7

                    }]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    interaction: {

                        intersect: false,

                        mode: "index"

                    },

                    scales: {

                        y: {

                            beginAtZero: true,

                            ticks: {

                                precision: 0

                            },

                            title: {

                                display: true,

                                text: "Visits"

                            }

                        },

                        x: {

                            title: {

                                display: true,

                                text: "Date"

                            }

                        }

                    },

                    plugins: {

                        legend: {

                            display: false

                        },

                        tooltip: {

                            callbacks: {

                                label:
                                    function(context) {

                                    return " Visits: "
                                        + context.raw;

                                }

                            }

                        }

                    }

                }

            }
        );

    }


    /* =====================================================
       3. LOGIN STATUS
       ===================================================== */

    const statusCanvas =
        document.getElementById(
            "statusChart"
        );


    if (statusCanvas) {

        new Chart(
            statusCanvas,
            {

                type: "doughnut",

                data: {

                    labels: [

                        "Active",

                        "Logout",

                        "Expired",

                        "Force Logout"

                    ],

                    datasets: [{

                        data: [

                            <%= activeCount %>,

                            <%= logoutCount %>,

                            <%= expiredCount %>,

                            <%= forceLogoutCount %>

                        ],

                        borderWidth: 3,

                        hoverOffset: 8

                    }]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    cutout: "62%",

                    plugins: {

                        legend: commonLegend,

                        tooltip: {

                            callbacks: {

                                label:
                                    function(context) {

                                    return " "
                                        + context.label
                                        + ": "
                                        + context.raw;

                                }

                            }

                        }

                    }

                }

            }
        );

    }


    /* =====================================================
       4. ONLINE USERS BY ROLE
       ===================================================== */

    let onlineCustomer = 0;

    let onlineStaff = 0;

    let onlineAdmin = 0;


    <%


    if (activeUsers != null) {

        for (UserLoginActivity onlineUser
                : activeUsers) {


            String onlineRole =
                    onlineUser.getRoleName();


            if (onlineRole != null
                    && onlineRole.equalsIgnoreCase(
                        "CUSTOMER")) {

    %>

                onlineCustomer++;

    <%

            } else if (onlineRole != null
                    && (
                        onlineRole.equalsIgnoreCase(
                            "STAFF")
                        ||
                        onlineRole.equalsIgnoreCase(
                            "DELIVERY")
                    )) {

    %>

                onlineStaff++;

    <%

            } else if (onlineRole != null
                    && onlineRole.equalsIgnoreCase(
                        "ADMIN")) {

    %>

                onlineAdmin++;

    <%

            }

        }

    }

    %>


    const onlineRoleCanvas =
        document.getElementById(
            "onlineRoleChart"
        );


    if (onlineRoleCanvas) {

        new Chart(
            onlineRoleCanvas,
            {

                type: "bar",

                data: {

                    labels: [

                        "Customers",

                        "Staff / Delivery",

                        "Administrators"

                    ],

                    datasets: [{

                        label: "Online Users",

                        data: [

                            onlineCustomer,

                            onlineStaff,

                            onlineAdmin

                        ],

                        borderRadius: 8,

                        borderWidth: 0

                    }]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    scales: {

                        y: {

                            beginAtZero: true,

                            ticks: {

                                precision: 0

                            },

                            title: {

                                display: true,

                                text: "Users"

                            }

                        }

                    },

                    plugins: {

                        legend: {

                            display: false

                        },

                        tooltip: {

                            callbacks: {

                                label:
                                    function(context) {

                                    return " Online: "
                                        + context.raw;

                                }

                            }

                        }

                    }

                }

            }
        );

    }


});



/* =====================================================
   AUTO REFRESH
   ===================================================== */

setTimeout(
    function () {

        window.location.reload();

    },
    30000
);

</script>


<!-- =====================================================
     BOOTSTRAP JS
     ===================================================== -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>