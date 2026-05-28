package com.quanlymayphatdien.g1.entity;

public class CategoryCustomerType {

    private int categoryId;
    private String taxType;

    public CategoryCustomerType() {
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getTaxType() {
        return taxType;
    }

    public void setTaxType(String taxType) {
        this.taxType = taxType;
    }
}