<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
    <head>
        <title>View Products</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/main.css">
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6;">

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	String userType = (String) session.getAttribute("usertype");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else {
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}
	%>



	<jsp:include page="header.jsp" />

	<div class="text-center" style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
	<!-- Start of Product Items List -->
	<div class="container" style="background-color: #E6F9E6;">
            <div class="row text-center">

		<%
		for (ProductBean product : products) {
		%>
                    <div class="col-sm-4" style='height: 350px; margin-bottom: 10px;'>
			<div class="thumbnail">
                            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                            <p class="productname"><%=product.getProdName()%><span style="color:green; font-weight: 400;"> &LeftAngleBracket; <%=product.getProdId()%> &RightAngleBracket;</span></p>
                            <%-- Product Description Java Code --%>
                            <%
                            String description = product.getProdInfo();
                            String shortDescription = description.substring(0, Math.min(description.length(), 100));
                            %>
                            <p class="productinfo">
                            <span class="short-description"><%= shortDescription %></span>
                                <% if (description.length() > 100) { %>
                                <span class="full-description" style="display: none;"><%= description %></span>
                                <a href="#" class="read-more" onclick="toggleDescription(this); return false;" style="color: #007bff;font-weight: 800;">Read More..</a>
                                <% } %>
                            </p>
                            <p class="price">Rs. <%=product.getProdPrice()%></p>
                            <form method="post">
				<button type="submit" formaction="removeProduct.jsp?prodid=<%=product.getProdId()%>" name="prodid" class="btn btn-danger">Remove Product</button>
                                &nbsp;&nbsp;&nbsp;
				<button type="submit" formaction="updateProductById.jsp?prodid=<%=product.getProdId()%>" name="prodid" class="btn btn-primary">Update Product</button>
                            </form>
			</div>
                    </div>

		<%}%>

            </div>
	</div>
	<!-- ENd of Product Items List -->

	<%@ include file="footer.html"%>
        <script>
            function toggleDescription(link){
            var parent = link.parentElement;
            var shortDesc = parent.querySelector('.short-description');
            var fullDesc = parent.querySelector('.full-description');
            
            if(shortDesc.style.display === 'none'){
                shortDesc.style.display = 'inline';
                fullDesc.style.display = 'none';
                link.innerText = 'Read More..';
                
            }else{
                shortDesc.style.display = 'none';
                fullDesc.style.display = 'inline';
                link.innerText = 'Read less';
                //link.style.color = '#';
            }
            
            }
        
        </script>
    </body>
</html>