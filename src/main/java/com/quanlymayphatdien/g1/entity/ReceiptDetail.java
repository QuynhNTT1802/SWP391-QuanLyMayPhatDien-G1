/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.math.BigDecimal;

/**
 *
 * @author FPTShop
 *
 * Moi dong = 1 serial cu the.
 * Serial khong con luu text o day - thay bang inventory_id (FK).
 * generator_id, serialNumber chi la transient field load qua JOIN
 * de phuc vu hien thi (JSP, Excel), KHONG su dung de ghi DB.
 */
public class ReceiptDetail {
    private int receiptDetailId;
    private int receiptId;
    private int inventoryId;
    private String note;

    private String serialNumber;
    private int generatorId;
    private String generatorModel;
    private String generatorBrand;

    public ReceiptDetail() {
    }

    public int getReceiptDetailId() {
        return receiptDetailId;
    }

    public void setReceiptDetailId(int receiptDetailId) {
        this.receiptDetailId = receiptDetailId;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public String getGeneratorModel() {
        return generatorModel;
    }

    public void setGeneratorModel(String generatorModel) {
        this.generatorModel = generatorModel;
    }

    public String getGeneratorBrand() {
        return generatorBrand;
    }

    public void setGeneratorBrand(String generatorBrand) {
        this.generatorBrand = generatorBrand;
    }
}
