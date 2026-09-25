<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="com.myshop.beans.UserBean"%>
<%@page import="com.myshop.service.UserService"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>

<%
    /* =========================================================
       USER SESSION / AUTHENTICATION
       ========================================================= */

    String userName =
            (String) session.getAttribute("username");

    String password =
            (String) session.getAttribute("sessionId");

    String userId =
            (String) session.getAttribute("user_id");


    /* =========================================================
       SESSION CHECK
       ========================================================= */

    if (userName == null ||
        password == null ||
        userId == null) {

        String sessionMessage =
                java.net.URLEncoder.encode(
                        "Your login session has expired. Please login again.",
                        "UTF-8"
                );

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?message="
                + sessionMessage
        );

        return;
    }


    /* =========================================================
       GET USER DETAILS
       ========================================================= */

    UserService dao =
            new UserServiceImpl();

    UserBean user =
            dao.getUserDetails(
                    userName,
                    password
            );


    /* =========================================================
       USER RECORD CHECK
       ========================================================= */

    if (user == null) {

        String sessionMessage =
                java.net.URLEncoder.encode(
                        "Unable to verify your login session. Please login again.",
                        "UTF-8"
                );

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?message="
                + sessionMessage
        );

        return;
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        MYSHOP - USER PROFILE
    </title>


    <!-- =====================================================
         FAVICON
         ===================================================== -->

    <link
        rel="icon"
        type="image/x-icon"
        href="<%=request.getContextPath()%>/favicon.ico"
    >

    <link
        rel="shortcut icon"
        type="image/x-icon"
        href="<%=request.getContextPath()%>/favicon.ico"
    >


    <!-- =====================================================
         BOOTSTRAP CSS
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
    >


    <!-- =====================================================
         BOOTSTRAP ICONS
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    >


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
    >


    <!-- =====================================================
         SWEET ALERT
         ===================================================== -->

    <script
        src="https://cdn.jsdelivr.net/npm/sweetalert2@11">
    </script>


    <!-- =====================================================
         THEME FLASH PROTECTION
         ===================================================== -->

    <script>

        (function () {

            const theme =
                localStorage.getItem("myshop-theme");

            if (theme === "dark") {

                document.documentElement
                    .classList.add("dark-loading");

            }

        })();

    </script>


    <!-- =====================================================
         PROFILE PAGE CSS
         ===================================================== -->

    <style>

        /* =====================================================
           THEME VARIABLES - LIGHT
           ===================================================== */

        :root {

            --profile-bg:
                linear-gradient(
                    135deg,
                    #f5f7fa,
                    #e4e8f0
                );

            --profile-text:
                #212529;

            --profile-heading:
                #111827;

            --profile-muted:
                #6c757d;

            --profile-card:
                #ffffff;

            --profile-border:
                rgba(0,0,0,0.08);

            --profile-shadow:
                0 10px 30px
                rgba(0,0,0,0.10);

            --profile-row-border:
                #e5e7eb;

            --profile-link:
                #6c63ff;

            --profile-avatar-border:
                #ffffff;

            --profile-avatar-shadow:
                0 8px 25px
                rgba(0,0,0,0.20);

            --profile-menu-bg:
                #ffffff;

            --profile-menu-hover:
                #f1f5f9;
        }


        /* =====================================================
           THEME VARIABLES - DARK
           ===================================================== */

        body.dark-mode {

            --profile-bg:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #111827
                );

            --profile-text:
                #f8fafc;

            --profile-heading:
                #ffffff;

            --profile-muted:
                #cbd5e1;

            --profile-card:
                #1e293b;

            --profile-border:
                rgba(255,255,255,0.12);

            --profile-shadow:
                0 12px 35px
                rgba(0,0,0,0.45);

            --profile-row-border:
                #334155;

            --profile-link:
                #a5b4fc;

            --profile-avatar-border:
                #334155;

            --profile-avatar-shadow:
                0 8px 30px
                rgba(0,0,0,0.55);

            --profile-menu-bg:
                #1e293b;

            --profile-menu-hover:
                #334155;
        }


        /* =====================================================
           BODY
           ===================================================== */

        html,
        body {

            margin: 0;

            padding: 0;

            min-height: 100%;
        }


        body {

            min-height: 100vh;

            background:
                var(--profile-bg) !important;

            color:
                var(--profile-text) !important;

            transition:
                background 0.35s ease,
                color 0.35s ease;
        }


        /* =====================================================
           THEME FLASH
           ===================================================== */

        html.dark-loading {

            background:
                #0f172a;
        }


        /* =====================================================
           SESSION MESSAGE
           ===================================================== */

        .myshop-message {

            position: fixed;

            top: 22px;

            right: 22px;

            width:
                min(
                    400px,
                    calc(100vw - 30px)
                );

            display: flex;

            align-items: flex-start;

            gap: 13px;

            padding:
                16px 42px 16px 16px;

            background:
                var(--profile-card);

            border:
                1px solid
                var(--profile-border);

            border-left:
                5px solid
                #f59e0b;

            border-radius:
                13px;

            box-shadow:
                0 12px 35px
                rgba(0,0,0,0.18);

            color:
                var(--profile-text);

            z-index:
                999999;

            opacity: 0;

            transform:
                translateX(120%);

            pointer-events:
                none;

            overflow: hidden;

            transition:
                opacity 0.35s ease,
                transform 0.35s ease;
        }


        .myshop-message.show {

            opacity: 1;

            transform:
                translateX(0);

            pointer-events:
                auto;
        }


        /* =====================================================
           MESSAGE ICON
           ===================================================== */

        .myshop-message-icon {

            width: 38px;

            height: 38px;

            min-width: 38px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background:
                rgba(245,158,11,0.12);

            color:
                #f59e0b;

            font-size: 19px;
        }


        /* =====================================================
           MESSAGE CONTENT
           ===================================================== */

        .myshop-message-content {

            flex: 1;

            min-width: 0;
        }


        .myshop-message-title {

            margin:
                0 0 3px;

            font-size:
                15px;

            font-weight:
                700;

            color:
                var(--profile-heading);
        }


        .myshop-message-text {

            margin: 0;

            font-size:
                13px;

            line-height:
                1.5;

            color:
                var(--profile-muted);
        }


        /* =====================================================
           MESSAGE CLOSE
           ===================================================== */

        .myshop-message-close {

            position: absolute;

            top: 8px;

            right: 9px;

            width: 28px;

            height: 28px;

            display: flex;

            align-items: center;

            justify-content: center;

            border: 0;

            background:
                transparent;

            color:
                var(--profile-muted);

            border-radius: 50%;

            cursor: pointer;

            font-size: 16px;

            transition:
                0.2s;
        }


        .myshop-message-close:hover {

            background:
                var(--profile-menu-hover);

            color:
                var(--profile-heading);
        }


        /* =====================================================
           MESSAGE PROGRESS
           ===================================================== */

        .myshop-message-progress {

            position: absolute;

            left: 0;

            bottom: 0;

            height: 3px;

            width: 100%;

            background:
                #f59e0b;

            transform-origin:
                left;

            animation:
                messageProgress 5s linear forwards;
        }


        @keyframes messageProgress {

            from {

                transform:
                    scaleX(1);
            }

            to {

                transform:
                    scaleX(0);
            }
        }


        /* =====================================================
           PROFILE MAIN
           ===================================================== */

        .profile-page {

            padding-top:
                105px;

            padding-bottom:
                60px;

            min-height:
                700px;
        }


        /* =====================================================
           BREADCRUMB
           ===================================================== */

        .profile-breadcrumb {

            background:
                var(--profile-card) !important;

            border:
                1px solid
                var(--profile-border);

            border-radius:
                12px;

            padding:
                13px 18px;

            box-shadow:
                var(--profile-shadow);

            transition:
                background 0.3s ease,
                border-color 0.3s ease;
        }


        .profile-breadcrumb .breadcrumb {

            margin: 0;

            align-items:
                center;
        }


        .profile-breadcrumb .breadcrumb-item {

            color:
                var(--profile-muted) !important;
        }


        .profile-breadcrumb
        .breadcrumb-item a {

            color:
                var(--profile-link) !important;

            text-decoration:
                none;

            font-weight:
                500;
        }


        .profile-breadcrumb
        .breadcrumb-item a:hover {

            text-decoration:
                underline;
        }


        .profile-breadcrumb
        .breadcrumb-item.active {

            color:
                var(--profile-text) !important;
        }


        /* =====================================================
           PROFILE CARD
           ===================================================== */

        .profile-card {

            background:
                var(--profile-card) !important;

            color:
                var(--profile-text) !important;

            border:
                1px solid
                var(--profile-border) !important;

            border-radius:
                18px;

            box-shadow:
                var(--profile-shadow);

            overflow:
                hidden;

            transition:
                background 0.35s ease,
                color 0.35s ease,
                border-color 0.35s ease,
                box-shadow 0.35s ease;
        }


        /* =====================================================
           CARD HEADER
           ===================================================== */

        .profile-card-header {

            background:
                transparent;

            color:
                var(--profile-heading) !important;

            border-bottom:
                1px solid
                var(--profile-border);

            padding:
                17px 20px;

            font-size:
                19px;

            font-weight:
                700;

            display:
                flex;

            align-items:
                center;

            gap:
                10px;
        }


        .profile-card-header i {

            color:
                var(--profile-link);

            font-size:
                21px;
        }


        /* =====================================================
           PROFILE LEFT
           ===================================================== */

        .profile-left {

            text-align:
                center;
        }


        /* =====================================================
           PROFILE IMAGE
           ===================================================== */

        .profile-image-wrapper {

            position:
                relative;

            display:
                inline-block;

            margin-top:
                10px;
        }


        .profile-image {

            width:
                160px;

            height:
                160px;

            border-radius:
                50%;

            object-fit:
                cover;

            border:
                5px solid
                var(--profile-avatar-border);

            box-shadow:
                var(--profile-avatar-shadow);

            background:
                #ffffff;

            display:
                block;

            transition:
                border-color 0.3s ease,
                box-shadow 0.3s ease;
        }


        /* =====================================================
           EDIT BUTTON
           ===================================================== */

        .profile-edit-button {

            position:
                absolute;

            right:
                5px;

            bottom:
                8px;

            width:
                42px;

            height:
                42px;

            border-radius:
                50%;

            background:
                var(--profile-card);

            color:
                var(--profile-heading);

            border:
                1px solid
                var(--profile-border);

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            cursor:
                pointer;

            box-shadow:
                0 4px 12px
                rgba(0,0,0,0.20);

            transition:
                0.2s;
        }


        .profile-edit-button:hover {

            background:
                var(--profile-link);

            color:
                #ffffff;

            transform:
                scale(1.08);
        }


        /* =====================================================
           GREETING
           ===================================================== */

        .profile-greeting {

            color:
                var(--profile-heading) !important;

            font-size:
                20px;

            font-weight:
                700;

            margin-top:
                18px;

            margin-bottom:
                5px;
        }


        .profile-greeting .user-name {

            color:
                #009966 !important;
        }


        body.dark-mode
        .profile-greeting
        .user-name {

            color:
                #34d399 !important;
        }


        /* =====================================================
           QUICK LINKS
           ===================================================== */

        .profile-links-card {

            margin-top:
                20px;
        }


        .profile-links {

            padding:
                0;

            margin:
                0;

            list-style:
                none;
        }


        .profile-links li {

            display:
                flex;

            flex-wrap:
                wrap;

            justify-content:
                center;

            align-items:
                center;

            padding:
                15px;

            color:
                var(--profile-text);

            border:
                0;
        }


        .profile-links a {

            color:
                var(--profile-link) !important;

            text-decoration:
                none;

            font-weight:
                500;

            margin:
                3px 7px;

            transition:
                0.2s;
        }


        .profile-links a:hover {

            text-decoration:
                underline;
        }


        .profile-links .separator {

            color:
                var(--profile-muted);

            margin:
                0 2px;
        }


        /* =====================================================
           DETAILS CARD
           ===================================================== */

        .details-card {

            height:
                100%;
        }


        .details-card-body {

            padding:
                20px 25px;
        }


        /* =====================================================
           DETAIL ROW
           ===================================================== */

        .detail-row {

            display:
                flex;

            align-items:
                flex-start;

            min-height:
                55px;

            padding:
                14px 0;
        }


        .detail-label {

            width:
                25%;

            flex:
                0 0 25%;

            color:
                var(--profile-heading) !important;

            font-weight:
                600;

            font-size:
                15px;
        }


        .detail-value {

            width:
                75%;

            flex:
                0 0 75%;

            color:
                var(--profile-text) !important;

            word-break:
                break-word;

            font-size:
                15px;
        }


        .detail-divider {

            margin:
                0;

            border:
                0;

            border-top:
                1px solid
                var(--profile-row-border);

            opacity:
                1;
        }


        /* =====================================================
           VERIFICATION
           ===================================================== */

        .verified {

            color:
                #198754 !important;

            font-weight:
                700;

            margin-left:
                5px;
        }


        .not-verified {

            color:
                #dc3545 !important;

            font-weight:
                700;

            margin-left:
                5px;
        }


        .verify-link {

            color:
                #dc3545 !important;

            text-decoration:
                none;

            font-weight:
                700;
        }


        .verify-link:hover {

            text-decoration:
                underline;
        }


        /* =====================================================
           DETAIL ICON
           ===================================================== */

        .detail-icon {

            width:
                32px;

            height:
                32px;

            display:
                inline-flex;

            align-items:
                center;

            justify-content:
                center;

            margin-right:
                5px;

            color:
                var(--profile-link);

            font-size:
                17px;
        }


        /* =====================================================
           UPLOAD STATUS
           ===================================================== */

        .upload-status {

            display:
                none;

            margin-top:
                12px;

            font-size:
                13px;

            color:
                var(--profile-muted);
        }


        /* =====================================================
           TABLET
           ===================================================== */

        @media (max-width: 991px) {

            .profile-page {

                padding-top:
                    95px;
            }


            .detail-label {

                width:
                    30%;

                flex-basis:
                    30%;
            }


            .detail-value {

                width:
                    70%;

                flex-basis:
                    70%;
            }
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 767px) {

            .profile-page {

                padding-top:
                    90px;

                padding-left:
                    10px;

                padding-right:
                    10px;
            }


            .profile-breadcrumb {

                padding:
                    11px 13px;

                font-size:
                    14px;
            }


            .profile-card-header {

                font-size:
                    17px;
            }


            .profile-image {

                width:
                    140px;

                height:
                    140px;
            }


            .detail-row {

                display:
                    block;

                padding:
                    13px 0;
            }


            .detail-label {

                width:
                    100%;

                display:
                    block;

                margin-bottom:
                    5px;

                font-size:
                    14px;
            }


            .detail-value {

                width:
                    100%;

                display:
                    block;

                font-size:
                    14px;
            }


            .details-card-body {

                padding:
                    15px 18px;
            }


            .profile-links li {

                padding:
                    12px 8px;
            }


            .profile-links a {

                font-size:
                    14px;

                margin:
                    3px 5px;
            }
        }


        /* =====================================================
           SMALL MOBILE
           ===================================================== */

        @media (max-width: 400px) {

            .profile-image {

                width:
                    125px;

                height:
                    125px;
            }


            .profile-edit-button {

                width:
                    36px;

                height:
                    36px;

                right:
                    2px;

                bottom:
                    5px;
            }


            .profile-greeting {

                font-size:
                    18px;
            }
        }

    </style>

</head>


<body>


    <!-- =====================================================
         SESSION MESSAGE
         ===================================================== -->

    <div
        id="myshopMessage"
        class="myshop-message"
        role="alert"
        aria-live="assertive"
    >

        <div class="myshop-message-icon">

            <i class="bi bi-exclamation-triangle-fill"></i>

        </div>


        <div class="myshop-message-content">

            <p
                id="myshopMessageTitle"
                class="myshop-message-title"
            >
                Session Expired
            </p>


            <p
                id="myshopMessageText"
                class="myshop-message-text"
            >
                Your login session has expired.
                Please login again.
            </p>

        </div>


        <button
            type="button"
            class="myshop-message-close"
            onclick="closeMyShopMessage()"
            aria-label="Close"
        >

            <i class="bi bi-x-lg"></i>

        </button>


        <div
            id="messageProgress"
            class="myshop-message-progress">
        </div>

    </div>


    <!-- =====================================================
         APPLY SAVED THEME
         ===================================================== -->

    <script>

        (function () {

            const theme =
                localStorage.getItem(
                    "myshop-theme"
                );


            if (theme === "dark") {

                document.body.classList.add(
                    "dark-mode"
                );

            }


            document.documentElement
                .classList.remove(
                    "dark-loading"
                );

        })();

    </script>


    <!-- =====================================================
         HEADER
         ===================================================== -->

    <jsp:include page="/header.jsp"/>


    <!-- =====================================================
         PROFILE PAGE
         ===================================================== -->

    <main class="container profile-page">


        <!-- =================================================
             BREADCRUMB
             ================================================= -->

        <div class="row mb-4">

            <div class="col-12">

                <nav
                    class="profile-breadcrumb"
                    aria-label="breadcrumb"
                >

                    <ol class="breadcrumb mb-0">

                        <li class="breadcrumb-item">

                            <a
                                href="<%=request.getContextPath()%>/user/userHome.jsp"
                            >

                                <i class="bi bi-house"></i>

                                Home

                            </a>

                        </li>


                        <li
                            class="breadcrumb-item active"
                            aria-current="page"
                        >

                            User Profile

                        </li>

                    </ol>

                </nav>

            </div>

        </div>


        <!-- =================================================
             PROFILE CONTENT
             ================================================= -->

        <div class="row g-4">


            <!-- =================================================
                 LEFT COLUMN
                 ================================================= -->

            <div class="col-lg-4 col-md-5">


                <!-- PROFILE CARD -->

                <div
                    class="profile-card profile-left"
                >


                    <!-- HEADER -->

                    <div
                        class="profile-card-header text-start"
                    >

                        <i class="bi bi-person-circle"></i>

                        <span>
                            User Profile
                        </span>

                    </div>


                    <!-- BODY -->

                    <div class="card-body">


                        <!-- PROFILE IMAGE -->

                        <div
                            class="profile-image-wrapper"
                        >

                            <img
                                id="profileImg"
                                class="profile-image"
                                src="<%=request.getContextPath()%>/showProfileImg?uid=<%=userId%>"
                                alt="Profile Image"
                                onerror="this.src='<%=request.getContextPath()%>/images/noimage.jpg';"
                            >


                            <!-- EDIT BUTTON -->

                            <label
                                for="fileInput"
                                class="profile-edit-button"
                                title="Change profile image"
                            >

                                <i class="bi bi-pencil-fill"></i>

                            </label>


                            <!-- UPLOAD FORM -->

                            <form
                                id="uploadForm"
                                action="<%=request.getContextPath()%>/UploadProfileImage"
                                method="post"
                                enctype="multipart/form-data"
                            >

                                <input
                                    type="file"
                                    id="fileInput"
                                    name="profileImg"
                                    accept="image/*"
                                    hidden
                                    onchange="uploadImage()"
                                >

                            </form>

                        </div>


                        <!-- UPLOAD STATUS -->

                        <div
                            id="uploadStatus"
                            class="upload-status"
                        >

                            Uploading profile image...

                        </div>


                        <!-- GREETING -->

                        <p
                            class="profile-greeting"
                        >

                            Hello

                            <span class="user-name">

                                <%=user.getName()%>

                            </span>

                        </p>

                    </div>

                </div>


                <!-- =================================================
                     QUICK LINKS
                     ================================================= -->

                <div
                    class="profile-card profile-links-card"
                >

                    <ul class="profile-links">

                        <li>

                            <a href="#">

                                My Profile

                            </a>


                            <span class="separator">
                                |
                            </span>


                            <a
                                href="<%=request.getContextPath()%>/user/orderDetails.jsp?userId=<%=user.getEmail()%>"
                            >

                                Orders

                            </a>


                            <span class="separator">
                                |
                            </span>


                            <a
                                href="<%=request.getContextPath()%>/user/transHist.jsp?userId=<%=user.getEmail()%>"
                            >

                                Transactions

                            </a>


                            <span class="separator">
                                |
                            </span>


                            <a href="#">

                                Wallet

                            </a>


                            <span class="separator">
                                |
                            </span>


                            <a href="#">

                                Cashback

                            </a>

                        </li>

                    </ul>

                </div>


            </div>


            <!-- =================================================
                 RIGHT COLUMN
                 ================================================= -->

            <div class="col-lg-8 col-md-7">


                <div
                    class="profile-card details-card"
                >


                    <!-- HEADER -->

                    <div class="profile-card-header">

                        <i class="bi bi-person-vcard"></i>

                        <span>
                            Personal Information
                        </span>

                    </div>


                    <!-- DETAILS -->

                    <div class="details-card-body">


                        <!-- =================================================
                             FULL NAME
                             ================================================= -->

                        <div class="detail-row">

                            <div class="detail-label">

                                <i
                                    class="bi bi-person detail-icon"
                                ></i>

                                Full Name

                            </div>


                            <div class="detail-value">

                                <%=user.getName()%>

                            </div>

                        </div>


                        <hr class="detail-divider">


                        <!-- =================================================
                             EMAIL
                             ================================================= -->

                        <div class="detail-row">

                            <div class="detail-label">

                                <i
                                    class="bi bi-envelope detail-icon"
                                ></i>

                                Email

                            </div>


                            <div class="detail-value">

                                <%=user.getEmail()%>


                                <%

                                    if (user.getEmailVerified() == 1) {

                                %>

                                    <span class="verified">
                                        &#10003; Verified
                                    </span>

                                <%

                                    } else {

                                        session.setAttribute(
                                            "email",
                                            user.getEmail()
                                        );

                                %>

                                    <span class="not-verified">
                                        &#10007; Not Verified
                                    </span>

                                <%

                                    }

                                %>

                            </div>

                        </div>


                        <hr class="detail-divider">


                        <!-- =================================================
                             PHONE
                             ================================================= -->

                        <div class="detail-row">

                            <div class="detail-label">

                                <i
                                    class="bi bi-telephone detail-icon"
                                ></i>

                                Phone

                            </div>


                            <div class="detail-value">

                                <%=user.getMobile() != null
                                    ? user.getMobile()
                                    : "N/A"%>


                                <%

                                    if (user.getMobileVerified() == 1) {

                                %>

                                    <span class="verified">
                                        &#10003; Verified
                                    </span>

                                <%

                                    } else {

                                        session.setAttribute(
                                            "mobile",
                                            user.getMobile()
                                        );

                                        session.setAttribute(
                                            "email",
                                            user.getEmail()
                                        );

                                %>

                                    <a
                                        href="#"
                                        class="verify-link"
                                        onclick="joinAndSendOtp(); return false;"
                                    >

                                        &#10007; Not Verified

                                    </a>

                                <%

                                    }

                                %>

                            </div>

                        </div>


                        <hr class="detail-divider">


                        <!-- =================================================
                             ADDRESS
                             ================================================= -->

                        <div class="detail-row">

                            <div class="detail-label">

                                <i
                                    class="bi bi-geo-alt detail-icon"
                                ></i>

                                Address

                            </div>


                            <div class="detail-value">

                                <%=user.getAddress() != null
                                    ? user.getAddress()
                                    : "N/A"%>

                            </div>

                        </div>


                        <hr class="detail-divider">


                        <!-- =================================================
                             PINCODE
                             ================================================= -->

                        <div class="detail-row">

                            <div class="detail-label">

                                <i
                                    class="bi bi-pin-map detail-icon"
                                ></i>

                                Pincode

                            </div>


                            <div class="detail-value">

                                <%=user.getPincode()%>

                            </div>

                        </div>


                    </div>

                </div>

            </div>

        </div>

    </main>


    <!-- =====================================================
         FOOTER
         ===================================================== -->

    <jsp:include page="/footer.html"/>


    <!-- =====================================================
         BOOTSTRAP JS
         ===================================================== -->

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>


    <!-- =====================================================
         PROFILE JAVASCRIPT
         ===================================================== -->

    <script>


        /* =================================================
           THEME
           ================================================= */

        function applyProfileTheme() {

            const theme =
                localStorage.getItem(
                    "myshop-theme"
                );


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


        applyProfileTheme();


        /* =================================================
           MYSHOP MESSAGE
           ================================================= */

        let myShopMessageTimer = null;


        function showMessage(
            type,
            title,
            message,
            duration = 5000
        ) {

            const box =
                document.getElementById(
                    "myshopMessage"
                );

            const titleElement =
                document.getElementById(
                    "myshopMessageTitle"
                );

            const textElement =
                document.getElementById(
                    "myshopMessageText"
                );

            const progress =
                document.getElementById(
                    "messageProgress"
                );


            if (!box ||
                !titleElement ||
                !textElement) {

                return;
            }


            titleElement.textContent =
                title;


            textElement.textContent =
                message;


            /* ---------------------------------------------
               ICON
               --------------------------------------------- */

            const icon =
                box.querySelector(
                    ".myshop-message-icon i"
                );


            if (icon) {

                if (type === "success") {

                    icon.className =
                        "bi bi-check-circle-fill success";

                } else if (type === "error") {

                    icon.className =
                        "bi bi-x-circle-fill";

                } else if (type === "info") {

                    icon.className =
                        "bi bi-info-circle-fill";

                } else {

                    icon.className =
                        "bi bi-exclamation-triangle-fill";
                }

            }


            /* ---------------------------------------------
               SHOW
               --------------------------------------------- */

            box.classList.remove("show");


            /* Restart progress animation */

            if (progress) {

                progress.style.animation = "none";

                progress.offsetHeight;

                progress.style.animation =
                    "messageProgress "
                    + (duration / 1000)
                    + "s linear forwards";
            }


            setTimeout(function () {

                box.classList.add("show");

            }, 20);


            /* ---------------------------------------------
               CLEAR OLD TIMER
               --------------------------------------------- */

            if (myShopMessageTimer) {

                clearTimeout(
                    myShopMessageTimer
                );
            }


            /* ---------------------------------------------
               AUTO CLOSE
               --------------------------------------------- */

            myShopMessageTimer =
                setTimeout(
                    function () {

                        closeMyShopMessage();

                    },
                    duration
                );

        }


        /* =================================================
           CLOSE MESSAGE
           ================================================= */

        function closeMyShopMessage() {

            const box =
                document.getElementById(
                    "myshopMessage"
                );


            if (!box) {

                return;
            }


            box.classList.remove(
                "show"
            );


            if (myShopMessageTimer) {

                clearTimeout(
                    myShopMessageTimer
                );

                myShopMessageTimer =
                    null;
            }

        }


        /* =================================================
           SESSION MESSAGE
           ================================================= */

        function showSessionMessage(
            message
        ) {

            showMessage(
                "warning",
                "Session Expired",
                message ||
                "Your login session has expired. Please login again.",
                5000
            );


            /*
             * Redirect after exactly 5 seconds.
             */

            setTimeout(
                function () {

                    window.location.href =
                        "<%=request.getContextPath()%>/login.jsp";

                },
                5000
            );

        }


        /* =================================================
           OTP
           ================================================= */

        function joinAndSendOtp() {

            Swal.fire({

                icon: "info",

                title: "Phone Verification",

                text:
                    "You will be redirected for phone verification.",

                showCancelButton: true,

                confirmButtonText:
                    "Continue",

                cancelButtonText:
                    "Cancel"

            }).then(
                function (result) {

                    if (!result.isConfirmed) {

                        return;
                    }


                    /*
                     * Existing WhatsApp sandbox workflow.
                     */

                    window.open(
                        "https://wa.me/+14155238886?text=join%20difficult-glass",
                        "_blank"
                    );


                    setTimeout(
                        function () {

                            window.location.href =
                                "<%=request.getContextPath()%>/SendOTPSrv";

                        },
                        5000
                    );

                }
            );

        }


        /* =================================================
           PROFILE IMAGE UPLOAD
           ================================================= */
           /* =================================================
   PROFILE IMAGE UPLOAD
   TOP-RIGHT NOTIFICATION
   ================================================= */

function uploadImage() {

    const fileInput =
        document.getElementById("fileInput");

    const file =
        fileInput.files[0];

    if (!file) {
        return;
    }


    /* =================================================
       CHECK FILE TYPE
       ================================================= */

    if (!file.type.startsWith("image/")) {

        showMessage(
            "error",
            "Invalid File",
            "Please select a valid image.",
            5000
        );

        fileInput.value = "";

        return;
    }


    /* =================================================
       CHECK FILE SIZE
       ================================================= */

    const maxSize =
        5 * 1024 * 1024;


    if (file.size > maxSize) {

        showMessage(
            "error",
            "File Too Large",
            "Profile image must be smaller than 5 MB.",
            5000
        );

        fileInput.value = "";

        return;
    }


    /* =================================================
       PREVIEW IMAGE
       ================================================= */

    const reader =
        new FileReader();


    reader.onload =
        function (event) {

            document.getElementById(
                "profileImg"
            ).src =
                event.target.result;

        };


    reader.readAsDataURL(file);


    /* =================================================
       UPLOAD STATUS
       ================================================= */

    const status =
        document.getElementById(
            "uploadStatus"
        );


    status.style.display =
        "block";


    status.innerText =
        "Uploading profile image...";


    /* =================================================
       FORM DATA
       ================================================= */

    const formData =
        new FormData();


    formData.append(
        "profileImg",
        file
    );


    /* =================================================
       UPLOAD TO SERVER
       ================================================= */

    fetch(
        "<%=request.getContextPath()%>/UploadProfileImage",
        {
            method: "POST",
            body: formData
        }
    )

    .then(
        function (response) {

            if (!response.ok) {

                throw new Error(
                    "Upload failed"
                );
            }

            return response.text();
        }
    )

    .then(
        function (data) {

            console.log(
                "Upload:",
                data
            );


            /* =========================================
               SUCCESS NOTIFICATION
               ========================================= */

            showMessage(
                "success",
                "Profile Updated",
                "Your profile image has been updated successfully.",
                5000
            );


            /* =========================================
               REFRESH IMAGE
               CACHE BUSTING
               ========================================= */

            document.getElementById(
                "profileImg"
            ).src =
                "<%=request.getContextPath()%>/showProfileImg?uid=<%=userId%>&t="
                + new Date().getTime();


            /* =========================================
               HIDE UPLOAD STATUS
               ========================================= */

            status.innerText =
                "Profile image updated successfully.";


            setTimeout(
                function () {

                    status.style.display =
                        "none";

                },
                2000
            );


            /* Clear input */

            fileInput.value = "";

        }
    )

    .catch(
        function (error) {

            console.error(
                "Upload error:",
                error
            );


            /* =========================================
               ERROR NOTIFICATION
               ========================================= */

            showMessage(
                "error",
                "Upload Failed",
                "Unable to upload profile image. Please try again.",
                5000
            );


            status.style.display =
                "none";


            fileInput.value = "";

        }
    );

}
        /* =================================================
           HANDLE SERVER SESSION MESSAGE
           ================================================= */

        document.addEventListener(
            "DOMContentLoaded",
            function () {

                const params =
                    new URLSearchParams(
                        window.location.search
                    );


                const message =
                    params.get(
                        "message"
                    );


                if (message) {

                    showSessionMessage(
                        message
                    );

                }

            }
        );

    </script>


</body>

</html>