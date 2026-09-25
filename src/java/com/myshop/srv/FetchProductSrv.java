package com.myshop.srv;

import com.myshop.beans.ProductBean;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
public class FetchProductSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int PAGE_SIZE = 6;

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /* =====================================================
           PAGINATION
           ===================================================== */

        int page = 1;

        String pageParam = request.getParameter("page");

        try {

            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
            }

        } catch (NumberFormatException e) {

            page = 1;
        }

        if (page < 1) {
            page = 1;
        }


        /* =====================================================
           SEARCH & CATEGORY
           ===================================================== */

        String search = request.getParameter("search");
        String category = request.getParameter("category");


        /* =====================================================
           PRODUCT DATA
           ===================================================== */

        List<ProductBean> allProducts = new ArrayList<>();

        /*
         * Image URL is kept in the same index as ProductBean.
         *
         * Example:
         *
         * products[0] -> imagePath[0]
         * products[1] -> imagePath[1]
         *
         * This relationship is maintained during filtering.
         */
        List<String> imagePath = new ArrayList<>();


        /* =====================================================
           FETCH PRODUCTS FROM FAKE STORE API
           ===================================================== */

        try {

    String apiUrl =
            "https://fakestoreapi.com/products";

    URL url = new URL(apiUrl);

    HttpURLConnection conn =
            (HttpURLConnection) url.openConnection();

    conn.setRequestMethod("GET");

    conn.setRequestProperty(
            "Accept",
            "application/json"
    );

    conn.setConnectTimeout(10000);
    conn.setReadTimeout(10000);


    int responseCode =
            conn.getResponseCode();


    if (responseCode != HttpURLConnection.HTTP_OK) {

        throw new IOException(
                "API returned HTTP status: "
                + responseCode
        );
    }


    StringBuilder sb =
            new StringBuilder();


    try (
        BufferedReader reader =
            new BufferedReader(
                new InputStreamReader(
                    conn.getInputStream(),
                    "UTF-8"
                )
            )
    ) {

        String line;

        while ((line = reader.readLine()) != null) {

            sb.append(line);
        }
    }


    conn.disconnect();


    JSONArray productsArray =
            new JSONArray(sb.toString());


    for (int i = 0;
         i < productsArray.length();
         i++) {

        JSONObject obj =
                productsArray.getJSONObject(i);


        ProductBean p =
                new ProductBean();


        p.setProdId(
                String.valueOf(
                    obj.getInt("id")
                )
        );


        p.setProdName(
                obj.getString("title")
        );


        p.setProdPrice(
                obj.getDouble("price")
        );


        p.setProdType(
                obj.getString("category")
        );


        p.setProdInfo(
                obj.getString("description")
        );


        allProducts.add(p);


        imagePath.add(
                obj.getString("image")
        );
    }


} catch (java.net.UnknownHostException e) {

    e.printStackTrace();

    request.setAttribute(
            "apiError",
            "Unable to connect to Fake Store API. " +
            "DNS could not resolve fakestoreapi.com."
    );

} catch (java.net.SocketTimeoutException e) {

    e.printStackTrace();

    request.setAttribute(
            "apiError",
            "Fake Store API connection timed out."
    );

} catch (Exception e) {

    e.printStackTrace();

    request.setAttribute(
            "apiError",
            "Unable to fetch products: "
            + e.getMessage()
    );
}


        /* =====================================================
           SEARCH FILTER
           ===================================================== */

        if (search != null
                && !search.trim().isEmpty()) {

            String searchLower =
                    search.trim().toLowerCase();


            List<ProductBean> filteredProducts =
                    new ArrayList<>();

            List<String> filteredImages =
                    new ArrayList<>();


            for (int i = 0;
                 i < allProducts.size();
                 i++) {

                ProductBean product =
                        allProducts.get(i);


                String productName =
                        product.getProdName();


                if (productName != null
                        && productName
                        .toLowerCase()
                        .contains(searchLower)) {

                    filteredProducts.add(product);

                    /*
                     * Keep the corresponding image
                     */
                    if (i < imagePath.size()) {

                        filteredImages.add(
                                imagePath.get(i)
                        );
                    }
                }
            }


            allProducts =
                    filteredProducts;

            imagePath =
                    filteredImages;
        }


        /* =====================================================
           CATEGORY FILTER
           ===================================================== */

        if (category != null
                && !category.trim().isEmpty()) {

            String categoryLower =
                    category.trim().toLowerCase();


            List<ProductBean> filteredProducts =
                    new ArrayList<>();

            List<String> filteredImages =
                    new ArrayList<>();


            for (int i = 0;
                 i < allProducts.size();
                 i++) {

                ProductBean product =
                        allProducts.get(i);


                String productType =
                        product.getProdType();


                if (productType != null
                        && productType
                        .toLowerCase()
                        .equals(categoryLower)) {

                    filteredProducts.add(product);


                    /*
                     * Keep matching image
                     */
                    if (i < imagePath.size()) {

                        filteredImages.add(
                                imagePath.get(i)
                        );
                    }
                }
            }


            allProducts =
                    filteredProducts;

            imagePath =
                    filteredImages;
        }


        /* =====================================================
           TOTAL PRODUCTS
           ===================================================== */

        int totalProducts =
                allProducts.size();


        /* =====================================================
           TOTAL PAGES
           ===================================================== */

        int totalPages =
                (int) Math.ceil(
                        (double) totalProducts
                        / PAGE_SIZE
                );


        /*
         * Always keep at least one page.
         *
         * This prevents problems when no products
         * are found.
         */
        if (totalPages == 0) {

            totalPages = 1;
        }


        /* =====================================================
           FIX INVALID PAGE
           ===================================================== */

        if (page > totalPages) {

            page = totalPages;
        }


        /* =====================================================
           PAGINATION INDEX
           ===================================================== */

        int start =
                (page - 1) * PAGE_SIZE;


        int end =
                Math.min(
                        start + PAGE_SIZE,
                        totalProducts
                );


        List<ProductBean> paginatedProducts =
                new ArrayList<>();


        List<String> paginatedImages =
                new ArrayList<>();


        if (start < end) {

            paginatedProducts.addAll(
                    allProducts.subList(
                            start,
                            end
                    )
            );


            /*
             * Get matching image URLs
             */
            paginatedImages.addAll(
                    imagePath.subList(
                            start,
                            end
                    )
            );
        }


        /* =====================================================
           SEND DATA TO JSP
           ===================================================== */

        request.setAttribute(
                "api-data",
                allProducts
        );


        request.setAttribute(
                "image",
                paginatedImages
        );


        request.setAttribute(
                "products",
                paginatedProducts
        );


        request.setAttribute(
                "currentPage",
                page
        );


        request.setAttribute(
                "totalPages",
                totalPages
        );


        request.setAttribute(
                "search",
                search != null
                        ? search
                        : ""
        );


        request.setAttribute(
                "category",
                category != null
                        ? category
                        : ""
        );


        /* =====================================================
           FORWARD TO JSP
           ===================================================== */

        RequestDispatcher rd = request.getRequestDispatcher("admin/addProduct.jsp");
        rd.forward(request,response);
    }


    /* =========================================================
       GET
       ========================================================= */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }


    /* =========================================================
       POST
       ========================================================= */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }


    /* =========================================================
       SERVLET INFO
       ========================================================= */

    @Override
    public String getServletInfo() {

        return "Fetch products from Fake Store API";
    }
}
