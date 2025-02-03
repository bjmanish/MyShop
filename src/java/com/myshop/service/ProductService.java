package com.myshop.service;

import com.myshop.beans.ProductBean;
import java.io.InputStream;
import java.util.List;

public interface ProductService {
    
    public String addProduct(String prodName, String prodType, String prodInfo, double prodPrice, int prodQuantity, InputStream prodImage);
    
    public String addProduct(ProductBean product);
    
    public String removeProduct(String prodId);
    
    public String updateProduct(ProductBean prevProduct);
    
    public String updateProductPrice(String prodId, double updatePrice);
    
    public List<ProductBean>getAllProducts();
    
    public List<ProductBean>getAllProductsByType(String type);
    
    public List<ProductBean>searchAllProducts(String search);
    
    public byte[] getProductImage(String prodId);
    
    public ProductBean getProductDetails(String prodId);
    
    public String updateProductWithoutImage(String prevProductId, ProductBean updatedProduct);
    
    public double getProductPrice(String prodId);
    
    public boolean sellNoProduct(String prodId, int n);
    
    public int getProductQuantity(String prodId);
    
    public List <String> getAllProductId();
}

