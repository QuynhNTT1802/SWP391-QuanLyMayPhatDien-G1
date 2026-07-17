/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

/**
 *
 * @author Phuong Linh
 */
public class OrderDetail {

    private int orderDetailId;
    private int orderId;
    private int generatorId;
    private int quantity;
    private Double unitPrice;
    private String note;
    private String generatorModel;
    private String generatorPower;
    private String generatorFreq;
    private String generatorWeight;
    private String generatorStatus;

    public OrderDetail() {
    }

    public OrderDetail(int orderDetailId, int orderId, int generatorId, int quantity, Double unitPrice, String note, String generatorModel) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.generatorId = generatorId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.note = note;
        this.generatorModel = generatorModel;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getGeneratorModel() {
        return generatorModel;
    }

    public void setGeneratorModel(String generatorModel) {
        this.generatorModel = generatorModel;
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
    
    
}
    


