package com.myshop.utility;

import com.myshop.service.impl.UserServiceImpl;
import java.util.Base64;

public class PasswordEncryption {
    public static String getEncryptedPassword(String pwd){
        Base64.Encoder en=Base64.getEncoder();
        String encryptedPwd=en.encodeToString(pwd.getBytes());
        return encryptedPwd;
    }
    public static String getDecryptedPassword(String pwd){
        Base64.Decoder dec=Base64.getDecoder();
        byte[]arr=dec.decode(pwd.getBytes());
        String decryptedPwd=new String(arr);
        return decryptedPwd;
    }
   
    public static void main(String[] args) throws Exception {
//        System.out.println("Decrypted password :"+getDecryptedPassword("YWRtaW5AMTIz"));
//        System.out.println("Encrypted Password :"+getEncryptedPassword("admin@123"));

//        System.out.println("USER ID: "+new UserServiceImpl().generateUserId());
    }
}
