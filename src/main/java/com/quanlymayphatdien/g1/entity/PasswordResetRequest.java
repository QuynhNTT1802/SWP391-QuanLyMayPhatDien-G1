/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;

/**
 *
 * @author FPTShop
 */
public class PasswordResetRequest {

    private int id;
    private int userId;
    private String username;
    private String status;
    private Integer processedBy;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime processedAt;

    public PasswordResetRequest() {
    }

    public PasswordResetRequest(int id, int userId, String username, String status, Integer processedBy, String note, LocalDateTime createdAt, LocalDateTime processedAt) {
        this.id = id;
        this.userId = userId;
        this.username = username;
        this.status = status;
        this.processedBy = processedBy;
        this.note = note;
        this.createdAt = createdAt;
        this.processedAt = processedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

}