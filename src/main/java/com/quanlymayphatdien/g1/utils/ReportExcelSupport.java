/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;

import org.apache.poi.xssf.usermodel.XSSFColor;

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

        String[] headers = {"STT", "Kho", "Mã máy", "Model", "Thương hiệu",
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
            r.createCell(2).setCellValue(String.valueOf(item.getGeneratorId()));
            r.getCell(2).setCellStyle(dataStyle);
            r.createCell(3).setCellValue(item.getModel());
            r.getCell(3).setCellStyle(dataStyle);
            r.createCell(4).setCellValue(item.getBrand());
            r.getCell(4).setCellStyle(dataStyle);
            r.createCell(5).setCellValue(item.getOpenQuantity());
            r.getCell(5).setCellStyle(dataStyle);
            r.createCell(6).setCellValue(item.getImportQuantity());
            r.getCell(6).setCellStyle(dataStyle);
            r.createCell(7).setCellValue(item.getExportQuantity());
            r.getCell(7).setCellStyle(dataStyle);
            r.createCell(8).setCellValue(item.getCloseQuantity());
            r.getCell(8).setCellStyle(dataStyle);
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
    
    public static XSSFWorkbook exportInventoryCheck(List<InventoryCheckReportItem> data, int month, int year, String warehouseName) {
        XSSFWorkbook wb = createWorkbook("Kiểm kê");
        XSSFSheet sheet = wb.getSheetAt(0);
        addHeader(wb, sheet, "BÁO CÁO KIỂM KÊ", month, year, warehouseName);

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle = createDataStyle(wb);

        String[] headers = {"STT", "Mã phiếu kiểm kê", "Kho", "Mã máy", "Model",
            "SL hệ thống", "SL thực tế", "Chênh lệch", "Người tạo", "Trạng thái"};
        int rowNum = sheet.getLastRowNum() + 1;
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell c = headerRow.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (InventoryCheckReportItem item : data) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(idx++);
            r.getCell(0).setCellStyle(dataStyle);
            r.createCell(1).setCellValue(item.getCheckCode());
            r.getCell(1).setCellStyle(dataStyle);
            r.createCell(2).setCellValue(item.getWarehouseName());
            r.getCell(2).setCellStyle(dataStyle);
            r.createCell(3).setCellValue(String.valueOf(item.getGeneratorId()));
            r.getCell(3).setCellStyle(dataStyle);
            r.createCell(4).setCellValue(item.getGeneratorModel());
            r.getCell(4).setCellStyle(dataStyle);
            r.createCell(5).setCellValue(item.getSystemQuantity());
            r.getCell(5).setCellStyle(dataStyle);
            r.createCell(6).setCellValue(item.getActualQuantity());
            r.getCell(6).setCellStyle(dataStyle);
            r.createCell(7).setCellValue(item.getDiscrepancy());
            r.getCell(7).setCellStyle(dataStyle);
            r.createCell(8).setCellValue(item.getCreatedByName());
            r.getCell(8).setCellStyle(dataStyle);
            String st = "doing".equals(item.getStatus()) ? "Đang kiểm kê" : "Hoàn thành";
            r.createCell(9).setCellValue(st);
            r.getCell(9).setCellStyle(dataStyle);
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

        String[] headers = {"STT", "Mã đơn hàng", "Ngày đặt", "Khách hàng", "Mặt hàng",
            "Tổng tiền", "Người tạo", "Trạng thái"};
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
}
