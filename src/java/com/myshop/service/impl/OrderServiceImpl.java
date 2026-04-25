package com.myshop.service.impl;

import com.myshop.beans.*;
import com.myshop.service.OrderService;
import com.myshop.utility.dbUtil;
import com.myshop.utility.idUtil;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderServiceImpl implements OrderService {

    // ================= PAYMENT SUCCESS =================
    @Override
    public String paymentSuccess(String paymentId, String orderId, String userId,String cartId, double paidAmount) {

        String status = "FAILED";
        Connection conn = null;
        try {
            conn = dbUtil.provideConnection();
            
            conn.setAutoCommit(false); // 🔥 transaction control

//            String orderId = idUtil.generateUUIDOrderId();

            // 🔥 1. INSERT ORDER
            PreparedStatement ps1 = conn.prepareStatement(
                "INSERT INTO ORDERS(order_id, user_id, total_amount, status, order_date) VALUES(?,?,?,?,?)"
            );

            SimpleDateFormat sdf = new SimpleDateFormat("YYYY:MM:DD hh:mm:ss");
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            sdf.format(timestamp);
                    
            ps1.setString(1, orderId);
            ps1.setString(2, userId);
            ps1.setDouble(3, paidAmount);
            ps1.setString(4, "PENDING");
            ps1.setTimestamp(5, timestamp);

            ps1.executeUpdate();

            // 🔥 2. GET CART ITEMS
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT * FROM CART_ITEMS WHERE cart_id=?"
            );
            ps2.setString(1, cartId);

            ResultSet rs = ps2.executeQuery();

            // 🔥 3. INSERT ORDER ITEMS
            while (rs.next()) {

                String productId = rs.getString("product_id");
                int qty = rs.getInt("quantity");

                double price = new ProductServiceImpl().getProductPrice(productId);

                PreparedStatement ps3 = conn.prepareStatement(
                    "INSERT INTO ORDER_ITEMS(order_item_id, order_id, product_id, quantity) VALUES(?,?,?,?)"
                );
                
                ps3.setString(1, idUtil.generateCartItemId());
                ps3.setString(2, orderId);
                ps3.setString(3, productId);
                ps3.setInt(4, qty);
//                ps3.setDouble(5, price);

                ps3.executeUpdate();

                // 🔥 Reduce stock
                new ProductServiceImpl().sellNoProduct(productId, qty);
            }

            // 🔥 4. CLEAR CART
            PreparedStatement ps4 = conn.prepareStatement(
                "DELETE FROM CART_ITEMS WHERE cart_id=?"
            );
            ps4.setString(1, cartId);
            ps4.executeUpdate();
            
//            TransactionBean trans = new TransactionBean();
//            
//            trans.setOrderId(orderId);
//            trans.setTransAmount(paidAmount);
//            trans.setTransDateTime(timestamp);
//            trans.setTransId(cartId);
//            trans.setUserName(userId);
//            
//            
//            new TransactionServiceImpl().addTransaction(trans);

            // 🔥 COMMIT
            conn.commit();

            status = orderId; // return orderId

            System.out.println("Order Created Successfully: " + orderId);

        } catch (Exception e) {

            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
        }

        return status;
    }

    // ================= COUNT SOLD =================
    @Override
    public int countSoldItem(String prodId) {

        int count = 0;

        try {
            Connection conn = dbUtil.provideConnection();

            PreparedStatement ps = conn.prepareStatement(
                "SELECT SUM(quantity) FROM ORDER_ITEMS WHERE product_id=?"
            );

            ps.setString(1, prodId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // ================= GET ALL ORDERS =================
    @Override
    public List<OrderDetails> getAllOrders() {

        List<OrderDetails> list = new ArrayList<>();

        try {
            Connection conn = dbUtil.provideConnection();

            PreparedStatement ps = conn.prepareStatement(
                "SELECT o.order_id, o.user_id, o.total_amount, o.status, o.order_date, " +
                "oi.product_id, oi.quantity " +
                "FROM ORDERS o JOIN ORDER_ITEMS oi ON o.order_id = oi.order_id"
            );

            ResultSet rs = ps.executeQuery();
            
            List<OrderItem> items = new ArrayList<>();
            OrderItem item = null;
            while (rs.next()) {
                item = new OrderItem();
                    item.setProductId(rs.getString("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("order_id"));
                    items.add(item);
                OrderDetails order = new OrderDetails();
                
                order.setOrderId(rs.getString("order_id"));
                order.setUserId(rs.getString("user_id"));
                order.setAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setDatetime(rs.getTimestamp("order_date"));
                order.setProdId(rs.getString("product_id"));
                order.setQnty(rs.getInt("quantity"));
                order.setItems(items);

                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= UPDATE STATUS =================
    public boolean updateOrderStatus(String orderId, String status) {

        boolean updated = false;

        try {
            Connection conn = dbUtil.provideConnection();

            PreparedStatement ps = conn.prepareStatement(
                "UPDATE ORDERS SET status=? WHERE order_id=?"
            );

            ps.setString(1, status);
            ps.setString(2, orderId);

            updated = ps.executeUpdate() > 0;
            if(updated){
                PreparedStatement ps2 = conn.prepareStatement("INSERT INTO ORDER_STATUS_HISTORY VALUES(?,?,?)");
                ps2.setString(1, orderId);
                ps2.setString(2, status);
                ps2.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                ps2.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return updated;
    }

    @Override
    public boolean addOrder(OrderBean order) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String shipNow(String orderId, String prodId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<OrderBean> getOrderByUserId(String emailId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
public List<OrderDetails> getAllOrderDetails(String userId) {

    List<OrderDetails> list = new ArrayList<>();

    try (Connection conn = dbUtil.provideConnection()) {

        String query = "SELECT o.order_id, o.user_id, o.total_amount, o.status, o.order_date, o.order_date+7 as delivery_date, " +
                       "oi.product_id, oi.quantity, " +
                       "p.name " +
                       "FROM ORDERS o " +
                       "JOIN ORDER_ITEMS oi ON o.order_id = oi.order_id " +
                       "JOIN PRODUCTS p ON oi.product_id = p.product_id " +
                       "WHERE o.user_id = ? " +
                       "ORDER BY o.order_date DESC";

        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, userId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            OrderDetails order = new OrderDetails();

            order.setOrderId(rs.getString("order_id"));
            order.setUserId(rs.getString("user_id"));
            order.setAmount(rs.getDouble("total_amount"));
            order.setStatus(rs.getString("status"));
            order.setDatetime(rs.getTimestamp("order_date"));
            order.setDeliveryDate(rs.getTimestamp("delivery_date"));

            order.setProdId(rs.getString("product_id"));
            order.setProdName(rs.getString("name"));
            order.setQnty(rs.getInt("quantity"));

            list.add(order);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    @Override
public boolean outForDelivery(String userId, String orderId, String prodId, AssignOrder assignOrder) {

    boolean flag = false;

    Connection con = null;
    PreparedStatement psUpdate = null;
    PreparedStatement psInsert = null;

    try {
        con = dbUtil.provideConnection(); // your DB connection class
        con.setAutoCommit(false); // ✅ transaction start

        // ✅ 1. Update order status
        String updateQuery = "UPDATE ORDERS SET status=? WHERE user_id=? AND order_id=?";
        psUpdate = con.prepareStatement(updateQuery);
        psUpdate.setString(1, "OUT_FOR_DELIVERY");
        psUpdate.setString(2, userId);
        psUpdate.setString(3, orderId);
//        psUpdate.setString(4, prodId);

        int updated = psUpdate.executeUpdate();

        // ✅ 2. Insert into ASSIGN_ORDER table
        String insertQuery = "INSERT INTO DELIVERY_ASSIGNMENT(assign_id,order_id, staff_id) VALUES (?, ?, ?)";
        psInsert = con.prepareStatement(insertQuery);
        psInsert.setString(1, assignOrder.getAssignId());
        psInsert.setString(2, assignOrder.getOrderId());
        psInsert.setString(3, assignOrder.getStaffId());
        
        int inserted = psInsert.executeUpdate();

        // ✅ Commit only if both succeed
        if (updated > 0 && inserted > 0) {
            con.commit();
            flag = true;
        } else {
            con.rollback();
        }

    } catch (Exception e) {
        try {
            if (con != null) con.rollback(); // rollback on error
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
    } finally {
        try {
            if (psUpdate != null) psUpdate.close();
            if (psInsert != null) psInsert.close();
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    return flag;
}

    @Override
    public boolean assignOrder(AssignOrder order) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public int assignId() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<AssignOrder> getAssignedOrdersByStaff(String staffEmail) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String markOrderAsDelivered(int assignId, String staffId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean updateOTPAfterDelivery(int assignId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public OrderDetails getOrderDetailsByOrdId(String ordId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getOrderId(String userId) {
        String  orderId = null;
        
        try(Connection conn = dbUtil.provideConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT order_id from orders where user_id = ?");){
            ps.setString(1, userId);
            
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                orderId = rs.getString("order_id");
            }
            
        } catch (SQLException ex) {
            ex.getMessage();
        }
        return orderId;
    }
}