package com.myshop.service;

import com.myshop.beans.OrderBean;
import com.myshop.beans.OrderDetails;
import com.myshop.beans.TransactionBean;
import java.util.List;

public interface OrderService {
    
    public boolean addOrder(OrderBean order);
    
    public boolean addTransaction(TransactionBean order);
    
    public String paymentSuccess(String userName, double paidAmount);
    
    public int countSoldItem(String prodId);
    
    public String shipNow(String orderId, String prodId);
    
    public List <OrderBean> getAllOrders();
    
    public List <OrderBean> getOrderByUserId(String emailId);
    
    public List <OrderDetails> getAllOrderDetails(String userEmailId);
    
}
