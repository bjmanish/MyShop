/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.srv;

import com.myshop.service.impl.CartServiceImpl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "cartCount", urlPatterns = {"/cartCount"})
public class cartCount extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain");

        String userId = (String) request.getSession().getAttribute("user_id");

        if(userId == null){
            response.getWriter().write("0");
            return;
        }

        CartServiceImpl cartService = new CartServiceImpl();
        int count = cartService.getCartCount(userId); // create this method

        response.getWriter().write(String.valueOf(count));
    }
}