package com.myshop.service.impl;

import com.myshop.beans.CartBean;
import com.myshop.beans.DemandBean;
import com.myshop.beans.ProductBean;
import com.myshop.service.CartService;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartServiceImpl implements CartService{

    @Override
    public String addProductToCart(String userId, String cartId, String prodId, int prodQty) {
        String status = "Failed to add product into cart!";
        int prodQTY = prodQty;
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM CART WHERE cart_id=? AND user_id= ? AND product_id=?");
            ps.setString(1, cartId);
            ps.setString(2, userId);
            ps.setString(3, prodId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                int cartQTY = rs.getInt("quantity");                
                ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
                int availableQTY = product.getProdQuantity();
                prodQTY += cartQTY;
                
                if( availableQTY < prodQTY){
                    
                    status = "Only " + availableQTY + " no of " + product.getProdName()
                            + " are available in the shop! So we are adding only " + availableQTY
                            + " no of that item into Your Cart" + "";
                    DemandBean demandBean = new DemandBean(userId, product.getProdId(), prodQTY-availableQTY);
                    boolean flag = new DemandServiceImpl().addProduct(demandBean);
                    if(flag){
                        status = "<br/>Later, We Will Mail You when " + product.getProdName() + " will be available into the Store!";
                    }
                }else{
                    status = updateProductToCart(userId, cartId, prodId, prodQTY);
                }
                
            }
        } catch (SQLException ex) {
            status = "error: "+ex.getMessage();
            System.out.println("Error in add product to cart:"+status);
        }
        
        return status;
    }

    @Override
    public String updateProductToCart(String userId, String cartId, String prodId, int prodQty) {
        String status = "Failed update the items into cart!";
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM CART WHERE cart_id AND user_id=? AND prododuct_id=?");
            ps.setString(1, cartId);
            ps.setString(2, userId);
            ps.setString(3, prodId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                if(prodQty > 0){
                    PreparedStatement ps2  = conn.prepareStatement("UPDATE CART SET quantity=? WHERE cart_id=? AND user_id=? AND product_id=?");
                    ps2.setInt(1, prodQty);
                    ps2.setString(2, cartId);
                    ps2.setString(3, userId);
                    ps2.setString(4, prodId);
                    
                    if(ps2.executeUpdate() > 0){
                        status = "Product successfully updated to cart!";
                    }
                }else if(prodQty == 0 ){
                    PreparedStatement ps2  = conn.prepareStatement("DELETE FROM CART WHERE user_id=? AND product_id=?");
                    
                    ps2.setString(1, userId);
                    ps2.setString(2, prodId);
                    
                    if(ps2.executeUpdate() > 0){
                        status = "Product successfully updated to cart!";
                    }
                }
            }else {
                PreparedStatement ps3 = conn.prepareStatement("INSERT INTO CART VALUES(?,?,?,?)");
                ps3.setString(1, cartId);
                ps3.setString(2, userId);
                ps3.setString(3, prodId);
                ps3.setInt(4, prodQty);
		int k = ps3.executeUpdate();
                if (k > 0)
                    status = "Product Successfully Updated to Cart!";
            }
        } catch (SQLException ex) {
             status = "Error in updateProductToCart: "+ex.getMessage();
             System.out.println(status);
        }
        
        return status;
    }

    @Override
    public List<CartBean> getAllCartItems(String userId) {
        List<CartBean> items = new ArrayList<>();
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM CART WHERE user_id=?");
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                CartBean cart = new CartBean();
                cart.setCartId(rs.getString("cart_id"));
                cart.setUserId(rs.getString("user_id"));
                cart.setProdId(rs.getString("product_id"));
                cart.setQuantity(rs.getInt("quantity"));                
                items.add(cart);
            }
        } catch (SQLException ex) {
            System.out.println("Error in getting All Cart Items from usercart db: "+ex.getMessage());
        }
        
        return items;
    }

    @Override
    public int getCartCount(String userId) {
        int count = 0;
        
       
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
             Connection conn = dbUtil.provideConnection();
            String query = "SELECT SUM(quantity) FROM CART WHERE user_id=?";
            ps = conn.prepareStatement(query);
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if(rs.next() && !rs.wasNull()){
                count = rs.getInt(1);
            }
        }catch(SQLException ex){
            System.out.println("Error in getCart count Method."+count);
            ex.printStackTrace();
        }
        
        
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);
     
        return count;
    }

    @Override
    public int getCartItemCount(String userId, String itemId) {
        
        int count = 0;
        if(userId == null || itemId == null)
            return 0;
       
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
             Connection conn = dbUtil.provideConnection();
            ps = conn.prepareStatement("SELECT quantity FROM CART WHERE user_id=? AND product_id =?");
            ps.setString(1, userId);
            ps.setString(2, itemId);
            rs = ps.executeQuery();
            if(rs.next() && !rs.wasNull()){
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
          ex.printStackTrace();
        }
        
        
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);
        
        return count;
        
    }

    @Override
    public String removeProductFromCart(String userId, String cartId, String prodId) {
        String status = "Product remove Failed from userCart!";
        
        try{
             Connection conn = dbUtil.provideConnection();
           
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM CART WHERE user_id=? AND cart_id=? AND product_id=?");
            ps.setString(1, userId);
            ps.setString(2, cartId);
            ps.setString(3, prodId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                int prodQty = rs.getInt("quantity");
                prodQty -= 1;
                
                if( prodQty > 0){
                    PreparedStatement ps2  = conn.prepareStatement("UPDATE CART SET quantity=?  WHERE user_id=? AND cart_id=? AND product_id=?");
                    ps2.setInt(1, prodQty);
                    ps2.setString(2, userId);
                    ps.setString(3, cartId);
                    ps2.setString(4, prodId);
                    
                    int k = ps2.executeUpdate();
                    if( k > 0)
                        status = "Product removed successfully from the Cart.";
                }else if( prodQty <= 0){
                    PreparedStatement ps3 = conn.prepareStatement("DELETE FROM CART WHERE user_id=? AND product_id=?");
                    ps3.setString(1, userId);
                    ps3.setString(2, prodId);
                    int k = ps3.executeUpdate();
                    if(k > 0)
                        status = "Product successfully removed from the cart. ";
                }
            }else{
                    status = "Product not Available in the cart!";
                }
        } catch (SQLException ex) {
            status = "error: "+ex.getMessage();
            System.out.println("Error in db for remove product from usercart: "+status);
        }
        
        return status;
    }   

    @Override
    public boolean removeProduct(String userId, String prodId) {
        boolean flag = false;
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM CART WHERE name=? AND prodid=? ");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            int k = ps.executeUpdate();
            if( k > 0 )
                flag = true;
        } catch (SQLException ex) {
            flag = false;
            System.out.println("Error in db for remove product from userCart db: "+ex.getMessage());
        }
        System.out.println("remove product from cart :"+flag);
        return flag;
    }

    @Override
    public int getProductCount(String userId, String prodId) {
        int count = 0;
        PreparedStatement ps = null;
	ResultSet rs = null;

        try {
            Connection conn = dbUtil.provideConnection();
            ps = conn.prepareStatement("SELECT SUM(quantity) FROM CART WHERE name=? AND prodid=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            rs = ps.executeQuery();
            if (rs.next() && !rs.wasNull())
                count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public String getCartId(String userId) {
        String cartId = null;
        
        String sql = "SELECT CART_ID FROM CART WHERE USER_ID = ?";
        
        try(Connection conn = dbUtil.provideConnection();
                PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                cartId=rs.getString("cart_id");
            }            
        } catch (SQLException ex) {
            System.out.println("Error in getCartID method:: "+ex.getMessage());
            ex.printStackTrace();
        }        
        return cartId;
    }
    
}
