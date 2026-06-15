/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

/**
 *
 * @author LENOVO
 */
public class Permission {
    private int permissionId;
    private String resource;
    private String action;
    private String description;
    private String module;
    private String featureName;
    private String taskType;

    public Permission() {
    }

    public Permission(int permissionId, String resource, String action, String description) {
        this.permissionId = permissionId;
        this.resource = resource;
        this.action = action;
        this.description = description;
    }

    public Permission(int permissionId, String resource, String action, String description,
                      String module, String featureName, String taskType) {
        this.permissionId = permissionId;
        this.resource = resource;
        this.action = action;
        this.description = description;
        this.module = module;
        this.featureName = featureName;
        this.taskType = taskType;
    }

    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
    }

    public String getResource() {
        return resource;
    }

    public void setResource(String resource) {
        this.resource = resource;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getFeatureName() {
        return featureName;
    }

    public void setFeatureName(String featureName) {
        this.featureName = featureName;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public String getCode() {
        return resource + "." + action;
    }
}
