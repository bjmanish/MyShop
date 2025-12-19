package com.myshop.service.impl;

import com.myshop.beans.StaffBean;
import com.myshop.service.StaffService;
import com.myshop.utility.MailMessage;
import com.myshop.utility.PasswordEncryption;
import com.myshop.utility.dbUtil;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;

/**
 *
 * @author Admin
 */
public class StaffServiceImpl implements StaffService {
    
    
    @Override
    public String registerStaff(StaffBean staff, InputStream inputStreamImage) {
        
            String status = "Staff added failed!";
        
            boolean isRegtd = isStaffRegistered(staff.getStaffId());
            if(isRegtd){
                status = "Email Id Already Registered!";
                return status;
            }
            int sId = getNewId();
            System.out.println("Staff Id: "+sId);
            try{
                Connection conn = dbUtil.provideConnection();
                PreparedStatement ps = conn.prepareStatement("INSERT INTO DELIVERYSTAFF VALUES(?,?,?,?,?,?)");
                //set image as binary Stream  
                ps.setBinaryStream(1, inputStreamImage);
                ps.setString(2, staff.getStaffId());
                ps.setString(3, staff.getStaffName());
                ps.setString(4, staff.getMobile());
                ps.setString(5, staff.getPassword());
                ps.setInt(6, sId);
                int k = ps.executeUpdate();
                //System.out.println("status: "+k);
                System.out.println("userdata: "+ps.toString());
                if(k > 0){
                    status = "Staff addedd Successfully! And successfully send mail.";
                    MailMessage.staffRegistrationSuccess(staff, staff.getStaffName().split(" ")[0]);
                }
            }catch(SQLException ex){
                String error = "Error in DB System.";
                status = error +" Error: "+ ex.getMessage();
                System.out.println("error in DB for adding staff: "+status);
            } catch (MessagingException ex) {
                status = "mail could not send mail :";
                System.out.println("Error for sending mail :"+ex.getMessage());
            }
                
        return status;
    }

    private boolean isStaffRegistered(String email) {
        
            boolean flag = false;
        
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = null;
            ResultSet rs = null;
        
            try{
                ps = conn.prepareStatement("SELECT * FROM DELIVERYSTAFF WHERE semail = ?");
            
                ps.setString(1, email);
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
    public StaffBean getStaffDetails(String email, String password) {
        StaffBean staff = null;
        String EncryptPassword = PasswordEncryption.getEncryptedPassword(password);
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement("SELECT * FROM DELIVERYSTAFF WHERE semail = ? and spassword = ?");
            
            ps.setString(1, email);
            ps.setString(2, EncryptPassword);
            
            rs = ps.executeQuery();
            if(rs.next()){
               staff = new StaffBean();
               //InputStream inputStream = rs.getBinaryStream("image");
               staff.setStaffName(rs.getString("sname"));
               staff.setMobile(rs.getString("smobile"));
               staff.setStaffId(rs.getString("semail"));
               staff.setPassword(rs.getString("spassword"));
            }  
        }catch(SQLException ex){
            System.out.println("Error in db"+ex.getMessage());
            ex.printStackTrace();
        }
       
        dbUtil.closeConnection(conn);
	dbUtil.closeConnection(ps);
	dbUtil.closeConnection(rs);
        
        return staff;
        
    }

    @Override
    public boolean isRegistered(String emailId) {
        boolean flag = false;
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT * FROM DELIVERYSTAFF WHERE semail = ?");
            
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
            ps = conn.prepareStatement("SELECT * FROM DELIVERYSTAFF WHERE semail = ? and spassword = ?");
            
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
    public byte[] getProfileImg(String staffId) {
        byte[] image = null;
       
       try{
           Connection conn = dbUtil.provideConnection();
           PreparedStatement ps = conn.prepareStatement("SELECT simage FROM DELIVERYSTAFF WHERE semail=?");
           ps.setString(1, staffId);
           ResultSet rs = ps.executeQuery();
           if(rs.next()){
               image  = rs.getBytes("simage");
//               System.out.println("simage: "+image);
           }
//           System.out.println("image url:"+image);
        } catch (SQLException ex) {
            System.out.println("Error in fetching Image from database: "+ex.getMessage());
            ex.printStackTrace();
        }
       
       return image;
    }

    @Override
    public List<StaffBean> getAllStaffs() {
        List<StaffBean> staffList = new ArrayList<>();
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM DELIVERYSTAFF");
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                StaffBean staff = new StaffBean();
                staff.setsId(rs.getString("sid"));
                staff.setStaffId(rs.getString("semail"));
                staff.setStaffName(rs.getString("sname"));
                staff.setMobile(rs.getString("smobile"));
                staff.setStaffProfile(rs.getAsciiStream("simage"));
                
                staffList.add(staff);
                staffList.toString();
            }
        } catch (SQLException ex) {
            ex.getMessage();
        }
        
        return staffList;
    }

    @Override
    public int getNewId() {
        int sid=0;
        try {
            Connection conn = dbUtil.provideConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("Select max(sid) from DELIVERYSTAFF");        
            rs.next();
            int id = rs.getInt(1);            
            if (id != 0) {
//                id = id.substring(4);
                sid +=id+1;
            } else {
                sid = 101;
            }
        }catch (SQLException ex) {
            ex.getMessage();
            ex.printStackTrace();
        }
        return sid;
    }

    
    
}
