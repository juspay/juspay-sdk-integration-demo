{
  // Overriding onBackPressed to handle hardware backpress
  // block:start:onBackPressed

  import { App } from '@capacitor/app';

  .........
  .........

  App.addListener('backButton', async (data) => {
    const { onBackPressed } = await BharatPeXPaymentServices.onBackPressed();
    if (!onBackPressed) {
      window.history.back();
    }
  });
    // block:end:onBackPressed


  // Calling process on bharatpexPaymentSDK to open the checkout screen
  // block:start:process-sdk

  await BharatPeXPaymentServices.process(processPayload);
  // block:end:process-sdk
}

// Listen to events from BharatPeXPaymentSDK
// block:start:callbacklistener
BharatPeXPaymentServices.addListener('BharatPeXPaymentEvent', async (data) => {
   var event = data["event"];
   switch (event) {
      case "show_loader": {
         // Show a loader
      }
      break;
      case "hide_loader": {
         // Hide Loader
      }
      break;
      case "initiate_result": {
         // Initiate api response
      }
      break;
      case "process_result": {
         // Process result
      }
      break;
      default:
         let payload = data["payload"];
         console.log("process result: ", payload)
      break;
   }
});
// block:end:callbacklistener
