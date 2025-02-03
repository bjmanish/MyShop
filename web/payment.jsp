<!DOCTYPE html >
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>The MYSHOP - Payment Page</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
       <!-- <link rel="stylesheet" href="./css/main.css"> -->
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: #E6F9E6 ;">
<!--         Checking the user credentials -->
        <%
            String userName = (String) session.getAttribute("username");
            String password = (String) session.getAttribute("password");

            if (userName == null || password == null){ 
		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            }
            
            String sAmount = request.getParameter("amount");
            double amount = 0;
            if( sAmount != null)
                amount = Double.parseDouble(sAmount);
        %>
        <jsp:include page="header.jsp" ></jsp:include>

        <div class="container">
            <div class="row" style="margin: 5px 2px;">
                
                <form action="./OrderSrv" method="post" class="col-md-6 col-md-offset-3" 
                style="border: 1px solid black; border-radius: 10px; background: #FFE5CC;padding: 10px; ">
                    <!-- <div class="text-center"> -->
                        
                        <div class="form-group text-center">
                            <img src="images/noimage.jpg" alt="Payment Proceed" height="100px">
                            <h2 style="color: crimson;"> Credit/Debit Card Payment</h2>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="cardholder">Name of Card Holder</label>
                                <input type="text" class="form-control" id="cardholder" name="cardholder" placeholder="Enter Card Holder Name" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="cardnumber">Card Number</label>
                                <input type="number" class="form-control" id="cardnumber" name="cardnumber" placeholder="1111-2222-3333-4444" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            
                            <div class="col-md-6 form-group">
                                <label for="ExMonth">Exp. Month</label>
                                <input type="number" class="form-control" id="ExMonth" name="ExMonth" placeholder="MM" max="12" min="0" required>
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="ExYear">Exp. Year</label>
                                <input type="number" class="form-control" id="ExYear" name="ExYear" placeholder="YYYY" size="4" required>
                            </div>
                        </div>

                        <div class="row">
                            
                            <div class="col-md-6 form-group">
                                <label for="cvv">Enter CVV</label> 
                                <input type="number" placeholder="123" class="form-control" size="3" id="cvv" name="cvv" required> 
                                <input type="hidden" name="amount" value="<%=amount%>">
        
                            </div>
                            <div class="col-md-6 form-group">
                                <label>&nbsp;</label>
                                <button type="submit" class="form-control btn btn-success">Pay: RS.<%=amount%></button>
                            </div>
                        </div>

                    <!-- </div> -->
                </form>
            </div>
        </div>
        
        <jsp:include page="footer.html" ></jsp:include>
    </body>
</html>