<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

    <style>
        body {
            background-color: #E6F9E6;
        }

        .card {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0px 0px 15px rgba(0,0,0,0.1);
        }

        .product-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            display: none;
            margin: 10px auto;
            border: 0.5px solid green;
        }

        .product-upload-btn {
            display: block;
            width: 100%;
            margin-bottom: 15px;
        }

        .btn-group {
            display: flex;
            justify-content: space-between;
        }

        .btn-group a {
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>

<%
    String userName = (String)session.getAttribute("username");
    String password = (String)session.getAttribute("password");
    String userType = (String)session.getAttribute("usertype");

    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Access Denied, Please Login as an admin!");
        return;
    } else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Access Denied, Session Expired! Please Login again.");
        return;
    }
%>

<jsp:include page="header.jsp"></jsp:include>

<%
    String message = request.getParameter("message");
%>

<div class="card">
    <div class="text-center">
        <h2>Add Product</h2>
        <p>Enter product details below:</p>
        <% if (message != null) { %>
            <p style="color:red;"><%= message %></p>
        <% } %>
    </div>

    <form action="./AddProductSrv" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="productCategory">Category:</label>
            <select class="form-control" id="productCategory" name="productCategory" required>
                <option value="" disabled selected>Select category</option>
                <option value="mobile">Mobile</option>
                <option value="tv">TV</option>
                <option value="laptop">Laptop</option>
                <option value="camera">Camera</option>
                <option value="speaker">Speaker</option>
                <option value="tablet">Tablet</option>
                <option value="tablet">Others</option>
            </select>
        </div>

        <div id="productDetails" style="margin-top: 20px;">
            <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" class="form-control" id="productName" name="productName" placeholder="Enter product name" required>
            </div>

            <div class="form-group">
                <label for="productPrice">Price:</label>
                <input type="number" class="form-control" id="productPrice" name="productPrice" placeholder="Enter price" required>
            </div>

            <div class="form-group">
                <label for="productQuantity">Quantity:</label>
                <input type="number" class="form-control" id="productQuantity" name="productQuantity" placeholder="Enter quantity" required>
            </div>

            <div class="form-group">
                <label for="productDescription">Description:</label>
                <textarea class="form-control" id="productDescription" name="productDescription" rows="4" placeholder="Enter product description" required></textarea>
            </div>

            <div class="form-group">
                <label for="productImage">Product Image:</label>
                <input type="file" class="form-control product-upload-btn" id="productImageFile" name="productImage" accept="image/*" onchange="previewProduct(event)">
                <img src="" alt="Product Preview" class="product-preview" id="productPreview">
            </div>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn btn-success">Add Product</button>
            <button type="button" class="btn btn-danger"><a href="adminViewProduct.jsp">Cancel</a></button>
        </div>
    </form>
</div>

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

<jsp:include page="footer.html"></jsp:include>
</body>
</html>
