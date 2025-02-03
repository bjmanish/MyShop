<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/main.css">
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6;">

        <jsp:include page="header.jsp"></jsp:include>

	<%
	String message = request.getParameter("message");
        String email = (String)session.getAttribute("Email");
	%>
	<div class="container">
            <div class="row" style="margin: 10px 10px;">
		<form action="./LoginSrv" method="post" class="col-md-4 col-md-offset-4 col-sm-8 col-sm-offset-2"
                    style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;" >
                    <div style="font-weight: bold;" class="text-center">
			<h2 style="color: green;">Login Form</h2>
			<%
                            if (message != null) {
			%>
                        <p style="color: red;" id="errorMessage"><%=message%></p>
			<%  } %>
                    </div>
                    
                    <div></div>
                    
                    <div class="row">			
                        <div class="col-md-12 form-group">
                            <label for="username">Username</label>   
                            <%if(email != null){%>
                            <input type="email" placeholder="Enter valid email" name="username" class="form-control" id="email" value="<%=email%>" required>
                            <%}else{%>
                            <input type="email" placeholder="Enter valid email" name="username" class="form-control" id="email" required>
                            <%}%>
                        </div>
                    </div>
                    
                    <div class="row">			
                        <div class="col-md-12 form-group">
                            <label for="last_name">Password</label> 
                            <input type="password" placeholder="Enter Password" name="password" class="form-control" id="password" required>
			</div>
                    </div>
                    
                    <div class="row">
			<div class="col-md-12 form-group">
                            <label for="userrole">Login As</label> 
                            <select name="usertype" id="userrole" class="form-control" required>
				<option value="customer" selected>CUSTOMER</option>
                                <option value="admin">ADMIN</option>
                                <option value="staff">DELIVERY STAFF</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row">
			<div class="col-md-12 text-center">
                            <button type="submit" id="loginButton" class="btn btn-success">Login</button>
                        </div>
                    </div>                        
                    
                    <!-- Register Link -->
                    <div class="row" style="margin-top: 10px;">
			<div class="col-md-12 text-center">
                            <a href="register.jsp">I do not have an Account? Create Account</a>
                        </div>
                    </div>
                    
                                
		</form>
                        
            </div>
                                
	</div>

        <jsp:include page="footer.html"></jsp:include>
        <script src="./js/allJsCode.js"></script>
    </body>
</html>