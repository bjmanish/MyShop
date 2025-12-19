package com.myshop.utility;

import com.myshop.beans.ProductBean;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Fetch products from FakeStoreAPI
 */
public class FetchProductAPI {

    public static List<ProductBean> getAllProductDetails() throws Exception {
        String apiUrl = "https://fakestoreapi.com/products";

        List<ProductBean> productList = new ArrayList<>();

        // Fetch JSON from API
        String jsonString = new java.util.Scanner(new java.net.URL(apiUrl).openStream(), "UTF-8").useDelimiter("\\A").next();

        JSONArray productsArray = new JSONArray(jsonString);

        for (int i = 0; i < productsArray.length(); i++) {
            JSONObject productJson = productsArray.getJSONObject(i);

            ProductBean product = new ProductBean();
            int id = productJson.getInt("id");
//            String id1 = Integer.parseInt(id);
            String id1 = id+"";
            product.setProdId(id1);
            product.setProdName(productJson.getString("title"));
            product.setProdType(productJson.getString("category"));
            product.setProdInfo(productJson.getString("description"));
            product.setProdPrice(productJson.getDouble("price"));
            product.setProdQuantity(1); // default quantity
            
            String imageUrl = productJson.getString("image"); // image URL from API
            InputStream prodImage = null;

            if (imageUrl != null && !imageUrl.isEmpty()) {
                prodImage = new URL(imageUrl).openStream();
            }

            product.setProdImage(prodImage);

            productList.add(product);
        }

        return productList;
    }

//    public static void main(String[] args) throws Exception {
//        List<ProductBean> products = getAllProductDetails();
//        for (ProductBean p : products) {
//            System.out.println(p.getProdId() + " | " + p.getProdName() + " | " + p.getProdType() + " | " + p.getProdPrice() + " | " + p.getProdImage());
//        }
//    }
}
