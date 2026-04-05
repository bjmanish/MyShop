package com.myshop.srv;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.myshop.utility.dbUtil;

@WebServlet("/UpdateProductImageSrv")
@MultipartConfig
public class UpdateProductImageSrv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        String pid = request.getParameter("pid");
        Part filePart = request.getPart("image");

        try (Connection conn = dbUtil.provideConnection()) {

            InputStream inputStream = filePart.getInputStream();

            PreparedStatement ps = conn.prepareStatement(
                "UPDATE PRODUCTS SET image=? WHERE product_id=?");

            ps.setBinaryStream(1, inputStream, (int) filePart.getSize());
            ps.setString(2, pid);

            int result = ps.executeUpdate();

            if(result > 0){
                response.getWriter().print("SUCCESS");
            } else {
                response.getWriter().print("FAIL");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("ERROR");
        }
    }
}