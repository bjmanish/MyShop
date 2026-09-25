<%@ page import="java.util.*,com.myshop.beans.ProductBean" %>

<%
    /* =========================================================
       SESSION VALIDATION
       ========================================================= */

    String userName = (String) session.getAttribute("username");
    String sId = (String) session.getAttribute("sessionId");
    String userType = (String) session.getAttribute("role");

    if (userType == null ||
        !userType.equalsIgnoreCase("admin")) {

        response.sendRedirect(
            "login.jsp?message=Access Denied, Please Login as an admin!"
        );

        return;
    }

    if (userName == null || sId == null) {

        response.sendRedirect(
            "login.jsp?message=Access Denied, Session Expired! Please Login again."
        );

        return;
    }


    /* =========================================================
       PRODUCT DATA FROM FetchProductSrv
       ========================================================= */

    List<ProductBean> products =
            (List<ProductBean>) request.getAttribute("products");

    List<String> images =
            (List<String>) request.getAttribute("image");


    /* =========================================================
       STATUS / ERROR MESSAGE
       ========================================================= */

    String importStatus =
            (String) request.getAttribute("importStatus");

    String apiError =
            (String) request.getAttribute("apiError");

    String message =
            request.getParameter("message");

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Add Product - MyShop Admin</title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


    <style>

        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            padding: 0;

            /*width: 100%;*/

            min-width: 320px;

            overflow-x: hidden;
        }

        body {

            background: #f4f7fb;

            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            color: #333;
        }


        /* =====================================================
           MAIN CONTAINER
           ===================================================== */

        .page-container {

            width: 100%;

            max-width: 1200px;

            margin: 70px auto;

            padding:
                25px
                15px
                50px;
        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .page-header-custom {

            background:
                linear-gradient(
                    135deg,
                    #198754,
                    #28a745
                );

            color: white;

            border-radius: 12px;

            padding:
                25px
                30px;

            margin-bottom: 25px;

            box-shadow:
                0 5px 18px
                rgba(0, 0, 0, 0.10);
        }


        .page-header-custom h1 {

            margin:
                0
                0
                8px;

            font-size: 30px;

            font-weight: 600;
        }


        .page-header-custom p {

            margin: 0;

            font-size: 15px;

            opacity: 0.9;
        }


        /* =====================================================
           IMPORT CARD
           ===================================================== */

        .import-card {

            background: #fff;

            border-radius: 12px;

            padding: 25px;

            margin-bottom: 25px;

            box-shadow:
                0 3px 15px
                rgba(0, 0, 0, 0.07);

            text-align: center;
        }


        .import-card h3 {

            margin-top: 0;

            font-size: 21px;

            font-weight: 600;
        }


        .import-card p {

            color: #777;

            margin-bottom: 18px;
        }


        .btn-import {

            background: #337ab7;

            color: white;

            border: none;

            padding:
                11px
                22px;

            border-radius: 6px;

            font-size: 15px;

            transition:
                all 0.2s ease;
        }


        .btn-import:hover {

            background: #286090;

            color: white;

            transform:
                translateY(-1px);
        }


        /* =====================================================
           STATUS MESSAGE
           ===================================================== */

        .status-message {

            padding:
                12px
                15px;

            border-radius: 6px;

            margin-bottom: 20px;

            background: #dff0d8;

            border:
                1px solid
                #d6e9c6;

            color: #3c763d;

            text-align: center;
        }


        .error-message {

            padding:
                10px
                15px;

            border-radius: 6px;

            margin-bottom: 20px;

            background: #f2dede;

            border:
                1px solid
                #ebccd1;

            color: #a94442;

            text-align: center;
        }


        /* =====================================================
           TWO COLUMN CONTENT
           ===================================================== */

        .content-row {

            display: flex;

            gap: 25px;

            align-items: flex-start;

            width: 100%;
        }


        .form-section {

            flex:
                0 0 48%;

            min-width: 0;
        }


        .info-section {

            flex: 1;

            min-width: 0;
        }


        /* =====================================================
           CARD
           ===================================================== */

        .card {

            background: #fff;

            border-radius: 12px;

            padding: 25px;

            box-shadow:
                0 3px 15px
                rgba(0, 0, 0, 0.07);

            width: 100%;
        }


        .card-title {

            margin:
                0
                0
                5px;

            font-size: 22px;

            font-weight: 600;

            color: #222;
        }


        .card-subtitle {

            color: #777;

            margin-bottom: 25px;

            font-size: 14px;
        }


        /* =====================================================
           FORM
           ===================================================== */

        .form-group-custom {

            margin-bottom: 18px;
        }


        .form-group-custom label {

            display: block;

            margin-bottom: 7px;

            font-weight: 600;

            font-size: 14px;

            color: #444;
        }


        .form-control {

            width: 100%;

            height: 44px;

            border-radius: 6px;

            border:
                1px solid
                #d7dce2;

            box-shadow: none;

            padding:
                10px
                13px;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }


        .form-control:focus {

            border-color: #28a745;

            box-shadow:
                0 0 0 2px
                rgba(40, 167, 69, 0.12);
        }


        textarea.form-control {

            height: 100px;

            resize: vertical;

            min-height: 100px;
        }


        input[type="file"].form-control {

            height: auto;

            padding:
                9px
                10px;
        }


        /* =====================================================
           IMAGE PREVIEW
           ===================================================== */

        .image-preview-container {

            display: none;

            margin-top: 15px;

            padding: 15px;

            border:
                1px dashed
                #ccc;

            border-radius: 8px;

            text-align: center;

            background: #fafafa;
        }


        .image-preview-container span {

            display: block;

            font-size: 13px;

            color: #777;

            margin-bottom: 10px;
        }


        .product-preview {

            width: 150px;

            height: 150px;

            max-width: 100%;

            object-fit: contain;

            border-radius: 8px;

            border:
                1px solid
                #ddd;

            background: white;
        }


        /* =====================================================
           ADD BUTTON
           ===================================================== */

        .btn-add {

            width: 100%;

            padding: 12px;

            border: none;

            border-radius: 6px;

            background: #28a745;

            color: white;

            font-size: 16px;

            font-weight: 600;

            transition:
                all 0.2s ease;
        }


        .btn-add:hover {

            background: #218838;

            color: white;

            transform:
                translateY(-1px);
        }


        /* =====================================================
           PRODUCTS HEADER
           ===================================================== */

        .products-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;

            margin-bottom: 18px;
        }


        .products-header h3 {

            margin: 0;

            font-size: 22px;

            font-weight: 600;

            color: green;
        }


        .product-count {

            background: #e8f5e9;

            color: #218838;

            border-radius: 20px;

            padding:
                6px
                12px;

            font-size: 13px;

            font-weight: 600;

            white-space: nowrap;
        }


        /* =====================================================
           PRODUCT GRID
           ===================================================== */

        .product-grid {

            display: grid;

            grid-template-columns:
                repeat(
                    2,
                    minmax(0, 1fr)
                );

            gap: 18px;

            width: 100%;
        }


        /* =====================================================
           PRODUCT CARD
           ===================================================== */

        .product-card {

            background: white;

            border:
                1px solid
                #e5e8eb;

            border-radius: 12px;

            overflow: hidden;

            transition:
                all 0.25s ease;

            height: 100%;

            min-width: 0;

            display: flex;

            flex-direction: column;
        }


        .product-card:hover {

            transform:
                translateY(-4px);

            box-shadow:
                0 8px 20px
                rgba(0, 0, 0, 0.10);
        }


        /* =====================================================
           PRODUCT IMAGE
           ===================================================== */

        .product-image-box {

            width: 100%;

            height: 190px;

            background: #f8f9fa;

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 15px;

            overflow: hidden;
        }


        .product-image {

            display: block;

            width: 100%;

            height: 100%;

            max-width: 100%;

            max-height: 160px;

            object-fit: contain;

            transition:
                transform 0.3s ease;
        }


        .product-card:hover
        .product-image {

            transform:
                scale(1.04);
        }


        /* =====================================================
           PRODUCT DETAILS
           ===================================================== */

        .product-details {

            padding: 15px;

            display: flex;

            flex-direction: column;

            flex: 1;
        }


        .product-name {

            font-size: 16px;

            font-weight: 600;

            line-height: 1.4;

            margin:
                0
                0
                10px;

            color: #222;

            display: -webkit-box;

            -webkit-line-clamp: 2;

            -webkit-box-orient: vertical;

            overflow: hidden;

            min-height: 45px;

            word-break: break-word;
        }


        /* =====================================================
           PRICE
           ===================================================== */

        .product-price {

            color: #198754;

            font-size: 18px;

            font-weight: 700;

            margin-bottom: 10px;
        }


        /* =====================================================
           CATEGORY
           ===================================================== */

        .product-category {

            display: inline-block;

            background: #f0f2f5;

            color: #666;

            padding:
                5px
                9px;

            border-radius: 15px;

            font-size: 12px;

            max-width: 100%;

            overflow: hidden;

            text-overflow: ellipsis;

            white-space: nowrap;

            align-self: flex-start;
        }


        /* =====================================================
           EMPTY STATE
           ===================================================== */

        .empty-state {

            text-align: center;

            padding:
                45px
                20px;

            background: #fff;

            border-radius: 12px;

            color: #777;

            box-shadow:
                0 3px 15px
                rgba(0, 0, 0, 0.05);
        }


        .empty-state i {

            font-size: 45px;

            color: #bbb;

            margin-bottom: 15px;
        }


        .empty-state h3 {

            margin-top: 10px;
        }


        /* =====================================================
           RESPONSIVE TABLET
           ===================================================== */

        @media (max-width: 991px) {

            .content-row {

                flex-direction: column;

                gap: 20px;
            }


            .form-section,
            .info-section {

                width: 100%;

                flex: none;
            }


            .product-grid {

                grid-template-columns:
                    repeat(
                        2,
                        minmax(0, 1fr)
                    );

                gap: 14px;
            }


            .product-image-box {

                height: 175px;
            }


            .product-image {

                max-height: 145px;
            }
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 600px) {

            .page-container {

                padding:
                    15px
                    10px
                    35px;
            }


            .page-header-custom {

                padding: 20px;

                border-radius: 9px;

                margin-bottom: 15px;
            }


            .page-header-custom h1 {

                font-size: 24px;

                line-height: 1.3;
            }


            .page-header-custom p {

                font-size: 13px;

                line-height: 1.5;
            }


            .import-card {

                padding: 18px;

                border-radius: 9px;

                margin-bottom: 15px;
            }


            .import-card h3 {

                font-size: 19px;
            }


            .import-card p {

                font-size: 13px;

                line-height: 1.5;
            }


            .btn-import {

                width: 100%;

                font-size: 14px;

                padding:
                    11px
                    15px;
            }


            .card {

                padding: 18px;

                border-radius: 9px;
            }


            .card-title {

                font-size: 20px;
            }


            .card-subtitle {

                margin-bottom: 20px;
            }


            .form-control {

                height: 43px;

                font-size: 14px;
            }


            textarea.form-control {

                height: 110px;
            }


            /* One product per row */

            .product-grid {

                grid-template-columns: 1fr;

                gap: 15px;
            }


            .products-header {

                align-items: flex-start;

                margin-bottom: 14px;
            }


            .products-header h3 {

                font-size: 19px;

                line-height: 1.4;
            }


            .product-count {

                font-size: 11px;

                padding:
                    5px
                    9px;
            }


            .product-image-box {

                height: 210px;
            }


            .product-image {

                max-height: 180px;
            }


            .product-details {

                padding: 13px;
            }


            .product-name {

                font-size: 15px;

                min-height: 42px;
            }


            .product-price {

                font-size: 17px;
            }


            .product-category {

                font-size: 11px;
            }


            .product-preview {

                width: 130px;

                height: 130px;
            }
        }


        /* =====================================================
           SMALL MOBILE
           ===================================================== */

        @media (max-width: 380px) {

            .page-container {

                padding:
                    10px
                    7px
                    25px;
            }


            .page-header-custom {

                padding: 16px;
            }


            .page-header-custom h1 {

                font-size: 21px;
            }


            .page-header-custom p {

                font-size: 12px;
            }


            .import-card,
            .card {

                padding: 14px;
            }


            .card-title {

                font-size: 19px;
            }


            .form-group-custom label {

                font-size: 13px;
            }


            .product-image-box {

                height: 180px;
            }


            .product-image {

                max-height: 150px;
            }


            .product-details {

                padding: 11px;
            }


            .product-name {

                font-size: 14px;

                min-height: 40px;
            }


            .product-price {

                font-size: 16px;
            }


            .product-category {

                font-size: 10px;

                padding:
                    4px
                    8px;
            }


            .btn-add {

                font-size: 14px;

                padding: 11px;
            }
        }


        /* =====================================================
           VERY SMALL SCREEN
           ===================================================== */

        @media (max-width: 320px) {

            .page-container {

                padding-left: 5px;

                padding-right: 5px;
            }


            .card,
            .import-card {

                padding: 12px;
            }


            .product-image-box {

                height: 160px;
            }


            .product-image {

                max-height: 135px;
            }
        }

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"></jsp:include>


<div class="page-container">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <div class="page-header-custom">

        <h1>

            <i class="fa fa-cube"></i>

            Product Management

        </h1>


        <p>

            Add products manually or import products from the API.

        </p>

    </div>



    <!-- =====================================================
         IMPORT PRODUCTS
         ===================================================== -->

    <div class="import-card">

        <h3 class="text-black">

            <i class="fa fa-cloud-download"></i>

            Import Products

        </h3>


        <p>

            Import products directly from the external product API.

        </p>


        <form
            action="<%=request.getContextPath()%>/FetchProductSrv?page=1"
            method="get"
        >

            <button
                type="submit"
                class="btn btn-import"
            >

                <i class="fa fa-download"></i>

                &nbsp;

                Import Products from API

            </button>

        </form>

    </div>



    <!-- =====================================================
         API SUCCESS MESSAGE
         ===================================================== -->

    <% if (importStatus != null &&
           !importStatus.trim().isEmpty()) { %>

        <div class="status-message">

            <i class="fa fa-check-circle"></i>

            &nbsp;

            <%=importStatus%>

        </div>

    <% } %>



    <!-- =====================================================
         API ERROR
         ===================================================== -->

    <% if (apiError != null &&
           !apiError.trim().isEmpty()) { %>

        <div class="error-message">

            <i class="fa fa-exclamation-circle"></i>

            &nbsp;

            <%=apiError%>

        </div>

    <% } %>



    <!-- =====================================================
         CONTENT
         ===================================================== -->

    <div class="content-row">


        <!-- =================================================
             MANUAL ADD PRODUCT
             ================================================= -->

        <div class="form-section">

            <div class="card">


                <h2 class="card-title">

                    <i class="fa fa-plus-circle"></i>

                    Add Product

                </h2>


                <p class="card-subtitle">

                    Enter the product details below.

                </p>



                <!-- =========================================
                     FORM MESSAGE
                     ========================================= -->

                <% if (message != null &&
                       !message.trim().isEmpty()) { %>

                    <div class="error-message">

                        <i class="fa fa-exclamation-circle"></i>

                        &nbsp;

                        <%=message%>

                    </div>

                <% } %>



                <!-- =========================================
                     ADD PRODUCT FORM
                     ========================================= -->

                <form
                    action="<%=request.getContextPath()%>/AddProductSrv"
                    method="post"
                    enctype="multipart/form-data"
                >


                    <!-- PRODUCT NAME -->

                    <div class="form-group-custom">

                        <label for="productName">

                            Product Name

                        </label>


                        <input
                            type="text"
                            id="productName"
                            name="productName"
                            placeholder="Enter product name"
                            class="form-control"
                            required
                        >

                    </div>



                    <!-- PRODUCT PRICE -->

                    <div class="form-group-custom">

                        <label for="productPrice">

                            Product Price

                        </label>


                        <input
                            type="number"
                            id="productPrice"
                            name="productPrice"
                            placeholder="Enter price"
                            min="0"
                            step="0.01"
                            class="form-control"
                            required
                        >

                    </div>



                    <!-- PRODUCT QUANTITY -->

                    <div class="form-group-custom">

                        <label for="productQuantity">

                            Quantity

                        </label>


                        <input
                            type="number"
                            id="productQuantity"
                            name="productQuantity"
                            placeholder="Enter quantity"
                            min="0"
                            class="form-control"
                            required
                        >

                    </div>



                    <!-- PRODUCT CATEGORY -->

                    <div class="form-group-custom">

                        <label for="productCategory">

                            Category

                        </label>


                        <input
                            type="text"
                            id="productCategory"
                            name="productCategory"
                            placeholder="Enter product category"
                            class="form-control"
                            required
                        >

                    </div>



                    <!-- PRODUCT DESCRIPTION -->

                    <div class="form-group-custom">

                        <label for="productDescription">

                            Description

                        </label>


                        <textarea
                            id="productDescription"
                            name="productDescription"
                            class="form-control"
                            placeholder="Enter product description"
                        ></textarea>

                    </div>



                    <!-- PRODUCT IMAGE -->

                    <div class="form-group-custom">

                        <label for="productImage">

                            Product Image

                        </label>


                        <input
                            type="file"
                            id="productImage"
                            name="productImage"
                            accept="image/*"
                            onchange="previewProduct(event)"
                            class="form-control"
                        >

                    </div>



                    <!-- IMAGE PREVIEW -->

                    <div
                        class="image-preview-container"
                        id="previewContainer"
                    >

                        <span>

                            Image Preview

                        </span>


                        <img
                            src=""
                            alt="Product Preview"
                            class="product-preview"
                            id="productPreview"
                        >

                    </div>


                    <br>


                    <!-- ADD BUTTON -->

                    <button
                        type="submit"
                        class="btn-add"
                    >

                        <i class="fa fa-plus"></i>

                        &nbsp;

                        Add Product

                    </button>

                </form>

            </div>

        </div>



        <!-- =================================================
             IMPORTED PRODUCTS
             ================================================= -->

        <div class="info-section">


            <% if (products != null &&
                   !products.isEmpty()) { %>


                <!-- PRODUCTS HEADER -->

                <div class="products-header">

                    <h3>

                        <i class="fa fa-shopping-bag"></i>

                        Imported Products

                    </h3>


                    <span class="product-count">

                        <%=products.size()%>

                        Products

                    </span>

                </div>



                <!-- =========================================
                     PRODUCT GRID
                     ========================================= -->

                <div class="product-grid">


                    <% for (int i = 0;
                            i < products.size();
                            i++) {


                        ProductBean product =
                                products.get(i);


                        String imageUrl = "";


                        /*
                         * Match image with product
                         */

                        if (images != null &&
                            i < images.size() &&
                            images.get(i) != null) {

                            imageUrl =
                                    images.get(i);
                        }

                    %>


                        <!-- =================================
                             PRODUCT CARD
                             ================================= -->

                        <div class="product-card">


                            <!-- PRODUCT IMAGE -->

                            <div class="product-image-box">


                                <% if (!imageUrl.isEmpty()) { %>


                                    <img
                                        src="<%=imageUrl%>"
                                        alt="<%=product.getProdName()%>"
                                        class="product-image"
                                        loading="lazy"

                                        onerror="
                                            this.onerror=null;
                                            this.src='<%=request.getContextPath()%>/images/noimage.jpg';
                                        "
                                    >


                                <% } else { %>


                                    <img
                                        src="<%=request.getContextPath()%>/images/noimage.jpg"
                                        alt="No Image"
                                        class="product-image"
                                    >


                                <% } %>


                            </div>



                            <!-- PRODUCT DETAILS -->

                            <div class="product-details">


                                <!-- PRODUCT NAME -->

                                <h4
                                    class="product-name"
                                    title="<%=product.getProdName()%>"
                                >

                                    <%=product.getProdName()%>

                                </h4>



                                <!-- PRICE -->

                                <div class="product-price">

                                    &#8377; <%=product.getProdPrice()%>

                                </div>



                                <!-- CATEGORY -->

                                <span
                                    class="product-category"
                                    title="<%=product.getProdType()%>"
                                >

                                    <%=product.getProdType()%>

                                </span>


                            </div>


                        </div>


                    <% } %>


                </div>



                <!-- =========================================
                     PAGINATION
                     ========================================= -->

                <%
                    Integer currentPage =
                            (Integer) request.getAttribute(
                                    "currentPage"
                            );

                    Integer totalPages =
                            (Integer) request.getAttribute(
                                    "totalPages"
                            );

                    String searchValue =
                            (String) request.getAttribute(
                                    "search"
                            );

                    String categoryValue =
                            (String) request.getAttribute(
                                    "category"
                            );


                    if (currentPage == null) {
                        currentPage = 1;
                    }

                    if (totalPages == null) {
                        totalPages = 1;
                    }

                    if (searchValue == null) {
                        searchValue = "";
                    }

                    if (categoryValue == null) {
                        categoryValue = "";
                    }
                %>


                <% if (totalPages > 1) { %>


                    <nav
                        aria-label="Product pagination"
                        style="text-align:center;margin-top:25px; font-size: 20px;"
                    >

                        <ul class="pagination">


                            <!-- PREVIOUS -->

                            <% if (currentPage > 1) { %>

                                <li>

                                    <a
                                        href="<%=request.getContextPath()%>/FetchProductSrv?page=<%=currentPage%>&search=<%=java.net.URLEncoder.encode(searchValue, "UTF-8")%>&category=<%=java.net.URLEncoder.encode(categoryValue, "UTF-8")%>"
                                        aria-label="Previous"
                                    >

                                        <span aria-hidden="true">
                                            &laquo;
                                        </span>

                                    </a>

                                </li>

                            <% } else { %>

                                <li class="disabled">

                                    <span>
                                        &laquo;
                                    </span>

                                </li>

                            <% } %>



                            <!-- PAGE NUMBERS -->

                            <%
                                for (int p = 1;
                                     p <= totalPages;
                                     p++) {
                            %>

                                <li class="<%=p == currentPage ? "active" : ""%>">

                                    <a
                                        href="<%=request.getContextPath()%>/FetchProductSrv?page=<%=p%>&search=<%=java.net.URLEncoder.encode(searchValue, "UTF-8")%>&category=<%=java.net.URLEncoder.encode(categoryValue, "UTF-8")%>"
                                    >

                                        <%=p%>

                                    </a>

                                </li>

                            <% } %>



                            <!-- NEXT -->

                            <% if (currentPage < totalPages) { %>

                                <li>

                                    <a
                                        href="<%=request.getContextPath()%>/FetchProductSrv?page=<%=currentPage + 1%>&search=<%=java.net.URLEncoder.encode(searchValue, "UTF-8")%>&category=<%=java.net.URLEncoder.encode(categoryValue, "UTF-8")%>"
                                        aria-label="Next"
                                    >

                                        <span aria-hidden="true">
                                            &raquo;
                                        </span>

                                    </a>

                                </li>

                            <% } else { %>

                                <li class="disabled">

                                    <span>
                                        &raquo;
                                    </span>

                                </li>

                            <% } %>


                        </ul>

                    </nav>


                <% } %>


            <% } else { %>


                <!-- =========================================
                     EMPTY STATE
                     ========================================= -->

                <div class="empty-state">


                    <i class="fa fa-cubes"></i>


                    <h3>

                        No Imported Products

                    </h3>


                    <p>

                        Click
                        <strong>
                            "Import Products from API"
                        </strong>
                        to load products.

                    </p>


                </div>


            <% } %>


        </div>


    </div>

</div>



<!-- =========================================================
     IMAGE PREVIEW JAVASCRIPT
     ========================================================= -->

<script>

function previewProduct(event) {

    const file =
        event.target.files[0];


    const preview =
        document.getElementById(
            "productPreview"
        );


    const container =
        document.getElementById(
            "previewContainer"
        );


    if (!file) {

        preview.src = "";

        container.style.display =
            "none";

        return;
    }


    /* =========================================
       CHECK FILE TYPE
       ========================================= */

    if (!file.type.startsWith("image/")) {

        alert(
            "Please select a valid image file."
        );


        event.target.value = "";

        preview.src = "";

        container.style.display =
            "none";

        return;
    }


    /* =========================================
       CHECK FILE SIZE
       Maximum 5 MB
       ========================================= */

    const maxSize =
        5 * 1024 * 1024;


    if (file.size > maxSize) {

        alert(
            "Image size must be less than 5 MB."
        );


        event.target.value = "";

        preview.src = "";

        container.style.display =
            "none";

        return;
    }


    /* =========================================
       IMAGE PREVIEW
       ========================================= */

    const reader =
        new FileReader();


    reader.onload =
        function(e) {

            preview.src =
                e.target.result;

            container.style.display =
                "block";
        };


    reader.readAsDataURL(file);

}

</script>



<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html" />


</body>

</html>
