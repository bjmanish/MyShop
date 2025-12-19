<%@ page import="java.util.List" %>
<%@ page import="com.myshop.beans.ProductBean" %>
<%@ page import="com.myshop.utility.FetchProductAPI" %>
<%@ page contentType="application/json" %>
<%
    List<ProductBean> products = FetchProductAPI.getAllProductDetails();
    StringBuilder json = new StringBuilder("[");
    for (int i = 0; i < products.size(); i++) {
        ProductBean p = products.get(i);
        json.append("{")
            .append("\"id\":\"").append(p.getProdId()).append("\",")
            .append("\"name\":\"").append(p.getProdName().replace("\"","\\\"")).append("\",")
            .append("\"type\":\"").append(p.getProdType()).append("\",")
            .append("\"price\":").append(p.getProdPrice()).append(",")
            .append("\"info\":\"").append(p.getProdInfo().replace("\"","\\\"")).append("\",")
            .append("\"image\":\"").append(p.getProdImage()).append("\"")
            .append("}");
        if (i < products.size() - 1) json.append(",");
    }
    json.append("]");
    out.print(json.toString());
%>
