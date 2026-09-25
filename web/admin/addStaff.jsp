<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Add Delivery Staff - MyShop</title>


    <!-- =====================================================
         BOOTSTRAP 5
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
        rel="stylesheet">


    <style>

        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            padding: 0;

            width: 100%;

            min-width: 320px;

            overflow-x: hidden;
        }


        body {

            min-height: 100vh;

            background:
                linear-gradient(
                    135deg,
                    #1d2671 0%,
                    #c33764 100%
                );

            font-family:
                "Segoe UI",
                Arial,
                sans-serif;
        }


        /* =====================================================
           MAIN CONTAINER
           ===================================================== */

        .register-container {

            min-height:
                calc(100vh - 160px);

            display: flex;

            align-items: center;

            justify-content: center;

            padding:
                40px
                15px;
        }


        /* =====================================================
           GLASS CARD
           ===================================================== */

        .glass-card {

            background:
                rgba(255, 255, 255, 0.14);

            backdrop-filter:
                blur(18px);

            -webkit-backdrop-filter:
                blur(18px);

            border:
                1px solid
                rgba(255, 255, 255, 0.20);

            border-radius: 20px;

            padding: 30px;

            

            width: 100%;

            max-width: 560px;

            box-shadow:
                0 15px 40px
                rgba(0, 0, 0, 0.25);
        }


        /* =====================================================
           TITLE
           ===================================================== */

        .form-title {

            font-size: 28px;

            font-weight: 700;

            margin-bottom: 5px;
        }


        .form-subtitle {

            color:
                rgba(255, 255, 255, 0.75);

            font-size: 14px;

            margin-bottom: 25px;
        }


        /* =====================================================
           FORM LABEL
           ===================================================== */

        .form-label {

            color: white;

            font-weight: 600;

            font-size: 14px;

            margin-bottom: 7px;
        }


        /* =====================================================
           INPUTS
           ===================================================== */

        .form-control,
        .form-select {

            width: 100%;

            min-height: 45px;

            background:
                rgba(255, 255, 255, 0.08);

            color: white;

            border:
                1px solid
                rgba(255, 255, 255, 0.30);

            border-radius: 9px;

            padding:
                10px
                13px;

            box-shadow: none;

            transition:
                all 0.2s ease;
        }


        .form-control:focus,
        .form-select:focus {

            background:
                rgba(255, 255, 255, 0.13);

            color: white;

            border-color:
                rgba(255, 255, 255, 0.80);

            box-shadow:
                0 0 0 3px
                rgba(255, 255, 255, 0.10);
        }


        .form-control::placeholder {

            color:
                rgba(255, 255, 255, 0.65);
        }


        /* =====================================================
           SELECT OPTION
           ===================================================== */

        .form-select option {

            color: #222;

            background: white;
        }


        /* =====================================================
           TEXTAREA
           ===================================================== */

        textarea.form-control {

            min-height: 100px;

            resize: vertical;
        }


        /* =====================================================
           FILE INPUT
           ===================================================== */

        input[type="file"].form-control {

            padding: 8px 10px;
        }


        /* =====================================================
           IMAGE SECTION
           ===================================================== */

        .image-section {

            text-align: center;

            padding:
                10px
                0
                20px;
        }


        .image-preview-wrapper {

            width: 105px;

            height: 105px;

            margin:
                0
                auto
                15px;

            position: relative;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .image-preview {

            width: 100px;

            height: 100px;

            border-radius: 50%;

            object-fit: cover;

            display: none;

            border:
                3px solid
                rgba(255, 255, 255, 0.9);

            box-shadow:
                0 5px 15px
                rgba(0, 0, 0, 0.25);
        }


        .default-avatar {

            width: 100px;

            height: 100px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                rgba(255, 255, 255, 0.15);

            border:
                2px dashed
                rgba(255, 255, 255, 0.5);

            color:
                rgba(255, 255, 255, 0.75);

            font-size: 35px;
        }


        /* =====================================================
           PASSWORD GROUP
           ===================================================== */

        .password-group {

            position: relative;
        }


        .password-group .form-control {

            padding-right: 48px;
        }


        .password-toggle {

            position: absolute;

            right: 0;

            top: 0;

            height: 100%;

            width: 45px;

            display: flex;

            align-items: center;

            justify-content: center;

            color: white;

            cursor: pointer;

            z-index: 5;
        }


        .password-toggle:hover {

            color: #ddd;
        }


        /* =====================================================
           ADD BUTTON
           ===================================================== */

        .btn-add {

            width: 100%;

            min-height: 48px;

            border: none;

            border-radius: 10px;

            background: white;

            color: #1d2671;

            font-size: 16px;

            font-weight: 700;

            transition:
                all 0.25s ease;
        }


        .btn-add:hover {

            background: #f1f1f1;

            color: #c33764;

            transform:
                translateY(-2px);

            box-shadow:
                0 7px 20px
                rgba(0, 0, 0, 0.20);
        }


        .btn-add:disabled {

            opacity: 0.7;

            cursor: not-allowed;

            transform: none;
        }


        /* =====================================================
           ALERT
           ===================================================== */

        .alert-container {

            width: 100%;

            max-width: 560px;

            margin:
                50px
                auto
                0;

            padding:
                0
                15px;
        }


        .alert-box {

            display: none;

            border-radius: 10px;

            font-size: 14px;

            margin-bottom: 10px;

            box-shadow:
                0 5px 15px
                rgba(0, 0, 0, 0.15);
        }


        /* =====================================================
           REQUIRED STAR
           ===================================================== */

        .required {

            color: #ffdddd;

            margin-left: 2px;
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 600px) {

            .register-container {

                min-height: auto;

                padding:
                    25px
                    10px
                    35px;
            }


            .glass-card {

                padding: 20px 16px;

                border-radius: 16px;
            }


            .form-title {

                font-size: 23px;
            }


            .form-subtitle {

                font-size: 12px;

                margin-bottom: 20px;
            }


            .form-label {

                font-size: 13px;
            }


            .form-control,
            .form-select {

                min-height: 44px;

                font-size: 14px;

                border-radius: 8px;
            }


            textarea.form-control {

                min-height: 95px;
            }


            .image-preview-wrapper {

                width: 90px;

                height: 90px;
            }


            .image-preview,
            .default-avatar {

                width: 85px;

                height: 85px;
            }


            .default-avatar {

                font-size: 30px;
            }


            .btn-add {

                min-height: 46px;

                font-size: 15px;
            }
        }


        /* =====================================================
           SMALL MOBILE
           ===================================================== */

        @media (max-width: 380px) {

            .register-container {

                padding:
                    15px
                    6px
                    25px;
            }


            .glass-card {

                padding:
                    18px
                    12px;

                border-radius: 14px;
            }


            .form-title {

                font-size: 21px;
            }


            .form-subtitle {

                font-size: 11px;
            }


            .form-control,
            .form-select {

                min-height: 42px;

                font-size: 13px;

                padding:
                    8px
                    10px;
            }


            textarea.form-control {

                min-height: 90px;
            }


            .btn-add {

                min-height: 44px;

                font-size: 14px;
            }


            .alert-container {

                padding:
                    0
                    7px;
            }
        }


        /* =====================================================
           VERY SMALL DEVICES
           ===================================================== */

        @media (max-width: 320px) {

            .glass-card {

                padding:
                    15px
                    10px;
            }


            .form-title {

                font-size: 19px;
            }


            .form-control,
            .form-select {

                font-size: 12px;
            }
        }

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp" />


<!-- =========================================================
     ALERT AREA
     ========================================================= -->

<div class="alert-container">

    <div
        id="successBox"
        class="alert alert-success alert-box text-center"
        role="alert"
    ></div>


    <div
        id="errorBox"
        class="alert alert-danger alert-box text-center"
        role="alert"
    ></div>

</div>



<!-- =========================================================
     REGISTER CONTAINER
     ========================================================= -->

<div class="container-fluid register-container">

    <div class="glass-card">


        <!-- =================================================
             TITLE
             ================================================= -->

        <div class="text-center">

            <div class="form-title">

                <i class="fa-solid fa-user-plus"></i>

                Add Delivery Staff

            </div>


            <div class="form-subtitle">

                Create a new delivery staff account

            </div>

        </div>



        <!-- =================================================
             FORM
             ================================================= -->

        <form
            id="staffForm"
            enctype="multipart/form-data"
            novalidate
        >


            <!-- =================================================
                 ROLE
                 ================================================= -->

            <input
                type="hidden"
                name="role"
                value="DELIVERY"
            >



            <!-- =================================================
                 PROFILE IMAGE
                 ================================================= -->

            <div class="image-section">


                <div class="image-preview-wrapper">


                    <!-- DEFAULT ICON -->

                    <div
                        id="defaultAvatar"
                        class="default-avatar"
                    >

                        <i class="fa-solid fa-user"></i>

                    </div>


                    <!-- PREVIEW -->

                    <img
                        id="preview"
                        class="image-preview"
                        alt="Staff Image Preview"
                    >

                </div>


                <label
                    for="staffImage"
                    class="form-label"
                >

                    <i class="fa-solid fa-camera"></i>

                    Profile Image

                </label>


                <input
                    type="file"
                    id="staffImage"
                    name="image"
                    class="form-control"
                    accept="image/*"
                    onchange="previewImage(event)"
                >

            </div>



            <!-- =================================================
                 FULL NAME
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="name"
                    class="form-label"
                >

                    Full Name
                    <span class="required">*</span>

                </label>


                <input
                    type="text"
                    id="name"
                    name="name"
                    class="form-control"
                    placeholder="Enter full name"
                    autocomplete="name"
                    required
                >

            </div>



            <!-- =================================================
                 EMAIL
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="email"
                    class="form-label"
                >

                    Email
                    <span class="required">*</span>

                </label>


                <input
                    type="email"
                    id="email"
                    name="email"
                    class="form-control"
                    placeholder="Enter email address"
                    autocomplete="email"
                    required
                >

            </div>



            <!-- =================================================
                 MOBILE
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="mobile"
                    class="form-label"
                >

                    Mobile Number
                    <span class="required">*</span>

                </label>


                <input
                    type="tel"
                    id="mobile"
                    name="mobile"
                    class="form-control"
                    placeholder="Enter mobile number"
                    inputmode="numeric"
                    maxlength="10"
                    required
                >

            </div>



            <!-- =================================================
                 ADDRESS
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="address"
                    class="form-label"
                >

                    Address
                    <span class="required">*</span>

                </label>


                <textarea
                    id="address"
                    name="address"
                    class="form-control"
                    placeholder="Enter complete address"
                    required
                ></textarea>

            </div>



            <!-- =================================================
                 PINCODE
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="pincode"
                    class="form-label"
                >

                    Pincode
                    <span class="required">*</span>

                </label>


                <input
                    type="text"
                    id="pincode"
                    name="pincode"
                    class="form-control"
                    placeholder="Enter pincode"
                    inputmode="numeric"
                    maxlength="6"
                    required
                >

            </div>



            <!-- =================================================
                 VEHICLE
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="vehicleType"
                    class="form-label"
                >

                    Vehicle Type
                    <span class="required">*</span>

                </label>


                <select
                    id="vehicleType"
                    name="vehicleType"
                    class="form-select"
                    required
                >

                    <option value="">
                        Select Vehicle
                    </option>

                    <option value="BIKE">
                        Bike
                    </option>

                    <option value="CYCLE">
                        Cycle
                    </option>

                    <option value="VAN">
                        Van
                    </option>

                </select>

            </div>



            <!-- =================================================
                 LICENSE
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="licenseNumber"
                    class="form-label"
                >

                    License Number
                    <span class="required">*</span>

                </label>


                <input
                    type="text"
                    id="licenseNumber"
                    name="licenseNumber"
                    class="form-control"
                    placeholder="Enter license number"
                    style="text-transform:uppercase;"
                    required
                >

            </div>



            <!-- =================================================
                 PASSWORD
                 ================================================= -->

            <div class="mb-3">

                <label
                    for="password"
                    class="form-label"
                >

                    Password
                    <span class="required">*</span>

                </label>


                <div class="password-group">

                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control"
                        placeholder="Enter password"
                        autocomplete="new-password"
                        required
                    >


                    <span
                        class="password-toggle"
                        onclick="togglePassword('password','eye1')"
                        title="Show/Hide Password"
                    >

                        <i
                            id="eye1"
                            class="fa-solid fa-eye"
                        ></i>

                    </span>

                </div>

            </div>



            <!-- =================================================
                 CONFIRM PASSWORD
                 ================================================= -->

            <div class="mb-4">

                <label
                    for="confirmPassword"
                    class="form-label"
                >

                    Confirm Password
                    <span class="required">*</span>

                </label>


                <div class="password-group">

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="form-control"
                        placeholder="Confirm password"
                        autocomplete="new-password"
                        required
                    >


                    <span
                        class="password-toggle"
                        onclick="togglePassword('confirmPassword','eye2')"
                        title="Show/Hide Password"
                    >

                        <i
                            id="eye2"
                            class="fa-solid fa-eye"
                        ></i>

                    </span>

                </div>

            </div>



            <!-- =================================================
                 SUBMIT
                 ================================================= -->

            <button
                type="button"
                id="btn"
                onclick="registerStaff()"
                class="btn-add"
            >

                <i class="fa-solid fa-user-plus"></i>

                &nbsp;

                Add Staff

            </button>


        </form>

    </div>

</div>



<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


/* =========================================================
   IMAGE PREVIEW
   ========================================================= */

function previewImage(event) {

    const file =
        event.target.files[0];

    const img =
        document.getElementById("preview");

    const defaultAvatar =
        document.getElementById("defaultAvatar");


    if (!file) {

        img.src = "";

        img.style.display = "none";

        defaultAvatar.style.display = "flex";

        return;
    }


    /* CHECK IMAGE TYPE */

    if (!file.type.startsWith("image/")) {

        showError(
            "Please select a valid image file."
        );

        event.target.value = "";

        img.src = "";

        img.style.display = "none";

        defaultAvatar.style.display = "flex";

        return;
    }


    /* CHECK IMAGE SIZE */

    const maxSize =
        5 * 1024 * 1024;


    if (file.size > maxSize) {

        showError(
            "Image size must be less than 5 MB."
        );

        event.target.value = "";

        img.src = "";

        img.style.display = "none";

        defaultAvatar.style.display = "flex";

        return;
    }


    /* CREATE PREVIEW */

    const objectUrl =
        URL.createObjectURL(file);


    img.src = objectUrl;

    img.style.display = "block";

    defaultAvatar.style.display = "none";

}


/* =========================================================
   PASSWORD TOGGLE
   ========================================================= */

function togglePassword(id, iconId) {

    const input =
        document.getElementById(id);

    const icon =
        document.getElementById(iconId);


    if (input.type === "password") {

        input.type = "text";

        icon.classList.remove(
            "fa-eye"
        );

        icon.classList.add(
            "fa-eye-slash"
        );

    } else {

        input.type = "password";

        icon.classList.remove(
            "fa-eye-slash"
        );

        icon.classList.add(
            "fa-eye"
        );
    }

}


/* =========================================================
   SUCCESS ALERT
   ========================================================= */

function showSuccess(msg) {

    const successBox =
        document.getElementById(
            "successBox"
        );

    const errorBox =
        document.getElementById(
            "errorBox"
        );


    errorBox.style.display =
        "none";


    successBox.innerText =
        msg;

    successBox.style.display =
        "block";


    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });


    setTimeout(function() {

        successBox.style.display =
            "none";

    }, 4000);

}


/* =========================================================
   ERROR ALERT
   ========================================================= */

function showError(msg) {

    const successBox =
        document.getElementById(
            "successBox"
        );

    const errorBox =
        document.getElementById(
            "errorBox"
        );


    successBox.style.display =
        "none";


    errorBox.innerText =
        msg;

    errorBox.style.display =
        "block";


    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });


    setTimeout(function() {

        errorBox.style.display =
            "none";

    }, 5000);

}


/* =========================================================
   MOBILE NUMBER VALIDATION
   ========================================================= */

document
    .getElementById("mobile")
    .addEventListener(
        "input",
        function() {

            this.value =
                this.value.replace(
                    /[^0-9]/g,
                    ""
                );

        }
    );


/* =========================================================
   PINCODE VALIDATION
   ========================================================= */

document
    .getElementById("pincode")
    .addEventListener(
        "input",
        function() {

            this.value =
                this.value.replace(
                    /[^0-9]/g,
                    ""
                );

        }
    );


/* =========================================================
   REGISTER STAFF
   ========================================================= */

function registerStaff() {

    const btn =
        document.getElementById("btn");

    const form =
        document.getElementById(
            "staffForm"
        );


    const pass =
        document.getElementById(
            "password"
        ).value.trim();


    const cpass =
        document.getElementById(
            "confirmPassword"
        ).value.trim();


    const mobile =
        document.getElementById(
            "mobile"
        ).value.trim();


    const pincode =
        document.getElementById(
            "pincode"
        ).value.trim();


    /* =====================================================
       BASIC VALIDATION
       ===================================================== */

    if (!form.checkValidity()) {

        form.reportValidity();

        return;
    }


    /* =====================================================
       MOBILE VALIDATION
       ===================================================== */

    if (mobile.length !== 10) {

        showError(
            "Please enter a valid 10-digit mobile number."
        );

        return;
    }


    /* =====================================================
       PINCODE VALIDATION
       ===================================================== */

    if (pincode.length !== 6) {

        showError(
            "Please enter a valid 6-digit pincode."
        );

        return;
    }


    /* =====================================================
       PASSWORD VALIDATION
       ===================================================== */

    if (pass.length < 6) {

        showError(
            "Password must contain at least 6 characters."
        );

        return;
    }


    /* =====================================================
       PASSWORD MATCH
       ===================================================== */

    if (pass !== cpass) {

        showError(
            "Passwords do not match."
        );

        return;
    }


    /* =====================================================
       DISABLE BUTTON
       ===================================================== */

    btn.disabled = true;

    btn.innerHTML =
        '<i class="fa-solid fa-spinner fa-spin"></i> Processing...';


    /* =====================================================
       FORM DATA
       ===================================================== */

    const data =
        new FormData(form);


    /* =====================================================
       AJAX REQUEST
       ===================================================== */

    fetch(
        "<%=request.getContextPath()%>/AddStaffSrv",
        {
            method: "POST",
            body: data
        }
    )

    .then(function(res) {

        /*
         * Check whether the server actually
         * returned JSON.
         */

        const contentType =
            res.headers.get(
                "content-type"
            );


        if (!res.ok) {

            throw new Error(
                "HTTP Error: "
                + res.status
            );
        }


        if (!contentType ||
            !contentType.includes(
                "application/json"
            )) {

            throw new Error(
                "Invalid server response."
            );
        }


        return res.json();

    })


    .then(function(d) {


        /* =================================================
           SUCCESS
           ================================================= */

        if (d.status === "success") {

            showSuccess(
                d.message ||
                "Delivery Staff Added Successfully!"
            );


            /* RESET FORM */

            form.reset();


            /* RESET IMAGE */

            const preview =
                document.getElementById(
                    "preview"
                );


            const defaultAvatar =
                document.getElementById(
                    "defaultAvatar"
                );


            preview.src = "";

            preview.style.display =
                "none";

            defaultAvatar.style.display =
                "flex";


        }


        /* =================================================
           SERVER ERROR
           ================================================= */

        else {

            showError(
                d.message ||
                "Unable to add delivery staff."
            );
        }


        /* ENABLE BUTTON */

        btn.disabled = false;

        btn.innerHTML =
            '<i class="fa-solid fa-user-plus"></i> &nbsp; Add Staff';

    })


    /* =====================================================
       CATCH
       ===================================================== */

    .catch(function(error) {

        console.error(
            "Add Staff Error:",
            error
        );


        showError(
            "Server error. Please try again."
        );


        btn.disabled = false;

        btn.innerHTML =
            '<i class="fa-solid fa-user-plus"></i> &nbsp; Add Staff';

    });

}

</script>



<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html" />


</body>

</html>