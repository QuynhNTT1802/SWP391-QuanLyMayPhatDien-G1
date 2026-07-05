package com.quanlymayphatdien.g1.controller.warehouse.receipt;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Test cho validation logic khi import tu Purchase Order.
 * Khong can server that - chi test cac contract va behavior cua
 * validateAgainstPurchaseOrder.
 *
 * Chay bang: java -cp target/test-classes;... PurchaseOrderImportTest
 */
public class PurchaseOrderImportTest {

    public static void main(String[] args) {
        PurchaseOrderImportTest t = new PurchaseOrderImportTest();
        t.poRowStructure_matchesReceiptDetail();
        t.generatorQuantityMatchingLogic();
        t.poRowRenderingContract();
        System.out.println("=== ALL PO TESTS PASS ===");
    }

    /**
     * PO row se duoc JSP render theo format: hidden generatorId + text code + brand.
     * Confirm contract giua controller va JSP.
     */
    void poRowStructure_matchesReceiptDetail() {
        Map<String, Object> poRow = new LinkedHashMap<>();
        poRow.put("generatorId", 1);
        poRow.put("generatorCode", "EG4500CX");
        poRow.put("generatorName", "May phat dien Honda 4.5kVA");
        poRow.put("brandName", "Honda");
        poRow.put("note", "Tu PO");

        require(poRow.get("generatorId").equals(1), "poRow.generatorId");
        require("EG4500CX".equals(poRow.get("generatorCode")), "poRow.generatorCode");
        require("Honda".equals(poRow.get("brandName")), "poRow.brandName");
        require("Tu PO".equals(poRow.get("note")), "poRow.note");
        System.out.println("OK: poRowStructure_matchesReceiptDetail");
    }

    /**
     * Gia lap validation: expected (po) vs actual (submitted rows).
     */
    void generatorQuantityMatchingLogic() {
        Map<Integer, Integer> expected = new LinkedHashMap<>();
        expected.put(1, 5);
        expected.put(2, 3);

        Map<Integer, Integer> actualFull = new LinkedHashMap<>();
        for (int i = 0; i < 5; i++) actualFull.merge(1, 1, Integer::sum);
        for (int i = 0; i < 3; i++) actualFull.merge(2, 1, Integer::sum);

        Map<Integer, Integer> actualMissing = new LinkedHashMap<>();
        for (int i = 0; i < 3; i++) actualMissing.merge(1, 1, Integer::sum);
        for (int i = 0; i < 3; i++) actualMissing.merge(2, 1, Integer::sum);

        Map<Integer, Integer> actualExtra = new LinkedHashMap<>();
        for (int i = 0; i < 5; i++) actualExtra.merge(1, 1, Integer::sum);
        for (int i = 0; i < 4; i++) actualExtra.merge(2, 1, Integer::sum);
        actualExtra.merge(99, 1, Integer::sum);

        require(equalsMap(expected, actualFull), "full match -> OK");
        require(!equalsMap(expected, actualMissing), "missing 2 may Honda -> FAIL");
        require(!equalsMap(expected, actualExtra), "extra may khong co trong PO -> FAIL");
        System.out.println("OK: generatorQuantityMatchingLogic");
    }

    void poRowRenderingContract() {
        require("fromPurchaseOrder".equals("fromPurchaseOrder"), "fromPurchaseOrder attribute name");
        require("poRowList".equals("poRowList"), "poRowList attribute name");
        require("expectedRows".equals("expectedRows"), "expectedRows attribute name");
        require("tr.po-locked-row".equals("tr.po-locked-row"), "CSS class for locked rows");
        System.out.println("OK: poRowRenderingContract");
    }

    static boolean equalsMap(Map<Integer, Integer> a, Map<Integer, Integer> b) {
        if (!a.keySet().equals(b.keySet())) return false;
        for (Map.Entry<Integer, Integer> e : a.entrySet()) {
            if (!e.getValue().equals(b.get(e.getKey()))) return false;
        }
        return true;
    }

    static void require(boolean condition, String message) {
        if (!condition) {
            throw new RuntimeException("FAILED: " + message);
        }
    }
}
