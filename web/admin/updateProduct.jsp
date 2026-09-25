<%@page import="com.myshop.service.impl.ProductServiceImpl"%>
<%@page import="com.myshop.beans.ProductBean"%>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    /* =========================================================
       GET PRODUCT
       ========================================================= */

    String prodid = request.getParameter("pid");

    if (prodid == null || prodid.trim().isEmpty()) {

        response.sendRedirect(
            "updateProductById.jsp?message=Invalid Product"
        );

        return;
    }

    ProductBean product =
        new ProductServiceImpl().getProductDetails(prodid);


    if (product == null) {

        response.sendRedirect(
            "updateProductById.jsp?message=Invalid Product"
        );

        return;
    }

    String contextPath =
        request.getContextPath();
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Update Product | MYSHOP
    </title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =====================================================
         GOOGLE FONT
         ===================================================== -->

    <link
        rel="preconnect"
        href="https://fonts.googleapis.com">

    <link
        rel="preconnect"
        href="https://fonts.gstatic.com">

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;500;600;700;800&display=swap"
        rel="stylesheet">


    <style>

        /* =====================================================
           THEME VARIABLES
           ===================================================== */

        :root {

            --page-bg: #f5f7fb;

            --card-bg: #ffffff;

            --input-bg: #f8fafc;

            --text: #111827;

            --muted: #64748b;

            --border: #e2e8f0;

            --primary: #2563eb;

            --primary-hover: #1d4ed8;

            --primary-soft: #eff6ff;

            --success: #16a34a;

            --success-soft: #f0fdf4;

            --danger: #dc2626;

            --danger-soft: #fef2f2;

            --shadow:
                0 15px 45px rgba(15, 23, 42, 0.08);

            --header-gradient:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #7c3aed
                );
        }


        body.dark-mode {

            --page-bg: #070b14;

            --card-bg: #111827;

            --input-bg: #0f172a;

            --text: #f8fafc;

            --muted: #94a3b8;

            --border:
                rgba(255,255,255,0.09);

            --primary: #60a5fa;

            --primary-hover: #93c5fd;

            --primary-soft:
                rgba(96,165,250,0.12);

            --success: #4ade80;

            --success-soft:
                rgba(34,197,94,0.10);

            --danger: #f87171;

            --danger-soft:
                rgba(239,68,68,0.10);

            --shadow:
                0 15px 45px rgba(0,0,0,0.28);

            --header-gradient:
                linear-gradient(
                    135deg,
                    #1e3a8a,
                    #581c87
                );
        }


        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            box-sizing: border-box;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            margin: 0;

            background: var(--page-bg);

            color: var(--text);

            font-family: "Inter", sans-serif;

            transition:
                background .3s ease,
                color .3s ease;

        }


        /* =====================================================
           PAGE
           ===================================================== */

        .update-page {

            max-width: 1180px;

            margin: 50px auto;

            padding:
                45px 20px 70px;

        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .page-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            margin-bottom: 28px;

        }


        .page-heading {

            display: flex;

            align-items: center;

            gap: 15px;

        }


        .page-icon {

            width: 55px;

            height: 55px;

            min-width: 55px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 16px;

            background: var(--header-gradient);

            color: white;

            font-size: 21px;

            box-shadow:
                0 10px 25px
                rgba(37,99,235,.20);

        }


        .page-title {

            margin: 0;

            color: var(--text);

            font-size: 27px;

            font-weight: 800;

            letter-spacing: -.5px;

        }


        .page-subtitle {

            margin: 5px 0 0;

            color: var(--muted);

            font-size: 13px;

        }


        .back-btn {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            padding: 11px 17px;

            border-radius: 12px;

            background: var(--card-bg);

            color: var(--text);

            border: 1px solid var(--border);

            text-decoration: none;

            font-size: 13px;

            font-weight: 600;

            transition: .25s ease;

        }


        .back-btn:hover {

            color: var(--primary);

            border-color: var(--primary);

            transform: translateY(-2px);

        }


        /* =====================================================
           MAIN GRID
           ===================================================== */

        .update-grid {

            display: grid;

            grid-template-columns:
                360px 1fr;

            gap: 25px;

            align-items: start;

        }


        /* =====================================================
           CARDS
           ===================================================== */

        .modern-card {

            background: var(--card-bg);

            border: 1px solid var(--border);

            border-radius: 22px;

            box-shadow: var(--shadow);

            overflow: hidden;

        }


        .card-header-modern {

            padding: 20px 22px;

            border-bottom: 1px solid var(--border);

            display: flex;

            align-items: center;

            gap: 12px;

        }


        .card-header-icon {

            width: 40px;

            height: 40px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 11px;

            background: var(--primary-soft);

            color: var(--primary);

        }


        .card-header-modern h3 {

            margin: 0;

            color: var(--text);

            font-size: 16px;

            font-weight: 800;

        }


        .card-header-modern p {

            margin: 3px 0 0;

            color: var(--muted);

            font-size: 11px;

        }


        .card-body-modern {

            padding: 25px;

        }


        /* =====================================================
           IMAGE CARD
           ===================================================== */

        .image-card {

            position: sticky;

            top: 20px;

        }


        .product-image-wrapper {

            position: relative;

            width: 100%;

            height: 270px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 17px;

            background:
                linear-gradient(
                    135deg,
                    var(--primary-soft),
                    var(--input-bg)
                );

            border: 1px solid var(--border);

            overflow: hidden;

        }


        .product-image-wrapper::before {

            content: "";

            position: absolute;

            width: 180px;

            height: 180px;

            border-radius: 50%;

            background:
                rgba(37,99,235,.06);

        }


        #productImg {

            position: relative;

            z-index: 2;

            max-width: 82%;

            max-height: 82%;

            object-fit: contain;

            border-radius: 15px;

            transition:
                transform .3s ease;

        }


        .product-image-wrapper:hover #productImg {

            transform: scale(1.04);

        }


        .image-label {

            display: inline-flex;

            align-items: center;

            gap: 6px;

            margin-top: 18px;

            color: var(--muted);

            font-size: 11px;

        }


        /* =====================================================
           FILE INPUT
           ===================================================== */

        .file-wrapper {

            margin-top: 12px;

        }


        .file-input {

            width: 100%;

            padding: 10px;

            border-radius: 11px;

            border: 1px solid var(--border);

            background: var(--input-bg);

            color: var(--text);

            font-size: 12px;

            cursor: pointer;

        }


        .file-input::file-selector-button {

            border: none;

            padding: 8px 12px;

            margin-right: 10px;

            border-radius: 8px;

            background: var(--primary);

            color: white;

            font-size: 11px;

            font-weight: 600;

            cursor: pointer;

        }


        /* =====================================================
           IMAGE BUTTON
           ===================================================== */

        .upload-btn {

            width: 100%;

            margin-top: 13px;

            padding: 12px;

            border: none;

            border-radius: 11px;

            background: var(--primary);

            color: white;

            font-size: 13px;

            font-weight: 700;

            cursor: pointer;

            transition: .25s ease;

        }


        .upload-btn:hover {

            background: var(--primary-hover);

            transform: translateY(-2px);

        }


        .upload-btn:disabled {

            opacity: .6;

            cursor: not-allowed;

            transform: none;

        }


        /* =====================================================
           UPLOAD STATUS
           ===================================================== */

        #uploadStatus {

            display: none;

            margin-top: 12px;

            padding: 10px 12px;

            border-radius: 10px;

            font-size: 11px;

            text-align: center;

        }


        #uploadStatus.success {

            display: block;

            background: var(--success-soft);

            color: var(--success);

        }


        #uploadStatus.error {

            display: block;

            background: var(--danger-soft);

            color: var(--danger);

        }


        /* =====================================================
           PRODUCT INFO
           ===================================================== */

        .product-summary {

            margin-top: 20px;

            padding: 15px;

            border-radius: 14px;

            background: var(--input-bg);

            border: 1px solid var(--border);

        }


        .summary-label {

            color: var(--muted);

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: .5px;

        }


        .summary-name {

            margin-top: 4px;

            color: var(--text);

            font-size: 15px;

            font-weight: 800;

            word-break: break-word;

        }


        .summary-id {

            margin-top: 4px;

            color: var(--primary);

            font-family: monospace;

            font-size: 11px;

        }


        /* =====================================================
           FORM
           ===================================================== */

        .product-form {

            padding: 25px;

        }


        .form-section-title {

            display: flex;

            align-items: center;

            gap: 9px;

            margin-bottom: 22px;

            color: var(--text);

            font-size: 17px;

            font-weight: 800;

        }


        .form-section-title i {

            color: var(--primary);

        }


        .form-group-modern {

            margin-bottom: 18px;

        }


        .form-label-modern {

            display: block;

            margin-bottom: 7px;

            color: var(--text);

            font-size: 12px;

            font-weight: 700;

        }


        .form-label-modern i {

            width: 18px;

            color: var(--primary);

        }


        .modern-input,

        .modern-select,

        .modern-textarea {

            width: 100%;

            border: 1px solid var(--border);

            border-radius: 11px;

            background: var(--input-bg);

            color: var(--text);

            outline: none;

            font-family: inherit;

            font-size: 13px;

            transition:
                border .2s ease,
                box-shadow .2s ease;

        }


        .modern-input,

        .modern-select {

            height: 45px;

            padding: 0 13px;

        }


        .modern-textarea {

            min-height: 110px;

            padding: 12px 13px;

            resize: vertical;

            line-height: 1.6;

        }


        .modern-input:focus,

        .modern-select:focus,

        .modern-textarea:focus {

            border-color: var(--primary);

            box-shadow:
                0 0 0 3px
                rgba(37,99,235,.10);

        }


        .modern-input::placeholder,

        .modern-textarea::placeholder {

            color: var(--muted);

        }


        /* =====================================================
           TWO COLUMNS
           ===================================================== */

        .form-row {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 15px;

        }


        /* =====================================================
           PRICE
           ===================================================== */

        .price-wrapper {

            position: relative;

        }


        .price-symbol {

            position: absolute;

            left: 13px;

            top: 50%;

            transform: translateY(-50%);

            color: var(--primary);

            font-weight: 800;

            font-size: 14px;

        }


        .price-input {

            padding-left: 30px !important;

        }


        /* =====================================================
           ACTIONS
           ===================================================== */

        .form-actions {

            display: flex;

            justify-content: flex-end;

            gap: 12px;

            margin-top: 28px;

            padding-top: 22px;

            border-top: 1px solid var(--border);

        }


        .action-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            min-width: 135px;

            height: 45px;

            padding: 0 18px;

            border-radius: 11px;

            border: none;

            text-decoration: none;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

            transition: .25s ease;

        }


        .cancel-btn {

            color: var(--text);

            background: var(--input-bg);

            border: 1px solid var(--border);

        }


        .cancel-btn:hover {

            color: var(--danger);

            border-color: var(--danger);

            transform: translateY(-2px);

        }


        .update-btn {

            color: white;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #4f46e5
                );

            box-shadow:
                0 8px 18px
                rgba(37,99,235,.18);

        }


        .update-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 12px 25px
                rgba(37,99,235,.25);

        }


        /* =====================================================
           REQUIRED
           ===================================================== */

        .required {

            color: var(--danger);

        }


        /* =====================================================
           INFO BOX
           ===================================================== */

        .info-box {

            display: flex;

            align-items: flex-start;

            gap: 10px;

            margin-top: 18px;

            padding: 12px;

            border-radius: 11px;

            background: var(--primary-soft);

            color: var(--muted);

            font-size: 10px;

            line-height: 1.6;

        }


        .info-box i {

            color: var(--primary);

            margin-top: 2px;

        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 900px) {

            .update-grid {

                grid-template-columns: 1fr;

            }


            .image-card {

                position: static;

            }

        }


        @media (max-width: 650px) {

            .update-page {

                padding:
                    30px 15px 50px;

            }


            .page-header {

                align-items: flex-start;

                flex-direction: column;

            }


            .page-title {

                font-size: 23px;

            }


            .page-icon {

                width: 48px;

                min-width: 48px;

                height: 48px;

            }


            .back-btn {

                width: 100%;

                justify-content: center;

            }


            .form-row {

                grid-template-columns: 1fr;

                gap: 0;

            }


            .product-image-wrapper {

                height: 230px;

            }


            .card-body-modern,

            .product-form {

                padding: 20px;

            }


            .form-actions {

                flex-direction: column-reverse;

            }


            .action-btn {

                width: 100%;

            }

        }


        @media (max-width: 400px) {

            .page-heading {

                align-items: flex-start;

            }


            .page-title {

                font-size: 20px;

            }


            .page-subtitle {

                font-size: 11px;

            }

        }


        /* =====================================================
           LOADING
           ===================================================== */

        .spinner {

            display: inline-block;

            width: 14px;

            height: 14px;

            border: 2px solid rgba(255,255,255,.4);

            border-top-color: white;

            border-radius: 50%;

            animation:
                spin .7s linear infinite;

        }


        @keyframes spin {

            to {
                transform: rotate(360deg);
            }

        }

    </style>

</head>


<body>


<!-- =========================================================
     HEADER
     ========================================================= -->

<jsp:include page="/header.jsp"/>


<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="update-page">


    <!-- =====================================================
         PAGE HEADER
         ===================================================== -->

    <div class="page-header">


        <div class="page-heading">

            <div class="page-icon">

                <i class="fa-solid fa-pen-to-square"></i>

            </div>


            <div>

                <h1 class="page-title">
                    Update Product
                </h1>

                <p class="page-subtitle">
                    Modify product information and update its image
                </p>

            </div>

        </div>


        <a
            href="adminViewProduct.jsp"
            class="back-btn">

            <i class="fa-solid fa-arrow-left"></i>

            Back to Products

        </a>


    </div>


    <!-- =====================================================
         GRID
         ===================================================== -->

    <div class="update-grid">


        <!-- =================================================
             IMAGE CARD
             ================================================= -->

        <section class="modern-card image-card">


            <div class="card-header-modern">

                <div class="card-header-icon">

                    <i class="fa-solid fa-image"></i>

                </div>


                <div>

                    <h3>
                        Product Image
                    </h3>

                    <p>
                        Upload a new product image
                    </p>

                </div>

            </div>


            <div class="card-body-modern">


                <!-- IMAGE -->

                <div class="product-image-wrapper">

                    <img
                        id="productImg"

                        src="<%=contextPath%>/ShowImage?pid=<%=product.getProdId()%>&t=<%=System.currentTimeMillis()%>"

                        alt="Product Image"

                        onerror="
                            this.src='<%=contextPath%>/images/noimage.jpg';
                        "
                    >

                </div>


                <div class="image-label">

                    <i class="fa-solid fa-circle-info"></i>

                    Recommended: JPG, JPEG, PNG or WEBP

                </div>


                <!-- FILE -->

                <div class="file-wrapper">

                    <input
                        type="file"
                        id="imageInput"
                        class="file-input"
                        accept="image/png,image/jpeg,image/jpg,image/webp"
                        onchange="previewSelectedImage(event)"
                    >

                </div>


                <!-- UPLOAD -->

                <button
                    type="button"
                    id="uploadBtn"
                    onclick="uploadImage()"
                    class="upload-btn">

                    <i class="fa-solid fa-cloud-arrow-up"></i>

                    Upload New Image

                </button>


                <!-- STATUS -->

                <div id="uploadStatus"></div>


                <!-- PRODUCT SUMMARY -->

                <div class="product-summary">

                    <div class="summary-label">
                        Product
                    </div>

                    <div class="summary-name">

                        <%=product.getProdName()%>

                    </div>

                    <div class="summary-id">

                        ID:
                        <%=product.getProdId()%>

                    </div>

                </div>


            </div>

        </section>


        <!-- =================================================
             PRODUCT FORM
             ================================================= -->

        <section class="modern-card">


            <div class="card-header-modern">

                <div class="card-header-icon">

                    <i class="fa-solid fa-box"></i>

                </div>


                <div>

                    <h3>
                        Product Information
                    </h3>

                    <p>
                        Update product details below
                    </p>

                </div>

            </div>


            <form
                action="<%=contextPath%>/UpdateProductSrv"
                method="post"
                class="product-form"
                onsubmit="return validateProductForm()"
            >


                <!-- PRODUCT ID -->

                <input
                    type="hidden"
                    name="pid"
                    value="<%=product.getProdId()%>"
                >


                <div class="form-section-title">

                    <i class="fa-solid fa-circle-info"></i>

                    Basic Information

                </div>


                <!-- NAME -->

                <div class="form-group-modern">

                    <label
                        class="form-label-modern">

                        <i class="fa-solid fa-tag"></i>

                        Product Name

                        <span class="required">*</span>

                    </label>


                    <input
                        type="text"
                        name="name"
                        id="productName"
                        class="modern-input"
                        value="<%=product.getProdName()%>"
                        placeholder="Enter product name"
                        maxlength="150"
                        required
                    >

                </div>


                <!-- TYPE -->

                <div class="form-group-modern">

                    <label
                        class="form-label-modern">

                        <i class="fa-solid fa-layer-group"></i>

                        Product Category

                        <span class="required">*</span>

                    </label>


                    <select
                        name="type"
                        class="modern-select"
                        required
                    >

                        <option value="mobile"
                            <%= "mobile".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            MOBILE
                        </option>


                        <option value="tv"
                            <%= "tv".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            TV
                        </option>


                        <option value="camera"
                            <%= "camera".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            CAMERA
                        </option>


                        <option value="laptop"
                            <%= "laptop".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            LAPTOP
                        </option>


                        <option value="tablet"
                            <%= "tablet".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            TABLET
                        </option>


                        <option value="speaker"
                            <%= "speaker".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            SPEAKER
                        </option>


                        <option value="other"
                            <%= "other".equalsIgnoreCase(
                                product.getProdType()
                            ) ? "selected" : "" %>>
                            OTHER
                        </option>

                    </select>

                </div>


                <!-- DESCRIPTION -->

                <div class="form-group-modern">

                    <label
                        class="form-label-modern">

                        <i class="fa-solid fa-align-left"></i>

                        Description

                    </label>


                    <textarea
                        name="info"
                        class="modern-textarea"
                        placeholder="Enter product description"
                        maxlength="1000"
                    ><%=product.getProdInfo()%></textarea>

                </div>


                <!-- PRICE + QUANTITY -->

                <div class="form-row">


                    <!-- PRICE -->

                    <div class="form-group-modern">

                        <label
                            class="form-label-modern">

                            <i class="fa-solid fa-indian-rupee-sign"></i>

                            Price

                            <span class="required">*</span>

                        </label>


                        <div class="price-wrapper">

                            <span class="price-symbol">
                                &#8377;
                            </span>


                            <input
                                type="number"
                                name="price"
                                id="productPrice"
                                class="modern-input price-input"
                                value="<%=product.getProdPrice()%>"
                                placeholder="0.00"
                                min="0"
                                step="0.01"
                                required
                            >

                        </div>

                    </div>


                    <!-- QUANTITY -->

                    <div class="form-group-modern">

                        <label
                            class="form-label-modern">

                            <i class="fa-solid fa-boxes-stacked"></i>

                            Quantity

                            <span class="required">*</span>

                        </label>


                        <input
                            type="number"
                            name="quantity"
                            id="productQuantity"
                            class="modern-input"
                            value="<%=product.getProdQuantity()%>"
                            placeholder="0"
                            min="0"
                            step="1"
                            required
                        >

                    </div>


                </div>


                <!-- INFO -->

                <div class="info-box">

                    <i class="fa-solid fa-circle-info"></i>

                    <span>
                        Updating the product information will immediately
                        reflect the new details wherever this product is
                        displayed in MYSHOP.
                    </span>

                </div>


                <!-- ACTIONS -->

                <div class="form-actions">


                    <a
                        href="adminViewProduct.jsp"
                        class="action-btn cancel-btn">

                        <i class="fa-solid fa-xmark"></i>

                        Cancel

                    </a>


                    <button
                        type="submit"
                        class="action-btn update-btn"
                        id="updateBtn">

                        <i class="fa-solid fa-floppy-disk"></i>

                        Update Product

                    </button>


                </div>


            </form>

        </section>


    </div>

</main>


<!-- =========================================================
     FOOTER
     ========================================================= -->

<jsp:include page="/footer.html"/>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

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
       IMAGE PREVIEW
       ========================================================= */

    function previewSelectedImage(event) {

        const file =
            event.target.files[0];

        if (!file) {
            return;
        }


        const allowedTypes = [
            "image/jpeg",
            "image/jpg",
            "image/png",
            "image/webp"
        ];


        if (!allowedTypes.includes(
                file.type
            )) {

            showUploadStatus(
                "Please select JPG, JPEG, PNG or WEBP image.",
                "error"
            );

            event.target.value = "";

            return;
        }


        /* 5 MB */

        if (file.size > 5 * 1024 * 1024) {

            showUploadStatus(
                "Image size must be less than 5 MB.",
                "error"
            );

            event.target.value = "";

            return;
        }


        const reader =
            new FileReader();


        reader.onload = function(e) {

            document.getElementById(
                "productImg"
            ).src = e.target.result;

        };


        reader.readAsDataURL(file);


        hideUploadStatus();

    }


    /* =========================================================
       UPLOAD IMAGE
       ========================================================= */

    function uploadImage() {

        const fileInput =
            document.getElementById(
                "imageInput"
            );

        const uploadBtn =
            document.getElementById(
                "uploadBtn"
            );


        const pid =
            document.getElementById(
                "productId"
            ) ?
            document.getElementById(
                "productId"
            ).value :
            "<%=product.getProdId()%>";


        if (fileInput.files.length === 0) {

            showUploadStatus(
                "Please select an image first.",
                "error"
            );

            return;
        }


        const file =
            fileInput.files[0];


        const allowedTypes = [
            "image/jpeg",
            "image/jpg",
            "image/png",
            "image/webp"
        ];


        if (!allowedTypes.includes(
                file.type
            )) {

            showUploadStatus(
                "Only JPG, JPEG, PNG and WEBP images are allowed.",
                "error"
            );

            return;
        }


        if (file.size > 5 * 1024 * 1024) {

            showUploadStatus(
                "Image size must be less than 5 MB.",
                "error"
            );

            return;
        }


        const formData =
            new FormData();


        formData.append(
            "image",
            file
        );


        formData.append(
            "pid",
            pid
        );


        uploadBtn.disabled = true;


        uploadBtn.innerHTML =
            '<span class="spinner"></span> Uploading...';


        hideUploadStatus();


        fetch(
            "<%=contextPath%>/UpdateProductImageSrv",
            {
                method: "POST",
                body: formData
            }
        )

        .then(function(response) {

            return response.text();

        })


        .then(function(data) {

            data =
                data.trim();


            if (data === "SUCCESS") {

                showUploadStatus(
                    "Product image updated successfully!",
                    "success"
                );


                /*
                 * Refresh image from server
                 */

                document.getElementById(
                    "productImg"
                ).src =
                    "<%=contextPath%>/ShowImage?pid="
                    + encodeURIComponent(pid)
                    + "&t="
                    + new Date().getTime();


                fileInput.value = "";


            } else {

                showUploadStatus(
                    "Image upload failed. Please try again.",
                    "error"
                );

            }

        })


        .catch(function(error) {

            console.error(error);

            showUploadStatus(
                "Server error while uploading image.",
                "error"
            );

        })


        .finally(function() {

            uploadBtn.disabled = false;

            uploadBtn.innerHTML =
                '<i class="fa-solid fa-cloud-arrow-up"></i> Upload New Image';

        });

    }


    /* =========================================================
       STATUS
       ========================================================= */

    function showUploadStatus(
        message,
        type
    ) {

        const status =
            document.getElementById(
                "uploadStatus"
            );


        status.className =
            type;


        status.innerHTML =
            message;


        status.style.display =
            "block";

    }


    function hideUploadStatus() {

        const status =
            document.getElementById(
                "uploadStatus"
            );


        status.style.display =
            "none";

        status.className = "";

        status.innerHTML = "";

    }


    /* =========================================================
       FORM VALIDATION
       ========================================================= */

    function validateProductForm() {

        const name =
            document.getElementById(
                "productName"
            ).value.trim();


        const price =
            parseFloat(
                document.getElementById(
                    "productPrice"
                ).value
            );


        const quantity =
            parseInt(
                document.getElementById(
                    "productQuantity"
                ).value
            );


        if (name.length === 0) {

            alert(
                "Please enter product name."
            );

            return false;
        }


        if (isNaN(price) ||
            price < 0) {

            alert(
                "Please enter a valid product price."
            );

            return false;
        }


        if (isNaN(quantity) ||
            quantity < 0) {

            alert(
                "Please enter a valid quantity."
            );

            return false;
        }


        const updateBtn =
            document.getElementById(
                "updateBtn"
            );


        updateBtn.disabled = true;


        updateBtn.innerHTML =
            '<span class="spinner"></span> Updating...';


        return true;

    }

</script>


<!-- =========================================================
     BOOTSTRAP JS
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>