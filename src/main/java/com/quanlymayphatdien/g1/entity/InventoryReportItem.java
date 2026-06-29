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
    private int openQty;
    private int importQty;
    private int exportQty;
    private int closeQty;

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int v) {
        warehouseId = v;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String v) {
        warehouseName = v;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public void setGeneratorId(int v) {
        generatorId = v;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String v) {
        model = v;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String v) {
        brand = v;
    }

    public int getOpenQty() {
        return openQty;
    }

    public void setOpenQty(int v) {
        openQty = v;
    }

    public int getImportQty() {
        return importQty;
    }

    public void setImportQty(int v) {
        importQty = v;
    }

    public int getExportQty() {
        return exportQty;
    }

    public void setExportQty(int v) {
        exportQty = v;
    }

    public int getCloseQty() {
        return closeQty;
    }

    public void setCloseQty(int v) {
        closeQty = v;
    }
}
