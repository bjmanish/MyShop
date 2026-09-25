package com.myshop.utility;

import javax.servlet.http.HttpSession;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public class MyShopSessionRegistry {

    private static final ConcurrentMap<String, HttpSession>
            SESSIONS =
            new ConcurrentHashMap<>();


    private MyShopSessionRegistry() {
    }


    public static void registerSession(
            HttpSession session) {

        if (session == null) {
            return;
        }

        SESSIONS.put(
                session.getId(),
                session
        );
    }


    public static HttpSession getSession(
            String sessionId) {

        if (sessionId == null ||
                sessionId.trim().isEmpty()) {

            return null;
        }

        return SESSIONS.get(sessionId);
    }


    public static void removeSession(
            String sessionId) {

        if (sessionId == null) {
            return;
        }

        SESSIONS.remove(sessionId);
    }


    public static int getActiveSessionCount() {

        return SESSIONS.size();
    }
}