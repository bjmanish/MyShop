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

    <!-- Search -->
    <input type="text" id="searchInput" class="form-control mb-3"
           placeholder="Search by name or email">

    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle text-center">
            <thead class="table-dark">
            <tr>
                <th>Profile</th>
                <th>ID</th>
                <th>Email</th>
                <th>Name</th>
                <th>Mobile</th>
                <th>Actions</th>
            </tr>
            </thead>

            <tbody id="staffTable">

            <%
                List<StaffBean> staffList = new ArrayList<>();
                StaffServiceImpl sdao = new StaffServiceImpl();
                staffList = sdao.getAllStaffs();

                if (staffList != null && !staffList.isEmpty()) {
                    for (StaffBean staff : staffList) {
            %>
            <tr>
                <td>
                    <img src="<%=request.getContextPath()%>/showProfileImg?uid=<%= staff.getStaffId() %>"
                         alt="ProfileImage<%= staff.getStaffId() %>"
                         class="profile-img">
                </td>
                <td><%= staff.getStaffId() %></td>
                <td><%= staff.getStaffId() %></td>
                <td><%= staff.getAvailability_status() %></td>
                <td><%= staff.getLicense_number() %></td>
                <td>
                    <a href="editStaff.jsp?id=<%= staff.getStaffId() %>"
                       class="btn btn-sm btn-primary">Edit</a>

                    <a href="deleteStaff?id=<%= staff.getStaffId() %>"
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
            const email = row.cells[2]?.textContent.toLowerCase();
            const name = row.cells[3]?.textContent.toLowerCase();

            if (email.includes(filter) || name.includes(filter)) {
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
