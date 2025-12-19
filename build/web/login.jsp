<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<jsp:include page="header.jsp" />

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-body">

                    <h3 class="text-center text-success mb-3">Login Form</h3>

                    <%-- ERROR MESSAGE --%>
                    <%
                        String error = (String) session.getAttribute("error");
                        if (error != null) {
                    %>
                        <div id="errorBox" class="alert alert-danger text-center">
                            <%= error %>
                        </div>
                    <%
                          // session.removeAttribute("error"); // clear flash message
                        }
                    %>

                    <form action="LoginSrv" method="post">

                        <!-- Email -->
                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="username" class="form-control" required>
                        </div>

                        <!-- Password -->
                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>

                        <!-- User Role -->
                        <div class="mb-3">
                            <label class="form-label">Login As</label>
                            <select class="form-select" name="usertype" required>
                                <option value="customer">CUSTOMER</option>
                                <option value="admin">ADMIN</option>
                                <option value="staff">DELIVERY STAFF</option>
                            </select>
                        </div>

                        <!-- Remember Me -->
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" name="rememberMe">
                            <label class="form-check-label">Remember Me</label>
                        </div>

                        <!-- Submit -->
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-success">Login</button>
                        </div>

                        <div class="text-center">
                            <a href="register.jsp">Create New Account</a>
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.html" />

<script>
    // Auto-hide error
    setTimeout(() => {
        const box = document.getElementById("errorBox");
        if (box) box.style.display = "none";
    }, 5000);
</script>

</body>
</html>
