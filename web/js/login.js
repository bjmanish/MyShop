


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
