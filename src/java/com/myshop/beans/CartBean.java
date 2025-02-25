package com.myshop.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class CartBean implements Serializable {
    
    public CartBean(){
        
    }
    
    private String userId;
    private String prodId;
    private int quantity;

    public CartBean(String userId, String prodId, int quantity) {
        super();
        this.userId = userId;
        this.prodId = prodId;
        this.quantity = quantity;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    
}
