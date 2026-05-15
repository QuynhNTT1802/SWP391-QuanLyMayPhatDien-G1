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

public class Admin extends User {
    private String department;
    private LocalDateTime lastLogin;

   
    public Admin() {
        super();
    }

  
    public Admin(int id, String name, String username, String password, String email,
                 String phone, String address, String status,
                 LocalDateTime createdAt, LocalDateTime updatedAt,
                 Integer createdBy, Integer updatedBy,
                 String department, LocalDateTime lastLogin) {
        super(id, name, username, password, email, phone, address, status,
              createdAt, updatedAt, createdBy, updatedBy);
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