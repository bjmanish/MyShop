<%@page import="com.myshop.service.StaffService"%>
<%@page import="com.myshop.beans.StaffBean"%>
<%@page import="com.myshop.service.impl.StaffServiceImpl"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MYSHOP - STAFF PROFILE PAGE</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    </head>
    <body style="background-color: #E6F9E6"> 
        
        <%
//            Checking the User crendentials
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");
            System.out.println("userName: "+userName);
            if(userName == null|| password == null){
                response.sendRedirect("login.jsp?message= Session Expired! Please Login Again!!");
            }
            
            StaffService dao = new StaffServiceImpl();
            StaffBean staff = dao.getStaffDetails(userName, password);
            System.out.println(staff.getStaffId());
        %>

        <jsp:include page="header.jsp"/>
        <div class="container bg-secondary">
            
            <div class="row">
                <div class="col">
                    <nav class="bg-light rounded-3 p-3 mb-4" aria-label="breadcrumb" >
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Staff Profile</li>
                        </ol>
                    </nav>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-4">
                    <div class="card mb-4">
                        
                        <div class="card-header">
                            <i class="fa fa-user" style="margin-right: 10px; "></i>
                            <span style="margin-left: -5px; justify-content: center; align-items: center; font-size:larger; font-weight: bold;">Staff Profile</span>
                        </div>
                        
                        <div class="card-body text-center">
                            <img src="./showProfileImg?uid=<%=staff.getStaffId() %>" alt="<%=staff.getStaffName()%>" style="height: 150px; max-width: 180px;" >
                            <p class="username"><span style="color: crimson; font-size: 14px; font-weight: 700;">Hello</span>&nbsp;<%=staff.getStaffName()%></p>
                        </div>                        
                    </div>

                    <div class="card mb-4 mb-lg-0">
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush rounded-3">
                                <li class="list-group-item d-flex justify-content-between align-items-center p-3">
                                   
                                    <a href="#">My Profile</a> | 
                                    <a href="./orderDetails.jsp?uerId=<%=staff.getStaffId()%>">Orders</a> | 
                                    <a href="./orderDetails.jsp?uerId=<%=staff.getStaffId()%>">Transactions</a> | 
                                    <a href="#">Wallet</a> | 
                                    <a href="#">CashBack</a>
                                
                                </li>
                            </ul>
                        </div>
                    </div>

                </div>

                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Full Name</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="text-muted mb-0"><%= staff.getStaffName() %></p>
                                </div>
                            </div>
                            
                            <hr>

                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Email</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="mb-0"><%= staff.getStaffId()%></p>
                                </div>
                            </div>
                            <hr>
                            
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Phone</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="mb-0"><%= staff.getMobile() %></p>
                                </div>
                            </div>
                            <hr>
                            
                            
                        </div>
                    </div>
                </div>
            </div>        
        </div>
        <br><br><br>
        <jsp:include page="footer.html"></jsp:include>
    </body>
</html>