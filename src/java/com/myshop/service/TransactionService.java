package com.myshop.service;

import com.myshop.beans.TransactionBean;

public interface TransactionService {
    
    public String getUserId(String transId);
    
    public boolean addTransaction(TransactionBean transaction);
    
}
