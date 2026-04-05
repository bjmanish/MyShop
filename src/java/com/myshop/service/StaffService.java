/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.service;

import com.myshop.beans.StaffBean;
import com.myshop.beans.UserBean;
import java.io.InputStream;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface StaffService {
    
    
    public String generateStaffId();
    
    public String registerStaff(UserBean user, StaffBean staff, InputStream inputStreamImage);
    
    public boolean isRegistered(String emailId);
    
    public String isValidCredential(String emailId, String password);
    
    public StaffBean getStaffDetails(String email, String password);
    
    public byte[] getProfileImg(String userId);
    
    public List<StaffBean> getAllStaffs();
    
   // public String getStaffId();
    
}
