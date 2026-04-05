//package com.myshop.utility;
//
//import com.myshop.beans.StaffBean;
//import com.myshop.beans.UserBean;
//import java.sql.Timestamp;
//import javax.mail.MessagingException;
//
//public class MailMessage {
//
//    public static void registrationSuccess(String emailId, String name) throws MessagingException {
//	String recipient = emailId;
//	String subject = "Registration Successfull";
//	String htmlTextMessage = "" + "<html>" + "<body>"
//		+ "<h2 style='color:green;'>Welcome to THE MYSHOP</h2>" + "" + "Hi " + name + ","
//		+ "<br><br>Thanks for singing up with THE MYSHOP.<br>"
//		+ "We are glad that you choose us. We invite you to check out our latest collection of new electonics appliances."
//		+ "<br>We are providing upto 60% OFF on most of the all products. So please visit our site and explore the collections."
//		+ "<br><br>Our Online MYSHOP is growing in a larger amount these days and we are in high demand so we thanks all of you for "
//		+ "making us up to that level. We Deliver Product to your house with no extra delivery charges and we also have collection of most of the"
//		+ "branded items.<br><br><font style=\"color:red;font-weigth:bold;\">As a Welcome gift for our New Customers we are providing additional 10% OFF Upto 500 Rs for the first product purchase. "
//		+ "<br>To avail this offer you only have </font>"
//		+ "to enter the promo code given below.<br><br><br> PROMO CODE: " + "<font style=\"color:red; font-weight:bold;\">THEMYSHOP500</font><br><br><br>"
//		+ "Have a good day!<br>" + "" + "</body>" + "</html>";
//        
//       JavaMailUtil.sendMail(recipient, subject, htmlTextMessage); 
//    }
//    
//    public static void staffRegistrationSuccess(UserBean staff, String name) throws MessagingException {
//	String recipient = staff.getStaffId();
//	String subject = "Staff Registration Successfully";
//	String htmlTextMessage = "" + "<html>" + "<body>"
//		+ "<h2 style='color:green;'>Welcome to THE MYSHOP</h2>" + "" + "Hii " + name + ","
//		+ "<br><br>Thanks for joining with THE MYSHOP.<br>"             
//                + "Email ID: " + staff.getStaffId() + "\n"
//                + "Staff password: " + PasswordEncryption.getDecryptedPassword(staff.getPassword()) + "\n"
//                + "\n"
//                + "These details are crucial for internal record-keeping and ensuring efficient communication within the organization.\n"
//                + "<br>\n"
//                + "Best regards,\n"
//                + "<strong>The MYSHOP Store</strong>\n"
//                + "</body>" + "</html>";
//    
//       JavaMailUtil.sendMail(recipient, subject, htmlTextMessage); 
//    }
//    
//    public static void productAvailableNow(String recipientEmail, String userName, String prodName, String prodId) throws MessagingException {
//        String recipient = recipientEmail;
//        String subject = "Product " + prodName + " is Now Available at THE MYSHOP Store";
//        String message = "<html>" + "<body>" + "    <p>"+"  Hey" + userName + ",<br/><br/>"
//                +"      We are glad that you shop with THE MYSHOP Store!" + "   <br/><br/>"
//                +"      As per your recent browsing history, we seen that you were searching for an item that was not available in sufficient amount at that time. <br/><br/>"
//                +"   We are glad so say that the product named <font style=\"color:crimson;font-weight:bold;\">" + prodName + "</font> with " + " product Id <font style=\"color:crimson;font-weight:bold;\">" + prodId
//                +"  </font> is now available to our store!"
//                +" <br/><h6>Please Note that this is demo project Email and you have not made any rael transaction with us and not ordered anything till now!</h6>"
//                +" <br/>" + "   Here is the product details which is now available to Store:<br/>"
//                +"  <br/>"
//                +"  <font style=\"color:blue;font-weight:bold;\">Product Id: </font><font style=\"color:black;font-weight:bold;\"> "+prodId +" "+"  </font><br/>"+"<br/>"
//                +"  <font style=\"color:blue;font-weight:bold;\">Product Name: </font><font style=\"color:black;font-weight:bold;\"> "+prodName +" "+"  </font><br/>"+"<br/>"
//                +"  Thanks for shopping with us!<br/><br/>"
//                +" Please Visit Again!<br/><br/><br/> <font style=\"color:crimson;font-weight:bold;\">THE MYSHOP Store</font>"
//                +" </p>" + "    "   +   "   </body>" + " </html>";
//        
//        
//            JavaMailUtil.sendMail(recipient, subject, message);
//        
//    }
//    
//    public static void transactionSuccess(String recipientEmail, String name, String transId, double transAmount) throws Exception {
//	String recipient = recipientEmail;
//	String subject = "Order Placed at THE MYSHOP STORE";
//	String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Hey " + name + ",<br/><br/>"
//            + "      We are glad that you shop with THE MYSHOP STORE!" + "      <br/><br/>"
//            + "      Your order has been placed successfully and under process to be shipped."
//            + "<br/><h6>Please Note that this is a demo projet Email and you have not made any real transaction with us till now!</h6>"
//            + "      <br/>" + "    <h4>  Here is Your Transaction Details:</h4><br/>" + "      <br/>"
//            + "      <font style=\"color:red;font-weight:bold;\">Order Id:</font>"
//            + "      <font style=\"color:black;font-weight:bold;\">" + transId + "</font><br/>" + "      <br/>"
//            + "      <font style=\"color:black;font-weight:bold;\">Amount Paid:</font> <font style=\"color:red;font-weight:bold;\">"
//            + transAmount + "</font>" + "      <br/><br/>" +
//                "\n<p>Please check the attached PDF.</p>"+
//                "      Thanks for shopping with us!<br/><br/>"
//            + "      Please visit Again and continue shopping! <br/<br/> <font style=\"color:crimson;font-weight:bold;\">THE MYSHOP STORE.</font>"
//            + "    </p>" + "    " + "  </body>" + "</html>";
//        try {
//          byte[] paypdfBytes = PaymentSlipPdfUtil.generatePaymentSlipPdf(
//                name,
//                transId,
//                transId,
//                "Card",
//                transAmount,
//                "SUCCESS"
//            );
//            
////            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
//            JavaMailUtil.sendMailWithAttach(recipient,subject,htmlTextMessage,paypdfBytes,transId+".pdf");
//	} catch (MessagingException e) {
//            e.printStackTrace();
//        }
//    }
//    
//    public static void orderShipped(String recipientEmail, String name, String transId, double transAmount) {
//        String recipient = recipientEmail;
//	String subject = "Hurray!!, Your Order has been Shipped from THE MYSHOP STORE";
//	String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Hey " + name + ",<br/><br/>"
//            + "      We are glad that you shop with THE MYSHOP STORE!" + "      <br/><br/>"
//            + "      Your order has been shipped successfully and on the way to be delivered."
//            + "<br/><h6>Please Note that this is a demo projet Email and you have not made any real transaction with us till now!</h6>"
//            + "      <br/>" + " <h4>Here is Your Transaction Details:</h4><br/>" + "      <br/>"
//            + "      <font style=\"color:red;font-weight:bold;\">Order Id:</font>"
//            + "      <font style=\"color:black;font-weight:bold;\">" + transId + "</font><br/>" + "      <br/>"
//            + "      <font style=\"color:black;font-weight:bold;\">Amount Paid:</font> <font style=\"color:red;font-weight:bold;\">"
//            + transAmount + "</font>" + "      <br/><br/>" + 
//                "      Thanks for shopping with us!<br/><br/>"
//            + "      Please Visit Again and continue Shopping! <br/<br/> <font style=\"color:black;font-weight:bold;\">THE MYSHOP STORE.</font>"
//            + "    </p>" + "    " + "  </body>" + "</html>";
//
//        try{
//            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
//        } catch (MessagingException e) {
//            e.printStackTrace();
//        }
//    }
//    
//    public static void orderOutForDelivery(String recipientEmail, String name, String orderId, String deliveryDate, String prodId, String otp) {
//    String subject = "Your Order is Out for Delivery - THE MYSHOP STORE";
//
//    String htmlTextMessage = "<!DOCTYPE html>" +
//        "<html>" +
//        "<head>" +
//        "<meta charset='UTF-8'>" +
//        "<style>" +
//        "  body { font-family: Arial, sans-serif; background-color: #f7f7f7; margin: 0; padding: 0; }" +
//        "  .container { background-color: #ffffff; max-width: 600px; margin: 30px auto; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }" +
//        "  .header { background-color: #4CAF50; color: white; padding: 10px 20px; border-top-left-radius: 8px; border-top-right-radius: 8px; }" +
//        "  .content { padding: 20px; color: #333; }" +
//        "  .btn { display: inline-block; padding: 10px 20px; margin-top: 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 5px; }" +
//        "  .footer { font-size: 12px; color: #777; text-align: center; margin-top: 20px; }" +
//        "</style>" +
//        "</head>" +
//        "<body>" +
//        "<div class='container'>" +
//        "  <div class='header'><h2>Delivery Status Update</h2></div>" +
//        "  <div class='content'>" +
//        "    <p>Hi <strong>" + name + "</strong>,</p>" +
//        "    <p>We're excited to let you know that your order <strong>" + orderId + "</strong> is now <strong style='color:#4CAF50;'>Out for Delivery</strong>.</p>" +
//        "    <p>Estimated delivery date: <strong>" + deliveryDate + "</strong></p>" +
//        "    <p class='btn' href=''" + prodId + "'>Prod ID</p>" +
//        "    <p class='btn' href='" + otp + "'>Delivery OTP</p>" +
//             "\n<p>Please check the attached PDF.</p>"+
//        "    <p>If you have any questions, feel free to contact our support team.</p>" +
//        "    <br/><p style='font-size:11px;color:#999;'>Note: This is a demo project email. No real transaction has been made.</p>" +
//            
//        "  </div>" +
//        "  <div class='footer'>© 2024 - "+(java.time.Year.now())+" THE MYSHOP STORE. All rights reserved.\"</div>" +
//        "</div>" +
//        "</body>" +
//        "</html>";
//
//    try {
//        byte[] pdfBytes = OrderPdfUtil.generateOutForDeliveryPdf(
//                name, orderId, deliveryDate, prodId, otp
//        );
//
//        JavaMailUtil.sendMailWithAttach(recipientEmail,subject,htmlTextMessage,pdfBytes,orderId+".pdf");
//    } catch (Exception e) {
//        System.out.println("Error in out for delivery sending mail: "+e.getMessage());
//        e.printStackTrace();
//    }
//}
//    
//    public static void markAsDelivered(String mail) throws MessagingException {
//        String subject = "Your Order Has Been Delivered - THE MYSHOP STORE";
//        
//        String htmlTextMessage =
//        "<!DOCTYPE html>" +
//        "<html>" +
//        "<head>" +
//        "<meta charset='UTF-8'>" +
//        "<style>" +
//        "body { font-family: Arial, sans-serif; background-color: #f7f7f7; margin: 0; padding: 0; }" +
//        ".container { background-color: #ffffff; max-width: 600px; margin: 30px auto; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }" +
//        ".header { background-color: #2196F3; color: white; padding: 10px 20px; border-top-left-radius: 8px; border-top-right-radius: 8px; }" +
//        ".content { padding: 20px; color: #333; }" +
//        ".badge { display: inline-block; padding: 8px 14px; background-color: #2196F3; color: #fff; border-radius: 5px; font-size: 13px; }" +
//        ".footer { font-size: 12px; color: #777; text-align: center; margin-top: 20px; }" +
//        "</style>" +
//        "</head>" +
//        "<body>" +
//        "<div class='container'>" +
//
//        "<div class='header'><h2>Order Delivered Successfully</h2></div>" +
//
//        "<div class='content'>" +
////        "<p>Hi <strong>" + name + "</strong>,</p>" +
//
////        "<p>We’re happy to inform you that your order <strong>" + orderId + "</strong> has been <span class='badge'>DELIVERED</span>.</p>" +
//
////        "<p><strong>Delivery Date:</strong> " + ts + "</p>" +
////        "<p><strong>Product ID:</strong> " + prodId + "</p>" +
//
//        "<p>We hope you enjoyed shopping with <strong>THE MYSHOP STORE</strong>.</p>" +
//
//        "<p>If you have any questions or need support, feel free to contact us.</p>" +
//
//        "<br/>" +
//        "<p style='font-size:11px;color:#999;'>Note: This is a demo project email. No real transaction has been made.</p>" +
//        "</div>" +
//
//        "<div class='footer'>© " + java.time.Year.now() +
//        " THE MYSHOP STORE. All rights reserved.</div>" +
//
//        "</div>" +
//        "</body>" +
//        "</html>";
//        
//        JavaMailUtil.sendMail(mail, subject, htmlTextMessage);
//    }
//    
//    
//    public static String sendMessage(String toEmailId, String subject, String htmlTextMessage) {
//        try {
//            JavaMailUtil.sendMail(toEmailId, subject, htmlTextMessage);
//        } catch (MessagingException e) {
//            e.printStackTrace();
//            return "FAILURE";
//	}
//	return "SUCCESS";
//    }
//    
//}
