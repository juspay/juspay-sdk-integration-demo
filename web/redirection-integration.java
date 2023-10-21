const initiatePayload = {
   action: "initiate",
   clientId: "clientId",
   merchantId: "merchantId",
   environment: "environment",
   integrationType: "redirection"
};
 
const sdkPayload = {
   service: "in.juspay.hyperpay",
   requestId: "uuidV4-generated-unique-string",
   payload: initiatePayload
};

hyperServiceObject.initiate(sdkPayload)