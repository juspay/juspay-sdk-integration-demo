//
//  IntegViewController.m
//  DevTools
//
//  Created by Balaganesh on 04/04/22.
//  Copyright © 2022 Juspay. All rights reserved.
//

#import "ViewController.h"

// Importing Hyper SDK
// block:start:import-hyper-sdk
#import <HyperSDK/HyperSDK.h>
// block:end:import-hyper-sdk

@interface ViewController ()

// Declaring HyperServices property
@property (nonatomic, strong) HyperServices *hyperInstance;
@property (nonatomic, copy) HyperSDKCallback hyperCallbackHandler;

@end

@implementation ViewController


// Creating initiate payload JSON object
// block:start:create-initiate-payload
- (NSDictionary *)createInitiatePayload {
    NSDictionary *innerPayload = @{
        @"action": @"initiate",
        @"merchantId": @"flipkart",
        @"clientId": @"flipkart",
        @"environment": @"production"
    };

    NSDictionary *sdkPayload = @{
        @"requestId": @"12398b5571d74c3388a74004bc24370c",
        @"service": @"in.juspay.safe",
        @"payload": innerPayload
    };

    return sdkPayload;
}
// block:end:create-initiate-payload


// Creating process payload JSON object
// block:start:fetch-process-payload
- (NSDictionary *)createProcessPayload {
    // Make an API Call to your server to create Session and return SDK Payload
    //Payload received from Session API call
    NSDictionary *sdkProcessPayload = @{
        @"amount": @"1.0",
        @"action": @"startJuspaySafe",
        @"url": @"<https://shop.merchant.com>",
        @"orderId": @"testing-order-one",
        @"endUrls": ["<testingURL"]
    };
    
    NSDictionary *sdkPayload = @{
        @"requestId": NSUUID.UUID.UUIDString,
        @"service": @"in.juspay.safe",
        @"payload": sdkProcessPayload
    };

    return sdkPayload;
}
// block:end:fetch-process-payload

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //block:start:create-hyper-services-instance
    self.hyperInstance = [[HyperServices alloc] init];
    //block:end:create-hyper-services-instance
    
    //block:start:create-hyper-callback
    self.hyperCallbackHandler = ^(NSDictionary<NSString *,id> * _Nullable response) {
        NSDictionary *data = response;
        NSString *event = data[@"event"];
        
        if ([event isEqualToString:@"hide_loader"]) {
            // hide loader
        }
        // Handle Process Result
        // This case will reach once the Hypercheckout screen closes
        // block:start:handle-process-result

        else if ([event isEqualToString:@"process_result"]) {
            BOOL error = [data[@"error"] boolValue];

            NSDictionary *innerPayload = data[@"payload"];
            NSString *status = innerPayload[@"status"];
            NSString *pi = innerPayload[@"paymentInstrument"];
            NSString *pig = innerPayload[@"paymentInstrumentGroup"];

            if (!error) {
                // txn success, status should be "charged"
                // process data -- show pi and pig in UI maybe also?
                // example -- pi: "PAYTM", pig: "WALLET"
                // call orderStatus once to verify (false positives)
            } else {

                NSString *errorCode = data[@"errorCode"];
                NSString *errorMessage = data[@"errorMessage"];
                if([status isEqualToString:@"backpressed"]) {
                    // user back-pressed from PP without initiating any txn
                }
                else if ([status isEqualToString:@"backpressed"]) {
                    // user initiated a txn and pressed back
                    // poll order status
                } else if ([status isEqualToString:@"pending_vbv"] || [status isEqualToString:@"authorizing"]) {
                    // txn in pending state
                    // poll order status until backend says fail or success
                } else if ([status isEqualToString:@"authorization_failed"] || [status isEqualToString:@"authentication_failed"] || [status isEqualToString:@"api_failure"]) {
                    // txn failed
                    // poll orderStatus to verify (false negatives)
                } else if([status isEqualToString:@"new"]) {
                    // order created but txn failed
                    // very rare for V2 (signature based)
                    // also failure
                    // poll order status
                } else {
                    // unknown status, this is also failure
                    // poll order status
                }
            }
        }
        // block:end:handle-process-result
    };
    //block:end:create-hyper-callback
    
}


- (IBAction)initiatePayments:(id)sender {
    // Calling initiate on hyperService instance to boot up payment engine.
    // block:start:initiate-sdk
    NSDictionary *initPayload = [self createInitiatePayload];
    [self.hyperInstance initiate:self payload:initPayload callback:self.hyperCallbackHandler];
    // block:end:initiate-sdk
}
- (IBAction)startPayments:(id)sender {
    // Calling process on hyperService to open the Hypercheckout screen
    // block:start:process-sdk
    NSDictionary *processPayload = [self createProcessPayload];
    [self.hyperInstance process:processPayload];
    // block:end:process-sdk
}


@end
