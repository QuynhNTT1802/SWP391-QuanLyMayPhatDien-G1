/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.math.BigDecimal;

/**
 *
 * @author LENOVO
 */
public class LiquidationDetail {
    private int liquidationDetailId;
    private int liquidationId;
    private int generatorId;
    private String serialNumber;
    private BigDecimal originalPrice;
    private BigDecimal liquidationPrice;
    
    private String generatorModelName; 
    
    public LiquidationDetail() {
        
    }

    public LiquidationDetail(int liquidationDetailId, int liquidationId, int generatorId, String serialNumber, BigDecimal originalPrice, BigDecimal liquidationPrice, String generatorModelName) {
        this.liquidationDetailId = liquidationDetailId;
        this.liquidationId = liquidationId;
        this.generatorId = generatorId;
        this.serialNumber = serialNumber;
        this.originalPrice = originalPrice;
        this.liquidationPrice = liquidationPrice;
        this.generatorModelName = generatorModelName;
    }

    public int getLiquidationDetailId() {
        return liquidationDetailId;
    }

    public void setLiquidationDetailId(int liquidationDetailId) {
        this.liquidationDetailId = liquidationDetailId;
    }

    public int getLiquidationId() {
        return liquidationId;
    }

    public void setLiquidationId(int liquidationId) {
        this.liquidationId = liquidationId;
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

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public BigDecimal getLiquidationPrice() {
        return liquidationPrice;
    }

    public void setLiquidationPrice(BigDecimal liquidationPrice) {
        this.liquidationPrice = liquidationPrice;
    }

    public String getGeneratorModelName() {
        return generatorModelName;
    }

    public void setGeneratorModelName(String generatorModelName) {
        this.generatorModelName = generatorModelName;
    }
    
    
}
