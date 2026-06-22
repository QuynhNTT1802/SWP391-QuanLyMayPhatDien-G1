package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.entity.StockCard;
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

public class InventoryCheckExcelSupport {

    private static final XSSFColor HEADER_BG = new XSSFColor(new byte[]{(byte) 79, (byte) 129, (byte) 189}, null);
    private static final int COL_COUNT = 9;

    public static XSSFWorkbook exportReport(String generatorModel, String warehouseName,
            LocalDate fromDate, LocalDate toDate, List<StockCard> stockCards) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Báo cáo kiểm kê");

        XSSFFont titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);

        XSSFFont headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 11);
        headerFont.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle infoStyle = workbook.createCellStyle();
        infoStyle.setFont(headerFont);
        infoStyle.setFillForegroundColor(HEADER_BG);
        infoStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        infoStyle.setAlignment(HorizontalAlignment.CENTER);

        int rowNum = 0;

        Row titleRow = sheet.createRow(rowNum);
        titleRow.createCell(0).setCellValue("KHO QUẢN LÝ MÁY PHÁT ĐIỆN G1");
        titleRow.getCell(0).setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, COL_COUNT - 1));
        rowNum++;

        Row dateRow = sheet.createRow(rowNum);
        dateRow.createCell(0).setCellValue("Ngày báo cáo: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        dateRow.getCell(0).setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, COL_COUNT - 1));
        rowNum++;

        Row whRow = sheet.createRow(rowNum);
        whRow.createCell(0).setCellValue("Kho: " + (warehouseName != null ? warehouseName : ""));
        whRow.getCell(0).setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, COL_COUNT - 1));
        rowNum++;

        rowNum++;

        if (fromDate != null && toDate != null) {
            Row rangeRow = sheet.createRow(rowNum);
            rangeRow.createCell(0).setCellValue("Khoảng thời gian: "
                    + fromDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                    + " - " + toDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            rangeRow.getCell(0).setCellStyle(infoStyle);
            sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, COL_COUNT - 1));
            rowNum++;
        }

        Row genRow = sheet.createRow(rowNum);
        genRow.createCell(0).setCellValue("Máy phát: " + (generatorModel != null ? generatorModel : ""));
        genRow.getCell(0).setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, COL_COUNT - 1));
        rowNum++;

        rowNum++;

        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(HEADER_BG);
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        String[] headers = {"STT", "Mã phiếu kiểm kê", "Loại giao dịch", "Số lượng thay đổi", "Số lượng sau", "Serial", "Người tạo", "Ngày tạo", "Ghi chú"};
        Row headerRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        int idx = 1;
        for (StockCard sc : stockCards) {
            if (fromDate != null && toDate != null) {
                LocalDate cardDate = sc.getCreatedAt() != null ? sc.getCreatedAt().toLocalDate() : null;
                if (cardDate != null && (cardDate.isBefore(fromDate) || cardDate.isAfter(toDate))) {
                    continue;
                }
            }
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(idx++);
            row.createCell(1).setCellValue(sc.getReceiptCode() != null ? sc.getReceiptCode() : "");
            row.createCell(2).setCellValue(sc.getTransactionType() != null ? sc.getTransactionType() : "");
            row.createCell(3).setCellValue(sc.getQuantityChange());
            row.createCell(4).setCellValue(sc.getQuantityAfter());
            row.createCell(5).setCellValue(sc.getSerialList() != null ? sc.getSerialList() : "");
            row.createCell(6).setCellValue(sc.getCreatedByName() != null ? sc.getCreatedByName() : "");
            row.createCell(7).setCellValue(sc.getCreatedAt() != null
                    ? sc.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "");
            row.createCell(8).setCellValue(sc.getReferenceNote() != null ? sc.getReferenceNote() : "");
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return workbook;
    }
}
