/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.utility;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Admin
 */
public class DeliveryDate {
    
    // You can maintain a list of holidays here if you like.
    private static final Set<String> HOLIDAYS = new HashSet<>();

    static {
        // Format: yyyy-MM-dd
        HOLIDAYS.add("2025-01-26"); // Republic Day
        HOLIDAYS.add("2025-08-15"); // Independence Day
        HOLIDAYS.add("2025-10-02"); // Gandhi Jayanti
    }
    
    public static LocalDate addBusinessDays(LocalDate startDate, int days) {
        LocalDate result = startDate;
        int addedDays = 0;

        while (addedDays < days) {
            result = result.plusDays(1);
            if (!(result.getDayOfWeek() == DayOfWeek.SATURDAY || result.getDayOfWeek() == DayOfWeek.SUNDAY)) {
                addedDays++;
            }
        }

        return result;
    }
    public static Date calculateExpectedDeliveryDate(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);

        int daysToAdd = 3; // Add 3 business days by default

        while (daysToAdd > 0) {
            cal.add(Calendar.DATE, 1); // Move one day forward

            int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            String formattedDate = String.format("%04d-%02d-%02d",
                    cal.get(Calendar.YEAR),
                    (cal.get(Calendar.MONTH) + 1),
                    cal.get(Calendar.DAY_OF_MONTH));

            // Skip weekends and holidays
            if (dayOfWeek != Calendar.SATURDAY &&
                dayOfWeek != Calendar.SUNDAY &&
                !HOLIDAYS.contains(formattedDate)) {
                daysToAdd--;
            }
        }

        // Set expected delivery time to 6 PM (optional)
        cal.set(Calendar.HOUR_OF_DAY, 18);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);

        return cal.getTime();
    }
    
}