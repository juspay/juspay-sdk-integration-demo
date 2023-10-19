let payload = [
  "service" : "in.juspay.hyperpay",
  "payload" : [
      "clientId" : "<clientID>"
  ]
] as [String: Any]
    
Hyper.preFetch(payload)