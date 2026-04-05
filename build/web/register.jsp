<%
    String message = request.getParameter("message");
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Register</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    /*background: linear-gradient(135deg, #1d2671, #c33764);*/
     background: linear-gradient(135deg, #141e30, #243b55);
    min-height: 100vh;
}

.register-container {
    min-height: 80vh;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 80px;
}

.glass-card {
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(15px);
    border-radius: 15px;
    padding: 25px;
    color: white;
    width: 100%;
    max-width: 550px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.3);
}

.form-control {
    background: transparent;
    color: white;
    border: 1px solid rgba(255,255,255,0.3);
}

.form-control::placeholder { color: #ddd; }

.input-group-text {
    background: transparent;
    color: white;
    cursor: pointer;
}

.image-preview {
    width: 90px;
    height: 90px;
    border-radius: 50%;
    display: none;
    border: 2px solid white;
    margin-bottom: 10px;
}

.btn-light {
    font-weight: bold;
    border-radius: 25px;
}

/* ALERT ANIMATION */
.alert-box {
    width: 50%;    
    display: none;
    transition: all 0.4s ease;
    margin: 0 auto;
}
</style>
</head>

<body>

<!-- REGISTER -->
<div class="container register-container">

<div class="glass-card">
    <!-- ALERT BOX -->
    <div id="successBox" class="alert alert-success text-center alert-box"></div>
    <div id="errorBox" class="alert alert-danger text-center alert-box"></div>
<h3 class="text-center mb-4">Create Account</h3>

<form id="registerForm" enctype="multipart/form-data">

<!-- IMAGE -->
<div class="text-center">
    <img id="preview" class="image-preview">
    <input type="file" name="image" class="form-control mb-3" onchange="previewImage(event)">
</div>

<!-- NAME -->
<input type="text" name="name" class="form-control mb-3" placeholder="Full Name" required>

<!-- EMAIL -->
<input type="email" name="email" class="form-control mb-3" placeholder="Email" required>

<!-- MOBILE -->
<input type="text" name="mobile" class="form-control mb-3" placeholder="Mobile Number" required>

<!-- ADDRESS -->
<textarea name="address" class="form-control mb-3" placeholder="Address" required></textarea>

<!-- PINCODE -->
<input type="text" name="pincode" class="form-control mb-3" placeholder="Pincode" required>

<!-- PASSWORD -->
<div class="input-group mb-3">
<input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
<span class="input-group-text" onclick="togglePassword('password','eye1')">
<i id="eye1" class="fa fa-eye"></i>
</span>
</div>

<!-- CONFIRM PASSWORD -->
<div class="input-group mb-4">
<input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
<span class="input-group-text" onclick="togglePassword('confirmPassword','eye2')">
<i id="eye2" class="fa fa-eye"></i>
</span>
</div>

<!-- BUTTON -->
<button type="button" id="registerBtn" onclick="registerUser()" class="btn btn-light w-100">
    Register
</button>

</form>

<div class="text-center mt-3">
<a href="login.jsp" class="text-white">Already have account? Login</a>
</div>

</div>
</div>

<script>

/* IMAGE PREVIEW */
function previewImage(event) {
    const img = document.getElementById("preview");
    img.src = URL.createObjectURL(event.target.files[0]);
    img.style.display = "block";
}

/* PASSWORD TOGGLE */
function togglePassword(id, iconId) {
    const input = document.getElementById(id);
    const icon = document.getElementById(iconId);

    if (input.type === "password") {
        input.type = "text";
        icon.classList.replace("fa-eye", "fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.replace("fa-eye-slash", "fa-eye");
    }
}

/* SHOW SUCCESS */
function showSuccess(msg) {
    const box = document.getElementById("successBox");
    box.innerText = msg;
    box.style.display = "block";

    setTimeout(() => {
        box.style.display = "none";
    }, 3000);
}

/* SHOW ERROR */
function showError(msg) {
    const box = document.getElementById("errorBox");
    box.innerText = msg;
    box.style.display = "block";

    setTimeout(() => {
        box.style.display = "none";
    }, 4000);
}

/* REGISTER AJAX */
function registerUser() {

    const btn = document.getElementById("registerBtn");
    btn.disabled = true;
    btn.innerText = "Registering...";

    const form = document.getElementById("registerForm");
    const formData = new FormData(form);

    const password = document.getElementById("password").value;
    const confirmPassword = document.getElementById("confirmPassword").value;

    if (password !== confirmPassword) {
        showError("Passwords do not match");
        btn.disabled = false;
        btn.innerText = "Register";
        return;
    }

    fetch("RegisterSrv", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formData
    })
    .then(res => res.text())
    .then(data => {

        if (data.status === "success") {
            showSuccess("Registration Successful!");

            setTimeout(() => {
                window.location.href = "login.jsp";
            }, 1500);

        } else {
            showError(data.message || "Registration Failed");
        }

        btn.disabled = false;
        btn.innerText = "Register";
    })
    .catch(err => {
        console.error(err);
        showError("Server Error!");
        btn.disabled = false;
        btn.innerText = "Register";
    });
}

</script>

</body>
</html>