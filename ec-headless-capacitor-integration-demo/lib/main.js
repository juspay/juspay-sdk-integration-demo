// Importing BharatPeXPayment SDK
// block:start:import-bharatpexpayment-sdk

import { Plugins } from '@capacitor/core';
import 'bharatpexpayment-sdk-capacitor';

const { BharatPeXPaymentServices } = Plugins;
// block:end:import-bharatpexpayment-sdk

....

  // Create Juspay Object
  // // block:start:create-bharatpexpayment-sdk-instance

  await BharatPeXPaymentServices.createBharatPeXPaymentServices();
  // await BharatPeXPaymentServices.createBharatPeXPaymentServices(clientId, service) 
  //service: "hyperpay" (For Payment Page),"hyperapi" (For Express Checkout)
  //clientId : "Client shared by Juspay"
  // // block:end:create-bharatpexpayment-sdk-instance
  ....

