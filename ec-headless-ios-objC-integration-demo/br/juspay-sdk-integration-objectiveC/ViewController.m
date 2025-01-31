//
//  ViewController.m
//  juspay-sdk-integration-objc
//

#import "ViewController.h"

@interface ViewController ()

// Create an instance of HyperServices class
// block:start:create-global-juspay-payments-services-instance
@property (nonatomic, strong) HyperServices *hyperInstance;
// block:end:create-global-juspay-payments-services-instance

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize HyperServices class
    // Creating an object of HyperServices class.
    // block:start:create-hyper-services-instance
    self.hyperInstance = [[HyperServices alloc] initWithTenantId:"TENANT_NAME" clientId:"CLIENT_ID"];
    // block:end:create-hyper-services-instance
}

// Creating initiate payload JSON object
// block:start:create-initiate-payload
- (NSDictionary *)createInitiatePayload {
    NSDictionary *innerPayload = @{
        @"action": @"initiate",
        @"merchantId": @"<MERCHANT_ID>",
        @"clientId": @"<CLIENT_ID>",
        @"customerId": @"<CUSTOMER_ID>",
        @"environment": @"prod"
    };
    
    NSDictionary *sdkPayload = @{
        @"requestId": [[NSUUID UUID] UUIDString],
        @"service": @"in.juspay.hyperapi",
        @"payload": innerPayload
    };
    
    return sdkPayload;
}
// block:end:create-initiate-payload

// Creating GlobalJuspayPaymentsCallback
// This callback will get all events from globalJuspay Instance
// block:start:create-hyper-callback

self.hyperCallbackHandler = ^(NSDictionary<NSString *,id> * _Nullable response) {
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
// block:end:create-hyper-callback

// Initiating payments when button is clicked
- (IBAction)initiatePayments:(id)sender {
    // Calling initiate on hyperService instance to boot up payment engine.
    // block:start:initiate-sdk
    [self.hyperInstance initiate:self payload:initPayload callback:self.hyperCallbackHandler];
    // block:end:initiate-sdk
}

// Creating process payload JSON object
// block:start:process-sdk-call
- (void)processPaymentWithPayload:(NSDictionary *)processPayload {
    if ([self.hyperInstance isInitialised]) {
        [self.hyperInstance process:processPayload];
    }
}
// block:end:process-sdk-call

@end
