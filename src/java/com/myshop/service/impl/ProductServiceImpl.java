package com.myshop.service.impl;

import com.myshop.beans.DemandBean;
import com.myshop.beans.ProductBean;
import com.myshop.service.ProductService;
import com.myshop.utility.dbUtil;
import com.myshop.utility.idUtil;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class ProductServiceImpl implements ProductService {

    // =========================================================
    // ADD PRODUCT
    // =========================================================

    @Override
    public String addProduct(
            String prodName,
            String prodType,
            String prodInfo,
            double prodPrice,
            int prodQuantity,
            InputStream prodImage) {

        String status;

        String prodId =
                idUtil.generateProductId();

        ProductBean product =
                new ProductBean(
                        prodId,
                        prodName,
                        prodType,
                        prodInfo,
                        prodPrice,
                        prodQuantity,
                        prodImage
                );

        status = addProduct(product);

        return status;
    }


    // =========================================================
    // ADD PRODUCT
    // =========================================================

    @Override
    public String addProduct(ProductBean product) {

        String status =
                "Product Registration Failed!";

        if (product == null) {
            return "Product Registration Failed: Product is null!";
        }

        if (product.getProdId() == null
                || product.getProdId().trim().isEmpty()) {

            product.setProdId(
                    idUtil.generateProductId()
            );
        }

        String query =
                "INSERT INTO PRODUCTS "
                + "(pId, pName, pType, pInfo, "
                + "pPrice, pQuantity, image) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    product.getProdId()
            );

            ps.setString(
                    2,
                    product.getProdName()
            );

            ps.setString(
                    3,
                    product.getProdType()
            );

            ps.setString(
                    4,
                    product.getProdInfo()
            );

            ps.setDouble(
                    5,
                    product.getProdPrice()
            );

            ps.setInt(
                    6,
                    product.getProdQuantity()
            );

            if (product.getProdImage() != null) {

                ps.setBlob(
                        7,
                        product.getProdImage()
                );

            } else {

                ps.setNull(
                        7,
                        java.sql.Types.BLOB
                );
            }

            int k =
                    ps.executeUpdate();

            if (k > 0) {

                status =
                        "Product Added Successfully! ID: "
                        + product.getProdId();

            } else {

                status =
                        "Product Insertion Failed!";
            }

        } catch (SQLException ex) {

            status =
                    "Error: While inserting product";

            System.err.println(
                    "Error while inserting product: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return status;
    }


    // =========================================================
    // UPDATE PRODUCT PRICE
    // =========================================================

    @Override
    public String updateProductPrice(
            String prodId,
            double updatePrice) {

        String status =
                "Price Updation Failed!";

        String query =
                "UPDATE PRODUCTS "
                + "SET pPrice = ? "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setDouble(
                    1,
                    updatePrice
            );

            ps.setString(
                    2,
                    prodId
            );

            int k =
                    ps.executeUpdate();

            if (k > 0) {

                status =
                        "Price Updation Successfully.";
            }

        } catch (SQLException ex) {

            status =
                    "Status=" + status
                    + "&Error=" + ex.getMessage();

            ex.printStackTrace();
        }

        return status;
    }


    // =========================================================
    // GET ALL PRODUCTS
    // =========================================================

    @Override
    public List<ProductBean> getAllProducts() {

        List<ProductBean> products =
                new ArrayList<>();

        String query =
                "SELECT pId, pName, pType, pInfo, "
                + "pPrice, pQuantity, image "
                + "FROM PRODUCTS";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query);

                ResultSet rs =
                        ps.executeQuery()
        ) {

            while (rs.next()) {

                ProductBean product =
                        new ProductBean();

                product.setProdId(
                        rs.getString("pId")
                );

                product.setProdName(
                        rs.getString("pName")
                );

                product.setProdPrice(
                        rs.getDouble("pPrice")
                );

                product.setProdQuantity(
                        rs.getInt("pQuantity")
                );

                product.setProdType(
                        rs.getString("pType")
                );

                product.setProdInfo(
                        rs.getString("pInfo")
                );

                product.setProdImage(
                        rs.getBinaryStream("image")
                );

                products.add(product);
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error while fetching all products: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return products;
    }


    // =========================================================
    // GET PRODUCTS BY TYPE
    // =========================================================

    @Override
    public List<ProductBean> getAllProductsByType(
            String pType) {

        List<ProductBean> products =
                new ArrayList<>();

        String query =
                "SELECT pId, pName, pType, pInfo, "
                + "pPrice, pQuantity, image "
                + "FROM PRODUCTS "
                + "WHERE LOWER(pType) LIKE ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    "%" + pType.toLowerCase() + "%"
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                while (rs.next()) {

                    ProductBean product =
                            new ProductBean();

                    product.setProdId(
                            rs.getString("pId")
                    );

                    product.setProdName(
                            rs.getString("pName")
                    );

                    product.setProdType(
                            rs.getString("pType")
                    );

                    product.setProdInfo(
                            rs.getString("pInfo")
                    );

                    product.setProdPrice(
                            rs.getDouble("pPrice")
                    );

                    product.setProdQuantity(
                            rs.getInt("pQuantity")
                    );

                    product.setProdImage(
                            rs.getBinaryStream("image")
                    );

                    products.add(product);
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error while fetching products by type: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return products;
    }


    // =========================================================
    // SEARCH PRODUCTS
    // =========================================================

    @Override
    public List<ProductBean> searchAllProducts(
            String search) {

        List<ProductBean> products =
                new ArrayList<>();

        String query =
                "SELECT pId, pName, pType, pInfo, "
                + "pPrice, pQuantity, image "
                + "FROM PRODUCTS "
                + "WHERE LOWER(pType) LIKE ? "
                + "OR LOWER(pName) LIKE ? "
                + "OR LOWER(pInfo) LIKE ?";

        if (search == null) {
            search = "";
        }

        String searchValue =
                "%" + search.toLowerCase() + "%";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    searchValue
            );

            ps.setString(
                    2,
                    searchValue
            );

            ps.setString(
                    3,
                    searchValue
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                while (rs.next()) {

                    ProductBean product =
                            new ProductBean();

                    product.setProdId(
                            rs.getString("pId")
                    );

                    product.setProdName(
                            rs.getString("pName")
                    );

                    product.setProdType(
                            rs.getString("pType")
                    );

                    product.setProdInfo(
                            rs.getString("pInfo")
                    );

                    product.setProdPrice(
                            rs.getDouble("pPrice")
                    );

                    product.setProdQuantity(
                            rs.getInt("pQuantity")
                    );

                    product.setProdImage(
                            rs.getBinaryStream("image")
                    );

                    products.add(product);
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error while searching products: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return products;
    }


    // =========================================================
    // GET PRODUCT IMAGE
    // =========================================================

    @Override
    public byte[] getProductImage(
            String prodId) {

        byte[] image = null;

        String query =
                "SELECT image "
                + "FROM PRODUCTS "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    image =
                            rs.getBytes("image");
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error fetching product image: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return image;
    }


    // =========================================================
    // GET PRODUCT DETAILS
    // =========================================================

    @Override
    public ProductBean getProductDetails(
            String prodId) {

        ProductBean product = null;

        String query =
                "SELECT pId, pName, pType, pInfo, "
                + "pPrice, pQuantity, image "
                + "FROM PRODUCTS "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    product =
                            new ProductBean();

                    product.setProdId(
                            rs.getString("pId")
                    );

                    product.setProdName(
                            rs.getString("pName")
                    );

                    product.setProdType(
                            rs.getString("pType")
                    );

                    product.setProdInfo(
                            rs.getString("pInfo")
                    );

                    product.setProdPrice(
                            rs.getDouble("pPrice")
                    );

                    product.setProdQuantity(
                            rs.getInt("pQuantity")
                    );

                    product.setProdImage(
                            rs.getBinaryStream("image")
                    );
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error fetching product details: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return product;
    }


    // =========================================================
    // UPDATE PRODUCT WITHOUT IMAGE
    // =========================================================

    @Override
    public String updateProductWithoutImage(
            String prevProductId,
            ProductBean updatedProduct) {

        String status =
                "Product Updation Failed!";

        if (prevProductId == null
                || updatedProduct == null) {

            return status;
        }

        if (!prevProductId.equals(
                updatedProduct.getProdId())) {

            return "Both Products are Different, "
                    + "Updation Failed!";
        }

        int prevQuantity =
                getProductQuantity(prevProductId);

        String query =
                "UPDATE PRODUCTS SET "
                + "pName=?, "
                + "pType=?, "
                + "pInfo=?, "
                + "pPrice=?, "
                + "pQuantity=? "
                + "WHERE pId=?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    updatedProduct.getProdName()
            );

            ps.setString(
                    2,
                    updatedProduct.getProdType()
            );

            ps.setString(
                    3,
                    updatedProduct.getProdInfo()
            );

            ps.setDouble(
                    4,
                    updatedProduct.getProdPrice()
            );

            ps.setInt(
                    5,
                    updatedProduct.getProdQuantity()
            );

            ps.setString(
                    6,
                    updatedProduct.getProdId()
            );

            int k =
                    ps.executeUpdate();

            if (k > 0) {

                status =
                        "Product update Successfully.";

                /*
                 * Product became available again.
                 */
                if (prevQuantity
                        < updatedProduct.getProdQuantity()) {

                    List<DemandBean> demandList =
                            new DemandServiceImpl()
                                    .haveDemanded(
                                            prevProductId
                                    );

                    for (
                            DemandBean demand
                            : demandList
                    ) {

                        try {

                            String userFName =
                                    new UserServiceImpl()
                                            .getFirstName(
                                                    demand.getUserName()
                                            );

                            /*
                             * Mail sending was disabled
                             * in the original code.
                             *
                             * MailMessage.productAvailableNow(...)
                             */

                        } catch (Exception ex) {

                            System.out.println(
                                    "Mail sending failed: "
                                    + ex.getMessage()
                            );
                        }

                        boolean flag =
                                new DemandServiceImpl()
                                        .removeProduct(
                                                demand.getUserName(),
                                                prevProductId
                                        );

                        if (flag) {

                            status +=
                                    " And Mail Send to the "
                                    + "customers who were waiting "
                                    + "for this product.";
                        }
                    }
                }

            } else {

                status =
                        "Product is not available "
                        + "in this store.";
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error updating product: "
                    + ex.getMessage()
            );

            ex.printStackTrace();

            status =
                    "Error: " + ex.getMessage();
        }

        return status;
    }


    // =========================================================
    // GET PRODUCT PRICE
    // =========================================================

    @Override
    public double getProductPrice(
            String prodId) {

        double prodPrice = 0;

        String query =
                "SELECT pPrice "
                + "FROM PRODUCTS "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    prodPrice =
                            rs.getDouble("pPrice");
                }
            }

        } catch (SQLException ex) {

            ex.printStackTrace();
        }

        return prodPrice;
    }


    // =========================================================
    // SELL PRODUCT
    // =========================================================

    @Override
    public boolean sellNoProduct(
            String prodId,
            int n) {

        boolean flag = false;

        String query =
                "UPDATE PRODUCTS "
                + "SET pQuantity = pQuantity - ? "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setInt(
                    1,
                    n
            );

            ps.setString(
                    2,
                    prodId
            );

            int k =
                    ps.executeUpdate();

            if (k > 0) {
                flag = true;
            }

        } catch (SQLException ex) {

            ex.printStackTrace();
        }

        System.out.println(
                "sell No of product: "
                + flag
        );

        return flag;
    }


    // =========================================================
    // GET PRODUCT QUANTITY
    // =========================================================

    @Override
    public int getProductQuantity(
            String prodId) {

        int prodQuantity = 0;

        String query =
                "SELECT pQuantity "
                + "FROM PRODUCTS "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    prodQuantity =
                            rs.getInt("pQuantity");
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error fetching product quantity: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return prodQuantity;
    }


    // =========================================================
    // GET ALL PRODUCT IDS
    // =========================================================

    @Override
    public List<String> getAllProductId() {

        List<String> productIds =
                new ArrayList<>();

        String query =
                "SELECT pId FROM PRODUCTS";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query);

                ResultSet rs =
                        ps.executeQuery()
        ) {

            while (rs.next()) {

                productIds.add(
                        rs.getString("pId")
                );
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error fetching product IDs: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return productIds;
    }


    // =========================================================
    // REMOVE PRODUCT
    // =========================================================

    @Override
    public String removeProduct(
            String prodId) {

        String query =
                "DELETE FROM PRODUCTS "
                + "WHERE pId = ?";

        String status =
                "Product Deletion Failed!";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            int k =
                    ps.executeUpdate();

            if (k > 0) {

                status =
                        "Product Deleted Successfully!";

                /*
                 * Optional cart cleanup.
                 */
                try (
                        PreparedStatement ps2 =
                                conn.prepareStatement(
                                        "DELETE FROM CARTS "
                                        + "WHERE pId = ?"
                                )
                ) {

                    ps2.setString(
                            1,
                            prodId
                    );

                    ps2.executeUpdate();
                }
            }

        } catch (SQLException ex) {

            status =
                    "Error: " + ex.getMessage();

            ex.printStackTrace();
        }

        return status;
    }


    // =========================================================
    // UPDATE PRODUCT
    // =========================================================

    @Override
    public String updateProduct(
            ProductBean product) {

        String query =
                "UPDATE PRODUCTS SET "
                + "pName=?, "
                + "pType=?, "
                + "pInfo=?, "
                + "pPrice=?, "
                + "pQuantity=? "
                + "WHERE pId=?";

        String status =
                "Product Updation Failed!";

        if (product == null) {

            return status;
        }

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    product.getProdName()
            );

            ps.setString(
                    2,
                    product.getProdType()
            );

            ps.setString(
                    3,
                    product.getProdInfo()
            );

            ps.setDouble(
                    4,
                    product.getProdPrice()
            );

            ps.setInt(
                    5,
                    product.getProdQuantity()
            );

            ps.setString(
                    6,
                    product.getProdId()
            );

            int k =
                    ps.executeUpdate();

            if (k > 0) {

                status =
                        "Product Updated Successfully!";
            }

        } catch (SQLException ex) {

            ex.printStackTrace();

            status =
                    "Error: " + ex.getMessage();
        }

        return status;
    }


    // =========================================================
    // UPDATE PRODUCT IMAGE
    // =========================================================

    @Override
    public boolean updateProductImage(
            String prodId) {

        throw new UnsupportedOperationException(
                "Product image update is not supported yet."
        );
    }


    // =========================================================
    // GET PRODUCT NAME BY ID
    // =========================================================

    @Override
    public String getProductNameById(
            String prodId) {

        String pName = null;

        String query =
                "SELECT pName "
                + "FROM PRODUCTS "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    pName =
                            rs.getString("pName");
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error getting product name: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return pName;
    }


    // =========================================================
    // GET PRODUCT INFO
    // =========================================================

    public String getProdInfo(
            String prodId) {

        String pInfo = "";

        String query =
                "SELECT pInfo "
                + "FROM PRODUCTS "
                + "WHERE pId = ?";

        try (
                Connection conn =
                        dbUtil.provideConnection();

                PreparedStatement ps =
                        conn.prepareStatement(query)
        ) {

            ps.setString(
                    1,
                    prodId
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    pInfo =
                            rs.getString("pInfo");
                }
            }

        } catch (SQLException ex) {

            System.err.println(
                    "Error getting product info: "
                    + ex.getMessage()
            );

            ex.printStackTrace();
        }

        return pInfo;
    }
}