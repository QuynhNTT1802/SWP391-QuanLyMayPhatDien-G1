/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.PurchaseOrderDetail;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author FPTShop
 */
public class ReceiptExcelSupport {

    public static final String COL_MODEL = "Mã máy";
    public static final String COL_SERIAL = "Serial";
    public static final String COL_QUANTITY = "Số lượng";
    public static final String COL_NOTE = "Ghi chú";

    public static final String[] HEADERS = {COL_MODEL, COL_SERIAL, COL_NOTE};

    public static final int MAX_ROWS = 5000;

    public static XSSFWorkbook createTemplateWorkbook() {
        return createTemplateWorkbook(null);
    }

    public static XSSFWorkbook createTemplateWorkbook(List<PurchaseOrderDetail> poDetails) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Phiếu nhập (Mẫu)");

        XSSFFont font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFont(font);
        headerStyle.setFillForegroundColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 79, (byte) 129, (byte) 189}, null));
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < HEADERS.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(HEADERS[i] + (i == 0 || i == 1 ? " (*)" : ""));
            cell.setCellStyle(headerStyle);
        }

        int rowIndex = 1;
        if (poDetails != null) {
            for (PurchaseOrderDetail pod : poDetails) {
                int qty = pod.getFinalQuantity() > 0 ? pod.getFinalQuantity()
                        : (pod.getProposedQuantity() > 0 ? pod.getProposedQuantity() : 1);
                for (int k = 0; k < qty && rowIndex <= MAX_ROWS; k++) {
                    Row row = sheet.createRow(rowIndex++);
                    row.createCell(0).setCellValue(pod.getGeneratorCode() != null ? pod.getGeneratorCode() : "");
                    row.createCell(1).setCellValue("");
                    row.createCell(2).setCellValue("");
                }
            }
        }

        for (int i = 0; i < HEADERS.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return workbook;
    }

    public static XSSFWorkbook createTemplateWorkbook(List<ReceiptDetail> details, List<Generator> generators) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Phiếu nhập (Mẫu)");

        XSSFFont font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFont(font);
        headerStyle.setFillForegroundColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 79, (byte) 129, (byte) 189}, null));
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < HEADERS.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(HEADERS[i] + " (*)");
            cell.setCellStyle(headerStyle);
        }

        Map<Integer, Generator> genMap = new LinkedHashMap<>();
        if (generators != null) {
            for (Generator g : generators) {
                genMap.put(g.getId(), g);
            }
        }

        int rowIndex = 1;
        if (details != null) {
            for (ReceiptDetail d : details) {
                if (rowIndex > MAX_ROWS) break;
                Row row = sheet.createRow(rowIndex++);
                Generator g = genMap.get(d.getGeneratorId());
                row.createCell(0).setCellValue(g != null ? g.getModel() : "");
                row.createCell(1).setCellValue("");
                row.createCell(2).setCellValue(d.getNote() != null ? d.getNote() : "");
            }
        }

        for (int i = 0; i < HEADERS.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return workbook;
    }

    public static List<Map<String, String>> parseFromExcel(InputStream is) throws IOException {
        List<Map<String, String>> result = new ArrayList<>();
        XSSFWorkbook workbook = new XSSFWorkbook(is);
        XSSFSheet sheet = workbook.getSheetAt(0);

        if (sheet.getLastRowNum() < 1) {
            workbook.close();
            return result;
        }

        Row headerRow = sheet.getRow(0);
        if (headerRow == null) {
            workbook.close();
            return result;
        }

        String[] headers = new String[HEADERS.length];
        for (int i = 0; i < HEADERS.length; i++) {
            String raw = getCellValueAsString(headerRow.getCell(i));
            raw = stripRequiredMarker(raw);
            headers[i] = raw;
        }

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            if (result.size() >= MAX_ROWS) {
                break;
            }
            Row row = sheet.getRow(i);
            if (row == null) {
                continue;
            }

            Map<String, String> rowData = new LinkedHashMap<>();
            boolean isEmpty = true;
            for (int j = 0; j < HEADERS.length; j++) {
                Cell cell = row.getCell(j);
                String value = getCellValueAsString(cell);
                String key = canonicalHeader(headers[j]);
                if (key == null) {
                    key = (headers[j] != null && !headers[j].isEmpty()) ? headers[j] : HEADERS[j];
                }
                rowData.put(key, value);
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

    /**
     * Bo dau " (*)" o cuoi header (template tu danh dau cot bat buoc).
     * "Ma may (*)" -> "Ma may", "Serial (*)" -> "Serial".
     */
    private static String stripRequiredMarker(String s) {
        if (s == null) return "";
        return s.replaceAll("\\s*\\(\\*\\)\\s*$", "").trim();
    }

    /**
     * Map mot ten cot Excel ve canonical key (COL_MODEL / COL_SERIAL / COL_NOTE)
     * de controller co the tra cuu nhat quan. So khop khong phan biet hoa thuong
     va khong dau (Vi khong dau).
     *
     * Tra ve null neu khong nhan dien duoc.
     */
    public static String canonicalHeader(String header) {
        if (header == null) return null;
        String normalized = removeDiacritics(header.trim().toLowerCase());
        if (normalized.isEmpty()) return null;

        if (matchesAny(normalized, "ma may", "model", "may phat", "may phat dien", "generator")) {
            return COL_MODEL;
        }
        if (matchesAny(normalized, "serial", "sn", "s/n", "so serial", "ma serial")) {
            return COL_SERIAL;
        }
        if (matchesAny(normalized, "ghi chu", "note", "notes")) {
            return COL_NOTE;
        }
        return null;
    }

    private static boolean matchesAny(String input, String... candidates) {
        for (String c : candidates) {
            if (input.equals(c)) return true;
        }
        return false;
    }

    private static String removeDiacritics(String s) {
        if (s == null) return "";
        String normalized = java.text.Normalizer.normalize(s, java.text.Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
    }

    public static XSSFWorkbook exportToWorkbook(List<ReceiptDetail> details, List<Generator> generators) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Phiếu nhập");

        XSSFFont font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFont(font);
        headerStyle.setFillForegroundColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 79, (byte) 129, (byte) 189}, null));
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);

        String[] exportHeaders = {"#", "Mã máy", "Brand", "Serial", "Ghi chú"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < exportHeaders.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(exportHeaders[i]);
            cell.setCellStyle(headerStyle);
        }

        Map<Integer, Generator> generatorMap = new LinkedHashMap<>();
        if (generators != null) {
            for (Generator g : generators) {
                generatorMap.put(g.getId(), g);
            }
        }

        int rowNum = 1;
        int idx = 1;
        for (ReceiptDetail d : details) {
            Row row = sheet.createRow(rowNum);
            row.createCell(0).setCellValue(idx++);
            Generator g = generatorMap.get(d.getGeneratorId());
            row.createCell(1).setCellValue(g != null ? g.getModel() : "");
            String brand = "";
            if (g != null && g.getCategories() != null) {
                for (com.quanlymayphatdien.g1.entity.Category c : g.getCategories()) {
                    if ("brand".equals(c.getType())) {
                        brand = c.getName();
                        break;
                    }
                }
            }
            row.createCell(2).setCellValue(brand);
            row.createCell(3).setCellValue(d.getSerialNumber() != null ? d.getSerialNumber() : "");
            row.createCell(4).setCellValue(d.getNote() != null ? d.getNote() : "");
            rowNum++;
        }

        for (int i = 0; i < exportHeaders.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return workbook;
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
