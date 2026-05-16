/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

/**
 *
 * @author Phuong Linh
 */

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

public class Admin extends User {
    private String department;
    private LocalDateTime lastLogin;

   
    public Admin(int id, String name, String username, String password, String email, String phone, String address, String status, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy, Integer updatedBy, List<Role> roles, Set<String> effectPermissions, String department1, LocalDateTime lastLogin1) {
        super();
    }

    public Admin(String department, LocalDateTime lastLogin) {
        this.department = department;
        this.lastLogin = lastLogin;
    }

    public Admin(String department, LocalDateTime lastLogin, Integer id, String name, String username, String password, String email, String phone, String address, String status, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy, Integer updatedBy, List<Role> roles, Set<String> effectivePermissions) {
        super(id, name, username, password, email, phone, address, status, createdAt, updatedAt, createdBy, updatedBy, roles, effectivePermissions);
        this.department = department;
        this.lastLogin = lastLogin;
    }

    
    


    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    @Override
    public String toString() {
        return "Admin{" +
               "id=" + getId() +
               ", name='" + getName() + '\'' +
               ", username='" + getUsername() + '\'' +
               ", email='" + getEmail() + '\'' +
               ", phone='" + getPhone() + '\'' +
               ", address='" + getAddress() + '\'' +
               ", status='" + getStatus() + '\'' +
               ", department='" + department + '\'' +
               ", lastLogin=" + lastLogin +
               ", createdAt=" + getCreatedAt() +
               ", updatedAt=" + getUpdatedAt() +
               ", createdBy=" + getCreatedBy() +
               ", updatedBy=" + getUpdatedBy() +
               '}';
    }
}