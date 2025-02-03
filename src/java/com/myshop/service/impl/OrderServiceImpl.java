package com.myshop.service.impl;

import com.myshop.beans.CartBean;
import com.myshop.beans.OrderBean;
import com.myshop.beans.OrderDetails;
import com.myshop.beans.TransactionBean;
import com.myshop.service.OrderService;
import com.myshop.utility.MailMessage;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class OrderServiceImpl implements OrderService{

    @Override
    public boolean addOrder(OrderBean order) {
        boolean flag = false;
        Connection conn = dbUtil.provideConnection();
        try {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO ORDERS VALUES(?,?,?,?,?)");
            ps.setString(1, order.getTransId());
            ps.setString(2, order.getProdId());
            ps.setInt(3, order.getQuantity());
            ps.setDouble(4, order.getAmount());
            ps.setInt(5, 0);
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
//        String status = "Order Placement Failed!";
            String status = "Order Placed Successfully!";
        List<CartBean> cartItems = new CartServiceImpl().getAllCartItems(userName);
        if (cartItems.isEmpty())
            return status;
        TransactionBean transaction = new TransactionBean(userName, paidAmount);
        boolean ordered = false;
        String transactionId = transaction.getTransId();
//        System.out.println("Transaction: "+transaction.getTransId()+" "+transaction.getTransAmount()+" "+transaction.getUserName()+" "+transaction.getTransDateTime());
        for (CartBean item : cartItems) {
            double amount = new ProductServiceImpl().getProductPrice(item.getProdId()) * item.getQuantity();
            OrderBean order = new OrderBean();
            order.setTransId(transactionId);
            order.setProdId(item.getProdId());
            order.setQuantity(item.getQuantity());
            order.setAmount(amount);
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
                MailMessage.transactionSuccess(userName, new UserServiceImpl().getFirstName(userName),transaction.getTransId(), transaction.getTransAmount());
                status = "Order Placed Successfully!";
            }
            status = "Order Placed Successfully!";
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
                OrderBean order = new OrderBean(rs.getString("orderId"), rs.getString("prodId"), rs.getInt("quantity"), rs.getDouble("amount"), rs.getInt("shipped") );
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
                + " P.pName AS pName, O.quantity AS quantity, O.amount AS amount, T.time AS time FROM ORDERS O, TRANSACTIONS T , PRODUCTS P"
                + " WHERE O.orderId = T.transId AND O.orderId = T.transId AND O.prodId = P.pId AND T.userName=?";
        Connection conn = dbUtil.provideConnection();
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
                order.setDatetime(rs.getTimestamp("time"));
                order.setQnty(rs.getInt("quantity"));
                order.setProdImage(rs.getAsciiStream("image"));
                order.setShipped(rs.getInt("shipped"));
                
                orders.add(order);
            }
            //System.out.println("Orders Details :"+orders.toString());
        } catch (SQLException ex) {
            System.out.println("Error in get all orderDetails from db: "+ex.getMessage());
        }
        
        dbUtil.closeConnection(conn);
        return orders;
    } 
      
}
