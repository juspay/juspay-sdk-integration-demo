[self.hyperInstance initiate:self payload:initiationPayload callback:^(NSDictionary *data) {
      if (data && data[@"event"]) {
          if ([event isEqualToString:@"show_loader"]) {
              // Show some loader here
          } else if ([event isEqualToString:@"hide_loader"]) {
              // Hide Loader
          } else if ([event isEqualToString:@"initiate_result"]) {
              // Get the payload
              NSDictionary *payload = data["payload"];
          } else if ([event isEqualToString:@"process_result"]) {
              // Get the payload
              NSDictionary *payload = data["payload"];
              // Merchant handling
          }
      } else {
        //Error handling
     }
}];