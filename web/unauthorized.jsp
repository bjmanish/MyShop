<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Unauthorized Access</title>

    <style>
        body {
            font-family: Arial;
            /*background: #f8f9fa;*/
             background: linear-gradient(135deg, #141e30, #243b55);
            text-align: center;
            padding-top: 100px;
        }

        .box {
            background: white;
            padding: 40px;
            margin: 20px auto;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }

        h1 {
            color: red;
        }

        a {
            text-decoration: none;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border-radius: 5px;
            /*margin-bottom: 20px;*/
        }
        a:hover {
            background: #009966;
        }
        .log:hover{
            background: #ff0000;
        }
    </style>
</head>

<body>

<div class="box">
    <h1>403</h1>
    <h2>Access Denied 🚫</h2>

    <p>You do not have permission to access this page.</p>

    <%
        String role = (String) session.getAttribute("role");
        if ("ADMIN".equalsIgnoreCase(role)) {
    %>
        <a href="admin/adminHome.jsp">Go to Dashboard</a>
    <%
        } else if("CUSTOMER".equalsIgnoreCase(role)) {
    %>
        <a href="user/userHome.jsp">Go to Home</a>
    <%
        }else if("DELIVERY".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role)){
    %>
        <a href="staff/staffHome.jsp">Go to Home</a>
    <%
        }else{
    %>
        <a href="<%=request.getContextPath()%>/">Go to Home</a>
    <%}%>
    
    <div><br/><br/></div>
    <a href="<%=request.getContextPath()%>/LogoutSrv" class="log">Logout</a>
</div>

</body>
</html>