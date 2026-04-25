<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.myshop.beans.OrderDetails"%>
<%@page import="java.util.*"%>
<%@page import="com.myshop.service.impl.OrderServiceImpl"%>

<!DOCTYPE html>
<html>
<head>
<title>My Orders - MyShop</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">-->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
body{
    padding-top:100px;
    background:#f5f5f5;
}

/* Card */
.order-card{
    background:white;
    padding:20px;
    border-radius:12px;
    margin-bottom:20px;
    box-shadow:0 5px 20px rgba(0,0,0,0.1);
}

/* Image */
.order-img{
    width:100px;
    height:100px;
    object-fit:contain;
}

/* Status */
.status-PLACED{background:#f0ad4e;color:white;padding:5px 10px;border-radius:5px;}
.status-CONFIRMED{background:#5bc0de;color:white;padding:5px 10px;border-radius:5px;}
.status-SHIPPED{background:#337ab7;color:white;padding:5px 10px;border-radius:5px;}
.status-OUT_FOR_DELIVERY{background:#5bc0de;color:white;padding:5px 10px;border-radius:5px;}
.status-DELIVERED{background:#5cb85c;color:white;padding:5px 10px;border-radius:5px;}
.status-CANCELLED{background:#d9534f;color:white;padding:5px 10px;border-radius:5px;}

/* Mini Progress */
.mini-progress{
    display:flex;
    justify-content:space-between;
    margin-top:15px;
}

.mini-step{
    text-align:center;
    flex:1;
}

.mini-circle{
    width:25px;
    height:25px;
    border-radius:50%;
    background:#ccc;
    margin:auto;
    line-height:25px;
    font-size:12px;
}

.mini-circle.done{
    background:#28a745;
    color:white;
}

/* ? Animated Bar */
.progress-bar-container{
    margin-top:15px;
}

.progress-line{
    width:100%;
    height:6px;
    background:#ddd;
    position:relative;
    border-radius:5px;
}

.progress-fill{
    height:6px;
    background:#28a745;
    border-radius:5px;
    transition:width 0.5s ease;
}

.truck{
    position:absolute;
    top:-18px;
    font-size:20px;
    color:#007bff;
    transition:left 0.5s ease;
}

/* Rating */
.rating-box span{
    font-size:20px;
    cursor:pointer;
    color:#ccc;
}
.rating-box span:hover{
    color:gold;
}
</style>

</head>

<body>

<jsp:include page="/header.jsp"></jsp:include>

<%
String userName = (String)session.getAttribute("user_id");
if(userName == null){
    response.sendRedirect("login.jsp");
}

OrderServiceImpl dao = new OrderServiceImpl();
List<OrderDetails> orders = dao.getAllOrderDetails(userName);

SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
%>

<div class="container">

<h2 class="text-center"><i class="bi bi-box-seam"></i> My Orders</h2>

<%
for(OrderDetails order : orders){

    String status = order.getStatus();
    String[] steps = {"PLACED","CONFIRMED","SHIPPED","OUT_FOR_DELIVERY","DELIVERED"};

    int currentIndex = Arrays.asList(steps).indexOf(status);
%>

<div class="order-card text-lg">

<div class="row">

<!-- IMAGE -->
<div class="col-md-2 text-center">
    <img src="<%=request.getContextPath()%>/ShowImage?pid=<%=order.getProdId()%>" class="order-img">
</div>

<!-- DETAILS -->
<div class="col-md-6">
    <h4><%=order.getProdName()%></h4>

    <p><b>Order ID:</b> <%=order.getOrderId()%></p>
    <p><b>Quantity:</b> <%=order.getQnty()%></p>
    <p><b>Amount:</b> &#x20B9; <%=order.getAmount()%></p>

    <p>
        <b>Order Date:</b> <%=sdf.format(order.getDatetime())%><br>
        <b>Delivery Date:</b> <%=sdf.format(order.getDeliveryDate())%>
    </p>
</div>

<!-- STATUS -->
<div class="col-md-4 text-center">

<h4>
<span class="status-<%=status%>"><%=status%></span>
</h4>

<br>
<br/>
<!--<h4>-->
<a href="trackOrder.jsp?orderId=<%=order.getOrderId()%>" 
   class="btn btn-primary btn"><i class="bi bi-truck" ></i> Track</a>
   <!--</h4>-->
<br><br>

<% if(status.equals("PLACED") || status.equals("CONFIRMED")){ %>
<button class="btn btn-danger btn-sm"
        onclick="cancelOrder('<%=order.getOrderId()%>')">
    ? Cancel
</button>
<% } %>

</div>

</div>

<!-- MINI PROGRESS -->
<div class="mini-progress">

<%
for(int i=0;i<steps.length;i++){
    boolean done = i <= currentIndex;
%>

<div class="mini-step">
    <div class="mini-circle <%=done?"done":""%>">
        <% if(done){ %><i class="bi bi-check"></i><% } else { %><%=i+1%><% } %>
    </div>
    <small><%=steps[i]%></small>
</div>

<% } %>

</div>

<!-- ? ANIMATED BAR -->
<div class="progress-bar-container">

<div class="progress-line">
    <div class="progress-fill" style="width:<%=(currentIndex+1)*20%>%"></div>

    <div class="truck" style="left:<%=currentIndex*20%>%">
        <i class="bi bi-truck"></i>
    </div>
</div>

</div>

<!-- RATING -->
<% if(status.equals("DELIVERED")){ %>
<div class="rating-box text-center" style="margin-top:10px;">
    <p>Rate Product:</p>
    <span onclick="rate('<%=order.getProdId()%>',1)">?</span>
    <span onclick="rate('<%=order.getProdId()%>',2)">?</span>
    <span onclick="rate('<%=order.getProdId()%>',3)">?</span>
    <span onclick="rate('<%=order.getProdId()%>',4)">?</span>
    <span onclick="rate('<%=order.getProdId()%>',5)">?</span>
</div>
<% } %>

</div>

<% } %>

</div>

<script>

// ? Cancel Order (SweetAlert)
function cancelOrder(orderId){

    Swal.fire({
        title:"Cancel Order?",
        icon:"warning",
        showCancelButton:true
    }).then(res=>{
        if(res.isConfirmed){

            fetch("CancelOrderSrv",{
                method:"POST",
                headers:{"Content-Type":"application/x-www-form-urlencoded"},
                body:"orderId="+orderId
            })
            .then(res=>res.json())
            .then(res=>{
                if(res.status==="success"){
                    Swal.fire("Cancelled","Order cancelled","success");
                    location.reload();
                }
            });
        }
    });
}

// ? Rating
function rate(pid, stars){

    fetch("RateProductSrv",{
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"pid="+pid+"&rating="+stars
    })
    .then(res=>res.json())
    .then(res=>{
        if(res.status==="success"){
            Swal.fire("Thanks!","Rating submitted ?","success");
        }
    });
}

// ? OPTIONAL AUTO REFRESH
// setInterval(()=>{ location.reload(); },10000);

</script>

<jsp:include page="/footer.html"></jsp:include>

</body>
</html>