/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

/**
 *
 * @author FPTShop
 */
public class ReceiptDetail {
    private int receiptDetailId;
    private int receiptId;
    private int generatorId;
    private String serialNumber;
    private int quantity;
    private String note;
    
    private String generatorModel;
    private String generatorBrand;

    public ReceiptDetail() {
    }

    public ReceiptDetail(int receiptDetailId, int receiptId, int generatorId, String serialNumber, int quantity, String note, String generatorModel, String generatorBrand) {
        this.receiptDetailId = receiptDetailId;
        this.receiptId = receiptId;
        this.generatorId = generatorId;
        this.serialNumber = serialNumber;
        this.quantity = quantity;
        this.note = note;
        this.generatorModel = generatorModel;
        this.generatorBrand = generatorBrand;
    }
    
}
