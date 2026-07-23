/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.math.BigDecimal;


public class ReceiptDetail {
    private int receiptDetailId;
    private int receiptId;
    private int inventoryId;
    private String note;

    private String serialNumber;
    private int generatorId;
    private String generatorModel;
    private String generatorBrand;
    private String condition;
    private String generatorPower;
    private String generatorFreq;
    private String generatorWeight;
    private String generatorStatus;
    private String generatorName;

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

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getGeneratorPower() {
        return generatorPower;
    }

    public void setGeneratorPower(String generatorPower) {
        this.generatorPower = generatorPower;
    }

    public String getGeneratorFreq() {
        return generatorFreq;
    }

    public void setGeneratorFreq(String generatorFreq) {
        this.generatorFreq = generatorFreq;
    }

    public String getGeneratorWeight() {
        return generatorWeight;
    }

    public void setGeneratorWeight(String generatorWeight) {
        this.generatorWeight = generatorWeight;
    }

    public String getGeneratorStatus() {
        return generatorStatus;
    }

    public void setGeneratorStatus(String generatorStatus) {
        this.generatorStatus = generatorStatus;
    }

    public String getGeneratorName() {
        return generatorName;
    }

    public void setGeneratorName(String generatorName) {
        this.generatorName = generatorName;
    }
}
