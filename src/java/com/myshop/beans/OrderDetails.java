package com.myshop.beans;

import java.io.InputStream;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

@SuppressWarnings("serial")
public class OrderDetails implements Serializable {
    
    private String orderId;
    private String prodId;
    private String userId;
    private String prodName;
    private int qnty;
    private double amount;
    private int shipped;
    private Timestamp datetime;
    private Timestamp deliveryDate;
    private InputStream prodImage;
    private String status;
    
    private List<OrderItem> items;
    private String userName;

    public OrderDetails() {
        super();
    }

    public OrderDetails(String orderId, String prodId, String prodName, int qnty, double amount, int shipped, Timestamp datetime, Timestamp deliveryDate, InputStream prodImage, String status) {
        super();
        this.orderId = orderId;
        this.prodId = prodId;
        this.prodName = prodName;
        this.qnty = qnty;
        this.amount = amount;
        this.shipped = shipped;
        this.datetime = datetime;
        this.deliveryDate = deliveryDate;
        this.prodImage = prodImage;
        this.status = status;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public Timestamp getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Timestamp deliveryDate) {
        this.deliveryDate = deliveryDate;
    } 

    public InputStream getProdImage() {
        return prodImage;
    }

    public void setProdImage(InputStream prodImage) {
        this.prodImage = prodImage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "OrderDetails{" + "orderId=" + orderId + ", prodId=" + prodId + ", userId=" + userId + ", prodName=" + prodName + ", qnty=" + qnty + ", amount=" + amount + ", shipped=" + shipped + ", datetime=" + datetime + ", deliveryDate=" + deliveryDate + ", prodImage=" + prodImage + ", status=" + status + ", items=" + items + ", userName=" + userName + '}';
    }  
    
}
