package com.quanlymayphatdien.g1.entity;

public class Generator {
    private int generatorId;
    private String model;
    private String brand;
    private Double price;
    private String power;
    private String fuelType;
    private String status;

    public Generator() {}

    public int getGeneratorId() { return generatorId; }
    public void setGeneratorId(int generatorId) { this.generatorId = generatorId; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getPower() { return power; }
    public void setPower(String power) { this.power = power; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
