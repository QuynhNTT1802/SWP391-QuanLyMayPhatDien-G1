package com.quanlymayphatdien.g1.entity;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Generator {

    private int id;
    private String model;
    private BigDecimal powerRating;
    private BigDecimal unitPrice;
    private String frequency;
    private BigDecimal weight;
    private String description;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer createdBy;
    private Integer updatedBy;
    private List<Category> categories;

    public Generator() {
    }

    public Generator(int id, String model, BigDecimal powerRating,
            BigDecimal unitPrice, String frequency, BigDecimal weight,
            String description, String status, LocalDateTime createdAt,
            LocalDateTime updatedAt, Integer createdBy, Integer updatedBy,
            List<Category> categories) {
        this.id = id;
        this.model = model;
        this.powerRating = powerRating;
        this.unitPrice = unitPrice;
        this.frequency = frequency;
        this.weight = weight;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
        this.categories = categories;
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

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
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

    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }

    @Override
    public String toString() {
        return "Generator{"
                + "id=" + id
                + ", model='" + model + '\''
                + ", powerRating=" + powerRating
                + ", unitPrice=" + unitPrice
                + ", frequency='" + frequency + '\''
                + ", weight=" + weight
                + ", description='" + description + '\''
                + ", status='" + status + '\''
                + '}';
    }
}
