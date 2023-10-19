[self.hyperInstance initiate:self payload:initiatePayload callback:^(NSDictionary<NSString *,id> * _Nullable response) {
        
    NSString *event = response[@"event"];
    
    if ([event isEqualToString:@"hide_loader"]) {
        // hide loader
    } else if ([event isEqualToString:@"initiate_result"]) {
        // handle initiate response
    } else if ([event isEqualToString:@"process_result"]) {
        
        BOOL error = response[@"error"];
        
        NSDictionary *innerPayload = response[@"payload"];
        NSString *status = innerPayload[@"status"];
        NSString *pi = innerPayload[@"paymentInstrument"];
        NSString *pig = innerPayload[@"paymentInstrumentGroup"];
        
        if (!error) {
            // txn success, status should be "charged"
            // process data -- show pi and pig in UI maybe also?
            // example -- pi: "PAYTM", pig: "WALLET"
            // call orderStatus once to verify (false positives)
        } else {
            
            NSString *errorCode = response[@"errorCode"];
            NSString *errorMessage = response[@"errorMessage"];
            
            if ([status isEqualToString:@"backpressed"]) {
                // user back-pressed from PP without initiating any txn
            } else if ([status isEqualToString:@"user_aborted"]) {
                // user initiated a txn and pressed back
                // poll order status
            } else if ([status isEqualToString:@"pending_vbv"] || [status isEqualToString:@"authorizing"]) {
                // txn in pending state
                // poll order status until backend says fail or success
            } else if ([status isEqualToString:@"authorization_failed"] || [status isEqualToString:@"authentication_failed"] || [status isEqualToString:@"api_failure"]) {
                // txn failed
                // poll orderStatus to verify (false negatives)
            } else if ([status isEqualToString:@"new"]) {
                // order created but txn failed
                // very rare for V2 (signature based)
                // also failure
                // poll order status
            } else {
                // unknown status, this is also failure
                // poll order status
            }
            
            // if txn was attempted, pi and pig would be non-empty
            // can be used to show in UI if you are into that
            // errorMessage can also be shown in UI
        }
    }
}];