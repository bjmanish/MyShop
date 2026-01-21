package com.myshop.utility;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import java.awt.Color;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PaymentSlipPdfUtil {

    public static byte[] generatePaymentSlipPdf(
            String customerName,
            String orderId,
            String paymentId,
            String paymentMethod,
            double amount,
            String paymentStatus
    ) throws Exception {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, baos);

        document.open();

        // Fonts
        Font titleFont = new Font(Font.HELVETICA, 18, Font.BOLD);
        Font headerFont = new Font(Font.HELVETICA, 12, Font.BOLD);
        Font normalFont = new Font(Font.HELVETICA, 12);
        Font smallFont = new Font(Font.HELVETICA, 9);

        // Title
        Paragraph title = new Paragraph("PAYMENT RECEIPT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Store Info
        Paragraph store = new Paragraph(
                "THE MYSHOP STORE\nPayment Confirmation Slip",
                headerFont
        );
        store.setAlignment(Element.ALIGN_CENTER);
        store.setSpacingAfter(20);
        document.add(store);

        // Date
        String date = new SimpleDateFormat("dd MMM yyyy HH:mm").format(new Date());
        document.add(new Paragraph("Payment Date: " + date, normalFont));
        document.add(new Paragraph(" "));

        // Table
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        table.setSpacingAfter(10);
        table.setWidths(new int[]{40, 60});

        addRow(table, "Customer Name", customerName);
        addRow(table, "Order ID", orderId);
        addRow(table, "Payment ID", paymentId);
        addRow(table, "Payment Method", paymentMethod);
        addRow(table, "Payment Status", paymentStatus);
        addRow(table, "Amount Paid", "₹ " + String.format("%.2f", amount));

        document.add(table);

        // Status Highlight
        Font statusFont = new Font(Font.HELVETICA, 12, Font.BOLD,
                paymentStatus.equalsIgnoreCase("SUCCESS") ? Color.GREEN : Color.RED);

        Paragraph status = new Paragraph(
                "Payment Status: " + paymentStatus,
                statusFont
        );
        status.setAlignment(Element.ALIGN_CENTER);
        status.setSpacingBefore(10);
        document.add(status);

        // Footer
        Paragraph note = new Paragraph(
                "\nThis is a system-generated payment receipt.\n" +
                "No signature is required.\n\n" +
                "© 2024 - "+(java.time.Year.now())+" THE MYSHOP STORE. All rights reserved.",
                smallFont
        );
        note.setAlignment(Element.ALIGN_CENTER);
        document.add(note);

        document.close();
        return baos.toByteArray();
    }

    private static void addRow(PdfPTable table, String key, String value) {
        Font keyFont = new Font(Font.HELVETICA, 11, Font.BOLD);
        Font valueFont = new Font(Font.HELVETICA, 11);

        PdfPCell keyCell = new PdfPCell(new Phrase(key, keyFont));
        PdfPCell valueCell = new PdfPCell(new Phrase(value, valueFont));

        keyCell.setPadding(8);
        valueCell.setPadding(8);

        keyCell.setBackgroundColor(new Color(245, 245, 245));

        table.addCell(keyCell);
        table.addCell(valueCell);
    }
}

