package com.myshop.service;

import com.myshop.beans.ProductBean;
import com.myshop.utility.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

public class ProductImportService {

    public static String saveProductsToDB(List<ProductBean> products, List<String> imageUrls) {

        String status = "Import Failed";

        String query = "INSERT INTO PRODUCTS (product_id, name, type, description, price, stock, image) VALUES (?,?,?,?,?,?,?)";

        try (Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            for (int i = 0; i < products.size(); i++) {

                ProductBean p = products.get(i);

                ps.setString(1, p.getProdId());
                ps.setString(2, p.getProdName());
                ps.setString(3, p.getProdType());
                ps.setString(4, p.getProdInfo());
                ps.setDouble(5, p.getProdPrice());
                ps.setInt(6, p.getProdQuantity());
                ps.setString(7, imageUrls.get(i));

                ps.addBatch(); // 🔥 batch insert (fast)
            }

            ps.executeBatch();

            status = "Products Imported Successfully!";

        } catch (Exception e) {
            e.printStackTrace();
            status = "Error: " + e.getMessage();
        }

        return status;
    }
}
