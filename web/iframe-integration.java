function hyperCallbackHandler(eventData){
   try {
       if (eventData){
           const eventJSON = typeof eventData === 'string' ? JSON.parse(eventData) : eventData;
           const event = eventJSON.event
           // Check for event key
           if (event == "initiate_result") {
               //Handle initiate result here
           } else if (event == "process_result") {
               //Handle process result here
           } else if (event == "user_event") {
               //Handle Payment Page events
           } else {
               console.log("Unhandled event",event, " Event data", eventData);           
           }
       } else {
           console.log("No data received in event",eventData);
       }
   } catch (error) {
       console.log("Error in hyperSDK response",error);
   }
}

const initiatePayload = {
   action: "initiate",
   clientId: "clientId",
   merchantId: "merchantId",
   environment: "environment",
   integrationType: "iframe",
   hyperSDKDiv: "merchantViewId" // Div ID to be used for rendering
};
 
const sdkPayload = {
   service: "in.juspay.hyperpay",
   requestId: "uuidV4-generated-unique-string",
   payload: initiatePayload
};

hyperServiceObject = new window.HyperServices();
hyperServiceObject.initiate(sdkPayload, hyperCallbackHandler)