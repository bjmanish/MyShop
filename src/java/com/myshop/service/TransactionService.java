package com.myshop.service;

import com.myshop.beans.TransactionBean;
import java.sql.Connection;

public interface TransactionService {
    
    public String getUserId(String transId);
    
    public boolean addTransaction(TransactionBean transaction, Connection conn);
    
}
