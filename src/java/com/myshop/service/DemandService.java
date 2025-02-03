package com.myshop.service;

import com.myshop.beans.DemandBean;
import java.util.List;


public interface DemandService {
    
    public boolean addProduct(String userName, String prodId, int demandQty);
    
    public boolean addProduct(DemandBean userDemand);
    
    public boolean removeProduct(String userId, String prodId);
    
    public List<DemandBean> haveDemanded(String prodId);
    
}
