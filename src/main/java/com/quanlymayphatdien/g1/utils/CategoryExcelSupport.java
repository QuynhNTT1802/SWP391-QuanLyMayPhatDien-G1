/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.CategoryBrand;
import com.quanlymayphatdien.g1.entity.CategoryCustomerType;
import com.quanlymayphatdien.g1.entity.CategoryFuelType;
import com.quanlymayphatdien.g1.entity.CategoryOrigin;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author LENOVO
 */
public class CategoryExcelSupport {

    private static String[] getHeaderColumns(String type) {
        String[] base = {"STT", "ID", "Tên danh mục", "Loại", "Mô tả", "Trạng thái", "Module"};
        if ("brand".equals(type)) {
            return new String[]{"STT", "ID", "Tên danh mục", "Loại", "Mô tả", "Trạng thái", "Module",
                "Quốc gia", "Website", "Năm thành lập", "Bảo hành"};
        }

        if ("fuel_type".equals(type)) {
            return new String[]{"STT", "ID", "Tên danh mục", "Loại", "Mô tả", "Trạng thái", "Module",
                "Đơn vị", "Giá tham khảo"};
        }

        if ("origin".equals(type)) {
            return new String[]{"STT", "ID", "Tên danh mục", "Loại", "Mô tả", "Trạng thái", "Module",
                "Mã quốc gia"};
        }

        if ("customer_type".equals(type)) {
            return new String[]{"STT", "ID", "Tên danh mục", "Loại", "Mô tả", "Trạng thái", "Module",
                "Loại thuế"};

        }
        return base;
    }

    public static XSSFWorkbook exportToWorkbook(List<Category> list, Map<Integer, Object> extensions, String type) {

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Danh mục");

        CellStyle headerStyle = workbook.createCellStyle();
        XSSFFont font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        headerStyle.setFont(font); // ← gán font vào style
        headerStyle.setFillForegroundColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 79, (byte) 129, (byte) 189}, null)); // màu xanh dương
        headerStyle.setFillPattern(org.apache.poi.ss.usermodel.FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(org.apache.poi.ss.usermodel.HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(org.apache.poi.ss.usermodel.BorderStyle.THIN);

        // Font trắng cho chữ trên nền xanh
        font.setColor(new org.apache.poi.xssf.usermodel.XSSFColor(
                new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

        String[] headers = getHeaderColumns(type);
        Row headerRow = sheet.createRow(0);

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }


        int rowNum = 1;
        for (Category c : list) {
            Row row = sheet.createRow(rowNum);

            row.createCell(0).setCellValue(rowNum);
            row.createCell(1).setCellValue(c.getId());
            row.createCell(2).setCellValue(c.getName());
            row.createCell(3).setCellValue(c.getType());
            row.createCell(4).setCellValue(c.getDescription() != null ? c.getDescription() : "");
            row.createCell(5).setCellValue(c.getStatus());
            row.createCell(6).setCellValue(c.getModule());

            Object ext = extensions != null ? extensions.get(c.getId()) : null;
            if ("brand".equals(type) && ext instanceof CategoryBrand) {
                CategoryBrand b = (CategoryBrand) ext;
                row.createCell(7).setCellValue(b.getCountry() != null ? b.getCountry() : "");
                row.createCell(8).setCellValue(b.getWebsite() != null ? b.getWebsite() : "");
                row.createCell(9).setCellValue(b.getFoundedYear() != null ? b.getFoundedYear() : 0);
                row.createCell(10).setCellValue(b.getWarrantyPeriod() != null ? b.getWarrantyPeriod() : 0);
            }

            if ("fuel_type".equals(type) && ext instanceof CategoryFuelType) {
                CategoryFuelType f = (CategoryFuelType) ext;
                row.createCell(7).setCellValue(f.getUnit() != null ? f.getUnit() : "");
                row.createCell(8).setCellValue((RichTextString) f.getTypicalPrice());
            }

            if ("origin".equals(type) && ext instanceof CategoryOrigin) {
                CategoryOrigin o = (CategoryOrigin) ext;
                row.createCell(7).setCellValue(o.getCountryCode() != null ? o.getCountryCode() : "");
            }

            if ("customer_type".equals(type) && ext instanceof CategoryCustomerType) {
                CategoryCustomerType ct = (CategoryCustomerType) ext;
                row.createCell(7).setCellValue(ct.getTaxType() != null ? ct.getTaxType() : "");
            }
            rowNum++;
        }
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        return workbook;
    }

    public static List<Map<String, String>> parseFromExcel(InputStream is, String type) throws IOException {
        List<Map<String, String>> result = new ArrayList<>();
        String[] headers = getHeaderColumns(type);

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
                Cell cell = row.getCell(j); // ← sửa: i → j
                String value = getCellValueAsString(cell);
                rowData.put(headers[j], value);
                if (!value.isEmpty()) {
                    isEmpty = false;
                }
            }

            if (!isEmpty) {
                result.add(rowData); // ← sửa: thêm dòng này để lưu kết quả
            }
        }
        workbook.close();
        return result;
    }

    private static String getCellValueAsString(Cell cell) {
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
