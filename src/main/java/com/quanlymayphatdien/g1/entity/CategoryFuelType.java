package com.quanlymayphatdien.g1.entity;

import java.math.BigDecimal;

public class CategoryFuelType {
    private int categoryId;
    private String unit;
    private BigDecimal typicalPrice;

    public CategoryFuelType() {}

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public BigDecimal getTypicalPrice() { return typicalPrice; }
    public void setTypicalPrice(BigDecimal typicalPrice) { this.typicalPrice = typicalPrice; }
}