package com.myshop.service.impl;

import com.myshop.beans.DemandBean;
import com.myshop.beans.ProductBean;
import com.myshop.service.ProductService;
import com.myshop.utility.MailMessage;
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

    @Override
    public String addProduct(String prodName, String prodType, String prodInfo, double prodPrice, int prodQuantity, InputStream prodImage) {
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        String status = null;
        String prodId = idUtil.generatedId();
        
        ProductBean product = new ProductBean(prodId, prodName, prodType, prodInfo, prodPrice, prodQuantity, prodImage);
      
        status = addProduct(product);
        
        return status;
    }


    @Override
    public String addProduct(ProductBean product) {
             String status = "Product Registration Failed!";
             if(product.getProdId() == null){
                 product.setProdId(idUtil.generatedId());
             }
             //System.out.println("ProductBean data: "+product.toString()+"");
             Connection conn = dbUtil.provideConnection();
             PreparedStatement ps = null;
             try{
                 ps = conn.prepareStatement("INSERT INTO PRODUCTS VALUES(?,?,?,?,?,?,?);");
                 ps.setString(1, product.getProdId());
                 ps.setString(2, product.getProdName());
                 ps.setString(3, product.getProdType());
                 ps.setString(4, product.getProdInfo());
                 ps.setDouble(5, product.getProdPrice());
                 ps.setInt(6, product.getProdQuantity());
                 ps.setBlob(7, product.getProdImage());
                 
                 int  k = ps.executeUpdate();
                 if(k > 0){
                     status = "Product Added SuccessFully with Product Id:"+product.getProdId();
                 }else{
                     status = "Product Updation Failed!";
                 }
                 
             }catch(SQLException ex){
                 status = "Error: "+ ex.getMessage();
                 ex.printStackTrace();
             }
             dbUtil.closeConnection(conn);
             dbUtil.closeConnection(ps);
        
        
        return status;
        
    }

    @Override
    public String removeProduct(String prodId) {
        String query = "DELETE FROM PRODUCTS WHERE pId=?";
        String status = "Product Deletion Failed!";
        try(
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query)){
            ps.setString(1, prodId);
            int k = ps.executeUpdate();
            if (k > 0){
                status = "Product Deleted Successfully!";
                PreparedStatement ps2 = conn.prepareStatement("DELETE FROM USERCART WHERE prodId=?");
                ps2.setString(1, prodId);
                ps2.executeUpdate();
            }
        }catch (SQLException ex) {
            System.out.println(status+" && error in updated the product: "+ex.getMessage());
            status = "Status="+status+"&Error: "+ ex.getMessage();
            ex.printStackTrace();
        }
        return status;
    }

    @Override
    public String updateProduct(ProductBean product) {
        String query = "UPDATE PRODUCTS SET pName=?, pType=?, pInfo=?, pPrice=?, pQuantity=? WHERE pId=?";
        String status = "Product Updation Failed!";
        try(
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query)){
            
            ps.setString(1, product.getProdName());
            ps.setString(2, product.getProdType());
            ps.setString(3, product.getProdInfo());
            ps.setDouble(4, product.getProdPrice());
            ps.setInt(5, product.getProdQuantity());
            ps.setString(6, product.getProdId());
            
            int k = ps.executeUpdate();
            if (k > 0)
                status = "Product Updated Successfully!";
            
        }catch (SQLException ex) {
            System.out.println("error in updated the product: "+ex.getMessage());
            ex.printStackTrace();
        }
        return status;
    }

    @Override
    public String updateProductPrice(String prodId, double updatePrice) {
        String status = "Price Updation Failed!";
        String query = "UPDATE PRODUCTS SET pPrice = ? WHERE pId = ?";
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setDouble(1, updatePrice);
            ps.setString(2, prodId);
            
            int k = ps.executeUpdate();
            
            if(k>0){
                status = "Price Updation Successfully.";
            }
        }catch(SQLException ex){
            status = "Status="+status+"&Error: "+ ex.getMessage();
            ex.printStackTrace();
        }
        return status;
    }

    @Override
    public List<ProductBean> getAllProducts() {
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        List <ProductBean> products = new ArrayList<>();
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT * FROM PRODUCTS");
            rs = ps.executeQuery();
            while(rs.next()){
                ProductBean product = new ProductBean();
                
                product.setProdId(rs.getString(1));
                product.setProdName(rs.getString(2));
                product.setProdType(rs.getString(3));
                product.setProdInfo(rs.getString(4));
                product.setProdPrice(rs.getDouble(5));
                product.setProdQuantity(rs.getInt(6));
                InputStream prodImage = rs.getBinaryStream(7);
                // Convert InputStream to BufferedImage
                //BufferedImage bufferedImage = ImageIO.read(inputStream);
                // Convert BufferedImage to Image
                //Image image = bufferedImage;
                product.setProdImage(prodImage);
                
                products.add(product);
            }
        } catch (SQLException ex) {
           // Logger.getLogger(ProductServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
           ex.printStackTrace();
        }
        
                
        return products;
    }

    @Override
    public List<ProductBean> getAllProductsByType(String type) {
        List<ProductBean> products = new ArrayList<>();
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = "SELECT * FROM PRODUCTS WHERE lower(pType) like ?";
        try{
            ps = conn.prepareStatement(query);
            ps.setString(1, type);
            rs = ps.executeQuery();
            if(rs.next()){
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString(1));
                product.setProdName(rs.getString(2));
                product.setProdType(rs.getString(3));
                product.setProdInfo(rs.getString(4));
                product.setProdPrice(rs.getDouble(5));
                product.setProdQuantity(rs.getInt(6));
                product.setProdImage(rs.getAsciiStream(7));
                
                products.add(product);
            }
        }catch(SQLException ex){
            ex.printStackTrace();
        }
        
        return products;
    }

    @Override
    public List<ProductBean> searchAllProducts(String search) {
        List<ProductBean> products = new ArrayList<>();
        String query = "SELECT * FROM PRODUCTS WHERE LOWER(pType) LIKE ? OR LOWER(pName) LIKE ? OR LOWER(pInfo) LIKE ?";
        search = "%" + search + "%";
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString(1));
                product.setProdName(rs.getString(2));
                product.setProdType(rs.getString(3));
                product.setProdInfo(rs.getString(4));
                product.setProdPrice(rs.getDouble(5));
                product.setProdQuantity(rs.getInt(6));
                product.setProdImage(rs.getAsciiStream(7));
                
                products.add(product);
            }
        }catch(SQLException ex){
            ex.printStackTrace();
        }
        
        return products;
    }

    @Override
    public byte[] getProductImage(String prodId) {
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        byte[] image = null;
        
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement("SELECT image FROM PRODUCTS WHERE pId=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();
            if(rs.next()){
                image = rs.getBytes("image");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        dbUtil.closeConnection(conn);
        dbUtil.closeConnection(ps);
        dbUtil.closeConnection(rs);
        return image;
    }

    @Override
    public ProductBean getProductDetails(String prodId) {
        //List<ProductBean> products = new ArrayList<>();
        ProductBean product = null;
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try{
            ps = conn.prepareStatement("SELECT * FROM PRODUCTS WHERE pId=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();
            if(rs.next()){
                product = new ProductBean();
                product.setProdId(rs.getString(1));
                product.setProdName(rs.getString(2));
                product.setProdType(rs.getString(3));
                product.setProdInfo(rs.getString(4));
                product.setProdPrice(rs.getDouble(5));
                product.setProdQuantity(rs.getInt(6));
            }
            //System.out.println("Product Details:"+product.toString());
        }catch(SQLException ex){
            System.out.println("Errro in fetching product details from db:"+ex.getMessage());
            ex.printStackTrace();
        }
        
        return product;
    }

    @Override
    public String updateProductWithoutImage(String prevProductId, ProductBean updatedProduct) {
        String status = "Product Updation Failed!";
        
        if(!prevProductId.equals(updatedProduct.getProdId())){
            status = "Both Products are Different, Updation Failed!";
            System.out.println("prev ID:"+prevProductId+" &ProductBean ID:"+updatedProduct.getProdId());
            return status;
        }
        int prevQuantity = new ProductServiceImpl().getProductQuantity(prevProductId);
        Connection conn = dbUtil.provideConnection();
        PreparedStatement ps = null;
        String query = "UPDATE PRODUCTS SET pName=?, pType=?, pInfo=?, pPrice=?, pQuantity=? WHERE pId=?";
        try{
            ps = conn.prepareStatement(query);
            ps.setString(1, updatedProduct.getProdName());
            ps.setString(2, updatedProduct.getProdType());
            ps.setString(3, updatedProduct.getProdInfo());
            ps.setDouble(4, updatedProduct.getProdPrice());
            ps.setInt(5, updatedProduct.getProdQuantity());
            ps.setString(6, updatedProduct.getProdId());
            
            int k = ps.executeUpdate();
            if((k > 0 ) && (prevQuantity < updatedProduct.getProdQuantity())){
                status = "Product update Successfully.";
                
                //below this code the demand list for customers demanded
                
                List<DemandBean> demandList = new DemandServiceImpl().haveDemanded(prevProductId);
                for(DemandBean demand : demandList){
                    String userFName = new UserServiceImpl().getFirstName(demand.getUserName());
                    try{
                        MailMessage.productAvailableNow(demand.getUserName(), userFName, updatedProduct.getProdName(), prevProductId);
                    }catch(Exception ex){
                        System.out.println("Mail sending Failed Error:"+ex.getMessage());
                    }
                    boolean flag = new DemandServiceImpl().removeProduct(demand.getUserName(), prevProductId );
                    
                    if(flag)
                        status += "And Mail Send to the customers who were waiting for this products.";
                }
                
            }else if(k>0){
                status = "Product update Successfully.";
            }else{
                status = "Product is not available in this store.";
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        return status;
    }

    @Override
    public double getProductPrice(String prodId) {
        double prodPrice = 0;
        String query = "SELECT pPrice FROM PRODUCTS WHERE pId=?";
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, prodId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                prodPrice = rs.getDouble("pPrice");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        return prodPrice;
    }

    @Override
    public boolean sellNoProduct(String prodId, int n) {
        boolean flag = false;
        String query = "UPDATE PRODUCTS SET pQuantity = (pQuantity - ?) WHERE pId = ?";
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, n);
            ps.setString(2, prodId);
            
            int k = ps.executeUpdate();
            
            if(k>0){
                flag = true;
            }
        }catch(SQLException ex){
            flag = false;
            ex.printStackTrace();
        }
        System.out.println("sell No of product: "+flag);
        return flag;
    }

    @Override
    public int getProductQuantity(String prodId) {
        int prodQuantity = 0;
        String query = "SELECT pQuantity FROM PRODUCTS WHERE pId=?";
        
        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, prodId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                prodQuantity = rs.getInt("pQuantity");
            }
            //System.out.println("productQuantity:"+prodQuantity);
        } catch (SQLException ex) {
            System.out.println("Eror in fetching prod quantity:"+ex.getMessage());
            ex.printStackTrace();
        }
        
        return prodQuantity;
    }

    @Override
    public List <String> getAllProductId() {
        List<String> productIds = new ArrayList<>();

        try{
            Connection conn = dbUtil.provideConnection();
            PreparedStatement ps  = conn.prepareStatement("SELECT pId FROM PRODUCTS");
            ResultSet rs  = ps.executeQuery();
            if(rs.next()){                
                productIds.add(rs.getString("pId"));
            }
        } catch (SQLException ex) {
            System.out.println("Error in fetching productId "+ex.getMessage());
            ex.printStackTrace();
        }
        return productIds;
    }
    
}
