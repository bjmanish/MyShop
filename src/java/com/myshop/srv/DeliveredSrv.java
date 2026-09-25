package com.myshop.srv;

import com.myshop.service.impl.OrderServiceImpl;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(
    name = "DeliveredSrv",
    urlPatterns = {"/DeliveredSrv"}
)
public class DeliveredSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        /* =====================================================
           SESSION
           ===================================================== */

        HttpSession session =
            request.getSession(false);


        if (session == null) {

            redirectToLogin(
                request,
                response,
                "Session expired! Please login again."
            );

            return;
        }


        /*
         * Logged-in username/email
         */
        String staffEmail =
            (String) session.getAttribute("username");


        /*
         * IMPORTANT:
         *
         * ASSIGNORDERFORSTAFF.staff_id contains the staff ID.
         *
         * Therefore do NOT trust staffid coming from the
         * hidden HTML field.
         *
         * Take it from the authenticated session.
         */
        String sessionStaffId =
            (String) session.getAttribute("user_id");


        String role =
            (String) session.getAttribute("role");


        /* =====================================================
           AUTHENTICATION CHECK
           ===================================================== */

        if (staffEmail == null
                || sessionStaffId == null
                || sessionStaffId.trim().isEmpty()
                || role == null
                || (
                    !"STAFF".equalsIgnoreCase(role)
                    &&
                    !"DELIVERY".equalsIgnoreCase(role)
                )) {

            redirectToLogin(
                request,
                response,
                "Your login session has expired. Please login again."
            );

            return;
        }


        /* =====================================================
           GET REQUEST PARAMETERS
           ===================================================== */

        String assignIdParam =
            request.getParameter("aId");

        String orderId =
            request.getParameter("orderid");

        String enteredOtp =
            request.getParameter("otp");


        System.out.println(
            "========================================"
        );

        System.out.println(
            "DeliveredSrv - Delivery Verification"
        );

        System.out.println(
            "Staff ID    : " + sessionStaffId
        );

        System.out.println(
            "Staff Email : " + staffEmail
        );

        System.out.println(
            "Assign ID   : " + assignIdParam
        );

        System.out.println(
            "Order ID    : " + orderId
        );


        /* =====================================================
           BASIC VALIDATION
           ===================================================== */

        if (assignIdParam == null
                || assignIdParam.trim().isEmpty()
                || orderId == null
                || orderId.trim().isEmpty()
                || enteredOtp == null
                || enteredOtp.trim().isEmpty()) {

            forwardError(
                request,
                response,
                "Invalid delivery request. Please try again.",
                orderId
            );

            return;
        }


        /* =====================================================
           PARSE ASSIGN ID
           ===================================================== */

        int assignId;

        try {

            assignId =
                Integer.parseInt(
                    assignIdParam.trim()
                );

        } catch (NumberFormatException e) {

            System.out.println(
                "Invalid Assign ID: "
                + assignIdParam
            );

            forwardError(
                request,
                response,
                "Invalid assignment ID.",
                orderId
            );

            return;
        }


        /* =====================================================
           OTP CLEANUP
           ===================================================== */

        enteredOtp =
            enteredOtp.trim();


        /* =====================================================
           OTP FORMAT VALIDATION
           ===================================================== */

        if (!enteredOtp.matches("\\d{6}")) {

            forwardError(
                request,
                response,
                "OTP must contain exactly 6 digits.",
                orderId
            );

            return;
        }


        /* =====================================================
           SERVICE
           ===================================================== */

        OrderServiceImpl service =
            new OrderServiceImpl();


        /* =====================================================
           GET OTP FROM DATABASE
           ===================================================== */

        String dbOtp =
            service.getOtpByAssignId(assignId);


        System.out.println(
            "DB OTP     : "
            + (dbOtp == null ? "NULL" : "******")
        );

        System.out.println(
            "Entered OTP: ******"
        );


        /* =====================================================
           OTP NOT FOUND
           ===================================================== */

        if (dbOtp == null
                || dbOtp.trim().isEmpty()) {

            forwardError(
                request,
                response,
                "No valid OTP found for this delivery. Please generate a new OTP.",
                orderId
            );

            return;
        }


        /* =====================================================
           OTP MATCH
           ===================================================== */

        if (!enteredOtp.equals(dbOtp.trim())) {

            System.out.println(
                "OTP verification failed."
            );

            forwardError(
                request,
                response,
                "Invalid OTP! Please enter the correct customer OTP.",
                orderId
            );

            return;
        }


        System.out.println(
            "OTP verification successful."
        );


        /* =====================================================
           MARK ASSIGNMENT AS DELIVERED
           
           IMPORTANT:
           Use sessionStaffId instead of request staffid.
           ===================================================== */

        String updateStatus =
            service.markOrderAsDelivered(
                assignId,
                sessionStaffId
            );


        System.out.println(
            "Assignment update result: "
            + updateStatus
        );


        /* =====================================================
           UPDATE FAILED
           ===================================================== */

        if (!"SUCCESS".equalsIgnoreCase(updateStatus)) {

            forwardError(
                request,
                response,
                "Failed to update delivery status. Please try again.",
                orderId
            );

            return;
        }


        /* =====================================================
           UPDATE ORDER STATUS
           ===================================================== */

        service.updateOrderStatus(
            orderId,
            "DELIVERED"
        );


        /* =====================================================
           INVALIDATE OTP
           
           Prevents the same OTP from being reused.
           ===================================================== */

        service.updateOTPAfterDelivery(
            assignId
        );


        System.out.println(
            "Order " + orderId
            + " successfully marked as DELIVERED."
        );


        /* =====================================================
           SUCCESS REDIRECT
           ===================================================== */

        String message =
            URLEncoder.encode(
                "OTP verified! Order marked as Delivered successfully.",
                "UTF-8"
            );


        response.sendRedirect(
            request.getContextPath()
            + "/staff/assignOrder.jsp?message="
            + message
        );
    }


    /* =========================================================
       FORWARD ERROR TO ASSIGN ORDER PAGE
       ========================================================= */

    private void forwardError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message,
            String orderId)
            throws ServletException, IOException {


        request.setAttribute(
            "otpError",
            message
        );


        request.setAttribute(
            "errorOrderId",
            orderId
        );


        RequestDispatcher dispatcher =
            request.getRequestDispatcher(
                "/staff/assignOrder.jsp"
            );


        dispatcher.forward(
            request,
            response
        );
    }


    /* =========================================================
       LOGIN REDIRECT
       ========================================================= */

    private void redirectToLogin(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {


        String encodedMessage =
            URLEncoder.encode(
                message,
                "UTF-8"
            );


        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message="
            + encodedMessage
        );
    }
}