/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.Supplier;
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
    public static final String HEADER_BRAND = "Thương hiệu";
    public static final String HEADER_ORIGIN = "Xuất xứ";
    public static final String HEADER_CONDITION = "Tình trạng";
    public static final String HEADER_FUEL = "Nhiên liệu";
    public static final String HEADER_PHASE = "Số pha";
    public static final String HEADER_GEN_TYPE = "Loại máy phát";
    public static final String HEADER_POWER = "Công suất (kVA)";
    public static final String HEADER_FREQUENCY = "Tần số";
    public static final String HEADER_WEIGHT = "Trọng lượng (kg)";
    public static final String HEADER_DESCRIPTION = "Mô tả";
    public static final String HEADER_SUPPLIER_NAME = "Tên nhà cung cấp";
    public static final String HEADER_UNIT_PRICE = "Đơn giá đề xuất (VNĐ)";
    public static final String HEADER_QUANTITY = "Số lượng";
    public static final String HEADER_NOTE = "Ghi chú dòng";

    public static String[] getDetailHeaders() {
        return new String[]{
            HEADER_STT,
            HEADER_MODEL,
            HEADER_BRAND,
            HEADER_ORIGIN,
            HEADER_CONDITION,
            HEADER_FUEL,
            HEADER_PHASE,
            HEADER_GEN_TYPE,
            HEADER_POWER,
            HEADER_FREQUENCY,
            HEADER_WEIGHT,
            HEADER_DESCRIPTION,
            HEADER_SUPPLIER_NAME,
            HEADER_UNIT_PRICE,
            HEADER_QUANTITY,
            HEADER_NOTE
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

    /**
     * Tạo file mẫu Excel với 16 cột. Mỗi sample row điền đủ thông tin máy (tham khảo) +
     * tên nhà cung cấp + đơn giá + số lượng để người dùng đối chiếu.
     *
     * @param sampleGenerators danh sách máy phát active (tối đa 3 sẽ được lấy làm mẫu)
     * @param sampleSuppliers  danh sách NCC active (tối đa 3 sẽ được lấy làm mẫu)
     * @param categoryMapByType map[type → Map<categoryId, name>] cho brand/origin/condition/fuel/phase/gen_type
     */
    public static XSSFWorkbook createTemplateWorkbook(
            List<Generator> sampleGenerators,
            List<Supplier> sampleSuppliers,
            Map<String, Map<Integer, String>> categoryMapByType) {
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

        // Luôn chỉ dùng 1 dòng mẫu static (Honda), không lấy từ DB
        {
            Row row = sheet.createRow(1);
            int col = 0;
            row.createCell(col++).setCellValue(1);
            row.createCell(col++).setCellValue("EG4500CX");
            row.createCell(col++).setCellValue("Honda");
            row.createCell(col++).setCellValue("Nhật Bản");
            row.createCell(col++).setCellValue("Mới");
            row.createCell(col++).setCellValue("Xăng");
            row.createCell(col++).setCellValue("1 pha");
            row.createCell(col++).setCellValue("Dân dụng");
            row.createCell(col++).setCellValue(4.5);
            row.createCell(col++).setCellValue("50Hz");
            row.createCell(col++).setCellValue(85);
            row.createCell(col++).setCellValue("Máy phát điện Honda 4.5kVA, chạy xăng, 1 pha");
            row.createCell(col++).setCellValue("Công ty Máy Phát Điện Đông Dương");
            row.createCell(col++).setCellValue(18_000_000);
            row.createCell(col++).setCellValue(2);
            row.createCell(col++).setCellValue("");
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        return workbook;
    }

    private static String pickCategoryName(Generator g, String type, Map<Integer, String> map) {
        if (g == null || g.getCategories() == null) {
            return "";
        }
        for (Category c : g.getCategories()) {
            if (type.equals(c.getType())) {
                String n = map.get(c.getId());
                if (n != null) {
                    return n;
                }
                return c.getName() != null ? c.getName() : "";
            }
        }
        return "";
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
