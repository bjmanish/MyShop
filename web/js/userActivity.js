(function () {
    "use strict";

    /* =====================================================
       THEME SYNC
       ===================================================== */

    const root = document.documentElement;

    function syncTheme() {
        const stored = localStorage.getItem("myshop-theme");

        const isDark =
            stored === "dark" ||
            document.body.classList.contains("dark-mode") ||
            root.classList.contains("dark-mode") ||
            root.getAttribute("data-theme") === "dark";

        const theme = isDark ? "dark" : "light";

        root.setAttribute("data-theme", theme);
        root.setAttribute("data-activity-theme", theme);

        if (theme === "dark") {
            root.classList.add("dark-mode");
            document.body.classList.add("dark-mode");
            document.body.classList.remove("light-mode");
        } else {
            root.classList.remove("dark-mode");
            document.body.classList.remove("dark-mode");
            document.body.classList.add("light-mode");
        }
    }

    syncTheme();

    window.addEventListener("storage", function (event) {
        if (event.key === "myshop-theme") {
            syncTheme();
        }
    });

    new MutationObserver(syncTheme).observe(root, {
        attributes: true,
        attributeFilter: ["class", "data-theme"]
    });

    new MutationObserver(syncTheme).observe(document.body, {
        attributes: true,
        attributeFilter: ["class"]
    });


    /* =====================================================
       ELEMENTS
       ===================================================== */

    const searchInput =
        document.getElementById("searchInput");

    const roleFilter =
        document.getElementById("roleFilter");

    const statusFilter =
        document.getElementById("statusFilter");

    const clearFilters =
        document.getElementById("clearFilters");

    const rows =
        document.querySelectorAll(".activity-row");

    const visibleCount =
        document.getElementById("visibleCount");


    /* =====================================================
       FILTER
       ===================================================== */

    function filterActivity() {

        const search = searchInput
            ? searchInput.value.toLowerCase().trim()
            : "";

        const selectedRole = roleFilter
            ? roleFilter.value.toLowerCase()
            : "";

        const selectedStatus = statusFilter
            ? statusFilter.value.toLowerCase()
            : "";

        let count = 0;

        rows.forEach(function (row) {

            const user =
                (row.dataset.user || "").toLowerCase();

            const userId =
                (row.dataset.userid || "").toLowerCase();

            const role =
                (row.dataset.role || "").toLowerCase();

            const status =
                (row.dataset.status || "").toLowerCase();

            const ip =
                (row.dataset.ip || "").toLowerCase();

            const matchesSearch =
                search === "" ||
                user.includes(search) ||
                userId.includes(search) ||
                ip.includes(search);

            const matchesRole =
                selectedRole === "" ||
                role === selectedRole;

            const matchesStatus =
                selectedStatus === "" ||
                status === selectedStatus;

            const visible =
                matchesSearch &&
                matchesRole &&
                matchesStatus;

            row.style.display =
                visible ? "" : "none";

            if (visible) {
                count++;
            }
        });

        if (visibleCount) {
            visibleCount.textContent = count;
        }
    }


    /* =====================================================
       FILTER EVENTS
       ===================================================== */

    if (searchInput) {

        searchInput.addEventListener(
            "input",
            filterActivity
        );
    }


    if (roleFilter) {

        roleFilter.addEventListener(
            "change",
            filterActivity
        );
    }


    if (statusFilter) {

        statusFilter.addEventListener(
            "change",
            filterActivity
        );
    }


    if (clearFilters) {

        clearFilters.addEventListener(
            "click",
            function () {

                if (searchInput) {
                    searchInput.value = "";
                }

                if (roleFilter) {
                    roleFilter.value = "";
                }

                if (statusFilter) {
                    statusFilter.value = "";
                }

                filterActivity();
            }
        );
    }


    /* Initial filter */

    filterActivity();


    /* =====================================================
       FORCE LOGOUT MODAL
       No Bootstrap Modal API is used here.
       ===================================================== */

    let selectedLoginId = null;

    let selectedLogoutButton = null;


    const modal =
        document.getElementById(
            "forceLogoutModal"
        );


    const usernameElement =
        document.getElementById(
            "forceLogoutUsername"
        );


    const loginIdElement =
        document.getElementById(
            "forceLogoutLoginId"
        );


    const confirmButton =
        document.getElementById(
            "confirmForceLogout"
        );


    const closeButton =
        document.getElementById(
            "closeForceLogoutModal"
        );


    const cancelButton =
        document.getElementById(
            "cancelForceLogout"
        );


    /* =====================================================
       OPEN FORCE LOGOUT MODAL
       ===================================================== */

    function openForceLogoutModal(
        button,
        loginId,
        username
    ) {

        if (!modal) {

            console.error(
                "Force Logout modal #forceLogoutModal was not found."
            );

            return;
        }


        selectedLoginId =
            loginId;


        selectedLogoutButton =
            button;


        if (loginIdElement) {

            loginIdElement.value =
                loginId;
        }


        if (usernameElement) {

            usernameElement.textContent =
                username || "Unknown User";
        }


        /*
         * Open custom modal.
         * No Bootstrap modal required.
         */

        modal.classList.add(
            "show"
        );


        modal.setAttribute(
            "aria-hidden",
            "false"
        );


        /*
         * Prevent background scrolling.
         */

        document.body.classList.add(
            "force-modal-open"
        );


        document.body.style.overflow =
            "hidden";


        /*
         * Focus confirmation button.
         */

        setTimeout(
            function () {

                if (confirmButton) {

                    confirmButton.focus();
                }

            },
            50
        );
    }


    /* =====================================================
       CLOSE FORCE LOGOUT MODAL
       ===================================================== */

    function closeForceLogoutModal() {

        if (!modal) {

            return;
        }


        modal.classList.remove(
            "show"
        );


        modal.setAttribute(
            "aria-hidden",
            "true"
        );


        document.body.classList.remove(
            "force-modal-open"
        );


        document.body.style.overflow =
            "";


        selectedLoginId =
            null;


        selectedLogoutButton =
            null;
    }


    /* =====================================================
       FORCE LOGOUT TABLE BUTTONS
       ===================================================== */

    document.querySelectorAll(
        ".force-logout-btn"
    ).forEach(
        function (button) {

            button.addEventListener(
                "click",
                function () {

                    const loginId =
                        this.getAttribute(
                            "data-login-id"
                        );


                    /*
                     * Get username directly
                     * from the current table row.
                     */

                    const row =
                        this.closest(
                            ".activity-row"
                        );


                    let username =
                        "Unknown User";


                    if (row) {

                        const userElement =
                            row.querySelector(
                                ".user-details strong"
                            );


                        if (userElement) {

                            username =
                                userElement
                                    .textContent
                                    .trim();
                        }
                    }


                    openForceLogoutModal(
                        this,
                        loginId,
                        username
                    );

                }
            );

        }
    );


    /* =====================================================
       CLOSE BUTTON
       ===================================================== */

    if (closeButton) {

        closeButton.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                closeForceLogoutModal();

            }
        );
    }


    /* =====================================================
       CANCEL BUTTON
       ===================================================== */

    if (cancelButton) {

        cancelButton.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                closeForceLogoutModal();

            }
        );
    }


    /* =====================================================
       CLICK OUTSIDE MODAL
       ===================================================== */

    if (modal) {

        modal.addEventListener(
            "click",
            function (event) {

                if (
                    event.target === modal
                ) {

                    closeForceLogoutModal();

                }

            }
        );
    }


    /* =====================================================
       ESC KEY
       ===================================================== */

    document.addEventListener(
        "keydown",
        function (event) {

            if (
                event.key === "Escape" &&
                modal &&
                modal.classList.contains("show")
            ) {

                closeForceLogoutModal();

            }

        }
    );


    /* =====================================================
       CONFIRM FORCE LOGOUT
       ===================================================== */

    if (confirmButton) {

        confirmButton.addEventListener(
            "click",
            function () {

                if (!selectedLoginId) {

                    showNotification(
                        "error",
                        "Invalid Request",
                        "No active login session was selected."
                    );

                    return;
                }


                const button =
                    this;


                /*
                 * Disable button while
                 * request is running.
                 */

                button.disabled =
                    true;


                button.innerHTML =
                    '<i class="fa-solid fa-spinner fa-spin"></i> Processing...';


                /*
                 * Send Force Logout request.
                 */

                fetch(
                    "<%=request.getContextPath()%>/ForceLogoutSrv",
                    {
                        method: "POST",

                        headers: {
                            "Content-Type":
                                "application/x-www-form-urlencoded"
                        },

                        body:
                            "loginId=" +
                            encodeURIComponent(
                                selectedLoginId
                            )
                    }
                )

                .then(
                    function (response) {

                        if (!response.ok) {

                            throw new Error(
                                "HTTP " +
                                response.status
                            );
                        }


                        return response.json();

                    }
                )

                .then(
                    function (data) {

                        console.log(
                            "Force Logout response:",
                            data
                        );


                        if (data.success) {

                            /*
                             * Keep reference to
                             * table button before
                             * closing modal.
                             */

                            const logoutButton =
                                selectedLogoutButton;


                            /*
                             * Close modal.
                             */

                            closeForceLogoutModal();


                            /*
                             * Update table button.
                             */

                            if (
                                logoutButton
                            ) {

                                logoutButton.classList.add(
                                    "force-logout-success"
                                );


                                logoutButton.innerHTML =
                                    '<i class="fa-solid fa-circle-check"></i> Logged Out';


                                logoutButton.disabled =
                                    true;
                            }


                            /*
                             * Show success notification.
                             */

                            showNotification(
                                "success",
                                "Force Logout Successful",
                                data.message ||
                                "User has been force logged out."
                            );


                            /*
                             * Refresh page.
                             */

                            setTimeout(
                                function () {

                                    window.location.reload();

                                },
                                1200
                            );


                        } else {

                            showNotification(
                                "error",
                                "Force Logout Failed",
                                data.message ||
                                "Unable to force logout user."
                            );

                        }

                    }
                )

                .catch(
                    function (error) {

                        console.error(
                            "Force Logout Error:",
                            error
                        );


                        showNotification(
                            "error",
                            "Server Error",
                            "Unable to connect to the Force Logout service."
                        );

                    }
                )

                .finally(
                    function () {

                        button.disabled =
                            false;


                        button.innerHTML =
                            '<i class="fa-solid fa-power-off"></i> Logout';

                    }
                );

            }
        );
    }


    /* =====================================================
       NOTIFICATION
       ===================================================== */

    let notificationTimer =
        null;


    function showNotification(
        type,
        title,
        message
    ) {

        const notification =
            document.getElementById(
                "activityNotification"
            );


        const icon =
            document.getElementById(
                "notificationIcon"
            );


        const titleElement =
            document.getElementById(
                "notificationTitle"
            );


        const messageElement =
            document.getElementById(
                "notificationMessage"
            );


        if (!notification) {

            return;
        }


        /*
         * Remove previous notification state.
         */

        notification.classList.remove(
            "success",
            "error",
            "notification-success",
            "notification-error"
        );


        if (
            type === "success"
        ) {

            notification.classList.add(
                "success"
            );


            if (icon) {

                icon.className =
                    "fa-solid fa-circle-check";
            }

        } else {

            notification.classList.add(
                "error"
            );


            if (icon) {

                icon.className =
                    "fa-solid fa-circle-exclamation";
            }
        }


        if (titleElement) {

            titleElement.textContent =
                title;
        }


        if (messageElement) {

            messageElement.textContent =
                message;
        }


        notification.classList.add(
            "show"
        );


        clearTimeout(
            notificationTimer
        );


        notificationTimer =
            setTimeout(
                hideNotification,
                5000
            );
    }


    /* =====================================================
       HIDE NOTIFICATION
       ===================================================== */

    window.hideNotification =
        function () {

            const notification =
                document.getElementById(
                    "activityNotification"
                );


            if (notification) {

                notification.classList.remove(
                    "show"
                );
            }
        };


    /* =====================================================
       AUTO REFRESH
       ===================================================== */

//    setTimeout(
//        function () {
//
//            /*
//             * Don't refresh while
//             * modal is open.
//             */
//
//            if (
//                modal &&
//                modal.classList.contains(
//                    "show"
//                )
//            ) {
//
//                return;
//            }
//
//
//            window.location.reload();
//
//        },
//        3000
//    );


    /* =====================================================
       DEBUG
       ===================================================== */

    console.log(
        "MyShop User Activity loaded successfully."
    );

})();