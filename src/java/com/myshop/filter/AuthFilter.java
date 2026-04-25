package com.myshop.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String context = req.getContextPath(); // /MyShop
        HttpSession session = req.getSession(false);

        // ✅ Allow public resources
        if (uri.contains("login.jsp") ||
            uri.contains("LoginSrv") ||
            uri.contains("GoogleLoginServlet") ||
            uri.contains("register.jsp") ||
            uri.contains("RegisterSrv") ||
            uri.contains("LogoutSrv") ||
            uri.contains("ShowImage") ||
            uri.contains("ShowProfileImg") ||
            uri.contains("StaffImage") ||
            uri.contains("css") ||
            uri.contains("js") ||
            uri.contains("images") ||
            uri.contains("PaymentServlet") ||
            uri.contains("https://test.payu.in/_payment") ||
            uri.contains("fonts")) {
            chain.doFilter(request, response);
            return;
        }

        // ✅ Not logged in
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect(context + "/index.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ✅ ADMIN access
        if (uri.contains("/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendRedirect(context + "/unauthorized.jsp");
            return;
        }

        // ✅ USER access
        if (uri.contains("/user/") && !"USER".equalsIgnoreCase(role)) {
            res.sendRedirect(context + "/unauthorized.jsp");
            return;
        }
        
        // ✅ STAFF access
        if (uri.contains("/staff/") && !"DELIVERY".equalsIgnoreCase(role)) {
            res.sendRedirect(context + "/unauthorized.jsp");
            return;
        }

        // ✅ Allow request
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig fc) throws ServletException {
//        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void destroy() {
//        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}