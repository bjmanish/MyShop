package com.myshop.service.impl;

import com.myshop.beans.StaffBean;
import com.myshop.beans.UserBean;
import com.myshop.service.StaffService;
//import com.myshop.utility.MailMessage;
import com.myshop.utility.PasswordEncryption;
import com.myshop.utility.dbUtil;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author Admin
 */
public class StaffServiceImpl implements StaffService {
    
    
    @Override
    public String registerStaff(UserBean user, StaffBean staff, InputStream image) {
        
            String status = "Staff added failed!";
        
            boolean isRegtd = isStaffRegistered(user.getEmail());
            if(isRegtd){
                status = "Email Id Already Registered!";
                return status;
            }
            String sId = generateStaffId();
            System.out.println("Staff Id: "+sId);
            try(Connection conn = dbUtil.provideConnection();){
                String encryptedPassword = PasswordEncryption.getEncryptedPassword(user.getPassword());
                    PreparedStatement ps2 = conn.prepareStatement("INSERT INTO USERS(image, email, name, mobile, address, pincode, password, role_id, email_verified, mobile_verified, user_id) " +
                     "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                    
                    ps2.setBinaryStream(1, image);
                    ps2.setString(2, user.getEmail());
                    ps2.setString(3, user.getName());
                    ps2.setString(4, user.getMobile());
                    ps2.setString(5, user.getAddress());
                    ps2.setInt(6, user.getPincode());
                    ps2.setString(7, encryptedPassword);
                    ps2.setString(8, user.getRoleId()); // 👉 default role = DELIVERY
                    ps2.setInt(9, user.getEmailVerified());
                    ps2.setInt(10, user.getMobileVerified());            
                    ps2.setString(11, sId);
                    
                    int k1 = ps2.executeUpdate();
                    if(k1 > 0){
//                        Connection conn = dbUtil.provideConnection();
                        PreparedStatement ps = conn.prepareStatement("INSERT INTO STAFF_DETAILS VALUES(?,?,?,?)");
                
                        ps.setString(1, sId);
                        ps.setString(2, staff.getVehicle_type());
                        ps.setString(3, staff.getLicense_number());
                        ps.setString(4, staff.getAvailability_status());
                        int k = ps.executeUpdate();
                        //System.out.println("status: "+k);
//                        System.out.println("Staffdata: "+ps.toString());
                        System.out.println("data added in staff_details and user table ");
                        status = "SUCCESS";
                    }else{
                    System.out.println("Error during inserting data in user table of staff");
                    status = "SERVER DIDNOT RESPONSE";
                }
            }catch(SQLException ex){
                status = "Error in DB SRVER.";
                System.out.println("error in DB for adding staff: "+ex.getMessage());
            }
//            catch (MessagingException ex) {
//                status = "mail could not send mail :";
//                System.out.println("Error for sending mail :"+ex.getMessage());
//            }
                
        return status;
    }

    private boolean isStaffRegistered(String email) {
        
            boolean flag = false;
        
//            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = null;
            ResultSet rs = null;
        
            try{
                Connection conn = dbUtil.provideConnection();
                ps = conn.prepareStatement("SELECT 1 FROM STAFF_DETAILS WHERE email = ?");
            
                ps.setString(1, email);
                rs = ps.executeQuery();
                if(rs.next())   flag = true;            
            
            }catch(SQLException e){
                e.printStackTrace();
            }
        
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);
        
        return flag;
        
    }

    @Override
    public StaffBean getStaffDetails(String email, String password) {
        StaffBean staff = null;
        String EncryptPassword = PasswordEncryption.getEncryptedPassword(password);
//        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            Connection conn = dbUtil.provideConnection();
            ps = conn.prepareStatement("SELECT * FROM STAFF_DETAILS WHERE email = ? and spassword = ?");
            
            ps.setString(1, email);
            ps.setString(2, EncryptPassword);
            
            rs = ps.executeQuery();
            if(rs.next()){
               staff = new StaffBean();
               //InputStream inputStream = rs.getBinaryStream("image");
//               staff.setStaffName(rs.getString("sname"));
//               staff.setMobile(rs.getString("smobile"));
               staff.setStaffId(rs.getString("semail"));
//               staff.setPassword(rs.getString("spassword"));
            }  
        }catch(SQLException ex){
            System.out.println("Error in db"+ex.getMessage());
            ex.printStackTrace();
        }
       
        
	dbUtil.closeConnection(ps);
	dbUtil.closeConnection(rs);
        
        return staff;
        
    }

    @Override
    public boolean isRegistered(String emailId) {
        boolean flag = false;
        
//        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            Connection conn = dbUtil.provideConnection();
            ps = conn.prepareStatement("SELECT * FROM DELIVERYSTAFF WHERE email = ?");
            
            ps.setString(1, emailId);
            rs = ps.executeQuery();
            if(rs.next())   flag = true;            
            
        }catch(SQLException e){
            e.printStackTrace();
        }
        
        
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);
        
        return flag;
    }

    @Override
    public String isValidCredential(String emailId, String password) {
        String status = "Login Denied! Incorrect Username or Password. Try Again!";
        
        String Encryptedpassword = PasswordEncryption.getEncryptedPassword(password);
        //System.out.println("EncryptedPassword: "+Encryptedpassword);
        
        
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            Connection conn = dbUtil.provideConnection();
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
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM STAFF_DETAILS");
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                StaffBean staff = new StaffBean();
                staff.setStaffId(rs.getString(1));
                staff.setVehicle_type(rs.getString(2));
                staff.setLicense_number(rs.getString(3));
                staff.setAvailability_status(rs.getString(4));
//                staff.setMobile(rs.getString("smobile"));
//                staff.setStaffProfile(rs.getAsciiStream("simage"));
                
                staffList.add(staff);
                staffList.toString();
            }
        } catch (SQLException ex) {
            ex.getMessage();
        }
        
        return staffList;
    }

    @Override
    public String generateStaffId() {
        String baseId = null;
        // Add random suffix to avoid collision
    String random = UUID.randomUUID().toString().substring(0, 3).toUpperCase();
    String sql = "SELECT TOP 1 staff_id FROM STAFF_DETAILS ORDER BY staff_id DESC";
    try(Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
//    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String lastId = rs.getString("staff_id");
        int num = Integer.parseInt(lastId.substring(3));
        num++;
        baseId = String.format("STF%03d", num);
    } else {
        baseId = "STF001";
    }

    
    }catch (SQLException ex) {
            
    }
    return baseId + random; // USR005A1B
    }
    
}
