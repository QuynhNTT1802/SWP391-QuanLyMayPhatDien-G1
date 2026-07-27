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

public class InventoryReportExcelSupport {

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

        CellStyle numStyle = wb.createCellStyle();
        numStyle.setFont(dataFont);
        numStyle.setAlignment(HorizontalAlignment.CENTER);

        String range = DF.format(fromDate) + " - " + DF.format(toDate);
        String wh = warehouseName != null && !warehouseName.isEmpty() ? warehouseName : "Tất cả kho";

        String[] headers = {"STT", "Serial", "Trạng thái", "Model", "Hãng", "Kho", "Ngày nhập", "Mã phiếu nhập"};

        XSSFSheet sheet = wb.createSheet("Báo cáo tồn kho");

        int r = 0;
        Row titleRow = sheet.createRow(r);
        titleRow.createCell(0).setCellValue("BÁO CÁO TỒN KHO CHI TIẾT");
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

        int idx = 1;
        for (Map<String, Object> m : rows) {
            r++;
            Row row = sheet.createRow(r);
            Cell stt = row.createCell(0);
            stt.setCellValue(idx++);
            stt.setCellStyle(numStyle);

            cellStr(row, 1, (String) m.get("serialNumber"), dataStyle);
            cellStr(row, 2, statusLabel((String) m.get("status")), dataStyle);
            cellStr(row, 3, (String) m.get("generatorModel"), dataStyle);
            cellStr(row, 4, (String) m.get("generatorBrand"), dataStyle);
            cellStr(row, 5, (String) m.get("warehouseName"), dataStyle);
            cellStr(row, 6, (String) m.get("createdAtStr"), dataStyle);
            cellStr(row, 7, (String) m.get("importReceiptCode"), dataStyle);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        sheet.setColumnWidth(0, 1500);

        return wb;
    }

    private static String statusLabel(String status) {
        if (status == null) {
            return "";
        }
        switch (status) {
            case "IN_STOCK":
                return "Đang trong kho";
            case "SOLD":
                return "Đã bán";
            case "PENDING_LIQUIDATION":
                return "Chờ thanh lý";
            case "LIQUIDATED":
                return "Đã thanh lý";
            case "IN_TRANSIT":
                return "Đang vận chuyển";
            default:
                return status;
        }
    }

    private static void cellStr(Row row, int col, String val, CellStyle s) {
        Cell c = row.createCell(col);
        c.setCellValue(val != null ? val : "");
        c.setCellStyle(s);
    }
}