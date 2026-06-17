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
        return String.format("%d%02d", date.getYear(), date.getMonthValue());
    }

    public static LocalDate startOf(String period) {
        int y = Integer.parseInt(period.substring(0, 4));
        int m = Integer.parseInt(period.substring(4));
        return LocalDate.of(y, m, 1);
    }

    public static LocalDate endOf(String period) {
        int y = Integer.parseInt(period.substring(0, 4));
        int m = Integer.parseInt(period.substring(4));
        return YearMonth.of(y, m).atEndOfMonth();
    }

    public static List<String> recentMonths(int n) {
        List<String> list = new ArrayList<>();
        LocalDate d = LocalDate.now();
        for (int i = 0; i < n; i++) {
            list.add(fromDate(d));
            d = d.minusMonths(1);
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

