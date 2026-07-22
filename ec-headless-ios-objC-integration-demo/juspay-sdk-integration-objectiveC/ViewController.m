//
//  ViewController.swift
//  bharatpex-sdk-integration-swift
//
//
import UIKit

// Importing BharatPeXPayment SDK
// block:start:import-bharatpexpayment-sdk

#import <BharatPeXPaymentSDK/BharatPeXPaymentSDK.h>
// block:end:import-bharatpexpayment-sdk


class ViewController: UIViewController {

    // Creating an object of BharatPeXPaymentServices class.
    // block:start:create-bharatpexpayment-services-instance

    self.bharatpexPaymentInstance = [[BharatPeXPaymentServices alloc] init];
    // block:end:create-bharatpexpayment-services-instance

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // Creating initiate payload JSON object
    // block:start:create-initiate-payload

    - (NSDictionary *)createInitiatePayload {
        NSDictionary *innerPayload = @{
            @"action": @"initiate",
            @"merchantId": @"<MERCHANT_ID>",
            @"clientId": @"<CLIENT_ID>",
            @"customerId": @"<CUSTOMER_ID>",
            @"xRoutingId": @"<X_ROUTING_ID>",
            @"environment": @"prod"
        };

        NSDictionary *sdkPayload = @{
            @"requestId": @"12398b5571d74c3388a74004bc24370c",
            @"service": @"in.bharatpex.bhartapexpaymenapi",
            @"payload": innerPayload
        };

        return sdkPayload;
    }
    // block:end:create-initiate-payload

    // Creating BharatPeXPaymentPaymentsCallbackAdapter
    // This callback will get all events from bharatpexPaymentService instance
      //block:start:create-bharatpexpayment-callback

    self.bharatpexPaymentCallbackHandler = ^(NSDictionary<NSString *,id> * _Nullable response) {
        NSDictionary *data = response;
        NSString *event = data[@"event"];

        if ([event isEqualToString:@"hide_loader"]) {
            // hide loader
        }
        // Handle Process Result
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
                    // user back-pressed from checkout screen without initiating any txn
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
    //block:end:create-bharatpexpayment-callback


    
    @IBAction func initiatePayments(_ sender: Any) {
        // Calling initiate on bharatpexPaymentService instance to boot up payment engine.
        // block:start:initiate-sdk
        
        NSDictionary *initPayload = [self createInitiatePayload];
        [self.bharatpexPaymentInstance initiate:self payload:initPayload callback:self.bharatpexPaymentCallbackHandler];
        // block:end:initiate-sdk
    }


    // Creating process payload JSON object
    // block:start:process-sdk-call

    if ([bharatpexPaymentInstance isInitialised]) {
          [bharatpexPaymentInstance process:processPayload];       
    }
    // block:end:process-sdk-call
    
}

