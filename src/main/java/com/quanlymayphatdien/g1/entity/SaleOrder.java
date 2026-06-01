/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.util.Date;

/**
 *
 * @author Phuong Linh
 */
public class SaleOrder {
    private int orderId;
    private String orderCode;
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String customerAddress;
    private String customerTaxCode;
    private String customerType;
    private String customerCompany;
    private String customerNote;
    
    private int createdBy;
    private int approvedBy;
    private int cancelledBy;
    private int updatedBy;
    private int customerTypeId;
    
    private String status; // PENDING, APPROVED, REJECTED, CANCELLED
    private Double totalAmount;
    private String note;
    private String rejectReason; // Lý do từ chối (UC-35)
    
    private Date orderDate;
    private Date approvedAt;
    private Date cancelledAt; // Thời điểm hủy (UC-36)
    private Date createdAt;
    private Date updatedAt;

    public SaleOrder() {
    }

    public SaleOrder(int orderId, String orderCode, String customerName, String customerPhone, String customerEmail, String customerAddress, String customerTaxCode, String customerType, String customerCompany, String customerNote, int createdBy, int approvedBy, int cancelledBy, int updatedBy, int customerTypeId, String status, Double totalAmount, String note, String rejectReason, Date orderDate, Date approvedAt, Date cancelledAt, Date createdAt, Date updatedAt) {
        this.orderId = orderId;
        this.orderCode = orderCode;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.customerEmail = customerEmail;
        this.customerAddress = customerAddress;
        this.customerTaxCode = customerTaxCode;
        this.customerType = customerType;
        this.customerCompany = customerCompany;
        this.customerNote = customerNote;
        this.createdBy = createdBy;
        this.approvedBy = approvedBy;
        this.cancelledBy = cancelledBy;
        this.updatedBy = updatedBy;
        this.customerTypeId = customerTypeId;
        this.status = status;
        this.totalAmount = totalAmount;
        this.note = note;
        this.rejectReason = rejectReason;
        this.orderDate = orderDate;
        this.approvedAt = approvedAt;
        this.cancelledAt = cancelledAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getCustomerTaxCode() {
        return customerTaxCode;
    }

    public void setCustomerTaxCode(String customerTaxCode) {
        this.customerTaxCode = customerTaxCode;
    }

    public String getCustomerType() {
        return customerType;
    }

    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }

    public String getCustomerCompany() {
        return customerCompany;
    }

    public void setCustomerCompany(String customerCompany) {
        this.customerCompany = customerCompany;
    }

    public String getCustomerNote() {
        return customerNote;
    }

    public void setCustomerNote(String customerNote) {
        this.customerNote = customerNote;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(int approvedBy) {
        this.approvedBy = approvedBy;
    }

    public int getCancelledBy() {
        return cancelledBy;
    }

    public void setCancelledBy(int cancelledBy) {
        this.cancelledBy = cancelledBy;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
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

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Date getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Date approvedAt) {
        this.approvedAt = approvedAt;
    }

    public Date getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(Date cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    
    


    
    
}
