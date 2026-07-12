package com.quanlymayphatdien.g1.utils;

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

public class StockCardReportExcelSupport {

    private static final XSSFColor HEADER_BG = new XSSFColor(new byte[]{(byte) 79, (byte) 129, (byte) 189}, null);
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

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

        CellStyle numStyle = wb.createCellStyle();
        numStyle.setFont(dataFont);
        numStyle.setAlignment(HorizontalAlignment.CENTER);

        DateTimeFormatter dfDate = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        String range = dfDate.format(fromDate) + " - " + dfDate.format(toDate);
        String wh = warehouseName != null && !warehouseName.isEmpty() ? warehouseName : "Tất cả kho";

        String[] headers = {"STT", "Thời gian", "Loại", "Số lượng", "Tồn sau GD", "Kho", "Model", "Mã phiếu", "Ghi chú"};

        XSSFSheet sheet = wb.createSheet("Báo cáo thẻ kho");

        int r = 0;
        Row titleRow = sheet.createRow(r);
        titleRow.createCell(0).setCellValue("BÁO CÁO THẺ KHO CHI TIẾT");
        titleRow.getCell(0).setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(r, r, 0, headers.length - 1));

        r++;
        Row dateRow = sheet.createRow(r);
        dateRow.createCell(0).setCellValue("Ngày xuất: " + LocalDate.now().format(dfDate));
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

        int idx = 1;
        for (Map<String, Object> m : rows) {
            r++;
            Row row = sheet.createRow(r);
            Cell stt = row.createCell(0);
            stt.setCellValue(idx++);
            stt.setCellStyle(numStyle);

            cellStr(row, 1, (String) m.get("createdAtStr"), dataStyle);
            cellStr(row, 2, typeLabel((String) m.get("transactionType")), dataStyle);

            Cell qtyCell = row.createCell(3);
            Object qc = m.get("quantityChange");
            int qty = qc instanceof Number ? ((Number) qc).intValue() : 0;
            qtyCell.setCellValue(qty);
            qtyCell.setCellStyle(numStyle);

            Cell afterCell = row.createCell(4);
            Object qa = m.get("quantityAfter");
            int qaVal = qa instanceof Number ? ((Number) qa).intValue() : 0;
            afterCell.setCellValue(qaVal);
            afterCell.setCellStyle(numStyle);

            cellStr(row, 5, (String) m.get("warehouseName"), dataStyle);
            cellStr(row, 6, (String) m.get("generatorModel"), dataStyle);
            cellStr(row, 7, (String) m.get("receiptCode"), dataStyle);
            cellStr(row, 8, (String) m.get("referenceNote"), dataStyle);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        sheet.setColumnWidth(0, 1500);

        return wb;
    }

    private static String typeLabel(String type) {
        if (type == null) {
            return "";
        }
        if ("IMPORT".equals(type)) {
            return "Nhập";
        }
        if ("EXPORT".equals(type)) {
            return "Xuất";
        }
        return type;
    }

    private static void cellStr(Row row, int col, String val, CellStyle s) {
        Cell c = row.createCell(col);
        c.setCellValue(val != null ? val : "");
        c.setCellStyle(s);
    }
}