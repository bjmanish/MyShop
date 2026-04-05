<%
    String message = request.getParameter("message");
    System.out.println("Error Message:"+message);
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
/*    background: linear-gradient(135deg, #1d2671, #c33764);*/
    background: linear-gradient(135deg, #141e30, #243b55);
    min-height: 100vh;
}

/* CENTER FIX (IMPORTANT) */
.login-container {
    min-height: 80vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* GLASS CARD */
.glass-card {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(15px);
    border-radius: 15px;
    padding: 30px;
    color: white;
    width: 100%;
    max-width: 400px;
}

/* INPUT */
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
</style>

</head>

<body>

<!-- ✅ HEADER -->
<%--<jsp:include page="header.jsp" />--%>

<!-- ✅ LOGIN CENTER -->
<div class="container login-container">

<div class="glass-card shadow">

<h3 class="text-center mb-4">Login</h3>

<%  if(message!=null ){ %>
    <div id="errorBox" class="alert alert-danger text-center"><%=message%></div>
<%}else{%>
    <!--<div id="errorBox" class="alert alert-success text-center"></div>-->
<%}%>

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
<button type="submit" class="btn btn-light">Login</button>
</div>

<div class="text-center">
<a href="register.jsp" class="text-white">Create Account</a>
</div>

</form>
</div>
</div>

<!-- ✅ FOOTER -->
<%--<jsp:include page="footer.html" />--%>

<script>

/* PASSWORD TOGGLE */
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

/* EMAIL SUGGESTION */
const emailInput = document.getElementById("email");

emailInput.addEventListener("input", function () {
    let val = this.value;
    if (val.includes("@")) return;

    const domains = ["gmail.com", "yahoo.com", "outlook.com"];
    this.setAttribute("list", "emailList");

    let datalist = document.getElementById("emailList");
    if (!datalist) {
        datalist = document.createElement("datalist");
        datalist.id = "emailList";
        document.body.appendChild(datalist);
    }

    datalist.innerHTML = "";

    domains.forEach(domain => {
        let option = document.createElement("option");
        option.value = val + "@" + domain;
        datalist.appendChild(option);
    });
});

/* REMEMBER ME */
window.onload = function () {
    const savedEmail = localStorage.getItem("email");
    if (savedEmail) {
        document.getElementById("email").value = savedEmail;
        document.getElementById("rememberMe").checked = true;
    }
};

/* AJAX LOGIN */
document.getElementById("loginForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    const remember = document.getElementById("rememberMe").checked;
    console.log("Email and Password :", email, password);
            
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

        console.log("SERVER:", data);

        data = data.trim(); // ✅ VERY IMPORTANT

        if (data === "invalid") {
            showError("Invalid username or password");
            return;
        }   

        if (remember) {
            localStorage.setItem("email", email);
        } else {
            localStorage.removeItem("email");
        }

        if (data === "ADMIN") {
            window.location.href = "admin/adminHome.jsp";
        } else if (data === "DELIVERY" || data === "STAFF") {
            window.location.href = "staff/staffHome.jsp";
        } else if (data === "CUSTOMER") {
            window.location.href = "user/userHome.jsp";
        }else{
            showError("unauthorized.jsp");
            showError("Unknown role: " + data);
        }
    });
});
</script>

</body>
</html>