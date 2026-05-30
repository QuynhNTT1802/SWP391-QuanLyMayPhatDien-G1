/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

import java.time.LocalDateTime;
import java.util.Date;

/**
 *
 * @author LENOVO
 */
public class SystemLog {

    private int id;
    private String level;
    private String module;
    private String source;
    private String message;
    private String stackTrace;
    private LocalDateTime createdAt;

    public SystemLog() {
    }

    public SystemLog(String level, String module, String source, String message, String stackTrace) {
        this.level = level;
        this.module = module;
        this.source = source;
        this.message = message;
        this.stackTrace = stackTrace;
    }

    public Date getCreatedAtDate() {
        if (createdAt == null) {
            return null;
        }
        return Date.from(createdAt.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public Date getCreatedAtAsDate() {
        return getCreatedAtDate();
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStackTrace() {
        return stackTrace;
    }

    public void setStackTrace(String stackTrace) {
        this.stackTrace = stackTrace;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
