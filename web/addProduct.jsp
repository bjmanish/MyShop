<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Product</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <!-- Add Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <style>
            .product-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            display: none;
            margin: 0 auto;
            border: 0.5px solid green;
        }

        .product-upload-btn {
            display: block;
            width: 100%;
            margin-bottom: 15px;
        }
        </style>
    </head>
    <body style="background-color: #E6F9E6;">
    
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
        
        <!-- Header -->
        <div class="container text-center" style="margin-top: 20px;">
            <% if (message != null) { %>
            <p style="color:red;"><%= message %></p>
            <% } %>
            <h2>Add Product</h2>
            <p>Enter product details below:</p>
        </div>

        <!-- Add Product Form -->
        <div class="container">
            <form action="./AddProductSrv" method="post" enctype="multipart/form-data">

                <div class="form-group" >
                    <label for="productCategory">Category:</label>
                    <select class="form-control productCategory" id="productCategory" name="productCategory" required>
                        <option value="" disabled selected>Select category</option>
                        <option value="mobile">Mobile</option>
                        <option value="tv">TV</option>
                        <option value="laptop">Laptop</option>
                        <option value="camera">Camera</option>
                        <option value="speaker">Speaker</option>
                        <option value="tablet">Tablet</option>
                    </select>
                </div>

                <div class="productDetails" id="productDetails" name="productDetails" style="display: block; margin-top: 30px;">
<!--                    <div class="form-group">
                        <label for="productId">Product ID:</label>
                        <input type="text" class="form-control" id="productId" name="productId" placeholder="Enter product ID" required>
                    </div>-->

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
                        <div style="display: flex; justify-content: center; align-items: center; gap: 10px;">
                            <input type="file" class="form-control product-upload-btn" id="productImageFile" name="productImage" accept="image/*" onchange="previewProduct(event)">
                            <img src="" alt="Product Preview" class="product-preview" id="productPreview">
                            <!-- <span><i class="fa fa-arrow-left" style="cursor: pointer;"></i></span>
                            
                            <img name="productImage" id="productImage" src="your-image-path.jpg" alt="Product Image" style="width: 200px; height: auto; border: 1px solid #ccc; border-radius: 5px;"> 
                            <span><i class="fa fa-arrow-right" style="cursor: pointer;"></i></span> -->
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-success">Add Product</button>
                <a href="adminViewProduct.jsp" class="btn btn-default">Cancel</a>
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
                preview.src = './images/default-product.png'; // Default image if no file selected
            }
        }
        </script>
        <jsp:include page="footer.html"></jsp:include>
    </body>
</html>
