package com.myshop.service.impl;

import com.myshop.beans.DemandBean;
import com.myshop.service.DemandService;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DemandServiceImpl implements DemandService{

    @Override
    public boolean addProduct(String userName, String prodId, int demandQty) {
        boolean flag = false;
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM USER_DEMAND WHERE userName=? AND prodId=?");
            ps.setString(1, userName);
            ps.setString(2, prodId);
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                flag = true;
            }else{
                PreparedStatement ps2 = conn.prepareStatement("INSERT INTO USER_DEMAND VALUES(?,?,?)");
                ps2.setString(1, userName);
                ps2.setString(2, prodId);
                ps2.setInt(3, demandQty);
                
                int k  = ps2.executeUpdate();
                if(k > 0)
                    flag = true;
            }
        }catch(SQLException ex){
            System.out.println("Error in db for adding data : "+ex.getMessage());
            flag = false;
            ex.getMessage();
        }
        
        return flag;
    }

    @Override
    public boolean addProduct(DemandBean userDemand) {
        
        return addProduct(userDemand.getUserName(), userDemand.getProdId(), userDemand.getDemandQty());
    }

    @Override
    public boolean removeProduct(String userId, String prodId) {
        boolean flag = false;
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT * FROM USER_DEMAND WHERE userName=? AND prodId=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            rs = ps.executeQuery();
            if(rs.next()){
                ps2 = conn.prepareStatement("DELETE FROM USER_DEMAND WHERE userName=? AND prodId=?");
                ps2.setString(1, userId);
                ps2.setString(2, prodId);
                
                int k = ps.executeUpdate();
                if(k > 0 ){
                    flag = true;
                }
            }else{
                flag = true;
            }
        } catch (SQLException ex) {
            System.out.println("Error in db for fetching data : "+ex.getMessage());
            flag = false;
            ex.getMessage();
        }
        
        dbUtil.closeConnection(conn);
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(ps2);
        dbUtil.closeConnection(rs);
        
        return flag;
    }

    @Override
    public List<DemandBean> haveDemanded(String prodId) {
        List<DemandBean> demandList = new ArrayList<>();
        DemandBean demand = null;
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM USER_DEMAND WHERE prodId=?");
            ps.setString(1, prodId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                demand = new DemandBean();
                demand.setUserName(rs.getString("userName"));
                demand.setProdId(rs.getString("prodId"));
                demand.setDemandQty(rs.getInt("quantity"));
                demandList.add(demand);
            }
        } catch (SQLException ex) {
            System.out.println("Error in getting data from db: "+ex.getMessage());
            ex.getMessage();
        }
        return demandList;
    }
    
}
