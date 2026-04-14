package com.myshop.service.impl;

import com.myshop.beans.CartBean;
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

    try (Connection conn = dbUtil.provideConnection()) {

        // ✅ STEP 1: Get/Create Cart
        if (cartId == null || cartId.isEmpty()) {
            cartId = getOrCreateCart(userId);
        }

        // ✅ STEP 2: Check if product already exists in CART_ITEMS
        String checkSql = "SELECT quantity FROM CART_ITEMS WHERE cart_id=? AND product_id=?";
        PreparedStatement ps = conn.prepareStatement(checkSql);
        ps.setString(1, cartId);
        ps.setString(2, prodId);

        ResultSet rs = ps.executeQuery();

        int existingQty = 0;
        if (rs.next()) {
            existingQty = rs.getInt("quantity");
        }

        int totalQty = existingQty + qtyToAdd;

        // ✅ STEP 3: Check stock
        ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
        int availableQty = product.getProdQuantity();

        if (availableQty == 0) return "Product is Out of Stock!";

        if (totalQty > availableQty) {
            totalQty = availableQty;
        }

        // ✅ STEP 4: Insert or Update CART_ITEMS
        if (existingQty > 0) {
            String updateSql = "UPDATE CART_ITEMS SET quantity=? WHERE cart_id=? AND product_id=?";
            PreparedStatement ps2 = conn.prepareStatement(updateSql);

            ps2.setInt(1, totalQty);
            ps2.setString(2, cartId);
            ps2.setString(3, prodId);

            ps2.executeUpdate();
            status = "Cart updated!";
        } else {
            String insertSql = "INSERT INTO CART_ITEMS(cart_item_id, cart_id, product_id, quantity) VALUES (?, ?, ?, ?)";
            PreparedStatement ps2 = conn.prepareStatement(insertSql);

            ps2.setString(1, idUtil.generateCartItemId());
            ps2.setString(2, cartId);
            ps2.setString(3, prodId);
            ps2.setInt(4, qtyToAdd);

            ps2.executeUpdate();
            status = "Product added to cart!";
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
    public List<CartBean> getAllCartItems(String cartId) {

        List<CartBean> items = new ArrayList<>();

        try (Connection conn = dbUtil.provideConnection()) {

            String sql = "SELECT ci.*, c.user_id FROM CART c " +
                     "JOIN CART_ITEMS ci ON c.cart_id = ci.cart_id " +
                     "WHERE c.cart_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, cartId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartBean cart = new CartBean();
                cart.setCartId(rs.getString("cart_id"));
                cart.setUserId(rs.getString("user_id"));
                cart.setProdId(rs.getString("product_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setCartItemId(rs.getString("cart_item_id"));
                items.add(cart);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }
    
    @Override
    public int getCartCount(String userId) {

        int count = 0;
        try (Connection conn = dbUtil.provideConnection()) {

            String sql = "SELECT SUM(ci.quantity) FROM CART c " +
                     "JOIN CART_ITEMS ci ON c.cart_id = ci.cart_id " +
                     "WHERE c.user_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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

        String status = "Failed";
        try (Connection conn = dbUtil.provideConnection()) {

            String sql = "DELETE FROM CART_ITEMS WHERE cart_id=? AND product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, cartId);
            ps.setString(2, prodId);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = "Product removed!";
            }
        } catch (Exception e) {
            status = "Error: " + e.getMessage();
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
    public String getOrCreateCart(String userId){

        String cartId = null;
        // ✅ Check existing cart
        String sql = "SELECT cart_id FROM CART WHERE user_id=?";
   
        try( Connection conn = dbUtil.provideConnection();
                PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setString(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cartId = rs.getString("cart_id");
            } else {
                // ✅ Create new cart
                cartId = idUtil.generateUUIDCartId();
                String insertSql = "INSERT INTO CART(cart_id, user_id) VALUES (?, ?)";
                PreparedStatement ps2 = conn.prepareStatement(insertSql);
                ps2.setString(1, cartId);
                ps2.setString(2, userId);
                ps2.executeUpdate();
            }            
        }catch (SQLException ex) {
            System.out.println("Error inside getOrCreateCartId Method :"+ex.getMessage());
            ex.printStackTrace();
        }
        return cartId;
    }
    
}
