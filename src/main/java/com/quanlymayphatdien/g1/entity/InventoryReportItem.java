/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

/**
 *
 * @author Aadmin
 */
public class InventoryReportItem {
    private int warehouseId;
    private String warehouseName;
    private int generatorId;
    private String model;
    private String brand;
    private int openQuantity;
    private int importQuantity;
    private int exportQuantity;
    private int closeQuantity;

    public int getWarehouseId() {
        return warehouseId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public String getModel() {
        return model;
    }

    public String getBrand() {
        return brand;
    }

    public int getOpenQuantity() {
        return openQuantity;
    }

    public int getImportQuantity() {
        return importQuantity;
    }

    public int getExportQuantity() {
        return exportQuantity;
    }

    public int getCloseQuantity() {
        return closeQuantity;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public void setOpenQuantity(int openQuantity) {
        this.openQuantity = openQuantity;
    }

    public void setImportQuantity(int importQuantity) {
        this.importQuantity = importQuantity;
    }

    public void setExportQuantity(int exportQuantity) {
        this.exportQuantity = exportQuantity;
    }

    public void setCloseQuantity(int closeQuantity) {
        this.closeQuantity = closeQuantity;
    }    
}
