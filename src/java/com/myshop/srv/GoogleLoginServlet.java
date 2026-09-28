package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.OrderServiceImpl;
import com.myshop.service.impl.UserLoginActivityServiceImpl;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.utility.MailMessage;
import com.myshop.utility.dbUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

@WebServlet("/GoogleLoginServlet")
public class GoogleLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // GOOGLE TOKEN URL
    // =========================================================

    private static final String GOOGLE_TOKEN_INFO_URL =
            "https://oauth2.googleapis.com/tokeninfo?id_token=";

    // =========================================================
    // TIMEOUTS
    // =========================================================

    private static final int CONNECT_TIMEOUT = 10000;
    private static final int READ_TIMEOUT = 15000;


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");


        // =====================================================
        // GET GOOGLE TOKEN
        // =====================================================

        String token = request.getParameter("token");


        // =====================================================
        // VALIDATE TOKEN
        // =====================================================

        if (token == null || token.trim().isEmpty()) {

            sendError(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    "INVALID_TOKEN"
            );

            return;
        }

        token = token.trim();


        try {

            // =================================================
            // VERIFY GOOGLE ID TOKEN
            // =================================================

            JSONObject googleUser =
                    verifyGoogleToken(token);


            if (googleUser == null) {

                sendError(
                        response,
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "GOOGLE_TOKEN_INVALID"
                );

                return;
            }


            // =================================================
            // GOOGLE USER INFORMATION
            // =================================================

            String email =
                    googleUser
                            .optString("email", "")
                            .trim();

            String name =
                    googleUser
                            .optString("name", "")
                            .trim();

            String emailVerified =
                    googleUser.optString(
                            "email_verified",
                            "false"
                    );


            // =================================================
            // VALIDATE EMAIL
            // =================================================

            if (email.isEmpty()) {

                sendError(
                        response,
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "EMAIL_NOT_FOUND"
                );

                return;
            }


            // =================================================
            // VALIDATE GOOGLE EMAIL
            // =================================================

            if (!"true".equalsIgnoreCase(emailVerified)) {

                sendError(
                        response,
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "EMAIL_NOT_VERIFIED"
                );

                return;
            }


            // =================================================
            // FALLBACK NAME
            // =================================================

            if (name.isEmpty()) {

                int atIndex = email.indexOf("@");

                name = email.substring(
                        0,
                        atIndex > 0
                                ? atIndex
                                : email.length()
                );
            }


            System.out.println(
                    "======================================="
            );

            System.out.println(
                    "Google Login Request"
            );

            System.out.println(
                    "Email : " + email
            );

            System.out.println(
                    "Name  : " + name
            );

            System.out.println(
                    "=======================================");


            // =================================================
            // LOGIN / REGISTER GOOGLE USER
            // =================================================

            UserServiceImpl userDao =
                    new UserServiceImpl();

            UserBean user =
                    userDao.loginOrRegisterGoogleUser(
                            name,
                            email
                    );
            
                    String ipAddress = getClientIpAddress(request);
                    String device = getDeviceInfo(request);
                    
                    MailMessage.welcomeBack(user, ipAddress, device);

            // =================================================
            // VALIDATE APPLICATION USER
            // =================================================

            if (user == null) {

                System.err.println(
                        "Google user could not be created/found: "
                                + email
                );

                sendError(
                        response,
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "USER_LOGIN_FAILED"
                );

                return;
            }


            // =================================================
            // VALIDATE USER ID
            // =================================================

            if (user.getId() == null
                    || user.getId().trim().isEmpty()) {

                System.err.println(
                        "Google user ID is missing: "
                                + email
                );

                sendError(
                        response,
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "USER_ID_MISSING"
                );

                return;
            }


            // =================================================
            // VALIDATE ROLE
            // =================================================

            if (user.getRoleName() == null
                    || user.getRoleName().trim().isEmpty()) {

                System.err.println(
                        "User role is missing: "
                                + email
                );

                sendError(
                        response,
                        HttpServletResponse.SC_FORBIDDEN,
                        "USER_ROLE_MISSING"
                );

                return;
            }


            // =================================================
            // USER INFORMATION
            // =================================================

            String userId =
                    user.getId();

            String role =
                    user.getRoleName();

            String username =
                    user.getEmail();

            String userName =
                    user.getName();


            // =================================================
            // CART
            // =================================================

            CartServiceImpl cartService =
                    new CartServiceImpl();

            String cartId =
                    cartService.getOrCreateCart(userId);

            int cartCount =
                    cartService.getCartCount(userId);


            // =================================================
            // SESSION
            // =================================================

            HttpSession session =
                    request.getSession(true);


            // =================================================
            // SESSION FIXATION PROTECTION
            // =================================================

            try {

                request.getRequestedSessionId();

            } catch (Exception e) {

                System.out.println(
                        "Session ID regeneration unavailable: "
                                + e.getMessage()
                );
            }


            // =================================================
            // STORE USER SESSION DATA
            // =================================================

            session.setAttribute(
                    "user_id",
                    userId
            );

            session.setAttribute(
                    "username",
                    username != null
                            ? username
                            : email
            );

            session.setAttribute(
                    "role",
                    role
            );

            session.setAttribute(
                    "name",
                    userName != null
                            ? userName
                            : name
            );

            session.setAttribute(
                    "sessionId",
                    session.getId()
            );

            session.setAttribute(
                    "cartId",
                    cartId
            );

            session.setAttribute(
                    "cartCount",
                    cartCount
            );


            // =================================================
            // ORDER ID
            // =================================================

            String orderId =
                    new OrderServiceImpl()
                            .getOrderId(userId);

            session.setAttribute(
                    "orderId",
                    orderId
            );


            // =================================================
            // LOGIN TYPE
            // =================================================

            session.setAttribute(
                    "loginType",
                    "GOOGLE"
            );


            // =================================================
            // INSERT SUCCESSFUL LOGIN ACTIVITY
            // =================================================
            UserLoginActivityServiceImpl userlogin = new UserLoginActivityServiceImpl();
            
            String sessionId = (String) session.getAttribute("sessionIs");
            insertLoginActivity(
                    request,
                    userId,
                    sessionId,
                    "GOOGLE",
                    "SUCCESS"
            );
            
//                userlogin.createLoginActivity(userId, orderId, userName);


            // =================================================
            // DEBUG INFORMATION
            // =================================================

            System.out.println(
                    "---------------------------------------"
            );

            System.out.println(
                    "Google Login Successful"
            );

            System.out.println(
                    "User ID    : " + userId
            );

            System.out.println(
                    "Email      : " + email
            );

            System.out.println(
                    "Name       : " + userName
            );

            System.out.println(
                    "Role       : " + role
            );

            System.out.println(
                    "Login Type : GOOGLE"
            );

            System.out.println(
                    "Cart ID    : " + cartId
            );

            System.out.println(
                    "Cart Count : " + cartCount
            );

            System.out.println(
                    "Order ID   : " + orderId
            );

            System.out.println(
                    "---------------------------------------"
            );


            // =================================================
            // RETURN ROLE TO login.js
            // =================================================

            response.setStatus(
                    HttpServletResponse.SC_OK
            );

            response.getWriter().write(
                    role
            );


        } catch (Exception e) {

            System.err.println(
                    "Google Login Error"
            );

            e.printStackTrace();

            sendError(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "ERROR"
            );
        }
    }


    // =========================================================
    // INSERT LOGIN ACTIVITY
    // =========================================================

    private void insertLoginActivity(
            HttpServletRequest request,
            String userId,
            String sessionId,
            String loginType,
            String loginStatus) {

        String sql =
                "INSERT INTO USER_LOGIN_ACTIVITY " +
                "(user_id, login_time, session_id, ip_address, user_agent, login_status) " +
                "VALUES (?, SYSDATETIME(), ?, ?, ?, ?)";


        // -----------------------------------------------------
        // GET CLIENT IP
        // -----------------------------------------------------

        String ipAddress =
                getClientIpAddress(request);


        try (
                Connection con =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    userId
            );

            ps.setString(
                    2,
                    sessionId
            );
            ps.setString(
                    3,
                    ipAddress
            );
            
            ps.setString(
                    4,
                    loginType
            );
            
            ps.setString(
                    5,
                    "ACTIVE"
            );


            int rows =
                    ps.executeUpdate();


            if (rows > 0) {
                
                System.out.println(
                        "Login activity inserted successfully."
                );

                System.out.println(
                        "Activity User ID : " + userId
                );

                System.out.println(
                        "Login Type       : " + loginType
                );

                System.out.println(
                        "Login Status     : " + loginStatus
                );

                System.out.println(
                        "IP Address       : " + ipAddress
                );

            } else {

                System.err.println(
                        "Login activity was not inserted."
                );
            }


        } catch (Exception e) {

            /*
             * IMPORTANT:
             *
             * Do not block successful Google login if the
             * activity table insert fails.
             *
             * The user is already authenticated.
             */

            System.err.println(
                    "Login activity insert failed."
            );

            System.err.println(
                    "User ID: " + userId
            );

            e.printStackTrace();
        }
    }


    // =========================================================
    // GET CLIENT IP ADDRESS
    // =========================================================

    private String getClientIpAddress(
            HttpServletRequest request) {

        String ipAddress =
                request.getHeader("X-Forwarded-For");


        if (ipAddress == null
                || ipAddress.isEmpty()
                || "unknown".equalsIgnoreCase(ipAddress)) {

            ipAddress =
                    request.getHeader(
                            "Proxy-Client-IP"
                    );
        }


        if (ipAddress == null
                || ipAddress.isEmpty()
                || "unknown".equalsIgnoreCase(ipAddress)) {

            ipAddress =
                    request.getHeader(
                            "WL-Proxy-Client-IP"
                    );
        }


        if (ipAddress == null
                || ipAddress.isEmpty()
                || "unknown".equalsIgnoreCase(ipAddress)) {

            ipAddress =
                    request.getHeader(
                            "HTTP_X_FORWARDED_FOR"
                    );
        }


        if (ipAddress == null
                || ipAddress.isEmpty()
                || "unknown".equalsIgnoreCase(ipAddress)) {

            ipAddress =
                    request.getRemoteAddr();
        }


        /*
         * X-Forwarded-For can contain multiple IP addresses.
         *
         * Example:
         *
         * 192.168.1.10, 10.0.0.1
         *
         * Take the first one.
         */

        if (ipAddress != null
                && ipAddress.contains(",")) {

            ipAddress =
                    ipAddress.split(",")[0].trim();
        }


        return ipAddress;
    }

    private String getDeviceInfo(HttpServletRequest request) { 
        String userAgent = request.getHeader("User-Agent"); 
        if (userAgent == null || userAgent.trim().isEmpty()) { 
            return "Unknown Device"; 
        } 
        userAgent = userAgent.toLowerCase(); 
        String device; 
        if (userAgent.contains("mobile") || 
                userAgent.contains("android") || 
                userAgent.contains("iphone") || 
                userAgent.contains("ipad")
            ) { 
            device = "Mobile"; 
        } else { 
            device = "Desktop"; 
        } 
        String browser = "Unknown Browser"; 
        if (userAgent.contains("edg/")){
            browser = "Microsoft Edge"; 
        } else if (userAgent.contains("chrome") && 
                !userAgent.contains("edg/")) { 
            browser = "Google Chrome"; 
        } else if (userAgent.contains("firefox")) { 
            browser = "Mozilla Firefox"; 
        } else if (userAgent.contains("safari") && 
                !userAgent.contains("chrome")) { 
            browser = "Safari"; 
        } else if (userAgent.contains("opera") || 
                userAgent.contains("opr/")) { 
            browser = "Opera"; 
        } 
        return device + " • " + browser; 
    }

    // =========================================================
    // VERIFY GOOGLE TOKEN
    // =========================================================

    private JSONObject verifyGoogleToken(
            String token)
            throws IOException {


        String encodedToken =
                URLEncoder.encode(
                        token,
                        StandardCharsets.UTF_8.name()
                );


        URL url =
                new URL(
                        GOOGLE_TOKEN_INFO_URL
                                + encodedToken
                );


        HttpURLConnection connection =
                (HttpURLConnection)
                        url.openConnection();


        connection.setRequestMethod(
                "GET"
        );

        connection.setConnectTimeout(
                CONNECT_TIMEOUT
        );

        connection.setReadTimeout(
                READ_TIMEOUT
        );

        connection.setRequestProperty(
                "Accept",
                "application/json"
        );


        try {

            // =================================================
            // GOOGLE RESPONSE CODE
            // =================================================

            int responseCode =
                    connection.getResponseCode();


            // =================================================
            // SUCCESSFUL GOOGLE RESPONSE
            // =================================================

            if (responseCode
                    >= HttpURLConnection.HTTP_OK
                    && responseCode
                    < HttpURLConnection.HTTP_MULT_CHOICE) {


                String responseBody =
                        readResponse(
                                connection.getInputStream()
                        );


                if (responseBody == null
                        || responseBody.trim().isEmpty()) {

                    return null;
                }


                return new JSONObject(
                        responseBody
                );
            }


            // =================================================
            // GOOGLE REJECTED TOKEN
            // =================================================

            String errorResponse =
                    "";

            InputStream errorStream =
                    connection.getErrorStream();


            if (errorStream != null) {

                errorResponse =
                        readResponse(
                                errorStream
                        );
            }


            System.err.println(
                    "Google token verification failed."
            );

            System.err.println(
                    "HTTP Code: "
                            + responseCode
            );

            System.err.println(
                    "Response: "
                            + errorResponse
            );


            return null;


        } finally {

            connection.disconnect();
        }
    }


    // =========================================================
    // READ HTTP RESPONSE
    // =========================================================

    private String readResponse(
            InputStream inputStream)
            throws IOException {


        if (inputStream == null) {

            return "";
        }


        StringBuilder response =
                new StringBuilder();


        try (
                BufferedReader reader =
                        new BufferedReader(
                                new InputStreamReader(
                                        inputStream,
                                        StandardCharsets.UTF_8
                                )
                        )
        ) {


            String line;


            while (
                    (line = reader.readLine())
                            != null
            ) {

                response.append(
                        line
                );
            }
        }


        return response.toString();
    }


    // =========================================================
    // SEND ERROR RESPONSE
    // =========================================================

    private void sendError(
            HttpServletResponse response,
            int status,
            String message)
            throws IOException {


        response.reset();


        response.setStatus(
                status
        );


        response.setContentType(
                "text/plain"
        );


        response.setCharacterEncoding(
                "UTF-8"
        );


        response.getWriter().write(
                message
        );
    }
}