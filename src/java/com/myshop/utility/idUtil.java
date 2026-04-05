package com.myshop.utility;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

public class idUtil {

    // Common method for timestamp
    private static String getTimestamp() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS"); // milliseconds added
        return sdf.format(new Date());
    }

    // Random 3-digit number
    private static int getRandomNumber() {
        return ThreadLocalRandom.current().nextInt(1000, 9999);
    }

    // Product ID
    public static String generateProductId() {
        return "P" + getTimestamp() + getRandomNumber();
    }

    // Transaction ID
    public static String generateTransactionId() {
        return "T" + getTimestamp() + getRandomNumber();
    }

    // Cart ID (NEW)
    public static String generateCartId() {
        return "C" + getTimestamp() + getRandomNumber();
    }

    // Alternative: UUID based (100% unique)
    public static String generateUUIDCartId() {
        return "C" + UUID.randomUUID().toString().replace("-", "").substring(0, 12);
    }
}