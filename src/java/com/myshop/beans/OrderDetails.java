package com.myshop.beans;

import java.io.InputStream;
import java.io.Serializable;
import java.sql.Timestamp;

@SuppressWarnings("serial")
public class OrderDetails implements Serializable {
    
    private String orderId;
    private String prodId;
//    private String userId;
    private String prodName;
    private int qnty;
    private double amount;
    private int shipped;
    private Timestamp datetime;
    private InputStream prodImage;

    public OrderDetails() {
        super();
    }

    public OrderDetails(String orderId, String prodId, String prodName, int qnty, double amount, int shipped, Timestamp datetime, InputStream prodImage) {
        super();
        this.orderId = orderId;
        this.prodId = prodId;
        this.prodName = prodName;
        this.qnty = qnty;
        this.amount = amount;
        this.shipped = shipped;
        this.datetime = datetime;
        this.prodImage = prodImage;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getProdId() {
        return prodId;
    }

    public void setProdId(String prodId) {
        this.prodId = prodId;
    }

    public String getProdName() {
        return prodName;
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }

    public int getQnty() {
        return qnty;
    }

    public void setQnty(int qnty) {
        this.qnty = qnty;
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

    public Timestamp getDatetime() {
        return datetime;
    }

    public void setDatetime(Timestamp datetime) {
        this.datetime = datetime;
    }

    public InputStream getProdImage() {
        return prodImage;
    }

    public void setProdImage(InputStream prodImage) {
        this.prodImage = prodImage;
    }

    @Override
    public String toString() {
        return "OrderDetails{" + "orderId=" + orderId + ", prodId=" + prodId + ", prodName=" + prodName + ", qnty=" + qnty + ", amount=" + amount + ", shipped=" + shipped + ", datetime=" + datetime + ", prodImage=" + prodImage + '}';
    }   
    
}
