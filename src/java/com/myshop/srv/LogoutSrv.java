package com.myshop.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LogoutSrv")
public class LogoutSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔐 Get session (if exists)
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.removeAttribute("sessionId");
            session.removeAttribute("username");
            session.removeAttribute("role");
            session.invalidate(); // ✅ Destroy session completely
            
        }

        // 🚫 Prevent browser caching (VERY IMPORTANT)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // ✅ Redirect properly using context path
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=logout_success");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}