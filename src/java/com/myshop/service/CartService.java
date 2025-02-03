package com.myshop.service;

import com.myshop.beans.CartBean;
import java.util.List;

public interface CartService {
        
    public String addProductToCart(String userID, int prodQty, String prodId);
    
    public String updateProductToCart(String userID, String prodId, int prodQty);
    
    public List<CartBean> getAllCartItems(String userId);
    
    public int getCartCount(String userID);
    
    public int getCartItemCount(String userID, String itemId);
    
    public String removeProductFromCart(String userID, String prodId);
    
    public boolean removeProduct(String userID, String prodId);
    
    public int getProductCount(String userId, String prodId);
}
