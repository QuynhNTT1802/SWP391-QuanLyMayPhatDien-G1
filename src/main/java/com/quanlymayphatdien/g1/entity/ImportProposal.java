/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Phuong Linh
 */
public class ImportProposal {

    private int proposalId;
    private String proposalCode;
    private String status;
    private int warehouseId;
    private int createdBy;
    private Integer approvedBy;
    private Integer rejectedBy;
    private LocalDateTime proposalDate;
    private String note;
    private String rejectReason;
    private LocalDateTime approvedAt;
    private LocalDateTime rejectedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // field phẳng để hiển thị (không map DB)
    private String warehouseName;
    private String createdByName;
    private String approvedByName;
    private String rejectedByName;
    private List<ImportProposalDetail> details;

    // field transient: đánh dấu phiếu có chứa máy chưa có trong kho (warehouse tự xử lý category)
    private transient Boolean hasNewGenerator;
    private Integer purchaseOrderId;
    private String period;
    private String poCode;

    public ImportProposal() {
    }

    public ImportProposal(int proposalId, String proposalCode, String status, int warehouseId, int createdBy, Integer approvedBy, Integer rejectedBy, LocalDateTime proposalDate, String note, String rejectReason, LocalDateTime approvedAt, LocalDateTime rejectedAt, LocalDateTime createdAt, LocalDateTime updatedAt, String warehouseName, String createdByName, String approvedByName, String rejectedByName, List<ImportProposalDetail> details, Boolean hasNewGenerator, Integer purchaseOrderId, String period, String poCode) {
        this.proposalId = proposalId;
        this.proposalCode = proposalCode;
        this.status = status;
        this.warehouseId = warehouseId;
        this.createdBy = createdBy;
        this.approvedBy = approvedBy;
        this.rejectedBy = rejectedBy;
        this.proposalDate = proposalDate;
        this.note = note;
        this.rejectReason = rejectReason;
        this.approvedAt = approvedAt;
        this.rejectedAt = rejectedAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.warehouseName = warehouseName;
        this.createdByName = createdByName;
        this.approvedByName = approvedByName;
        this.rejectedByName = rejectedByName;
        this.details = details;
        this.hasNewGenerator = hasNewGenerator;
        this.purchaseOrderId = purchaseOrderId;
        this.period = period;
        this.poCode = poCode;
    }
  

    public Integer getPurchaseOrderId() {
        return purchaseOrderId;
    }

    public void setPurchaseOrderId(Integer purchaseOrderId) {
        this.purchaseOrderId = purchaseOrderId;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getPoCode() {
        return poCode;
    }

    public void setPoCode(String poCode) {
        this.poCode = poCode;
    }
    

    public int getProposalId() {
        return proposalId;
    }

    public void setProposalId(int proposalId) {
        this.proposalId = proposalId;
    }

    public String getProposalCode() {
        return proposalCode;
    }

    public void setProposalCode(String proposalCode) {
        this.proposalCode = proposalCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Integer getRejectedBy() {
        return rejectedBy;
    }

    public void setRejectedBy(Integer rejectedBy) {
        this.rejectedBy = rejectedBy;
    }

    public LocalDateTime getProposalDate() {
        return proposalDate;
    }

    public void setProposalDate(LocalDateTime proposalDate) {
        this.proposalDate = proposalDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
    }

    public LocalDateTime getRejectedAt() {
        return rejectedAt;
    }

    public void setRejectedAt(LocalDateTime rejectedAt) {
        this.rejectedAt = rejectedAt;
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

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getApprovedByName() {
        return approvedByName;
    }

    public void setApprovedByName(String approvedByName) {
        this.approvedByName = approvedByName;
    }

    public String getRejectedByName() {
        return rejectedByName;
    }

    public void setRejectedByName(String rejectedByName) {
        this.rejectedByName = rejectedByName;
    }

    public List<ImportProposalDetail> getDetails() {
        return details;
    }

    public void setDetails(List<ImportProposalDetail> details) {
        this.details = details;
    }

    public void setHasNewGenerator(Boolean hasNewGenerator) {
        this.hasNewGenerator = hasNewGenerator;
    }

    public boolean hasNewGenerator() {
        return Boolean.TRUE.equals(hasNewGenerator);
    }

}
