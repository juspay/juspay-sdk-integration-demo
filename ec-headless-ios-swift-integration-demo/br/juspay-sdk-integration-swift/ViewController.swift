//
//  ViewController.swift
//  juspay-sdk-integration-swift
//
//
import UIKit

// Importing GlobalJuspayPaymentsSDK
// block:start:import-global-juspay-payments-sdk

import GlobalJuspayPaymentsSDK
// block:end:import-global-juspay-payments-sdk


class ViewController: UIViewController {

    // Create an instance of GlobalJuspayPaymentsServices
    // block:start:create-global-juspay-payments-services-instance

    let globalJuspayInstance = GlobalJuspayPaymentsServices();
    // block:end:create-global-juspay-payments-services-instance

    
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

    // Creating GlobalJuspayPaymentsCallback
    // This callback will get all events from globalJuspay Instance
    // block:start:create-hyper-callback

    let globalJuspayCallbackHandler : GlobalJuspayPaymentsCallback = { [weak self] (response) in
    	guard let self = self else {
        	return
    	}
        
    	if let data = response, let event = data["event"] as? String {
        	if (event == "hide_loader") {
            	// hide loader
        	}
        	// Handle Process Result
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
    	}
    }

    // block:end:create-hyper-callback

    
    @IBAction func initiatePayments(_ sender: Any) {
        // Calling initiate on hyperService instance to boot up payment engine.
        // block:start:initiate-sdk
        
        globalJuspayInstance.initiate(
            self,
            payload: createInitiatePayload(),
            callback: globalJuspayCallbackHandler
        )
        // block:end:initiate-sdk
    }


    // Creating process payload JSON object
    // block:start:process-sdk-call

    if globalJuspayInstance?.isInitialised() ?? false {
     globalJuspayInstance.process(processPayload)               
    }
    // block:end:process-sdk-call
    
}
