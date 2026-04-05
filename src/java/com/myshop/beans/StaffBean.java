/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.beans;
  
import java.io.Serializable;

@SuppressWarnings("serial")
public class StaffBean implements Serializable{
    
    private String staffId;
    private String vehicle_type;
    private String license_number;
    private String availability_status;

    public StaffBean() {
    }
    
    public StaffBean(String staffId, String vehicle_type, String license_number, String availability_status) {
        this.staffId = staffId;
        this.vehicle_type = vehicle_type;
        this.license_number = license_number;
        this.availability_status = availability_status;
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

    @Override
    public String toString() {
        return "StaffBean{" + "staffId=" + staffId + ", vehicle_type=" + vehicle_type + ", license_number=" + license_number + ", availability_status=" + availability_status + '}';
    }    
}