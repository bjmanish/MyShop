package com.myshop.beans;

import java.io.Serializable;
import java.time.LocalDateTime;

public class UserLoginActivity implements Serializable {

    private static final long serialVersionUID = 1L;

    private long loginId;
    private String userId;
    private String username;
    private String roleName;
    private LocalDateTime loginTime;
    private LocalDateTime logoutTime;
    private String sessionId;
    private String ipAddress;
    private String userAgent;
    private String loginStatus;

    public UserLoginActivity() {
    }

    public long getLoginId() {
        return loginId;
    }

    public void setLoginId(long loginId) {
        this.loginId = loginId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public LocalDateTime getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(LocalDateTime loginTime) {
        this.loginTime = loginTime;
    }

    public LocalDateTime getLogoutTime() {
        return logoutTime;
    }

    public void setLogoutTime(LocalDateTime logoutTime) {
        this.logoutTime = logoutTime;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getLoginStatus() {
        return loginStatus;
    }

    public void setLoginStatus(String loginStatus) {
        this.loginStatus = loginStatus;
    }

    @Override
    public String toString() {
        return "UserLoginActivity{" + "loginId=" + loginId + ", userId=" + userId + ", username=" + username + ", roleName=" + roleName + ", loginTime=" + loginTime + ", logoutTime=" + logoutTime + ", sessionId=" + sessionId + ", ipAddress=" + ipAddress + ", userAgent=" + userAgent + ", loginStatus=" + loginStatus + '}';
    }
    
    
    
}