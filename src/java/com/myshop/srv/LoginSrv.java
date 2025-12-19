package com.myshop.srv;

import com.myshop.beans.StaffBean;
import com.myshop.beans.UserBean;
import com.myshop.service.impl.StaffServiceImpl;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.utility.PasswordEncryption;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("usertype");

        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        try {

            /* ================= ADMIN LOGIN ================= */
            if ("admin".equalsIgnoreCase(userType)) {

                if ("admin123@gmail.com".equalsIgnoreCase(userName) && "admin".equals(password)) {

                    session.setAttribute("username", userName);
                    session.setAttribute("usertype", "admin");
                    session.setAttribute("password", PasswordEncryption.getEncryptedPassword(password));        
                    response.sendRedirect("adminHome.jsp?id="+session.getId());
                    return;
                } else {
                    session.setAttribute("error", "Invalid admin credentials");
                }
            }

            /* ================= STAFF LOGIN ================= */
            else if ("staff".equalsIgnoreCase(userType)) {

                StaffServiceImpl staffDao = new StaffServiceImpl();
                String status = staffDao.isValidCredential(userName, password);

                if ("valid".equalsIgnoreCase(status)) {

                    StaffBean staff = staffDao.getStaffDetails(userName, password);

                    session.setAttribute("username", userName);
                    session.setAttribute("staffname", staff.getStaffName());
                    session.setAttribute("usertype", "staff");
                     session.setAttribute("password", PasswordEncryption.getEncryptedPassword(password));
                    response.sendRedirect("staffHome.jsp?id="+session.getId());
                    return;
                } else {
                    session.setAttribute("error", status);
                }
            }

            /* ================= CUSTOMER LOGIN ================= */
            else if ("customer".equalsIgnoreCase(userType)) {

                UserServiceImpl udao = new UserServiceImpl();
                String status = udao.isValidCredential(userName, password);

                if ("valid".equalsIgnoreCase(status)) {

                    UserBean user = udao.getUserDetails(userName, password);

                    session.setAttribute("username", userName);
                    session.setAttribute("usertype", "customer");
                    session.setAttribute("password", PasswordEncryption.getEncryptedPassword(password));
                    response.sendRedirect("userHome.jsp?id="+session.getId());
                    return;
                } else {
                    session.setAttribute("error", status);
                }
            }

            /* ================= INVALID TYPE ================= */
            else {
                session.setAttribute("error", "Invalid user type selected");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Something went wrong. Try again.");
        }

        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
