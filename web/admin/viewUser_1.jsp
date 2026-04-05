<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<title>Manage Users</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#111; color:white; }
.table { background:white; color:black; }
.loader { display:none; text-align:center; }
</style>
</head>

<body>

<jsp:include page="/header.jsp"/>

<div class="container mt-4">

<h3>Manage Users</h3>

<select id="roleFilter" class="form-control w-25 mb-3" onchange="loadUsers()">
    <option value="">All</option>
    <option value="ADMIN">Admin</option>
    <option value="DELIVERY">Delivery</option>
    <option value="CUSTOMER">Customer</option>
</select>

<div id="loader" class="loader">
    <div class="spinner-border text-light"></div>
</div>

<table class="table table-bordered text-center">
<thead>
<tr>
<th>ID</th>
<th>Name</th>
<th>Email</th>
<th>Mobile</th>
<th>Role</th>
<th>Vehicle</th>
<th>Status</th>
<th>Action</th>
</tr>
</thead>

<tbody id="userTable"></tbody>

</table>
</div>

<script>

/* LOAD USERS */
function loadUsers(){

document.getElementById("loader").style.display = "block";

fetch("<%=request.getContextPath()%>/AdminSrv")
.then(res => {
    if(!res.ok) throw new Error("Failed to fetch users");
    return res.json();
})
.then(data => {

    console.log("Users Data:", data);

    let role = document.getElementById("roleFilter").value;
    let html = "";

    if(!data || data.length === 0){
        html = `<tr><td colspan="8">No Users Found</td></tr>`;
    } else {

        data.forEach(u => {
                
            console.log("User:", u); // 🔍 debug
            console.log("user Id: ",u.userId);
            console.log(typeof u.userId, u.userId);
            // ✅ FIXED FILTER
            if(role && u.roleName !== role) return;
          
            html += `
            <tr>
            <td>${u.userId || '-'}</td>
            <td>${u.name || '-'}</td>
            <td>${u.email || '-'}</td>
            <td>${u.mobile || '-'}</td>
            <td>${u.roleName || '-'}</td>
            <td>${u.vehicleType || u.vehivle_type || '-'}</td>
            <td>${u.status != 'Active' ? u.status : 'Disabled'}</td>
            <td>
                <button onclick="toggleStatus('${u.userId}')" class="btn btn-warning btn-sm">
                    Toggle
                </button>
                <button onclick="deleteUser('${u.userId}')" class="btn btn-danger btn-sm">
                    Delete
                </button>
            </td>
            </tr>`;
        });

        if(html === ""){
            html = `<tr><td colspan="8">No Users for selected role</td></tr>`;
        }
    }
    console.log("HTML DATA:",html)
    document.getElementById("userTable").innerHTML = html;
})
.catch(err => {
    console.error(err);
    document.getElementById("userTable").innerHTML =
        `<tr><td colspan="8">Error loading users</td></tr>`;
})
.finally(()=>{
    document.getElementById("loader").style.display = "none";
});
}
/* TOGGLE STATUS */
function toggleStatus(id){

fetch("<%=request.getContextPath()%>/ToggleUserSrv?id=" + id)
.then(res => res.text())
.then(msg => {
    console.log("Toggle:", msg);
    loadUsers();
})
.catch(err => console.error(err));
}

/* DELETE USER */
function deleteUser(id){

if(confirm("Delete user?")){
    fetch("<%=request.getContextPath()%>/DeleteUserSrv?id=" + id)
    .then(res => res.text())
    .then(msg => {
        console.log("Delete:", msg);
        loadUsers();
    })
    .catch(err => console.error(err));
}
}

/* INITIAL LOAD */
window.onload = loadUsers;

</script>

</body>
</html>