package com.myshop.srv;

import com.myshop.service.impl.UserLoginActivityServiceImpl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutSrv", urlPatterns = {"/LogoutSrv"})
public class LogoutSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        logout(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        logout(request, response);
    }

    private void logout(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session != null) {

            String userId =
                    (String) session.getAttribute(
                            "user_id"
                    );

            Object activityObject =
                    session.getAttribute(
                            "loginActivityId"
                    );

            if (userId != null
                    && activityObject != null) {

                try {

                    long loginActivityId =
                            Long.parseLong(
                                    activityObject.toString()
                            );

                    UserLoginActivityServiceImpl
                            activityService =
                            new UserLoginActivityServiceImpl();

                    activityService.logoutActivity(
                            loginActivityId,
                            userId
                    );

                } catch (Exception e) {

                    e.printStackTrace();
                }
            }

            session.invalidate();
        }

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?message="
                + java.net.URLEncoder.encode(
                        "You have been logged out successfully.",
                        "UTF-8"
                )
        );
    }
}