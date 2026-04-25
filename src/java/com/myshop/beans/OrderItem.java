/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.beans;

/**
 *
 * @author Admin
 */
public class OrderItem {
    private String productId;
    private String productName;
    private int quantity;
//    private double price;

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

//    public double getPrice() {
//        return price;
//    }
//
//    public void setPrice(double price) {
//        this.price = price;
//    }

    @Override
    public String toString() {
        return "OrderItem{" + "productId=" + productId + ", productName=" + productName + ", quantity=" + quantity  + '}';
    }

    
    
}
