package com.quanlymayphatdien.g1.utils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class LiquidationReportExcelSupport {

    private static final XSSFColor HEADER_BG = new XSSFColor(new byte[]{(byte) 79, (byte) 129, (byte) 189}, null);
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static XSSFWorkbook exportReport(
            LocalDate fromDate, LocalDate toDate, String warehouseName,
            List<Map<String, Object>> rows) {

        XSSFWorkbook wb = new XSSFWorkbook();

        XSSFFont titleFont = wb.createFont();
        titleFont.setFontName("Times New Roman");
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);

        XSSFFont headerFont = wb.createFont();
        headerFont.setFontName("Times New Roman");
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 11);
        headerFont.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        XSSFFont dataFont = wb.createFont();
        dataFont.setFontName("Times New Roman");
        dataFont.setFontHeightInPoints((short) 11);

        CellStyle titleStyle = wb.createCellStyle();
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle infoStyle = wb.createCellStyle();
        infoStyle.setFont(dataFont);

        CellStyle headerStyle = wb.createCellStyle();
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(HEADER_BG);
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        CellStyle dataStyle = wb.createCellStyle();
        dataStyle.setFont(dataFont);

        CellStyle moneyStyle = wb.createCellStyle();
        moneyStyle.setFont(dataFont);
        moneyStyle.setDataFormat(wb.createDataFormat().getFormat("#,##0"));

        CellStyle totalStyle = wb.createCellStyle();
        totalStyle.setFont(dataFont);
        totalStyle.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 242, (byte) 242, (byte) 242}, null));
        totalStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        totalStyle.setBorderTop(BorderStyle.MEDIUM);

        String range = DF.format(fromDate) + " - " + DF.format(toDate);
        String wh = warehouseName != null && !warehouseName.isEmpty() ? warehouseName : "Tất cả kho";

        String[] headers = {"STT", "Mã đơn", "Ngày thanh lý", "Kho", "Lý do",
                "Số máy", "Giá nhập (VNĐ)", "Giá thanh lý (VNĐ)", "Chênh lệch (VNĐ)",
                "Khách hàng", "Người tạo", "Người duyệt"};

        XSSFSheet sheet = wb.createSheet("Báo cáo thanh lý");

        int r = 0;
        Row titleRow = sheet.createRow(r);
        titleRow.createCell(0).setCellValue("BÁO CÁO THANH LÝ");
        titleRow.getCell(0).setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(r, r, 0, headers.length - 1));

        r++;
        Row dateRow = sheet.createRow(r);
        dateRow.createCell(0).setCellValue("Ngày xuất: " + LocalDate.now().format(DF));
        dateRow.getCell(0).setCellStyle(infoStyle);

        r++;
        Row rangeRow = sheet.createRow(r);
        rangeRow.createCell(0).setCellValue("Khoảng thời gian: " + range);
        rangeRow.getCell(0).setCellStyle(infoStyle);

        r++;
        Row whRow = sheet.createRow(r);
        whRow.createCell(0).setCellValue("Kho: " + wh);
        whRow.getCell(0).setCellStyle(infoStyle);

        r++;
        Row hr = sheet.createRow(r);
        for (int i = 0; i < headers.length; i++) {
            Cell c = hr.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int sumMachine = 0;
        BigDecimal sumOrig = BigDecimal.ZERO;
        BigDecimal sumLiq = BigDecimal.ZERO;
        BigDecimal sumLoss = BigDecimal.ZERO;
        int idx = 1;

        for (Map<String, Object> m : rows) {
            r++;
            Row row = sheet.createRow(r);
            row.createCell(0).setCellValue(idx++);
            row.getCell(0).setCellStyle(dataStyle);

            cellStr(row, 1, (String) m.get("liquidationCode"), dataStyle);
            cellStr(row, 2, (String) m.get("reviewedAtStr"), dataStyle);
            cellStr(row, 3, (String) m.get("warehouseName"), dataStyle);
            cellStr(row, 4, (String) m.get("reasonName"), dataStyle);
            cellInt(row, 5, num(m.get("machineCount")), dataStyle);
            cellMoney(row, 6, bd(m.get("totalOriginal")), moneyStyle);
            cellMoney(row, 7, bd(m.get("totalLiquidation")), moneyStyle);
            cellMoney(row, 8, bd(m.get("totalLoss")), moneyStyle);
            cellStr(row, 9, (String) m.get("customerName"), dataStyle);
            cellStr(row, 10, (String) m.get("creatorName"), dataStyle);
            cellStr(row, 11, (String) m.get("ceoName"), dataStyle);

            sumMachine += num(m.get("machineCount"));
            sumOrig = sumOrig.add(bd(m.get("totalOriginal")));
            sumLiq = sumLiq.add(bd(m.get("totalLiquidation")));
            sumLoss = sumLoss.add(bd(m.get("totalLoss")));
        }

        r++;
        Row total = sheet.createRow(r);
        total.createCell(0).setCellStyle(totalStyle);
        Cell totalLabel = total.createCell(1);
        totalLabel.setCellValue("Tổng (" + rows.size() + " đơn)");
        totalLabel.setCellStyle(totalStyle);
        sheet.addMergedRegion(new CellRangeAddress(r, r, 1, 4));
        for (int i = 2; i <= 4; i++) {
            Cell c = total.createCell(i);
            c.setCellStyle(totalStyle);
        }
        cellInt(total, 5, sumMachine, totalStyle);
        cellMoney(total, 6, sumOrig, totalStyle);
        cellMoney(total, 7, sumLiq, totalStyle);
        cellMoney(total, 8, sumLoss, totalStyle);
        for (int i = 9; i <= 11; i++) {
            Cell c = total.createCell(i);
            c.setCellStyle(totalStyle);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return wb;
    }

    private static void cellStr(Row row, int col, String val, CellStyle s) {
        Cell c = row.createCell(col);
        c.setCellValue(val != null ? val : "");
        c.setCellStyle(s);
    }

    private static void cellInt(Row row, int col, int val, CellStyle s) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(s);
    }

    private static void cellMoney(Row row, int col, BigDecimal val, CellStyle s) {
        Cell c = row.createCell(col);
        c.setCellValue(val != null ? val.doubleValue() : 0d);
        c.setCellStyle(s);
    }

    private static BigDecimal bd(Object o) {
        return o instanceof BigDecimal ? (BigDecimal) o : BigDecimal.ZERO;
    }

    private static int num(Object o) {
        return o instanceof Number ? ((Number) o).intValue() : 0;
    }
}
