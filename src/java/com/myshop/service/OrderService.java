package com.myshop.service;

import com.myshop.beans.AssignOrder;
import com.myshop.beans.OrderBean;
import com.myshop.beans.OrderDetails;
import java.util.List;

public interface OrderService {
    
    public boolean addOrder(OrderBean order);
    
//    public boolean addTransaction(TransactionBean order);
    
    public String paymentSuccess(String payId, String ordId, String userId, String cartId, double paidAmount);
    
    public int countSoldItem(String prodId);
    
    public String shipNow(String orderId, String prodId);
    
    public List <OrderDetails> getAllOrders();
    
    public List <OrderBean> getOrderByUserId(String emailId);
    
    public List <OrderDetails> getAllOrderDetails(String userEmailId);
    
    public boolean outForDelivery(String userId, String orderId, String prodId, AssignOrder assignOrder);
    
    public boolean assignOrder(AssignOrder order);
    
    public int assignId();
    
    List<AssignOrder> getAssignedOrdersByStaff(String staffEmail);
    
    public String markOrderAsDelivered(int assignId, String staffId);
    
    public boolean updateOTPAfterDelivery(int assignId);
        
    public OrderDetails getOrderDetailsByOrdId(String ordId);
    
    String getOrderId(String userId);
    
}
