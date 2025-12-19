<%@ page import="java.util.*, com.myshop.beans.AssignOrder, com.myshop.service.impl.OrderServiceImpl" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Session validation
    String staffEmail = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("usertype");

    if (staffEmail == null || !"staff".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp?message=Please login as staff to access deliveries");
        return;
    }

    // Fetch assigned orders for this staff
    List<AssignOrder> assignedList = new OrderServiceImpl().getAssignedOrdersByStaff(staffEmail);
//    System.out.println("assign delivery list: "+assignedList.toString());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assigned Deliveries - MyShop</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <!-- jQuery (Required for Bootstrap 4/5) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap JS (for modals, dropdowns, etc.) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</head>

<body class="bg-light">
<jsp:include page="header.jsp" />

<div class="container mt-5 pt-4">
    <h3 class="text-center text-success mb-4">📦 Assigned Deliveries</h3>

    <%
        if (assignedList == null || assignedList.isEmpty()) {
    %>
        <div class="alert alert-info text-center shadow-sm">
            No deliveries assigned yet.
        </div>
    <%
        } else {
    %>

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
                    <th>OTP</th>
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
                            <%= "Delivered".equalsIgnoreCase(order.getDeliveryStatus()) ? "bg-success" : 
                                "Out For Delivery".equalsIgnoreCase(order.getDeliveryStatus()) ? "bg-warning text-dark" : "bg-info" %>">
                            <%= order.getDeliveryStatus() %>
                        </span>
                    </td>
                    <td><%= order.getOtp() %></td>

                    <td>
                        <% if ("Out For Delivery".equalsIgnoreCase(order.getDeliveryStatus())) { %>
                            <a href="ReadyForDeliverySrv?orderid=<%= order.getOrderId() %>&staffid=<%= staffEmail %>"
                               class="btn btn-sm btn-primary">Ready for Delivery</a>
                        <% } if ("Ready For Delivery".equalsIgnoreCase(order.getDeliveryStatus())) { %>
                                <!-- ✅ Button triggers modal popup -->
                                <button type="button" 
                                    class="btn btn-sm btn-success" 
                                    data-toggle="modal" 
                                    data-target="#otpModal_<%= order.getOrderId() %>">
                                    Mark As Delivered
                                </button>

                                <!-- ✅ OTP Modal -->
                                <div class="modal fade" id="otpModal_<%= order.getOrderId() %>" tabindex="-1" role="dialog" aria-labelledby="otpModalLabel" aria-hidden="true">
                                    <div class="modal-dialog" role="document">
                                        <form action="DeliveredSrv" method="post">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Enter Delivery OTP</h5>
                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                </div>
                                                <div class="modal-body">
                                                    <input type="hidden" name="orderid" value="<%= order.getOrderId() %>">
                                                    <input type="hidden" name="staffid" value="<%= staffEmail %>">
                                                    <input type="hidden" name="aId" value="<%=order.getAssignId() %>">
                                                    <div class="form-group">
                                                        <label>Enter 6-digit OTP:</label>
                                                        <input type="text" name="otp" class="form-control" maxlength="6" required pattern="[0-9]{6}" placeholder="Enter OTP">
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

</body>
</html>
