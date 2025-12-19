<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Delivery Staff</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 3 -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

    <style>
        body {
            background-color: #E6F9E6;
        }

        .register-container {
            max-width: 600px;
            margin: 30px auto 150px;
            background-color: #FFE5CC;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #333;
        }

        .register-container h2 {
            text-align: center;
            color: crimson;
            margin-bottom: 15px;
        }

        .image-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            display: none;
            margin: 0 auto 10px;
            border: 1px solid green;
        }

        .input-group-addon {
            width: 40px;
        }

        .toggle-eye {
            cursor: pointer;
        }
    </style>
</head>

<body>

<%
    // ---- Session Validation ----
    String userName = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("usertype");

    if (userName == null || userType == null || !userType.equalsIgnoreCase("admin")) {
        response.sendRedirect("login.jsp?error=access_denied");
        return;
    }
%>

<%@ include file="header.jsp" %>

<div class="register-container">

    <h2>Add Delivery Staff</h2>

    <form action="AddStaffSrv" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">

        <!-- Error Message -->
        <div class="alert alert-danger" id="errorMessage" style="display:none;"></div>

        <!-- Profile Image -->
        <div class="form-group text-center">
            <img id="profilePreview" class="image-preview">
            <input type="file" name="profileImage" class="form-control" accept="image/*" onchange="previewImage(this)" required>
        </div>

        <!-- Name -->
        <div class="form-group">
            <label>Name</label>
            <div class="input-group">
                <span class="input-group-addon">
                    <i class="glyphicon glyphicon-user"></i>
                </span>
                <input type="text" class="form-control" name="username" required>
            </div>
        </div>

        <!-- Email -->
        <div class="form-group">
            <label>Email</label>
            <div class="input-group">
                <span class="input-group-addon">
                    <i class="glyphicon glyphicon-envelope"></i>
                </span>
                <input type="email" class="form-control" name="email" required>
            </div>
        </div>

        <!-- Mobile -->
        <div class="form-group">
            <label>Mobile</label>
            <div class="input-group">
                <span class="input-group-addon">
                    <i class="glyphicon glyphicon-phone"></i>
                </span>
                <input type="tel" class="form-control" name="mobile" pattern="[0-9]{10}" required>
            </div>
        </div>

        <!-- Password -->
        <div class="form-group">
            <label>Password</label>
            <div class="input-group">
                <span class="input-group-addon">
                    <i class="glyphicon glyphicon-lock"></i>
                </span>
                <input type="password" id="password" class="form-control" name="password" required>
                <span class="input-group-addon toggle-eye" onclick="togglePassword('password', this)">
                    <i class="glyphicon glyphicon-eye-open"></i>
                </span>
            </div>
        </div>

        <!-- Confirm Password -->
        <div class="form-group">
            <label>Confirm Password</label>
            <div class="input-group">
                <span class="input-group-addon">
                    <i class="glyphicon glyphicon-lock"></i>
                </span>
                <input type="password" id="confirmPassword" class="form-control" name="confirmPassword" required>
                <span class="input-group-addon toggle-eye" onclick="togglePassword('confirmPassword', this)">
                    <i class="glyphicon glyphicon-eye-open"></i>
                </span>
            </div>
        </div>

        <button type="submit" class="btn btn-primary btn-block">
            Add Staff
        </button>

    </form>
</div>

<jsp:include page="footer.html"></jsp:include>

<script>
    function previewImage(input) {
        const preview = document.getElementById("profilePreview");
        const file = input.files[0];

        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = "block";
            };
            reader.readAsDataURL(file);
        }
    }

    function togglePassword(fieldId, el) {
        const field = document.getElementById(fieldId);
        const icon = el.querySelector("i");

        if (field.type === "password") {
            field.type = "text";
            icon.className = "glyphicon glyphicon-eye-close";
        } else {
            field.type = "password";
            icon.className = "glyphicon glyphicon-eye-open";
        }
    }

    function validateForm() {
        const pwd = document.getElementById("password").value;
        const cpwd = document.getElementById("confirmPassword").value;
        const errorBox = document.getElementById("errorMessage");

        if (pwd !== cpwd) {
            errorBox.innerText = "Passwords do not match!";
            errorBox.style.display = "block";
            return false;
        }
        return true;
    }
</script>

</body>
</html>
