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

public class ReceiptReportExcelSupport {

    private static final XSSFColor HEADER_BG = new XSSFColor(new byte[]{(byte) 79, (byte) 129, (byte) 189}, null);
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static XSSFWorkbook exportReport(
            LocalDate fromDate, LocalDate toDate, String warehouseName,
            String receiptType, List<Map<String, Object>> rows) {

        boolean isImport = "IMPORT".equals(receiptType);
        String title = isImport ? "BÁO CÁO NHẬP KHO CHI TIẾT" : "BÁO CÁO XUẤT KHO CHI TIẾT";
        String sheetName = isImport ? "Báo cáo nhập kho" : "Báo cáo xuất kho";
        String refHeader = isImport ? "Mã phiếu mua" : "Mã đơn hàng / Thanh lý";

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

        CellStyle totalStyle = wb.createCellStyle();
        totalStyle.setFont(dataFont);
        totalStyle.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 242, (byte) 242, (byte) 242}, null));
        totalStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        totalStyle.setBorderTop(BorderStyle.MEDIUM);

        String range = DF.format(fromDate) + " - " + DF.format(toDate);
        String wh = warehouseName != null && !warehouseName.isEmpty() ? warehouseName : "Tất cả kho";

        String[] headers = {"STT", "Mã phiếu", "Ngày lập phiếu", "Kho", "Trạng thái",
                "Số máy", refHeader, "Ghi chú"};

        XSSFSheet sheet = wb.createSheet(sheetName);

        int r = 0;
        Row titleRow = sheet.createRow(r);
        titleRow.createCell(0).setCellValue(title);
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
        Row typeRow = sheet.createRow(r);
        typeRow.createCell(0).setCellValue("Loại phiếu: " + (isImport ? "Nhập kho" : "Xuất kho"));
        typeRow.getCell(0).setCellStyle(infoStyle);

        r++;
        Row hr = sheet.createRow(r);
        for (int i = 0; i < headers.length; i++) {
            Cell c = hr.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(headerStyle);
        }

        int idx = 1;
        int totalMachines = 0;
        for (Map<String, Object> m : rows) {
            r++;
            Row row = sheet.createRow(r);
            Cell stt = row.createCell(0);
            stt.setCellValue(idx++);
            stt.setCellStyle(numStyle);

            cellStr(row, 1, (String) m.get("receiptCode"), dataStyle);
            cellStr(row, 2, (String) m.get("createdAtStr"), dataStyle);
            cellStr(row, 3, (String) m.get("warehouseName"), dataStyle);
            cellStr(row, 4, statusLabel((String) m.get("status")), dataStyle);

            Cell qtyCell = row.createCell(5);
            Object mc = m.get("machineCount");
            int qty = mc instanceof Number ? ((Number) mc).intValue() : 0;
            qtyCell.setCellValue(qty);
            qtyCell.setCellStyle(numStyle);
            totalMachines += qty;

            if (isImport) {
                cellStr(row, 6, (String) m.get("purchaseOrderCode"), dataStyle);
            } else {
                String orderCode = (String) m.get("orderCode");
                String liqCode = (String) m.get("liquidationCode");
                StringBuilder sb = new StringBuilder();
                if (orderCode != null && !orderCode.isEmpty()) {
                    sb.append(orderCode);
                }
                if (liqCode != null && !liqCode.isEmpty()) {
                    if (sb.length() > 0) {
                        sb.append(" / ");
                    }
                    sb.append(liqCode);
                }
                cellStr(row, 6, sb.toString(), dataStyle);
            }
            cellStr(row, 7, (String) m.get("note"), dataStyle);
        }

        r++;
        Row total = sheet.createRow(r);
        Cell totalStt = total.createCell(0);
        totalStt.setCellValue("");
        totalStt.setCellStyle(totalStyle);

        Cell totalLabel = total.createCell(1);
        totalLabel.setCellValue("Tổng (" + rows.size() + " phiếu)");
        totalLabel.setCellStyle(totalStyle);
        sheet.addMergedRegion(new CellRangeAddress(r, r, 1, 4));
        for (int i = 2; i <= 4; i++) {
            Cell c = total.createCell(i);
            c.setCellStyle(totalStyle);
        }

        Cell totalQty = total.createCell(5);
        totalQty.setCellValue(totalMachines);
        totalQty.setCellStyle(totalStyle);

        for (int i = 6; i <= headers.length - 1; i++) {
            Cell c = total.createCell(i);
            c.setCellStyle(totalStyle);
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
            case "COMPLETED":
                return "Hoàn thành";
            case "PENDING":
                return "Chờ duyệt";
            case "CANCELLED":
                return "Đã huỷ";
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
