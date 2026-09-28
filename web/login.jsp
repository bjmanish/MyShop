<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String message = request.getParameter("message");

%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <!-- =====================================================
         MYSHOP FAVICON
         ===================================================== -->

    <link rel="icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">

    <link rel="shortcut icon"
          type="image/x-icon"
          href="<%=request.getContextPath()%>/favicon.ico">


    <title>MYSHOP - Login</title>


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
         GOOGLE LOGIN
         ===================================================== -->

    <script src="https://accounts.google.com/gsi/client" async defer></script>


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
         LOGIN CSS
         ===================================================== -->

    <link rel="stylesheet" href="css/login.css"/>

</head>


<body>


    <!-- =====================================================
         LOGIN PAGE
         ===================================================== -->

    <div class="login-page">


        <div class="login-card">


            <!-- =================================================
                 BACK TO HOME
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

            <div class="login-logo">

                <i class="bi bi-bag-heart-fill"></i>

            </div>


            <!-- =================================================
                 TITLE
                 ================================================= -->

            <h1 class="login-title">

                Welcome Back

            </h1>


            <p class="login-subtitle">

                Login to continue shopping with MYSHOP

            </p>


            <!-- =================================================
                 LOGIN FORM
                 ================================================= -->

            <form
                id="loginForm"
                autocomplete="on">


                <!-- =================================================
                     EMAIL
                     ================================================= -->

                <div class="mb-3">

                    <label
                        for="email"
                        class="login-form-label">

                        Email Address

                    </label>


                    <div class="input-wrapper">

                        <i
                            class="bi bi-envelope input-icon">
                        </i>


                        <input
                            type="email"
                            id="email"
                            name="username"
                            class="form-control login-input"
                            placeholder="Enter your email"
                            autocomplete="username"
                            required>

                    </div>

                </div>


                <!-- =================================================
                     PASSWORD
                     ================================================= -->

                <div class="mb-3">

                    <label
                        for="password"
                        class="login-form-label">

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
                            class="form-control login-input password-input"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>


                        <button
                            type="button"
                            class="password-toggle"
                            id="passwordToggle"
                            onclick="togglePassword()"
                            aria-label="Show password">

                            <i
                                id="eyeIcon"
                                class="fa-solid fa-eye">
                            </i>

                        </button>

                    </div>

                </div>


                <!-- =================================================
                     REMEMBER ME
                     ================================================= -->

                <div class="remember-row">

                    <div class="form-check">

                        <input
                            class="form-check-input"
                            type="checkbox"
                            id="rememberMe">

                        <label
                            class="form-check-label remember-label"
                            for="rememberMe">

                            Remember Me

                        </label>

                    </div>

                </div>


                <!-- =================================================
                     LOGIN BUTTON
                     ================================================= -->

                <div class="d-grid">

                    <button
                        type="submit"
                        id="loginBtn"
                        class="login-button">

                        <i
                            class="bi bi-box-arrow-in-right me-2">
                        </i>

                        Login

                    </button>

                </div>


                <!-- =================================================
                     DIVIDER
                     ================================================= -->

                <div class="divider">

                    <div class="divider-line"></div>

                    <span class="divider-text">

                        OR

                    </span>

                    <div class="divider-line"></div>

                </div>


                <!-- =================================================
                     GOOGLE LOGIN
                     ================================================= -->

                <div class="google-container">
                        
                    <div id="g_id_onload"
                        data-client_id="626330070401-adk186e3q4davc4re3bei10bgh95o3sc.apps.googleusercontent.com"
                        data-callback="handleCredentialResponse"
                        data-auto_prompt="true"
                        data-cancel_on_tap_outside="true">
                    </div>
                    <div class="g_id_signin"
                        data-type="standard"
                        data-size="large"
                        data-theme="outline"
                        data-text="sign_in_with"
                        data-logo_alignment ="left"
                        data-width ="320"
                        data-shape="pill">                            
                    </div>

                </div>


                <!-- =================================================
                     REGISTER
                     ================================================= -->

                <p class="register-text">

                    Don't have an account?

                    <a
                        href="<%=request.getContextPath()%>/register.jsp"
                        class="register-link">

                        Create Account

                    </a>

                </p>


                <!-- =================================================
                     SECURITY
                     ================================================= -->

                <p class="security-text">

                    <i class="bi bi-shield-check"></i>

                    Your login information is securely processed.

                </p>


            </form>

        </div>

    </div>


    <!-- =========================================================
         JAVASCRIPT
         ========================================================= -->
    
    <script>


        /* =========================================================
           THEME
           ========================================================= */

        function applyLoginTheme() {

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


        applyLoginTheme();


        /* =========================================================
           PASSWORD TOGGLE
           ========================================================= */

        function togglePassword() {

            const password =
                document.getElementById(
                    "password"
                );


            const icon =
                document.getElementById(
                    "eyeIcon"
                );


            const toggle =
                document.getElementById(
                    "passwordToggle"
                );


            if (password.type === "password") {

                password.type = "text";

                icon.classList.remove(
                    "fa-eye"
                );

                icon.classList.add(
                    "fa-eye-slash"
                );

                toggle.setAttribute(
                    "aria-label",
                    "Hide password"
                );

            } else {

                password.type = "password";

                icon.classList.remove(
                    "fa-eye-slash"
                );

                icon.classList.add(
                    "fa-eye"
                );

                toggle.setAttribute(
                    "aria-label",
                    "Show password"
                );

            }

        }


        /* =========================================================
           REMEMBER ME
           ========================================================= */

        window.addEventListener(
            "DOMContentLoaded",
            function () {

                const savedEmail =
                    localStorage.getItem(
                        "email"
                    );


                if (savedEmail) {

                    document.getElementById(
                        "email"
                    ).value =
                        savedEmail;


                    document.getElementById(
                        "rememberMe"
                    ).checked =
                        true;

                }

            }
        );


        /* =========================================================
           MESSAGE TIMER
           ========================================================= */

        let myShopMessageTimer = null;


        /* =========================================================
           COMMON MESSAGE
           ========================================================= */

        function showMessage(
            type,
            title,
            message,
            duration = 5000
        ) {


            /* Remove previous message */

            const oldMessage =
                document.querySelector(
                    ".myshop-message"
                );


            if (oldMessage) {

                oldMessage.remove();

            }


            /* Clear previous timer */

            if (myShopMessageTimer) {

                clearTimeout(
                    myShopMessageTimer
                );

                myShopMessageTimer = null;

            }


            /* Icons */

            const icons = {

                error:
                    "fa-solid fa-circle-xmark",

                success:
                    "fa-solid fa-circle-check",

                warning:
                    "fa-solid fa-circle-exclamation",

                info:
                    "fa-solid fa-circle-info",

                loading:
                    "fa-solid fa-spinner"

            };


            /* Main box */

            const box =
                document.createElement(
                    "div"
                );


            box.className =
                "myshop-message " + type;


            box.setAttribute(
                "role",
                "alert"
            );


            /* Icon */

            const iconBox =
                document.createElement(
                    "div"
                );


            iconBox.className =
                "myshop-message-icon";


            const icon =
                document.createElement(
                    "i"
                );


            icon.className =
                icons[type] ||
                icons.info;


            iconBox.appendChild(
                icon
            );


            /* Content */

            const content =
                document.createElement(
                    "div"
                );


            content.className =
                "myshop-message-content";


            const titleElement =
                document.createElement(
                    "div"
                );


            titleElement.className =
                "myshop-message-title";


            titleElement.textContent =
                title;


            const messageElement =
                document.createElement(
                    "div"
                );


            messageElement.className =
                "myshop-message-text";


            messageElement.textContent =
                message;


            content.appendChild(
                titleElement
            );


            content.appendChild(
                messageElement
            );


            /* Close */

            const closeButton =
                document.createElement(
                    "button"
                );


            closeButton.type =
                "button";


            closeButton.className =
                "myshop-message-close";


            closeButton.setAttribute(
                "aria-label",
                "Close"
            );


            const closeIcon =
                document.createElement(
                    "i"
                );


            closeIcon.className =
                "fa-solid fa-xmark";


            closeButton.appendChild(
                closeIcon
            );


            closeButton.onclick =
                function () {

                    closeMyShopMessage();

                };


            /* Add elements */

            box.appendChild(
                iconBox
            );


            box.appendChild(
                content
            );


            box.appendChild(
                closeButton
            );


            document.body.appendChild(
                box
            );


            /* Loading spinner */

            if (type === "loading") {

                icon.classList.add(
                    "fa-spin"
                );

            }


            /* Auto close */

            if (duration > 0) {

                myShopMessageTimer =
                    setTimeout(
                        function () {

                            closeMyShopMessage();

                        },
                        duration
                    );

            }

        }


        /* =========================================================
           CLOSE MESSAGE
           ========================================================= */

        function closeMyShopMessage() {

            const box =
                document.querySelector(
                    ".myshop-message"
                );


            if (!box) {

                return;

            }


            if (myShopMessageTimer) {

                clearTimeout(
                    myShopMessageTimer
                );

                myShopMessageTimer = null;

            }


            box.classList.add(
                "hide"
            );


            setTimeout(
                function () {

                    if (box.parentNode) {

                        box.remove();

                    }

                },
                300
            );

        }


        /* =========================================================
           ERROR
           ========================================================= */

        function showError(message) {

            showMessage(
                "error",
                "Login Failed",
                message,
                5000
            );

        }


        /* =========================================================
           SUCCESS
           ========================================================= */

        function showSuccess(message) {

            showMessage(
                "success",
                "Success",
                message,
                5000
            );

        }


        /* =========================================================
           WARNING
           ========================================================= */

        function showWarning(message) {

            showMessage(
                "warning",
                "Warning",
                message,
                5000
            );

        }


        /* =========================================================
           INFO
           ========================================================= */

        function showInfo(message) {

            showMessage(
                "info",
                "Information",
                message,
                5000
            );

        }


        /* =========================================================
           SERVER ERROR
           ========================================================= */

        function showServerError(message) {

            showMessage(
                "error",
                "Server Error",
                message,
                5000
            );

        }


        /* =========================================================
           SESSION EXPIRED
           ========================================================= */

        function showSessionMessage(message) {

            showMessage(
                "warning",
                "Session Expired",
                message,
                5000
            );


            setTimeout(
                function () {

                    window.location.href =
                        "<%=request.getContextPath()%>/login.jsp";

                },
                5000
            );

        }


        /* =========================================================
           LOADING
           ========================================================= */

        function showLoading() {

            showMessage(
                "loading",
                "Logging in...",
                "Please wait",
                0
            );

        }


        /* =========================================================
           RESET LOGIN BUTTON
           ========================================================= */

        function resetLoginButton() {

            const loginBtn =
                document.getElementById(
                    "loginBtn"
                );


            if (!loginBtn) {

                return;

            }


            loginBtn.disabled =
                false;


            loginBtn.innerHTML =
                '<i class="bi bi-box-arrow-in-right me-2"></i>Login';

        }


        /* =========================================================
           NORMAL LOGIN
           ========================================================= */

        document
            .getElementById("loginForm")
            .addEventListener(
                "submit",
                function (event) {

                    event.preventDefault();


                    const email =
                        document.getElementById(
                            "email"
                        ).value.trim();


                    const password =
                        document.getElementById(
                            "password"
                        ).value;


                    const remember =
                        document.getElementById(
                            "rememberMe"
                        ).checked;


                    const loginBtn =
                        document.getElementById(
                            "loginBtn"
                        );


                    /* -----------------------------------------
                       VALIDATION
                       ----------------------------------------- */

                    if (!email && !password) {

                        showError(
                            "Please enter your email and password."
                        );

                        return;

                    }


                    if (!email) {

                        showError(
                            "Please enter your email address."
                        );

                        return;

                    }


                    if (!password) {

                        showError(
                            "Please enter your password."
                        );

                        return;

                    }


                    /* -----------------------------------------
                       EMAIL VALIDATION
                       ----------------------------------------- */

                    const emailPattern =
                        /^[^\s@]+@[^\s@]+\.[^\s@]+$/;


                    if (!emailPattern.test(email)) {

                        showError(
                            "Please enter a valid email address."
                        );

                        return;

                    }


                    /* -----------------------------------------
                       PREVENT DUPLICATE LOGIN
                       ----------------------------------------- */

                    loginBtn.disabled =
                        true;


                    loginBtn.innerHTML =
                        '<span class="spinner-border spinner-border-sm me-2"></span>Logging in...';


                    showLoading();


                    /* -----------------------------------------
                       LOGIN REQUEST
                       ----------------------------------------- */

                    fetch(
                        "<%=request.getContextPath()%>/LoginSrv",
                        {

                            method: "POST",

                            headers: {

                                "Content-Type":
                                    "application/x-www-form-urlencoded"

                            },

                            body:
                                new URLSearchParams({

                                    username:
                                        email,

                                    password:
                                        password

                                })

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

                            data =
                                data.trim();


                            /* Close loading */

                            closeMyShopMessage();


                            /* ---------------------------------
                               INVALID LOGIN
                               --------------------------------- */

                            if (
                                data === "invalid"
                                ||
                                data === "INVALID"
                                ||
                                data === "false"
                            ) {

                                resetLoginButton();

                                showError(
                                    "Wrong email or password. Please try again."
                                );

                                return;

                            }


                            /* ---------------------------------
                               REMEMBER ME
                               --------------------------------- */

                            if (remember) {

                                localStorage.setItem(
                                    "email",
                                    email
                                );

                            } else {

                                localStorage.removeItem(
                                    "email"
                                );

                            }


                            /* ---------------------------------
                               ADMIN
                               --------------------------------- */

                            if (
                                data === "ADMIN"
                            ) {

                                showSuccess(
                                    "Welcome Admin!"
                                );


                                setTimeout(
                                    function () {

                                        window.location.href =
                                            "<%=request.getContextPath()%>/admin/adminHome.jsp";

                                    },
                                    1000
                                );


                                return;

                            }


                            /* ---------------------------------
                               DELIVERY
                               --------------------------------- */

                            if (
                                data === "DELIVERY"
                                ||
                                data === "STAFF"
                            ) {

                                showSuccess(
                                    "Welcome Staff!"
                                );


                                setTimeout(
                                    function () {

                                        window.location.href =
                                            "<%=request.getContextPath()%>/staff/staffHome.jsp";

                                    },
                                    1000
                                );


                                return;

                            }


                            /* ---------------------------------
                               CUSTOMER
                               --------------------------------- */

                            if (
                                data === "CUSTOMER"
                                ||
                                data === "USER"
                            ) {

                                showSuccess(
                                    "Login Successful!"
                                );


                                setTimeout(
                                    function () {

                                        window.location.href =
                                            "<%=request.getContextPath()%>/user/userHome.jsp";

                                    },
                                    1000
                                );


                                return;

                            }


                            /* ---------------------------------
                               UNKNOWN ROLE
                               --------------------------------- */

                            resetLoginButton();

                            showError(
                                "Unable to login. Invalid account role."
                            );

                        }
                    )

                    .catch(
                        function (error) {

                            console.error(
                                "Normal login error:",
                                error
                            );


                            closeMyShopMessage();

                            resetLoginButton();


                            showServerError(
                                "Unable to connect to the server. Please try again."
                            );

                        }
                    );

                }
            );


        /* =========================================================
           GOOGLE LOGIN
           ========================================================= */

        function handleCredentialResponse(response) {

            if (
                !response
                ||
                !response.credential
            ) {

                showError(
                    "Google authentication failed. Please try again."
                );

                return;

            }


            const jwt =
                response.credential;


            console.log(
                "Google authentication token received"
            );


            showMessage(
                "loading",
                "Google Login",
                "Verifying your Google account...",
                0
            );


            /* -----------------------------------------
               GOOGLE REQUEST
               ----------------------------------------- */

            fetch(
                "<%=request.getContextPath()%>/GoogleLoginServlet",
                {

                    method: "POST",

                    headers: {

                        "Content-Type":
                            "application/x-www-form-urlencoded"

                    },

                    body:
                        new URLSearchParams({

                            token:
                                jwt

                        })

                }
            )

            .then(
                function (response) {

                    return response.text()
                        .then(
                            function (data) {

                                return {

                                    status:
                                        response.status,

                                    ok:
                                        response.ok,

                                    data:
                                        data.trim()

                                };

                            }
                        );

                }
            )

            .then(
                function (result) {

                    console.log(
                        "Google login response:",
                        result.data
                    );


                    closeMyShopMessage();


                    /* =====================================================
                       SERVER ERROR
                       ===================================================== */

                    if (!result.ok) {

                        switch (result.data) {

                            case "INVALID_TOKEN":

                                showError(
                                    "Invalid Google authentication token."
                                );

                                break;


                            case "GOOGLE_TOKEN_INVALID":

                                showError(
                                    "Google authentication could not be verified."
                                );

                                break;


                            case "EMAIL_NOT_FOUND":

                                showError(
                                    "Google account email could not be verified."
                                );

                                break;


                            case "EMAIL_NOT_VERIFIED":

                                showError(
                                    "Your Google email address is not verified."
                                );

                                break;


                            case "USER_LOGIN_FAILED":

                                showError(
                                    "Unable to create or find your MYSHOP account."
                                );

                                break;


                            case "USER_ROLE_MISSING":

                                showError(
                                    "Your account role is not configured."
                                );

                                break;


                            default:

                                showServerError(
                                    "Unable to complete Google login. Please try again."
                                );

                        }

                        return;

                    }


                    /* =====================================================
                       NORMALIZE RESPONSE
                       ===================================================== */

                    const role =
                        result.data
                            .trim()
                            .toUpperCase();


                    /* =====================================================
                       ADMIN
                       ===================================================== */

                    if (role === "ADMIN") {

                        showSuccess(
                            "Welcome Admin! Redirecting..."
                        );


                        setTimeout(
                            function () {

                                window.location.href =
                                    "<%=request.getContextPath()%>/admin/adminHome.jsp";

                            },
                            1000
                        );


                        return;

                    }


                    /* =====================================================
                       DELIVERY / STAFF
                       ===================================================== */

                    if (
                        role === "DELIVERY"
                        ||
                        role === "STAFF"
                    ) {

                        showSuccess(
                            "Welcome Staff! Redirecting..."
                        );


                        setTimeout(
                            function () {

                                window.location.href =
                                    "<%=request.getContextPath()%>/staff/staffHome.jsp";

                            },
                            1000
                        );


                        return;

                    }


                    /* =====================================================
                       CUSTOMER / USER
                       ===================================================== */

                    if (
                        role === "CUSTOMER"
                        ||
                        role === "USER"
                    ) {

                        showSuccess(
                            "Login successful! Welcome to MYSHOP."
                        );


                        setTimeout(
                            function () {

                                window.location.href =
                                    "<%=request.getContextPath()%>/user/userHome.jsp";

                            },
                            1000
                        );


                        return;

                    }


                    /* =====================================================
                       UNKNOWN ROLE
                       ===================================================== */

                    console.error(
                        "Unknown Google account role:",
                        role
                    );


                    showError(
                        "Your account role is not recognized. Please contact MYSHOP support."
                    );

                }
            )

            .catch(
                function (error) {

                    console.error(
                        "Google login error:",
                        error
                    );


                    closeMyShopMessage();


                    showServerError(
                        "Unable to connect to the MYSHOP server. Please try again."
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

                    applyLoginTheme();

                }

            }
        );


        /* =========================================================
           SERVER MESSAGE
           ========================================================= */

        document.addEventListener(
            "DOMContentLoaded",
            function () {

                <% 
                    if (message != null &&
                        !message.trim().isEmpty()) {

                    String safeMessage =
                        message
                            .replace("\\", "\\\\")
                            .replace("\"", "\\\"")
                            .replace("\r", "")
                            .replace("\n", "\\n");
                %>

                    showSessionMessage(
                        "<%=safeMessage%>"
                    );

                <% } %>

            }
        );


    </script>
         
    
</body>

</html>