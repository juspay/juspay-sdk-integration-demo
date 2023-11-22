// Importing Hyper SDK
// block:start:import-hyper-sdk

import { Plugins } from '@capacitor/core';
import 'hyper-sdk-capacitor';

const { HyperServices } = Plugins;
// block:end:import-hyper-sdk

....

  // Create Juspay Object
  // // block:start:create-hyper-sdk-instance

  await HyperServices.createHyperServices();
  // await HyperServices.createHyperServices(clientId, service) 
  //service: "in.juspay.hyperpay" (For Payment Page),"in.juspay.hyperapi" (For Express Checkout)
  //clientId : "Client shared by Juspay"
  // // block:end:create-hyper-sdk-instance
  ....

