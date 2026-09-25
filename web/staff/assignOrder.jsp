<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.myshop.beans.AssignOrder" %>
<%@ page import="com.myshop.service.impl.OrderServiceImpl" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    /* =========================================================
       SESSION VALIDATION
       ========================================================= */

    String userType =
        (String) session.getAttribute("role");

    String userName =
        (String) session.getAttribute("username");

    String userId =
        (String) session.getAttribute("user_id");


    if (userName == null
            || userName.trim().isEmpty()
            || userType == null
            || userId == null
            || userId.trim().isEmpty()
            || (!"STAFF".equalsIgnoreCase(userType)
                && !"DELIVERY".equalsIgnoreCase(userType))) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?message=Please login as staff to access deliveries"
        );

        return;
    }


    /* =========================================================
       FETCH ASSIGNED ORDERS
       ========================================================= */

    List<AssignOrder> assignedList =
        new OrderServiceImpl()
            .getAssignedOrdersByStaff(userId);


    /* =========================================================
       OTP ERROR
       ========================================================= */

    String otpError =
        (String) request.getAttribute("otpError");

    String errorOrderId =
        (String) request.getAttribute("errorOrderId");


    /* =========================================================
       MESSAGE
       ========================================================= */

    String message =
        request.getParameter("message");


    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd-MM-yyyy hh:mm a");
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Assigned Deliveries | MYSHOP</title>


    <!-- =====================================================
         FAVICON
         ===================================================== -->

    <link
        rel="icon"
        type="image/x-icon"
        href="<%=request.getContextPath()%>/favicon.ico"
    >


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
    >


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    >


    <!-- =====================================================
         GOOGLE FONT
         ===================================================== -->

    <link
        rel="preconnect"
        href="https://fonts.googleapis.com"
    >

    <link
        rel="preconnect"
        href="https://fonts.gstatic.com"
    >

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet"
    >


    <!-- =====================================================
         ASSIGN CSS
         ===================================================== -->

    <link
        rel="stylesheet"
        href="<%=request.getContextPath()%>/css/assign.css"
    >

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="delivery-page">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <section class="delivery-header">


        <div class="delivery-title">


            <div class="delivery-icon">

                <i class="fa-solid fa-truck-fast"></i>

            </div>


            <div>

                <h1>
                    Assigned Deliveries
                </h1>

                <p>
                    Manage your assigned orders and delivery status.
                </p>

            </div>


        </div>


        <div class="staff-badge">

            <i class="fa-solid fa-user"></i>

            <span>
                <%=userName%>
            </span>

        </div>


    </section>


    <!-- =====================================================
         SUCCESS MESSAGE
         ===================================================== -->

<%
    if (message != null
            && !message.trim().isEmpty()) {
%>

    <div
        class="delivery-page-message success-message"
        id="deliveryMessage"
    >

        <i class="fa-solid fa-circle-check"></i>

        <span>
            <%=message%>
        </span>

        <button
            type="button"
            onclick="closeDeliveryMessage()"
        >
            <i class="fa-solid fa-xmark"></i>
        </button>

    </div>

<%
    }
%>


    <!-- =====================================================
         DELIVERY CARD
         ===================================================== -->

    <section class="delivery-card">


<%
    if (assignedList == null
            || assignedList.isEmpty()) {
%>


        <!-- =================================================
             EMPTY STATE
             ================================================= -->

        <div class="empty-state">


            <div class="empty-icon">

                <i class="fa-solid fa-box-open"></i>

            </div>


            <h4>
                No Deliveries Assigned
            </h4>


            <p>
                There are currently no deliveries assigned to you.
            </p>


        </div>


<%
    } else {
%>


        <!-- =================================================
             TABLE
             ================================================= -->

        <div class="table-wrapper">


            <table class="delivery-table">


                <thead>

                    <tr>

                        <th>
                            Assign ID
                        </th>

                        <th>
                            Order ID
                        </th>

                        <th>
                            Delivery Staff
                        </th>

                        <th>
                            Assign Date
                        </th>

                        <th>
                            Expected Delivery
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                </thead>


                <tbody>


<%
        for (AssignOrder order : assignedList) {


            /* =================================================
               STATUS
               ================================================= */

            String status =
                order.getDeliveryStatus();


            if (status == null
                    || status.trim().isEmpty()) {

                status = "PENDING";

            }


            status =
                status.trim();


            /* =================================================
               STATUS DESIGN
               ================================================= */

            String statusClass =
                "status-default";

            String statusIcon =
                "fa-clock";


            if ("DELIVERED".equalsIgnoreCase(status)) {

                statusClass =
                    "status-delivered";

                statusIcon =
                    "fa-circle-check";


            } else if (
                "OUT_FOR_DELIVERY"
                    .equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-out";

                statusIcon =
                    "fa-truck-fast";


            } else if (
                "ASSIGNED".equalsIgnoreCase(status)
                ||
                "PENDING".equalsIgnoreCase(status)
                ||
                "READY_FOR_DELIVERED".equalsIgnoreCase(status)
            ) {

                statusClass =
                    "status-ready";

                statusIcon =
                    "fa-box";

            }
%>


                    <tr>


                        <!-- =================================
                             ASSIGN ID
                             ================================= -->

                        <td>

                            <span class="assign-id">

                                <%--<%=order.getAssignId()%> --%>

                            </span>

                        </td>


                        <!-- =================================
                             ORDER ID
                             ================================= -->

                        <td>

                            <span class="order-id">

                                <%=order.getOrderId()%>

                            </span>

                        </td>


                        <!-- =================================
                             STAFF
                             ================================= -->

                        <td>

                            <span class="staff-name-cell">

                                <i class="fa-solid fa-user"></i>

                                <%=order.getStaffName()%>

                            </span>

                        </td>


                        <!-- =================================
                             ASSIGN DATE
                             ================================= -->

                        <td>

<%
                        if (order.getAssignDate() != null) {
%>

                            <%=dateFormat.format(
                                order.getAssignDate()
                            )%>

<%
                        } else {
%>

                            -

<%
                        }
%>

                        </td>


                        <!-- =================================
                             EXPECTED DELIVERY
                             ================================= -->

                        <td>

<%
                        /*
                         * AssignOrder currently exposes
                         * assignDate only.
                         *
                         * Therefore this uses assignDate
                         * until a separate expected-delivery
                         * property is available.
                         */

                        if (order.getAssignDate() != null) {
%>

                            <%=dateFormat.format(
                                order.getAssignDate()
                            )%>

<%
                        } else {
%>

                            -

<%
                        }
%>

                        </td>


                        <!-- =================================
                             STATUS
                             ================================= -->

                        <td>

                            <span
                                class="status-badge <%=statusClass%>"
                            >

                                <i
                                    class="fa-solid <%=statusIcon%>"
                                ></i>

                                <%=status.replace(
                                    "_",
                                    " "
                                )%>

                            </span>

                        </td>


                        <!-- =================================
                             ACTION
                             ================================= -->

                        <td>


<%
            /*
             * =================================================
             * ASSIGNED / PENDING / READY
             *
             * Show Ready for Delivery
             * =================================================
             */

            if (
                "ASSIGNED".equalsIgnoreCase(status)
                ||
                "PENDING".equalsIgnoreCase(status)
                ||
                "READY_FOR_DELIVERED".equalsIgnoreCase(status)
            ) {
%>


                            <a
                                href="<%=request.getContextPath()%>/OutForDeliverySrv?orderid=<%=order.getOrderId()%>&staffid=<%=userId%>&aId=<%=order.getAssignId()%>"
                                class="delivery-action ready-btn"
                            >

                                <i
                                    class="fa-solid fa-truck"
                                ></i>

                                Ready for Delivery

                            </a>


<%
            }

            /*
             * =================================================
             * OUT FOR DELIVERY
             *
             * Show Confirm Delivery modal button
             * =================================================
             */

            else if (
                "OUT_FOR_DELIVERY".equalsIgnoreCase(status)
            ) {
%>


                            <button
                                type="button"
                                class="delivery-action delivered-btn"
                                data-bs-toggle="modal"
                                data-bs-target="#otpModal_<%=order.getOrderId()%>"
                            >

                                <i
                                    class="fa-solid fa-circle-check"
                                ></i>

                                Mark As Delivered

                            </button>


<%
            }

            /*
             * =================================================
             * DELIVERED
             * =================================================
             */

            else if (
                "DELIVERED".equalsIgnoreCase(status)
            ) {
%>


                            <span
                                class="delivered-action-text"
                            >

                                <i
                                    class="fa-solid fa-circle-check"
                                ></i>

                                Delivered

                            </span>


<%
            }

            /*
             * =================================================
             * UNKNOWN STATUS
             * =================================================
             */

            else {
%>


                            <span
                                class="no-action"
                            >

                                <i
                                    class="fa-solid fa-minus"
                                ></i>

                                No Action

                            </span>


<%
            }
%>


                        </td>


                    </tr>


<%
        }
%>


                </tbody>


            </table>


        </div>


<%
    }
%>


    </section>


</main>


<!-- =========================================================
     CONFIRM DELIVERY MODALS

     IMPORTANT:
     These modals are OUTSIDE the table and table-wrapper.
     ========================================================= -->


<%
    if (assignedList != null
            && !assignedList.isEmpty()) {


        for (AssignOrder order :
                assignedList) {


            String modalStatus =
                order.getDeliveryStatus();


            if (modalStatus == null) {

                modalStatus = "";

            }


            if (
                "OUT_FOR_DELIVERY"
                    .equalsIgnoreCase(modalStatus)
            ) {
%>


<div
    class="modal fade delivery-confirm-modal"
    id="otpModal_<%=order.getOrderId()%>"
    tabindex="-1"
    aria-labelledby="otpModalLabel_<%=order.getOrderId()%>"
    aria-hidden="true"
>


    <div
        class="modal-dialog modal-dialog-centered"
    >


        <form
            action="<%=request.getContextPath()%>/DeliveredSrv"
            method="post"
            class="modal-content confirm-delivery-content"
        >


            <!-- =============================================
                 HEADER
                 ============================================= -->


            <div
                class="confirm-delivery-header"
            >


                <div
                    class="confirm-delivery-heading"
                >


                    <div
                        class="confirm-delivery-icon"
                    >

                        <i
                            class="fa-solid fa-shield-halved"
                        ></i>

                    </div>


                    <div>

                        <h5
                            id="otpModalLabel_<%=order.getOrderId()%>"
                        >

                            Confirm Delivery

                        </h5>


                        <p>

                            Enter the customer's delivery OTP

                        </p>

                    </div>


                </div>


                <button
                    type="button"
                    class="confirm-close-btn"
                    data-bs-dismiss="modal"
                    aria-label="Close"
                >

                    <i
                        class="fa-solid fa-xmark"
                    ></i>

                </button>


            </div>


            <!-- =============================================
                 BODY
                 ============================================= -->


            <div
                class="confirm-delivery-body"
            >


<%
                if (
                    otpError != null
                    &&
                    errorOrderId != null
                    &&
                    errorOrderId.equals(
                        order.getOrderId()
                    )
                ) {
%>


                <div
                    class="confirm-otp-error"
                >

                    <i
                        class="fa-solid fa-circle-exclamation"
                    ></i>

                    <span>

                        <%=otpError%>

                    </span>

                </div>


<%
                }
%>


                <!-- ORDER INFO -->


                <div
                    class="confirm-order-info"
                >


                    <div
                        class="confirm-info-box"
                    >

                        <span
                            class="confirm-info-label"
                        >

                            Order ID

                        </span>


                        <span
                            class="confirm-info-value"
                        >

                            <%=order.getOrderId()%>

                        </span>

                    </div>


                    <div
                        class="confirm-info-box"
                    >

                        <span
                            class="confirm-info-label"
                        >

                            Assign ID

                        </span>


                        <span
                            class="confirm-info-value"
                        >

                            <%=order.getAssignId()%>

                        </span>

                    </div>


                </div>


                <!-- HIDDEN VALUES -->


                <input
                    type="hidden"
                    name="orderid"
                    value="<%=order.getOrderId()%>"
                >


                <input
                    type="hidden"
                    name="aId"
                    value="<%=order.getAssignId()%>"
                >


                <!-- =================================================
                     OTP
                     ================================================= -->


                <div
                    class="confirm-otp-section"
                >


                    <label
                        for="otp_<%=order.getOrderId()%>"
                        class="confirm-otp-label"
                    >

                        <i
                            class="fa-solid fa-key"
                        ></i>

                        Enter 6-digit OTP

                    </label>


                    <input
                        type="text"
                        id="otp_<%=order.getOrderId()%>"
                        name="otp"
                        class="confirm-otp-input"
                        maxlength="6"
                        minlength="6"
                        pattern="[0-9]{6}"
                        inputmode="numeric"
                        autocomplete="one-time-code"
                        placeholder="••••••"
                        required
                    >


                    <div
                        class="confirm-otp-help"
                    >

                        <i
                            class="fa-solid fa-circle-info"
                        ></i>

                        Enter the OTP provided by the customer.

                    </div>


                </div>


            </div>


            <!-- =============================================
                 FOOTER
                 ============================================= -->


            <div
                class="confirm-delivery-footer"
            >


                <button
                    type="button"
                    class="confirm-cancel-btn"
                    data-bs-dismiss="modal"
                >

                    <i
                        class="fa-solid fa-xmark"
                    ></i>

                    Cancel

                </button>


                <button
                    type="submit"
                    class="confirm-submit-btn"
                >

                    <i
                        class="fa-solid fa-circle-check"
                    ></i>

                    Confirm Delivery

                </button>


            </div>


        </form>


    </div>


</div>


<%
            }
        }
    }
%>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"/>


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script>

    /* =========================================================
       THEME
       ========================================================= */

    function applyTheme() {

        const theme =
            localStorage.getItem("myshop-theme");


        if (theme === "dark") {

            document.body.classList.add(
                "dark-mode"
            );

        } else {

            document.body.classList.remove(
                "dark-mode"
            );

        }

    }


    applyTheme();


    /* =========================================================
       SUCCESS MESSAGE AUTO CLOSE
       ========================================================= */

    function closeDeliveryMessage() {

        const message =
            document.getElementById(
                "deliveryMessage"
            );


        if (message) {

            message.remove();

        }

    }


    setTimeout(
        closeDeliveryMessage,
        5000
    );


    /* =========================================================
       OTP ONLY NUMBERS
       ========================================================= */

    document.addEventListener(
        "input",
        function(event) {


            if (
                event.target.classList.contains(
                    "confirm-otp-input"
                )
            ) {


                event.target.value =
                    event.target.value
                        .replace(/\D/g, "")
                        .substring(0, 6);


            }

        }
    );


    /* =========================================================
       OTP FOCUS
       ========================================================= */

    document.addEventListener(
        "shown.bs.modal",
        function(event) {


            const modal =
                event.target;


            const input =
                modal.querySelector(
                    ".confirm-otp-input"
                );


            if (input) {


                setTimeout(
                    function() {

                        input.focus();

                    },
                    250
                );


            }

        }
    );


</script>


<!-- =========================================================
     REOPEN MODAL AFTER INVALID OTP
     ========================================================= -->


<%
    if (
        otpError != null
        &&
        errorOrderId != null
    ) {
%>


<script>

    document.addEventListener(
        "DOMContentLoaded",
        function() {


            const modalElement =
                document.getElementById(
                    "otpModal_<%=errorOrderId%>"
                );


            if (modalElement) {


                const modal =
                    bootstrap.Modal.getOrCreateInstance(
                        modalElement
                    );


                modal.show();


            }

        }
    );

</script>


<%
    }
%>


</body>

</html>