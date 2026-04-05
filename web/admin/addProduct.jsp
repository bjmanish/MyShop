<%@ page import="java.util.*,com.myshop.beans.ProductBean" %>

<%
    String userName = (String)session.getAttribute("username");
    String sId = (String)session.getAttribute("sessionId");
    String userType = (String)session.getAttribute("role");

    if (userType == null || !userType.equalsIgnoreCase("admin")) {
        response.sendRedirect("login.jsp?message=Access Denied, Please Login as an admin!");
        return;
    } else if (userName == null || sId == null) {
        response.sendRedirect("login.jsp?message=Access Denied, Session Expired! Please Login again.");
        return;
    }

    List<ProductBean> products = (List<ProductBean>) request.getAttribute("products");
    List<String> images = (List<String>) request.getAttribute("image");

    String importStatus = (String) request.getAttribute("importStatus");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>

    <link rel="stylesheet"
     href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <style>
        body { background:#E6F9E6; }
        .card { max-width:600px; margin:30px auto; padding:20px; background:#fff; }
        .product-preview { width:100px; height:100px; display:none; }
    </style>
</head>

<body>
    <jsp:include page="/header.jsp"></jsp:include>

<%
    String message = request.getParameter("message");
%>

<div class="container">

    <!-- ? IMPORT BUTTON -->
<!--    <div style="text-align:center; margin-bottom:20px;">
        <form action="/FetchProductSrv" method="get">
            <button class="btn btn-primary">
                Import Products from API
            </button>
        </form>
    </div>-->

    <!-- ? STATUS MESSAGE -->
    <% if (importStatus != null) { %>
        <p style="color:green;text-align:center;"><%= importStatus %></p>
    <% } %>

    <!-- ? MANUAL ADD FORM -->
<div class="card">
    <div class="text-center">
        <h2>Add Product</h2>
        <p>Enter product details below:</p>
        <% if (message != null) { %>
            <p style="color:red;"><%= message %></p>
        <% } %>
    </div>
        <h3>Add Product Manually</h3>

        <form action="<%=request.getContextPath()%>/AddProductSrv" method="post" enctype="multipart/form-data">

            <input type="text" name="productName" placeholder="Name" class="form-control" required><br>

            <input type="number" name="productPrice" placeholder="Price" class="form-control" required><br>

            <input type="number" name="productQuantity" placeholder="Quantity" class="form-control" required><br>

            <input type="text" name="productCategory" placeholder="Category" class="form-control" required><br>

            <textarea name="productDescription" class="form-control" placeholder="Description"></textarea><br>

            <input type="file" name="productImage" onchange="previewProduct(event)" class="form-control"><br>

            <!--<img id="preview" class="product-preview"/>-->
            <img src="" alt="Product Preview" class="product-preview" id="productPreview">

            <br>
            <button class="btn btn-success">Add Product</button>
        </form>
    </div>

    <!-- ? IMPORTED PRODUCTS VIEW -->
    <% if (products != null && products.size() > 0) { %>

    <h3>Imported Products</h3>

    <div class="row">

    <% for (int i = 0; i < products.size(); i++) { %>
        <div class="col-md-4">
            <div class="panel panel-default text-center">

                <img src="<%= images.get(i) %>" width="150">

                <h4><%= products.get(i).getProdName() %></h4>
                <p>? <%= products.get(i).getProdPrice() %></p>
                <p><%= products.get(i).getProdType() %></p>

            </div>
        </div>
    <% } %>

    </div>

    <% } %>

</div>

<script>
function preview(e){
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onload = function(){
        document.getElementById("preview").src = reader.result;
        document.getElementById("preview").style.display="block";
    };
    reader.readAsDataURL(file);
}
</script>
<script>
    function previewProduct(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('productPreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = '';
            preview.style.display = 'none';
        }
    }
</script>

<jsp:include page="/footer.html" />
</body>
</html>