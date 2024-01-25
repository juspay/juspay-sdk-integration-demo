import okhttp3.*;
import org.json.JSONObject;

public JSONObject createSession() {
  JSONObject payload = new JSONObject();
  try {
    String apiKey = "<your_api_key>";
    String clientId = "<your_client_id>";
    String merchantId = "<your_merchant_id>";


    payload.put("order_id", "testing-order-id-four");
    payload.put("amount", "1.0");
    payload.put("customer_id", "9876543201");
    payload.put("customer_email", "test@mail.com");
    payload.put("customer_phone", "9876543201");
    payload.put("payment_page_client_id", clientId);
    payload.put("action", "paymentPage");
    payload.put("offer_code", "testingCode");
    payload.put("first_name", "john");
    payload.put("last_name", "wick");
    payload.put("description", "Order Description");

    OkHttpClient okHttpClient = new OkHttpClient();

    MediaType mediaType = MediaType.parse("application/json");
    RequestBody requestBody = RequestBody.create(mediaType, payload.toString());

    String authorization = "Basic " + Base64.getEncoder()
      .encodeToString(apiKey.concat(":").getBytes());

    Request request =
        new Request.Builder()
            .url("https://api.juspay.in/session")
            .method("POST", requestBody)
            .addHeader("x-merchantid", merchantId)
            .addHeader("Authorization", authorization)
            .addHeader("Content-Type", "application/json")
            .build();
    Response response = okHttpClient.newCall(request).execute();
    JSONObject responseJSON = new JSONObject(response.body().string());
    return responseJSON;

  } catch (Exception e) {
    e.printStacktrace();
  }
  "test"

}
