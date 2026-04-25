<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Redirecting to Payment...</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <style>
        body {
            background: #f4f6f9;
            font-family: Arial, sans-serif;
        }

        .container-box {
            margin-top: 120px;
            text-align: center;
        }

        /* Loader Spinner */
        .loader {
            border: 6px solid #f3f3f3;
            border-top: 6px solid #28a745;
            border-radius: 50%;
            width: 80px;
            height: 80px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Text animation */
        .fade-text {
            font-size: 18px;
            color: #555;
            animation: fade 1.5s infinite;
        }

        @keyframes fade {
            0% { opacity: 0.3; }
            50% { opacity: 1; }
            100% { opacity: 0.3; }
        }

        .secure-text {
            margin-top: 10px;
            color: green;
            font-size: 14px;
        }

        .progress {
            margin-top: 20px;
            height: 10px;
        }
    </style>
</head>

<body onload="startRedirect()">

<div class="container">
    <div class="container-box">

        <h3>🔄 Redirecting to Secure Payment</h3>

        <div class="loader"></div>

        <p class="fade-text">Please wait, do not refresh...</p>

        <div class="secure-text">🔒 100% Secure Payment via PayU</div>

        <!-- Progress bar -->
        <div class="progress">
            <div id="progressBar" class="progress-bar progress-bar-success" style="width: 0%"></div>
        </div>

    </div>
</div>

<!-- PayU Form -->
<form action="https://test.payu.in/_payment" method="post" name="payuForm">

    <input type="hidden" name="key" value="${key}" />
    <input type="hidden" name="txnid" value="${txnid}" />
    <input type="hidden" name="amount" value="${amount}" />
    <input type="hidden" name="productinfo" value="${productinfo}" />
    <input type="hidden" name="firstname" value="${firstname}" />
    <input type="hidden" name="email" value="${email}" />
    <input type="hidden" name="phone" value="${phone}" />
    <input type="hidden" name="surl" value="${surl}" />
    <input type="hidden" name="furl" value="${furl}" />
    <input type="hidden" name="hash" value="${hash}" />

</form>

<script>
    function startRedirect() {
        let progress = 0;
        let bar = document.getElementById("progressBar");

        let interval = setInterval(function () {
            progress += 10;
            bar.style.width = progress + "%";

            if (progress >= 100) {
                clearInterval(interval);
                document.forms['payuForm'].submit(); // ✅ Final submit
            }
        }, 150); // speed of progress
    }
</script>

</body>
</html>