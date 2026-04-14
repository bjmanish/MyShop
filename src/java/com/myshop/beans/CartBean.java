package com.myshop.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class CartBean implements Serializable {
    
    public CartBean(){
        
    }
    private String cartId;
    private String userId;
    private String prodId;
    private int quantity;
    
    private String cartItemId;

    public CartBean(String cartId, String userId, String prodId, int quantity) {
        super();
        this.cartId = cartId;
        this.userId = userId;
        this.prodId = prodId;
        this.quantity = quantity;
    }

    public String getCartId() {
        return cartId;
    }

    public void setCartId(String cartId) {
        this.cartId = cartId;
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

    public String getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(String cartItemId) {
        this.cartItemId = cartItemId;
    }

    @Override
    public String toString() {
        return "CartBean{" + "cartId=" + cartId + ", userId=" + userId + ", prodId=" + prodId + ", quantity=" + quantity + ", cartItemId=" + cartItemId + '}';
    }    
    
}
