package com.myshop.utility;

import javax.mail.MessagingException;

public class MailMessage {

    public static void registrationSuccess(String emailId, String name) throws MessagingException {
	String recipient = emailId;
	String subject = "Registration Successfull";
	String htmlTextMessage = "" + "<html>" + "<body>"
		+ "<h2 style='color:green;'>Welcome to THE MYSHOP</h2>" + "" + "Hi " + name + ","
		+ "<br><br>Thanks for singing up with THE MYSHOP.<br>"
		+ "We are glad that you choose us. We invite you to check out our latest collection of new electonics appliances."
		+ "<br>We are providing upto 60% OFF on most of the all products. So please visit our site and explore the collections."
		+ "<br><br>Our Online MYSHOP is growing in a larger amount these days and we are in high demand so we thanks all of you for "
		+ "making us up to that level. We Deliver Product to your house with no extra delivery charges and we also have collection of most of the"
		+ "branded items.<br><br><font style=\"color:red;font-weigth:bold;\">As a Welcome gift for our New Customers we are providing additional 10% OFF Upto 500 Rs for the first product purchase. "
		+ "<br>To avail this offer you only have </font>"
		+ "to enter the promo code given below.<br><br><br> PROMO CODE: " + "<font style=\"color:red; font-weight:bold;\">THEMYSHOP500</font><br><br><br>"
		+ "Have a good day!<br>" + "" + "</body>" + "</html>";
        
       JavaMailUtil.sendMail(recipient, subject, htmlTextMessage); 
    }
    
    
    public static void productAvailableNow(String recipientEmail, String userName, String prodName, String prodId) throws MessagingException {
        String recipient = recipientEmail;
        String subject = "Product " + prodName + " is Now Available at THE MYSHOP Store";
        String message = "<html>" + "<body>" + "    <p>"+"  Hey" + userName + ",<br/><br/>"
                +"      We are glad that you shop with THE MYSHOP Store!" + "   <br/><br/>"
                +"      As per your recent browsing history, we seen that you were searching for an item that was not available in sufficient amount at that time. <br/><br/>"
                +"   We are glad so say that the product named <font style=\"color:crimson;font-weight:bold;\">" + prodName + "</font> with " + " product Id <font style=\"color:crimson;font-weight:bold;\">" + prodId
                +"  </font> is now available to our store!"
                +" <br/><h6>Please Note that this is demo project Email and you have not made any rael transaction with us and not ordered anything till now!</h6>"
                +" <br/>" + "   Here is the product details which is now available to Store:<br/>"
                +"  <br/>"
                +"  <font style=\"color:blue;font-weight:bold;\">Product Id: </font><font style=\"color:black;font-weight:bold;\"> "+prodId +" "+"  </font><br/>"+"<br/>"
                +"  <font style=\"color:blue;font-weight:bold;\">Product Name: </font><font style=\"color:black;font-weight:bold;\"> "+prodName +" "+"  </font><br/>"+"<br/>"
                +"  Thanks for shopping with us!<br/><br/>"
                +" Please Visit Again!<br/><br/><br/> <font style=\"color:crimson;font-weight:bold;\">THE MYSHOP Store</font>"
                +" </p>" + "    "   +   "   </body>" + " </html>";
        
        
            JavaMailUtil.sendMail(recipient, subject, message);
        
    }
    
    public static void transactionSuccess(String recipientEmail, String name, String transId, double transAmount) {
	String recipient = recipientEmail;
	String subject = "Order Placed at THE MYSHOP STORE";
	String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Hey " + name + ",<br/><br/>"
            + "      We are glad that you shop with THE MYSHOP STORE!" + "      <br/><br/>"
            + "      Your order has been placed successfully and under process to be shipped."
            + "<br/><h6>Please Note that this is a demo projet Email and you have not made any real transaction with us till now!</h6>"
            + "      <br/>" + "    <h4>  Here is Your Transaction Details:</h4><br/>" + "      <br/>"
            + "      <font style=\"color:red;font-weight:bold;\">Order Id:</font>"
            + "      <font style=\"color:black;font-weight:bold;\">" + transId + "</font><br/>" + "      <br/>"
            + "      <font style=\"color:black;font-weight:bold;\">Amount Paid:</font> <font style=\"color:red;font-weight:bold;\">"
            + transAmount + "</font>" + "      <br/><br/>" + "      Thanks for shopping with us!<br/><br/>"
            + "      Please visit Again and continue shopping! <br/<br/> <font style=\"color:crimson;font-weight:bold;\">THE MYSHOP STORE.</font>"
            + "    </p>" + "    " + "  </body>" + "</html>";
        try {
            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
	} catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    
    public static void orderShipped(String recipientEmail, String name, String transId, double transAmount) {
        String recipient = recipientEmail;
	String subject = "Hurray!!, Your Order has been Shipped from THE MYSHOP STORE";
	String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Hey " + name + ",<br/><br/>"
            + "      We are glad that you shop with THE MYSHOP STORE!" + "      <br/><br/>"
            + "      Your order has been shipped successfully and on the way to be delivered."
            + "<br/><h6>Please Note that this is a demo projet Email and you have not made any real transaction with us till now!</h6>"
            + "      <br/>" + " <h4>Here is Your Transaction Details:</h4><br/>" + "      <br/>"
            + "      <font style=\"color:red;font-weight:bold;\">Order Id:</font>"
            + "      <font style=\"color:black;font-weight:bold;\">" + transId + "</font><br/>" + "      <br/>"
            + "      <font style=\"color:black;font-weight:bold;\">Amount Paid:</font> <font style=\"color:red;font-weight:bold;\">"
            + transAmount + "</font>" + "      <br/><br/>" + "      Thanks for shopping with us!<br/><br/>"
            + "      Please Visit Again and continue Shopping! <br/<br/> <font style=\"color:black;font-weight:bold;\">THE MYSHOP STORE.</font>"
            + "    </p>" + "    " + "  </body>" + "</html>";

        try{
            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    
    public static String sendMessage(String toEmailId, String subject, String htmlTextMessage) {
        try {
            JavaMailUtil.sendMail(toEmailId, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
            return "FAILURE";
	}
	return "SUCCESS";
    }
    
}
