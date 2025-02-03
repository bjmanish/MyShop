<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>

<html>
    <head>
        <title>THE MYSHOP</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/main.css">
        <script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6;">
        
        <%
//        Checking the USer credentials
            String userName = (String) session.getAttribute("username");
            String password = (String) session.getAttribute("password");
            String userType = (String) session.getAttribute("usertype");
            
            boolean isValidUser = true;
            if(userType == null || userName == null || password == null || !userType.equals("customer") ){
                isValidUser = false ;
            }
            
            ProductServiceImpl prodDao = new ProductServiceImpl();
            List<ProductBean> products = new ArrayList<>();
            
            String search = request.getParameter("search");
            String type =  request.getParameter("type");
            String message = "All Products" ;
            if(search != null){
                products = prodDao.searchAllProducts(search);
                message = "SHowing Result for '" + search +"'";
            }else if(type != null){
                products = prodDao.getAllProductsByType(type);
                message = "SHowing Result for '" + type +"'";
            }else{
                products = prodDao.getAllProducts();
            }
            if(products.isEmpty()){
                message = "No items found for the search ' " + (search != null ? search : type ) + "' ";
                prodDao.getAllProducts();
            }            
        %>
        
        <!-- Adding header page -->
        <jsp:include page="header.jsp" />

        <div class="text-center" style="color: black; font-size:14px; font-weight: bold;"><%=message%></div>
        <div class="text-center" id="message" style="color: black; font-size:14px; font-weight: bold;"></div>

        <!-- Start of product Item List -->
        <div class="container">
           <div class="row text-center">
                <%
                for(ProductBean product : products){
                    int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
               
               %> 
               <div class="col-sm-4" style="height: 350px; margin-bottom: 30px;">
                    <div class="thumbnail">
                        <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;" >
                        <p class="productname"><%=product.getProdName()%></p>
                        
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
                        <p class="price">Rs <%=product.getProdPrice()%></p>

                        <form action="" method="post">
                            <!-- java code for cart checking -->
                             <%
                                if (cartQty == 0) {
                            %> 
                            <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" class="btn btn-success">Add To Cart</button>
                            &nbsp;&nbsp;&nbsp;
                            <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-primary">Buy Now</button>
                             <% }
                                else{
                             %> 
                            <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" class="btn btn-danger">Remove From Cart</button>
                            &nbsp;&nbsp;&nbsp;
                            <button type="submit" formaction="cartDetails.jsp" class="btn btn-success">Checkout</button>
                            <%
				}
                            %> 
                        </form>
                        <br />
                    </div>
               </div>
                <%
                    }
		%> 
            </div>
        </div>
        <!-- End of product item list -->

        <%@ include file="footer.html" %>
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
