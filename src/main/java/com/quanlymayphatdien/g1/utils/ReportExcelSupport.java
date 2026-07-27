/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.entity.InventoryReportItem;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
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
 *
 * @author Aadmin
 */
public class ReportExcelSupport {
    private static final XSSFColor HEADER_BG = new XSSFColor(new byte[]{(byte) 79, (byte) 129, (byte) 189}, null);

    public static XSSFWorkbook exportInventory(List<InventoryReportItem> data, int month, int year, String warehouseName) {
        XSSFWorkbook wb = createWorkbook("Tồn kho");
        XSSFSheet sheet = wb.getSheetAt(0);
        addHeader(wb, sheet, "BÁO CÁO TỒN KHO", month, year, warehouseName);

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle = createDataStyle(wb);

        String[] headers = {"STT", "Kho", "Mẫu máy", "Thương hiệu",
            "Tồn đầu kì", "Nhập trong kì", "Xuất trong kì", "Tồn cuối kì"};
        int rowNum = sheet.getLastRowNum() + 1;
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell c = headerRow.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (InventoryReportItem item : data) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(idx++);
            r.getCell(0).setCellStyle(dataStyle);
            r.createCell(1).setCellValue(item.getWarehouseName());
            r.getCell(1).setCellStyle(dataStyle);
            r.createCell(2).setCellValue(item.getModel());
            r.getCell(2).setCellStyle(dataStyle);
            r.createCell(3).setCellValue(item.getBrand());
            r.getCell(3).setCellStyle(dataStyle);
            r.createCell(4).setCellValue(item.getOpenQuantity());
            r.getCell(4).setCellStyle(dataStyle);
            r.createCell(5).setCellValue(item.getImportQuantity());
            r.getCell(5).setCellStyle(dataStyle);
            r.createCell(6).setCellValue(item.getExportQuantity());
            r.getCell(6).setCellStyle(dataStyle);
            r.createCell(7).setCellValue(item.getCloseQuantity());
            r.getCell(7).setCellStyle(dataStyle);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return wb;
    }
    
    public static XSSFWorkbook exportImport(List<Object[]> data, int month, int year, String warehouseName) {
        XSSFWorkbook wb = createWorkbook("Phiếu nhập");
        XSSFSheet sheet = wb.getSheetAt(0);
        addHeader(wb, sheet, "BÁO CÁO NHẬP KHO", month, year, warehouseName);

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle = createDataStyle(wb);

        String[] headers = {"STT", "Mã phiếu nhập", "Ngày nhập", "Kho", "Mã máy", "Serial", "Người tạo", "Ghi chú"};
        int rowNum = sheet.getLastRowNum() + 1;
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell c = headerRow.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (Object[] row : data) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(idx++);
            r.getCell(0).setCellStyle(dataStyle);
            for (int i = 0; i < row.length; i++) {
                r.createCell(i + 1).setCellValue(row[i] != null ? row[i].toString() : "");
                r.getCell(i + 1).setCellStyle(dataStyle);
            }
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return wb;
    }
    
    public static XSSFWorkbook exportExport(List<Object[]> data, int month, int year, String warehouseName) {
        XSSFWorkbook wb = createWorkbook("Phiếu xuất");
        XSSFSheet sheet = wb.getSheetAt(0);
        addHeader(wb, sheet, "BÁO CÁO XUẤT KHO", month, year, warehouseName);

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle = createDataStyle(wb);

        String[] headers = {"STT", "Mã phiếu xuất", "Ngày xuất", "Kho", "Khách hàng", "Mã máy", "Serial", "Người tạo", "Ghi chú"};
        int rowNum = sheet.getLastRowNum() + 1;
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell c = headerRow.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (Object[] row : data) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(idx++);
            r.getCell(0).setCellStyle(dataStyle);
            for (int i = 0; i < row.length; i++) {
                r.createCell(i + 1).setCellValue(row[i] != null ? row[i].toString() : "");
                r.getCell(i + 1).setCellStyle(dataStyle);
            }
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return wb;
    }
    
    public static XSSFWorkbook exportPurchase(List<Object[]> data, int month, int year, String warehouseName) {
        XSSFWorkbook wb = createWorkbook("Phiếu mua");
        XSSFSheet sheet = wb.getSheetAt(0);
        addHeader(wb, sheet, "BÁO CÁO MUA HÀNG", month, year, warehouseName);

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle = createDataStyle(wb);

        String[] headers = {"STT", "Mã phiếu mua", "Kho", "Kỳ", "Mặt hàng",
            "Số lượng", "Người tạo", "Ngày tạo", "Trạng thái"};
        int rowNum = sheet.getLastRowNum() + 1;
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell c = headerRow.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (Object[] row : data) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(idx++);
            r.getCell(0).setCellStyle(dataStyle);
            for (int i = 0; i < row.length; i++) {
                r.createCell(i + 1).setCellValue(row[i] != null ? row[i].toString() : "");
                r.getCell(i + 1).setCellStyle(dataStyle);
            }
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return wb;
    }
    
    public static XSSFWorkbook exportSales(List<Object[]> data, int month, int year) {
        XSSFWorkbook wb = createWorkbook("Đơn bán");
        XSSFSheet sheet = wb.getSheetAt(0);
        addHeader(wb, sheet, "BÁO CÁO BÁN HÀNG", month, year, null);

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle = createDataStyle(wb);

        String[] headers = {"STT", "Mã phiếu", "Kho", "Khách hàng",
            "Số lượng", "Tổng tiền", "Người tạo", "Ngày tạo"};
        int rowNum = sheet.getLastRowNum() + 1;
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell c = headerRow.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (Object[] row : data) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(idx++);
            r.getCell(0).setCellStyle(dataStyle);
            for (int i = 0; i < row.length; i++) {
                r.createCell(i + 1).setCellValue(row[i] != null ? row[i].toString() : "");
                r.getCell(i + 1).setCellStyle(dataStyle);
            }
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return wb;
    }
    
    private static XSSFWorkbook createWorkbook(String sheetName) {
        XSSFWorkbook wb = new XSSFWorkbook();
        wb.createSheet(sheetName);
        return wb;
    }
    
    private static void addHeader(XSSFWorkbook wb, XSSFSheet sheet, String title,
            int month, int year, String warehouseName) {
        XSSFFont titleFont = wb.createFont();
        titleFont.setFontName("Times New Roman");
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);

        XSSFFont infoFont = wb.createFont();
        infoFont.setFontName("Times New Roman");
        infoFont.setBold(true);
        infoFont.setFontHeightInPoints((short) 11);
        infoFont.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        CellStyle titleStyle = wb.createCellStyle();
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle infoStyle = wb.createCellStyle();
        infoStyle.setFont(infoFont);
        infoStyle.setFillForegroundColor(HEADER_BG);
        infoStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        infoStyle.setAlignment(HorizontalAlignment.CENTER);

        int lastCol = sheet.getRow(0) != null ? sheet.getRow(0).getLastCellNum() - 1 : 8;
        if (lastCol < 1) {
            lastCol = 8;
        }

        int rowNum = 0;
        Row tRow = sheet.createRow(rowNum);
        tRow.createCell(0).setCellValue("KHO QUẢN LÝ MÁY PHÁT ĐIỆN G1");
        tRow.getCell(0).setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, lastCol));
        rowNum++;

        Row dRow = sheet.createRow(rowNum);
        dRow.createCell(0).setCellValue("Ngày báo cáo: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        dRow.getCell(0).setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, lastCol));
        rowNum++;

        Row pRow = sheet.createRow(rowNum);
        pRow.createCell(0).setCellValue("Kì báo cáo: Tháng " + month + "/" + year);
        pRow.getCell(0).setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, lastCol));
        rowNum++;

        if (warehouseName != null && !warehouseName.isEmpty()) {
            Row wRow = sheet.createRow(rowNum);
            wRow.createCell(0).setCellValue("Kho: " + warehouseName);
            wRow.getCell(0).setCellStyle(infoStyle);
            sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, lastCol));
            rowNum++;
        }

        rowNum++;
    }
    
    private static CellStyle createHeaderStyle(XSSFWorkbook wb) {
        XSSFFont font = wb.createFont();
        font.setFontName("Times New Roman");
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        style.setFillForegroundColor(HEADER_BG);
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setBorderBottom(BorderStyle.THIN);
        return style;
    }

    private static CellStyle createDataStyle(XSSFWorkbook wb) {
        XSSFFont font = wb.createFont();
        font.setFontName("Times New Roman");
        font.setFontHeightInPoints((short) 11);

        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        return style;
    }
}
