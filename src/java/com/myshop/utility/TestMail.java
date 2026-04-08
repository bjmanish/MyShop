//package com.myshop.utility;
//
//import javax.mail.MessagingException;
//
//public class TestMail {
//	public static void main(String[] args) throws Exception {
//		try {
//			String recipient = "bjmanish45@gmail.com";
////			String subject = "Mail Configuration Successfull";
//                        String name = "Manish";
//                        String orderId = "T20260107095058";
//			String subject = "📦 Your Order is Out for Delivery - THE MYSHOP STORE";
//                        String textMessage = "Hello " + name +
//                            ",\n\nYour order is out for delivery.\nPlease check the attached PDF.";
//                        
//                        byte[] paypdfBytes = PaymentSlipPdfUtil.generatePaymentSlipPdf(
//                                "Rahul Sharma",
//                                "ORD123456",
//                                "PAY987654",
//                                "UPI",
//                                2499.00,
//                                "SUCCESS"
//                            );
//                        
////                        JavaMailUtil.sendMailWithAttach(recipient,subject,textMessage,paypdfBytes,orderId+".pdf");
//
//
//                        byte[] pdfBytes = OrderPdfUtil.generateOutForDeliveryPdf(name, orderId, "2026-01-14", "P20250921112523", "897868");
//
////                        JavaMailUtil.sendMailWithAttach(recipient,subject,textMessage,pdfBytes,orderId+".pdf");
//                        System.out.println("Send Delivered ail ");
//                        MailMessage.markAsDelivered(recipient);
//                    } catch (MessagingException e) {
//			System.out.println("Mail Sending Failed With Error: " + e.getMessage());
//			e.printStackTrace();
//		}
//                
////                MailMessage mail = new MailMessage();
//
//                    
//                
//                
//                
//	}
//
//}
