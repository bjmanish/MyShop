<%@page import="com.myshop.service.impl.UserServiceImpl"%>
<%@page import="com.myshop.beans.UserDetails"%>
<%@page import="com.myshop.srv.StaffImage"%>
<%@page import="com.myshop.service.impl.StaffServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.util.List" %>
<%@ page import="com.myshop.beans.StaffBean" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Staff</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            padding: 30px;
            background-color: #f8f9fa;
        }

        table tbody tr:hover {
            background-color: #f2f2f2;
        }

        .profile-img {
            height: 80px;
            width: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        #searchInput{
            width: 40%;
        }
    </style>
</head>
<body>

<%
    // ---- Session Validation ----
    String userName = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("role");

    if (userName == null || userType == null || !userType.equalsIgnoreCase("admin")) {
        response.sendRedirect("login.jsp?error=access_denied");
        return;
    }
%>

<jsp:include page="/header.jsp" />

<div class="container">

    <h2 class="mb-4 text-center">All Staff Members</h2>

    
    <div class="col-md-6 display-flex">
        <!-- Search -->
        <input type="text" id="searchInput" class="form-control mb-3" placeholder="Search by name or email">
        <!--<input type="text" id="searchInput" class="form-control mb-3" placeholder="Search ROLE">-->
<!--        <select id="searchInput" class="form-control w-25 mb-3">
            <option value="">All</option>
            <option value="ADMIN">Admin</option>
            <option value="DELIVERY">Delivery</option>
            <option value="CUSTOMER">Customer</option>
        </select>-->
    </div>
    

    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle text-center">
            <thead class="table-dark">
            <tr>
                <th>Profile</th>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Mobile</th>
                <th>Role</th>
                <th>Vehicle</th>
                <th>license</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>

            <tbody id="staffTable">

            <%
                List<UserDetails> userList = new ArrayList<>();
                UserServiceImpl sdao = new UserServiceImpl();
                userList = sdao.getAllUsers();

                if (userList != null && !userList.isEmpty()) {
                    for (UserDetails staff : userList) {
            %>
            <tr>
                <td>
                    <img src="<%=request.getContextPath()%>/showProfileImg?uid=<%= staff.getUserId() %>"
                         alt="Profile"
                         class="profile-img" onerror="this.src='../images/noimage.jpg';">
                </td>
                <td><%= staff.getUserId() %></td>
                <td><%= staff.getName() %></td>
                <td><%= staff.getEmail() %></td>
                <td><%= staff.getMobile() %></td>
                <td><%= staff.getRoleName() %></td>
                <td><%= (staff.getVehicle_type() != null) ? staff.getVehicle_type()  : "NO"%></td>               
                <td><%= (staff.getLicense_number() != null) ? "YES" : "NO" %></td>
                <td><%= staff.getStatus() %></td>
                <td>
                    <a href="editStaff.jsp?id=<%= staff.getUserId() %>"
                       class="btn btn-sm btn-primary">Edit</a>

                    <a href="deleteStaff?id=<%= staff.getUserId() %>"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
            <%
                    }
                }
            %>

            <!-- No Data Found Row -->
            <tr id="noDataRow" style="display:none;">
                <td colspan="6" class="text-center text-danger fw-bold">
                    No staff found
                </td>
            </tr>

            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

<!-- Search Script -->
<script>
    const searchInput = document.getElementById("searchInput");
    const tableBody = document.getElementById("staffTable");
    const noDataRow = document.getElementById("noDataRow");

    searchInput.addEventListener("keyup", function () {
        const filter = this.value.toLowerCase();
        const rows = tableBody.querySelectorAll("tr:not(#noDataRow)");
        let visibleCount = 0;

        rows.forEach(row => {
            const id = row.cells[1]?.textContent.toLowerCase();
            const email = row.cells[2]?.textContent.toLowerCase();
            const name = row.cells[3]?.textContent.toLowerCase();
            const role = row.cells[5]?.textContent.toLowerCase();

            if (email.includes(filter) || name.includes(filter) || id.includes(filter) || role.includes(filter)) {
                row.style.display = "";
                visibleCount++;
            } else {
                row.style.display = "none";
            }
        });

        // Show or hide "No staff found"
        noDataRow.style.display = visibleCount === 0 ? "" : "none";
    });
</script>

<jsp:include page="/footer.html" />
</body>
</html>
