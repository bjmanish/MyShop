<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Product</title>

    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>

<body style="background-color:#E6F9E6;">

<%
    String username = (String)session.getAttribute("username");
    String password = (String)session.getAttribute("sessionId");
    String usertype = (String)session.getAttribute("role");

    if(usertype == null || !usertype.equalsIgnoreCase("admin")){
        response.sendRedirect("login.jsp?message=Access Denied!");
        return;
    }

    if(username == null || password == null){
        response.sendRedirect("login.jsp?message=Session Expired!");
        return;
    }

    String prodId = request.getParameter("prodid");
%>

<jsp:include page="/header.jsp" />

<div class="container">
    <div class="row" style="margin-top:40px;">

        <div class="col-md-4 col-md-offset-4"
             style="border:2px solid black; border-radius:10px; background:#FFE5CC; padding:15px;">

            <div class="text-center">
                <h2 style="color:seagreen;">Remove Product</h2>
                <p id="msgBox"></p>
            </div>

            <div class="form-group">
                <label>Product ID</label>
                <input type="text" id="prodid"
                       value="<%= prodId != null ? prodId : "" %>"
                       class="form-control" placeholder="Enter Product ID" required>
            </div>

            <div class="row">
                <div class="col-md-6 text-center">
                    <a href="adminViewProduct.jsp" class="btn btn-info">Cancel</a>
                </div>

                <div class="col-md-6 text-center">
                    <button onclick="removeProduct()" class="btn btn-danger">
                        Remove
                    </button>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/footer.html" />

<!-- 🔥 JAVASCRIPT -->
<script>
function removeProduct() {

    let prodId = document.getElementById("prodid").value.trim();
    let msgBox = document.getElementById("msgBox");

    if (!prodId) {
        msgBox.innerText = "Please enter Product ID!";
        msgBox.style.color = "red";
        return;
    }

    if (!confirm("Are you sure you want to delete this product?")) {
        return;
    }

    fetch("<%=request.getContextPath()%>/RemoveProductSrv", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "prodid=" + encodeURIComponent(prodId)
    })
    .then(res => res.text())
    .then(data => {

        if (data === "SUCCESS") {
            msgBox.innerText = "Product removed successfully!";
            msgBox.style.color = "green";

            setTimeout(() => {
                window.location.href = "adminViewProduct.jsp";
            }, 1500);

        } else {
            msgBox.innerText = "Failed to remove product!";
            msgBox.style.color = "red";
        }

    })
    .catch(err => {
        console.error(err);
        msgBox.innerText = "Server error!";
        msgBox.style.color = "red";
    });
}
</script>

</body>
</html>