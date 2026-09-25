package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.service.impl.UserLoginActivityServiceImpl;
import com.myshop.utility.MyShopSessionRegistry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /* ==========================================
           RESPONSE
           ========================================== */

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");


        /* ==========================================
           GET LOGIN DETAILS
           ========================================== */

        String email =
                request.getParameter("username");

        String password =
                request.getParameter("password");


        if (email == null
                || email.trim().isEmpty()
                || password == null
                || password.trim().isEmpty()) {

            response.getWriter().write("Invalid");
            return;
        }


        /* ==========================================
           LOGIN USER
           ========================================== */

        UserServiceImpl service =
                new UserServiceImpl();

        UserBean user =
                service.loginUser(
                        email.trim(),
                        password
                );


        /* ==========================================
           SUCCESSFUL LOGIN
           ========================================== */

        if (user != null
                && user.getRoleName() != null) {

            /*
             * Create/get session only after
             * successful authentication.
             */

            HttpSession session =
                    request.getSession();
            
            MyShopSessionRegistry.registerSession(session);

            /*
             * Session expires after 30 minutes
             * of inactivity.
             */

            session.setMaxInactiveInterval(
                    30 * 60
            );


            /* ==========================================
               SESSION ATTRIBUTES
               ========================================== */

            session.setAttribute(
                    "user_id",
                    user.getId()
            );

            session.setAttribute(
                    "username",
                    user.getEmail()
            );

            session.setAttribute(
                    "role",
                    user.getRoleName()
            );

            session.setAttribute(
                    "name",
                    user.getName()
            );

            session.setAttribute(
                    "sessionId",
                    session.getId()
            );


            /* ==========================================
               CART
               ========================================== */

            try {

                String cartId =
                        new CartServiceImpl()
                                .getOrCreateCart(
                                        user.getId()
                                );

                session.setAttribute(
                        "cartId",
                        cartId
                );

            } catch (Exception e) {

                /*
                 * Cart failure should not prevent
                 * a valid user from logging in.
                 */

                e.printStackTrace();
            }


            /* ==========================================
               USER LOGIN ACTIVITY
               ========================================== */

            try {

                /*
                 * Get user IP address.
                 *
                 * X-Forwarded-For is useful when
                 * application runs behind proxy/server.
                 */

                String ipAddress =
                        request.getHeader(
                                "X-Forwarded-For"
                        );


                if (ipAddress == null
                        || ipAddress.trim().isEmpty()
                        || "unknown".equalsIgnoreCase(
                                ipAddress)) {

                    ipAddress =
                            request.getRemoteAddr();
                }


                /*
                 * X-Forwarded-For can contain:
                 *
                 * 192.168.1.10, proxy1, proxy2
                 *
                 * Take first IP.
                 */

                if (ipAddress != null
                        && ipAddress.contains(",")) {

                    ipAddress =
                            ipAddress
                                    .split(",")[0]
                                    .trim();
                }


                /* ======================================
                   GET BROWSER / DEVICE
                   ====================================== */

                String userAgent =
                        request.getHeader(
                                "User-Agent"
                        );


                /* ======================================
                   INSERT LOGIN ACTIVITY
                   ====================================== */

                UserLoginActivityServiceImpl
                        activityService =
                        new UserLoginActivityServiceImpl();


                long loginActivityId =
                        activityService
                                .createLoginActivity(

                                        user.getId(),

                                        session.getId(),

                                        ipAddress,

                                        userAgent
                                );


                /* ======================================
                   SAVE LOGIN ID IN SESSION
                   ====================================== */

                if (loginActivityId > 0) {

                    session.setAttribute(
                            "loginActivityId",
                            loginActivityId
                    );


                    System.out.println(
                            "===================================="
                    );

                    System.out.println(
                            "LOGIN ACTIVITY INSERTED"
                    );

                    System.out.println(
                            "Login ID : "
                            + loginActivityId
                    );

                    System.out.println(
                            "User ID  : "
                            + user.getId()
                    );

                    System.out.println(
                            "Email    : "
                            + user.getEmail()
                    );

                    System.out.println(
                            "Role     : "
                            + user.getRoleName()
                    );

                    System.out.println(
                            "Session  : "
                            + session.getId()
                    );

                    System.out.println(
                            "IP       : "
                            + ipAddress
                    );

                    System.out.println(
                            "===================================="
                    );

                } else {

                    System.out.println(
                            "Login successful but "
                            + "USER_LOGIN_ACTIVITY "
                            + "was not inserted."
                    );
                }


            } catch (Exception e) {

                /*
                 * IMPORTANT:
                 *
                 * Activity logging failure should
                 * not block normal login.
                 */

                System.out.println(
                        "Error while inserting "
                        + "login activity."
                );

                e.printStackTrace();
            }


            /* ==========================================
               RETURN ROLE TO AJAX
               ========================================== */

            response.getWriter()
                    .write(
                            user.getRoleName()
                    );


            System.out.println(
                    "Login Role : "
                    + user.getRoleName()
            );


        } else {

            /* ==========================================
               INVALID LOGIN
               ========================================== */

            response.getWriter()
                    .write("Invalid");
        }
    }


    /* ==============================================
       GET
       ============================================== */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }
}