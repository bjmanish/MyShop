/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myshop.utility;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "NetworkInfo", urlPatterns = {"/NetworkInfo"})
public class NetworkInfo extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");

        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");
        String host = request.getRemoteHost();

        String json = "{"
                + "\"ip\":\"" + ip + "\","
                + "\"host\":\"" + host + "\","
                + "\"userAgent\":\"" + userAgent + "\""
                + "}";

        response.getWriter().write(json);
        
        System.out.println("Network Info "+json);
        
    }
}