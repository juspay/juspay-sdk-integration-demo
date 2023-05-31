self.hyperInstance.hyperSDKCallback = ^(NSDictionary<NSString *,id> * _Nullable data) {
    if (data && data[@"event"]) {
        if ([event isEqualToString:@"initiate_result"]) {

        } else if ([event isEqualToString:@"process_result"]) {

        }
    }      
};