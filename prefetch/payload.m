NSDictionary *payload = @{
  @"service" : @"in.juspay.hyperpay",
  @"payload" : @{
      @"clientId" : @"<clientID>"
  }
};
 
[Hyper preFetch:payload];