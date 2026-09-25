package com.myshop.service;

import com.myshop.beans.UserLoginActivity;
import com.myshop.beans.UserLoginActivityStats;

import java.util.List;

public interface UserLoginActivityService {

    long createLoginActivity(
            String userId,
            String sessionId,
            String ipAddress,
            String userAgent
    );

    boolean logoutActivity(
            long loginId,
            String userId
    );

    boolean expireActivity(
            long loginId
    );

    int getTotalUsers();

    int getOnlineUsers();

    int getTodayUsers();

    int getTotalLogins();

    int getCustomerCount();

    int getStaffCount();

    int getAdminCount();

    UserLoginActivityStats getActivityStats();

    List<UserLoginActivity> getActiveUsers();

    List<UserLoginActivity> getLoginHistory();

    List<UserLoginActivity> getTodayLoginHistory();
    
    boolean forceLogout(long loginId, String adminUserId);
    
    UserLoginActivity getLoginActivityById(long loginId);
}