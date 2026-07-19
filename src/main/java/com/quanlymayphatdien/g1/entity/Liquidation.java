/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class Liquidation {
    private int liquidationId;
    private String liquidationCode;
    private int createdBy;
    private String status;
    private int reasonId;
    private Integer ceoReviewedBy;
    private LocalDateTime ceoReviewedAt;
    private Integer ceoFeedbackId;
    private Integer convertedReceiptId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private String createdByName;
    private String reasonName;
    private String ceoFeedbackName;
    
    // New fields
    private int warehouseId;
    private Integer customerId;
    private String warehouseName;
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String customerAddress;

    private List<LiquidationDetail> details;

    // Aggregated summary fields (populated by listing query)
    private Integer detailCount;
    private BigDecimal totalOriginalPrice;
    private BigDecimal totalLiquidationPrice;

    public Liquidation() {
    }

    public Liquidation(int liquidationId, String liquidationCode, int createdBy, String status, int reasonId, Integer ceoReviewedBy, LocalDateTime ceoReviewedAt, Integer ceoFeedbackId, Integer convertedReceiptId, LocalDateTime createdAt, LocalDateTime updatedAt, String createdByName, String reasonName, String ceoFeedbackName, List<LiquidationDetail> details) {
        this.liquidationId = liquidationId;
        this.liquidationCode = liquidationCode;
        this.createdBy = createdBy;
        this.status = status;
        this.reasonId = reasonId;
        this.ceoReviewedBy = ceoReviewedBy;
        this.ceoReviewedAt = ceoReviewedAt;
        this.ceoFeedbackId = ceoFeedbackId;
        this.convertedReceiptId = convertedReceiptId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdByName = createdByName;
        this.reasonName = reasonName;
        this.ceoFeedbackName = ceoFeedbackName;
        this.details = details;
    }

    public int getLiquidationId() {
        return liquidationId;
    }

    public void setLiquidationId(int liquidationId) {
        this.liquidationId = liquidationId;
    }

    public String getLiquidationCode() {
        return liquidationCode;
    }

    public void setLiquidationCode(String liquidationCode) {
        this.liquidationCode = liquidationCode;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getReasonId() {
        return reasonId;
    }

    public void setReasonId(int reasonId) {
        this.reasonId = reasonId;
    }

    public Integer getCeoReviewedBy() {
        return ceoReviewedBy;
    }

    public void setCeoReviewedBy(Integer ceoReviewedBy) {
        this.ceoReviewedBy = ceoReviewedBy;
    }

    public LocalDateTime getCeoReviewedAt() {
        return ceoReviewedAt;
    }

    public void setCeoReviewedAt(LocalDateTime ceoReviewedAt) {
        this.ceoReviewedAt = ceoReviewedAt;
    }

    public Integer getCeoFeedbackId() {
        return ceoFeedbackId;
    }

    public void setCeoFeedbackId(Integer ceoFeedbackId) {
        this.ceoFeedbackId = ceoFeedbackId;
    }

    public Integer getConvertedReceiptId() {
        return convertedReceiptId;
    }

    public void setConvertedReceiptId(Integer convertedReceiptId) {
        this.convertedReceiptId = convertedReceiptId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getReasonName() {
        return reasonName;
    }

    public void setReasonName(String reasonName) {
        this.reasonName = reasonName;
    }

    public String getCeoFeedbackName() {
        return ceoFeedbackName;
    }

    public void setCeoFeedbackName(String ceoFeedbackName) {
        this.ceoFeedbackName = ceoFeedbackName;
    }

    public List<LiquidationDetail> getDetails() {
        return details;
    }

    public void setDetails(List<LiquidationDetail> details) {
        this.details = details;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public Integer getDetailCount() {
        return detailCount;
    }

    public void setDetailCount(Integer detailCount) {
        this.detailCount = detailCount;
    }

    public BigDecimal getTotalOriginalPrice() {
        return totalOriginalPrice;
    }

    public void setTotalOriginalPrice(BigDecimal totalOriginalPrice) {
        this.totalOriginalPrice = totalOriginalPrice;
    }

    public BigDecimal getTotalLiquidationPrice() {
        return totalLiquidationPrice;
    }

    public void setTotalLiquidationPrice(BigDecimal totalLiquidationPrice) {
        this.totalLiquidationPrice = totalLiquidationPrice;
    }
}
