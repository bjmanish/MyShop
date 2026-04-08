<%@page import="com.myshop.beans.UserBean"%>
<%@page import="com.myshop.service.UserService"%>
<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MYSHOP - USER PROFILE PAGE</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    </head>
    <body> 
        
        <%
//            Checking the User crendentials
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("sessionId");
            if(userName == null|| password == null){
                response.sendRedirect("login.jsp?message= Session Expired! Please Login Again!!");
            }
            
            UserService dao = new UserServiceImpl();
            UserBean user = dao.getUserDetails(userName, password);
//            System.out.println("USER: "+user.toString());
        %>

        <jsp:include page="/header.jsp"/>
        <div class="mt-4 pt-5">
            <div class="mt-4 pt-5"></div>
        </div>
        <div class="container ">
            
            <div class="row">
                <div class="col">
                    <nav class="bg-light rounded-3 p-3 mb-4" aria-label="breadcrumb" >
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/user/userHome.jsp">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">User Profile</li>
                        </ol>
                    </nav>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-4">
                    <div class="card mb-4">
                        
                        <div class="card-header">
                            <i class="fa fa-user" style="margin-right: 10px; "></i>
                            <!--<bold>User Profile</bold>-->
                            <span style="margin-left: -5px; justify-content: center; align-items: center; font-size:larger; font-weight: bold;">User Profile</span>                          
                        </div>

                        <div class="card-body text-center position-relative">
                            <!-- Profile Image -->
                            <div style="position: relative; display: inline-block;">
                                <img id="profileImg" src="<%=request.getContextPath()%>/showProfileImg?uid=<%=(String)session.getAttribute("user_id") %>" 
                                     alt="Profile Image"
                                     style="height: 150px; width: 150px; border-radius: 50%; object-fit: cover;"
                                     onerror="this.src='../images/noimage.jpg';">
                                
                                <!-- ?? Edit Button -->
                                <label for="fileInput" 
                                       style="position: absolute; bottom: 5px; right: 5px; 
                                       background: #fff; border-radius: 50%; 
                                       padding: 6px; cursor: pointer; 
                                       box-shadow: 0 2px 6px rgba(0,0,0,0.2);">
                                    <i class="bi bi-pencil-fill"></i>
                                </label>
                                
                                <!-- Hidden File Input -->
                                <form id="uploadForm" action="<%=request.getContextPath()%>/UploadProfileImage" method="post" enctype="multipart/form-data">
                                    <input type="file" id="fileInput" name="profileImg" accept="image/*" hidden onchange="uploadImage()">
                                </form>
                            </div>
                            <!-- Username -->
                            <p class="fw-bold mt-3" style="font-size: 20px; color:#009966;">
                                <span style="color:#000;">Hello</span> <%=user.getName()%>
                            </p>
                        </div>
                    </div>

                    <div class="card mb-4 mb-lg-4">
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush rounded-3">
                                <li class="list-group-item d-flex justify-content-between align-items-center p-3">
                                   
                                    <a href="#">My Profile</a> | 
                                    <a href="./orderDetails.jsp?uerId=<%=user.getEmail()%>">Orders</a> | 
                                    <a href="./orderDetails.jsp?uerId=<%=user.getEmail()%>">Transactions</a> | 
                                    <a href="#">Wallet</a> | 
                                    <a href="#">CashBack</a>
                                
                                </li>
                            </ul>
                        </div>
                    </div>

                </div>

                <div class="col-4 justify-content-center align-middle">
                    <div class="card mb-4">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Full Name</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="text-muted mb-0"><%= user.getName() %></p>
                                </div>
                            </div>
                            
                            <hr>

                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Email</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="mb-0">
                                        <%= user.getEmail()%>
                                        <% if(user.getEmailVerified() == 1) { %>
                                            <span style="color:green; font-weight:bold;">(Verified)</span>
                                        <% } else { 
                                                session.setAttribute("email", user.getEmail());
//                                                System.out.println("email from userProfile: "+ user.getEmail());
                                        %>                                            
                                            <span style="color:red; font-weight:bold;">(Not Verified)</span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            <hr>
                            
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Phone</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="mb-0">
                                    <%= user.getMobile() %>
                                    <% if(user.getMobileVerified() == 1) { %>
                                        <span style="color:green; font-weight:bold;">(Verified)</span>
                                    <% } else {
                                            session.setAttribute("mobile", user.getMobile());
                                            session.setAttribute("email", user.getEmail());
//                                                System.out.println("email from userProfile: "+ user.getEmail());
                                            
                                    %>
                                        <a href="#" style="text-decoration: none;" onclick="joinAndSendOtp()">
                                            <span style="color:red; font-weight:bold;">(Not Verified)</span>
                                        </a>
                                                                               
                                    <% } %>
                                    </p>
                                </div>

                            </div>
                            <hr>
                            
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Address</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="mb-0"><%= user.getAddress() %></p>
                                </div>
                            </div>
                            <hr>

                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Pincode</p>
                                </div>
                                <div class="col-sm-9">
                                    <p class="mb-0"><%= user.getPincode() %></p>
                                </div>
                            </div>                           

                        </div>
                    </div>
                </div>
            </div>        
        </div>
        <br><br><br>
        <jsp:include page="/footer.html"></jsp:include>
        
        <script>
            function joinAndSendOtp() {
                // 1?? Open WhatsApp sandbox join link
                window.open("https://wa.me/+14155238886?text=join%20difficult-glass", "_blank");
                // 2?? After 5 seconds, redirect to your OTP servlet
                setTimeout(function() { window.location.href = "SendOTPSrv";}, 5000);
            }
            

function uploadImage() {
    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];

    if (!file) return;

    // ? Preview instantly
    const reader = new FileReader();
    reader.onload = function(e) {
        document.getElementById("profileImg").src = e.target.result;
    };
    reader.readAsDataURL(file);

    // ? Upload to server
    const formData = new FormData();
    formData.append("profileImg", file);

    fetch("<%=request.getContextPath()%>/UploadProfileImage", {
        method: "POST",
        body: formData
    })
    .then(res => res.text())
    .then(data => {
        console.log("Upload:", data);
        // Optional success alert
    })
    .catch(err => {
        console.error(err);
        alert("Upload failed");
    });
}
</script>
            
        
    </body>
</html>