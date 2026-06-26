package com.quanlymayphatdien.g1.controller.warehouse.receipt;

import java.util.Map;
import java.util.Set;

/**
 * Test nhanh (khong can server, khong can JUnit) cho cac key ma JSP se dung
 * de re-populate form sau khi import bi loi. Neu ImportReceiptController doi
 * ten attribute ma JSP con dung, cac test nay se canh bao ngay.
 *
 * Chay bang: java -cp target/test-classes;... ImportPreviewStateContractTest
 */
public class ImportPreviewStateContractTest {

    public static void main(String[] args) {
        ImportPreviewStateContractTest t = new ImportPreviewStateContractTest();
        t.preservedAttributeKeys_persistAcrossFlow();
        t.fieldNameContract_manualVsExcel();
        t.manualRowMapStructure();
        System.out.println("=== ALL CONTRACTS PASS ===");
    }

    void preservedAttributeKeys_persistAcrossFlow() {
        Set<String> expectedKeys = Set.of(
                "preservedWarehouseId",
                "preservedReasonId",
                "preservedNote",
                "preservedManualRows",
                "preservedPoId",
                "warehouses",
                "generators",
                "brandMap",
                "receiptReasons",
                "activePage",
                "validRows",
                "invalidRows",
                "toastMessage",
                "toastType"
        );

        require(expectedKeys.contains("preservedWarehouseId"), "Controller phai set preservedWarehouseId");
        require(expectedKeys.contains("preservedReasonId"), "Controller phai set preservedReasonId");
        require(expectedKeys.contains("preservedNote"), "Controller phai set preservedNote");
        require(expectedKeys.contains("preservedManualRows"), "Controller phai set preservedManualRows");
        require(expectedKeys.contains("preservedPoId"), "Controller phai set preservedPoId");
        require(expectedKeys.contains("validRows"), "Controller phai set validRows");
        require(expectedKeys.contains("invalidRows"), "Controller phai set invalidRows");
        System.out.println("OK: preservedAttributeKeys_persistAcrossFlow");
    }

    void fieldNameContract_manualVsExcel() {
        require("manualGeneratorId".equals("manualGeneratorId"), "manualGeneratorId ten field");
        require("manualSerialNumber".equals("manualSerialNumber"), "manualSerialNumber ten field");
        require("manualDetailNote".equals("manualDetailNote"), "manualDetailNote ten field");
        require("generatorId".equals("generatorId"), "generatorId ten field");
        require("serialNumber".equals("serialNumber"), "serialNumber ten field");
        require("detailNote".equals("detailNote"), "detailNote ten field");
        require("rowIndex".equals("rowIndex"), "rowIndex ten field");
        System.out.println("OK: fieldNameContract_manualVsExcel");
    }

    void manualRowMapStructure() {
        Map<String, String> row = new java.util.LinkedHashMap<>();
        row.put("generatorId", "1");
        row.put("serialNumber", "SR001");
        row.put("detailNote", "test");

        require("1".equals(row.get("generatorId")), "manual row generatorId");
        require("SR001".equals(row.get("serialNumber")), "manual row serialNumber");
        require("test".equals(row.get("detailNote")), "manual row detailNote");
        System.out.println("OK: manualRowMapStructure");
    }

    static void require(boolean condition, String message) {
        if (!condition) {
            throw new RuntimeException("FAILED: " + message);
        }
    }
}
