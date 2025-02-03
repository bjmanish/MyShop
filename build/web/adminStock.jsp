<%@page import="com.myshop.service.impl.OrderServiceImpl"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>The MYSHOP - Product Stock </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
       <link rel="stylesheet" href="css/main.css">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6;">
        <!-- checking user crendentials java code -->
        
        <jsp:include page="header.jsp"></jsp:include>
        
        <div class="text-center" style="color: green; font-size: 24px; font-weight: bold;">Stock Products</div>

        <div class="container-fluid">
            
            <div class="table-responsive">
                
                <table class="table table-hover table-sm">
                    <thead class="thead-dark" style="background-color: #2c6c4b; color: azure; font-size: 18px;">
                        <tr>
                            <th>Product Image</th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Product Category/Type</th>
                            <th>Product Price</th>
                            <th>Sold Product Quantity</th>
                            <th>Stock Product Quantity</th>
                            <th colspan="2" style="text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    
                    <tbody>
                        <%
                        // get the product list from database
                        ProductServiceImpl productDAO = new ProductServiceImpl();
                        List <ProductBean> products = productDAO.getAllProducts();
                        for(ProductBean product : products){
                        %>
                            <tr>
                                <td><img src="./ShowImage?pid=<%=product.getProdId()%>" width="50" height="50"></td>
                                    
                                <td><a href="./updateProduct.jsp?prodid=<%=product.getProdId()%>"><%=product.getProdId()%></a></td>
                                 <% 
                                    String prodName = product.getProdName();
                                    String name = prodName.substring(0, Math.min(prodName.length(), 25))+ "..";
                                 %>   
                                <td><%=name%></td>
                                    
                                <td><%=product.getProdType().toUpperCase()%></td>
                                    
                                <td><%=product.getProdPrice()%></td>
                                    
                                <td><%=new OrderServiceImpl().countSoldItem(product.getProdId())%></td>
                                
                                <td><%=product.getProdQuantity()%></td>
                                    
                                <td >
                                    <a href="updateProduct.jsp?prodid=<%=product.getProdId()%>" style="color: #007bff; margin-right:  10px; ">Update</a>
                                    <a href="./RemoveProductSrv?prodid=<%=product.getProdId()%>" style="color: red; margin-left:  10px; ">Remove</a>
                                </td>
                            </tr>
                        <%
                        }
                        if(products.size() == 0){
                        %>
                            <tr style="background-color: grey; color: azure;">
                                <td colspan="7" style="text-align: center;">
                                    No Items Available
                                </td>
                            </tr>
                        <%}%>
                    </tbody>

                </table>
            </div>
        </div>

        <jsp:include page="footer.html"></jsp:include>
    </body>
</html>
