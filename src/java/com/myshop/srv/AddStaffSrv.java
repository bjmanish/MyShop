package com.myshop.srv;

import com.myshop.beans.StaffBean;
import com.myshop.beans.UserBean;
import com.myshop.service.impl.StaffServiceImpl;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import org.json.JSONObject;


@WebServlet(name = "AddStaffSrv", urlPatterns = {"/AddStaffSrv"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Max File size 5MB
public class AddStaffSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public AddStaffSrv() {
        super();
    }

    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        try {

            // 🔐 SESSION CHECK
            HttpSession session = request.getSession();
            String role = (String) session.getAttribute("role");

            if (role == null || !role.equalsIgnoreCase("ADMIN")) {
                json.put("status", "error");
                json.put("message", "Unauthorized Access");
                out.print(json);
                return;
            }

            // 📥 GET DATA
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            String address = request.getParameter("address");
            int pincode = Integer.parseInt(request.getParameter("pincode"));

            String vehicle = request.getParameter("vehicleType");
            String license = request.getParameter("licenseNumber");

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // VALIDATION
            if (!password.equals(confirmPassword)) {
                json.put("status", "error");
                json.put("message", "Passwords do not match");
                out.print(json);
                return;
            }

            // IMAGE
            Part file = request.getPart("image");
            InputStream image = file.getInputStream();

            // 🧱 USER BEAN
            UserBean user = new UserBean();
            user.setName(name);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setAddress(address);
            user.setPincode(pincode);
            user.setPassword(password);
            user.setRoleId("R002");
            user.setRoleName("DELIVERY");
            
            // 🚚 STAFF BEAN
            StaffBean staff = new StaffBean();
            staff.setStaffId(email); // same id
            staff.setVehicle_type(vehicle);
            staff.setLicense_number(license);
//            staff.setAvailability_status(1);

            // 🔧 SERVICE
            StaffServiceImpl service = new StaffServiceImpl();
            String status = service.registerStaff(user, staff, image);

            if ("SUCCESS".equalsIgnoreCase(status)) {
                json.put("status", "success");
                json.put("message", "Staff Added Successfully");
            } else {
                json.put("status", "error");
                json.put("message", status);
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.put("status", "error");
            json.put("message", "Server Error");
        }

        out.print(json);
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
