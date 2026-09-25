package com.myshop.utility;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class dbUtil {

    private static final ResourceBundle rb =
            ResourceBundle.getBundle("application");


    private static final String URL =
            rb.getString("db.connectionString");

    private static final String USER =
            rb.getString("db.username");

    private static final String PASS =
            rb.getString("db.password");

    private static final String DRIVER =
            rb.getString("db.driverName");


    private static final HikariDataSource DATA_SOURCE;


    /*
     * ============================================================
     * HIKARI CP INITIALIZATION
     * ============================================================
     */
    static {

        try {

            Class.forName(DRIVER);


            HikariConfig config =
                    new HikariConfig();


            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASS);


            config.setMaximumPoolSize(10);

            config.setMinimumIdle(2);


            config.setConnectionTimeout(10000);

            config.setValidationTimeout(5000);

            config.setIdleTimeout(600000);

            config.setMaxLifetime(1800000);


            config.setPoolName(
                    "MyShop-SQLServer-Pool"
            );


            /*
             * SQL Server prepared statement cache
             */
            config.addDataSourceProperty(
                    "cachePrepStmts",
                    "true"
            );

            config.addDataSourceProperty(
                    "prepStmtCacheSize",
                    "250"
            );

            config.addDataSourceProperty(
                    "prepStmtCacheSqlLimit",
                    "2048"
            );


            /*
             * Fail fast if SQL Server cannot be reached.
             */
            config.setInitializationFailTimeout(
                    10000
            );


            DATA_SOURCE =
                    new HikariDataSource(config);


            System.out.println(
                    "======================================"
            );

            System.out.println(
                    "MyShop HikariCP Configured"
            );

            System.out.println(
                    "Pool Name    : "
                    + DATA_SOURCE.getPoolName()
            );

            System.out.println(
                    "Maximum Pool : "
                    + DATA_SOURCE.getMaximumPoolSize()
            );

            System.out.println(
                    "Minimum Idle : "
                    + DATA_SOURCE.getMinimumIdle()
            );

            System.out.println(
                    "======================================");


        } catch (Exception e) {

            System.err.println(
                    "HikariCP initialization failed"
            );

            e.printStackTrace();

            throw new ExceptionInInitializerError(e);
        }
    }


    /*
     * ============================================================
     * GET CONNECTION
     * ============================================================
     */
    public static Connection provideConnection()
            throws SQLException {

        long start =
                System.currentTimeMillis();


        Connection connection =
                DATA_SOURCE.getConnection();


        long time =
                System.currentTimeMillis() - start;


        /*
         * Only print slow connection acquisition.
         */
        if (time > 100) {

            System.out.println(
                    "WARNING: Hikari connection acquisition = "
                    + time
                    + " ms"
            );
        }


        return connection;
    }


    /*
     * ============================================================
     * INITIALIZE POOL
     *
     * Called when Tomcat starts.
     * This prevents the first JSP request from starting the pool.
     * ============================================================
     */
    public static void initializePool() {

        long start =
                System.currentTimeMillis();


        try (
                Connection con =
                        DATA_SOURCE.getConnection()
        ) {

            System.out.println(
                    "======================================"
            );

            System.out.println(
                    "MyShop HikariCP Started"
            );

            System.out.println(
                    "Pool Name    : "
                    + DATA_SOURCE.getPoolName()
            );

            System.out.println(
                    "Maximum Pool : "
                    + DATA_SOURCE.getMaximumPoolSize()
            );

            System.out.println(
                    "Minimum Idle : "
                    + DATA_SOURCE.getMinimumIdle()
            );

            System.out.println(
                    "Startup Time : "
                    + (System.currentTimeMillis() - start)
                    + " ms"
            );

            System.out.println(
                    "======================================"
            );

        } catch (SQLException e) {

            System.err.println(
                    "Unable to initialize HikariCP pool"
            );

            e.printStackTrace();
        }
    }


    /*
     * ============================================================
     * CLOSE CONNECTION
     *
     * Hikari does NOT physically destroy the connection here.
     * It returns the connection to the pool.
     * ============================================================
     */
    public static void closeConnection(
            Connection conn) {

        try {

            if (conn != null &&
                    !conn.isClosed()) {

                conn.close();
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    /*
     * ============================================================
     * CLOSE RESULT SET
     * ============================================================
     */
    public static void closeConnection(
            ResultSet rs) {

        try {

            if (rs != null &&
                    !rs.isClosed()) {

                rs.close();
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    /*
     * ============================================================
     * CLOSE PREPARED STATEMENT
     * ============================================================
     */
    public static void closeConnection(
            PreparedStatement ps) {

        try {

            if (ps != null &&
                    !ps.isClosed()) {

                ps.close();
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    /*
     * ============================================================
     * SHUTDOWN HIKARI
     * ============================================================
     */
    public static void shutdownPool() {

        if (DATA_SOURCE != null &&
                !DATA_SOURCE.isClosed()) {

            DATA_SOURCE.close();

            System.out.println(
                    "MyShop HikariCP Pool Closed"
            );
        }
    }
}