package com.myshop.listener;

import com.myshop.service.impl.UserLoginActivityServiceImpl;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class MyShopSessionListener
        implements HttpSessionListener {

    @Override
    public void sessionCreated(
            HttpSessionEvent event) {

        // Nothing required here.
    }

    @Override
    public void sessionDestroyed(
            HttpSessionEvent event) {

        try {

            Object activityObject =
                    event.getSession()
                            .getAttribute(
                                    "loginActivityId"
                            );

            if (activityObject != null) {

                long loginActivityId =
                        Long.parseLong(
                                activityObject.toString()
                        );

                UserLoginActivityServiceImpl service =
                        new UserLoginActivityServiceImpl();

                service.expireActivity(
                        loginActivityId
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}