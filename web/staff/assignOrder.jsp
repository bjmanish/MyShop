<%@ page import="java.util.*, com.myshop.beans.AssignOrder, com.myshop.service.impl.OrderServiceImpl" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Session validation
    String userType = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("username");
    String userId = (String) session.getAttribute("sessionId");
    
    if (userName == null || !"staff".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp?message=Please login as staff to access deliveries");
        return;
    }

    // Fetch assigned orders
    List<AssignOrder> assignedList = new OrderServiceImpl().getAssignedOrdersByStaff(userName);

    // OTP error handling
    String otpError = (String) request.getAttribute("otpError");
    String errorOrderId = (String) request.getAttribute("errorOrderId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assigned Deliveries - MyShop</title>

    <!-- ✅ Bootstrap 4 (FIXED) -->
    <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">-->

    <!-- jQuery + Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body class="bg-light">
<jsp:include page="/header.jsp" />

<div class="container mt-5 pt-4">
    <h3 class="text-center text-success mb-4">📦 Assigned Deliveries</h3>

    <% if (assignedList == null || assignedList.isEmpty()) { %>
        <div class="alert alert-info text-center shadow-sm">
            No deliveries assigned yet.
        </div>
    <% } else { %>

    <div class="table-responsive">
        <table class="table table-bordered table-striped shadow-sm">
            <thead class="table-success text-center">
                <tr>
                    <th>Assign ID</th>
                    <th>Order ID</th>
                    <th>Delivery Staff Name</th>
                    <th>Assign Date</th>
                    <th>Expected Delivery</th>
                    <th>Status</th>
                    <!--<th>OTP</th>-->
                    <th>Action</th>
                </tr>
            </thead>
            <tbody class="text-center align-middle">

            <% for (AssignOrder order : assignedList) { %>
                <tr>
                    <td><%= order.getAssignId() %></td>
                    <td><%= order.getOrderId() %></td>
                    <td><%= order.getStaffName() %></td>
                    <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(order.getAssignDate()) %></td>
                    <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(order.getAssignDate()) %></td>

                    <td>
                        <span class="badge
                            <%= "DELIVERED".equalsIgnoreCase(order.getDeliveryStatus()) ? "badge-success" :
                                "OUT_FOR_DELIVERY".equalsIgnoreCase(order.getDeliveryStatus()) ? "badge-warning" :
                                "badge-info" %>">
                            <%= order.getDeliveryStatus() %>
                        </span>
                    </td>

                    <%--    <td><%= order.getOtp() %></td> --%>

                    <td>
                        <% if ("READY_FOR_DELIVERED".equalsIgnoreCase(order.getDeliveryStatus())) { %>

                            <a href="ReadyForDeliverySrv?orderid=<%= order.getOrderId() %>&staffid=<%= staffEmail %>"
                               class="btn btn-sm btn-primary">
                               Ready for Delivery
                            </a>

                        <% } else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(order.getDeliveryStatus())) { %>

                            <!-- Button -->
                            <button type="button"
                                    class="btn btn-sm btn-success"
                                    data-toggle="modal"
                                    data-target="#otpModal_<%= order.getOrderId() %>">
                                Mark As Delivered
                            </button>

                            <!-- OTP Modal -->
                            <div class="modal fade" id="otpModal_<%= order.getOrderId() %>" tabindex="-1">
                                <div class="modal-dialog" role="document">
                                    <form action="DeliveredSrv" method="post">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h5 class="modal-title">Enter Delivery OTP</h5>
                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            </div>

                                            <div class="modal-body">

                                                <% if (otpError != null && errorOrderId != null
                                                       && errorOrderId.equals(order.getOrderId())) { %>
                                                    <div class="alert alert-danger">
                                                        <%= otpError %>
                                                    </div>
                                                <% } %>

                                                <input type="hidden" name="orderid" value="<%= order.getOrderId() %>">
                                                <input type="hidden" name="staffid" value="<%= staffEmail %>">
                                                <input type="hidden" name="aId" value="<%= order.getAssignId() %>">

                                                <div class="form-group">
                                                    <label>Enter 6-digit OTP:</label>
                                                    <input type="text"
                                                           name="otp"
                                                           class="form-control"
                                                           maxlength="6"
                                                           required
                                                           pattern="[0-9]{6}"
                                                           placeholder="Enter OTP">
                                                </div>
                                            </div>

                                            <div class="modal-footer">
                                                <button type="submit" class="btn btn-success">Confirm Delivery</button>
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                            </div>

                                        </div>
                                    </form>
                                </div>
                            </div>

                        <% } else { %>
                            <span class="text-muted">--</span>
                        <% } %>
                    </td>
                </tr>
            <% } %>

            </tbody>
        </table>
    </div>
    <% } %>
</div>

<!-- ✅ Auto reopen modal if OTP error -->
<% if (otpError != null && errorOrderId != null) { %>
<script>
    $(document).ready(function () {
        $('#otpModal_<%= errorOrderId %>').modal('show');
    });
</script>
<% } %>

<jsp:include page="/footer.html" />


</body>
</html>
