package com.myshop.utility;

import java.text.SimpleDateFormat;
import java.util.Date;

public class idUtil {
    
    public static String generatedId(){
        String pId = null;
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
        pId = sdf.format(new Date());
        pId = "P" + pId;
        return pId;
    }
    
    public static String generatedTransId(){
        String tId = null;
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
        tId = sdf.format(new Date());
        tId = "T" + tId;
        return tId;
    }
    
    
}
