boolean useBetaAssets = true; // If you want to use beta assets
String clientId =  "clientId"; // unique resource identifier
JSONObject payload = new JSONObject(); 
JSONObject innerPayload = new JSONObject();

try {
  //Setting clientId as nested to ensure uniformity across payloads
   innerPayload.put("clientId", clientId);
  //Ensuring proper nesting
   payload.put("payload", innerPayload);
  //service acts as a product refrence
   payload.put("service", "in.juspay.hyperapi"); 
} catch (JSONException e) {
   e.printStackTrace();
}
HyperServices.preFetch(getApplicationContext(), payload);