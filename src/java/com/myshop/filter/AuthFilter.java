package com.myshop.filter;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String context = req.getContextPath();

        HttpSession session = req.getSession(false);

        /* =====================================================
           PUBLIC RESOURCES
           ===================================================== */

        if (isPublicResource(uri, context)) {
            chain.doFilter(request, response);
            return;
        }

        /* =====================================================
           LOGIN CHECK
           ===================================================== */

        if (!isLoggedIn(session)) {

            if (session != null) {
                session.invalidate();
            }

            redirectToLogin(
                    req,
                    res,
                    "Your login session has expired. Please login again."
            );

            return;
        }

        /* =====================================================
           GET ROLE
           ===================================================== */

        String role = String.valueOf(
                session.getAttribute("role")
        ).trim().toUpperCase();

        /* =====================================================
           ADMIN AREA
           ===================================================== */

        if (uri.contains("/admin/")) {

            if (!"ADMIN".equals(role)) {

                res.sendRedirect(
                        context + "/unauthorized.jsp"
                );

                return;
            }
        }

        /* =====================================================
           USER / CUSTOMER AREA
           ===================================================== */

        if (uri.contains("/user/")) {

            if (!"USER".equals(role)
                    && !"CUSTOMER".equals(role)) {

                res.sendRedirect(
                        context + "/unauthorized.jsp"
                );

                return;
            }
        }

        /* =====================================================
           STAFF / DELIVERY AREA
           ===================================================== */

        if (uri.contains("/staff/")) {

            if (!"DELIVERY".equals(role)
                    && !"STAFF".equals(role)) {

                res.sendRedirect(
                        context + "/unauthorized.jsp"
                );

                return;
            }
        }

        /* =====================================================
           CONTINUE REQUEST
           ===================================================== */

        chain.doFilter(request, response);
    }


    /* =========================================================
       CHECK LOGIN
       ========================================================= */

    private boolean isLoggedIn(HttpSession session) {

        if (session == null) {
            return false;
        }

        Object role = session.getAttribute("role");
        Object userId = session.getAttribute("user_id");

        return role != null
                && userId != null
                && !String.valueOf(role).trim().isEmpty()
                && !String.valueOf(userId).trim().isEmpty();
    }


    /* =========================================================
       PUBLIC RESOURCE CHECK
       ========================================================= */

    private boolean isPublicResource(
            String uri,
            String context) {

        String path = uri.substring(context.length());

        return

                /* Login */
                path.equals("/login.jsp")
                || path.contains("/LoginSrv")
                || path.contains("/GoogleLoginServlet")

                /* Register */
                || path.equals("/register.jsp")
                || path.contains("/RegisterSrv")

                /* Logout */
                || path.contains("/LogoutSrv")
                
                /* Payment */
                || path.equals("/PaymentFailureServlet")
                || path.contains("/PaymentSuccessServlet")
                || path.contains("/PaymentServlet")

                /* Home */
                || path.equals("/")
                || path.equals("/index.jsp")

                /* Public product image */
                || path.contains("/ShowImage")
                || path.contains("/ShowProfileImg")
                || path.contains("/StaffImage")

                /* Static resources */
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/fonts/")

                /* Favicon */
                || path.equalsIgnoreCase("/favicon.ico")

                /* Public pages */
                || path.equals("/unauthorized.jsp");
    }


    /* =========================================================
       REDIRECT TO LOGIN WITH MESSAGE
       ========================================================= */

    private void redirectToLogin(
            HttpServletRequest req,
            HttpServletResponse res,
            String message)
            throws IOException {

        String encodedMessage =
                URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8.name()
                );

        res.sendRedirect(
                req.getContextPath()
                + "/login.jsp?message="
                + encodedMessage
        );
    }


    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {
    }

    @Override
    public void destroy() {
    }
}