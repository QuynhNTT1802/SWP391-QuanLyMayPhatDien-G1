package com.quanlymayphatdien.g1.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Generator {

    private int id;
    private String model;
    private String brand;
    private BigDecimal powerRating;
    private BigDecimal unitPrice;
    private int stockQuantity;
    private String description;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer createdBy;
    private Integer updatedBy;

    public Generator() {
    }

    public Generator(int id, String model, String brand, BigDecimal powerRating,
            BigDecimal unitPrice, int stockQuantity, String description,
            String status, LocalDateTime createdAt, LocalDateTime updatedAt,
            Integer createdBy, Integer updatedBy) {
        this.id = id;
        this.model = model;
        this.brand = brand;
        this.powerRating = powerRating;
        this.unitPrice = unitPrice;
        this.stockQuantity = stockQuantity;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public BigDecimal getPowerRating() {
        return powerRating;
    }

    public void setPowerRating(BigDecimal powerRating) {
        this.powerRating = powerRating;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    @Override
    public String toString() {
        return "Generator{"
                + "id=" + id
                + ", model='" + model + '\''
                + ", brand='" + brand + '\''
                + ", powerRating=" + powerRating
                + ", unitPrice=" + unitPrice
                + ", stockQuantity=" + stockQuantity
                + ", description='" + description + '\''
                + ", status='" + status + '\''
                + '}';
    }
}