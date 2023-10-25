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