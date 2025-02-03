<%@page import="java.util.ArrayList"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.beans.CartBean"%>
<%@page import="com.myshop.service.impl.CartServiceImpl"%>
<!DOCTYPE html>
<html>
    <head>
        <title>THE MYSHOP - Cart Details Page</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/main.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body style="background-color: #E6F9E6;">
        
        <!-- Checking user credentials -->
        
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
            
            String message = request.getParameter("message");
            
            String adds = request.getParameter("add");
            if(adds != null){
                
                int add = Integer.parseInt(adds);
                String uid = request.getParameter("uid");
                String pid = request.getParameter("pid");
                int avail = Integer.parseInt(request.getParameter("avail"));
                int cartQty = Integer.parseInt(request.getParameter("qty"));
                
                CartServiceImpl cart = new CartServiceImpl();
                if(add == 1){
                    //Add Product into the cart
                    cartQty +=1;
                    if(cartQty <= avail){
                        cart.addProductToCart(uid, 1, pid);
                    }else{
                        response.sendRedirect("./AddtoCart?pid=" + pid + "&pqty=" + cartQty);
                    }
                }else if(add == 0){
                    // Remove Product from cart
                    cart.removeProductFromCart(uid, pid);
                }
            }            
        %>
        
        <!-- get details to how many data will be add to cart -->

        <jsp:include page="header.jsp" ></jsp:include>
        <%if( message != null){%>
        <div class="text-center" style="color: red; font-weight: 500; font-size: 16px;"><p><%=message%></p></div>
        <%}%>
        <div class="text-center" style="color: darkslategray;">
            <h1>Cart Items</h1>
        </div>

        <!-- Start the product Item List -->
        <div class="container-fluid">
            
            <div class="table-responsive">
                
                <table class="table table-hover table-sm" >
                    <thead class="thead-dark  align-items-center" style="background-color: #2c6c4b; color: azure; font-size: 18px;">
                        <tr>
                            <th>Product Image</th>
                            <th>Products</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Add</th>
                            <th>Remove</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    
                    <tbody class="align-items-center" style="background-color: white; font-size: 15px; font-weight: bold;">
                        
                        <!-- get the cart product list from database -->
                        <%
                            CartServiceImpl carts = new CartServiceImpl();
                            List<CartBean> cartItems = new ArrayList<>();
                            cartItems = carts.getAllCartItems(userName);
                            //System.out.println("cart items:"+cartItems.toString());
                            double totalAmount = 0;
                                                       
                            for(CartBean item : cartItems){
                                
                                String prodId = item.getProdId();
                                int prodQty = item.getQuantity();    
                                ProductServiceImpl products = new ProductServiceImpl();
                                ProductBean product = products.getProductDetails(prodId);
                                //System.out.println("ProductBean Data: "+product);
                                double currAmount = product.getProdPrice() * prodQty;
                                totalAmount += currAmount ;
                                //System.out.println("Cart data - prodId: "+prodId+" prodQty: "+prodQty+" current Amount: "+currAmount+" totalamount: "+totalAmount+"");
                                if(prodQty > 0){
                                    
                                %>
                            <tr>
                                <td><img src="./ShowImage?pid=<%=product.getProdId() %>" width="50" height="50"></td>
                                <td><%=product.getProdName()%></td>
                                <td><%=product.getProdPrice()%></td>
                                <td>
                                    <form>
                                        <input type="number" name="pqty" value="<%=prodQty%>" min="1" max="10" style="max-width: 70px;">
                                        <input type="hidden" name="pid" value="<%=product.getProdId()%>">                                        
                                        <input type="submit" name="update" value="Update"style="max-width: 80px;">                                        
                                    </form>
                                </td>
                                <td><span><a href="cartDetails.jsp?add=1&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQty%>"><i class="fa fa-plus-square"></i></a></span></td>
                                <td><span><a href="cartDetails.jsp?add=0&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQty%>"><i class="fa fa-minus-square"></i></a></span></td>
                                <td><%=currAmount%></td>    
                                
                            </tr>
                            <%
                                }
                            }
                            %>
                        
                        
                            <tr style="background-color: grey; color: azure;">
                                <td colspan="6" style="text-align: center;">Total Amount to Pay (in Rupees)</td>
                                <td><%=totalAmount%></td>
                            </tr>
                        <%
                            if(totalAmount != 0){
                        %>
                        
                        <tr style="background-color: grey; color: white;">
                                <td colspan="4" style="text-align: center;"></td>
                                <td>
                                    <form method="post">
                                        <button formaction="userHome.jsp" style="background-color: black; color:white; ">Cancel</button>
                                    </form>
                                </td>
                                <td colspan='2' align='center'>
                                    <form method="post">
                                        <button formaction="payment.jsp?amount=<%=totalAmount%>" style="background-color: blueviolet; color:white;">Pay Now</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        
                    </tbody>

                </table>
            </div>
        </div>


        <jsp:include page="footer.html"></jsp:include>

    </body>
</html>