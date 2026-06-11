/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 *
 * @author FPTShop
 */
public class StockCard {

    private int stockCardId;
    private int warehouseId;
    private int generatorId;
    private Integer receiptId;
    private String transactionType;
    private int quantityChange;
    private int quantityAfter;
    private String referenceNote;
    private LocalDateTime createdAt;
    private Integer createdBy;

    //join
    private String warehouseName;
    private String generatorModel;
    private String receiptCode;
    private String createdByName;
    private String serialList;

    public StockCard() {
    }

    public int getStockCardId() {
        return stockCardId;
    }

    public void setStockCardId(int stockCardId) {
        this.stockCardId = stockCardId;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public Integer getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(Integer receiptId) {
        this.receiptId = receiptId;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public int getQuantityChange() {
        return quantityChange;
    }

    public void setQuantityChange(int quantityChange) {
        this.quantityChange = quantityChange;
    }

    public int getQuantityAfter() {
        return quantityAfter;
    }

    public void setQuantityAfter(int quantityAfter) {
        this.quantityAfter = quantityAfter;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Date getCreatedAtAsDate() {
        if (createdAt == null) {
            return null;
        }
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getGeneratorModel() {
        return generatorModel;
    }

    public void setGeneratorModel(String generatorModel) {
        this.generatorModel = generatorModel;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public String getReferenceNote() {
        return referenceNote;
    }

    public void setReferenceNote(String referenceNote) {
        this.referenceNote = referenceNote;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getSerialList() {
        return serialList;
    }

    public void setSerialList(String serialList) {
        this.serialList = serialList;
    }
}
