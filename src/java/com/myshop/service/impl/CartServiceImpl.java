package com.myshop.service.impl;

import com.myshop.beans.CartBean;
import com.myshop.beans.DemandBean;
import com.myshop.beans.ProductBean;
import com.myshop.service.CartService;
import com.myshop.utility.dbUtil;
import com.myshop.utility.idUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartServiceImpl implements CartService{

@Override
public String addProductToCart(String userId, String cartId, String prodId, int qtyToAdd) {

    String status = "Failed to add product!";
    
    if (cartId == null) {
        cartId = getCartId(userId);
    }

    try (Connection conn = dbUtil.provideConnection()) {

        // ✅ Check existing product in cart
        String checkSql = "SELECT quantity FROM CART WHERE cart_id=? AND user_id=? AND product_id=?";
        PreparedStatement ps = conn.prepareStatement(checkSql);
        ps.setString(1, cartId);
        ps.setString(2, userId);
        ps.setString(3, prodId);

        ResultSet rs = ps.executeQuery();

        int existingQty = 0;

        if (rs.next()) {
            existingQty = rs.getInt("quantity");
        }

        int totalQty = existingQty + qtyToAdd;

        // ✅ Get product stock
        ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
        int availableQty = product.getProdQuantity();

        // 🔴 OUT OF STOCK
        if (availableQty == 0) {
            return "Product is Out of Stock!";
        }

        // ⚠️ EXCEEDS STOCK
        if (totalQty > availableQty) {

            updateProductToCart(userId, cartId, prodId, availableQty);

            int demandQty = totalQty - availableQty;
            DemandBean demand = new DemandBean(userId, prodId, demandQty);
            new DemandServiceImpl().addProduct(demand);

            return "Only " + availableQty + " items available. Added maximum to cart.";
        }

        // ✅ INSERT OR UPDATE
        if (existingQty > 0) {
            status = updateProductToCart(userId, cartId, prodId, totalQty);
        } else {
            String insertSql = "INSERT INTO CART(cart_id, user_id, product_id, quantity) VALUES (?, ?, ?, ?)";
            PreparedStatement ps2 = conn.prepareStatement(insertSql);

            ps2.setString(1, cartId);
            ps2.setString(2, userId);
            ps2.setString(3, prodId);
            ps2.setInt(4, qtyToAdd);

            if (ps2.executeUpdate() > 0) {
                status = "Product added to cart!";
            }
        }

    } catch (Exception e) {
        status = "Error: " + e.getMessage();
        e.printStackTrace();
    }

    return status;
}

@Override
public String updateProductToCart(String userId, String cartId, String prodId, int qty) {

    String status = "Failed to update cart!";

    try (Connection conn = dbUtil.provideConnection()) {

        // ✅ DELETE if qty = 0
        if (qty == 0) {
            String deleteSql = "DELETE FROM CART WHERE user_id=? AND product_id=?";
            PreparedStatement ps = conn.prepareStatement(deleteSql);

            ps.setString(1, userId);
            ps.setString(2, prodId);

            if (ps.executeUpdate() > 0) {
                status = "Product removed from cart!";
            }

            return status;
        }

        // ✅ UPDATE
        String updateSql = "UPDATE CART SET quantity=? WHERE cart_id=? AND user_id=? AND product_id=?";
        PreparedStatement ps = conn.prepareStatement(updateSql);

        ps.setInt(1, qty);
        ps.setString(2, cartId);
        ps.setString(3, userId);
        ps.setString(4, prodId);

        int rows = ps.executeUpdate();

        // ✅ If not exist → INSERT
        if (rows == 0) {
            String insertSql = "INSERT INTO CART(cart_id, user_id, product_id, quantity) VALUES (?, ?, ?, ?)";
            PreparedStatement ps2 = conn.prepareStatement(insertSql);

            ps2.setString(1, cartId);
            ps2.setString(2, userId);
            ps2.setString(3, prodId);
            ps2.setInt(4, qty);

            if (ps2.executeUpdate() > 0) {
                status = "Product added to cart!";
            }
        } else {
            status = "Cart updated successfully!";
        }

    } catch (Exception e) {
        status = "Error: " + e.getMessage();
        e.printStackTrace();
    }

    return status;
}


    @Override
    public List<CartBean> getAllCartItems(String userId) {
        List<CartBean> items = new ArrayList<>();
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM CART WHERE cart_id=?");
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
        
//	ResultSet rs = null;
        String query = "SELECT SUM(quantity) FROM CART WHERE user_id=? AND product_id = ?";
        try(Connection conn = dbUtil.provideConnection(); 
                PreparedStatement ps = conn.prepareStatement(query);) {
            ps.setString(1, userId);
            ps.setString(2, prodId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && !rs.wasNull()){
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public String getCartId(String userId) {
        String cartId = null;
        String cId = "";
        String sql = "SELECT cart_id FROM CART WHERE USER_ID = ?";
        
        try(Connection conn = dbUtil.provideConnection();
                PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                cartId=rs.getString("cart_id");
                if(cartId!=null){
                    cId = cartId;
                }else{
                    cId = idUtil.generateUUIDCartId();
                }
            }   
            System.out.println("cart id from getId method :"+cartId);
        } catch (SQLException ex) {
            System.out.println("Error in getCartID method:: "+ex.getMessage());
            ex.printStackTrace();
        }        
        return cId;
    }
    
}
