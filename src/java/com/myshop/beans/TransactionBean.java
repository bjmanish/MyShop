package com.myshop.beans;

import com.myshop.utility.idUtil;
import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

@SuppressWarnings("serial")
public class TransactionBean implements Serializable{
    
    private String transId;
    private String userName;
    private Timestamp transDateTime;
    private double transAmount;

    public TransactionBean() {
        super();
        this.transId = idUtil.generatedTransId();
        SimpleDateFormat sdf = new SimpleDateFormat("YYYY:MM:DD hh:mm:ss");
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        sdf.format(timestamp);
        this.transDateTime = timestamp;
    }

    public TransactionBean(String userName, double transAmount) {
        super();
        this.userName = userName;
        this.transAmount = transAmount;
        this.transId = idUtil.generatedTransId();
        SimpleDateFormat sdf = new SimpleDateFormat("YYYY:MM:DD hh:mm:ss");
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        sdf.format(timestamp);
        this.transDateTime = timestamp;
    }

    public TransactionBean(String transId, String userName, double transAmount) {
        super();
        this.transId = transId;
        this.userName = userName;
        this.transAmount = transAmount;
        SimpleDateFormat sdf = new SimpleDateFormat("YYYY:MM:DD hh:mm:ss");
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        sdf.format(timestamp);
        this.transDateTime = timestamp;
    }

    public TransactionBean(String userName, Timestamp transDateTime, double transAmount) {
        super();
        this.userName = userName;
        this.transDateTime = transDateTime;
        this.transId = idUtil.generatedTransId();
        this.transAmount = transAmount;
    }
    
    
    

    public TransactionBean(String transId, String userName, Timestamp transDateTime, double transAmount) {
        super();
        this.transId = transId;
        this.userName = userName;
        this.transDateTime = transDateTime;
        this.transAmount = transAmount;
    }

    public String getTransId() {
        return transId;
    }

    public void setTransId(String transId) {
        this.transId = transId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Timestamp getTransDateTime() {
        return transDateTime;
    }

    public void setTransDateTime(Timestamp transDateTime) {
        this.transDateTime = transDateTime;
    }

    public double getTransAmount() {
        return transAmount;
    }

    public void setTransAmount(double transAmount) {
        this.transAmount = transAmount;
    }

    @Override
    public String toString() {
        return "TransactionBean{" + "transId=" + transId + ", userName=" + userName + ", transDateTime=" + transDateTime + ", transAmount=" + transAmount + '}';
    }
    
    
}
