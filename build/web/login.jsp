<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<!-- SweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
 <!--google js Library-->


<style>
body {
    background: linear-gradient(135deg, #141e30, #243b55);
    min-height: 100vh;
}

/* Center */
.login-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Glass Card */
.glass-card {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(15px);
    border-radius: 15px;
    padding: 30px;
    color: white;
    width: 100%;
    max-width: 400px;
}

/* Inputs */
.form-control {
    background: transparent;
    color: white;
}
.form-control::placeholder {
    color: #ddd;
}
.input-group-text {
    background: transparent;
    color: white;
    cursor: pointer;
}

/* Back Button */
.back-btn {
    position: absolute;
    top: 20px;
    left: 20px;
    color: crimson;
    font-weight: 400;
}

/* Button */
.btn-login {
    background: white;
    color: #333;
}
.btn-login:hover {
    background: #007bff;
}
</style>

</head>

<body>



<!-- 🔐 Login -->
<div class="container login-container">
    <div class="glass-card shadow">
        <!-- 🔙 Back Button -->
        <a onclick="window.location.href='index.jsp'" class="btn btn-sm-light shadow-sm back-btn"><i class="bi bi-arrow-left"></i> Back</a>
        <h3 class="text-center mb-4">Login</h3>

        <form id="loginForm">

            <!-- Email -->
            <div class="mb-3">
                <label>Email</label>
                <input type="email" id="email" name="username" class="form-control" placeholder="Enter email" required>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label>Password</label>
                <div class="input-group">
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required>
                    <span class="input-group-text" onclick="togglePassword()">
                        <i id="eyeIcon" class="fa fa-eye"></i>
                    </span>
                </div>
            </div>

            <!-- Remember -->
            <div class="form-check mb-3">
                <input class="form-check-input" type="checkbox" id="rememberMe">
                <label class="form-check-label">Remember Me</label>
            </div>

            <!-- Button -->
            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-login">Login</button>
            </div>
            <!-- Google Signup button-->
            <div class="text-center mb-3">
                <div id="g_id_onload"
                    data-client_id="626330070401-sg7fiq4l715ud8ga6efl115bfj8qkmph.apps.googleusercontent.com"
                    data-callback="handleCredentialResponse">
                </div>

                <div class="g_id_signin"
                    data-type="standard"
                    data-size="large"
                    data-theme="outline"
                    data-text="sign_in_with"
                    data-shape="pill"
                    data-logo_alignment="left">
                </div>
            </div>
            <div class="text-center">
                <a href="register.jsp" class="text-white">Create Account</a>
            </div>

        </form>
    </div>
</div>

<script>

/* 🔐 Toggle Password */
function togglePassword() {
    const pass = document.getElementById("password");
    const icon = document.getElementById("eyeIcon");

    if (pass.type === "password") {
        pass.type = "text";
        icon.classList.replace("fa-eye", "fa-eye-slash");
    } else {
        pass.type = "password";
        icon.classList.replace("fa-eye-slash", "fa-eye");
    }
}

/* 🍪 Remember Me */
window.onload = function () {
    const savedEmail = localStorage.getItem("email");
    if (savedEmail) {
        document.getElementById("email").value = savedEmail;
        document.getElementById("rememberMe").checked = true;
    }
};

/* 🔥 SweetAlert Functions */
function showError(msg) {
    Swal.fire({
        icon: "error",
        title: "Login Failed",
        text: msg,
        confirmButtonColor: "#d33"
    });
}

function showSuccess(msg) {
    Swal.fire({
        icon: "success",
        title: "Success",
        text: msg,
        confirmButtonColor: "#667eea"
    });
}

function showLoading(){
    Swal.fire({
        title: 'Logging in...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
}

/* 🚀 Login AJAX */
document.getElementById("loginForm").addEventListener("submit", function(e) {
    e.preventDefault();

    showLoading();

    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    const remember = document.getElementById("rememberMe").checked;

    fetch("LoginSrv", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: new URLSearchParams({
            username: email,
            password: password
        })
    })
    .then(res => res.text())
    .then(data => {

        data = data.trim();
        Swal.close();

        if (data === "invalid") {
            showError("Invalid username or password");
            return;
        }

        if (remember) {
            localStorage.setItem("email", email);
        } else {
            localStorage.removeItem("email");
        }

        // 🎯 Role-based redirect
        if (data === "ADMIN") {
            showSuccess("Welcome Admin!");
            setTimeout(() => window.location.href = "admin/adminHome.jsp", 1500);

        } else if (data === "DELIVERY" || data === "STAFF") {
            showSuccess("Welcome Staff!");
            setTimeout(() => window.location.href = "staff/staffHome.jsp", 1500);

        } else if (data === "CUSTOMER") {
            showSuccess("Login Successful!");
            setTimeout(() => window.location.href = "user/userHome.jsp", 1500);

        } else {
            showError("Unknown role: " + data);
        }
    })
    .catch(err => {
        Swal.close();
        showError("Server error. Try again!");
        console.error(err);
    });
});

//Google auth frontend hadler
function handleCredentialResponse(response) {

    const jwt = response.credential; // Google ID token

    console.log("Google JWT:", jwt);

    // Send token to backend
    fetch("GoogleLoginServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "token=" + jwt
    })
    .then(res => res.text())
    .then(data => {

        data = data.trim();
console.log(data);

        if (data === "SUCCESS" || data === "CUSTOMER") {
            Swal.fire({
                icon: "success",
                title: "Login Successful",
                text: "Welcome with Google!",
                confirmButtonColor: "#667eea"
            }).then(() => {
                window.location.href = "user/userHome.jsp";
            });
        } else {
            showError("Google login failed");
        }
    })
    .catch(() => {
        showError("Server error during Google login");
    });
}

</script>
 <script src="https://accounts.google.com/gsi/client" async defer></script>
</body>
</html>