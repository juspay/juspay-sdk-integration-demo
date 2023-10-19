hyperInstance.initiate(initiationPayload, new HyperPaymentsCallbackAdapter() {
   @Override
   public void onEvent(JSONObject data, JuspayResponseHandler handler) {
       try {
         String event = data.getString("event");
         if (event.equals("show_loader")) {
           // Show some loader here
         } else if (event.equals("hide_loader")) {
           // Hide Loader
         } else if (event.equals("initiate_result")) {
           // Get the response
           JSONObject response = data.optJSONObject("payload");
         } else if (event.equals("process_result")) {
           // Get the response
           JSONObject response = data.optJSONObject("payload");
           //Merchant handling
         }
       } catch (Exception e) {
         // merchant code...
       }  
    }
});