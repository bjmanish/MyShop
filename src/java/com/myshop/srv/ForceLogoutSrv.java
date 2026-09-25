package com.myshop.srv;

import com.myshop.beans.UserLoginActivity;
import com.myshop.service.impl.UserLoginActivityServiceImpl;
import com.myshop.utility.MyShopSessionRegistry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ForceLogoutSrv", urlPatterns = {"/ForceLogoutSrv"})
public class ForceLogoutSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserLoginActivityServiceImpl service =
            new UserLoginActivityServiceImpl();


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");


        /*
         * ============================================================
         * GET CURRENT ADMIN SESSION
         * ============================================================
         */
        HttpSession adminSession =
                request.getSession(false);


        if (adminSession == null) {

            writeJson(
                    response,
                    false,
                    "Your session has expired. Please login again."
            );

            return;
        }


        /*
         * ============================================================
         * CHECK ADMIN ROLE
         * ============================================================
         */
        String role =
                (String) adminSession.getAttribute("role");

        String adminUserId =
                (String) adminSession.getAttribute("user_id");


        if (role == null ||
                !role.equalsIgnoreCase("ADMIN")) {

            writeJson(
                    response,
                    false,
                    "Unauthorized access."
            );

            return;
        }


        if (adminUserId == null ||
                adminUserId.trim().isEmpty()) {

            writeJson(
                    response,
                    false,
                    "Admin user information is missing."
            );

            return;
        }


        /*
         * ============================================================
         * GET LOGIN ID
         * ============================================================
         */
        String loginIdParameter =
                request.getParameter("loginId");


        if (loginIdParameter == null ||
                loginIdParameter.trim().isEmpty()) {

            writeJson(
                    response,
                    false,
                    "Login ID is required."
            );

            return;
        }


        long loginId;


        try {

            loginId =
                    Long.parseLong(
                            loginIdParameter.trim()
                    );

        } catch (NumberFormatException e) {

            writeJson(
                    response,
                    false,
                    "Invalid login ID."
            );

            return;
        }


        if (loginId <= 0) {

            writeJson(
                    response,
                    false,
                    "Invalid login ID."
            );

            return;
        }


        /*
         * ============================================================
         * GET TARGET LOGIN ACTIVITY
         *
         * This method should be added to
         * UserLoginActivityServiceImpl.
         * ============================================================
         */
        UserLoginActivity activity =
                service.getLoginActivityById(loginId);


        if (activity == null) {

            writeJson(
                    response,
                    false,
                    "Login activity not found."
            );

            return;
        }


        /*
         * ============================================================
         * PREVENT LOGGING OUT ALREADY LOGGED-OUT USER
         * ============================================================
         */
        String currentStatus =
                activity.getLoginStatus();


        if (currentStatus == null ||
                !currentStatus.equalsIgnoreCase("ACTIVE")) {

            writeJson(
                    response,
                    false,
                    "This user is already logged out."
            );

            return;
        }


        /*
         * ============================================================
         * PREVENT ADMIN FROM FORCE LOGGING OUT HIMSELF
         * ============================================================
         */
        if (adminUserId.equals(
                activity.getUserId())) {

            writeJson(
                    response,
                    false,
                    "You cannot force logout your own account."
            );

            return;
        }


        /*
         * ============================================================
         * FORCE LOGOUT DATABASE RECORD
         * ============================================================
         */
        boolean updated =
                service.forceLogout(
                        loginId,
                        adminUserId
                );


        if (!updated) {

            writeJson(
                    response,
                    false,
                    "Unable to force logout the user. "
                    + "The session may already be inactive."
            );

            return;
        }


        /*
         * ============================================================
         * INVALIDATE TARGET USER SESSION
         * ============================================================
         */
        String targetSessionId =
                activity.getSessionId();


        boolean sessionInvalidated = false;


        if (targetSessionId != null &&
                !targetSessionId.trim().isEmpty()) {

            try {

                HttpSession targetSession =
                        MyShopSessionRegistry.getSession(
                                targetSessionId
                        );


                if (targetSession != null) {

                    targetSession.invalidate();

                    sessionInvalidated = true;
                }

            } catch (IllegalStateException e) {

                /*
                 * Session was already invalidated.
                 */
                sessionInvalidated = true;

            } catch (Exception e) {

                e.printStackTrace();
            }
        }


        /*
         * ============================================================
         * RESPONSE
         * ============================================================
         */
        String targetUser =
                activity.getUserId();


        if (sessionInvalidated) {

            writeJson(
                    response,
                    true,
                    "User "
                    + targetUser
                    + " has been force logged out."
            );

        } else {

            writeJson(
                    response,
                    true,
                    "User "
                    + targetUser
                    + " was marked as force logged out."
            );
        }
    }


    /*
     * ============================================================
     * GET
     *
     * Force logout should normally be POST only.
     * ============================================================
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        writeJson(
                response,
                false,
                "Force logout must use POST."
        );
    }


    /*
     * ============================================================
     * JSON RESPONSE
     * ============================================================
     */
    private void writeJson(
            HttpServletResponse response,
            boolean success,
            String message)
            throws IOException {

        String safeMessage =
                message
                        .replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("\r", "\\r")
                        .replace("\n", "\\n");


        response.getWriter().write(
                "{"
                + "\"success\":"
                + success
                + ","
                + "\"message\":\""
                + safeMessage
                + "\""
                + "}"
        );
    }
}