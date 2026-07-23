/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;

/**
 *
 * @author Aadmin
 */
public class InventoryCheckReportItem {
    private int checkId;
    private String checkCode;
    private int warehouseId;
    private String warehouseName;
    private String status;
    private String createdByName;
    private java.time.LocalDateTime startedAt;
    private java.time.LocalDateTime completedAt;
    private int generatorId;
    private String generatorModel;
    private int systemQuantity;
    private int actualQuantity;
    private int discrepancy;

    public int getCheckId() {
        return checkId;
    }

    public String getCheckCode() {
        return checkCode;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public String getStatus() {
        return status;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public String getGeneratorModel() {
        return generatorModel;
    }

    public int getSystemQuantity() {
        return systemQuantity;
    }

    public int getActualQuantity() {
        return actualQuantity;
    }

    public int getDiscrepancy() {
        return discrepancy;
    }

    public void setCheckId(int checkId) {
        this.checkId = checkId;
    }

    public void setCheckCode(String checkCode) {
        this.checkCode = checkCode;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public void setGeneratorModel(String generatorModel) {
        this.generatorModel = generatorModel;
    }

    public void setSystemQuantity(int systemQuantity) {
        this.systemQuantity = systemQuantity;
    }

    public void setActualQuantity(int actualQuantity) {
        this.actualQuantity = actualQuantity;
    }

    public void setDiscrepancy(int discrepancy) {
        this.discrepancy = discrepancy;
    }
}
