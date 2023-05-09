
//block:start:call-initiate
//This function initiate the Juspay SDK
private void initiatePaymentsSDK() {
    if(!hyperServicesHolder.isInitiated()){
        initiatePayload = createInitiatePayload();
        hyperServicesHolder.initiate(initiatePayload);

        //Showing snackbar
        Helper helper = new Helper();
        CoordinatorLayout coordinatorLayout = findViewById(R.id.coordinatorLayout2);
        helper.showSnackbar("Initiate Called!", coordinatorLayout);
    }
}
//block:end:call-initiate

  