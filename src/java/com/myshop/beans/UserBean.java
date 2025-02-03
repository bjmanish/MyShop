//also known as pojo

package com.myshop.beans;

import java.io.Serializable;
import java.io.InputStream;

@SuppressWarnings("serial")
public class UserBean implements Serializable {
    private InputStream image;
    private String name;
    private String mobile;
    private String email;
    private String address;
    private int pincode;
    private String password;
    
    public UserBean() {
    }

    public UserBean(InputStream image, String name, String mobile, String email, String address, int pincode, String password) {
        super();
        this.image = image;
        this.name = name;
        this.mobile = mobile;
        this.email = email;
        this.address = address;
        this.pincode = pincode;
        this.password = password;
    }

    @Override
    public String toString() {
        return "UserBean{" + "image=" + image + ", name=" + name + ", mobile=" + mobile + ", email=" + email + ", address=" + address + ", pincode=" + pincode + ", password=" + password + '}';
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
    
    
    

    
    
}
