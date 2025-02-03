<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Delivery Staff</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

    <style>
        .register-container {
            background: 0 4px rgba(0, 0, 0, 0.6);
            padding:  10px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            margin: 0px auto;
            margin-bottom: -150px ;
        }

        .register-container h2 {
            background: 0 4px rgba(0, 0, 0, 0);
            margin-bottom: 5px;
            color: crimson;
            text-align: center;
        }

        .register-container .form-label {
            color: #555;
            font-weight: bold;
        }

        .register-container .input-group-text {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
        }

        .register-container .input-group-text i {
            color: #007bff;
        }

        .register-container .form-control {
            border-radius: 4px;
        }

        .register-container .btn-primary {
            width: 100%;
            background-color: #007bff;
            border-color: #007bff;
            padding: 10px;
            font-size: 16px;
        }

        .register-container .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .register-container .error,
        .register-container .success {
            margin-bottom: 15px;
            text-align: center;
        }

        .register-container .error {
            color: #ff0000;
        }

        .register-container .success {
            color: #28a745;
        }

        .register-container a {
            display: block;
            text-align: center;
            margin-top: 10px;
            color: #007bff;
            text-decoration: none;
        }

        .register-container a:hover {
            text-decoration: underline;
        }
        .image-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            display: none;
            margin: 0 auto 10px auto;
            border: 0.5px solid green;
        }

        .image-upload-btn {
            display: block;
            width: 100%;
            margin-bottom: 15px;
        }
        
        .input-group i{
            width: 15px;
            height: 20.5px;
        }
/*        .glyphicon-lock{
            width: 10px;
            height: 1px;
        }*/
        #togglePassword i, #toggleConfPassword i, #toggleIcon {
            color: #007bff;
            width: 20px;
            height: 20.5px;
            justify-content: center;
            align-content: center;
            display: flex;
            
        }
    </style>
</head>
<body style="background-color: #E6F9E6;">
    <%
        String message = request.getParameter("message");
    %>

    <!-- Registration Form -->
    <div class="register-container">
        <h2>Registration Form</h2>
        <form id="registerForm" action="./RegisterSrv" style="border: 1px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
            <!-- Error & Success Messages -->
            <div class="alert alert-danger error" id="errorMessage" style="display: none;"></div>
            <div class="alert alert-success success" id="successMessage" style="display: none;"></div>
            
            
            <!-- Profile Image -->
            <div class="form-group text-center">
                <img src="" alt="Profile Preview" class="image-preview" id="profilePreview">
                <input type="file" id="profileImage" name="profileImage" accept="image/*" class="form-control image-upload-btn" onchange="previewImage(event)">
            </div>
            
            <!-- Username -->
            <div class="form-group">
                <label for="username" class="form-label">Name</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" required>
                </div>
            </div>

            <!-- Email -->
            <div class="form-group">
                <label for="email" class="form-label">Email</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="glyphicon glyphicon-envelope"></i></span>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                </div>
            </div>
            
            <!-- Phone Number -->
            <div class="form-group">
                <label for="mobile" class="form-label">Phone No.</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="glyphicon glyphicon-phone"></i></span>
                    <input type="tel" class="form-control" id="mobile" name="mobile" placeholder="Enter your Phone Number" required>
                </div>
            </div>
                       
            <!-- Password -->
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div class="input-group" style="display: flex;">
                    <div class="input-group-prepend">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                    </div>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                    <div class="input-group-append">
                        <span class="input-group-addon" id="togglePassword"><i class="glyphicon glyphicon-eye-open" id="toggleIcon"></i></span>
                    </div>
                </div>                
            </div>

            <!-- Confirm Password -->
            <div class="form-group">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <div class="input-group" style="display: flex;">
                    <div class="input-group-prepend">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                    </div>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Enter your password" required>
                    <div class="input-group-append">
                        <span class="input-group-addon" id="toggleConfPassword"><i class="glyphicon glyphicon-eye-open" id="toggleIcon"></i></span>
                    </div>
                </div>                
            </div>

            <!-- Register Button -->
            <button type="button" class="btn btn-primary" id="registerButton">Add Staff</button>
        </form>

    </div>

    <!-- Footer Include -->
    <jsp:include page="footer.html"></jsp:include>
    
    <script src="./js/allJsCode.js"></script>
</body>
</html>
