package com.myshop.service;

import com.myshop.beans.UserBean;
import com.myshop.beans.UserDetails;
import java.io.InputStream;
import java.util.List;

public interface UserService {
       
    public String registerUser(UserBean user, InputStream inputStreamImage);
    
    public boolean isRegistered(String emailId);
    
    public UserBean loginUser(String email, String password);
    
    public String isValidCredential(String emailId, String password);
    
    public UserBean getUserDetails(String email, String password);
    
    public String getFirstName(String emailId);
    
    public String getUserAddr(String userId);
    
    public byte[] getProfileImg(String userId);
    
    public void verifyMobile(String mobile, String email);
    
    public UserBean getUserDetailsById(int userId);
    
    public String generateUserId();
    
    public List<UserDetails> getAllUsers();
}
