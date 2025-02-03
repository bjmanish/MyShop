//package com.myshop.utility;
//
//import com.mashape.unirest.http.HttpResponse;
//import com.mashape.unirest.http.JsonNode;
//import com.mashape.unirest.http.Unirest;
//import java.awt.Image;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.ArrayList;
//import java.util.List;
//import javax.imageio.ImageIO;
//import org.json.JSONArray;
//import org.json.JSONObject;
//import com.myshop.beans.ProductBean;
//import java.awt.image.BufferedImage;
//
///**
// *
// * @author Admin
// */
//public class SpoonacularAPI {
//    public static List<ProductBean> getAllItemDetailsByName(String foodName)throws Exception{
//         String apiKey = "7f74954148884415903f1ff5f409a47b";
//         String apiUrl = " https://api.spoonacular.com/food/search?query=" + foodName + "&number=2&apiKey=" + apiKey;
//         List<ProductBean> foodList=new ArrayList<>();
//         HttpResponse<JsonNode> response = Unirest.get(apiUrl)
//                    .header("accept", "application/json")
//                    .asJson();
//
//            JSONObject jsonResponse = response.getBody().getObject();
//            JSONArray searchResultsArray = jsonResponse.getJSONArray("searchResults");
//            //System.out.println("SearchResultsArray:"+searchResultsArray);
//            for (int i = 0; i < searchResultsArray.length(); i++) {
//                JSONObject searchResult = searchResultsArray.getJSONObject(i);
//                JSONArray resultsArray = searchResult.getJSONArray("results");
//
//                for (int j = 0; j < resultsArray.length(); j++) {
//                    JSONObject result = resultsArray.getJSONObject(j);
//
//                    if (!result.has("name") || !result.has("image")) {
//                        continue;
//                    }
//                    String itemName = result.getString("name");
//                    String imageUrl = result.getString("image");
//                    String imageType = imageUrl.substring(imageUrl.lastIndexOf(".") + 1, imageUrl.length());
//
//                    if (itemName.isEmpty() || imageUrl.isEmpty()) {
//                        continue;
//                    }
//
//                    HttpURLConnection url = (HttpURLConnection) new URL(imageUrl).openConnection();
//                    url.addRequestProperty("user-agent", "mozilla");
//
//                    if (url.getResponseCode() != HttpURLConnection.HTTP_OK) {
//                        continue;
//                    }
//
//                   BufferedImage bufferedImage = ImageIO.read(url.getInputStream());
//                    Image image = bufferedImage;
//                    ProductBean product=new ProductBean();
//                    product.setProdName(itemName);
//                    product.setProdImage(image);
//                    product.setProdImageType(imageType);
//                    foodList.add(product);
//
//                }
//            }
//        return foodList;
//    }
//    public static void main(String[] args)throws Exception {
//        System.out.println(getAllItemDetailsByName("biryani"));
//    }
//    
//}
