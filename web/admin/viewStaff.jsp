<%@page import="com.myshop.srv.StaffImage"%>
<%@page import="com.myshop.service.impl.StaffServiceImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.myshop.beans.StaffBean"%>
<%@page session="true"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>View Staff - MyShop Admin</title>


    <!-- =====================================================
         BOOTSTRAP 5
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
        rel="stylesheet">
    
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/viewStaff.css"/>
</head>


<body>


<!-- =========================================================
     SESSION VALIDATION
     ========================================================= -->

<%
    String userName =
            (String) session.getAttribute("username");

    String userType =
            (String) session.getAttribute("role");


    if (userName == null ||
        userType == null ||
        !userType.equalsIgnoreCase("admin")) {

        response.sendRedirect(
            "login.jsp?error=access_denied"
        );

        return;
    }
%>



<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp" />



<!-- =========================================================
     MAIN CONTAINER
     ========================================================= -->

<div class="staff-container">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <div class="page-header">


        <div>

            <h2>

                <i class="fa-solid fa-users"></i>

                All Staff Members

            </h2>


            <p>

                Manage delivery staff accounts and availability.

            </p>

        </div>


        <div class="header-icon">

            <i class="fa-solid fa-user-group"></i>

        </div>


    </div>



<%
    /* =========================================================
       LOAD STAFF
       ========================================================= */

    List<StaffBean> staffList =
            new ArrayList<>();


    StaffServiceImpl sdao =
            new StaffServiceImpl();


    staffList =
            sdao.getAllStaffs();


    int staffCount =
            staffList != null
            ? staffList.size()
            : 0;
%>



    <!-- =====================================================
         SEARCH
         ===================================================== -->

    <div class="search-card">

        <div class="search-wrapper">

            <i class="fa-solid fa-magnifying-glass"></i>


            <input
                type="text"
                id="searchInput"
                class="form-control"
                placeholder="Search by staff ID, name, email or mobile..."
                autocomplete="on"
            >

        </div>

    </div>



    <!-- =====================================================
         SUMMARY
         ===================================================== -->

    <div class="staff-summary">

        <h3>
            <span style="color:#198754;">
                <i class="fa-solid fa-id-badge"></i>
                Staff Directory
            </span>

        </h3>


        <span class="staff-count">

            <i class="fa-solid fa-users"></i>

            <span id="staffCount">
                <%=staffCount%>
            </span>

            Staff

        </span>

    </div>



    <!-- =====================================================
         DESKTOP / TABLET TABLE
         ===================================================== -->

    <div class="table-card">

        <div class="table-responsive">

            <table
                class="table table-bordered table-striped align-middle text-center staff-table"
            >

                <thead>

                    <tr>

                        <th>
                            Profile
                        </th>

                        <th>
                            Staff ID
                        </th>

                        <th>
                            Email
                        </th>

                        <th>
                            Name
                        </th>

                        <th>
                            Mobile
                        </th>

                        <th>
                            Availability
                        </th>

                        <th>
                            License
                        </th>

                        <th>
                            Actions
                        </th>

                    </tr>

                </thead>


                <tbody id="staffTable">


<%
    if (staffList != null &&
        !staffList.isEmpty()) {


        for (StaffBean staff :
                staffList) {
%>


                    <tr
                        class="staff-row"
                        data-search="
                            <%=staff.getStaffId()%>
                            <%=staff.getName()%>
                            <%=staff.getEmail()%>
                            <%=staff.getMobile()%>
                            <%=staff.getAvailability_status()%>
                            <%=staff.getLicense_number()%>
                        "
                    >


                        <!-- PROFILE -->

                        <td>

                            <img
                                src="<%=request.getContextPath()%>/showProfileImg?uid=<%=staff.getStaffId()%>"
                                alt="Profile Image"
                                class="profile-img"

                                onerror="
                                    this.onerror=null;
                                    this.style.display='none';
                                    this.nextElementSibling.style.display='flex';
                                "
                            >


                            <div
                                class="profile-placeholder"
                                style="display:none;"
                            >

                                <i class="fa-solid fa-user"></i>

                            </div>

                        </td>



                        <!-- STAFF ID -->

                        <td>

                            <span class="staff-id">

                                <%=staff.getStaffId()%>

                            </span>

                        </td>



                        <!-- EMAIL -->

                        <td>

                            <span class="staff-email">

                                <%=staff.getEmail()%>

                            </span>

                        </td>



                        <!-- NAME -->

                        <td>

                            <span class="staff-name">

                                <%=staff.getName()%>

                            </span>

                        </td>



                        <!-- MOBILE -->

                        <td>

                            <span class="staff-mobile">

                                <%=staff.getMobile()%>

                            </span>

                        </td>



                        <!-- AVAILABILITY -->

                        <td>


<%
    String availability =
            staff.getAvailability_status();


    boolean available =
            availability != null &&
            (
                availability.equalsIgnoreCase("AVAILABLE")
                ||
                availability.equalsIgnoreCase("ONLINE")
                ||
                availability.equalsIgnoreCase("ACTIVE")
            );
%>


                            <span
                                class="availability-badge
                                <%=available ? "" : "unavailable"%>"
                            >

                                <i
                                    class="fa-solid
                                    <%=available
                                        ? "fa-circle-check"
                                        : "fa-circle-xmark"%>"
                                ></i>


                                <%=availability != null
                                    ? availability.replace(
                                        "_",
                                        " "
                                      )
                                    : "N/A"%>

                            </span>

                        </td>



                        <!-- LICENSE -->

                        <td>

                            <span class="license-number">

                                <%=staff.getLicense_number()%>

                            </span>

                        </td>



                        <!-- ACTIONS -->

                        <td>

                            <div class="action-buttons">


                                <button
                                    type="button"
                                    class="btn btn-primary btn-sm"
                                    onclick="openEditStaffModal(
                                        '<%=staff.getStaffId()%>',
                                        '<%=staff.getName()%>',
                                        '<%=staff.getEmail()%>',
                                        '<%=staff.getMobile()%>',
                                        '<%=staff.getAvailability_status()%>',
                                        '<%=staff.getLicense_number()%>'
                                    )"
                                >
                                    <i class="fa-solid fa-pen"></i>
                                    Edit
                                </button>


                                <a
                                    href="deleteStaff?id=<%=staff.getStaffId()%>"
                                    class="btn btn-danger btn-sm btn-action"

                                    onclick="
                                        return confirm(
                                            'Are you sure you want to delete this staff member?'
                                        );
                                    "
                                >

                                    <i class="fa-solid fa-trash"></i>

                                    Delete

                                </a>

                            </div>

                        </td>


                    </tr>


<%
        }

    }
%>


                    <!-- NO DATA -->

                    <tr
                        id="noDataRow"
                        style="display:none;"
                    >

                        <td colspan="8">

                            <i
                                class="fa-solid fa-user-slash no-data-icon"
                            ></i>

                            No staff found

                        </td>

                    </tr>


                </tbody>

            </table>

        </div>

    </div>



    <!-- =====================================================
         MOBILE STAFF CARDS
         ===================================================== -->

    <div
        class="mobile-staff-list"
        id="mobileStaffList"
    >


<%
    if (staffList != null &&
        !staffList.isEmpty()) {


        for (StaffBean staff :
                staffList) {


            String availability =
                    staff.getAvailability_status();


            boolean available =
                    availability != null &&
                    (
                        availability.equalsIgnoreCase("AVAILABLE")
                        ||
                        availability.equalsIgnoreCase("ONLINE")
                        ||
                        availability.equalsIgnoreCase("ACTIVE")
                    );
%>


        <div
            class="mobile-staff-card staff-mobile-row"

            data-search="
                <%=staff.getStaffId()%>
                <%=staff.getName()%>
                <%=staff.getEmail()%>
                <%=staff.getMobile()%>
                <%=staff.getAvailability_status()%>
                <%=staff.getLicense_number()%>
            "
        >


            <!-- TOP -->

            <div class="mobile-staff-top">


                <img
                    src="<%=request.getContextPath()%>/showProfileImg?uid=<%=staff.getStaffId()%>"
                    alt="Profile"
                    class="mobile-staff-image"

                    onerror="
                        this.onerror=null;
                        this.src='<%=request.getContextPath()%>/images/noimage.jpg';
                    "
                >


                <div class="mobile-staff-main">

                    <div class="mobile-staff-name">

                        <%=staff.getName()%>
                        STAFF

                    </div>


                    <div class="mobile-staff-id">

                        ID:
                        <%=staff.getStaffId()%>

                    </div>

                </div>


                <span
                    class="availability-badge
                    <%=available ? "" : "unavailable"%>"
                >

                    <i
                        class="fa-solid
                        <%=available
                            ? "fa-circle-check"
                            : "fa-circle-xmark"%>"
                    ></i>

                    <%=availability != null
                        ? availability.replace(
                            "_",
                            " "
                          )
                        : "N/A"%>

                </span>


            </div>



            <!-- INFORMATION -->

            <div class="mobile-info">


                <!-- EMAIL -->

                <div class="mobile-info-row">

                    <i class="fa-solid fa-envelope"></i>

                    <span>

                        <%=staff.getEmail()%>

                    </span>

                </div>


                <!-- MOBILE -->

                <div class="mobile-info-row">

                    <i class="fa-solid fa-phone"></i>

                    <span>

                       <%=staff.getMobile()%>

                    </span>

                </div>


                <!-- LICENSE -->

                <div class="mobile-info-row">

                    <i class="fa-solid fa-id-card"></i>

                    <span>

                        <%=staff.getLicense_number()%>

                    </span>

                </div>


            </div>



            <!-- ACTIONS -->

            <div class="mobile-actions">


                <button
                    type="button"
                    class="btn btn-primary btn-sm"
                    onclick="openEditStaffModal(
                        '<%=staff.getStaffId()%>',
                        '<%=staff.getName()%>',
                        '<%=staff.getEmail()%>',
                        '<%=staff.getMobile()%>',
                        '<%=staff.getAvailability_status()%>',
                        '<%=staff.getLicense_number()%>'
                    )"
                >
                    <i class="fa-solid fa-pen"></i>
                    Edit
                </button>


                <a
                    href="deleteStaff?id=<%=staff.getStaffId()%>"
                    class="btn btn-danger btn-sm"

                    onclick="
                        return confirm(
                            'Are you sure you want to delete this staff member?'
                        );
                    "
                >

                    <i class="fa-solid fa-trash"></i>

                    Delete

                </a>

            </div>


        </div>


<%
        }

    }
%>


        <!-- MOBILE NO DATA -->

        <div
            id="mobileNoData"
            class="empty-mobile"
            style="display:none;"
        >

            <div
                class="text-center"
                style="
                    background:white;
                    border-radius:12px;
                    padding:40px 15px;
                    color:#777;
                "
            >

                <i
                    class="fa-solid fa-user-slash"
                    style="
                        font-size:35px;
                        color:#bbb;
                        margin-bottom:12px;
                    "
                ></i>


                <div>

                    No staff found

                </div>

            </div>

        </div>


    </div>


</div>

<!-- =========================================================
     EDIT STAFF GLASSMORPHISM MODAL
     ========================================================= -->

<div
    class="modal fade"
    id="editStaffModal"
    tabindex="-1"
    aria-labelledby="editStaffModalLabel"
    aria-hidden="true"
>

    <div class="modal-dialog modal-dialog-centered modal-lg">

        <div class="modal-content glass-edit-modal">

            <!-- HEADER -->

            <div class="modal-header glass-modal-header">

                <div class="edit-modal-title">

                    <div class="edit-modal-icon">
                        <i class="fa-solid fa-user-pen"></i>
                    </div>

                    <div>

                        <h5
                            class="modal-title"
                            id="editStaffModalLabel"
                        >
                            Edit Staff Details
                        </h5>

                        <small>
                            Update staff account information
                        </small>

                    </div>

                </div>


                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal"
                    aria-label="Close"
                ></button>

            </div>


            <!-- FORM -->

            <form
                id="editStaffForm"
                method="post"
                action="<%=request.getContextPath()%>/UpdateStaff"
            >

                <div class="modal-body glass-modal-body">

                    <!-- STAFF ID -->

                    <div class="staff-id-display">

                        <div class="staff-id-icon">
                            <i class="fa-solid fa-id-badge"></i>
                        </div>

                        <div>

                            <small>
                                Staff ID
                            </small>

                            <strong id="modalStaffId">
                                -
                            </strong>

                        </div>

                    </div>


                    <div class="row g-3">


                        <!-- NAME -->

                        <div class="col-md-6">

                            <label
                                for="editName"
                                class="form-label"
                            >
                                <i class="fa-solid fa-user"></i>
                                Full Name
                            </label>

                            <input
                                type="text"
                                class="form-control glass-input"
                                id="editName"
                                name="name"
                                required
                            >

                        </div>


                        <!-- EMAIL -->

                        <div class="col-md-6">

                            <label
                                for="editEmail"
                                class="form-label"
                            >
                                <i class="fa-solid fa-envelope"></i>
                                Email
                            </label>

                            <input
                                type="email"
                                class="form-control glass-input"
                                id="editEmail"
                                name="email"
                                required
                            >

                        </div>


                        <!-- MOBILE -->

                        <div class="col-md-6">

                            <label
                                for="editMobile"
                                class="form-label"
                            >
                                <i class="fa-solid fa-phone"></i>
                                Mobile
                            </label>

                            <input
                                type="text"
                                class="form-control glass-input"
                                id="editMobile"
                                name="mobile"
                                maxlength="10"
                                required
                            >

                        </div>


                        <!-- AVAILABILITY -->

                        <div class="col-md-6">

                            <label
                                for="editAvailability"
                                class="form-label"
                            >
                                <i class="fa-solid fa-circle-check"></i>
                                Availability
                            </label>

                            <select
                                class="form-select glass-input"
                                id="editAvailability"
                                name="availability_status"
                                required
                            >

                                <option value="AVAILABLE">
                                    AVAILABLE
                                </option>

                                <option value="UNAVAILABLE">
                                    UNAVAILABLE
                                </option>

                                <option value="ONLINE">
                                    ONLINE
                                </option>

                                <option value="OFFLINE">
                                    OFFLINE
                                </option>

                                <option value="ACTIVE">
                                    ACTIVE
                                </option>

                                <option value="INACTIVE">
                                    INACTIVE
                                </option>

                            </select>

                        </div>


                        <!-- LICENSE -->

                        <div class="col-md-6">

                            <label
                                for="editLicense"
                                class="form-label"
                            >
                                <i class="fa-solid fa-id-card"></i>
                                License Number
                            </label>

                            <input
                                type="text"
                                class="form-control glass-input"
                                id="editLicense"
                                name="license_number"
                                required
                            >

                        </div>


                        <!-- STAFF ID HIDDEN -->

                        <input
                            type="hidden"
                            id="editStaffId"
                            name="staff_id"
                        >

                    </div>

                </div>


                <!-- FOOTER -->

                <div class="modal-footer glass-modal-footer">

                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                    >
                        <i class="fa-solid fa-xmark"></i>
                        Cancel
                    </button>


                    <button
                        type="submit"
                        class="btn btn-success save-staff-btn"
                    >
                        <i class="fa-solid fa-floppy-disk"></i>
                        Save Changes
                    </button>

                </div>

            </form>

        </div>

    </div>

</div>



<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js">
</script>



<!-- =========================================================
     SEARCH SCRIPT
     ========================================================= -->

<script>

document.addEventListener(
    "DOMContentLoaded",
    function() {


        const searchInput =
            document.getElementById(
                "searchInput"
            );


        const tableRows =
            document.querySelectorAll(
                ".staff-row"
            );


        const mobileRows =
            document.querySelectorAll(
                ".staff-mobile-row"
            );


        const noDataRow =
            document.getElementById(
                "noDataRow"
            );


        const mobileNoData =
            document.getElementById(
                "mobileNoData"
            );


        const staffCount =
            document.getElementById(
                "staffCount"
            );


        searchInput.addEventListener(
            "input",
            function() {


                const filter =
                    this.value
                        .trim()
                        .toLowerCase();


                let desktopVisible =
                    0;


                let mobileVisible =
                    0;


                /* =========================================
                   DESKTOP TABLE SEARCH
                   ========================================= */

                tableRows.forEach(
                    function(row) {


                        const text =
                            row
                                .getAttribute(
                                    "data-search"
                                )
                                .toLowerCase();


                        if (
                            text.includes(
                                filter
                            )
                        ) {

                            row.style.display =
                                "";

                            desktopVisible++;

                        } else {

                            row.style.display =
                                "none";
                        }

                    }
                );


                /* =========================================
                   MOBILE CARD SEARCH
                   ========================================= */

                mobileRows.forEach(
                    function(card) {


                        const text =
                            card
                                .getAttribute(
                                    "data-search"
                                )
                                .toLowerCase();


                        if (
                            text.includes(
                                filter
                            )
                        ) {

                            card.style.display =
                                "";

                            mobileVisible++;

                        } else {

                            card.style.display =
                                "none";
                        }

                    }
                );


                /* =========================================
                   NO DATA - DESKTOP
                   ========================================= */

                noDataRow.style.display =
                    desktopVisible === 0
                    ? ""
                    : "none";


                /* =========================================
                   NO DATA - MOBILE
                   ========================================= */

                mobileNoData.style.display =
                    mobileVisible === 0
                    ? "block"
                    : "none";


                /* =========================================
                   UPDATE COUNT
                   ========================================= */

                const visibleCount =
                    desktopVisible;


                staffCount.innerText =
                    visibleCount;

            }
        );

    }

);

function openEditStaffModal(
    staffId,
    name,
    email,
    mobile,
    availability,
    license
) {

    /* =========================================
       SET STAFF ID
       ========================================= */

    document.getElementById("editStaffId").value =
        staffId;

    document.getElementById("modalStaffId").innerText =
        staffId;


    /* =========================================
       SET FORM VALUES
       ========================================= */

    document.getElementById("editName").value =
        name;

    document.getElementById("editEmail").value =
        email;

    document.getElementById("editMobile").value =
        mobile;

    document.getElementById("editLicense").value =
        license;


    /* =========================================
       AVAILABILITY
       ========================================= */

    const availabilitySelect =
        document.getElementById(
            "editAvailability"
        );


    let availabilityFound = false;


    for (
        let i = 0;
        i < availabilitySelect.options.length;
        i++
    ) {

        if (
            availabilitySelect.options[i]
                .value
                .toUpperCase()
            ===
            String(availability)
                .toUpperCase()
        ) {

            availabilitySelect.selectedIndex =
                i;

            availabilityFound = true;

            break;
        }
    }


    if (!availabilityFound) {

        availabilitySelect.value =
            "AVAILABLE";

    }


    /* =========================================
       OPEN MODAL
       ========================================= */

    const modalElement =
        document.getElementById(
            "editStaffModal"
        );


    const modal =
        bootstrap.Modal.getOrCreateInstance(
            modalElement
        );


    modal.show();

}


</script>



<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html" />


</body>

</html>