<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Update Product | MYSHOP</title>


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


    <style>

        /* =====================================================
           THEME
           ===================================================== */

        :root {

            --bg: #f5f7fb;

            --card: #ffffff;

            --input-bg: #f8fafc;

            --text: #111827;

            --muted: #64748b;

            --border: #e2e8f0;

            --primary: #2563eb;

            --primary-hover: #1d4ed8;

            --primary-soft: #eff6ff;

            --success: #16a34a;

            --danger: #dc2626;

            --danger-soft: #fef2f2;

            --shadow:
                0 20px 55px
                rgba(15, 23, 42, 0.10);

            --gradient:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #7c3aed
                );
        }


        /* =====================================================
           DARK MODE
           ===================================================== */

        body.dark-mode {

            --bg: #070b14;

            --card: #111827;

            --input-bg: #0f172a;

            --text: #f8fafc;

            --muted: #94a3b8;

            --border:
                rgba(255,255,255,0.09);

            --primary: #60a5fa;

            --primary-hover: #93c5fd;

            --primary-soft:
                rgba(96,165,250,0.12);

            --success: #4ade80;

            --danger: #f87171;

            --danger-soft:
                rgba(239,68,68,0.10);

            --shadow:
                0 20px 55px
                rgba(0,0,0,0.35);

            --gradient:
                linear-gradient(
                    135deg,
                    #1e3a8a,
                    #581c87
                );
        }


        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            box-sizing: border-box;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            margin: 0;

            min-height: 100vh;

            background: var(--bg);

            color: var(--text);

            font-family: "Inter", sans-serif;

            transition:
                background .3s ease,
                color .3s ease;

        }


        /* =====================================================
           PAGE
           ===================================================== */

        .update-product-page {

            min-height: calc(100vh - 150px);

            display: flex;

            justify-content: center;

            align-items: center;
            
            margin: 50px auto;

            padding:
                45px 20px 65px;

        }


        /* =====================================================
           MAIN CARD
           ===================================================== */

        .update-card {

            width: 100%;

            max-width: 850px;

            display: grid;

            grid-template-columns:
                42% 58%;

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: 25px;

            overflow: hidden;

            box-shadow: var(--shadow);

        }


        /* =====================================================
           LEFT PANEL
           ===================================================== */

        .intro-panel {

            position: relative;

            padding: 45px 35px;

            background: var(--gradient);

            color: white;

            display: flex;

            flex-direction: column;

            justify-content: center;

            overflow: hidden;

        }


        .intro-panel::before {

            content: "";

            position: absolute;

            width: 220px;

            height: 220px;

            border-radius: 50%;

            background:
                rgba(255,255,255,0.08);

            top: -90px;

            right: -80px;

        }


        .intro-panel::after {

            content: "";

            position: absolute;

            width: 180px;

            height: 180px;

            border-radius: 50%;

            background:
                rgba(255,255,255,0.06);

            bottom: -80px;

            left: -70px;

        }


        .intro-content {

            position: relative;

            z-index: 2;

        }


        /* =====================================================
           LOGO ICON
           ===================================================== */

        .intro-icon {

            width: 72px;

            height: 72px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 20px;

            background:
                rgba(255,255,255,0.15);

            border:
                1px solid
                rgba(255,255,255,0.20);

            backdrop-filter: blur(10px);

            font-size: 30px;

            margin-bottom: 25px;

        }


        .intro-title {

            margin: 0;

            font-size: 28px;

            line-height: 1.2;

            font-weight: 800;

            letter-spacing: -.7px;

        }


        .intro-title span {

            color: #bfdbfe;

        }


        .intro-description {

            margin:
                15px 0 28px;

            color:
                rgba(255,255,255,.82);

            font-size: 13px;

            line-height: 1.7;

        }


        /* =====================================================
           FEATURES
           ===================================================== */

        .feature-list {

            display: flex;

            flex-direction: column;

            gap: 13px;

        }


        .feature-item {

            display: flex;

            align-items: center;

            gap: 11px;

            color:
                rgba(255,255,255,.90);

            font-size: 12px;

        }


        .feature-item i {

            width: 25px;

            height: 25px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background:
                rgba(255,255,255,.13);

            font-size: 10px;

        }


        /* =====================================================
           RIGHT FORM PANEL
           ===================================================== */

        .form-panel {

            padding:
                45px 40px;

            display: flex;

            flex-direction: column;

            justify-content: center;

        }


        .form-header {

            margin-bottom: 28px;

        }


        .form-header h2 {

            margin: 0;

            color: var(--text);

            font-size: 23px;

            font-weight: 800;

        }


        .form-header p {

            margin:
                6px 0 0;

            color: var(--muted);

            font-size: 12px;

        }


        /* =====================================================
           MESSAGE
           ===================================================== */

        .message-box {

            display: flex;

            align-items: flex-start;

            gap: 10px;

            padding:
                12px 14px;

            margin-bottom: 20px;

            border-radius: 11px;

            background:
                var(--primary-soft);

            color: var(--primary);

            border:
                1px solid
                rgba(37,99,235,.12);

            font-size: 12px;

            line-height: 1.5;

        }


        .message-box i {

            margin-top: 2px;

        }


        /* =====================================================
           FORM
           ===================================================== */

        .form-group-modern {

            margin-bottom: 22px;

        }


        .form-label {

            display: flex;

            align-items: center;

            gap: 7px;

            margin-bottom: 8px;

            color: var(--text);

            font-size: 12px;

            font-weight: 700;

        }


        .form-label i {

            color: var(--primary);

        }


        .required {

            color: var(--danger);

        }


        /* =====================================================
           INPUT
           ===================================================== */

        .input-wrapper {

            position: relative;

        }


        .input-icon {

            position: absolute;

            left: 15px;

            top: 50%;

            transform:
                translateY(-50%);

            color: var(--muted);

            font-size: 14px;

            pointer-events: none;

            transition: .2s;

        }


        .product-id-input {

            width: 100%;

            height: 52px;

            padding:
                0 15px 0 45px;

            border:
                1px solid var(--border);

            border-radius: 13px;

            outline: none;

            background: var(--input-bg);

            color: var(--text);

            font-family: monospace;

            font-size: 14px;

            font-weight: 600;

            letter-spacing: .3px;

            transition:
                border .2s ease,
                box-shadow .2s ease,
                background .2s ease;

        }


        .product-id-input::placeholder {

            color: var(--muted);

            font-family: "Inter", sans-serif;

            font-weight: 400;

        }


        .product-id-input:focus {

            border-color:
                var(--primary);

            box-shadow:
                0 0 0 4px
                rgba(37,99,235,.10);

        }


        .product-id-input:focus
        ~ .input-icon {

            color:
                var(--primary);

        }


        /* =====================================================
           HELPER TEXT
           ===================================================== */

        .helper-text {

            margin-top: 8px;

            display: flex;

            align-items: flex-start;

            gap: 6px;

            color: var(--muted);

            font-size: 10px;

            line-height: 1.5;

        }


        .helper-text i {

            color: var(--primary);

            margin-top: 2px;

        }


        /* =====================================================
           BUTTONS
           ===================================================== */

        .button-row {

            display: grid;

            grid-template-columns:
                1fr 1.4fr;

            gap: 12px;

            margin-top: 28px;

        }


        .action-btn {

            height: 48px;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            border-radius: 12px;

            font-size: 12px;

            font-weight: 700;

            text-decoration: none;

            cursor: pointer;

            transition:
                transform .2s ease,
                box-shadow .2s ease,
                border .2s ease,
                background .2s ease;

        }


        /* CANCEL */

        .cancel-btn {

            background:
                var(--input-bg);

            color: var(--text);

            border:
                1px solid
                var(--border);

        }


        .cancel-btn:hover {

            color: var(--danger);

            border-color:
                var(--danger);

            transform:
                translateY(-2px);

        }


        /* UPDATE */

        .update-btn {

            border: none;

            color: white;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #4f46e5
                );

            box-shadow:
                0 8px 20px
                rgba(37,99,235,.20);

        }


        .update-btn:hover {

            color: white;

            transform:
                translateY(-2px);

            box-shadow:
                0 12px 25px
                rgba(37,99,235,.28);

        }


        .update-btn:active {

            transform:
                translateY(0);

        }


        /* =====================================================
           BOTTOM SECURITY
           ===================================================== */

        .security-note {

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            margin-top: 24px;

            color: var(--muted);

            font-size: 10px;

        }


        .security-note i {

            color: var(--success);

        }


        /* =====================================================
           PRODUCT ID BADGE
           ===================================================== */

        .id-format {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            margin-top: 22px;

            padding:
                7px 10px;

            border-radius: 8px;

            background:
                rgba(255,255,255,.10);

            color:
                rgba(255,255,255,.75);

            font-family: monospace;

            font-size: 10px;

        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 850px) {

            .update-card {

                grid-template-columns: 1fr;

                max-width: 550px;

            }


            .intro-panel {

                padding: 35px;

                min-height: 280px;

            }


            .intro-icon {

                width: 58px;

                height: 58px;

                font-size: 24px;

                margin-bottom: 18px;

            }


            .intro-title {

                font-size: 24px;

            }


            .intro-description {

                margin-bottom: 18px;

            }


            .feature-list {

                display: grid;

                grid-template-columns:
                    1fr 1fr;

            }


            .form-panel {

                padding: 35px;

            }

        }


        @media (max-width: 600px) {

            .update-product-page {

                padding:
                    25px 15px 45px;

                align-items:
                    flex-start;

            }


            .update-card {

                border-radius: 20px;

            }


            .intro-panel {

                padding:
                    30px 25px;

            }


            .intro-title {

                font-size: 22px;

            }


            .intro-description {

                font-size: 12px;

            }


            .feature-list {

                grid-template-columns: 1fr;

                gap: 9px;

            }


            .form-panel {

                padding:
                    30px 22px;

            }


            .form-header h2 {

                font-size: 21px;

            }


            .button-row {

                grid-template-columns: 1fr;

            }


            .cancel-btn {

                order: 2;

            }


            .update-btn {

                order: 1;

            }

        }


        @media (max-width: 380px) {

            .intro-panel {

                padding:
                    25px 20px;

            }


            .form-panel {

                padding:
                    25px 18px;

            }


            .product-id-input {

                height: 48px;

            }


            .action-btn {

                height: 46px;

            }

        }

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<%
    /* =========================================================
       ADMIN AUTHENTICATION
       ========================================================= */

    String userType =
        (String) session.getAttribute("role");

    String userName =
        (String) session.getAttribute("username");

    String password =
        (String) session.getAttribute("sessionId");


    if (userType == null ||
        !userType.equalsIgnoreCase("admin")) {

        response.sendRedirect(
            "login.jsp?message=Access Denied, Login As Admin!!"
        );

        return;
    }


    if (userName == null ||
        password == null) {

        response.sendRedirect(
            "login.jsp?message=Session Expired, Login Again!!"
        );

        return;
    }


    String message =
        request.getParameter("message");

%>


<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="update-product-page">


    <div class="update-card">


        <!-- =================================================
             LEFT INFORMATION PANEL
             ================================================= -->

        <section class="intro-panel">


            <div class="intro-content">


                <div class="intro-icon">

                    <i class="fa-solid fa-box-open"></i>

                </div>


                <h1 class="intro-title">

                    Update
                    <span>Product</span>

                </h1>


                <p class="intro-description">

                    Enter the product ID to access its
                    information and make changes to the
                    product details, pricing, quantity,
                    category, or image.

                </p>


                <!-- FEATURES -->

                <div class="feature-list">


                    <div class="feature-item">

                        <i class="fa-solid fa-pen"></i>

                        <span>
                            Edit product information
                        </span>

                    </div>


                    <div class="feature-item">

                        <i class="fa-solid fa-indian-rupee-sign"></i>

                        <span>
                            Update product price
                        </span>

                    </div>


                    <div class="feature-item">

                        <i class="fa-solid fa-boxes-stacked"></i>

                        <span>
                            Manage inventory
                        </span>

                    </div>


                    <div class="feature-item">

                        <i class="fa-solid fa-image"></i>

                        <span>
                            Change product image
                        </span>

                    </div>


                </div>


                <div class="id-format">

                    <i class="fa-solid fa-hashtag"></i>

                    Product ID Required

                </div>


            </div>

        </section>


        <!-- =================================================
             RIGHT FORM
             ================================================= -->

        <section class="form-panel">


            <div class="form-header">

                <h2>
                    Find Product
                </h2>

                <p>
                    Enter the product ID you want to update.
                </p>

            </div>


            <!-- =================================================
                 MESSAGE
                 ================================================= -->

            <%
                if (message != null &&
                    !message.trim().isEmpty()) {
            %>

                <div class="message-box">

                    <i class="fa-solid fa-circle-info"></i>

                    <span>
                        <%=message%>
                    </span>

                </div>

            <%
                }
            %>


            <!-- =================================================
                 FORM
                 ================================================= -->

            <form
                action="updateProduct.jsp"
                method="post"
                onsubmit="return validateProductId();"
            >


                <div class="form-group-modern">


                    <label
                        for="prodid"
                        class="form-label">

                        <i class="fa-solid fa-fingerprint"></i>

                        Product ID

                        <span class="required">*</span>

                    </label>


                    <div class="input-wrapper">


                        <input
                            type="text"
                            name="prodid"
                            id="prodid"
                            class="product-id-input"
                            placeholder="Enter Product ID"
                            autocomplete="on"
                            required
                            value="<%request.getAttribute("pid");%>"
                        >


                        <i class="fa-solid fa-box input-icon"></i>


                    </div>


                    <div class="helper-text">

                        <i class="fa-solid fa-circle-info"></i>

                        <span>
                            Enter the exact Product ID assigned
                            to the product in MYSHOP.
                        </span>

                    </div>


                </div>


                <!-- =================================================
                     BUTTONS
                     ================================================= -->

                <div class="button-row">


                    <a
                        href="adminViewProduct.jsp"
                        class="action-btn cancel-btn">

                        <i class="fa-solid fa-arrow-left"></i>

                        Cancel

                    </a>


                    <button
                        type="submit"
                        id="updateBtn"
                        class="action-btn update-btn">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        Find & Update Product

                    </button>


                </div>


            </form>


            <!-- =================================================
                 SECURITY
                 ================================================= -->

            <div class="security-note">

                <i class="fa-solid fa-shield-halved"></i>

                Admin-only product management

            </div>


        </section>


    </div>


</main>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"/>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>

    /* =========================================================
       THEME
       ========================================================= */

    function applyTheme() {

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


    applyTheme();


    /* =========================================================
       AUTO FOCUS
       ========================================================= */

    window.addEventListener(
        "load",
        function() {

            const input =
                document.getElementById(
                    "prodid"
                );

            if (input) {

                input.focus();

            }

        }
    );


    /* =========================================================
       VALIDATION
       ========================================================= */

    function validateProductId() {

        const input =
            document.getElementById(
                "prodid"
            );

        const value =
            input.value.trim();


        if (value.length === 0) {

            input.focus();

            return false;

        }


        const button =
            document.getElementById(
                "updateBtn"
            );


        button.disabled = true;


        button.innerHTML =
            '<span class="spinner-border spinner-border-sm"></span>'
            + ' Finding Product...';


        return true;

    }

</script>


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>