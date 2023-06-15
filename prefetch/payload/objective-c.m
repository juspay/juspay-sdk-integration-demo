NSString *clientId = @"clientId"; //Unique resource identifier

//Setting clientId as nested to ensure uniformity across payloads
NSMutableDictionary *innerPayload = [NSMutableDictionary new];
innerPayload[@"clientId"] = clientId;

//Service acts as a product refrence
NSDictionary *payload = @{
   @"payload" : innerPayload,
   @"service" : @"in.juspay.hyperapi" 
};
      
[HyperServices preFetch:payload];