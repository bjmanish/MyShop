package com.myshop.service;

import com.myshop.utility.dbUtil;
import com.myshop.utility.idUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class PaymentDAO {

    public static void savePayment(String orderId, String userId, String txnId, Double amount, String status, String payu_hash) {
        try (Connection con = dbUtil.provideConnection()) {

            String sql = "INSERT INTO PAYMENTS_PAYU(payment_id1, order_id, user_id, txn_id, amount, status, payu_hash) VALUES(?,?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            String payId = idUtil.generateTransactionId();
            ps.setString(1, payId);
            ps.setString(2, orderId);
            ps.setString(3, userId);
            ps.setString(4, txnId);
            ps.setDouble(5, amount);
            ps.setString(6, status);
            ps.setString(7, payu_hash);
            int k = ps.executeUpdate();
            
            if(k>0)
                System.out.println("Payment PENDING:"+payId);
            else
                System.out.println("Payment FAILED");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void updatePayment(String txnId, String status, String mode) {
        try (Connection con = dbUtil.provideConnection()) {

            String sql = "UPDATE PAYMENTS_PAYU SET status=?, payment_mode=? WHERE txn_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, status);
            ps.setString(2, mode);
            ps.setString(3, txnId);

            int k = ps.executeUpdate();
            
            if(k>0)
                System.out.println("Payment SUCCESS");
            else
                System.out.println("Payment FAILED");         
            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}