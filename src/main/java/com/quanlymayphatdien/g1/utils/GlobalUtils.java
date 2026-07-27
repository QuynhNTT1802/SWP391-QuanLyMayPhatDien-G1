package com.quanlymayphatdien.g1.utils;

public class GlobalUtils {

    public static final String REGEX_USERNAME = "^[a-zA-Z0-9_]+$";

    public static final String REGEX_PASSWORD = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$";

    public static final String REGEX_EMAIL
            = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    public static final String REGEX_PHONE = "^0[0-9]{9,10}$";
    
    public static final String PHONE_ERROR_MSG = "SĐT không hợp lệ (10-11 số, bắt đầu là 0).";

    public static final String PASSWORD_ERROR_MSG = "Mật khẩu phải có ít nhất 1 chữ hoa, 1 chữ thường và 1 số.";

    public static final String EMAIL_ERROR_MSG = "Email không hợp lệ.";


    
    public static final String SALE_ORDER_STATUS_PENDING = "PENDING";
    public static final String SALE_ORDER_STATUS_APPROVED = "APPROVED";
    public static final String SALE_ORDER_STATUS_REJECTED = "REJECTED";
    public static final String SALE_ORDER_STATUS_CANCELLED = "CANCELLED";
    public static final String SALE_ORDER_STATUS_DELETED = "DELETED";
    public static final String SALE_ORDER_STATUS_COMPLETED = "COMPLETED";
    public static final String SALE_ORDER_STATUS_NEEDS_REVISION = "NEEDS_REVISION";

 
    public static final String RECEIPT_STATUS_PENDING = "PENDING";
    public static final String RECEIPT_STATUS_COMPLETED = "COMPLETED";
    public static final String RECEIPT_STATUS_CANCELLED = "CANCELLED";

    
    public static final String PO_STATUS_PENDING_CEO = "PENDING_CEO";
    public static final String PO_STATUS_APPROVED = "APPROVED";
    public static final String PO_STATUS_REJECTED = "REJECTED";
    public static final String PO_STATUS_CANCELLED = "CANCELLED";

  
    public static final String IMPORT_PROPOSAL_STATUS_PENDING = "PENDING";
    public static final String IMPORT_PROPOSAL_STATUS_APPROVED = "APPROVED";
    public static final String IMPORT_PROPOSAL_STATUS_REJECTED = "REJECTED";
    public static final String IMPORT_PROPOSAL_STATUS_CANCELLED = "CANCELLED";
    public static final String IMPORT_PROPOSAL_STATUS_DELETED = "DELETED";
    public static final String IMPORT_PROPOSAL_STATUS_COMPLETED = "COMPLETED";
    public static final String IMPORT_PROPOSAL_STATUS_PENDING_CEO = "PENDING_CEO";
    public static final String IMPORT_PROPOSAL_STATUS_NEEDS_REVISION = "NEEDS_REVISION";

    public static final String REVISION_REQUESTER_SM = "SM";
    public static final String REVISION_REQUESTER_CEO = "CEO";

    public static final int PROPOSAL_DEADLINE_DAY = 5;

   
    public static final String TRANSFER_STATUS_PENDING_CEO = "PENDING_CEO";
    public static final String TRANSFER_STATUS_APPROVED = "APPROVED";
    public static final String TRANSFER_STATUS_EXPORTED = "EXPORTED";
    public static final String TRANSFER_STATUS_COMPLETED = "COMPLETED";
    public static final String TRANSFER_STATUS_REJECTED = "REJECTED";
    public static final String TRANSFER_STATUS_REQUEST_REVISION = "REQUEST_REVISION";

    
    public static final String LIQUIDATION_STATUS_PENDING_CEO = "PENDING_CEO";
    public static final String LIQUIDATION_STATUS_APPROVED = "APPROVED";
    public static final String LIQUIDATION_STATUS_COMPLETED = "COMPLETED";
    public static final String LIQUIDATION_STATUS_CEO_REQUEST_EDIT = "CEO_REQUEST_EDIT";
    public static final String LIQUIDATION_STATUS_CANCELLED = "CANCELLED";

    
    public static final String INVENTORY_STATUS_IN_STOCK = "IN_STOCK";
    public static final String INVENTORY_STATUS_SOLD = "SOLD";
    public static final String INVENTORY_STATUS_PENDING_LIQUIDATION = "PENDING_LIQUIDATION";
    public static final String INVENTORY_STATUS_IN_TRANSIT = "IN_TRANSIT";
   
}
