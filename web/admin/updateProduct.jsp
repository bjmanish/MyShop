<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>

<%
String prodid = request.getParameter("pid");
ProductBean product = new ProductServiceImpl().getProductDetails(prodid);

if (prodid == null || product == null) {
    response.sendRedirect("updateProductById.jsp?message=Invalid Product");
    return;
}
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Update Product</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min"></script>
        
          <style>
        body {background: linear-gradient(135deg, #1d2671, #c33764);}
        /* GLASS CARD */.product-card { background: rgba(255,255,255,0.1); backdrop-filter: blur(15px);border-radius: 15px;color: white;transition: 0.3s;}
        .product-card:hover {transform: translateY(-5px);box-shadow: 0 10px 30px rgba(0,0,0,0.3);}
        /* IMAGE */.product-img {height: 180px;object-fit: contain;border-radius: 50%;}
        /* BUTTONS */ .btn-custom {border-radius: 25px;font-weight: 500;}
        /* TEXT */.card-title {font-size: 14px;}
        .price { color:#28a745; font-weight:bold; }
        .old-price { text-decoration: line-through; color:gray; font-size:13px; }
        .discount { color:green; font-size:13px; }
    </style>
        
        
    </head>

    <body>
    
    <jsp:include page="/header.jsp"/>

<div class="container">

    <!-- 🔥 IMAGE SECTION (AJAX UPLOAD) -->
    <div class="text-center" style="margin:20px;">
        
        <img id="productImg"
             src="<%=request.getContextPath()%>/ShowImage?pid=<%=product.getProdId()%>&t=<%=System.currentTimeMillis()%>"
             height="120"
             style="border-radius:10px;"
             onerror="this.src='<%=request.getContextPath()%>/images/noimage.jpg';"/>

        <br><br>

        <input type="hidden" id="pid" value="<%=product.getProdId()%>">

        <input type="file" id="imageInput" class="form-control" style="width:250px; margin:auto;">
        
        <br>

        <button type="button" onclick="uploadImage()" class="btn btn-primary">
            Upload Image
        </button>
    </div>

    <!-- 🔥 NORMAL FORM -->
    <form action="<%=request.getContextPath()%>/UpdateProductSrv" method="post"
          class="col-md-6 col-md-offset-3"
          style="background:#FFE5CC; padding:15px; border-radius:10px;">

        <input type="hidden" name="pid" value="<%=product.getProdId()%>">

        <div class="form-group">
            <label>Name</label>
            <input type="text" name="name" class="form-control"
                   value="<%=product.getProdName()%>" required>
        </div>

        <div class="form-group">
            <label>Type</label>
            <select name="type" class="form-control">
                <option value="mobile" <%= "mobile".equalsIgnoreCase(product.getProdType())?"selected":"" %>>MOBILE</option>
                <option value="tv" <%= "tv".equalsIgnoreCase(product.getProdType())?"selected":"" %>>TV</option>
                <option value="camera" <%= "camera".equalsIgnoreCase(product.getProdType())?"selected":"" %>>CAMERA</option>
                <option value="laptop" <%= "laptop".equalsIgnoreCase(product.getProdType())?"selected":"" %>>LAPTOP</option>
                <option value="tablet" <%= "tablet".equalsIgnoreCase(product.getProdType())?"selected":"" %>>TABLET</option>
                <option value="speaker" <%= "speaker".equalsIgnoreCase(product.getProdType())?"selected":"" %>>SPEAKER</option>
                <option value="other" <%= "other".equalsIgnoreCase(product.getProdType())?"selected":"" %>>OTHER</option>
            </select>
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="info" class="form-control"><%=product.getProdInfo()%></textarea>
        </div>

        <div class="form-group">
            <label>Price</label>
            <input type="number" name="price" class="form-control"
                   value="<%=product.getProdPrice()%>" required>
        </div>

        <div class="form-group">
            <label>Quantity</label>
            <input type="number" name="quantity" class="form-control"
                   value="<%=product.getProdQuantity()%>" required>
        </div>

        <div class="text-center">
            <a href="adminViewProduct.jsp" class="btn btn-danger">Cancel</a>
            <button type="submit" class="btn btn-success">Update Product</button>
        </div>

    </form>

</div>

<!-- 🔥 JAVASCRIPT -->
<script>
function uploadImage() {

    let fileInput = document.getElementById("imageInput");
    let pid = document.getElementById("pid").value;

    if (fileInput.files.length === 0) {
        alert("Select image first!");
        return;
    }

    let formData = new FormData();
    formData.append("image", fileInput.files[0]);
    formData.append("pid", pid);

    fetch("<%=request.getContextPath()%>/UpdateProductImageSrv", {
        method: "POST",
        body: formData
    })
    .then(res => res.text())
    .then(data => {

        if(data === "SUCCESS"){
            alert("Image Updated!");

            // refresh image
            document.getElementById("productImg").src =
                "<%=request.getContextPath()%>/ShowImage?pid=" + pid + "&t=" + new Date().getTime();
        } else {
            alert("Upload Failed");
        }

    })
    .catch(err => {
        console.error(err);
        alert("Error uploading image");
    });
}
</script>
    
 <jsp:include page="/footer.html"/>
</body>
</html>