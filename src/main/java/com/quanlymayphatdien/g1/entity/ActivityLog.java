/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;

public class ActivityLog {
    private int id;
    private int userId;
    private String entityType;
    private String action;
    private Integer entityId;
    private String entityName;
    private String details;
    private LocalDateTime createdAt;
    private String username;

    public ActivityLog() {
    }

    public ActivityLog(int id, int userId, String entityType, String action, Integer entityId, String entityName, String details, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.entityType = entityType;
        this.action = action;
        this.entityId = entityId;
        this.entityName = entityName;
        this.details = details;
        this.createdAt = createdAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getEntityType() {
        return entityType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Integer getEntityId() {
        return entityId;
    }

    public void setEntityId(Integer entityId) {
        this.entityId = entityId;
    }

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public java.util.Date getCreatedAtAsDate() {
        if (createdAt == null) return null;
        return java.util.Date.from(createdAt.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }
    
    
}
