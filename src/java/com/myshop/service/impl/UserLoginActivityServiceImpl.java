package com.myshop.service.impl;

import com.myshop.beans.UserLoginActivity;
import com.myshop.beans.UserLoginActivityStats;
import com.myshop.service.UserLoginActivityService;
import com.myshop.utility.dbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserLoginActivityServiceImpl
        implements UserLoginActivityService {

    private static final int QUERY_TIMEOUT_SECONDS = 10;
    private static final int HISTORY_LIMIT = 50;


    /*
     * ============================================================
     * CREATE LOGIN ACTIVITY
     * ============================================================
     */
    @Override
    public long createLoginActivity(
            String userId,
            String sessionId,
            String ipAddress,
            String userAgent) {

        String sql =
                "INSERT INTO USER_LOGIN_ACTIVITY " +
                "(user_id, login_time, session_id, ip_address, user_agent, login_status) " +
                "VALUES (?, SYSDATETIME(), ?, ?, ?, 'ACTIVE')";

        long start = System.currentTimeMillis();

        try (
                Connection con = dbUtil.provideConnection();
                PreparedStatement ps =
                        con.prepareStatement(
                                sql,
                                Statement.RETURN_GENERATED_KEYS)
        ) {

            ps.setQueryTimeout(QUERY_TIMEOUT_SECONDS);

            ps.setString(1, userId);
            ps.setString(2, sessionId);
            ps.setString(3, ipAddress);
            ps.setString(4, userAgent);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                try (ResultSet rs = ps.getGeneratedKeys()) {

                    if (rs.next()) {

                        long id = rs.getLong(1);

                        System.out.println(
                                "Login activity insert: "
                                + (System.currentTimeMillis() - start)
                                + " ms"
                        );

                        return id;
                    }
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "createLoginActivity() failed: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return 0;
    }


    /*
     * ============================================================
     * NORMAL LOGOUT
     * ============================================================
     */
    @Override
    public boolean logoutActivity(
            long loginId,
            String userId) {

        String sql =
                "UPDATE USER_LOGIN_ACTIVITY " +
                "SET logout_time = SYSDATETIME(), " +
                "login_status = 'LOGOUT' " +
                "WHERE login_id = ? " +
                "AND user_id = ? " +
                "AND login_status = 'ACTIVE'";

        try (
                Connection con = dbUtil.provideConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setQueryTimeout(QUERY_TIMEOUT_SECONDS);

            ps.setLong(1, loginId);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.err.println(
                    "logoutActivity() failed: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return false;
    }


    /*
     * ============================================================
     * SESSION EXPIRED
     * ============================================================
     */
    @Override
    public boolean expireActivity(long loginId) {

        String sql =
                "UPDATE USER_LOGIN_ACTIVITY " +
                "SET logout_time = SYSDATETIME(), " +
                "login_status = 'EXPIRED' " +
                "WHERE login_id = ? " +
                "AND login_status = 'ACTIVE'";

        try (
                Connection con = dbUtil.provideConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setQueryTimeout(QUERY_TIMEOUT_SECONDS);

            ps.setLong(1, loginId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.err.println(
                    "expireActivity() failed: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return false;
    }


    /*
     * ============================================================
     * TOTAL USERS
     * ============================================================
     */
    @Override
    public int getTotalUsers() {

        String sql =
                "SELECT COUNT(*) FROM [USER]";

        return getCount(sql);
    }


    /*
     * ============================================================
     * ONLINE USERS
     * ============================================================
     */
    @Override
    public int getOnlineUsers() {

        String sql =
                "SELECT COUNT(*) " +
                "FROM USER_LOGIN_ACTIVITY " +
                "WHERE login_status = 'ACTIVE'";

        return getCount(sql);
    }


    /*
     * ============================================================
     * TODAY USERS
     * ============================================================
     */
    @Override
    public int getTodayUsers() {

        String sql =
                "SELECT COUNT(DISTINCT user_id) " +
                "FROM USER_LOGIN_ACTIVITY " +
                "WHERE login_time >= CAST(GETDATE() AS DATE) " +
                "AND login_time < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))";

        return getCount(sql);
    }


    /*
     * ============================================================
     * TOTAL LOGIN RECORDS
     * ============================================================
     */
    @Override
    public int getTotalLogins() {

        String sql =
                "SELECT COUNT(*) " +
                "FROM USER_LOGIN_ACTIVITY";

        return getCount(sql);
    }


    /*
     * ============================================================
     * CUSTOMER COUNT
     * ============================================================
     */
    @Override
    public int getCustomerCount() {

        String sql =
                "SELECT COUNT(*) " +
                "FROM [USER] u " +
                "INNER JOIN ROLES r " +
                "ON u.role_id = r.role_id " +
                "WHERE r.role_name = 'CUSTOMER'";

        return getCount(sql);
    }


    /*
     * ============================================================
     * STAFF COUNT
     * ============================================================
     */
    @Override
    public int getStaffCount() {

        String sql =
                "SELECT COUNT(*) " +
                "FROM [USER] u " +
                "INNER JOIN ROLES r " +
                "ON u.role_id = r.role_id " +
                "WHERE r.role_name IN ('STAFF', 'DELIVERY')";

        return getCount(sql);
    }


    /*
     * ============================================================
     * ADMIN COUNT
     * ============================================================
     */
    @Override
    public int getAdminCount() {

        String sql =
                "SELECT COUNT(*) " +
                "FROM [USER] u " +
                "INNER JOIN ROLES r " +
                "ON u.role_id = r.role_id " +
                "WHERE r.role_name = 'ADMIN'";

        return getCount(sql);
    }


    /*
     * ============================================================
     * ACTIVITY STATISTICS
     *
     * IMPORTANT:
     *
     * 1. ONE HIKARI CONNECTION
     * 2. FOUR QUERIES USING SAME CONNECTION
     * 3. NO NEW CONNECTION FOR EACH QUERY
     * 4. QUERY TIMEOUT IS SET BEFORE executeQuery()
     * ============================================================
     */
    /*
 * ============================================================
 * ACTIVITY STATISTICS CACHE
 *
 * Statistics are cached for 5 seconds.
 *
 * This prevents every page refresh from executing the
 * statistics queries again.
 * ============================================================
 */
private static volatile UserLoginActivityStats cachedStats = null;

private static volatile long statsCacheTime = 0;

private static final long STATS_CACHE_DURATION =
        5000L;


/*
 * Prevent multiple requests from querying SQL Server
 * simultaneously when the cache expires.
 */
private static final Object STATS_LOCK =
        new Object();


/*
 * ============================================================
 * GET ACTIVITY STATISTICS
 * ============================================================
 */
@Override
public UserLoginActivityStats getActivityStats() {

    long now =
            System.currentTimeMillis();


    /*
     * ========================================================
     * RETURN CACHE
     * ========================================================
     */
    if (cachedStats != null &&
            (now - statsCacheTime)
            < STATS_CACHE_DURATION) {

        System.out.println(
                "Activity statistics: USING CACHE"
        );

        return copyStats(cachedStats);
    }


    /*
     * ========================================================
     * ONLY ONE THREAD REFRESHES CACHE
     * ========================================================
     */
    synchronized (STATS_LOCK) {

        /*
         * Another request may have refreshed the cache
         * while this thread was waiting.
         */
        now =
                System.currentTimeMillis();


        if (cachedStats != null &&
                (now - statsCacheTime)
                < STATS_CACHE_DURATION) {

            System.out.println(
                    "Activity statistics: USING CACHE"
            );

            return copyStats(cachedStats);
        }


        System.out.println(
                "Activity statistics: REFRESHING DATABASE"
        );


        UserLoginActivityStats stats =
                new UserLoginActivityStats();


        long totalStart =
                System.currentTimeMillis();


        /*
         * ====================================================
         * TOTAL LOGIN RECORDS
         *
         * Uses SQL Server metadata instead of scanning
         * USER_LOGIN_ACTIVITY.
         * ====================================================
         */
        String totalSql =
                "SELECT SUM(row_count) AS total_count " +
                "FROM sys.dm_db_partition_stats " +
                "WHERE object_id = OBJECT_ID('USER_LOGIN_ACTIVITY') " +
                "AND index_id IN (0, 1)";


        /*
         * ====================================================
         * ONLINE USERS
         * ====================================================
         */
        String onlineSql =
                "SELECT COUNT(*) " +
                "FROM USER_LOGIN_ACTIVITY " +
                "WHERE login_status = 'ACTIVE'";


        /*
         * ====================================================
         * TODAY USERS
         * ====================================================
         */
        String todaySql =
                "SELECT COUNT(DISTINCT user_id) " +
                "FROM USER_LOGIN_ACTIVITY " +
                "WHERE login_time >= CAST(GETDATE() AS DATE) " +
                "AND login_time < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))";


        /*
         * ====================================================
         * LOGOUT USERS
         * ====================================================
         */
        String logoutSql =
                "SELECT COUNT(*) " +
                "FROM USER_LOGIN_ACTIVITY " +
                "WHERE login_status IN ('LOGOUT', 'FORCE_LOGOUT')";


        /*
         * ====================================================
         * ONE HIKARI CONNECTION
         * ====================================================
         */
        try (
                Connection con =
                        dbUtil.provideConnection()
        ) {

            System.out.println(
                    "Hikari connection acquired for activity statistics"
            );


            /*
             * ====================================================
             * TOTAL LOGINS
             * ====================================================
             */
            long start =
                    System.currentTimeMillis();

            try (
                    PreparedStatement ps =
                            con.prepareStatement(totalSql)
            ) {

                ps.setQueryTimeout(10);

                try (
                        ResultSet rs =
                                ps.executeQuery()
                ) {

                    if (rs.next()) {

                        long total =
                                rs.getLong("total_count");


                        if (total >
                                Integer.MAX_VALUE) {

                            stats.setTotalLogins(
                                    Integer.MAX_VALUE
                            );

                        } else {

                            stats.setTotalLogins(
                                    (int) total
                            );
                        }
                    }
                }
            }


            System.out.println(
                    "Total login SQL only: "
                    + (System.currentTimeMillis()
                    - start)
                    + " ms"
            );


            /*
             * ====================================================
             * ONLINE USERS
             * ====================================================
             */
            start =
                    System.currentTimeMillis();

            try (
                    PreparedStatement ps =
                            con.prepareStatement(
                                    onlineSql)
            ) {

                ps.setQueryTimeout(10);

                try (
                        ResultSet rs =
                                ps.executeQuery()
                ) {

                    if (rs.next()) {

                        stats.setOnlineUsers(
                                rs.getInt(1)
                        );
                    }
                }
            }


            System.out.println(
                    "Online users SQL only: "
                    + (System.currentTimeMillis()
                    - start)
                    + " ms"
            );


            /*
             * ====================================================
             * TODAY USERS
             * ====================================================
             */
            start =
                    System.currentTimeMillis();

            try (
                    PreparedStatement ps =
                            con.prepareStatement(
                                    todaySql)
            ) {

                ps.setQueryTimeout(10);

                try (
                        ResultSet rs =
                                ps.executeQuery()
                ) {

                    if (rs.next()) {

                        stats.setTodayUsers(
                                rs.getInt(1)
                        );
                    }
                }
            }


            System.out.println(
                    "Today users SQL only: "
                    + (System.currentTimeMillis()
                    - start)
                    + " ms"
            );


            /*
             * ====================================================
             * LOGOUT USERS
             * ====================================================
             */
            start =
                    System.currentTimeMillis();

            try (
                    PreparedStatement ps =
                            con.prepareStatement(
                                    logoutSql)
            ) {

                ps.setQueryTimeout(10);

                try (
                        ResultSet rs =
                                ps.executeQuery()
                ) {

                    if (rs.next()) {

                        stats.setLogoutUsers(
                                rs.getInt(1)
                        );
                    }
                }
            }


            System.out.println(
                    "Logout users SQL only: "
                    + (System.currentTimeMillis()
                    - start)
                    + " ms"
            );


        } catch (Exception e) {

            System.err.println(
                    "getActivityStats() failed: "
                    + e.getMessage()
            );

            e.printStackTrace();


            /*
             * If database temporarily fails but an old cache
             * exists, return the old cache.
             */
            if (cachedStats != null) {

                System.out.println(
                        "Using previous activity statistics cache."
                );

                return copyStats(cachedStats);
            }
        }


        /*
         * ========================================================
         * UPDATE CACHE
         * ========================================================
         */
        cachedStats =
                copyStats(stats);

        statsCacheTime =
                System.currentTimeMillis();


        System.out.println(
                "======================================"
        );

        System.out.println(
                "Activity statistics total: "
                + (System.currentTimeMillis()
                - totalStart)
                + " ms"
        );

        System.out.println(
                "Activity statistics cache updated"
        );

        System.out.println(
                "======================================"
        );


        return copyStats(stats);
}

}
    /*
     * ============================================================
     * ACTIVE USERS
     * ============================================================
     */
    @Override
    public List<UserLoginActivity> getActiveUsers() {

        List<UserLoginActivity> list =
                new ArrayList<>();

        String sql =
                "SELECT TOP (50) " +

                "l.login_id, " +
                "l.user_id, " +
                "u.user_id AS username, " +
                "r.role_name, " +
                "l.login_time, " +
                "l.logout_time, " +
                "l.session_id, " +
                "l.ip_address, " +
                "l.user_agent, " +
                "l.login_status " +

                "FROM USER_LOGIN_ACTIVITY l " +

                "INNER JOIN [USER] u " +
                "ON l.user_id = u.user_id " +

                "LEFT JOIN ROLES r " +
                "ON u.role_id = r.role_id " +

                "WHERE l.login_status = 'ACTIVE' " +

                "ORDER BY l.login_time DESC";


        long start =
                System.currentTimeMillis();

        loadUsers(sql, list);

        System.out.println(
                "Active users query: "
                + (System.currentTimeMillis() - start)
                + " ms"
        );

        return list;
    }


    /*
     * ============================================================
     * LOGIN HISTORY
     *
     * ONLY 50 RECORDS
     * ============================================================
     */
    @Override
    public List<UserLoginActivity> getLoginHistory() {

        List<UserLoginActivity> list =
                new ArrayList<>();

        String sql =
                "SELECT TOP (50) " +

                "l.login_id, " +
                "l.user_id, " +
                "u.user_id AS username, " +
                "r.role_name, " +
                "l.login_time, " +
                "l.logout_time, " +
                "l.session_id, " +
                "l.ip_address, " +
                "l.user_agent, " +
                "l.login_status " +

                "FROM USER_LOGIN_ACTIVITY l " +

                "INNER JOIN [USER] u " +
                "ON l.user_id = u.user_id " +

                "LEFT JOIN ROLES r " +
                "ON u.role_id = r.role_id " +

                "ORDER BY l.login_time DESC";


        long start =
                System.currentTimeMillis();

        loadUsers(sql, list);

        System.out.println(
                "Login history query: "
                + (System.currentTimeMillis() - start)
                + " ms"
        );

        return list;
    }


    /*
     * ============================================================
     * TODAY LOGIN HISTORY
     * ============================================================
     */
    @Override
    public List<UserLoginActivity> getTodayLoginHistory() {

        List<UserLoginActivity> list =
                new ArrayList<>();

        String sql =
                "SELECT TOP (50) " +

                "l.login_id, " +
                "l.user_id, " +
                "u.user_id AS username, " +
                "r.role_name, " +
                "l.login_time, " +
                "l.logout_time, " +
                "l.session_id, " +
                "l.ip_address, " +
                "l.user_agent, " +
                "l.login_status " +

                "FROM USER_LOGIN_ACTIVITY l " +

                "INNER JOIN [USER] u " +
                "ON l.user_id = u.user_id " +

                "LEFT JOIN ROLES r " +
                "ON u.role_id = r.role_id " +

                "WHERE l.login_time >= CAST(GETDATE() AS DATE) " +
                "AND l.login_time < DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) " +

                "ORDER BY l.login_time DESC";


        long start =
                System.currentTimeMillis();

        loadUsers(sql, list);

        System.out.println(
                "Today login history query: "
                + (System.currentTimeMillis() - start)
                + " ms"
        );

        return list;
    }


    /*
     * ============================================================
     * GENERIC COUNT
     * ============================================================
     */
    private int getCount(String sql) {

        long start =
                System.currentTimeMillis();

        try (
                Connection con =
                        dbUtil.provideConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setQueryTimeout(
                    QUERY_TIMEOUT_SECONDS
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Count query failed: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        System.out.println(
                "Count query time: "
                + (System.currentTimeMillis() - start)
                + " ms"
        );

        return 0;
    }


    /*
     * ============================================================
     * LOAD USER LOGIN ACTIVITY
     * ============================================================
     */
    private void loadUsers(
            String sql,
            List<UserLoginActivity> list) {

        long start =
                System.currentTimeMillis();

        try (
                Connection con =
                        dbUtil.provideConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setQueryTimeout(
                    QUERY_TIMEOUT_SECONDS
            );

            ps.setFetchSize(
                    HISTORY_LIMIT
            );


            long queryStart =
                    System.currentTimeMillis();


            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                long queryEnd =
                        System.currentTimeMillis();


                while (rs.next()) {

                    UserLoginActivity activity =
                            new UserLoginActivity();


                    activity.setLoginId(
                            rs.getLong("login_id")
                    );


                    activity.setUserId(
                            rs.getString("user_id")
                    );


                    activity.setUsername(
                            rs.getString("username")
                    );


                    activity.setRoleName(
                            rs.getString("role_name")
                    );


                    Timestamp loginTimestamp =
                            rs.getTimestamp(
                                    "login_time"
                            );


                    if (loginTimestamp != null) {

                        activity.setLoginTime(
                                loginTimestamp
                                        .toLocalDateTime()
                        );
                    }


                    Timestamp logoutTimestamp =
                            rs.getTimestamp(
                                    "logout_time"
                            );


                    if (logoutTimestamp != null) {

                        activity.setLogoutTime(
                                logoutTimestamp
                                        .toLocalDateTime()
                        );
                    }


                    activity.setSessionId(
                            rs.getString(
                                    "session_id"
                            )
                    );


                    activity.setIpAddress(
                            rs.getString(
                                    "ip_address"
                            )
                    );


                    activity.setUserAgent(
                            rs.getString(
                                    "user_agent"
                            )
                    );


                    activity.setLoginStatus(
                            rs.getString(
                                    "login_status"
                            )
                    );


                    list.add(activity);
                }


                System.out.println(
                        "History SQL execute: "
                        + (queryEnd - queryStart)
                        + " ms"
                );
            }


        } catch (Exception e) {

            System.err.println(
                    "loadUsers() failed: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }


        System.out.println(
                "History total processing: "
                + (System.currentTimeMillis() - start)
                + " ms"
        );
    }
    
    private UserLoginActivityStats copyStats(
        UserLoginActivityStats source) {

    if (source == null) {
        return null;
    }


    UserLoginActivityStats copy =
            new UserLoginActivityStats();


    copy.setTotalLogins(
            source.getTotalLogins()
    );


    copy.setOnlineUsers(
            source.getOnlineUsers()
    );


    copy.setTodayUsers(
            source.getTodayUsers()
    );


    copy.setLogoutUsers(
            source.getLogoutUsers()
    );


    return copy;
}
    
    @Override
public UserLoginActivity getLoginActivityById(
        long loginId) {

    String sql =
            "SELECT TOP 1 " +
            "l.login_id, " +
            "l.user_id, " +
            "u.user_id AS username, " +
            "r.role_name, " +
            "l.login_time, " +
            "l.logout_time, " +
            "l.session_id, " +
            "l.ip_address, " +
            "l.user_agent, " +
            "l.login_status " +
            "FROM USER_LOGIN_ACTIVITY l " +
            "INNER JOIN [USER] u " +
            "ON l.user_id = u.user_id " +
            "LEFT JOIN ROLES r " +
            "ON u.role_id = r.role_id " +
            "WHERE l.login_id = ?";


    try (
            Connection con =
                    dbUtil.provideConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql)
    ) {

        ps.setQueryTimeout(10);

        ps.setLong(1, loginId);


        try (ResultSet rs =
                     ps.executeQuery()) {

            if (rs.next()) {

                UserLoginActivity activity =
                        new UserLoginActivity();


                activity.setLoginId(
                        rs.getLong("login_id")
                );

                activity.setUserId(
                        rs.getString("user_id")
                );

                activity.setUsername(
                        rs.getString("username")
                );

                activity.setRoleName(
                        rs.getString("role_name")
                );


                Timestamp loginTimestamp =
                        rs.getTimestamp("login_time");

                if (loginTimestamp != null) {

                    activity.setLoginTime(
                            loginTimestamp.toLocalDateTime()
                    );
                }


                Timestamp logoutTimestamp =
                        rs.getTimestamp("logout_time");

                if (logoutTimestamp != null) {

                    activity.setLogoutTime(
                            logoutTimestamp.toLocalDateTime()
                    );
                }


                activity.setSessionId(
                        rs.getString("session_id")
                );

                activity.setIpAddress(
                        rs.getString("ip_address")
                );

                activity.setUserAgent(
                        rs.getString("user_agent")
                );

                activity.setLoginStatus(
                        rs.getString("login_status")
                );


                return activity;
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }


    return null;
}

@Override
public boolean forceLogout(
        long loginId,
        String adminUserId) {

    String sql =
            "UPDATE USER_LOGIN_ACTIVITY " +
            "SET logout_time = SYSDATETIME(), " +
            "login_status = 'FORCE_LOGOUT' " +
            "WHERE login_id = ? " +
            "AND login_status = 'ACTIVE'";


    try (
            Connection con =
                    dbUtil.provideConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql)
    ) {

        ps.setQueryTimeout(10);

        ps.setLong(1, loginId);


        return ps.executeUpdate() > 0;

    } catch (Exception e) {

        e.printStackTrace();
    }


    return false;
}

}