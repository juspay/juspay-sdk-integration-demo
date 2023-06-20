//
//  ViewController.swift
//  juspay-sdk-integration-swift
//
//
import UIKit

// Importing Hyper SDK
// block:start:import-hyper-sdk

import HyperSDK
// block:end:import-hyper-sdk


class ViewController: UIViewController {

    // Creating an object of HyperServices class.
    // block:start:create-hyper-services-instance

    let hyperInstance = HyperServices();
    // block:end:create-hyper-services-instance

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // Creating initiate payload JSON object
    // block:start:create-initiate-payload

    func createInitiatePayload() -> [String: Any] {
        let innerPayload : [String: Any] = [
            "action": "initiate",
            "merchantId": "<MERCHANT_ID>",
            "clientId": "<CLIENT_ID>",
            "customerId": "<CUSTOMER_ID>",
            "environment": "prod"
        ];

        let sdkPayload : [String: Any] = [
            "requestId": UUID().uuidString,
            "service": "in.juspay.hyperapi",
            "payload": innerPayload
        ]

        return sdkPayload
    }
    // block:end:create-initiate-payload

    // Creating HyperPaymentsCallbackAdapter
    // This callback will get all events from hyperService instance
    // block:start:create-hyper-callback

    func hyperCallbackHandler(response : (Optional<Dictionary<String, Any>>)) {
        if let data = response, let event = data["event"] as? String {
            if (event == "hide_loader") {
                // hide loader
            }
            // Handle Process Result
            // block:start:handle-process-result
            else if (event == "process_result") {
                let error = data["error"] as! Bool

                let innerPayload = data["payload"] as! [ String: Any ]
                let status = innerPayload["status"] as! String
                let pi = innerPayload["paymentInstrument"] as? String
                let pig = innerPayload["paymentInstrumentGroup"] as? String

                if (!error) {
                    // txn success, status should be "charged"
                    // process data -- show pi and pig in UI maybe also?
                    // example -- pi: "PAYTM", pig: "WALLET"
                    // call orderStatus once to verify (false positives)
                } else {

                    let errorCode = data["errorCode"] as! String
                    let errorMessage = data["errorMessage"] as! String
                    switch (status) {
                        case "backpressed":
                            // user back-pressed from checkout screen without initiating any txn
                            break;
                        case "user_aborted":
                            // user initiated a txn and pressed back
                            // poll order status
                            break;
                        case "pending_vbv", "authorizing":
                            // txn in pending state
                            // poll order status until backend says fail or success
                            break;
                        case "authorization_failed", "authentication_failed", "api_failure":
                            // txn failed
                            // poll orderStatus to verify (false negatives)
                            break;
                        case "new":
                            // order created but txn failed
                            // also failure
                            // poll order status
                            break;
                        default:
                            // unknown status, this is also failure
                            // poll order status
                            break;
                    }
                }
            }
            // block:end:handle-process-result
        }

    }
    // block:end:create-hyper-callback

    
    @IBAction func initiatePayments(_ sender: Any) {
        // Calling initiate on hyperService instance to boot up payment engine.
        // block:start:initiate-sdk
        
        hyperInstance.initiate(
            self,
            payload: createInitiatePayload(),
            callback: hyperCallbackHandler
        )
        // block:end:initiate-sdk
    }


    // Creating process payload JSON object
    // block:start:process-sdk-call

    if hyperInstance?.isInitialised() ?? false {
     hyperInstance.process(processPayload)               
    }
    // block:end:process-sdk-call
    
}

