/*
 * Entity class for the customer table.
 */
package com.quanlymayphatdien.g1.entity;

import java.util.Date;

/**
 * Đại diện cho bảng customer — quản lý thông tin khách hàng.
 */
public class Customer {

    private int id;
    private String name;
    private String phone;
    private String email;
    private String address;
    private String companyName;      // nullable — chỉ điền khi là doanh nghiệp
    private int customerTypeId;      // FK → category (loại KH: Cá nhân / Doanh nghiệp / Nhà nước)
    private String status;           // active | inactive
    private Date createdAt;
    private int createdBy;           // FK → user.id
    private Date updatedAt;
    private int updatedBy;           // FK → user.id

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    public Customer() {
    }

    public Customer(int id, String name, String phone, String email,
                    String address, String companyName, int customerTypeId,
                    String status, Date createdAt, int createdBy,
                    Date updatedAt, int updatedBy) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.companyName = companyName;
        this.customerTypeId = customerTypeId;
        this.status = status;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.updatedAt = updatedAt;
        this.updatedBy = updatedBy;
    }

    // -------------------------------------------------------------------------
    // Getters & Setters
    // -------------------------------------------------------------------------

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public int getCustomerTypeId() {
        return customerTypeId;
    }

    public void setCustomerTypeId(int customerTypeId) {
        this.customerTypeId = customerTypeId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    @Override
    public String toString() {
        return "Customer{id=" + id + ", name=" + name + ", phone=" + phone + "}";
    }
}
