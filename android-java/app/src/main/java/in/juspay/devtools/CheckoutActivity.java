
{
    //block:start:process-sdk-call

    if (hyperInstance.isInitialised()){
    hyperInstance.process(processPayload);
}
    //block:end:process-sdk-call



    // block:start:create-hyper-callback
    
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
                    // This case will reach once the Hypercheckout screen closes
                    // block:start:handle-process-result
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
    // block:end:create-hyper-callback



    //block:start:onBackPressed
    
    @Override
    public void onBackPressed() {
        boolean handleBackpress = hyperServicesHolder.onBackPressed();
        if(!handleBackpress) {
            super.onBackPressed();
        }

    }
    //block:end:onBackPressed

    

    /*
    Optional Block
    These functions are only supposed to be implemented in case if you are overriding
    onActivityResult or onRequestPermissionsResult Life cycle hooks


    - onActivityResult
    - Handling onActivityResult hook and passing data to HyperServices Instance, to handle App Switch
    @Override
    public void onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        // block:start:onActivityResult

        // If super.onActivityResult is available use following:
        // super.onActivityResult(requestCode, resultCode, data);

        // In case super.onActivityResult is NOT available please use following:
        // if (data != null) {
        //    hyperServices.onActivityResult(requestCode, resultCode, data);
        // }

        // block:end:onActivityResult

        // Rest of your code.
    }


    - onRequestPermissionsResult
    - Handling onRequestPermissionsResult hook and passing data to HyperServices Instance, to OTP reading permissions
    @Override
    public void onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        // block:start:onRequestPermissionsResult

        //  If super.onRequestPermissionsResult is available use following:
        // super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        // In case super.onActivityResult is NOT available please use following:
        // hyperServices.onRequestPermissionsResult(requestCode, permissions, grantResults);

        // block:end:onRequestPermissionsResult
    }
     */
}