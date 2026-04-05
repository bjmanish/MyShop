package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.UserServiceImpl;
//import com.myshop.utility.PasswordEncryption;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONObject;

@WebServlet(name = "RegisterSrv", urlPatterns = {"/RegisterSrv"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)

public class RegisterSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        JSONObject json = new JSONObject();

        try {
            // 🔹 Get Data
            String userName = request.getParameter("name");
            String mobileNo = request.getParameter("mobile");
            String emailId = request.getParameter("email");
            String address = request.getParameter("address");
            String pinStr = request.getParameter("pincode");

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // 🔹 Validation
            if (userName == null || emailId == null || password == null ||
                userName.isEmpty() || emailId.isEmpty() || password.isEmpty()) {

                json.put("status", "error");
                json.put("message", "All fields are required!");
                out.print(json.toString());
                return;
            }

            // 🔹 Pincode validation
            int pinCode = 0;
            try {
                pinCode = Integer.parseInt(pinStr);
            } catch (Exception e) {
                json.put("status", "error");
                json.put("message", "Invalid Pincode!");
                out.print(json.toString());
                return;
            }

            // 🔹 Password match
            if (!password.equals(confirmPassword)) {
                json.put("status", "error");
                json.put("message", "Passwords do not match!");
                out.print(json.toString());
                return;
            }

            // 🔹 Encrypt Password (optional)
            // password = PasswordEncryption.getEncryptedPassword(password);

            // 🔹 Image Upload
            Part filePart = request.getPart("image");
            InputStream userImage = null;

            if (filePart != null && filePart.getSize() > 0) {
                userImage = filePart.getInputStream();
            } else {
                json.put("status", "error");
                json.put("message", "Please upload profile image!");
                out.print(json.toString());
                return;
            }

            // 🔹 Create Bean
            UserBean user = new UserBean();
            user.setName(userName);
            user.setEmail(emailId);
            user.setMobile(mobileNo);
            user.setAddress(address);
            user.setPincode(pinCode);
            user.setPassword(password);

            // 🔹 Call Service
            UserServiceImpl dao = new UserServiceImpl();
            String status = dao.registerUser(user, userImage);

            // 🔥 IMPORTANT: decide success or error
            if ("SUCCESS".equalsIgnoreCase(status)) {
                json.put("status", "success");
                json.put("message", "Registration Successful!");
            } else {
                json.put("status", "error");
                json.put("message", status); // e.g. Email exists
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "Server Error!");
        }

        out.print(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}