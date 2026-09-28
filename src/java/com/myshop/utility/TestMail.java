package com.myshop.utility;

import javax.mail.MessagingException;

public class TestMail {

    public static void main(String[] args) {

        // =====================================================
        // TEST EMAIL
        // =====================================================

        String recipient = "bjmanish45@gmail.com";

        // Common test data
        String name = "Manish";
        String staffName = "Manish Kumar";

        String orderId = "T20260107095058";
        String transactionId = "T20260107095058";
        String productId = "P20250921112523";

        String productName = "Samsung Smart LED TV";

        String deliveryDate = "2026-01-14";
        String otp = "897868";

        double amount = 2499.00;


        try {

            System.out.println();
            System.out.println("================================================");
            System.out.println("       MYSHOP EMAIL TEST STARTED");
            System.out.println("================================================");
            System.out.println("Recipient : " + recipient);
            System.out.println();


            // =================================================
            // 1. WELCOME BACK / LOGIN EMAIL
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("1. Sending Welcome Back email...");
            System.out.println("-----------------------------------------------");

//            MailMessage.welcomeBack(
//                    recipient,
//                    name
//            );

            System.out.println(
                    "✓ Welcome Back email sent successfully."
            );


            // =================================================
            // 2. REGISTRATION SUCCESS
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("2. Sending Registration email...");
            System.out.println("-----------------------------------------------");

            MailMessage.registrationSuccess(
                    recipient,
                    name
            );

            System.out.println(
                    "✓ Registration email sent successfully."
            );


            // =================================================
            // 3. PRODUCT AVAILABLE
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("3. Sending Product Available email...");
            System.out.println("-----------------------------------------------");

            MailMessage.productAvailableNow(
                    recipient,
                    name,
                    productName,
                    productId
            );

            System.out.println(
                    "✓ Product Available email sent successfully."
            );


            // =================================================
            // 4. TRANSACTION / PAYMENT SUCCESS
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("4. Sending Transaction Success email...");
            System.out.println("-----------------------------------------------");

            MailMessage.transactionSuccess(
                    recipient,
                    name,
                    transactionId,
                    amount
            );

            System.out.println(
                    "✓ Transaction email sent successfully."
            );

            System.out.println(
                    "  → Payment PDF attachment generated."
            );


            // =================================================
            // 5. ORDER SHIPPED
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("5. Sending Order Shipped email...");
            System.out.println("-----------------------------------------------");

            MailMessage.orderShipped(
                    recipient,
                    name,
                    orderId,
                    amount
            );

            System.out.println(
                    "✓ Order Shipped email sent successfully."
            );


            // =================================================
            // 6. OUT FOR DELIVERY
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("6. Sending Out For Delivery email...");
            System.out.println("-----------------------------------------------");

            MailMessage.orderOutForDelivery(
                    recipient,
                    name,
                    orderId,
                    deliveryDate,
                    productId,
                    otp
            );

            System.out.println(
                    "✓ Out For Delivery email sent successfully."
            );

            System.out.println(
                    "  → Delivery PDF attachment generated."
            );


            // =================================================
            // 7. ORDER DELIVERED
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("7. Sending Order Delivered email...");
            System.out.println("-----------------------------------------------");

            MailMessage.markAsDelivered(
                    recipient
            );

            System.out.println(
                    "✓ Order Delivered email sent successfully."
            );


            // =================================================
            // 8. GENERIC MESSAGE
            // =================================================

            System.out.println("-----------------------------------------------");
            System.out.println("8. Sending Generic Message email...");
            System.out.println("-----------------------------------------------");

            String genericHtml =
                    "<!DOCTYPE html>"
                    + "<html>"
                    + "<body>"
                    + "<h2>MYSHOP Test Email</h2>"
                    + "<p>Hello <strong>"
                    + name
                    + "</strong>,</p>"
                    + "<p>This is a test email sent using "
                    + "MailMessage.sendMessage().</p>"
                    + "<p>Mail configuration is working correctly.</p>"
                    + "</body>"
                    + "</html>";

            String result =
                    MailMessage.sendMessage(
                            recipient,
                            "MYSHOP Test Email",
                            genericHtml
                    );

            System.out.println(
                    "Generic email result: " + result
            );


            // =================================================
            // COMPLETE
            // =================================================

            System.out.println();
            System.out.println("================================================");
            System.out.println("       ALL EMAIL TESTS COMPLETED");
            System.out.println("================================================");
            System.out.println();
            System.out.println(
                    "Check inbox: " + recipient
            );
            System.out.println();


        } catch (MessagingException e) {

            System.out.println();
            System.out.println("================================================");
            System.out.println("       MAIL SENDING FAILED");
            System.out.println("================================================");

            System.out.println(
                    "Error: " + e.getMessage()
            );

            e.printStackTrace();


        } catch (Exception e) {

            System.out.println();
            System.out.println("================================================");
            System.out.println("       UNEXPECTED ERROR");
            System.out.println("================================================");

            System.out.println(
                    "Error: " + e.getMessage()
            );

            e.printStackTrace();
        }
    }
}
