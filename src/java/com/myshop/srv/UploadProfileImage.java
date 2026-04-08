/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.srv;

import com.myshop.utility.dbUtil;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet("/UploadProfileImage")
public class UploadProfileImage extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("profileImg");
        String userId = (String) request.getSession().getAttribute("user_id");
        System.out.println("userId from user profile:"+userId);
        InputStream inputStream = filePart.getInputStream();

        try (Connection con = dbUtil.provideConnection()) {

            String sql = "UPDATE USERS SET image = ? WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setBinaryStream(1, inputStream, (int) filePart.getSize());
            ps.setString(2, userId);

            ps.executeUpdate();

            response.getWriter().write("SUCCESS");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("ERROR");
        }
    }
}