package com.myshop.utility;

import com.myshop.beans.UserBean;

import javax.mail.MessagingException;
import java.io.UnsupportedEncodingException;
import java.time.Year;

/**
 * Centralized email message utility for MYSHOP.
 *
 * Features:
 * - Modern responsive HTML email design
 * - Consistent MYSHOP branding
 * - Mobile-friendly layout
 * - Reusable email components
 * - HTML escaping for user/product data
 * - Existing public method names preserved
 * - Supports PDF attachments
 */
public class MailMessage {

    /* =========================================================
       BRAND
       ========================================================= */

    private static final String STORE_NAME = "THE MYSHOP STORE";

    private static final String PRIMARY_COLOR = "#6C63FF";
    private static final String PRIMARY_DARK = "#574FD6";

    private static final String SUCCESS_COLOR = "#16A34A";
    private static final String SUCCESS_LIGHT = "#DCFCE7";

    private static final String DANGER_COLOR = "#DC3545";

    private static final String INFO_COLOR = "#2563EB";
    private static final String INFO_LIGHT = "#DBEAFE";

    private static final String WARNING_COLOR = "#D97706";
    private static final String WARNING_LIGHT = "#FEF3C7";

    private static final String PAGE_BG = "#F5F7FB";
    private static final String CARD_BG = "#FFFFFF";
    private static final String TEXT_COLOR = "#171B2D";
    private static final String MUTED_COLOR = "#707789";
    private static final String BORDER_COLOR = "#E5E7EB";


    /* =========================================================
       REGISTRATION SUCCESS
       ========================================================= */

    public static void registrationSuccess(
            String emailId,
            String name
    ) throws MessagingException, UnsupportedEncodingException {

        String recipient = emailId;

        String subject = "Welcome to THE MYSHOP STORE 🎉";

        String safeName = escapeHtml(name);

        String content =
                greeting(safeName)

                + paragraph(
                    "Thank you for creating your account with "
                    + "<strong>" + STORE_NAME + "</strong>."
                )

                + paragraph(
                    "We're excited to have you with us. "
                    + "Explore our latest electronics, appliances, "
                    + "and branded products."
                )

                + infoCard(
                    "🎁 Welcome Gift",
                    "Enjoy an additional <strong>10% OFF</strong> "
                    + "up to ₹500 on your first purchase."
                )

                + promoCode("THEMYSHOP500")

                + paragraph(
                    "We offer convenient home delivery with no "
                    + "additional delivery charges on eligible orders."
                )

                + closing();

        String html = buildEmail(
                "Welcome to MYSHOP",
                "Your account has been created successfully.",
                content,
                PRIMARY_COLOR
        );

        JavaMailUtil.sendMail(
                recipient,
                subject,
                html
        );
    }

    /* =========================================================
        WELCOME BACK - USER LOGIN
    ========================================================= */


    public static void welcomeBack(
        UserBean user,
        String ip,
        String device
    ) throws MessagingException, UnsupportedEncodingException {

        String subject =
            "Welcome Back to THE MYSHOP STORE 👋";

        // =====================================================
        // SAFE USER DATA
        // =====================================================

        String safeName =
            escapeHtml(user.getName());

        String safeEmail =
            escapeHtml(user.getEmail());

        String safeIp =
            escapeHtml(
                    ip != null && !ip.trim().isEmpty()
                            ? ip
                            : "Unknown"
            );

        String safeDevice =
            escapeHtml(
                    device != null && !device.trim().isEmpty()
                            ? device
                            : "Unknown Device"
            );


        // =====================================================
        // LOGIN TIME
        // =====================================================

        String loginTime =
            java.time.LocalDateTime.now()
                    .format(
                            java.time.format.DateTimeFormatter.ofPattern(
                                    "dd MMM yyyy, hh:mm a"
                            )
                    );


        // =====================================================
        // EMAIL CONTENT
        // =====================================================

        String content =

            greeting(safeName)

            + statusBadge(
                "LOGIN SUCCESSFUL",
                SUCCESS_COLOR,
                SUCCESS_LIGHT
            )


            + paragraph(
                "Welcome back to "
                + "<strong>"
                + STORE_NAME
                + "</strong>! 👋"
            )


            + paragraph(
                "We're happy to see you again. "
                + "Your account has been successfully signed in."
            )


            // =================================================
            // LOGIN DETAILS
            // =================================================

            + detailCard(
                "🔐 Login Details",

                detailRow(
                    "Account ",
                    safeEmail
                )

                + detailRow(
                    "Login Time ",
                    escapeHtml(loginTime)
                )

                + detailRow(
                    "IP Address ",
                    safeIp
                )

                + detailRow(
                    "Device ",
                    safeDevice
                )
            )


            // =================================================
            // SHOPPING CARD
            // =================================================

            + infoCard(
                "🛍️ Continue Shopping",

                "Explore our latest products, "
                + "check your cart, track your orders, "
                + "and discover new offers."
            )


            // =================================================
            // SECURITY CARD
            // =================================================

            + infoCard(
                "🔐 Security Notice",

                "If you did not perform this login, "
                + "please change your password immediately "
                + "and contact our support team."
            )


            + closing();


        // =====================================================
        // BUILD EMAIL
        // =====================================================

        String html =
            buildEmail(
                "Welcome Back 👋",
                "You have successfully signed in to your MYSHOP account.",
                content,
                PRIMARY_COLOR
            );


        // =====================================================
        // SEND EMAIL
        // =====================================================

        JavaMailUtil.sendMail(
            user.getEmail(),
            subject,
            html
        );
    }

    /* =========================================================
       STAFF REGISTRATION
       ========================================================= */

    public static void staffRegistrationSuccess(
            UserBean staff,
            String name
    ) throws MessagingException, UnsupportedEncodingException {

        String recipient = staff.getId();

        String subject = "Welcome to THE MYSHOP STORE - Staff Account";

        String safeName = escapeHtml(name);
        String safeEmail = escapeHtml(staff.getEmail());

        String content =
                greeting(safeName)

                + paragraph(
                    "Your staff account for "
                    + "<strong>" + STORE_NAME + "</strong>"
                    + " has been created successfully."
                )

                + detailCard(
                    "Account Details",
                    detailRow("Email", safeEmail)
                )

                + infoCard(
                    "🔐 Account Security",
                    "For security reasons, your password is not "
                    + "included in email. Please use the password "
                    + "provided during account creation or contact "
                    + "the administrator if you need assistance."
                )

                + paragraph(
                    "Please keep your account credentials private "
                    + "and never share them with anyone."
                )

                + closing();

        String html = buildEmail(
                "Staff Account Created",
                "Your MYSHOP staff account is ready.",
                content,
                SUCCESS_COLOR
        );

        JavaMailUtil.sendMail(
                recipient,
                subject,
                html
        );
    }


    /* =========================================================
       PRODUCT AVAILABLE
       ========================================================= */

    public static void productAvailableNow(
            String recipientEmail,
            String userName,
            String prodName,
            String prodId
    ) throws MessagingException, UnsupportedEncodingException {

        String subject =
                "Product Available Now - " + safeSubject(prodName);

        String safeName = escapeHtml(userName);
        String safeProductName = escapeHtml(prodName);
        String safeProductId = escapeHtml(prodId);

        String content =
                greeting(safeName)

                + paragraph(
                    "Good news! The product you were looking for "
                    + "is now available at "
                    + "<strong>" + STORE_NAME + "</strong>."
                )

                + statusBadge(
                    "AVAILABLE NOW",
                    SUCCESS_COLOR,
                    SUCCESS_LIGHT
                )

                + detailCard(
                    "Product Details",
                    detailRow("Product Name", safeProductName)
                    + detailRow("Product ID", safeProductId)
                )

                + infoCard(
                    "ℹ️ Demo Project Notice",
                    "This is a demonstration email from the MYSHOP "
                    + "project. No real transaction has been made."
                )

                + paragraph(
                    "Visit MYSHOP and check the product while stock "
                    + "is available."
                )

                + closing();

        String html = buildEmail(
                "Product Available",
                "The product you were waiting for is back in stock.",
                content,
                SUCCESS_COLOR
        );

        JavaMailUtil.sendMail(
                recipientEmail,
                subject,
                html
        );
    }


    /* =========================================================
       TRANSACTION SUCCESS
       ========================================================= */

    public static void transactionSuccess(
            String recipientEmail,
            String name,
            String transId,
            double transAmount
    ) throws Exception {

        String subject = "Order Confirmed - THE MYSHOP STORE ✓";

        String safeName = escapeHtml(name);
        String safeTransactionId = escapeHtml(transId);

        String amount =
                formatAmount(transAmount);

        String content =
                greeting(safeName)

                + statusBadge(
                    "ORDER CONFIRMED",
                    SUCCESS_COLOR,
                    SUCCESS_LIGHT
                )

                + paragraph(
                    "Your order has been placed successfully "
                    + "and is now being prepared for shipment."
                )

                + detailCard(
                    "Payment Details",
                    detailRow("Order / Transaction ID", safeTransactionId)
                    + detailRow("Amount Paid", "₹" + amount)
                    + detailRow("Payment Status",
                                "<span style='color:"
                                + SUCCESS_COLOR
                                + ";font-weight:700;'>SUCCESS</span>")
                )

                + infoCard(
                    "📄 Payment Receipt",
                    "Your payment receipt is attached to this email "
                    + "as a PDF document."
                )

                + paragraph(
                    "Thank you for shopping with "
                    + "<strong>" + STORE_NAME + "</strong>."
                )

                + closing();

        String html = buildEmail(
                "Order Confirmed",
                "Your payment was successful and your order is confirmed.",
                content,
                SUCCESS_COLOR
        );

        try {

            byte[] payPdfBytes =
                    PaymentSlipPdfUtil.generatePaymentSlipPdf(
                            name,
                            transId,
                            transId,
                            "Card",
                            transAmount,
                            "SUCCESS"
                    );

            JavaMailUtil.sendMailWithAttach(
                    recipientEmail,
                    subject,
                    html,
                    payPdfBytes,
                    transId + ".pdf"
            );

        } catch (MessagingException e) {

            System.err.println(
                    "Failed to send transaction success email: "
                    + e.getMessage()
            );

            e.printStackTrace();

            throw e;
        }
    }


    /* =========================================================
       ORDER SHIPPED
       ========================================================= */

    public static void orderShipped(
            String recipientEmail,
            String name,
            String transId,
            double transAmount
    ) throws UnsupportedEncodingException {

        String subject =
                "Your MYSHOP Order Has Been Shipped 🚚";

        String safeName = escapeHtml(name);
        String safeTransactionId = escapeHtml(transId);

        String amount =
                formatAmount(transAmount);

        String content =
                greeting(safeName)

                + statusBadge(
                    "SHIPPED",
                    INFO_COLOR,
                    INFO_LIGHT
                )

                + paragraph(
                    "Great news! Your order has been shipped "
                    + "and is now on its way to you."
                )

                + detailCard(
                    "Order Details",
                    detailRow(
                        "Order / Transaction ID",
                        safeTransactionId
                    )
                    + detailRow(
                        "Order Amount",
                        "₹" + amount
                    )
                    + detailRow(
                        "Current Status",
                        "<span style='color:"
                        + INFO_COLOR
                        + ";font-weight:700;'>SHIPPED</span>"
                    )
                )

                + paragraph(
                    "Please keep your phone available so our "
                    + "delivery team can contact you when required."
                )

                + closing();

        String html = buildEmail(
                "Order Shipped",
                "Your order is on its way.",
                content,
                INFO_COLOR
        );

        try {

            JavaMailUtil.sendMail(
                    recipientEmail,
                    subject,
                    html
            );

        } catch (MessagingException e) {

            System.err.println(
                    "Failed to send order shipped email: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }
    }


    /* =========================================================
       OUT FOR DELIVERY
       ========================================================= */

    public static void orderOutForDelivery(
            String recipientEmail,
            String name,
            String orderId,
            String deliveryDate,
            String prodId,
            String otp
    ) {

        String subject =
                "Your Order Is Out for Delivery 🚚";

        String safeName = escapeHtml(name);
        String safeOrderId = escapeHtml(orderId);
        String safeDeliveryDate = escapeHtml(deliveryDate);
        String safeProductId = escapeHtml(prodId);
        String safeOtp = escapeHtml(otp);

        String content =
                greeting(safeName)

                + statusBadge(
                    "OUT FOR DELIVERY",
                    WARNING_COLOR,
                    WARNING_LIGHT
                )

                + paragraph(
                    "Your order "
                    + "<strong>" + safeOrderId + "</strong>"
                    + " is now out for delivery."
                )

                + detailCard(
                    "Delivery Details",
                    detailRow(
                        "Order ID",
                        safeOrderId
                    )
                    + detailRow(
                        "Product ID",
                        safeProductId
                    )
                    + detailRow(
                        "Expected Delivery",
                        safeDeliveryDate
                    )
                )

                + otpCard(safeOtp)

                + infoCard(
                    "🔒 Delivery Security",
                    "Please share the delivery OTP only with "
                    + "the authorized delivery person after receiving "
                    + "your order."
                )

                + paragraph(
                    "Your delivery partner may contact you before "
                    + "arrival."
                )

                + infoCard(
                    "ℹ️ Demo Project Notice",
                    "This is a demonstration email from the MYSHOP "
                    + "project. No real transaction has been made."
                )

                + closing();

        String html = buildEmail(
                "Out for Delivery",
                "Your MYSHOP order is on its way to you.",
                content,
                WARNING_COLOR
        );

        try {

            byte[] pdfBytes =
                    OrderPdfUtil.generateOutForDeliveryPdf(
                            name,
                            orderId,
                            deliveryDate,
                            prodId,
                            otp
                    );

            JavaMailUtil.sendMailWithAttach(
                    recipientEmail,
                    subject,
                    html,
                    pdfBytes,
                    orderId + ".pdf"
            );

        } catch (Exception e) {

            System.err.println(
                    "Error sending out-for-delivery email: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }
    }


    /* =========================================================
       ORDER DELIVERED
       ========================================================= */

    public static void markAsDelivered(
            String mail
    ) throws MessagingException, UnsupportedEncodingException {

        String subject =
                "Your Order Has Been Delivered ✓";

        String content =
                statusBadge(
                    "DELIVERED",
                    SUCCESS_COLOR,
                    SUCCESS_LIGHT
                )

                + paragraph(
                    "Your order from "
                    + "<strong>" + STORE_NAME + "</strong>"
                    + " has been successfully delivered."
                )

                + infoCard(
                    "📦 Delivery Complete",
                    "We hope you enjoy your purchase and had a "
                    + "great shopping experience with us."
                )

                + paragraph(
                    "If you have any questions regarding your order, "
                    + "please contact our support team."
                )

                + infoCard(
                    "ℹ️ Demo Project Notice",
                    "This is a demonstration email from the MYSHOP "
                    + "project. No real transaction has been made."
                )

                + closing();

        String html = buildEmail(
                "Order Delivered",
                "Your MYSHOP order has arrived successfully.",
                content,
                SUCCESS_COLOR
        );

        JavaMailUtil.sendMail(
                mail,
                subject,
                html
        );
    }

    
    public static void subscriptionWelcome(String email) 
            throws MessagingException, UnsupportedEncodingException {

        String subject = "Welcome to MYSHOP Updates";

        String html =
            "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "<title>MYSHOP Subscription</title>" +
            "</head>" +

            "<body style='margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;'>" +

            "<table width='100%' cellpadding='0' cellspacing='0' " +
            "style='background:#f4f6f8;padding:30px 10px;'>" +

            "<tr>" +
            "<td align='center'>" +

            "<table width='600' cellpadding='0' cellspacing='0' " +
            "style='max-width:600px;background:#ffffff;border-radius:14px;overflow:hidden;'>" +

            "<tr>" +
            "<td style='background:#0d6efd;padding:28px;text-align:center;color:#ffffff;'>" +

            "<div style='font-size:30px;font-weight:bold;'>MYSHOP</div>" +

            "<div style='font-size:14px;margin-top:8px;'>" +
            "Your shopping destination" +
            "</div>" +

            "</td>" +
            "</tr>" +

            "<tr>" +
            "<td style='padding:35px 30px;color:#333333;'>" +

            "<h2 style='margin-top:0;color:#222222;'>" +
            "Welcome to MYSHOP! 🎉" +
            "</h2>" +

            "<p style='font-size:16px;line-height:1.7;'>" +
            "Thank you for subscribing to MYSHOP updates." +
            "</p>" +

            "<p style='font-size:16px;line-height:1.7;'>" +
            "You will receive updates about new products, special offers, " +
            "exclusive deals and important MYSHOP announcements." +
            "</p>" +

            "<div style='background:#f8f9fa;border-radius:10px;padding:18px;margin:25px 0;'>" +

            "<div style='font-size:13px;color:#777777;'>Subscribed Email</div>" +

            "<div style='font-size:16px;font-weight:bold;margin-top:5px;'>" +
            escapeHtml(email) +
            "</div>" +

            "</div>" +

            "<div style='text-align:center;margin:30px 0;'>" +

            "<a href='http://localhost:2025/MyShop/user/userHome.jsp' " +
            "style='display:inline-block;background:#0d6efd;color:#ffffff;" +
            "text-decoration:none;padding:13px 25px;border-radius:8px;" +
            "font-weight:bold;'>" +

            "Visit MYSHOP" +

            "</a>" +

            "</div>" +

            "<p style='font-size:13px;color:#777777;line-height:1.6;'>" +
            "If you did not subscribe to MYSHOP, you can safely ignore this email." +
            "</p>" +

            "</td>" +
            "</tr>" +

            "<tr>" +
            "<td style='background:#f8f9fa;padding:20px;text-align:center;" +
            "font-size:12px;color:#888888;'>" +

            "© " + java.time.Year.now().getValue() +
            " MYSHOP. All rights reserved." +

            "</td>" +
            "</tr>" +

            "</table>" +

            "</td>" +
            "</tr>" +

            "</table>" +

            "</body>" +
            "</html>";

        JavaMailUtil.sendMail(email, subject, html);
    }

    /* =========================================================
       GENERIC MESSAGE
       ========================================================= */

    public static String sendMessage(
            String toEmailId,
            String subject,
            String htmlTextMessage
    ) throws UnsupportedEncodingException {

        try {

            JavaMailUtil.sendMail(
                    toEmailId,
                    subject,
                    htmlTextMessage
            );

            return "SUCCESS";

        } catch (MessagingException e) {

            System.err.println(
                    "Failed to send email: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return "FAILURE";
        }
    }


    /* =========================================================
       EMAIL TEMPLATE
       ========================================================= */

    private static String buildEmail(
            String title,
            String subtitle,
            String content,
            String accentColor
    ) {

        String safeTitle = escapeHtml(title);
        String safeSubtitle = escapeHtml(subtitle);

        return "<!DOCTYPE html>"
                + "<html lang='en'>"

                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' "
                + "content='width=device-width, initial-scale=1.0'>"

                + "<title>"
                + safeTitle
                + "</title>"

                + "<style>"

                + "*{box-sizing:border-box;}"

                + "body{"
                + "margin:0;"
                + "padding:0;"
                + "background:"
                + PAGE_BG
                + ";"
                + "font-family:Arial,Helvetica,sans-serif;"
                + "color:"
                + TEXT_COLOR
                + ";"
                + "}"

                + ".email-wrapper{"
                + "width:100%;"
                + "padding:35px 15px;"
                + "}"

                + ".email-card{"
                + "max-width:640px;"
                + "margin:0 auto;"
                + "background:"
                + CARD_BG
                + ";"
                + "border:1px solid "
                + BORDER_COLOR
                + ";"
                + "border-radius:20px;"
                + "overflow:hidden;"
                + "box-shadow:0 15px 40px "
                + "rgba(20,25,45,.08);"
                + "}"

                + ".email-header{"
                + "padding:28px 30px;"
                + "background:linear-gradient("
                + "135deg,"
                + accentColor
                + ","
                + PRIMARY_DARK
                + ");"
                + "color:#ffffff;"
                + "}"

                + ".brand{"
                + "font-size:13px;"
                + "font-weight:700;"
                + "letter-spacing:1px;"
                + "text-transform:uppercase;"
                + "opacity:.9;"
                + "margin-bottom:12px;"
                + "}"

                + ".email-title{"
                + "font-size:27px;"
                + "line-height:1.25;"
                + "font-weight:800;"
                + "margin:0 0 8px;"
                + "}"

                + ".email-subtitle{"
                + "font-size:14px;"
                + "line-height:1.6;"
                + "margin:0;"
                + "opacity:.9;"
                + "}"

                + ".email-content{"
                + "padding:30px;"
                + "}"

                + ".greeting{"
                + "font-size:17px;"
                + "font-weight:700;"
                + "margin:0 0 18px;"
                + "}"

                + ".paragraph{"
                + "font-size:14px;"
                + "line-height:1.75;"
                + "color:"
                + TEXT_COLOR
                + ";"
                + "margin:0 0 18px;"
                + "}"

                + ".detail-card{"
                + "margin:22px 0;"
                + "border:1px solid "
                + BORDER_COLOR
                + ";"
                + "border-radius:14px;"
                + "overflow:hidden;"
                + "}"

                + ".detail-title{"
                + "padding:14px 16px;"
                + "font-size:14px;"
                + "font-weight:800;"
                + "background:#F8F9FD;"
                + "border-bottom:1px solid "
                + BORDER_COLOR
                + ";"
                + "}"

                + ".detail-row{"
                + "display:flex;"
                + "justify-content:space-between;"
                + "gap:20px;"
                + "padding:13px 16px;"
                + "border-bottom:1px solid "
                + BORDER_COLOR
                + ";"
                + "font-size:13px;"
                + "}"

                + ".detail-row:last-child{"
                + "border-bottom:0;"
                + "}"

                + ".detail-label{"
                + "color:"
                + MUTED_COLOR
                + ";"
                + "}"

                + ".detail-value{"
                + "font-weight:700;"
                + "text-align:right;"
                + "word-break:break-word;"
                + "}"

                + ".info-card{"
                + "padding:16px;"
                + "margin:20px 0;"
                + "border-radius:13px;"
                + "background:#F8F9FD;"
                + "border:1px solid "
                + BORDER_COLOR
                + ";"
                + "font-size:13px;"
                + "line-height:1.65;"
                + "}"

                + ".promo{"
                + "margin:20px 0;"
                + "padding:20px;"
                + "text-align:center;"
                + "border-radius:15px;"
                + "background:"
                + SUCCESS_LIGHT
                + ";"
                + "border:1px dashed "
                + SUCCESS_COLOR
                + ";"
                + "}"

                + ".promo-label{"
                + "font-size:11px;"
                + "font-weight:700;"
                + "color:"
                + SUCCESS_COLOR
                + ";"
                + "text-transform:uppercase;"
                + "letter-spacing:1px;"
                + "}"

                + ".promo-code{"
                + "margin-top:8px;"
                + "font-size:22px;"
                + "font-weight:900;"
                + "letter-spacing:2px;"
                + "color:"
                + SUCCESS_COLOR
                + ";"
                + "}"

                + ".status{"
                + "display:inline-block;"
                + "padding:8px 13px;"
                + "border-radius:30px;"
                + "font-size:11px;"
                + "font-weight:800;"
                + "letter-spacing:.5px;"
                + "margin:5px 0 20px;"
                + "}"

                + ".otp-card{"
                + "margin:22px 0;"
                + "padding:22px;"
                + "text-align:center;"
                + "background:#FFF7ED;"
                + "border:1px dashed "
                + WARNING_COLOR
                + ";"
                + "border-radius:15px;"
                + "}"

                + ".otp-label{"
                + "font-size:11px;"
                + "font-weight:700;"
                + "color:"
                + WARNING_COLOR
                + ";"
                + "text-transform:uppercase;"
                + "letter-spacing:1px;"
                + "}"

                + ".otp-value{"
                + "font-size:30px;"
                + "font-weight:900;"
                + "letter-spacing:7px;"
                + "color:"
                + TEXT_COLOR
                + ";"
                + "margin-top:8px;"
                + "}"

                + ".email-footer{"
                + "padding:22px 30px;"
                + "text-align:center;"
                + "background:#F8F9FD;"
                + "border-top:1px solid "
                + BORDER_COLOR
                + ";"
                + "}"

                + ".footer-brand{"
                + "font-size:14px;"
                + "font-weight:800;"
                + "color:"
                + TEXT_COLOR
                + ";"
                + "}"

                + ".footer-text{"
                + "font-size:11px;"
                + "line-height:1.6;"
                + "color:"
                + MUTED_COLOR
                + ";"
                + "margin-top:6px;"
                + "}"

                + "@media only screen and "
                + "(max-width:600px){"

                + ".email-wrapper{"
                + "padding:15px 8px;"
                + "}"

                + ".email-card{"
                + "border-radius:15px;"
                + "}"

                + ".email-header{"
                + "padding:24px 20px;"
                + "}"

                + ".email-title{"
                + "font-size:23px;"
                + "}"

                + ".email-content{"
                + "padding:22px 18px;"
                + "}"

                + ".detail-row{"
                + "display:block;"
                + "}"

                + ".detail-value{"
                + "text-align:left;"
                + "margin-top:4px;"
                + "}"

                + ".email-footer{"
                + "padding:18px;"
                + "}"

                + ".otp-value{"
                + "font-size:25px;"
                + "letter-spacing:5px;"
                + "}"

                + "}"

                + "</style>"
                + "</head>"

                + "<body>"

                + "<div class='email-wrapper'>"

                + "<div class='email-card'>"

                + "<div class='email-header'>"

                + "<div class='brand'>"
                + STORE_NAME
                + "</div>"

                + "<h1 class='email-title'>"
                + safeTitle
                + "</h1>"

                + "<p class='email-subtitle'>"
                + safeSubtitle
                + "</p>"

                + "</div>"

                + "<div class='email-content'>"
                + content
                + "</div>"

                + "<div class='email-footer'>"

                + "<div class='footer-brand'>"
                + STORE_NAME
                + "</div>"

                + "<div class='footer-text'>"
                + "Thank you for choosing MYSHOP.<br>"
                + "© "
                + Year.now()
                + " "
                + STORE_NAME
                + ". All rights reserved."
                + "</div>"

                + "</div>"

                + "</div>"

                + "</div>"

                + "</body>"
                + "</html>";
    }


    /* =========================================================
       COMPONENTS
       ========================================================= */

    private static String greeting(String name) {

        return "<p class='greeting'>"
                + "Hi "
                + name
                + ","
                + "</p>";
    }


    private static String paragraph(String text) {

        return "<p class='paragraph'>"
                + text
                + "</p>";
    }


    private static String infoCard(
            String title,
            String message
    ) {

        return "<div class='info-card'>"
                + "<strong>"
                + title
                + "</strong>"
                + "<br>"
                + message
                + "</div>";
    }


    private static String detailCard(
            String title,
            String rows
    ) {

        return "<div class='detail-card'>"

                + "<div class='detail-title'>"
                + title
                + "</div>"

                + rows

                + "</div>";
    }


    private static String detailRow(
            String label,
            String value
    ) {

        return "<div class='detail-row'>"

                + "<span class='detail-label'>"
                + label
                + "</span>"

                + "<span class='detail-value'>"
                + value
                + "</span>"

                + "</div>";
    }


    private static String statusBadge(
            String status,
            String color,
            String background
    ) {

        return "<span class='status' "
                + "style='color:"
                + color
                + ";background:"
                + background
                + ";'>"
                + status
                + "</span>";
    }


    private static String promoCode(
            String code
    ) {

        return "<div class='promo'>"

                + "<div class='promo-label'>"
                + "Welcome Promo Code"
                + "</div>"

                + "<div class='promo-code'>"
                + escapeHtml(code)
                + "</div>"

                + "</div>";
    }


    private static String otpCard(
            String otp
    ) {

        return "<div class='otp-card'>"

                + "<div class='otp-label'>"
                + "Delivery OTP"
                + "</div>"

                + "<div class='otp-value'>"
                + otp
                + "</div>"

                + "</div>";
    }


    private static String closing() {

        return "<p class='paragraph' "
                + "style='margin-top:25px;'>"
                + "Thanks for shopping with "
                + "<strong>"
                + STORE_NAME
                + "</strong>."
                + "<br><br>"
                + "Have a great day!"
                + "</p>";
    }


    /* =========================================================
       UTILITIES
       ========================================================= */

    private static String escapeHtml(
            String value
    ) {

        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }


    private static String safeSubject(
            String value
    ) {

        if (value == null || value.trim().isEmpty()) {
            return "Product";
        }

        return value.trim();
    }


    private static String formatAmount(
            double amount
    ) {

        return String.format(
                java.util.Locale.US,
                "%,.2f",
                amount
        );
    }

}
