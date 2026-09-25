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
    
    private String staffId;
    private String vehicle_type;
    private String license_number;
    private String availability_status;
    private String mobile;
    private String name;
    private String email;
    private InputStream image;

    public StaffBean() {
    }
    
    public StaffBean(String staffId,String mobile, String name, String email, String vehicle_type, String license_number, String availability_status, InputStream iamge) {
        this.staffId = staffId;
        this.mobile = mobile;
        this.email = email;
        this.name = name;        
        this.vehicle_type = vehicle_type;
        this.license_number = license_number;
        this.availability_status = availability_status;
        this.image = image;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
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

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public InputStream getImage() {
        return image;
    }

    public void setImage(InputStream image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "StaffBean{" + "staffId=" + staffId + ", vehicle_type=" + vehicle_type + ", license_number=" + license_number + ", availability_status=" + availability_status + ", mobile=" + mobile + ", name=" + name + ", email=" + email + ", image=" + image + '}';
    }

            
}