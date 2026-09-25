<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">
    
        <!--MYSHOP ICON-->
<link rel="icon"
      type="image/x-icon"
      href="<%=request.getContextPath()%>/favicon.ico">

<link rel="shortcut icon"
      type="image/x-icon"
      href="<%=request.getContextPath()%>/favicon.ico">
    <title>MYSHOP - Register</title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         BOOTSTRAP ICONS
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
        rel="stylesheet">


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
         REGISTER CSS
         ===================================================== -->

    <style>


        /* =====================================================
           LIGHT THEME
           ===================================================== */

        :root {

            --register-bg:
                linear-gradient(
                    135deg,
                    #f5f7fa,
                    #e4e8f0
                );

            --register-text:
                #212529;

            --register-heading:
                #111827;

            --register-muted:
                #6c757d;

            --register-card:
                rgba(255,255,255,0.97);

            --register-border:
                rgba(0,0,0,0.08);

            --register-shadow:
                0 20px 50px
                rgba(0,0,0,0.15);

            --register-input:
                #ffffff;

            --register-input-text:
                #212529;

            --register-input-border:
                #ced4da;

            --register-icon:
                #6c63ff;

            --register-primary:
                #6c63ff;

            --register-primary-hover:
                #574fd6;

            --register-link:
                #6c63ff;

            --register-back:
                #6c63ff;

            --register-preview-border:
                #ffffff;
        }


        /* =====================================================
           DARK THEME
           ===================================================== */

        body.dark-mode {

            --register-bg:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #111827
                );

            --register-text:
                #f8fafc;

            --register-heading:
                #ffffff;

            --register-muted:
                #cbd5e1;

            --register-card:
                rgba(30,41,59,0.97);

            --register-border:
                rgba(255,255,255,0.12);

            --register-shadow:
                0 20px 55px
                rgba(0,0,0,0.55);

            --register-input:
                #111827;

            --register-input-text:
                #ffffff;

            --register-input-border:
                #475569;

            --register-icon:
                #a5b4fc;

            --register-primary:
                #6c63ff;

            --register-primary-hover:
                #8178ff;

            --register-link:
                #a5b4fc;

            --register-back:
                #a5b4fc;

            --register-preview-border:
                #475569;
        }


        /* =====================================================
           HTML / BODY
           ===================================================== */

        html,
        body {

            margin:
                0;

            padding:
                0;

            min-height:
                100%;
        }


        body {

            min-height:
                100vh;

            background:
                var(--register-bg);

            color:
                var(--register-text);

            transition:
                background 0.35s ease,
                color 0.35s ease;

            overflow-x:
                hidden;
        }


        /* =====================================================
           DARK LOADING
           ===================================================== */

        html.dark-loading {

            background:
                #0f172a;
        }


        /* =====================================================
           REGISTER PAGE
           ===================================================== */

        .register-page {

            min-height:
                100vh;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            padding:
                35px 15px;
        }


        /* =====================================================
           REGISTER CARD
           ===================================================== */

        .register-card {

            width:
                100%;

            max-width:
                600px;

            background:
                var(--register-card);

            color:
                var(--register-text);

            border:
                1px solid
                var(--register-border);

            border-radius:
                24px;

            padding:
                35px;

            box-shadow:
                var(--register-shadow);

            backdrop-filter:
                blur(20px);

            -webkit-backdrop-filter:
                blur(20px);

            transition:
                background 0.35s ease,
                color 0.35s ease,
                border-color 0.35s ease,
                box-shadow 0.35s ease;
        }


        /* =====================================================
           BACK BUTTON
           ===================================================== */

        .back-button {

            display:
                inline-flex;

            align-items:
                center;

            gap:
                7px;

            color:
                var(--register-back);

            text-decoration:
                none;

            font-size:
                14px;

            font-weight:
                600;

            margin-bottom:
                15px;

            transition:
                0.2s;
        }


        .back-button:hover {

            color:
                var(--register-primary-hover);

            transform:
                translateX(-3px);
        }


        /* =====================================================
           LOGO
           ===================================================== */

        .register-logo {

            width:
                65px;

            height:
                65px;

            margin:
                0 auto 12px;

            border-radius:
                18px;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            background:
                linear-gradient(
                    135deg,
                    #6c63ff,
                    #8f94fb
                );

            color:
                #ffffff;

            font-size:
                30px;

            box-shadow:
                0 10px 25px
                rgba(108,99,255,0.30);
        }


        /* =====================================================
           TITLE
           ===================================================== */

        .register-title {

            color:
                var(--register-heading);

            text-align:
                center;

            font-size:
                28px;

            font-weight:
                800;

            margin-bottom:
                5px;
        }


        .register-subtitle {

            color:
                var(--register-muted);

            text-align:
                center;

            font-size:
                14px;

            margin-bottom:
                25px;
        }


        /* =====================================================
           FORM LABEL
           ===================================================== */

        .register-label {

            display:
                block;

            color:
                var(--register-heading);

            font-weight:
                600;

            font-size:
                14px;

            margin-bottom:
                7px;
        }


        /* =====================================================
           INPUT WRAPPER
           ===================================================== */

        .input-wrapper {

            position:
                relative;

            width:
                100%;
        }


        .input-icon {

            position:
                absolute;

            left:
                15px;

            top:
                50%;

            transform:
                translateY(-50%);

            color:
                var(--register-icon);

            font-size:
                16px;

            z-index:
                5;

            pointer-events:
                none;
        }


        /* =====================================================
           INPUT
           ===================================================== */

        .register-input {

            width:
                100%;

            min-height:
                47px;

            border-radius:
                11px !important;

            background:
                var(--register-input) !important;

            color:
                var(--register-input-text) !important;

            border:
                1px solid
                var(--register-input-border) !important;

            padding:
                10px 15px 10px 45px;

            transition:
                0.25s;
        }


        .register-input::placeholder {

            color:
                var(--register-muted);

            opacity:
                0.85;
        }


        .register-input:focus {

            background:
                var(--register-input) !important;

            color:
                var(--register-input-text) !important;

            border-color:
                var(--register-primary) !important;

            box-shadow:
                0 0 0 4px
                rgba(108,99,255,0.14) !important;

            outline:
                none;
        }


        /* =====================================================
           TEXTAREA
           ===================================================== */

        .register-textarea {

            min-height:
                90px;

            resize:
                vertical;

            padding-top:
                13px;
        }


        .textarea-icon {

            top:
                20px;

            transform:
                none;
        }


        /* =====================================================
           PASSWORD
           ===================================================== */

        .password-input {

            padding-right:
                50px;
        }


        .password-toggle {

            position:
                absolute;

            right:
                10px;

            top:
                50%;

            transform:
                translateY(-50%);

            width:
                36px;

            height:
                36px;

            border:
                0;

            border-radius:
                50%;

            background:
                transparent;

            color:
                var(--register-muted);

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            cursor:
                pointer;

            z-index:
                5;

            transition:
                0.2s;
        }


        .password-toggle:hover {

            color:
                var(--register-icon);

            background:
                rgba(108,99,255,0.10);
        }


        /* =====================================================
           IMAGE SECTION
           ===================================================== */

        .image-section {

            text-align:
                center;

            margin-bottom:
                20px;
        }


        .image-preview {

            width:
                100px;

            height:
                100px;

            object-fit:
                cover;

            border-radius:
                50%;

            display:
                none;

            margin:
                0 auto 12px;

            border:
                4px solid
                var(--register-preview-border);

            box-shadow:
                0 8px 20px
                rgba(0,0,0,0.20);

            background:
                #ffffff;
        }


        .image-label {

            display:
                inline-flex;

            align-items:
                center;

            justify-content:
                center;

            gap:
                8px;

            padding:
                10px 18px;

            border-radius:
                25px;

            background:
                rgba(108,99,255,0.10);

            color:
                var(--register-primary);

            border:
                1px solid
                rgba(108,99,255,0.25);

            font-weight:
                600;

            font-size:
                14px;

            cursor:
                pointer;

            transition:
                0.2s;
        }


        .image-label:hover {

            background:
                var(--register-primary);

            color:
                #ffffff;
        }


        .file-input {

            display:
                none;
        }


        .image-hint {

            color:
                var(--register-muted);

            font-size:
                12px;

            margin-top:
                7px;

            margin-bottom:
                0;
        }


        /* =====================================================
           REGISTER BUTTON
           ===================================================== */

        .register-button {

            width:
                100%;

            min-height:
                49px;

            border:
                0;

            border-radius:
                12px;

            background:
                var(--register-primary);

            color:
                #ffffff;

            font-weight:
                700;

            font-size:
                16px;

            transition:
                0.25s;

            box-shadow:
                0 8px 20px
                rgba(108,99,255,0.25);
        }


        .register-button:hover {

            background:
                var(--register-primary-hover);

            color:
                #ffffff;

            transform:
                translateY(-2px);

            box-shadow:
                0 12px 25px
                rgba(108,99,255,0.35);
        }


        .register-button:disabled {

            opacity:
                0.7;

            cursor:
                not-allowed;

            transform:
                none;
        }


        /* =====================================================
           LOGIN LINK
           ===================================================== */

        .login-text {

            color:
                var(--register-muted);

            text-align:
                center;

            font-size:
                14px;

            margin-top:
                22px;

            margin-bottom:
                0;
        }


        .login-link {

            color:
                var(--register-link);

            font-weight:
                700;

            text-decoration:
                none;
        }


        .login-link:hover {

            text-decoration:
                underline;
        }


        /* =====================================================
           ALERT
           ===================================================== */

        .alert-box {

            width:
                100%;

            display:
                none;

            border-radius:
                10px;

            font-size:
                14px;
        }


        /* =====================================================
           SECURITY
           ===================================================== */

        .security-text {

            text-align:
                center;

            color:
                var(--register-muted);

            font-size:
                12px;

            margin-top:
                18px;

            margin-bottom:
                0;
        }


        .security-text i {

            color:
                #198754;

            margin-right:
                4px;
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 576px) {

            .register-page {

                padding:
                    20px 10px;
            }


            .register-card {

                padding:
                    25px 18px;

                border-radius:
                    20px;
            }


            .register-logo {

                width:
                    58px;

                height:
                    58px;

                font-size:
                    26px;
            }


            .register-title {

                font-size:
                    24px;
            }


            .register-subtitle {

                margin-bottom:
                    20px;
            }


            .image-preview {

                width:
                    85px;

                height:
                    85px;
            }

        }


        /* =====================================================
           VERY SMALL
           ===================================================== */

        @media (max-width: 360px) {

            .register-card {

                padding:
                    22px 15px;
            }


            .register-title {

                font-size:
                    22px;
            }

        }

    </style>

</head>


<body>


<!-- =========================================================
     REGISTER PAGE
     ========================================================= -->

<div class="register-page">


    <!-- =====================================================
         REGISTER CARD
         ===================================================== -->

    <div class="register-card">


        <!-- =================================================
             BACK
             ================================================= -->

        <a
            href="<%=request.getContextPath()%>/index.jsp"
            class="back-button">

            <i class="bi bi-arrow-left"></i>

            Back to Home

        </a>


        <!-- =================================================
             LOGO
             ================================================= -->

        <div class="register-logo">

            <i class="bi bi-person-plus-fill"></i>

        </div>


        <!-- =================================================
             TITLE
             ================================================= -->

        <h1 class="register-title">

            Create Account

        </h1>


        <p class="register-subtitle">

            Join MYSHOP and start shopping today

        </p>


        <!-- =================================================
             ALERTS
             ================================================= -->

        <div
            id="successBox"
            class="alert alert-success
                   text-center
                   alert-box">
        </div>


        <div
            id="errorBox"
            class="alert alert-danger
                   text-center
                   alert-box">
        </div>


        <!-- =================================================
             REGISTER FORM
             ================================================= -->

        <form
            id="registerForm"
            enctype="multipart/form-data">


            <!-- =================================================
                 PROFILE IMAGE
                 ================================================= -->

            <div class="image-section">


                <img
                    id="preview"
                    class="image-preview"
                    alt="Profile Preview">


                <label
                    for="imageInput"
                    class="image-label">

                    <i class="bi bi-camera-fill"></i>

                    Choose Profile Image

                </label>


                <input
                    type="file"
                    id="imageInput"
                    name="image"
                    class="file-input"
                    accept="image/*"
                    onchange="previewImage(event)">


                <p class="image-hint">

                    JPG, PNG or WEBP · Maximum 5 MB

                </p>

            </div>


            <!-- =================================================
                 NAME
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="name"
                    class="register-label">

                    Full Name

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-person input-icon">
                    </i>


                    <input
                        type="text"
                        id="name"
                        name="name"
                        class="form-control register-input"
                        placeholder="Enter your full name"
                        autocomplete="name"
                        required>

                </div>

            </div>


            <!-- =================================================
                 EMAIL
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="email"
                    class="register-label">

                    Email Address

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-envelope input-icon">
                    </i>


                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-control register-input"
                        placeholder="Enter your email"
                        autocomplete="email"
                        required>

                </div>

            </div>


            <!-- =================================================
                 MOBILE
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="mobile"
                    class="register-label">

                    Mobile Number

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-phone input-icon">
                    </i>


                    <input
                        type="tel"
                        id="mobile"
                        name="mobile"
                        class="form-control register-input"
                        placeholder="Enter mobile number"
                        autocomplete="tel"
                        maxlength="15"
                        required>

                </div>

            </div>


            <!-- =================================================
                 ADDRESS
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="address"
                    class="register-label">

                    Address

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-geo-alt input-icon textarea-icon">
                    </i>


                    <textarea
                        id="address"
                        name="address"
                        class="form-control register-input register-textarea"
                        placeholder="Enter your complete address"
                        autocomplete="street-address"
                        required></textarea>

                </div>

            </div>


            <!-- =================================================
                 PINCODE
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="pincode"
                    class="register-label">

                    Pincode

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-pin-map input-icon">
                    </i>


                    <input
                        type="text"
                        id="pincode"
                        name="pincode"
                        class="form-control register-input"
                        placeholder="Enter pincode"
                        inputmode="numeric"
                        maxlength="10"
                        required>

                </div>

            </div>


            <!-- =================================================
                 PASSWORD
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="password"
                    class="register-label">

                    Password

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-lock input-icon">
                    </i>


                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control register-input password-input"
                        placeholder="Create a password"
                        autocomplete="new-password"
                        required>


                    <button
                        type="button"
                        class="password-toggle"
                        onclick="togglePassword(
                            'password',
                            'eye1'
                        )">

                        <i
                            id="eye1"
                            class="fa-solid fa-eye">
                        </i>

                    </button>

                </div>

            </div>


            <!-- =================================================
                 CONFIRM PASSWORD
                 ================================================= -->

            <div class="mb-4">

                <label
                    for="confirmPassword"
                    class="register-label">

                    Confirm Password

                </label>


                <div class="input-wrapper">

                    <i
                        class="bi bi-shield-lock input-icon">
                    </i>


                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="form-control register-input password-input"
                        placeholder="Confirm your password"
                        autocomplete="new-password"
                        required>


                    <button
                        type="button"
                        class="password-toggle"
                        onclick="togglePassword(
                            'confirmPassword',
                            'eye2'
                        )">

                        <i
                            id="eye2"
                            class="fa-solid fa-eye">
                        </i>

                    </button>

                </div>

            </div>


            <!-- =================================================
                 REGISTER BUTTON
                 ================================================= -->

            <button
                type="submit"
                id="registerBtn"
                class="register-button">

                <i
                    class="bi bi-person-plus-fill me-2">
                </i>

                Create Account

            </button>


        </form>


        <!-- =================================================
             LOGIN
             ================================================= -->

        <p class="login-text">

            Already have an account?

            <a
                href="<%=request.getContextPath()%>/login.jsp"
                class="login-link">

                Login

            </a>

        </p>


        <!-- =================================================
             SECURITY
             ================================================= -->

        <p class="security-text">

            <i class="bi bi-shield-check"></i>

            Your information is securely processed.

        </p>


    </div>

</div>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


/* =========================================================
   THEME
   ========================================================= */

function applyRegisterTheme() {

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


/* =========================================================
   APPLY THEME
   ========================================================= */

applyRegisterTheme();


/* =========================================================
   IMAGE PREVIEW
   ========================================================= */

function previewImage(event) {

    const file =
        event.target.files[0];


    if (!file) {
        return;
    }


    /* ---------------------------------------------
       FILE TYPE
       --------------------------------------------- */

    if (
        !file.type.startsWith(
            "image/"
        )
    ) {

        showError(
            "Please select a valid image file."
        );

        event.target.value =
            "";

        return;
    }


    /* ---------------------------------------------
       FILE SIZE
       --------------------------------------------- */

    const maxSize =
        5 * 1024 * 1024;


    if (file.size > maxSize) {

        showError(
            "Image size must be less than 5 MB."
        );

        event.target.value =
            "";

        return;
    }


    /* ---------------------------------------------
       PREVIEW
       --------------------------------------------- */

    const img =
        document.getElementById(
            "preview"
        );


    if (img.dataset.objectUrl) {

        URL.revokeObjectURL(
            img.dataset.objectUrl
        );
    }


    const objectUrl =
        URL.createObjectURL(file);


    img.src =
        objectUrl;


    img.dataset.objectUrl =
        objectUrl;


    img.style.display =
        "block";
}


/* =========================================================
   PASSWORD TOGGLE
   ========================================================= */

function togglePassword(
    id,
    iconId
) {

    const input =
        document.getElementById(
            id
        );


    const icon =
        document.getElementById(
            iconId
        );


    if (
        input.type ===
        "password"
    ) {

        input.type =
            "text";


        icon.classList.remove(
            "fa-eye"
        );


        icon.classList.add(
            "fa-eye-slash"
        );

    } else {

        input.type =
            "password";


        icon.classList.remove(
            "fa-eye-slash"
        );


        icon.classList.add(
            "fa-eye"
        );
    }
}


/* =========================================================
   SUCCESS
   ========================================================= */

function showSuccess(message) {

    const box =
        document.getElementById(
            "successBox"
        );


    const errorBox =
        document.getElementById(
            "errorBox"
        );


    errorBox.style.display =
        "none";


    box.innerText =
        message;


    box.style.display =
        "block";


    setTimeout(
        function () {

            box.style.display =
                "none";

        },
        4000
    );
}


/* =========================================================
   ERROR
   ========================================================= */

function showError(message) {

    const box =
        document.getElementById(
            "errorBox"
        );


    const successBox =
        document.getElementById(
            "successBox"
        );


    successBox.style.display =
        "none";


    box.innerText =
        message;


    box.style.display =
        "block";


    setTimeout(
        function () {

            box.style.display =
                "none";

        },
        5000
    );
}


/* =========================================================
   REGISTER
   ========================================================= */

document
    .getElementById("registerForm")
    .addEventListener(
        "submit",
        function (event) {

            event.preventDefault();


            registerUser();

        }
    );


/* =========================================================
   REGISTER AJAX
   ========================================================= */

function registerUser() {

    const btn =
        document.getElementById(
            "registerBtn"
        );


    const form =
        document.getElementById(
            "registerForm"
        );


    const password =
        document.getElementById(
            "password"
        ).value;


    const confirmPassword =
        document.getElementById(
            "confirmPassword"
        ).value;


    const mobile =
        document.getElementById(
            "mobile"
        ).value.trim();


    const pincode =
        document.getElementById(
            "pincode"
        ).value.trim();


    /* =====================================================
       PASSWORD CHECK
       ===================================================== */

    if (
        password !==
        confirmPassword
    ) {

        showError(
            "Passwords do not match."
        );

        return;
    }


    /* =====================================================
       PASSWORD LENGTH
       ===================================================== */

    if (
        password.length <
        6
    ) {

        showError(
            "Password must contain at least 6 characters."
        );

        return;
    }


    /* =====================================================
       MOBILE CHECK
       ===================================================== */

    const mobilePattern =
        /^[0-9+\-\s]{10,15}$/;


    if (
        !mobilePattern.test(
            mobile
        )
    ) {

        showError(
            "Please enter a valid mobile number."
        );

        return;
    }


    /* =====================================================
       PINCODE CHECK
       ===================================================== */

    if (
        pincode.length <
        4
    ) {

        showError(
            "Please enter a valid pincode."
        );

        return;
    }


    /* =====================================================
       IMAGE CHECK
       ===================================================== */

    const imageInput =
        document.getElementById(
            "imageInput"
        );


    if (
        imageInput.files.length >
        0
    ) {

        const image =
            imageInput.files[0];


        if (
            image.size >
            5 * 1024 * 1024
        ) {

            showError(
                "Image size must be less than 5 MB."
            );

            return;
        }
    }


    /* =====================================================
       BUTTON
       ===================================================== */

    btn.disabled =
        true;


    btn.innerHTML =
        '<span class="spinner-border spinner-border-sm me-2"></span>Registering...';


    /* =====================================================
       FORM DATA
       ===================================================== */

    const formData =
        new FormData(form);


    /* =====================================================
       AJAX
       ===================================================== */

    fetch(
        "<%=request.getContextPath()%>/RegisterSrv",
        {

            method:
                "POST",

            /*
             * IMPORTANT:
             *
             * Do NOT manually set Content-Type here.
             *
             * Browser automatically creates:
             * multipart/form-data + boundary
             *
             * This is required because image is uploaded.
             */

            body:
                formData
        }
    )
    .then(
        function (response) {

            if (!response.ok) {

                throw new Error(
                    "Server error"
                );
            }


            return response.text();

        }
    )
    .then(
        function (data) {

            console.log(
                "Register response:",
                data
            );


            data =
                data.trim();


            btn.disabled =
                false;


            btn.innerHTML =
                '<i class="bi bi-person-plus-fill me-2"></i>Create Account';


            /*
             * =================================================
             * TRY JSON RESPONSE
             * =================================================
             */

            let result =
                null;


            try {

                result =
                    JSON.parse(data);

            } catch (e) {

                /*
                 * Backend may be returning plain text.
                 */
            }


            /* =================================================
               JSON SUCCESS
               ================================================= */

            if (
                result &&
                (
                    result.status ===
                    "success"
                )
            ) {

                showSuccess(
                    result.message ||
                    "Registration Successful!"
                );


                setTimeout(
                    function () {

                        window.location.href =
                            "<%=request.getContextPath()%>/login.jsp";

                    },
                    1500
                );


                return;
            }


            /* =================================================
               JSON ERROR
               ================================================= */

            if (
                result &&
                result.message
            ) {

                showError(
                    result.message
                );

                return;
            }


            /* =================================================
               PLAIN TEXT SUCCESS
               ================================================= */

            if (
                data.toLowerCase()
                    .includes(
                        "success"
                    )
            ) {

                showSuccess(
                    "Registration Successful!"
                );


                setTimeout(
                    function () {

                        window.location.href =
                            "<%=request.getContextPath()%>/login.jsp";

                    },
                    1500
                );


                return;
            }


            /* =================================================
               PLAIN TEXT ERROR
               ================================================= */

            showError(
                data ||
                "Registration Failed."
            );

        }
    )
    .catch(
        function (error) {

            console.error(
                "Registration error:",
                error
            );


            btn.disabled =
                false;


            btn.innerHTML =
                '<i class="bi bi-person-plus-fill me-2"></i>Create Account';


            showError(
                "Server error. Please try again."
            );

        }
    );

}


/* =========================================================
   THEME SYNC
   ========================================================= */

window.addEventListener(
    "storage",
    function (event) {

        if (
            event.key ===
            "myshop-theme"
        ) {

            applyRegisterTheme();

        }

    }
);

</script>


</body>

</html>