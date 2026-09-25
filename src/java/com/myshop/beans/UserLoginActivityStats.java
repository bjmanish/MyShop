package com.myshop.beans;

public class UserLoginActivityStats {

    private int totalLogins;
    private int onlineUsers;
    private int todayUsers;
    private int logoutUsers;

    public UserLoginActivityStats() {
    }

    public int getTotalLogins() {
        return totalLogins;
    }

    public void setTotalLogins(int totalLogins) {
        this.totalLogins = totalLogins;
    }

    public int getOnlineUsers() {
        return onlineUsers;
    }

    public void setOnlineUsers(int onlineUsers) {
        this.onlineUsers = onlineUsers;
    }

    public int getTodayUsers() {
        return todayUsers;
    }

    public void setTodayUsers(int todayUsers) {
        this.todayUsers = todayUsers;
    }

    public int getLogoutUsers() {
        return logoutUsers;
    }

    public void setLogoutUsers(int logoutUsers) {
        this.logoutUsers = logoutUsers;
    }

    @Override
    public String toString() {
        return "UserLoginActivityStats{" +
                "totalLogins=" + totalLogins +
                ", onlineUsers=" + onlineUsers +
                ", todayUsers=" + todayUsers +
                ", logoutUsers=" + logoutUsers +
                '}';
    }
    
    
    
}