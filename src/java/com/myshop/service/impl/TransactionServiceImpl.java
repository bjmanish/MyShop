package com.myshop.service.impl;

import com.myshop.beans.TransactionBean;
import com.myshop.service.TransactionService;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;


public class TransactionServiceImpl implements TransactionService {

    @Override
    public String getUserId(String transId) {
        String userId = "";
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM TRANSACTIONS WHERE transId = ?");
            ps.setString(1, transId);
            ResultSet rs = ps.executeQuery();
            if(rs.next())
                userId = rs.getString(1);
        } catch (SQLException ex) {
            ex.getMessage();
        }
        
        return userId;
    }
    
    
    @Override
    public boolean addTransaction(TransactionBean transaction, Connection conn) {

    boolean flag = false;

    try {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO TRANSACTIONS (transId, user_id, time, amount, orderId, payStatus, payType) VALUES (?, ?, ?, ?, ?, ?, ?)"
        );

        ps.setString(1, transaction.getTransId());
        ps.setString(2, transaction.getUserName());
        ps.setString(3, transaction.getTransDateTime().toString());
        ps.setDouble(4, transaction.getTransAmount());
        ps.setString(5, transaction.getOrderId());
        ps.setString(6, "SUCCESS");
        ps.setString(7, transaction.getTransType());
        

        flag = ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return flag;
}

    @Override
    public boolean addTransaction(String tranId, String userId, String orderId, double amount, String transType, Timestamp transDate) {
      
        boolean flag = false;
//        Connection dbUtil;

    try(Connection conn = dbUtil.provideConnection();) {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO TRANSACTIONS (transId, user_id, time, amount, orderId, payStatus, payType) VALUES (?, ?, ?, ?, ?, ?, ?)"
        );

        ps.setString(1, tranId);
        ps.setString(2, userId);
        ps.setTimestamp(3, transDate);
        ps.setDouble(4, amount);
        ps.setString(5, orderId);
        ps.setString(6, "PENDING");
        ps.setString(7, transType);
        

        flag = ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return flag;
    
    }

    @Override
    public void updatePayment(String txnId, String status, String mode) {
        try (Connection con = dbUtil.provideConnection()) {

            String sql = "UPDATE TRANSACTIONS SET payStatus=?, payType=? WHERE transId=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, status);
            ps.setString(2, mode);
            ps.setString(3, txnId);

            int k = ps.executeUpdate();
            
            if(k>0)
                System.out.println("Payment SUCCESS");
            else
                System.out.println("Payment FAILED");         
            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

   
    
}
