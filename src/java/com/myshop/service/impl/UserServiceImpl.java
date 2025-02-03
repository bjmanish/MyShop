package com.myshop.service.impl;

import com.myshop.beans.UserBean;
import com.myshop.constants.IUserConstants;
import com.myshop.service.UserService;
import com.myshop.utility.MailMessage;
import com.myshop.utility.dbUtil;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.mail.MessagingException;
import com.myshop.utility.PasswordEncryption;

public class UserServiceImpl implements UserService{

//    @Override
//    public String registerUser(String userName, String mobileNo, String emailId, String address, int pinCode, String password) {
//        
//        String Encryptpassword = PasswordEncryption.getEncryptedPassword(password);
//        UserBean user = new UserBean(userName, mobileNo, emailId, address, pinCode, Encryptpassword);
//        String status = registerUser(user, inputStreamImage);
//        return status;
//    }

    @Override
    public String registerUser(UserBean user, InputStream imageInputStream) {
        String status = "User Registration Failed!";
        
        boolean isRegtd = isRegistered(user.getEmail());
        if(isRegtd){
            status = "Email Id Already Registered!";
            return status;
        }
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        if(conn != null){
            System.out.println("Connection Successsfully!");
        }
        
        try{
            String query = "INSERT INTO "+IUserConstants.TABLE_USER+" VALUES(?,?,?,?,?,?,?)";
            ps = conn.prepareStatement(query);;
            
            //set image as binary Stream  
            ps.setBinaryStream(1, imageInputStream);
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getName());
            ps.setString(4, user.getMobile());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getPincode());
            ps.setString(7, user.getPassword());
            
            int k = ps.executeUpdate();
            //System.out.println("status: "+k);
            //System.out.println("userdata: "+ps.toString());
            if(k > 0){
                status = "User Rgistered Successfully!Please checked your mail.";
                MailMessage.registrationSuccess(user.getEmail(), user.getName().split(" ")[0]);
            }
        }catch(SQLException ex){
            String error = "Error in DB System.";
            status = error +" Error: "+ ex.getMessage();
            System.out.println("error in DB for adding customers: "+status);
        } catch (MessagingException ex) {
            System.out.println("Error for sending mail :"+ex.getMessage());
        }
        
        dbUtil.closeConnection(conn);
        dbUtil.closeConnection(ps);
        
        
        return status;
    }

    @Override
    public boolean isRegistered(String emailId) {
        boolean flag = false;
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT * FROM USER WHERE email = ?");
            
            ps.setString(1, emailId);
            rs = ps.executeQuery();
            if(rs.next())   flag = true;            
            
        }catch(SQLException e){
            e.printStackTrace();
        }
        
        dbUtil.closeConnection(conn);
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);
        
        return flag;
    }

    @Override
    public String isValidCredential(String emailId, String password) {
        String status = "Login Denied! Incorrect Username or Password. Try Again!";
        
        String Encryptedpassword = PasswordEncryption.getEncryptedPassword(password);
        //System.out.println("EncryptedPassword: "+Encryptedpassword);
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT * FROM USER WHERE email = ? and password = ?");
            
            ps.setString(1, emailId);
            ps.setString(2, Encryptedpassword);
            
            rs = ps.executeQuery();
            if(rs.next())
                status = "valid";
            
        }catch(SQLException ex){
            status  = "Error: "+ ex.getMessage();
            ex.printStackTrace();
        }
       
        dbUtil.closeConnection(conn);
	dbUtil.closeConnection(ps);
	dbUtil.closeConnection(rs);
        
        return status;
    }

    @Override
    public UserBean getUserDetails(String emailId, String password) {
        UserBean user = null;
        String EncryptPassword = PasswordEncryption.getEncryptedPassword(password);
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement("SELECT * FROM USER WHERE email = ? and password = ?");
            
            ps.setString(1, emailId);
            ps.setString(2, EncryptPassword);
            
            rs = ps.executeQuery();
            if(rs.next()){
               user = new UserBean();
               //InputStream inputStream = rs.getBinaryStream("image");
               user.setName(rs.getString("name"));
               user.setMobile(rs.getString("mobile"));
               user.setEmail(rs.getString("email"));
               user.setAddress(rs.getString("address"));
               user.setPincode(rs.getInt("pincode"));
               user.setPassword(rs.getString("password"));
            }  
        }catch(SQLException ex){
            System.out.println("Error in db"+ex.getMessage());
            ex.printStackTrace();
        }
       
        dbUtil.closeConnection(conn);
	dbUtil.closeConnection(ps);
	dbUtil.closeConnection(rs);
        
        return user;
    }

    @Override
    public String getFirstName(String emailId) {
        String fname = "";
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT name FROM USER WHERE email = ? ");
            
            ps.setString(1, emailId);
            
            rs = ps.executeQuery();
            if(rs.next())
                fname = rs.getString(1);
            fname = fname.split("")[0];
            
        }catch(SQLException ex){
            ex.printStackTrace();
        }
       
        dbUtil.closeConnection(conn);
        
        return fname;
    }

    @Override
    public String getUserAddr(String userId) {
    String address = "";
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT address FROM USER WHERE email = ?");
            
            ps.setString(1, userId);
            
            rs = ps.executeQuery();
            if(rs.next())
                address = rs.getString(1);
            
        }catch(SQLException ex){
           
            ex.printStackTrace();
        }
       
        dbUtil.closeConnection(conn);
	dbUtil.closeConnection(ps);
	dbUtil.closeConnection(rs);
        
        return address;
    }

    @Override
    public byte[] getProfileImg(String userId) {
       byte[] image = null;
       
       try{
           Connection conn = dbUtil.provideConnection();
           PreparedStatement ps = conn.prepareStatement("SELECT image FROM USER WHERE email=?");
           ps.setString(1, userId);
           ResultSet rs = ps.executeQuery();
           if(rs.next()){
               image  = rs.getBytes("image");
           }
        } catch (SQLException ex) {
            System.out.println("Error in fetching Image from database: "+ex.getMessage());
            ex.printStackTrace();
        }
       
       return image;
    }
   
}
