<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Add Delivery Staff</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #1d2671, #c33764);
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
    max-width: 550px;
    width: 100%;
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
}

.alert-box {
    width: 50%;
    margin: 0 auto;
    display: none;
}
</style>
</head>

<body>

<jsp:include page="/header.jsp" />

<!-- ALERT -->
<div class="container mt-3">
    <div id="successBox" class="alert alert-success text-center alert-box"></div>
    <div id="errorBox" class="alert alert-danger text-center alert-box"></div>
</div>

<div class="container register-container">
<div class="glass-card">

<h3 class="text-center mb-4">Add Delivery Staff</h3>

<form id="staffForm" enctype="multipart/form-data">

<!-- ROLE -->
<input type="hidden" name="role" value="DELIVERY">

<!-- IMAGE -->
<div class="text-center mb-3">
    <img id="preview" class="image-preview">
    <input type="file" name="image" class="form-control" onchange="previewImage(event)">
</div>

<input type="text" name="name" class="form-control mb-3" placeholder="Full Name" required>
<input type="email" name="email" class="form-control mb-3" placeholder="Email" required>
<input type="text" name="mobile" class="form-control mb-3" placeholder="Mobile" required>

<textarea name="address" class="form-control mb-3" placeholder="Address" required></textarea>

<input type="text" name="pincode" class="form-control mb-3" placeholder="Pincode" required>

<!-- VEHICLE -->
<select name="vehicleType" class="form-control mb-3" required>
    <option value="">Select Vehicle</option>
    <option value="BIKE">Bike</option>
    <option value="CYCLE">Cycle</option>
    <option value="VAN">Van</option>
</select>

<input type="text" name="licenseNumber" class="form-control mb-3" placeholder="License Number" required>

<!-- PASSWORD -->
<div class="input-group mb-3">
<input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
<span class="input-group-text" onclick="togglePassword('password','eye1')">
<i id="eye1" class="fa fa-eye"></i>
</span>
</div>

<div class="input-group mb-4">
<input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
<span class="input-group-text" onclick="togglePassword('confirmPassword','eye2')">
<i id="eye2" class="fa fa-eye"></i>
</span>
</div>

<button type="button" id="btn" onclick="registerStaff()" class="btn btn-light w-100">
    Add Staff
</button>

</form>

</div>
</div>

<jsp:include page="/footer.html" />

<script>

/* IMAGE */
function previewImage(e){
    let img = document.getElementById("preview");
    img.src = URL.createObjectURL(e.target.files[0]);
    img.style.display = "block";
}

/* PASSWORD */
function togglePassword(id, iconId){
    let input = document.getElementById(id);
    let icon = document.getElementById(iconId);

    if(input.type==="password"){
        input.type="text";
        icon.classList.replace("fa-eye","fa-eye-slash");
    } else {
        input.type="password";
        icon.classList.replace("fa-eye-slash","fa-eye");
    }
}

/* ALERT */
function showSuccess(msg){
    let box = document.getElementById("successBox");
    box.innerText = msg;
    box.style.display = "block";
    setTimeout(()=> box.style.display="none",3000);
}

function showError(msg){
    let box = document.getElementById("errorBox");
    box.innerText = msg;
    box.style.display = "block";
    setTimeout(()=> box.style.display="none",4000);
}

/* AJAX */
function registerStaff(){

    let btn = document.getElementById("btn");
    btn.disabled = true;
    btn.innerText = "Processing...";

    let form = document.getElementById("staffForm");
    let data = new FormData(form);

    let pass = document.getElementById("password").value;
    let cpass = document.getElementById("confirmPassword").value;

    if(pass !== cpass){
        showError("Passwords do not match");
        btn.disabled = false;
        btn.innerText = "Add Staff";
        return;
    }

    fetch("<%=request.getContextPath()%>/AddStaffSrv", {
        method: "POST",
        body: data
    })
    .then(res => res.json())
    .then(d => {

        if(d.status === "success"){
            showSuccess("Delivery Staff Added!");

            form.reset();
            document.getElementById("preview").style.display="none";

        } else {
            showError(d.message);
        }

        btn.disabled = false;
        btn.innerText = "Add Staff";
    })
    .catch(()=>{
        showError("Server error");
        btn.disabled = false;
        btn.innerText = "Add Staff";
    });
}

</script>

</body>
</html>