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
public class Inventory {

    private int inventoryId;
    private int warehouseId;
    private int generatorId;
    private int quantity;
    private LocalDateTime updatedAt;

    private String generatorModel;
    private String generatorBrand;
    private String warehouseName;
    private LocalDateTime firstImportAt;

    public Inventory() {
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public LocalDateTime getFirstImportAt() {
        return firstImportAt;
    }

    public void setFirstImportAt(LocalDateTime firstImportAt) {
        this.firstImportAt = firstImportAt;
    }

    public Date getFirstImportAtAsDate() {
        if (firstImportAt == null) {
            return null;
        }
        return Date.from(firstImportAt.atZone(ZoneId.systemDefault()).toInstant());
    }

}
