package com.myshop.beans;

import java.io.Serializable;
import java.io.InputStream;

@SuppressWarnings("serial")
public class UserBean implements Serializable {
    
    private String id;
    private InputStream image;
    private String name;
    private String mobile;
    private String email;
    private String address;
    private int pincode;
    private String password;
    private int emailVerified = 1;   // default
    private int mobileVerified = 0;  // default
    
    private String roleId;
    private String roleName;
    
    
    
    public UserBean() {}

    public UserBean(String id, InputStream image, String name, String mobile, String email, String address, int pincode, String password) {
        this.id = id;
        this.image = image;
        this.name = name;
        this.mobile = mobile;
        this.email = email;
        this.address = address;
        this.pincode = pincode;
        this.password = password;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    @Override
    public String toString() {
        return "UserBean{" + "id=" + id + ", image=" + image + ", name=" + name + ", mobile=" + mobile + ", email=" + email + ", address=" + address + ", pincode=" + pincode + ", password=" + password + ", emailVerified=" + emailVerified + ", mobileVerified=" + mobileVerified + ", roleId=" + roleId + ", roleName=" + roleName + '}';
    }

    
    
    
    
    
}
