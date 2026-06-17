package com.quanlymayphatdien.g1.entity;

public class GeneratorSummary {

    private int id;
    private String model;
    private String brand;
    private int totalSerials;

    public GeneratorSummary() {
    }

    public GeneratorSummary(int id, String model, String brand, int totalSerials) {
        this.id = id;
        this.model = model;
        this.brand = brand;
        this.totalSerials = totalSerials;
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

    public int getTotalSerials() {
        return totalSerials;
    }

    public void setTotalSerials(int totalSerials) {
        this.totalSerials = totalSerials;
    }

}
