// This function creates intiate payload.
    private JSONObject createInitiatePayload() {
        JSONObject sdkPayload = new JSONObject();
        JSONObject innerPayload = new JSONObject();
        try {
            // generating inner payload
            innerPayload.put("action", "initiate");
            innerPayload.put("logLevel", "1");
            innerPayload.put("merchantId", "<MERCHANT_ID>");    // Put your Merchant ID here
            innerPayload.put("clientId", "CLIENT_ID");          // Put your Client ID here
            innerPayload.put("environment", "production");
            sdkPayload.put("requestId",  ""+ UUID.randomUUID());
            sdkPayload.put("service", "in.juspay.hyperpay");
            sdkPayload.put("payload", innerPayload);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return sdkPayload;
    }
