package com.myshop.listener;

import com.myshop.utility.dbUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MyShopStartupListener
        implements ServletContextListener {


    @Override
    public void contextInitialized(
            ServletContextEvent event) {

        System.out.println(
                "======================================"
        );

        System.out.println(
                "MyShop Application Starting..."
        );

        System.out.println(
                "Initializing HikariCP..."
        );


        long start =
                System.currentTimeMillis();


        try {

            dbUtil.initializePool();


            System.out.println(
                    "HikariCP initialized successfully"
            );


            System.out.println(
                    "Startup DB time: "
                    + (System.currentTimeMillis() - start)
                    + " ms"
            );


        } catch (Exception e) {

            System.err.println(
                    "HikariCP startup failed"
            );

            e.printStackTrace();
        }


        System.out.println(
                "======================================"
        );
    }


    @Override
    public void contextDestroyed(
            ServletContextEvent event) {

        System.out.println(
                "======================================"
        );

        System.out.println(
                "MyShop Application Stopping..."
        );


        dbUtil.shutdownPool();


        System.out.println(
                "MyShop Application Stopped"
        );

        System.out.println(
                "======================================"
        );
    }
}