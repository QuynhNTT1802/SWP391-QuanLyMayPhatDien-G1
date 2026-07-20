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

    public static class DetailReportData {
        private final String generatorModel;
        private final List<StockCard> stockCards;
        public DetailReportData(String generatorModel, List<StockCard> stockCards) {
            this.generatorModel = generatorModel;
            this.stockCards = stockCards;
        }
        public String getGeneratorModel() { return generatorModel; }
        public List<StockCard> getStockCards() { return stockCards; }
    }

    public static XSSFWorkbook exportReport(String warehouseName,
            LocalDate fromDate, LocalDate toDate, List<DetailReportData> details) {
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

        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(HEADER_BG);
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        CellStyle infoStyle = workbook.createCellStyle();
        infoStyle.setFont(headerFont);
        infoStyle.setFillForegroundColor(HEADER_BG);
        infoStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        infoStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setFont(dataFont);

        String[] headers = {"STT", "Mã phiếu kiểm kê", "Loại giao dịch", "Số lượng thay đổi", "Số lượng sau", "Serial", "Người tạo", "Ngày tạo", "Ghi chú"};

        for (DetailReportData detail : details) {
            String sheetName = detail.getGeneratorModel();
            if (sheetName == null || sheetName.isEmpty()) {
                sheetName = "Unknown";
            }
            sheetName = sheetName.length() > 31 ? sheetName.substring(0, 31) : sheetName;
            XSSFSheet sheet = workbook.createSheet(sheetName);

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
            genRow.createCell(0).setCellValue("Máy phát: " + (detail.getGeneratorModel() != null ? detail.getGeneratorModel() : ""));
            genRow.getCell(0).setCellStyle(infoStyle);
            sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, COL_COUNT - 1));
            rowNum++;

            rowNum++;

            Row headerRow = sheet.createRow(rowNum++);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            int idx = 1;
            for (StockCard sc : detail.getStockCards()) {
                if (fromDate != null && toDate != null) {
                    LocalDate cardDate = sc.getCreatedAt() != null ? sc.getCreatedAt().toLocalDate() : null;
                    if (cardDate != null && (cardDate.isBefore(fromDate) || cardDate.isAfter(toDate))) {
                        continue;
                    }
                }
                Row row = sheet.createRow(rowNum++);
                Cell c0 = row.createCell(0); c0.setCellValue(idx++); c0.setCellStyle(dataStyle);
                Cell c1 = row.createCell(1); c1.setCellValue(sc.getReceiptCode() != null ? sc.getReceiptCode() : ""); c1.setCellStyle(dataStyle);
                Cell c2 = row.createCell(2); c2.setCellValue(sc.getTransactionType() != null ? sc.getTransactionType() : ""); c2.setCellStyle(dataStyle);
                Cell c3 = row.createCell(3); c3.setCellValue(sc.getQuantityChange()); c3.setCellStyle(dataStyle);
                Cell c4 = row.createCell(4); c4.setCellValue(sc.getQuantityAfter()); c4.setCellStyle(dataStyle);
                Cell c5 = row.createCell(5); c5.setCellValue(sc.getSerialList() != null ? sc.getSerialList() : ""); c5.setCellStyle(dataStyle);
                Cell c6 = row.createCell(6); c6.setCellValue(sc.getCreatedByName() != null ? sc.getCreatedByName() : ""); c6.setCellStyle(dataStyle);
                Cell c7 = row.createCell(7); c7.setCellValue(sc.getCreatedAt() != null
                        ? sc.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : ""); c7.setCellStyle(dataStyle);
                Cell c8 = row.createCell(8); c8.setCellValue(sc.getReferenceNote() != null ? sc.getReferenceNote() : ""); c8.setCellStyle(dataStyle);
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
        }

        return workbook;
    }
}