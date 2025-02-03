package com.myshop.service;

import com.myshop.beans.UserBean;
import java.io.InputStream;

public interface UserService {
    
    /*
    * private String userName; private String mobileNo; private String emailId;
    * private String address; private int pinCode; private String password;
    */
    
    //public String registerUser(String userName, String mobileNo, String emailId, String address, int pinCode, String password);
    
    public String registerUser(UserBean user, InputStream inputStreamImage);
    
    public boolean isRegistered(String emailId);
    
    public String isValidCredential(String emailId, String password);
    
    public UserBean getUserDetails(String email, String password);
    
    public String getFirstName(String emailId);
    
    public String getUserAddr(String userId);
    
    public byte[] getProfileImg(String userId);
}
