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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    int page = 1;
    int pageSize = 6;

    String pageParam = request.getParameter("page");
    if (pageParam != null) page = Integer.parseInt(pageParam);

    String search = request.getParameter("search");
    String category = request.getParameter("category");

    List<ProductBean> allProducts = new ArrayList<>();
    List<String> imagePath = new ArrayList<>();

    try {
        String apiUrl = "https://fakestoreapi.com/products";
        URL url = new URL(apiUrl);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

            // 🔥 FIX 403 ERROR
            // 🔥 IMPORTANT HEADERS (for ALL search engines)
            conn.setRequestProperty("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "+ "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");

            conn.setRequestProperty("Accept",
            "text/html,application/json,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");

            conn.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
            conn.setRequestProperty("Connection", "keep-alive");

            // Optional but useful
            conn.setRequestProperty("Referer", "https://www.google.com/");
//        conn.setRequestProperty("Accept", "application/json");

        int responseCode = conn.getResponseCode();

        if (responseCode != 200) {
            throw new RuntimeException("HTTP Error: " + responseCode);
        }

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        reader.close();

        JSONArray productsArray = new JSONArray(sb.toString());

        for (int i = 0; i < productsArray.length(); i++) {

            JSONObject obj = productsArray.getJSONObject(i);

            ProductBean p = new ProductBean();

            p.setProdId(String.valueOf(obj.getInt("id")));
            p.setProdName(obj.getString("title"));
            p.setProdPrice(obj.getDouble("price"));
            p.setProdType(obj.getString("category"));
            p.setProdInfo(obj.getString("description"));

            allProducts.add(p);
            imagePath.add(obj.getString("image"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    // 🔍 SEARCH FILTER
    if (search != null && !search.trim().isEmpty()) {
        String searchLower = search.toLowerCase();
        List<ProductBean> filtered = new ArrayList<>();

        for (ProductBean p : allProducts) {
            if (p.getProdName().toLowerCase().contains(searchLower)) {
                filtered.add(p);
            }
        }
        allProducts = filtered;
    }

    // 📂 CATEGORY FILTER
    if (category != null && !category.trim().isEmpty()) {
        List<ProductBean> filtered = new ArrayList<>();

        for (ProductBean p : allProducts) {
            if (p.getProdType().equalsIgnoreCase(category)) {
                filtered.add(p);
            }
        }
        allProducts = filtered;
    }

    // 📄 PAGINATION (FIXED)
    int totalProducts = allProducts.size();
    int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

    int start = (page - 1) * pageSize;
    int end = Math.min(start + pageSize, totalProducts);

    List<ProductBean> paginatedProducts = new ArrayList<>();

    if (start < end) {
        paginatedProducts = allProducts.subList(start, end);
    }

    // ✅ SEND TO JSP
    request.setAttribute("api-data", allProducts);
    request.setAttribute("image", imagePath);
    request.setAttribute("products", paginatedProducts);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("search", search != null ? search : "");
    request.setAttribute("category", category != null ? category : "");

    RequestDispatcher rd = request.getRequestDispatcher("addProduct.jsp");
    rd.forward(request, response);
}


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
