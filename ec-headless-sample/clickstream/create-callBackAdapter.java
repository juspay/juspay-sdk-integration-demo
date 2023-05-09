private HyperPaymentsCallbackAdapter createHyperPaymentsCallbackAdapter() {
        return new HyperPaymentsCallbackAdapter() {
            @Override
            public void onEvent(JSONObject jsonObject, JuspayResponseHandler responseHandler) {
                Intent redirect = new Intent(CheckoutActivity.this, ResponsePage.class);
                redirect.putExtra("responsePayload", jsonObject.toString());
                System.out.println(jsonObject);
                try {
                    String event = jsonObject.getString("event");
                    if (event.equals("hide_loader")) {
                        // Hide Loader
                        dialog.hide();
                    }
                    // Handle Process Result
                    // This case will reach once payment page closes
                    // block:start:handle-process-result
                    if (event.equals("log_stream")) {
                       // catch the relevant events from here 
                       }
                    else if (event.equals("process_result")) {
                        boolean error = jsonObject.optBoolean("error");
                        JSONObject innerPayload = jsonObject.optJSONObject("payload");
                        String status = innerPayload.optString("status");
                        if (!error) {
                            switch (status) {
                                case "charged":
                                    // Successful Transaction
                                    // check order status via S2S API
                                    redirect.putExtra("status", "OrderSuccess");
                                    startActivity(redirect);
                                    break;
                                case "cod_initiated":
                                    redirect.putExtra("status", "CODInitiated");
                                    startActivity(redirect);
                                    break;
                            }
                        } else {
                            switch (status) {
                                case "backpressed":
                                    // user back-pressed from PP without initiating transaction
                                    break;
                                case "user_aborted":
                                    // user initiated a txn and pressed back
                                    // check order status via S2S API
                                    Intent successIntent = new Intent(CheckoutActivity.this, ResponsePage.class);
                                    redirect.putExtra("status", "UserAborted");
                                    startActivity(redirect);
                                    break;
                                case "pending_vbv":
                                    redirect.putExtra("status", "PendingVBV");
                                    startActivity(redirect);
                                    break;
                                case "authorizing":
                                    // txn in pending state
                                    // check order status via S2S API
                                    redirect.putExtra("status", "Authorizing");
                                    startActivity(redirect);
                                    break;
                                case "authorization_failed":
                                    redirect.putExtra("status", "AuthorizationFailed");
                                    startActivity(redirect);
                                    break;
                                case "authentication_failed":
                                    redirect.putExtra("status", "AuthenticationFailed");
                                    startActivity(redirect);
                                    break;
                                case "api_failure":
                                    redirect.putExtra("status", "APIFailure");
                                    startActivity(redirect);
                                    break;
                                    // txn failed
                                    // check order status via S2S API
                            }
                        }
                    }
                    // block:end:handle-process-result
                } catch (Exception e) {
                    // merchant code...
                }
            }
        };
    }
