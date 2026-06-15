package com.quanlymayphatdien.g1.utils;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class PeriodUtils {

    public static String currentPeriod() {
        return fromDate(LocalDate.now());
    }

    public static String fromDate(LocalDate date) {
        int q = (date.getMonthValue() - 1) / 3 + 1;
        return date.getYear() + "Q" + q;
    }

    public static LocalDate startOf(String period) {
        int y = Integer.parseInt(period.substring(0, 4));
        int q = Integer.parseInt(period.substring(5));
        return LocalDate.of(y, (q - 1) * 3 + 1, 1);
    }

    public static LocalDate endOf(String period) {
        int y = Integer.parseInt(period.substring(0, 4));
        int q = Integer.parseInt(period.substring(5));
        return YearMonth.of(y, q * 3).atEndOfMonth();
    }

    public static List<String> recentQuarters(int n) {
        List<String> list = new ArrayList<>();
        LocalDate d = LocalDate.now();
        for (int i = 0; i < n; i++) {
            list.add(fromDate(d));
            d = d.minusMonths(3);
        }
        return list;
    }

    public static long daysUntilEnd(String period) {
        if (period == null || period.isEmpty()) {
            return -1;
        }
        LocalDate end = endOf(period);
        return ChronoUnit.DAYS.between(LocalDate.now(), end);
    }

    public static boolean isNearDeadline(String period, int thresholdDays) {
        long daysLeft = daysUntilEnd(period);
        return daysLeft >= 0 && daysLeft <= thresholdDays;
    }
}

