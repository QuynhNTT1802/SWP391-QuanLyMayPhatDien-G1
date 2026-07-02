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

/**
 * Xuất báo cáo thanh lý ra Excel (nhiều sheet): Tổng quan, Theo lý do, Theo kho,
 * Theo model, Xu hướng theo tháng. Theo style chung của các *ExcelSupport khác.
 */
public class LiquidationReportExcelSupport {

    private static final XSSFColor HEADER_BG = new XSSFColor(new byte[]{(byte) 79, (byte) 129, (byte) 189}, null);
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static XSSFWorkbook exportReport(
            LocalDate fromDate, LocalDate toDate, String warehouseName,
            Map<String, Object> summary,
            List<Map<String, Object>> byReason,
            List<Map<String, Object>> byWarehouse,
            List<Map<String, Object>> byModel,
            List<Map<String, Object>> monthly,
            List<Map<String, Object>> detailList) {

        XSSFWorkbook workbook = new XSSFWorkbook();

        XSSFFont titleFont = workbook.createFont();
        titleFont.setFontName("Times New Roman");
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);

        XSSFFont headerFont = workbook.createFont();
        headerFont.setFontName("Times New Roman");
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 11);
        headerFont.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        XSSFFont dataFont = workbook.createFont();
        dataFont.setFontName("Times New Roman");
        dataFont.setFontHeightInPoints((short) 11);

        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle infoStyle = workbook.createCellStyle();
        infoStyle.setFont(dataFont);

        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(HEADER_BG);
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setFont(dataFont);

        CellStyle moneyStyle = workbook.createCellStyle();
        moneyStyle.setFont(dataFont);
        moneyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));

        Styles styles = new Styles(titleStyle, infoStyle, headerStyle, dataStyle, moneyStyle);
        String range = (fromDate != null && toDate != null)
                ? fromDate.format(DF) + " - " + toDate.format(DF) : "Toàn bộ";
        String wh = warehouseName != null && !warehouseName.isEmpty() ? warehouseName : "Tất cả kho";

        buildDetailSheet(workbook, styles, range, wh, detailList);
        buildSummarySheet(workbook, styles, range, wh, summary);
        buildReasonSheet(workbook, styles, byReason);
        buildWarehouseSheet(workbook, styles, byWarehouse);
        buildModelSheet(workbook, styles, byModel);
        buildMonthlySheet(workbook, styles, monthly);

        return workbook;
    }

    private static final class Styles {
        final CellStyle title, info, header, data, money;
        Styles(CellStyle title, CellStyle info, CellStyle header, CellStyle data, CellStyle money) {
            this.title = title; this.info = info; this.header = header; this.data = data; this.money = money;
        }
    }

    private static BigDecimal bd(Object o) {
        return o instanceof BigDecimal ? (BigDecimal) o : BigDecimal.ZERO;
    }

    private static int num(Object o) {
        return o instanceof Number ? ((Number) o).intValue() : 0;
    }

    private static double dbl(Object o) {
        return o instanceof Number ? ((Number) o).doubleValue() : 0.0;
    }

    private static void writeHeaderBlock(XSSFSheet sheet, Styles s, String sheetTitle,
            String range, String wh, int colCount) {
        int r = 0;
        Row t = sheet.createRow(r);
        t.createCell(0).setCellValue(sheetTitle);
        t.getCell(0).setCellStyle(s.title);
        sheet.addMergedRegion(new CellRangeAddress(r, r, 0, colCount - 1));
        r++;

        Row d = sheet.createRow(r++);
        d.createCell(0).setCellValue("Ngày xuất: " + LocalDate.now().format(DF));
        d.getCell(0).setCellStyle(s.info);

        Row rg = sheet.createRow(r++);
        rg.createCell(0).setCellValue("Khoảng thời gian: " + range);
        rg.getCell(0).setCellStyle(s.info);

        Row w = sheet.createRow(r);
        w.createCell(0).setCellValue("Phạm vi kho: " + wh);
        w.getCell(0).setCellStyle(s.info);
    }

    private static Row makeHeaderRow(XSSFSheet sheet, Styles s, int rowNum, String[] headers) {
        Row hr = sheet.createRow(rowNum);
        for (int i = 0; i < headers.length; i++) {
            Cell c = hr.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(s.header);
        }
        return hr;
    }

    private static void cellStr(Row row, int col, String val, Styles s) {
        Cell c = row.createCell(col);
        c.setCellValue(val != null ? val : "");
        c.setCellStyle(s.data);
    }

    private static void cellInt(Row row, int col, int val, Styles s) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(s.data);
    }

    private static void cellMoney(Row row, int col, BigDecimal val, Styles s) {
        Cell c = row.createCell(col);
        c.setCellValue(val != null ? val.doubleValue() : 0d);
        c.setCellStyle(s.money);
    }

    private static void autoSize(XSSFSheet sheet, int cols) {
        for (int i = 0; i < cols; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    private static void buildDetailSheet(XSSFWorkbook wb, Styles s, String range, String wh, List<Map<String, Object>> rows) {
        XSSFSheet sheet = wb.createSheet("Chi tiết thanh lý");
        String[] headers = {"STT", "Mã đơn", "Serial", "Model", "Kho", "Lý do thanh lý",
            "Nguyên giá (VNĐ)", "Giá thanh lý (VNĐ)", "Tổn thất (VNĐ)", "Khách hàng", "CEO duyệt", "Ngày duyệt"};
        writeHeaderBlock(sheet, s, "BÁO CÁO THANH LÝ - CHI TIẾT", range, wh, headers.length);
        int r = 5;
        makeHeaderRow(sheet, s, r++, headers);

        BigDecimal sumOrig = BigDecimal.ZERO;
        BigDecimal sumLiq = BigDecimal.ZERO;
        BigDecimal sumLoss = BigDecimal.ZERO;
        int idx = 1;
        for (Map<String, Object> m : rows) {
            Row row = sheet.createRow(r++);
            cellInt(row, 0, idx++, s);
            cellStr(row, 1, (String) m.get("liquidationCode"), s);
            cellStr(row, 2, (String) m.get("serialNumber"), s);
            cellStr(row, 3, (String) m.get("modelName"), s);
            cellStr(row, 4, (String) m.get("warehouseName"), s);
            cellStr(row, 5, (String) m.get("reasonName"), s);
            cellMoney(row, 6, bd(m.get("originalPrice")), s);
            cellMoney(row, 7, bd(m.get("liquidationPrice")), s);
            cellMoney(row, 8, bd(m.get("totalLoss")), s);
            cellStr(row, 9, (String) m.get("customerName"), s);
            cellStr(row, 10, (String) m.get("ceoName"), s);
            cellStr(row, 11, (String) m.get("reviewedAtStr"), s);
            sumOrig = sumOrig.add(bd(m.get("originalPrice")));
            sumLiq = sumLiq.add(bd(m.get("liquidationPrice")));
            sumLoss = sumLoss.add(bd(m.get("totalLoss")));
        }

        // Dòng tổng cộng
        Row total = sheet.createRow(r);
        Cell label = total.createCell(0);
        label.setCellValue("TỔNG CỘNG (" + rows.size() + " máy)");
        label.setCellStyle(s.header);
        for (int c = 1; c <= 5; c++) {
            total.createCell(c).setCellStyle(s.header);
        }
        sheet.addMergedRegion(new CellRangeAddress(r, r, 0, 5));
        cellMoney(total, 6, sumOrig, s);
        cellMoney(total, 7, sumLiq, s);
        cellMoney(total, 8, sumLoss, s);
        for (int c = 9; c <= 11; c++) {
            total.createCell(c).setCellStyle(s.header);
        }

        autoSize(sheet, headers.length);
    }

    private static void buildSummarySheet(XSSFWorkbook wb, Styles s, String range, String wh, Map<String, Object> sum) {
        XSSFSheet sheet = wb.createSheet("Tổng quan");
        writeHeaderBlock(sheet, s, "BÁO CÁO THANH LÝ - TỔNG QUAN", range, wh, 2);
        int r = 5;
        makeHeaderRow(sheet, s, r++, new String[]{"Chỉ tiêu", "Giá trị"});

        Row r1 = sheet.createRow(r++);
        cellStr(r1, 0, "Số đơn đã thanh lý", s);
        cellInt(r1, 1, num(sum.get("orderCount")), s);

        Row r2 = sheet.createRow(r++);
        cellStr(r2, 0, "Số máy đã thanh lý", s);
        cellInt(r2, 1, num(sum.get("machineCount")), s);

        Row r3 = sheet.createRow(r++);
        cellStr(r3, 0, "Tổng nguyên giá (VNĐ)", s);
        cellMoney(r3, 1, bd(sum.get("totalOriginal")), s);

        Row r4 = sheet.createRow(r++);
        cellStr(r4, 0, "Tổng giá trị thu hồi (VNĐ)", s);
        cellMoney(r4, 1, bd(sum.get("totalLiquidation")), s);

        Row r5 = sheet.createRow(r++);
        cellStr(r5, 0, "Tổn thất (VNĐ)", s);
        cellMoney(r5, 1, bd(sum.get("totalLoss")), s);

        Row r6 = sheet.createRow(r++);
        cellStr(r6, 0, "Tỷ lệ thu hồi vốn (%)", s);
        Cell rate = r6.createCell(1);
        rate.setCellValue(dbl(sum.get("recoveryRate")));
        rate.setCellStyle(s.data);

        autoSize(sheet, 2);
    }

    private static void buildReasonSheet(XSSFWorkbook wb, Styles s, List<Map<String, Object>> rows) {
        XSSFSheet sheet = wb.createSheet("Theo lý do");
        String[] headers = {"STT", "Lý do thanh lý", "Số máy", "Nguyên giá (VNĐ)", "Thu hồi (VNĐ)", "Tổn thất (VNĐ)"};
        Row hr = makeHeaderRow(sheet, s, 0, headers);
        int r = 1, idx = 1;
        for (Map<String, Object> m : rows) {
            Row row = sheet.createRow(r++);
            cellInt(row, 0, idx++, s);
            cellStr(row, 1, (String) m.get("reasonName"), s);
            cellInt(row, 2, num(m.get("machineCount")), s);
            cellMoney(row, 3, bd(m.get("totalOriginal")), s);
            cellMoney(row, 4, bd(m.get("totalLiquidation")), s);
            cellMoney(row, 5, bd(m.get("totalLoss")), s);
        }
        autoSize(sheet, headers.length);
    }

    private static void buildWarehouseSheet(XSSFWorkbook wb, Styles s, List<Map<String, Object>> rows) {
        XSSFSheet sheet = wb.createSheet("Theo kho");
        String[] headers = {"STT", "Kho", "Số máy", "Nguyên giá (VNĐ)", "Thu hồi (VNĐ)", "Tổn thất (VNĐ)", "Tỷ lệ thu hồi (%)"};
        makeHeaderRow(sheet, s, 0, headers);
        int r = 1, idx = 1;
        for (Map<String, Object> m : rows) {
            Row row = sheet.createRow(r++);
            cellInt(row, 0, idx++, s);
            cellStr(row, 1, (String) m.get("warehouseName"), s);
            cellInt(row, 2, num(m.get("machineCount")), s);
            cellMoney(row, 3, bd(m.get("totalOriginal")), s);
            cellMoney(row, 4, bd(m.get("totalLiquidation")), s);
            cellMoney(row, 5, bd(m.get("totalLoss")), s);
            Cell rate = row.createCell(6);
            rate.setCellValue(dbl(m.get("recoveryRate")));
            rate.setCellStyle(s.data);
        }
        autoSize(sheet, headers.length);
    }

    private static void buildModelSheet(XSSFWorkbook wb, Styles s, List<Map<String, Object>> rows) {
        XSSFSheet sheet = wb.createSheet("Theo model");
        String[] headers = {"STT", "Model máy", "Số máy", "Nguyên giá (VNĐ)", "Thu hồi (VNĐ)", "Tổn thất (VNĐ)"};
        makeHeaderRow(sheet, s, 0, headers);
        int r = 1, idx = 1;
        for (Map<String, Object> m : rows) {
            Row row = sheet.createRow(r++);
            cellInt(row, 0, idx++, s);
            cellStr(row, 1, (String) m.get("modelName"), s);
            cellInt(row, 2, num(m.get("machineCount")), s);
            cellMoney(row, 3, bd(m.get("totalOriginal")), s);
            cellMoney(row, 4, bd(m.get("totalLiquidation")), s);
            cellMoney(row, 5, bd(m.get("totalLoss")), s);
        }
        autoSize(sheet, headers.length);
    }

    private static void buildMonthlySheet(XSSFWorkbook wb, Styles s, List<Map<String, Object>> rows) {
        XSSFSheet sheet = wb.createSheet("Xu hướng theo tháng");
        String[] headers = {"Tháng", "Số đơn", "Nguyên giá (VNĐ)", "Thu hồi (VNĐ)", "Tổn thất (VNĐ)"};
        makeHeaderRow(sheet, s, 0, headers);
        int r = 1;
        for (Map<String, Object> m : rows) {
            Row row = sheet.createRow(r++);
            cellStr(row, 0, (String) m.get("month"), s);
            cellInt(row, 1, num(m.get("orderCount")), s);
            cellMoney(row, 2, bd(m.get("totalOriginal")), s);
            cellMoney(row, 3, bd(m.get("totalLiquidation")), s);
            cellMoney(row, 4, bd(m.get("totalLoss")), s);
        }
        autoSize(sheet, headers.length);
    }
}
