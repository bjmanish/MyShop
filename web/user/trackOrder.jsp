<%@ page import="java.sql.*" %>
<%@ page import="com.myshop.utility.dbUtil" %>

<%
String orderId = request.getParameter("orderId");

Connection con = dbUtil.provideConnection();

// Get all statuses
PreparedStatement ps = con.prepareStatement(
    "SELECT status, FORMAT(status_time,'dd:MM:yyyy HH:mm:ss') as time FROM ORDER_STATUS_HISTORY WHERE order_id=? ORDER BY status_time"
);
ps.setString(1, orderId);

ResultSet rs = ps.executeQuery();

java.util.List<String> statusList = new java.util.ArrayList<>();
java.util.Map<String,String> timeMap = new java.util.HashMap<>();

while(rs.next()){
    String s = rs.getString("status");
    statusList.add(s);
    timeMap.put(s, rs.getString("time"));
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Track Order</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
body{
    background: linear-gradient(135deg,#1d2671,#c33764);
    color:white;
}

/* Card */
.track-box{
    max-width:800px;
    margin:50px auto;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(20px);
    padding:30px;
    border-radius:20px;
}

/* Progress */
.progress-track{
    display:flex;
    justify-content:space-between;
    position:relative;
    margin:40px 0;
}

.progress-track::before{
    content:"";
    position:absolute;
    top:20px;
    left:0;
    width:100%;
    height:5px;
    background:#444;
}

.step{
    text-align:center;
    z-index:1;
}

.circle{
    width:40px;
    height:40px;
    border-radius:50%;
    background:#666;
    line-height:40px;
}

.active{
    background:#00ff88;
    color:black;
}

/* Timeline */
.timeline{
    margin-top:30px;
    text-align:left;
}

.timeline-item{
    padding:10px;
    border-left:3px solid #00ff88;
    margin-bottom:10px;
}
/* Back Button */
.back-btn {
    position: absolute;
    top: 20px;
    left: 20px;
    color: crimson;
    font-weight: 400;
}
</style>
</head>

<body>

<div class="track-box">
<a onclick="window.location.href='userHome.jsp'" class="btn btn-sm-light shadow-sm back-btn"><i class="bi bi-arrow-left"></i> Back</a>
<h4 class="text-center"><i class="bi bi-truck"></i> Order Tracking</h4>
<p class="text-center">Order ID: <b><%=orderId%></b></p>

<!-- ? PROGRESS BAR -->
<div class="progress-track">

<%
String[] steps = {"PLACED","CONFIRMED","SHIPPED","OUT_FOR_DELIVERY","DELIVERED"};

for(int i=0;i<steps.length;i++){
    boolean active = statusList.contains(steps[i]);
%>

<div class="step">
    <div class="circle <%=active?"active":""%>">
        <% if(active){ %>
                <i class="bi bi-check"></i>
        <% } else { %>
                <%= (i+1) %>
        <% } %>
    </div>
    <small><%=steps[i]%></small>
</div>

<% } %>

</div>

<!-- ? TIMELINE -->
<div class="timeline">

<%
for(String s : statusList){
%>

<div class="timeline-item">
    <b><%=s%></b> - <%=timeMap.get(s)%>
</div>

<% } %>

</div>

</div>

<!-- ? AUTO REFRESH -->
<script>
setInterval(()=>{
    location.reload();
},10000); // refresh every 5 sec
</script>

</body>
</html>