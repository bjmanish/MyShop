package com.myshop.service.impl;

import com.myshop.beans.TransactionBean;
import com.myshop.service.TransactionService;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class TransactionServiceImpl implements TransactionService {

    @Override
    public String getUserId(String transId) {
        String userId = "";
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM PAYMENTS WHERE payment_id = ?");
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
    public boolean addTransaction(TransactionBean transaction) {

        boolean flag = false;

        try {
            Connection conn = dbUtil.provideConnection();

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO PAYMENTS VALUES(?,?,?,?,?,?)"
            );

            ps.setString(1, transaction.getTransId());
            ps.setString(2, transaction.getOrderId());
            ps.setString(3, transaction.getUserName());
            ps.setDouble(4, transaction.getTransAmount());
            ps.setString(5, "SUCCESS");
            ps.setTimestamp(6, transaction.getTransDateTime());
//            ps.setTimestamp(6, new java.util.DateTime());
            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }
    
}
