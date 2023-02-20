

//block:start:create-initiate-payload
// This function creates intiate payload.
private JSONObject createInitiatePayload() {
    JSONObject sdkPayload = new JSONObject();
    JSONObject innerPayload = new JSONObject();
    try {
        // generating inner payload
        innerPayload.put("action", "initiate");
        innerPayload.put("merchantId", "<MERCHANT_ID>");    // Put your Merchant ID here
        innerPayload.put("clientId", "<CLIENT_ID>");          // Put your Client ID here
        innerPayload.put("customerId", "<Customer Id>"); //Any unique refrences to current customer
        innerPayload.put("environment", "prod");
        sdkPayload.put("requestId",  ""+ UUID.randomUUID());
        sdkPayload.put("service", "in.juspay.hyperapi");
        sdkPayload.put("payload", innerPayload);

    } catch (Exception e) {
        e.printStackTrace();
    }
    return sdkPayload;
}
//block:end:create-initiate-payload

   