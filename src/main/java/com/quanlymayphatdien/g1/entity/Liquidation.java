/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.sql.Timestamp;
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
    private Integer managerReviewedBy; 
    private LocalDateTime managerReviewedAt;
    private Integer ceoReviewedBy;
    private LocalDateTime ceoReviewedAt;
    private Integer ceoFeedbackId;
    private Integer managerFeedbackId;
    private Integer convertedReceiptId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private String createdByName;
    private String managerReviewedByName;
    private String reasonName;
    private String ceoFeedbackName;
    private String managerFeedbackName;
    private List<LiquidationDetail> details;
    
    public Liquidation() {
    }

    public Liquidation(int liquidationId, String liquidationCode, int createdBy, String status, int reasonId, Integer managerReviewedBy, LocalDateTime managerReviewedAt, Integer ceoReviewedBy, LocalDateTime ceoReviewedAt, Integer ceoFeedbackId, Integer managerFeedbackId, Integer convertedReceiptId, LocalDateTime createdAt, LocalDateTime updatedAt, String createdByName, String managerReviewedByName, String reasonName, String ceoFeedbackName, String managerFeedbackName, List<LiquidationDetail> details) {
        this.liquidationId = liquidationId;
        this.liquidationCode = liquidationCode;
        this.createdBy = createdBy;
        this.status = status;
        this.reasonId = reasonId;
        this.managerReviewedBy = managerReviewedBy;
        this.managerReviewedAt = managerReviewedAt;
        this.ceoReviewedBy = ceoReviewedBy;
        this.ceoReviewedAt = ceoReviewedAt;
        this.ceoFeedbackId = ceoFeedbackId;
        this.managerFeedbackId = managerFeedbackId;
        this.convertedReceiptId = convertedReceiptId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdByName = createdByName;
        this.managerReviewedByName = managerReviewedByName;
        this.reasonName = reasonName;
        this.ceoFeedbackName = ceoFeedbackName;
        this.managerFeedbackName = managerFeedbackName;
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

    public Integer getManagerFeedbackId() {
        return managerFeedbackId;
    }

    public void setManagerFeedbackId(Integer managerFeedbackId) {
        this.managerFeedbackId = managerFeedbackId;
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

    public String getManagerReviewedByName() {
        return managerReviewedByName;
    }

    public void setManagerReviewedByName(String managerReviewedByName) {
        this.managerReviewedByName = managerReviewedByName;
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

    public String getManagerFeedbackName() {
        return managerFeedbackName;
    }

    public void setManagerFeedbackName(String managerFeedbackName) {
        this.managerFeedbackName = managerFeedbackName;
    }

    public List<LiquidationDetail> getDetails() {
        return details;
    }

    public void setDetails(List<LiquidationDetail> details) {
        this.details = details;
    }
    
    
}
