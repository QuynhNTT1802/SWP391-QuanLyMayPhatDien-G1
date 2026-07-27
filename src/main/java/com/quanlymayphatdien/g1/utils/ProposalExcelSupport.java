/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFColor;

/**
 *
 * @author Phuong Linh
 */
public class ProposalExcelSupport {

    public static final String HEADER_STT = "STT";
    public static final String HEADER_MODEL = "Mã máy phát";
    public static final String HEADER_UNIT_PRICE = "Đơn giá đề xuất (VNĐ)";
    public static final String HEADER_QUANTITY = "Số lượng";

    public static String[] getDetailHeaders() {
        return new String[]{
            HEADER_STT,
            HEADER_MODEL,
            HEADER_QUANTITY,
            HEADER_UNIT_PRICE
        };
    }

    private static CellStyle buildHeaderStyle(XSSFWorkbook workbook) {
        CellStyle headerStyle = workbook.createCellStyle();
        XSSFFont font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));
        headerStyle.setFont(font);
        headerStyle.setFillForegroundColor(new XSSFColor(
                new byte[]{(byte) 79, (byte) 129, (byte) 189}, null));
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        return headerStyle;
    }


    public static XSSFWorkbook createTemplateWorkbook() {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Chi tiết đề xuất (Mẫu)");

        String[] headers = getDetailHeaders();
        CellStyle headerStyle = buildHeaderStyle(workbook);

        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        {
            Row row = sheet.createRow(1);
            int col = 0;
            row.createCell(col++).setCellValue(1);
            row.createCell(col++).setCellValue("Cummins GEN83D2K");
            row.createCell(col++).setCellValue(2);
            row.createCell(col++).setCellValue(18_000_000);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return workbook;
    }

    public static List<Map<String, String>> parseFromExcel(InputStream is) throws IOException {
        List<Map<String, String>> result = new ArrayList<>();
        String[] headers = getDetailHeaders();

        XSSFWorkbook workbook = new XSSFWorkbook(is);
        XSSFSheet sheet = workbook.getSheetAt(0);

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) {
                continue;
            }

            Map<String, String> rowData = new LinkedHashMap<>();
            boolean isEmpty = true;

            for (int j = 0; j < headers.length; j++) {
                Cell cell = row.getCell(j);
                String value = getCellValueAsString(cell);
                rowData.put(headers[j], value);
                if (!value.isEmpty()) {
                    isEmpty = false;
                }
            }

            if (!isEmpty) {
                result.add(rowData);
            }
        }
        workbook.close();
        return result;
    }

    public static String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                double val = cell.getNumericCellValue();
                if (val == Math.floor(val)) {
                    return String.valueOf((long) val);
                }
                return String.valueOf(val);
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }
}
