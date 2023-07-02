
// Getting initiate payload
// block:start:get-initiate-payload

var initiatePayload = {
  "requestId": const Uuid().v4(),
  "service": "in.juspay.hyperapi",
  "payload": {
    "action": "initiate",
    "merchantId": "<merchant-id>",
    "clientId": "<client-id>",
    "environment": "production"
  }
};
// block:end:get-initiate-payload

// Calling initiate on hyperSDK instance to boot up payment engine.
// block:start:initiate-sdk

await HyperServices.initiate(initiatePayload);
// block:end:initiate-sdk



