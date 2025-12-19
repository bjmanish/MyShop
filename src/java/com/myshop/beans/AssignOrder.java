package com.myshop.beans;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class AssignOrder {
    private String orderId;
    private String staffId;
    private Timestamp assignDate;
    private String DeliveryStatus;
    private String otp;
    private LocalDateTime otpGeneratedAt;
    private int assignId;
    private String staffName;
    public AssignOrder() {
        super();
    }
    
    public AssignOrder(String orderId, String staffId, Timestamp assignDate, String DeliveryStatus, String otp, LocalDateTime otpGeneratedAt) {
        this.orderId = orderId;
        this.staffId = staffId;
        this.assignDate = assignDate;
        this.DeliveryStatus = DeliveryStatus;
        this.otp = otp;
        this.otpGeneratedAt = otpGeneratedAt;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    
    
    public int getAssignId() {
        return assignId;
    }

    public void setAssignId(int assignId) {
        this.assignId = assignId;
    }

    
    
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public Timestamp getAssignDate() {
        return assignDate;
    }

    public void setAssignDate(Timestamp assignDate) {
        this.assignDate = assignDate;
    }

    public String getDeliveryStatus() {
        return DeliveryStatus;
    }

    public void setDeliveryStatus(String DeliveryStatus) {
        this.DeliveryStatus = DeliveryStatus;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public LocalDateTime getOtpGeneratedAt() {
        return otpGeneratedAt;
    }

    public void setOtpGeneratedAt(LocalDateTime otpGeneratedAt) {
        this.otpGeneratedAt = otpGeneratedAt;
    }

    @Override
    public String toString() {
        return "AssignOrder{" + "orderId=" + orderId + ", staffId=" + staffId + ", assignDate=" + assignDate + ", DeliveryStatus=" + DeliveryStatus + ", otp=" + otp + ", otpGeneratedAt=" + otpGeneratedAt + '}';
    }   

}