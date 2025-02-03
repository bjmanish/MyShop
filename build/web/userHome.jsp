<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<!DOCTYPE html>
<html>
    <head>
        <title>THE MYSHOP - USER HOME PAGE</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<!--        <link rel="stylesheet" href="css/main.css">-->
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6;">
        
        <jsp:include page="header.jsp"></jsp:include>
        
        <% 
            String userName = (String)session.getAttribute("username");
            String password = (String)session.getAttribute("password");
            String userType = (String)session.getAttribute("usertype");
            
            if (userType == null || !userType.equalsIgnoreCase("customer")) {
                response.sendRedirect("login.jsp?error=access_denied");
                return;
            }
            if (userName == null || password == null) {
                response.sendRedirect("login.jsp?error=session_expired");
                return;
            }
            
            ProductServiceImpl productDAO = new ProductServiceImpl();
            List <ProductBean> products  = new ArrayList<>();
            String search = request.getParameter("search");
            String type = request.getParameter("type");
            String message = "Showing All Products";

            if(search != null){
                products = productDAO.searchAllProducts(search);
                message = "Showing Result for '"+search+"' ";
            }else if(type != null){
                products = productDAO.getAllProductsByType(type);
                message = "Showing Result for '"+type+"' ";
            }else{
                products = productDAO.getAllProducts();
            }
            
            if(products.isEmpty()){
                message = "No Items Found For The Search '"+(search != null ? search : type)+"' ";
                products = productDAO.getAllProducts();
            }

        %>
        

	<div class="text-center" style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
<!--	<script>document.getElementById('mycart').innerHTML='<i data-count="20" class="fa fa-shopping-cart fa-3x icon-white badge" style="background-color:#333;margin:0px;padding:0px; margin-top:5px;"></i>'</script>-->
 
	<!-- Start of Product Items List -->
	<div class="container" >
            <div class="row text-center">
                <%
                    for(ProductBean product : products){
                        int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
                    
                %>    
                
                <div class="col-sm-4" style='height: 350px;'>
                    
                    <div class="thumbnail">
			<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                        <p class="productname"><%=product.getProdName()%><span style="color:green; font-weight: 700;"> &LeftAngleBracket; <%=product.getProdId()%> &RightAngleBracket;</span></p>
			
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
                        <p class="price">Rs <%=product.getProdPrice() %></p>
                        <form action="" method="post">
                            <!-- if code cartQuantity -->
                            <%if(cartQty == 0 ){%>
                         
                            <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"  class="btn btn-success">Add to Cart</button>
                            &nbsp;&nbsp;&nbsp;
                            <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-primary">Buy Now</button>
                        
                            <%}else{%>
                            <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"  class="btn btn-danger">Remove From Cart</button>
                            &nbsp;&nbsp;&nbsp;
                            <button type="submit" formaction="./cartDetails.jsp"  class="btn btn-success">Checkout</button>
                        <%}%>
                        </form>
                        <br/>
                    </div>
                </div>
                <%}%>
            </div>
        </div>
        <!-- End of product item list -->
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
        
    </boby>
</html>