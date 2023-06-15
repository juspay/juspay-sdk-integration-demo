let clientId = "clientId" //Unique resource identifier

//Setting clientId as nested to ensure uniformity across payloads
var innerPayload : [String:Any] = [:]
innerPayload["clientId"] = clientId

//Service acts as a product refrence
let payload = [
   "payload" : innerPayload,
   "service" : "in.juspay.hyperapi" 
] as [String: Any]
      
HyperServices.preFetch(payload)