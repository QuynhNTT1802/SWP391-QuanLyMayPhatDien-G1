package com.quanlymayphatdien.g1.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * Test thu cong (khong can JUnit) de kiem tra parseFromExcel xu ly dung
 * header co dau " (*)" va header tieng Viet co dau.
 *
 * Chay bang: java -cp target/classes;<tomcat-home>/lib/*;<tomcat-lib>... ReceiptExcelSupportTest
 * Hoac don gian: copy test nay vao main, chay, roi xoa.
 *
 * Trong moi truong khong co test framework, ta su dung main() co san.
 */
public class ReceiptExcelSupportTest {

    public static void main(String[] args) throws Exception {
        System.out.println("=== Test 1: Template mac dinh (Mã máy (*) | Serial (*) | Ghi chú) ===");
        testTemplateDefault();

        System.out.println("\n=== Test 2: User tu tao file voi header tuy y ===");
        testCustomHeaders();

        System.out.println("\n=== Test 3: canonicalHeader voi nhieu bien the ===");
        testCanonicalHeader();

        System.out.println("\n=== Test 4: Strip (*) suffix voi cac bien the ===");
        testStripRequiredMarker();

        System.out.println("\n=== ALL TESTS PASSED ===");
    }

    static void testStripRequiredMarker() throws Exception {
        java.lang.reflect.Method m = ReceiptExcelSupport.class.getDeclaredMethod("stripRequiredMarker", String.class);
        m.setAccessible(true);
        checkStrip(m, "Mã máy (*)", "Mã máy");
        checkStrip(m, "Serial (*)", "Serial");
        checkStrip(m, "Mã máy(*)", "Mã máy");
        checkStrip(m, "Mã máy  (*)", "Mã máy");
        checkStrip(m, "Mã máy", "Mã máy");
        checkStrip(m, "", "");
        checkStrip(m, null, "");
        checkStrip(m, "(*)", "");
        System.out.println("OK: 8 truong hop stripRequiredMarker deu dung");
    }

    static void checkStrip(java.lang.reflect.Method m, String input, String expected) throws Exception {
        String actual = (String) m.invoke(null, input);
        if (!java.util.Objects.equals(expected, actual)) {
            throw new RuntimeException("stripRequiredMarker(\"" + input + "\") expected \""
                    + expected + "\" but got \"" + actual + "\"");
        }
    }

    static void testTemplateDefault() throws Exception {
        XSSFWorkbook wb = ReceiptExcelSupport.createTemplateWorkbook();
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        wb.write(out);
        wb.close();

        try (InputStream in = new ByteArrayInputStream(out.toByteArray())) {
            List<Map<String, String>> rows = ReceiptExcelSupport.parseFromExcel(in);
            if (!rows.isEmpty()) {
                throw new RuntimeException("Template mac dinh khong co data, phai tra ve 0 rows");
            }
            System.out.println("OK: Template khong co data -> 0 rows");
        }

        wb = ReceiptExcelSupport.createTemplateWorkbook();
        org.apache.poi.xssf.usermodel.XSSFSheet sh = wb.getSheetAt(0);
        org.apache.poi.ss.usermodel.Row dataRow = sh.createRow(1);
        dataRow.createCell(0).setCellValue("EG4500CX");
        dataRow.createCell(1).setCellValue("SN001");
        dataRow.createCell(2).setCellValue("");
        ByteArrayOutputStream out2 = new ByteArrayOutputStream();
        wb.write(out2);
        wb.close();

        try (InputStream in = new ByteArrayInputStream(out2.toByteArray())) {
            List<Map<String, String>> rows = ReceiptExcelSupport.parseFromExcel(in);
            if (rows.size() != 1) {
                throw new RuntimeException("Expected 1 row, got " + rows.size());
            }
            Map<String, String> row = rows.get(0);
            if (!row.containsKey(ReceiptExcelSupport.COL_MODEL)) {
                throw new RuntimeException("Key COL_MODEL khong ton tai. Keys = " + row.keySet());
            }
            if (!row.containsKey(ReceiptExcelSupport.COL_SERIAL)) {
                throw new RuntimeException("Key COL_SERIAL khong ton tai");
            }
            if (!"EG4500CX".equals(row.get(ReceiptExcelSupport.COL_MODEL))) {
                throw new RuntimeException("Expected EG4500CX, got " + row.get(ReceiptExcelSupport.COL_MODEL));
            }
            if (!"SN001".equals(row.get(ReceiptExcelSupport.COL_SERIAL))) {
                throw new RuntimeException("Expected SN001, got " + row.get(ReceiptExcelSupport.COL_SERIAL));
            }
            System.out.println("OK: Template + 1 dong data parse dung, keys khop canonical");
        }
    }

    static void testCustomHeaders() throws Exception {
        XSSFWorkbook wb = new XSSFWorkbook();
        org.apache.poi.xssf.usermodel.XSSFSheet sh = wb.createSheet("Test");

        org.apache.poi.ss.usermodel.Row headerRow = sh.createRow(0);
        headerRow.createCell(0).setCellValue("Model");
        headerRow.createCell(1).setCellValue("SN");
        headerRow.createCell(2).setCellValue("Note");

        org.apache.poi.ss.usermodel.Row dataRow = sh.createRow(1);
        dataRow.createCell(0).setCellValue("EG4500CX");
        dataRow.createCell(1).setCellValue("ABC123");
        dataRow.createCell(2).setCellValue("test note");

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        wb.write(out);
        wb.close();

        try (InputStream in = new ByteArrayInputStream(out.toByteArray())) {
            List<Map<String, String>> rows = ReceiptExcelSupport.parseFromExcel(in);
            if (rows.size() != 1) {
                throw new RuntimeException("Expected 1 row, got " + rows.size());
            }
            Map<String, String> row = rows.get(0);
            if (!row.containsKey(ReceiptExcelSupport.COL_MODEL)) {
                throw new RuntimeException("Model header khong map duoc. Keys = " + row.keySet());
            }
            if (!row.containsKey(ReceiptExcelSupport.COL_SERIAL)) {
                throw new RuntimeException("SN header khong map duoc");
            }
            System.out.println("OK: Header tuy y 'Model' va 'SN' van map dung canonical key");
        }
    }

    static void testCanonicalHeader() {
        checkCanonical("Mã máy", ReceiptExcelSupport.COL_MODEL);
        checkCanonical("Serial", ReceiptExcelSupport.COL_SERIAL);
        checkCanonical("Ghi chú", ReceiptExcelSupport.COL_NOTE);
        checkCanonical("Model", ReceiptExcelSupport.COL_MODEL);
        checkCanonical("SN", ReceiptExcelSupport.COL_SERIAL);
        checkCanonical("S/N", ReceiptExcelSupport.COL_SERIAL);
        checkCanonical("máy phát", ReceiptExcelSupport.COL_MODEL);
        checkCanonical("generator", ReceiptExcelSupport.COL_MODEL);
        checkCanonical("Note", ReceiptExcelSupport.COL_NOTE);
        checkCanonical("ghi chú", ReceiptExcelSupport.COL_NOTE);
        checkCanonical("UNKNOWN", null);
        checkCanonical(null, null);
        checkCanonical("", null);
        System.out.println("OK: 12 truong hop canonicalHeader deu dung");
    }

    static void checkCanonical(String input, String expected) {
        String actual = ReceiptExcelSupport.canonicalHeader(input);
        if (!java.util.Objects.equals(expected, actual)) {
            throw new RuntimeException("canonicalHeader(\"" + input + "\") expected "
                    + expected + " but got " + actual);
        }
    }
}
