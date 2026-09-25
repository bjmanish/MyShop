package com.myshop.service;

import com.myshop.beans.TransactionBean;
import java.sql.Connection;
import java.sql.Timestamp;

public interface TransactionService {
    
    public String getUserId(String transId);
    
    public boolean addTransaction(TransactionBean transaction, Connection conn);
    
    public boolean addTransaction(String tranId, String userId, String orderId, double amount, String transType, Timestamp transDate);
    
    public void updatePayment(String txnId, String status, String mode);
    
}
