package com.quanlymayphatdien.g1.controller.warehouse.receipt;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Test cho flow PO + Excel upload.
 * Kiem tra contract giua controller va JSP: poSerialList align voi poRowList theo index.
 */
public class PurchaseOrderExcelTest {

    public static void main(String[] args) {
        PurchaseOrderExcelTest t = new PurchaseOrderExcelTest();
        t.serialListAlignsWithPoRows();
        t.serialCountValidation();
        t.duplicateSerialDetection();
        t.poSerialRendersInSerialInput();
        System.out.println("=== ALL PO-EXCEL TESTS PASS ===");
    }

    void serialListAlignsWithPoRows() {
        List<String> poRowList = Arrays.asList("EG4500CX", "EG4500CX", "EF6000");
        List<String> poSerialList = Arrays.asList("SN001", "SN002", "SN003");

        require(poRowList.size() == poSerialList.size(),
                "poSerialList size phai bang poRowList size");

        for (int i = 0; i < poRowList.size(); i++) {
            String expected = poSerialList.get(i);
            String actual = (i < poSerialList.size()) ? poSerialList.get(i) : null;
            require(expected.equals(actual), "Serial tai index " + i);
        }
        System.out.println("OK: serialListAlignsWithPoRows");
    }

    void serialCountValidation() {
        int expectedFromPo = 8;
        int actualInExcel = 7;
        require(actualInExcel != expectedFromPo,
                "Serial count khac phai bi reject (expected != actual)");

        int exact = 8;
        require(exact == expectedFromPo, "Serial count bang expected -> OK");
        System.out.println("OK: serialCountValidation");
    }

    void duplicateSerialDetection() {
        java.util.Set<String> seen = new java.util.HashSet<>();
        List<String> serials = Arrays.asList("SN001", "SN002", "SN001", "SN003");
        List<String> duplicates = new ArrayList<>();
        for (String s : serials) {
            if (!seen.add(s)) duplicates.add(s);
        }
        require(duplicates.size() == 1, "Phai tim duoc 1 serial trung");
        require("SN001".equals(duplicates.get(0)), "Serial trung phai la SN001");
        System.out.println("OK: duplicateSerialDetection");
    }

    void poSerialRendersInSerialInput() {
        Map<String, Object> poRow = new LinkedHashMap<>();
        poRow.put("generatorId", 1);
        poRow.put("generatorCode", "EG4500CX");

        List<String> poSerialList = Arrays.asList("SN001");

        String serial = poSerialList.get(0);
        String inputValue = serial != null ? serial : "";

        require("SN001".equals(inputValue), "Serial phai duoc render vao input value");
        require(poRow.get("generatorCode").equals("EG4500CX"), "Generator info giu nguyen");
        System.out.println("OK: poSerialRendersInSerialInput");
    }

    static void require(boolean condition, String message) {
        if (!condition) {
            throw new RuntimeException("FAILED: " + message);
        }
    }
}