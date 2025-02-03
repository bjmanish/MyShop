package com.myshop.service.impl;

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
            PreparedStatement ps = conn.prepareStatement("SELECT userName FROM TRANSACTIONS WHERE transId = ?");
            ps.setString(1, transId);
            ResultSet rs = ps.executeQuery();
            if(rs.next())
                userId = rs.getString(1);
        } catch (SQLException ex) {
            ex.getMessage();
        }
        
        return userId;
    }
    
}
