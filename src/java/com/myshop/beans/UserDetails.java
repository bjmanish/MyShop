/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.beans;

import java.io.InputStream;

/**
 *
 * @author Admin
 */
public class UserDetails {
    
    private String userId;
    private InputStream image;
    private String name;
    private String mobile;
    private String email;
    private String address;
    private int pincode;
    private String password;
    private String status;
    private int emailVerified = 1;   // default
    private int mobileVerified = 0;  // default
    
    private String roleId;
    private String roleName;
    
    private String vehicle_type;
    private String license_number;
    private String availability_status;

    public UserDetails() {}

    public UserDetails(String userId, InputStream image, String name, String mobile, String email, String address, int pincode, String password, String roleId, String roleName, String vehicle_type, String license_number, String availability_status, String status) {
        this.userId = userId;
        this.image = image;
        this.name = name;
        this.mobile = mobile;
        this.email = email;
        this.address = address;
        this.pincode = pincode;
        this.password = password;
        this.roleId = roleId;
        this.roleName = roleName;
        this.vehicle_type = vehicle_type;
        this.license_number = license_number;
        this.availability_status = availability_status;
        this.status = status;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public InputStream getImage() {
        return image;
    }

    public void setImage(InputStream image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getPincode() {
        return pincode;
    }

    public void setPincode(int pincode) {
        this.pincode = pincode;
    }
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(int emailVerified) {
        this.emailVerified = emailVerified;
    }

    public int getMobileVerified() {
        return mobileVerified;
    }

    public void setMobileVerified(int mobileVerified) {
        this.mobileVerified = mobileVerified;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getVehicle_type() {
        return vehicle_type;
    }

    public void setVehicle_type(String vehicle_type) {
        this.vehicle_type = vehicle_type;
    }

    public String getLicense_number() {
        return license_number;
    }

    public void setLicense_number(String license_number) {
        this.license_number = license_number;
    }

    public String getAvailability_status() {
        return availability_status;
    }

    public void setAvailability_status(String availability_status) {
        this.availability_status = availability_status;
    }

    @Override
    public String toString() {
        return "UserDetails{" + "userId=" + userId + ", image=" + image + ", name=" + name + ", mobile=" + mobile + ", email=" + email + ", address=" + address + ", pincode=" + pincode + ", password=" + password + ", emailVerified=" + emailVerified + ", mobileVerified=" + mobileVerified + ", roleId=" + roleId + ", roleName=" + roleName + ", vehicle_type=" + vehicle_type + ", license_number=" + license_number + ", availability_status=" + availability_status + '}';
    }
    
    
    
    
    
    
    
    
}
