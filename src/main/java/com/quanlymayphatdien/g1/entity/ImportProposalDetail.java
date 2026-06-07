/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.entity;

/**
 *
 * @author Phuong Linh
 */

public class ImportProposalDetail {

    private int proposalDetailId;
    private int proposalId;
    private int generatorId;
    private int quantity;
    private int currentStock;
    private String note;

    
    private String generatorCode;
    private String generatorName;
    private String brandName;

    public ImportProposalDetail() {
    }

    public ImportProposalDetail(int proposalDetailId, int proposalId, int generatorId, int quantity, int currentStock, String note, String generatorCode, String generatorName, String brandName) {
        this.proposalDetailId = proposalDetailId;
        this.proposalId = proposalId;
        this.generatorId = generatorId;
        this.quantity = quantity;
        this.currentStock = currentStock;
        this.note = note;
        this.generatorCode = generatorCode;
        this.generatorName = generatorName;
        this.brandName = brandName;
    }

    public int getProposalDetailId() {
        return proposalDetailId;
    }

    public void setProposalDetailId(int proposalDetailId) {
        this.proposalDetailId = proposalDetailId;
    }

    public int getProposalId() {
        return proposalId;
    }

    public void setProposalId(int proposalId) {
        this.proposalId = proposalId;
    }

    public int getGeneratorId() {
        return generatorId;
    }

    public void setGeneratorId(int generatorId) {
        this.generatorId = generatorId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getCurrentStock() {
        return currentStock;
    }

    public void setCurrentStock(int currentStock) {
        this.currentStock = currentStock;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getGeneratorCode() {
        return generatorCode;
    }

    public void setGeneratorCode(String generatorCode) {
        this.generatorCode = generatorCode;
    }

    public String getGeneratorName() {
        return generatorName;
    }

    public void setGeneratorName(String generatorName) {
        this.generatorName = generatorName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

}
