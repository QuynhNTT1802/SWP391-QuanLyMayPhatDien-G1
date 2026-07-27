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
    private int customerId;
    private int createdBy;

    private int approvedBy;
    private int cancelledBy;
    private int updatedBy;

    private int rejectedBy;
    private String createdByName;
    private String approvedByName;
    private String cancelledByName;
    private String rejectedByName;

    private String status;
    private Double totalAmount;
    private String note;
    private String customerNote;
    private String rejectReason;
    private String revisionReason;

    private Date orderDate;
    private Date approvedAt;
    private Date cancelledAt;
    private Date createdAt;
    private Date updatedAt;
    private Customer customer;
    private String warehouseName;
    private int totalQuantity;

    public SaleOrder() {
    }

    public SaleOrder(int orderId, String orderCode, int customerId, int createdBy, int approvedBy, int cancelledBy, int updatedBy, int rejectedBy, String status, Double totalAmount, String note, String rejectReason, Date orderDate, Date approvedAt, Date cancelledAt, Date createdAt, Date updatedAt, Customer customer) {
        this.orderId = orderId;
        this.orderCode = orderCode;
        this.customerId = customerId;
        this.createdBy = createdBy;
        this.approvedBy = approvedBy;
        this.cancelledBy = cancelledBy;
        this.updatedBy = updatedBy;
        this.rejectedBy = rejectedBy;
        this.status = status;
        this.totalAmount = totalAmount;
        this.note = note;
        this.rejectReason = rejectReason;
        this.orderDate = orderDate;
        this.approvedAt = approvedAt;
        this.cancelledAt = cancelledAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.customer = customer;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getApprovedByName() {
        return approvedByName;
    }

    public void setApprovedByName(String approvedByName) {
        this.approvedByName = approvedByName;
    }

    public String getCancelledByName() {
        return cancelledByName;
    }

    public void setCancelledByName(String cancelledByName) {
        this.cancelledByName = cancelledByName;
    }

    public String getRejectedByName() {
        return rejectedByName;
    }

    public void setRejectedByName(String rejectedByName) {
        this.rejectedByName = rejectedByName;
    }

    public String getCustomerNote() {
        return customerNote;
    }

    public void setCustomerNote(String customerNote) {
        this.customerNote = customerNote;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
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

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
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

    public int getRejectedBy() {
        return rejectedBy;
    }

    public void setRejectedBy(int rejectedBy) {
        this.rejectedBy = rejectedBy;
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

    public String getRevisionReason() {
        return revisionReason;
    }

    public void setRevisionReason(String revisionReason) {
        this.revisionReason = revisionReason;
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
