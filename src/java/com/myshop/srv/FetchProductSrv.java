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

        // Pagination settings
        int page = 1;
        int pageSize = 6;
//        String imagePath = "default.jpg";
        String pageParam = request.getParameter("page");
        if (pageParam != null) page = Integer.parseInt(pageParam);

        String search = request.getParameter("search");
        String category = request.getParameter("category");

        List<ProductBean> allProducts = new ArrayList<>();
        List<String> imagePath = new ArrayList<>();
        // Fetch API data
        try {
            String apiUrl = "https://fakestoreapi.com/products";
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            reader.close();

            JSONArray productsArray = new JSONArray(sb.toString());
            for (int i = 0; i < productsArray.length(); i++) {
                JSONObject obj = productsArray.getJSONObject(i);
                imagePath.add(obj.getString("image"));
                ProductBean p = new ProductBean();
                p.setProdId(String.valueOf(obj.getInt("id")));
                p.setProdName(obj.getString("title"));
                p.setProdPrice(obj.getDouble("price"));
                p.setProdType(obj.getString("category"));
                p.setProdInfo(obj.getString("description"));
//                p.setProdImage(obj.getString("image"));
                allProducts.add(p);
//                allProducts.add(imagePath);
            }
//            System.out.println("api data :"+allProducts.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Apply search
        if (search != null && !search.trim().isEmpty()) {
            search = search.toLowerCase();
            List<ProductBean> filtered = new ArrayList<>();
            for (ProductBean p : allProducts) {
                if (p.getProdName().toLowerCase().contains(search)) {
                    filtered.add(p);
                }
            }
            allProducts = filtered;
        }

        // Apply category filter
        if (category != null && !category.trim().isEmpty()) {
            List<ProductBean> filtered = new ArrayList<>();
            for (ProductBean p : allProducts) {
                if (p.getProdType().equalsIgnoreCase(category)) {
                    filtered.add(p);
                }
            }
            allProducts = filtered;
        }

        // Pagination
        int totalProducts = allProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalProducts);
        List<ProductBean> paginatedProducts = allProducts.subList(start, end);
//    List<ProductBean> paginatedProducts = new ArrayList<>();
        if (start < end) paginatedProducts = allProducts.subList(start, end);

        // Set attributes safely
        request.setAttribute("api-data", allProducts);
        request.setAttribute("image", imagePath);
        request.setAttribute("products", paginatedProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("category", category != null ? category : "");

        RequestDispatcher rd = request.getRequestDispatcher("addProduct.jsp");
        rd.forward(request, response);
//            response.sendRedirect("addProduct.jsp?");
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
