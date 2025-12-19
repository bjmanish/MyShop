/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.beans;
  
import java.io.InputStream;
import java.io.Serializable;

@SuppressWarnings("serial")
public class StaffBean implements Serializable{
    
    private String sId;
    private String staffId;
    private String staffName;
    private String mobile;
    private String password;
    private InputStream staffProfile;

    public StaffBean() {
        super();
    }

    public StaffBean(String staffId, String sId, String staffName, String mobile, String password, InputStream staffProfile) {
        this.staffId = staffId;
        this.sId = sId;
        this.staffName = staffName;
        this.mobile = mobile;
        this.password = password;
        this.staffProfile = staffProfile;
    }
    
    public String getsId() {
        return sId;
    }

    public void setsId(String sId) {
        this.sId = sId;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public InputStream getStaffProfile() {
        return staffProfile;
    }

    public void setStaffProfile(InputStream staffProfile) {
        this.staffProfile = staffProfile;
    }

    @Override
    public String toString() {
        return "StaffBean{" + "staffId=" + staffId + ", staffName=" + staffName + ", mobile=" + mobile + ", password=" + password + ", staffProfile=" + staffProfile + '}';
    }   
    
    
    
    
}
