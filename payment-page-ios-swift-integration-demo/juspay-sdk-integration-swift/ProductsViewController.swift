//
//  ProductsViewController.swift
//  juspay-sdk-integration-swift
//
//  Created by Arbinda Kumar Prasad on 08/06/23.
//

import UIKit

// Importing Hyper SDK
// block:start:import-hyper-sdk
import HyperSDK
// block:end:import-hyper-sdk


// Creating an object of HyperServices class.
// block:start:create-hyper-services-instance
let hyperInstance = HyperServices();
// block:end:create-hyper-services-instance

var p1Price = 1
var p2Price = 2
var p1Qnty = 3
var p2Qnty = 4

class ProductsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        p1Outlet.text = "\(p1Qnty)"
        p2Outlet.text = "\(p2Qnty)"

        // Calling initiate on hyperService instance to boot up payment engine.
        // block:start:initiate-sdk
        hyperInstance.initiate(
            self,
            payload: createInitiatePayload(),
            callback: hyperCallbackHandler
        )
        // block:end:initiate-sdk
    }

    // Creating initiate payload JSON object
    // block:start:create-initiate-payload
    func createInitiatePayload() -> [String: Any] {
        let innerPayload : [String: Any] = [
            "action": "initiate",
            "merchantId": "flipkart",
            "clientId": "flipkart",
            "environment": "production"
        ];
        
        let sdkPayload : [String: Any] = [
            "requestId": UUID().uuidString,
            "service": "in.juspay.safe",
            "payload": innerPayload
        ]
        
        return sdkPayload
    }
    // block:end:create-initiate-payload
    
    @IBOutlet weak var p1Outlet: UITextView!
    
    
    @IBOutlet weak var p2Outlet: UITextView!


    // Creating HyperPaymentsCallbackAdapter
    // This callback will get all events from hyperService instance
    // block:start:create-hyper-callback
    func hyperCallbackHandler(response: [String: Any]?) {
        if let data = response, let event = data["event"] as? String {
            if event == "hide_loader" {
                // hide loader
            }
            // Handle Process Result
            // This case will reach once the Hypercheckout screen closes
            // block:start:handle-process-result
            else if event == "process_result" {
                let error = data["error"] as? Bool ?? false
                
                if let innerPayload = data["payload"] as? [String: Any] {
                    let status = innerPayload["status"] as? String
                    let pi = innerPayload["paymentInstrument"] as? String
                    let pig = innerPayload["paymentInstrumentGroup"] as? String
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    if !error {
                        performSegue(withIdentifier: "statusSegue", sender: status)
                        // txn success, status should be "charged"
                        // process data -- show pi and pig in UI maybe also?
                        // example -- pi: "PAYTM", pig: "WALLET"
                        // call orderStatus once to verify (false positives)
                    } else {
                        let errorCode = data["errorCode"] as? String
                        let errorMessage = data["errorMessage"] as? String
                        switch status! {
                        case "backpressed":
                            // user back-pressed from PP without initiating any txn
                            let alertController = UIAlertController(title: "Payment Cancelled", message: "User clicked back button on Payment Page", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            present(alertController, animated: true, completion: nil)

                            break
                        case "user_aborted":
                            // user initiated a txn and pressed back
                            // poll order status
                            let alertController = UIAlertController(title: "Payment Aborted", message: "Transaction aborted by user", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            present(alertController, animated: true, completion: nil)
                            break
                        case "pending_vbv", "authorizing":
                            performSegue(withIdentifier: "statusSegue", sender: status)
                            // txn in pending state
                            // poll order status until backend says fail or success
                            break
                        case "authorization_failed", "authentication_failed", "api_failure":
                            performSegue(withIdentifier: "statusSegue", sender: status)
                            // txn failed
                            // poll orderStatus to verify (false negatives)
                            break
                        case "new":
                            performSegue(withIdentifier: "statusSegue", sender: status)
                            // order created but txn failed
                            // very rare for V2 (signature based)
                            // also failure
                            // poll order status
                            break
                        default:
                            performSegue(withIdentifier: "statusSegue", sender: status)
                            // unknown status, this is also failure
                            // poll order status
                            break
                        }
                    }
                }
            }
            // block:end:handle-process-result
        }
    }
    // block:end:create-hyper-callback
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statusSegue" {
            if let destinationVC = segue.destination as? StatusViewController {                
                if let txnStatus = sender as? String {
                    print(txnStatus)
                    destinationVC.txnStatus = txnStatus
                }
            }
            if let txnStatus = sender as? String {
                print(txnStatus) 
            }
        }
    }
    
    @IBAction func increaseP1Qnty(_ sender: Any) {
        p1Qnty = p1Qnty + 1
        p1Outlet.text = "\(p1Qnty)"

    }
    @IBAction func decreaseP1Qnty(_ sender: Any) {
        p1Qnty = p1Qnty - 1
        p1Outlet.text = "\(p1Qnty)"

    }
    @IBAction func decreaseP2Qnty(_ sender: Any) {
        p2Qnty = p2Qnty - 1
        p2Outlet.text = "\(p2Qnty)"
    }
    @IBAction func increaseP2Qnty(_ sender: Any) {
        p2Qnty = p2Qnty + 1
        p2Outlet.text = "\(p2Qnty)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    */
    


}
