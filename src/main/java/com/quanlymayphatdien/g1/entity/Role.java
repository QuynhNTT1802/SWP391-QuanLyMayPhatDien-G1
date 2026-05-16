package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;

/**
 *
 * @author LENOVO
 */
public class Role {
    private int roleId;
    private String roleName;
    private String description;
    private String status;
    private LocalDateTime createdAt; 
    private LocalDateTime updatedAt; 

    public Role() {
    }

    public Role(int roleId, String roleName, String description, String status, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
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
}