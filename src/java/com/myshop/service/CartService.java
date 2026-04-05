package com.myshop.service;

import com.myshop.beans.CartBean;
import java.util.List;

public interface CartService {
        
    public String addProductToCart(String userID, String cartId, String prodId, int prodQty);
    
    public String updateProductToCart(String userID, String cartId, String prodId, int prodQty);
    
    public List<CartBean> getAllCartItems(String userId);
    
    public int getCartCount(String userID);
    
    public int getCartItemCount(String userID, String itemId);
    
    public String removeProductFromCart(String userID,String cartId, String prodId);
    
    public boolean removeProduct(String userID, String prodId);
    
    public int getProductCount(String userId, String prodId);
    
    public String getCartId(String userId);
    
}
