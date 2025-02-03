<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>The MYSHOP - Remove Product</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
<!--        <link rel="stylesheet" href="css/main.css">-->
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6;">
        <!-- checking user crendentials java code -->
        
        <%
            String username = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");
            String usertype = (String)session.getAttribute("usertype");
            
            if(usertype == null || !usertype.equals("admin")){
                response.sendRedirect("login.jsp?message=Access Denied! Please Login as Admin.");
            }
            else if(username == null || password == null){
                response.sendRedirect("login.jsp?message=Session Expired!. Please Login Again.");
            }
        %>
        
        <jsp:include page="header.jsp"></jsp:include>

        <!-- get message from request -->
        <% 
            String message = request.getParameter("message");
            String prodId = request.getParameter("prodid");
        %>
        <div class="container">
            <div class="row" style="margin: 10px auto;"  >
                <form action="./RemoveProductSrv" methos="post" class="col-md-4 col-md-offset-4"
                style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
                    <div class="text-center">
                        <h2 style="color: seagreen;">Remove Product Form</h2>
                        <!-- ifchecking message = !null -->
                        <% 
                            if(message != null){
                        %>
                        <p style="color:blue"><%=message%></p>
                        
                        <% 
                            }
                        %>
                    </div>
                    <div></div>
                    
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label for="prodId">Product Id</label>
                            <% if(prodId !=null){%>
                                <input type="text" value="<%= prodId %>" placeholder="Enter Product Id" name="prodid" class="form-control" id="last_name" required>
                            <%}else{%>
                                <input type="text" placeholder="Enter Product Id" name="prodid" class="form-control" id="last_name" required>
                            <%}%>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 text-center" style="margin-bottom: 5px;">
                            <a href="adminViewProduct.jsp" class="btn btn-info">Cancel</a>
                        </div>
                        
                        <div class="col-md-6 text-center">
                            <button type="submit" class="btn btn-danger">Remove</button>
                        </div>
                    </div>

                </form>
            </div>
        </div>
        <jsp:include page="footer.html"></jsp:include>
    </body>
</html>