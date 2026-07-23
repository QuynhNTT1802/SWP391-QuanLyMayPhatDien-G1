package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;

public class ReceiptDetailReportItem {
    private int receiptId;
    private String receiptCode;
    private LocalDateTime createdAt;
    private String warehouseName;
    private String model;
    private String serialNumber;
    private String createdByName;
    private String status;
    private Integer purchaseOrderId;
    private String purchaseOrderCode;
    private String customerName;
    private Integer orderId;
    private String orderCode;

    public int getReceiptId() { return receiptId; }
    public void setReceiptId(int receiptId) { this.receiptId = receiptId; }

    public String getReceiptCode() { return receiptCode; }
    public void setReceiptCode(String receiptCode) { this.receiptCode = receiptCode; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getPurchaseOrderId() { return purchaseOrderId; }
    public void setPurchaseOrderId(Integer purchaseOrderId) { this.purchaseOrderId = purchaseOrderId; }

    public String getPurchaseOrderCode() { return purchaseOrderCode; }
    public void setPurchaseOrderCode(String purchaseOrderCode) { this.purchaseOrderCode = purchaseOrderCode; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
}
