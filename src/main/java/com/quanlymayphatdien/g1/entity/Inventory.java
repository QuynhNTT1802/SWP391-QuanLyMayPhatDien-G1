/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;

/**
 *
 * @author FPTShop
 *
 * Moi serial = 1 dong trong bang inventory.
 * Quan ly ton kho = quan ly serial.
 */
public class Inventory {

    private int inventoryId;
    private String serialNumber;
    private int generatorId;
    private int warehouseId;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Joined fields (for display)
    private String generatorModel;
    private String generatorBrand;
    private String warehouseName;
    private Integer importReceiptId;
    private String importReceiptCode;

    public Inventory() {
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
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

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public Integer getImportReceiptId() {
        return importReceiptId;
    }

    public void setImportReceiptId(Integer importReceiptId) {
        this.importReceiptId = importReceiptId;
    }

    public String getImportReceiptCode() {
        return importReceiptCode;
    }

    public void setImportReceiptCode(String importReceiptCode) {
        this.importReceiptCode = importReceiptCode;
    }

    /**
     * Tinh so serial IN_STOCK theo (warehouse, generator).
     * Su dung khi can hien thi tong ton o trang overview/aggregate.
     * @return 1 vi moi dong = 1 serial
     */
    public int getQuantity() {
        return 1;
    }
}
