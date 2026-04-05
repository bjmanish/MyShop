package com.myshop.service.impl;

import com.myshop.beans.UserBean;
import com.myshop.beans.UserDetails;
import com.myshop.service.UserService;
//import com.myshop.utility.MailMessage;
import com.myshop.utility.dbUtil;
import com.myshop.utility.PasswordEncryption;

import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserServiceImpl implements UserService {

    /* ================= REGISTER ================= */
    @Override
    public String registerUser(UserBean user, InputStream imageInputStream) {

        String status = "User Registration Failed!";

        if (isRegistered(user.getEmail())) {
            return "Email Id Already Registered!";
        }

        String encryptedPassword = PasswordEncryption.getEncryptedPassword(user.getPassword());

        try (Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO USERS(image, email, name, mobile, address, pincode, password, role_id, email_verified, mobile_verified, user_id) " +
                     "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")) {

            ps.setBinaryStream(1, imageInputStream);
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getName());
            ps.setString(4, user.getMobile());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getPincode());
            ps.setString(7, encryptedPassword);

            ps.setString(8, "R003"); // 👉 default role = customer

            ps.setInt(9, user.getEmailVerified());
            ps.setInt(10, user.getMobileVerified());
            
            ps.setString(11, generateUserId());

            int k = ps.executeUpdate();

            if (k > 0) {
                status = "User Registered Successfully! Please check your mail.";
//                MailMessage.registrationSuccess(user.getEmail(), user.getName().split(" ")[0]);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            status = "Error: " + e.getMessage();
        }

        return status;
    }

    /* ================= CHECK REGISTER ================= */
    @Override
    public boolean isRegistered(String emailId) {

        try (Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM USERS WHERE email = ?")) {

            ps.setString(1, emailId);
            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /* ================= LOGIN WITH ROLE ================= */
    @Override
    public UserBean loginUser(String email, String password) {

        UserBean user = null;

        String encryptedPassword = PasswordEncryption.getEncryptedPassword(password);
//        System.out.println("Encrypted Password from Service :"+encryptedPassword);
        
        String query = "SELECT u.*, r.role_name FROM USERS u " +
                       "JOIN ROLES r ON u.role_id = r.role_id " +
                       "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            if(conn == null){
                System.out.println("Connection is null :");
            }else{
                System.out.println("Connection is established :");
            }
            ps.setString(1, email);
            ps.setString(2, encryptedPassword);

            ResultSet rs = ps.executeQuery();
            
//            System.out.println("Result set:"+rs);

            if (rs.next()) {
                user = new UserBean();

                user.setId(rs.getString("user_id"));
                user.setEmail(rs.getString("email"));
                user.setName(rs.getString("name"));
                user.setMobile(rs.getString("mobile"));
                user.setAddress(rs.getString("address"));
                user.setPincode(rs.getInt("pincode"));
                
                String role = rs.getString("role_name");
                String roleId = rs.getString("role_id");
                if(role == null ){
                    role = "CUSTOMER";
                    roleId = "R003";
                }                        
                user.setRoleId(roleId);
                user.setRoleName(role);
            }
//             System.out.println("User data: "+user.toString());

        } catch (SQLException e) {
            System.out.println("error :"+e.getMessage());
            e.printStackTrace();
        }

        return user;
    }

    /* ================= OTHER METHODS (UNCHANGED BUT FIXED PASSWORD) ================= */

    @Override
    public UserBean getUserDetails(String emailId, String password) {

        UserBean user = null;
        String encryptedPassword = PasswordEncryption.getEncryptedPassword(password);

        try (Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM USERS WHERE email = ?")) {

            ps.setString(1, emailId);
//            ps.setString(2, encryptedPassword);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new UserBean();

                user.setName(rs.getString("name"));
                user.setMobile(rs.getString("mobile"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setPincode(rs.getInt("pincode"));
                user.setImage(rs.getBinaryStream("image"));
                user.setId(rs.getString("user_id"));
            }
//            System.out.println("USER details: "+user);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public String isValidCredential(String emailId, String password) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getFirstName(String emailId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getUserAddr(String userId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public byte[] getProfileImg(String userId) {
        
        byte[] image = null;
        
        String sql = "SELECT IMAGE FROM USERS WHERE USER_ID = ?";
        
        try(Connection conn = dbUtil.provideConnection();
                PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                image = rs.getBytes("image");
            }
        } catch (SQLException ex) {
             ex.printStackTrace();
        }
        
        return image;
    }

    @Override
    public void verifyMobile(String mobile, String email) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public UserBean getUserDetailsById(int userId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    @Override
    public String generateUserId() {
        String baseId = null;
        // Add random suffix to avoid collision
    String random = UUID.randomUUID().toString().substring(0, 3).toUpperCase();
    String sql = "SELECT TOP 1 user_id FROM USERS ORDER BY user_id DESC";
    try(Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
//    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String lastId = rs.getString("user_id");
        int num = Integer.parseInt(lastId.substring(3));
        num++;
        baseId = String.format("USR%03d", num);
    } else {
        baseId = "USR001";
    }

    
    }catch (SQLException ex) {
            
    }
    return baseId + random; // USR005A1B
}

    @Override
    public List<UserDetails> getAllUsers() {
        List<UserDetails> list = new ArrayList<>();

        try (Connection con = dbUtil.provideConnection()) {

            String query = "SELECT u.*,\n" +
                "(SELECT r.role_name FROM ROLES r WHERE r.role_id = u.role_id) AS role_name,\n" +
                "(SELECT s.vehicle_type FROM STAFF_DETAILS s WHERE s.staff_id = u.user_id) AS vehicle_type,\n" +
                "(SELECT s.availability_status FROM STAFF_DETAILS s WHERE s.staff_id = u.user_id) AS availability_status,\n" +
                "(SELECT s.license_number FROM STAFF_DETAILS s WHERE s.staff_id = u.user_id) AS license_number\n" +
                "FROM USERS u ORDER BY u.created_at";

            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserDetails u = new UserDetails();
                u.setUserId(rs.getString("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setMobile(rs.getString("mobile"));
                u.setRoleName(rs.getString("role_id"));
                u.setStatus(rs.getString("status"));
                u.setAddress(rs.getString("address"));
                u.setPincode(rs.getInt("pincode"));
                u.setImage(rs.getBinaryStream("image"));
                u.setRoleName(rs.getString("role_name"));
                u.setAvailability_status(rs.getString("availability_status"));
                u.setVehicle_type(rs.getString("vehicle_type"));
                u.setLicense_number(rs.getString("license_number"));
                list.add(u);
            }   
        
        } catch (Exception e) {
            System.out.println("Error during query execution of gell usersDetails() :"+e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
}