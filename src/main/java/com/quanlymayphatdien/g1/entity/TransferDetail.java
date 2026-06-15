package com.quanlymayphatdien.g1.entity;

public class TransferDetail {

    private int transferDetailId;
    private int transferId;
    private int generatorId;
    private String serialNumber;
    private int quantity;
    private String note;

    // join fields
    private String generatorModel;
    private String generatorBrand;
    private int sourceWarehouseId;
    private int destWarehouseId;

    public TransferDetail() {
    }

    public int getTransferDetailId() {
        return transferDetailId;
    }

    public void setTransferDetailId(int transferDetailId) {
        this.transferDetailId = transferDetailId;
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public String getGeneratorBrand() {
        return generatorBrand;
    }

    public void setGeneratorBrand(String generatorBrand) {
        this.generatorBrand = generatorBrand;
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
}
