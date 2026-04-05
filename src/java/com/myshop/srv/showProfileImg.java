package com.myshop.srv;

import com.myshop.service.impl.UserServiceImpl;
import java.awt.image.BufferedImage;
import java.io.*;
import javax.imageio.ImageIO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/showProfileImg")
public class showProfileImg extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("uid");
     
        byte[] image = null;
        UserServiceImpl dao = new UserServiceImpl();
        image = dao.getProfileImg(userId);

        if(image == null){
            File fnew = new File(request.getServletContext().getRealPath("images/noimage.jpg") );
            BufferedImage originalImage = ImageIO.read(fnew);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(originalImage, "jpg", baos);
            image = baos.toByteArray();
        }
        
        ServletOutputStream sos = null;
        sos = response.getOutputStream();
        sos.write(image);
    }
}