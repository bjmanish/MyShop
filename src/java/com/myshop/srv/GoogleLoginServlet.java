package com.myshop.srv;

import com.myshop.beans.UserBean;
import com.myshop.service.impl.CartServiceImpl;
import com.myshop.service.impl.UserServiceImpl;
import com.myshop.utility.idUtil;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.json.JSONObject;
import java.net.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/GoogleLoginServlet")
public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        try {
            // Verify token with Google
            URL url = new URL("https://oauth2.googleapis.com/tokeninfo?id_token=" + token);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine, res = "";
            while ((inputLine = in.readLine()) != null) {
                res += inputLine;
            }
            in.close();

            JSONObject json = new JSONObject(res);

            String email = json.getString("email");
            String name = json.getString("name");

            System.out.println("Google User: " + email);
            


            UserServiceImpl userDao = new UserServiceImpl();

            // 🔥 Main logic
            UserBean user = userDao.loginOrRegisterGoogleUser(name, email);
            int cartCount = new CartServiceImpl().getCartCount(user.getId());

            
//            System.out.println("role "+role);
                // ✅ Create session
            HttpSession session = request.getSession();
            if (user != null && user.getRoleName() != null) {
            session.setAttribute("user_id", user.getId());
            session.setAttribute("username", user.getEmail());
            session.setAttribute("role", user.getRoleName());
            session.setAttribute("name", user.getName());
            session.setAttribute("sessionId", session.getId());
            String cartId = new CartServiceImpl().getCartId(user.getId());
            session.setAttribute("cartId", cartId);
            session.setAttribute("cartCount", cartCount);
            System.out.println("Cart Id from Login servlet "+cartId);

            // ✅ RETURN ROLE INSTEAD OF REDIRECT
                response.getWriter().write(user.getRoleName());
              System.out.println("data for staff:"+user.getRoleName());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("ERROR");
        }
    }
}