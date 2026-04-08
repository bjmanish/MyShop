package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.UserServiceImpl;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        HttpSession session = request.getSession();

    String email = request.getParameter("username");
    String password = request.getParameter("password");
    
//    System.out.println("email and password from servlet :"+email+", "+password);

    response.setContentType("text/plain"); 
    
    session.setMaxInactiveInterval(30 * 60);
    
    UserServiceImpl service = new UserServiceImpl();
    UserBean user = service.loginUser(email, password);
//    System.out.println("Login User :"+user.toString());
        
    if (user != null && user.getRoleName() != null) {

        session.setAttribute("user_id", user.getId());
        session.setAttribute("username", user.getEmail());
        session.setAttribute("role", user.getRoleName());
        session.setAttribute("name", user.getName());
        session.setAttribute("sessionId", session.getId());

        // ✅ RETURN ROLE INSTEAD OF REDIRECT
        response.getWriter().write(user.getRoleName());
//        System.out.println("data for staff:"+user.getRoleName());

    } else {
        response.getWriter().write("Invalid");
    }
}
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
