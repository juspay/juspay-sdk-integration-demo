JSONObject preFetchPayload = new JSONObject();

try {
   JSONObject innerPayload = new JSONObject();
   String clientId = "<clientID>";
   innerPayload.put("clientId", clientId);
   preFetchPayload.put("payload", innerPayload);
   
   preFetchPayload.put("service","in.juspay.hyperpay");
} catch (JSONException e) {
   e.printStackTrace();
}

HyperServices.preFetch(this, preFetchPayload);