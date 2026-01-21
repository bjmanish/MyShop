package com.myshop.service.impl;

import com.myshop.beans.AssignOrder;
import com.myshop.beans.CartBean;
import com.myshop.beans.OrderBean;
import com.myshop.beans.OrderDelivery;
import com.myshop.beans.OrderDetails;
import com.myshop.beans.TransactionBean;
import com.myshop.service.OrderService;
import com.myshop.utility.DeliveryDate;
import com.myshop.utility.JavaMailUtil;
import com.myshop.utility.MailMessage;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;


public class OrderServiceImpl implements OrderService{
    private Connection conn = dbUtil.provideConnection();

    @Override
    public boolean addOrder(OrderBean order) {
        boolean flag = false;
//        Connection conn = dbUtil.provideConnection();
        try {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO ORDERS VALUES(?,?,?,?,?,?,?,?)");
            ps.setString(1, order.getTransId());
            ps.setString(2, order.getProdId());
            ps.setInt(3, order.getQuantity());
            ps.setDouble(4, order.getAmount());
            ps.setTimestamp(5, order.getOrderDate());
            ps.setTimestamp(6, order.getDeliveryDate());
            ps.setInt(7, 0);
            ps.setString(8, "ORDER PLACED");
            System.out.println("data for orders placed "+ps.toString());
            int k = ps.executeUpdate();
            if (k > 0){
                flag = true;
            }
            
        } catch (SQLException e) {
            flag = false;
            System.out.println("Error in adding order in db :"+e.getMessage());
            e.printStackTrace();
        }
        System.out.println("add Product: "+flag);
        return flag;
    }

    @Override
    public boolean addTransaction(TransactionBean transaction) {
        boolean flag = false;
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement("INSERT INTO TRANSACTIONS VALUES(?,?,?,?)");
            ps.setString(1, transaction.getTransId());
            ps.setString(2, transaction.getUserName());
            ps.setTimestamp(3, transaction.getTransDateTime());
            ps.setDouble(4, transaction.getTransAmount());
            
            int k = ps.executeUpdate();
            if (k > 0){
                flag = true;
            }
            System.out.println("add Tansaction :"+flag);
        } catch (SQLException e) {
            flag = false;
            e.printStackTrace();    
        }
        
        dbUtil.closeConnection(conn);
        dbUtil.closeConnection(ps);
        
        return flag;
    }

    @Override
    public String paymentSuccess(String userName, double paidAmount) {
        String status = "Order Placement Failed!";
            String status1 = "Order Placed Successfully!";
        List<CartBean> cartItems = new CartServiceImpl().getAllCartItems(userName);
        if (cartItems.isEmpty())
            return status;
        TransactionBean transaction = new TransactionBean(userName, paidAmount);
        boolean ordered = false;
        String transactionId = transaction.getTransId();
        Timestamp transDate = transaction.getTransDateTime();
        // Convert to LocalDateTime
        LocalDateTime localDateTime = transDate.toLocalDateTime();

        // Add 7 days
        LocalDateTime deliveryDateTime = localDateTime.plusDays(7);

        // Convert back to Timestamp if needed
        Timestamp deliveryDate = Timestamp.valueOf(deliveryDateTime);
        System.out.println("Transaction: "+transaction.getTransId()+" "+transaction.getTransAmount()+" "+transaction.getUserName()+" "+transaction.getTransDateTime());
        for (CartBean item : cartItems) {
            double amount = new ProductServiceImpl().getProductPrice(item.getProdId()) * item.getQuantity();
            OrderBean order = new OrderBean();
            order.setTransId(transactionId);
            order.setProdId(item.getProdId());
            order.setQuantity(item.getQuantity());
            order.setAmount(amount);
            order.setOrderDate(transaction.getTransDateTime());
            order.setDeliveryDate(deliveryDate);
            order.setShipped(0);
            
            ordered = addOrder(order);
            if (!ordered)
                break;
            else {
                ordered = new CartServiceImpl().removeProduct(item.getUserId(), item.getProdId());
            }
            if (!ordered)
                break;
            else
                ordered = new ProductServiceImpl().sellNoProduct(item.getProdId(), item.getQuantity());
            if (!ordered)
                break;
        }
        if (ordered) {
            ordered = new OrderServiceImpl().addTransaction(transaction);
            if (ordered) {
                try {
                    MailMessage.transactionSuccess(userName, new UserServiceImpl().getFirstName(userName),transaction.getTransId(), transaction.getTransAmount());
                } catch (Exception ex) {
                    System.out.println("Error in sending transaction email: "+ex.getMessage());
                    ex.printStackTrace();
//                    Logger.getLogger(OrderServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
                }
                status = "Order Placed Successfully!";
            }
//            status = "Order Placed Successfully!";
	}
        System.out.println("Payment Success: "+ordered+" and status :"+status);
        
        return status;
    }

    @Override
    public int countSoldItem(String prodId) {
        int count = 0;
	Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement("SELECT SUM(quantity) FROM ORDERS WHERE prodId=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();
            if (rs.next())
                count = rs.getInt(1);
        } catch (SQLException e) {
            count = 0;
            System.out.println("Error for counting the sold item from db:"+e.getMessage());
        }
        dbUtil.closeConnection(conn);
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);

	return count;
    }

    @Override
    public String shipNow(String orderId, String prodId) {
        String status = "FAILURE";
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement("UPDATE ORDERS SET shipped=1 WHERE orderId=? AND prodId=? AND shipped = 0");
            ps.setString(1, orderId);
            ps.setString(2, prodId);
            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Order Has been shipped successfully!!";
                updateOrderStatus(orderId, "ORDER_SHIPPED");
            }
        } catch (SQLException e) {
            System.out.println("Error in shippedNow db for shipped product: "+e.getMessage());
        }

	dbUtil.closeConnection(conn);
	dbUtil.closeConnection(ps);

        return status;
    }

    @Override
    public List<OrderBean> getAllOrders() {
        List<OrderBean> orderList = new ArrayList<>();
               
        Connection conn = dbUtil.provideConnection();
        try {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM ORDERS");
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                OrderBean order = new OrderBean(
                        rs.getString("orderId"), 
                        rs.getString("prodId"), 
                        rs.getInt("quantity"), 
                        rs.getDouble("amount"), 
                        rs.getInt("shipped"), 
                        rs.getString("status"),
                        rs.getTimestamp("delivery_date"),
                        rs.getTimestamp("order_date")
                );
                orderList.add(order);
            }
        } catch (SQLException ex) {
            System.out.println("Error: "+ex.getMessage());
        }
        dbUtil.closeConnection(conn);
        
        return orderList;
    }

    @Override
    public List<OrderBean> getOrderByUserId(String emailId) {
        List<OrderBean> orderList = new ArrayList<>();
        Connection conn = dbUtil.provideConnection();
         
        String query = "SELECT * FROM ORDERS o INNER JOIN TRANSACTIONS t ON o.orderId = t.transId WHERE userName=?";
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, emailId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderBean order = new OrderBean();                
                order.setTransId(rs.getString("t.transId"));
                order.setProdId(rs.getString("t.prodId"));
                order.setQuantity(rs.getInt("quantity"));
                order.setAmount(rs.getDouble("t.amount"));
                order.setShipped(rs.getInt("shipped"));
                
                orderList.add(order);
            }
        } catch (SQLException e) {
            System.out.println("Error in get OrderDetails by user Id from db :"+e.getMessage());
        }
                
        return orderList;
    }

    @Override
    public List<OrderDetails> getAllOrderDetails(String userEmailId) {
        List<OrderDetails> orders = new ArrayList<>();
        String query =  "SELECT P.pId AS ProdId, O.orderId AS orderId, t.transId As transId, O.shipped AS shipped, P.image AS image, "
                + " P.pName AS pName, O.quantity AS quantity, O.amount AS amount,o.delivery_date AS deliveryDate, o.status AS status, o.order_date AS orderDate FROM ORDERS O, TRANSACTIONS T , PRODUCTS P"
                + " WHERE O.orderId = T.transId AND O.orderId = T.transId AND O.prodId = P.pId AND T.userName=?";
//        Connection conn = dbUtil.provideConnection();
        //System.out.println(userEmailId);
        
        OrderDetails order = null;
        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, userEmailId);
            ResultSet rs = ps.executeQuery();
            //System.out.println(rs);
            while(rs.next()){
                order =  new OrderDetails();
                order.setOrderId(rs.getString("orderId"));
                order.setProdId(rs.getString("prodId"));
                order.setProdName(rs.getString("pName"));
                order.setAmount(rs.getDouble("amount"));
                order.setDatetime(rs.getTimestamp("orderDate"));
                order.setStatus(rs.getString("status"));
                order.setDeliveryDate(rs.getTimestamp("deliveryDate"));
                order.setQnty(rs.getInt("quantity"));
                order.setProdImage(rs.getAsciiStream("image"));
                order.setShipped(rs.getInt("shipped"));
                
                orders.add(order);
            }
            //System.out.println("Orders Details :"+orders.toString());
        } catch (SQLException ex) {
            System.out.println("Error in get all orderDetails from db: "+ex.getMessage());
        }
        
//        dbUtil.closeConnection(conn);
        return orders;
    } 
      
    @Override
    public boolean outForDelivery(String userId, String orderId, String prodId, AssignOrder assignOrd) {
    boolean flag = false;
     String status = "";
    List<OrderDetails> orders = new OrderServiceImpl().getAllOrderDetails(userId);
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd:MM:yyyy HH:mm");

    for (OrderDetails order : orders) {
        Date orderDate = order.getDatetime();

        // Convert Date -> LocalDateTime
        LocalDateTime localOrderDateTime = orderDate.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime();

        // Add 7 days for delivery date
        LocalDateTime deliveryDateTime = localOrderDateTime.plusDays(7)
                .withHour(23).withMinute(0).withSecond(0).withNano(0);

        // Convert back to java.util.Date
        Date deliveryDate = Date.from(deliveryDateTime.atZone(ZoneId.systemDefault()).toInstant());

        // ✅ FIX: Properly convert Date → Timestamp
        order.setDeliveryDate(new java.sql.Timestamp(deliveryDate.getTime()));

        // Format delivery date for email
        String formattedDeliveryDate = sdf2.format(deliveryDate);

        // Generate OTP
        String otp = String.format("%06d", new Random().nextInt(1000000));
        LocalDateTime otpTime = LocalDateTime.now();
        boolean k1 = assignOrder(assignOrd);
        boolean k = updateOrderStatus(orderId, "OUT_FOR_DELIVERY");
        if (k==true && k1==true) {
//            assignOrder(order);
            flag = true;
            status = "Your order has been marked as Out for Delivery!";
            System.out.println("Delivery Status: " + status);
    
            // Send email notification
            MailMessage.orderOutForDelivery(userId,new UserServiceImpl().getFirstName(userId),orderId,formattedDeliveryDate,prodId,otp    );
        }
//        dbUtil.closeConnection(conn);
    }
    return flag;
}

    @Override
    public boolean assignOrder(AssignOrder order) {
        System.out.println("Assign order details from assing order :"+ order.toString());
        boolean inserted = false;
        String sName = "";
        String sql = "INSERT INTO AssignOrderForStaff (assignId, orderId, staffId, StaffName, assignedDate, deliveryStatus, otp,  otpGeneratedAt, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sql2 = "SELECT sname FROM DELIVERYSTAFF WHERE semail = ?";        
        int aId = assignId();
        System.out.println("AssignId :"+aId);
        try(Connection conn = dbUtil.provideConnection()){          
            PreparedStatement ps = conn.prepareStatement(sql);
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setString(1, order.getStaffId());
            ResultSet rs = ps2.executeQuery();
            while(rs.next()){
                sName = rs.getString(1);
            }
            System.out.println("Staff Name from assignOrder():"+sName);
            ps.setInt(1, aId);
            ps.setString(2, order.getOrderId());
            ps.setString(3, order.getStaffId());
            ps.setString(4, sName);
            ps.setTimestamp(5, order.getAssignDate());
            ps.setString(6, order.getDeliveryStatus());
            ps.setString(7, order.getOtp());
            ps.setTimestamp(8, Timestamp.valueOf(order.getOtpGeneratedAt()));
            ps.setString(9, null);
            inserted = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inserted;    
    }    

    @Override
    public int assignId() {
        int id = 1001;
        String query = "SELECT MAX(assignId) FROM AssignOrderForStaff";
   
        try (Connection conn = dbUtil.provideConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {   
            if (rs.next()) {
                int maxId = rs.getInt(1);
                if (!rs.wasNull()) { // ensure table is not empty
                    id = maxId + 1;
                }
            }
            System.out.println("Next assignId: " + id);
        } catch (SQLException ex) {
            System.out.println("Error in assignId(): " + ex.getMessage());
            ex.printStackTrace();
        }
        
        return id;
    }

    public Timestamp getDeliveryDateByOrderId(String orderId) {
    Timestamp deliveryDate = null;
    String query = "SELECT delivery_date FROM ORDERS WHERE orderId = ?";

    try (Connection conn = dbUtil.provideConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setString(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                deliveryDate = rs.getTimestamp("delivery_date");
            }
        }

    } catch (SQLException e) {
        System.out.println("❌ Error in getDeliveryDateByOrderId: " + e.getMessage());
        e.printStackTrace();
    }

    return deliveryDate;
}

    @Override
    public List<AssignOrder> getAssignedOrdersByStaff(String staffEmail) {
        List<AssignOrder> list = new ArrayList<>();
        String query = "SELECT * FROM AssignOrderForStaff WHERE staffId = ? ORDER BY assignedDate DESC";
        try(Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query)
        ){
            ps.setString(1, staffEmail);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                AssignOrder o = new AssignOrder();
                o.setAssignId(rs.getInt("assignId"));
                o.setOrderId(rs.getString("orderId"));
                o.setStaffName(rs.getString("staffname"));
                o.setAssignDate(rs.getTimestamp("assignedDate"));
//                o.setDeliveryDate(rs.getTimestamp("deliveryDate"));
                o.setDeliveryStatus(rs.getString("deliveryStatus"));
                o.setOtp(rs.getString("otp"));
                o.setOtpGeneratedAt(rs.getTimestamp("otpGeneratedAt").toLocalDateTime());
                list.add(o);
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        return list;
    }

    @Override
    public String markOrderAsDelivered(int assignId, String staffId) {
        String status = "FAILED";
        String query = "UPDATE AssignOrderForStaff SET DeliveryStatus = ?, deliveredAt = ? WHERE assignId = ? AND staffId = ?";
        try (Connection conn = dbUtil.provideConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
            Timestamp ts = new Timestamp(System.currentTimeMillis());
            ps.setString(1, "DELIVERED");
            ps.setTimestamp(2, ts);
            ps.setInt(3, assignId);
            ps.setString(4, staffId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                status = "SUCCESS";
                System.out.println("AssignOrder updated to Delivered for orderId: " + assignId);
                
//               OrderService order =  (OrderService) new OrderServiceImpl().getAllOrderDetails(orderId);
                
//                MailMessage.markAsDelivered(
//                    order,
//                    ts
//                );
            }
        } catch (SQLException e) {
            System.out.println("Error in markOrderAsDelivered(): " + e.getMessage());
        }
        return status;
    }

    public boolean updateOrderStatus(String orderId, String newStatus) {
    boolean updated = false;
    String query = "UPDATE ORDERS SET status = ? WHERE orderId = ?";
    try (Connection conn = dbUtil.provideConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setString(1, newStatus);
        ps.setString(2, orderId);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            updated = true;
            System.out.println("ORDERS table updated to " + newStatus + " for orderId: " + orderId);
        }
    } catch (SQLException e) {
        System.out.println("Error in updateOrderStatus(): " + e.getMessage());
    }
    return updated;
}

    public String getOtpByAssignId(int assignId) {
    String otp = null;
    String query = "SELECT otp FROM AssignOrderForStaff WHERE assignId = ?";
    try (Connection conn = dbUtil.provideConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setInt(1, assignId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            otp = rs.getString("otp");
        }
    } catch (SQLException e) {
        System.out.println("Error in getOtpByAssignId(): " + e.getMessage());
    }
    return otp;
}

    @Override
    public boolean updateOTPAfterDelivery(int assignId){
        boolean status = false;
        
        String query = "UPDATE AssignOrderForStaff SET otp = ? WHERE assignId = ?";
        try (Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, "EXPIRED");
            ps.setInt(2, assignId);
            int k = ps.executeUpdate();
            if(k>0){
                System.out.println("OTP Expired!/removed from DB after Delivery.");
            }
        } catch (SQLException e) {
            System.out.println("Error in UpdateOtpAfterDelivery: " + e.getMessage());
        }
        
        return status;
    }
    
    public String getOtpByOrderId(String orderId) throws SQLException{
        String otp = "";
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = conn.prepareStatement("Select otp from ASSIGNORDERFORSTAFF where orderId = ?");
        
        ps.setString(1, orderId);
        
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            otp = rs.getString(1);
        }
        
        return otp;
    }
    
    
}