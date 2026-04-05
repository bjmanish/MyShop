package com.myshop.beans;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;


@SuppressWarnings("serial")
public class OrderBean implements Serializable{

    private String transId;
    private String prodId;
    private String userId;
    private String status;
    private int quantity;
    private double amount;
    private int shipped;
    private Timestamp orderDate;
    private Timestamp deliveryDate;

    public OrderBean() {
        super();
    }

    public OrderBean(String transId, String prodId, int quantity, double amount, int shipped, String status) {
        super();
        this.transId= transId;
        this.prodId = prodId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = shipped;
        this.status = status;
    }
    
    public OrderBean(String transId, String prodId, int quantity, double amount, int shipped, String status, Timestamp deliveryDate, Timestamp orderDate) {
        super();
        this.transId= transId;
        this.prodId = prodId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = shipped;
        this.status = status;
        this.deliveryDate = deliveryDate;
        this.orderDate = orderDate;
    }

    public OrderBean(String transId, String userId, double amount, String status, Timestamp orderDate, Timestamp deliveryDate) {
        this.transId = transId;
        this.userId = userId;
//        this.status = status;
        this.amount = amount;
        this.status = status;
        this.orderDate = orderDate;
        this.deliveryDate = deliveryDate;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
    
    public int getShipped() {
        return shipped;
    }

    public void setShipped(int shipped) {
        this.shipped = shipped;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public Timestamp getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Timestamp deliveryDate) {
        this.deliveryDate = deliveryDate;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "OrderBean{" + "transId=" + transId + ", prodId=" + prodId + ", userId=" + userId + ", status=" + status + ", quantity=" + quantity + ", amount=" + amount + ", shipped=" + shipped + ", orderDate=" + orderDate + ", deliveryDate=" + deliveryDate + '}';
    }

    
    
    
    
}
