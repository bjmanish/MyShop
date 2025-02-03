package com.myshop.beans;

import java.io.Serializable;


@SuppressWarnings("serial")
public class OrderBean implements Serializable{

    private String transId;
    private String prodId;
    private int quantity;
    private double amount;
    private int shipped;

    public OrderBean() {
        super();
    }

    public OrderBean(String transId, String prodId, int quantity, double amount, int shipped) {
        super();
        this.transId= transId;
        this.prodId = prodId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = shipped;
    }

    public String getTransId() {
        return transId;
    }

    public void setTransId(String transId) {
        this.transId = transId;
    }

    public String getProdId() {
        return prodId;
    }

    public void setProdId(String prodId) {
        this.prodId = prodId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public int getShipped() {
        return shipped;
    }

    public void setShipped(int shipped) {
        this.shipped = shipped;
    }

    @Override
    public String toString() {
        return "OrderBean{" + "transId=" + transId + ", prodId=" + prodId + ", quantity=" + quantity + ", amount=" + amount + ", shipped=" + shipped + '}';
    }
    
    
    
}
