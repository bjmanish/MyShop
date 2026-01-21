package com.myshop.utility;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.io.ByteArrayOutputStream;

public class OrderPdfUtil {

    public static byte[] generateOutForDeliveryPdf(
            String name,
            String orderId,
            String deliveryDate,
            String prodId,
            String otp
    ) throws Exception {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, baos);

        document.open();

        Font titleFont = new Font(Font.HELVETICA, 18, Font.BOLD);
        Font normal = new Font(Font.HELVETICA, 12);
        Font bold = new Font(Font.HELVETICA, 12, Font.BOLD);

        Paragraph title = new Paragraph("Order Out for Delivery", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        document.add(new Paragraph("Hello " + name + ",", normal));
        document.add(new Paragraph("\nYour order is OUT FOR DELIVERY.", bold));

        document.add(new Paragraph("\nOrder ID: " + orderId, normal));
        document.add(new Paragraph("Product ID: " + prodId, normal));
        document.add(new Paragraph("Estimated Delivery Date: " + deliveryDate, normal));
        document.add(new Paragraph("\nDelivery OTP: " + otp, bold));

        document.add(new Paragraph(
                "\nPlease share this OTP with the delivery partner.",
                normal
        ));

        document.add(new Paragraph(
                "\n\nNote: This is a demo project PDF.",
                new Font(Font.HELVETICA, 9, Font.ITALIC)
        ));

        Paragraph footer = new Paragraph(
                "\n© 2024 - "+(java.time.Year.now())+" THE MYSHOP STORE. All rights reserved.",
                new Font(Font.HELVETICA, 9)
        );
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();

        return baos.toByteArray();
    }
}
