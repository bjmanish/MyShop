<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Redirecting to Payment | MYSHOP</title>

    <!-- =====================================================
         FAVICON
         ===================================================== -->
    <link rel="icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">

    <link rel="shortcut icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">


    <!-- =====================================================
         BOOTSTRAP ICONS
         ===================================================== -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <style>

        /* =====================================================
           THEME VARIABLES
           ===================================================== */

        :root {

            --bg: #f5f7fb;
            --card: #ffffff;
            --text: #1f2937;
            --muted: #6b7280;
            --border: #e5e7eb;

            --primary: #2563eb;
            --primary-light: #eff6ff;

            --success: #16a34a;
            --success-light: #f0fdf4;

            --shadow:
                0 20px 50px rgba(0, 0, 0, 0.10);
        }


        [data-theme="dark"] {

            --bg: #0f172a;
            --card: #1e293b;
            --text: #f8fafc;
            --muted: #94a3b8;
            --border: #334155;

            --primary: #60a5fa;
            --primary-light: #172554;

            --success: #4ade80;
            --success-light: #052e16;

            --shadow:
                0 20px 50px rgba(0, 0, 0, 0.40);
        }


        /* =====================================================
           BODY
           ===================================================== */

        * {
            box-sizing: border-box;
        }


        html,
        body {

            width: 100%;
            min-height: 100%;

            margin: 0;
            padding: 0;
        }


        body {

            min-height: 100vh;

            display: flex;
            align-items: center;
            justify-content: center;

            padding: 20px;

            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            background:
                radial-gradient(
                    circle at top left,
                    rgba(37, 99, 235, 0.10),
                    transparent 35%
                ),
                radial-gradient(
                    circle at bottom right,
                    rgba(22, 163, 74, 0.10),
                    transparent 35%
                ),
                var(--bg);

            color: var(--text);

            transition:
                background 0.3s ease,
                color 0.3s ease;
        }


        /* =====================================================
           MAIN CARD
           ===================================================== */

        .payment-card {

            width: 100%;
            max-width: 520px;

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: 24px;

            padding: 40px 35px;

            text-align: center;

            box-shadow: var(--shadow);

            animation:
                cardEnter 0.6s ease;
        }


        @keyframes cardEnter {

            from {

                opacity: 0;

                transform:
                    translateY(25px)
                    scale(0.97);
            }

            to {

                opacity: 1;

                transform:
                    translateY(0)
                    scale(1);
            }
        }


        /* =====================================================
           MYSHOP LOGO
           ===================================================== */

        .brand {

            display: inline-flex;

            align-items: center;
            justify-content: center;

            gap: 9px;

            margin-bottom: 25px;

            font-size: 24px;

            font-weight: 800;

            letter-spacing: 0.5px;

            color: var(--text);
        }


        .brand-icon {

            width: 42px;
            height: 42px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 13px;

            background: var(--primary);

            color: white;

            font-size: 21px;

            box-shadow:
                0 8px 20px rgba(37, 99, 235, 0.25);
        }


        /* =====================================================
           PAYMENT ICON
           ===================================================== */

        .payment-icon {

            width: 92px;
            height: 92px;

            margin: 0 auto 25px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 50%;

            background: var(--primary-light);

            color: var(--primary);

            font-size: 42px;

            position: relative;
        }


        .payment-icon::after {

            content: "";

            position: absolute;

            inset: -7px;

            border-radius: 50%;

            border: 2px solid var(--primary);

            opacity: 0.15;

            animation:
                pulse 1.8s infinite;
        }


        @keyframes pulse {

            0% {

                transform: scale(0.9);

                opacity: 0.25;
            }

            70% {

                transform: scale(1.15);

                opacity: 0;
            }

            100% {

                transform: scale(1.15);

                opacity: 0;
            }
        }


        /* =====================================================
           HEADING
           ===================================================== */

        .payment-title {

            margin: 0;

            font-size: 27px;

            font-weight: 750;

            color: var(--text);
        }


        .payment-description {

            margin-top: 10px;

            margin-bottom: 28px;

            color: var(--muted);

            font-size: 15px;

            line-height: 1.6;
        }


        /* =====================================================
           LOADER
           ===================================================== */

        .loader {

            width: 64px;
            height: 64px;

            margin: 0 auto 25px;

            border-radius: 50%;

            border:
                6px solid var(--border);

            border-top-color: var(--primary);

            animation:
                spin 0.9s linear infinite;
        }


        @keyframes spin {

            to {

                transform: rotate(360deg);
            }
        }


        /* =====================================================
           STATUS
           ===================================================== */

        .status-text {

            display: flex;

            justify-content: center;

            align-items: center;

            gap: 8px;

            margin-bottom: 8px;

            font-size: 15px;

            font-weight: 600;

            color: var(--text);
        }


        .status-dot {

            width: 8px;
            height: 8px;

            border-radius: 50%;

            background: var(--success);

            animation:
                blink 1s infinite;
        }


        @keyframes blink {

            0%,
            100% {

                opacity: 1;
            }

            50% {

                opacity: 0.3;
            }
        }


        /* =====================================================
           PROGRESS BAR
           ===================================================== */

        .progress-container {

            width: 100%;

            height: 9px;

            margin-top: 22px;

            overflow: hidden;

            border-radius: 20px;

            background: var(--border);
        }


        #progressBar {

            width: 0%;

            height: 100%;

            border-radius: 20px;

            background:
                linear-gradient(
                    90deg,
                    var(--primary),
                    var(--success)
                );

            transition:
                width 0.15s linear;
        }


        .progress-percent {

            margin-top: 8px;

            font-size: 12px;

            color: var(--muted);
        }


        /* =====================================================
           SECURITY BOX
           ===================================================== */

        .secure-box {

            display: flex;

            align-items: center;
            justify-content: center;

            gap: 9px;

            margin-top: 25px;

            padding: 13px 15px;

            border-radius: 12px;

            background: var(--success-light);

            color: var(--success);

            font-size: 13px;

            font-weight: 600;
        }


        /* =====================================================
           WARNING
           ===================================================== */

        .warning-text {

            margin-top: 17px;

            color: var(--muted);

            font-size: 12px;

            line-height: 1.5;
        }


        /* =====================================================
           PAYMENT PROVIDER
           ===================================================== */

        .provider {

            margin-top: 24px;

            padding-top: 18px;

            border-top: 1px solid var(--border);

            color: var(--muted);

            font-size: 12px;
        }


        .provider strong {

            color: var(--text);
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 576px) {

            body {

                padding: 14px;
            }


            .payment-card {

                padding: 32px 22px;

                border-radius: 20px;
            }


            .payment-title {

                font-size: 23px;
            }


            .payment-description {

                font-size: 14px;
            }


            .payment-icon {

                width: 78px;
                height: 78px;

                font-size: 34px;
            }


            .loader {

                width: 55px;
                height: 55px;

                border-width: 5px;
            }
        }

    </style>

</head>


<body>

    <!-- =====================================================
         PAYMENT CARD
         ===================================================== -->

    <main class="payment-card">


        <!-- MYSHOP BRAND -->

        <div class="brand">

            <div class="brand-icon">

                <i class="bi bi-bag-heart-fill"></i>

            </div>

            MYSHOP

        </div>


        <!-- PAYMENT ICON -->

        <div class="payment-icon">

            <i class="bi bi-credit-card-2-front"></i>

        </div>


        <!-- TITLE -->

        <h1 class="payment-title">

            Redirecting to Secure Payment

        </h1>


        <p class="payment-description">

            Please wait while we securely connect you
            to the PayU payment gateway.

        </p>


        <!-- LOADER -->

        <div class="loader"></div>


        <!-- STATUS -->

        <div class="status-text">

            <span class="status-dot"></span>

            <span id="statusText">
                Preparing secure payment...
            </span>

        </div>


        <!-- PROGRESS -->

        <div class="progress-container">

            <div id="progressBar"></div>

        </div>


        <div class="progress-percent">

            <span id="progressPercent">0</span>% complete

        </div>


        <!-- SECURITY -->

        <div class="secure-box">

            <i class="bi bi-shield-lock-fill"></i>

            <span>
                Secure payment powered by PayU
            </span>

        </div>


        <!-- WARNING -->

        <div class="warning-text">

            <i class="bi bi-info-circle"></i>

            Please do not refresh or close this page
            while we are processing your payment.

        </div>


        <!-- PROVIDER -->

        <div class="provider">

            Securely connecting to
            <strong>PayU Payment Gateway</strong>

        </div>


    </main>


    <!-- =====================================================
         PAYU FORM
         ===================================================== -->

    <form action="https://test.payu.in/_payment"
          method="post"
          name="payuForm"
          id="payuForm">

        <input type="hidden"
               name="key"
               value="${key}" />

        <input type="hidden"
               name="txnid"
               value="${txnid}" />

        <input type="hidden"
               name="amount"
               value="${amount}" />

        <input type="hidden"
               name="productinfo"
               value="${productinfo}" />

        <input type="hidden"
               name="firstname"
               value="${firstname}" />

        <input type="hidden"
               name="email"
               value="${email}" />
        
        <input type="hidden"
               name="userId"
               value="${userId}" />

        <input type="hidden"
               name="phone"
               value="${phone}" />

        <input type="hidden"
               name="surl"
               value="${surl}" />

        <input type="hidden"
               name="furl"
               value="${furl}" />

        <input type="hidden"
               name="hash"
               value="${hash}" />

    </form>


    <!-- =====================================================
         JAVASCRIPT
         ===================================================== -->

    <script>

        function startRedirect() {

            let progress = 0;

            const bar =
                document.getElementById("progressBar");

            const percent =
                document.getElementById("progressPercent");

            const status =
                document.getElementById("statusText");


            const statusMessages = [

                "Preparing secure payment...",

                "Validating payment details...",

                "Connecting to PayU...",

                "Establishing secure connection...",

                "Redirecting to PayU..."
            ];


            let messageIndex = 0;


            const interval = setInterval(function () {

                progress += 10;


                if (progress > 100) {

                    progress = 100;

                }


                bar.style.width =
                    progress + "%";


                percent.textContent =
                    progress;


                /* Change status message */

                if (progress % 20 === 0 &&
                    messageIndex < statusMessages.length) {

                    status.textContent =
                        statusMessages[messageIndex];

                    messageIndex++;
                }


                /* Submit to PayU */

                if (progress >= 100) {

                    clearInterval(interval);

                    status.textContent =
                        "Redirecting to PayU...";


                    setTimeout(function () {

                        document
                            .getElementById("payuForm")
                            .submit();

                    }, 150);

                }

            }, 150);

        }


        /* =====================================================
           START AFTER PAGE LOAD
           ===================================================== */

        window.addEventListener(
            "load",
            startRedirect
        );

    </script>


</body>

</html>