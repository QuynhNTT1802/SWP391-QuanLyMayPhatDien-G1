package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;
import java.util.List;

public class Transfer {

    private int transferId;
    private String transferCode;
    private int sourceWarehouseId;
    private int destWarehouseId;
    private String status;
    private int createdBy;
    private Integer managerReviewedBy;
    private LocalDateTime managerReviewedAt;
    private String managerNote;
    private Integer ceoReviewedBy;
    private LocalDateTime ceoReviewedAt;
    private String ceoNote;
    private Integer finalReviewedBy;
    private LocalDateTime finalReviewedAt;
    private LocalDateTime executedAt;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // join fields
    private String sourceWarehouseName;
    private String destWarehouseName;
    private String createdByName;
    private String managerReviewedByName;
    private String ceoReviewedByName;
    private String finalReviewedByName;
    private List<TransferDetail> details;

    public Transfer() {
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
    }

    public String getTransferCode() {
        return transferCode;
    }

    public void setTransferCode(String transferCode) {
        this.transferCode = transferCode;
    }

    public int getSourceWarehouseId() {
        return sourceWarehouseId;
    }

    public void setSourceWarehouseId(int sourceWarehouseId) {
        this.sourceWarehouseId = sourceWarehouseId;
    }

    public int getDestWarehouseId() {
        return destWarehouseId;
    }

    public void setDestWarehouseId(int destWarehouseId) {
        this.destWarehouseId = destWarehouseId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getManagerReviewedBy() {
        return managerReviewedBy;
    }

    public void setManagerReviewedBy(Integer managerReviewedBy) {
        this.managerReviewedBy = managerReviewedBy;
    }

    public LocalDateTime getManagerReviewedAt() {
        return managerReviewedAt;
    }

    public void setManagerReviewedAt(LocalDateTime managerReviewedAt) {
        this.managerReviewedAt = managerReviewedAt;
    }

    public String getManagerNote() {
        return managerNote;
    }

    public void setManagerNote(String managerNote) {
        this.managerNote = managerNote;
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

    public String getCeoNote() {
        return ceoNote;
    }

    public void setCeoNote(String ceoNote) {
        this.ceoNote = ceoNote;
    }

    public Integer getFinalReviewedBy() {
        return finalReviewedBy;
    }

    public void setFinalReviewedBy(Integer finalReviewedBy) {
        this.finalReviewedBy = finalReviewedBy;
    }

    public LocalDateTime getFinalReviewedAt() {
        return finalReviewedAt;
    }

    public void setFinalReviewedAt(LocalDateTime finalReviewedAt) {
        this.finalReviewedAt = finalReviewedAt;
    }

    public LocalDateTime getExecutedAt() {
        return executedAt;
    }

    public void setExecutedAt(LocalDateTime executedAt) {
        this.executedAt = executedAt;
    }

    private static java.util.Date toDate(LocalDateTime ldt) {
        if (ldt == null) return null;
        return java.util.Date.from(ldt.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }

    public java.util.Date getCreatedAtAsDate() { return toDate(createdAt); }
    public java.util.Date getExecutedAtAsDate() { return toDate(executedAt); }
    public java.util.Date getManagerReviewedAtAsDate() { return toDate(managerReviewedAt); }
    public java.util.Date getCeoReviewedAtAsDate() { return toDate(ceoReviewedAt); }
    public java.util.Date getFinalReviewedAtAsDate() { return toDate(finalReviewedAt); }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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

    public String getSourceWarehouseName() {
        return sourceWarehouseName;
    }

    public void setSourceWarehouseName(String sourceWarehouseName) {
        this.sourceWarehouseName = sourceWarehouseName;
    }

    public String getDestWarehouseName() {
        return destWarehouseName;
    }

    public void setDestWarehouseName(String destWarehouseName) {
        this.destWarehouseName = destWarehouseName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getManagerReviewedByName() {
        return managerReviewedByName;
    }

    public void setManagerReviewedByName(String managerReviewedByName) {
        this.managerReviewedByName = managerReviewedByName;
    }

    public String getCeoReviewedByName() {
        return ceoReviewedByName;
    }

    public void setCeoReviewedByName(String ceoReviewedByName) {
        this.ceoReviewedByName = ceoReviewedByName;
    }

    public String getFinalReviewedByName() {
        return finalReviewedByName;
    }

    public void setFinalReviewedByName(String finalReviewedByName) {
        this.finalReviewedByName = finalReviewedByName;
    }

    public List<TransferDetail> getDetails() {
        return details;
    }

    public void setDetails(List<TransferDetail> details) {
        this.details = details;
    }
}
