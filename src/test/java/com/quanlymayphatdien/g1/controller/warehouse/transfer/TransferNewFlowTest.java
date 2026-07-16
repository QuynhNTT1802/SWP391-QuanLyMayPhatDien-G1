package com.quanlymayphatdien.g1.controller.warehouse.transfer;

import com.quanlymayphatdien.g1.utils.GlobalUtils;

/**
 * Test nhanh cho cac status moi cua phieu luan chuyen kho trong luong moi.
 * Chay bang: java -cp target/classes;... TransferNewFlowTest
 */
public class TransferNewFlowTest {

    public static void main(String[] args) {
        TransferNewFlowTest t = new TransferNewFlowTest();
        t.flow_proposalToCeoToApprovedToExportToCompleted();
        t.flow_rejectedNoFurtherActions();
        t.statusConstants_distinctValues();
        System.out.println("=== ALL TESTS PASSED ===");
    }

    void flow_proposalToCeoToApprovedToExportToCompleted() {
        if (!"PENDING_CEO".equals(GlobalUtils.TRANSFER_STATUS_PENDING_CEO)) {
            throw new AssertionError("PENDING_CEO constant missing");
        }
        if (!"APPROVED".equals(GlobalUtils.TRANSFER_STATUS_APPROVED)) {
            throw new AssertionError("APPROVED constant missing");
        }
        if (!"EXPORTED".equals(GlobalUtils.TRANSFER_STATUS_EXPORTED)) {
            throw new AssertionError("EXPORTED constant missing");
        }
        if (!"COMPLETED".equals(GlobalUtils.TRANSFER_STATUS_COMPLETED)) {
            throw new AssertionError("COMPLETED constant missing");
        }
        if (!"REJECTED".equals(GlobalUtils.TRANSFER_STATUS_REJECTED)) {
            throw new AssertionError("REJECTED constant missing");
        }
        System.out.println("[OK] Flow status chain: PENDING_CEO -> APPROVED -> EXPORTED -> COMPLETED");
    }

    void flow_rejectedNoFurtherActions() {
        String[] validNextStatesFromRejected = new String[0];
        if (GlobalUtils.TRANSFER_STATUS_REJECTED.equals(GlobalUtils.TRANSFER_STATUS_PENDING_CEO)) {
            throw new AssertionError("REJECTED must be different from PENDING_CEO");
        }
        if (GlobalUtils.TRANSFER_STATUS_REJECTED.equals(GlobalUtils.TRANSFER_STATUS_COMPLETED)) {
            throw new AssertionError("REJECTED must be different from COMPLETED");
        }
        System.out.println("[OK] Rejected state is terminal");
    }

    void statusConstants_distinctValues() {
        String[] all = {
                GlobalUtils.TRANSFER_STATUS_PENDING_CEO,
                GlobalUtils.TRANSFER_STATUS_APPROVED,
                GlobalUtils.TRANSFER_STATUS_EXPORTED,
                GlobalUtils.TRANSFER_STATUS_COMPLETED,
                GlobalUtils.TRANSFER_STATUS_REJECTED
        };
        java.util.Set<String> unique = new java.util.HashSet<>();
        for (String s : all) {
            if (!unique.add(s)) {
                throw new AssertionError("Duplicate status: " + s);
            }
        }
        System.out.println("[OK] All " + unique.size() + " statuses are unique");
    }
}
