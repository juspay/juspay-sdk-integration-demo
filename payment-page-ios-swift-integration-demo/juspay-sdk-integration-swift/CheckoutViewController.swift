//
//  CheckoutViewController.swift
//  juspay-sdk-integration-swift
//
//  Created by Arbinda Kumar Prasad on 08/06/23.
//

import UIKit
import HyperSDK

var totalpayable = 1;

class CheckoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        p1QntyOutlet.text = "x\(p1Qnty)"
        p2QntyOutlet.text = "x\(p2Qnty)"
        let total =  (p1Qnty * p1Price) + (p2Qnty * p1Price)
        let tax = (total * 18)/100
        totalpayable = total + tax
        
        p1Amount.text = "Rs. \(p1Qnty * p1Price)"
        p2Amount.text = "Rs. \(p2Qnty * p1Price)"
        totalAmount.text = "Rs. \(total)"
        taxOutlet.text = "Rs. \(tax)"
        totalPayableOutlet.text = "Rs. \(totalpayable)"
    }

    // block:start:fetch-process-payload
    func getProcessPayload(completion: @escaping ([AnyHashable: Any]?) -> Void) {
        // Make an API Call to your server to create Session and return SDK Payload
        // API Call should be made on the merchants server
        createOrder { jsonData in
            completion(jsonData)
        }
    }
    // block:end:fetch-process-payload

    
    
    
    @IBAction func startPayments(_ sender: Any) {
        getProcessPayload { sdkProcessPayload in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if (sdkProcessPayload != nil){
                    HyperCheckoutLite.openPaymentPage(self, payload: sdkProcessPayload!, callback: hyperCallbackHandler)
                }else{
                    // handle case when sdkProcessPayload is nils
                }
            }
        }
    }
    
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
                    if !error {
                        performSegue(withIdentifier: "statusSegue", sender: status)
                        // txn success, status should be "charged"
                        // process data -- show pi and pig in UI maybe also?
                        // example -- pi: "PAYTM", pig: "WALLET"
                        // call orderStatus once to verify (false positives)
                    } else {
                        switch status != nil ? status : "status not present" {
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
    
    func createOrder(completion: @escaping ([String: Any]?) -> Void) {
            let semaphore = DispatchSemaphore(value: 0)
            let endpoint = "http://127.0.0.1:5000/initiateJuspayPayment";
            var request = URLRequest(url: URL(string: endpoint)!, timeoutInterval: Double.infinity)

            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    semaphore.signal()
                    completion(nil)
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let sdkPayload = json["sdkPayload"] as? [String: Any] {
                        completion(sdkPayload)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Error: Failed to parse JSON - \(error)")
                    completion(nil)
                }

                semaphore.signal()
            }

            task.resume()
            semaphore.wait()
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
     */
    @IBOutlet weak var p1QntyOutlet: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var totalPayableOutlet: UILabel!
    @IBOutlet weak var taxOutlet: UILabel!
    @IBOutlet weak var p2Amount: UILabel!
    @IBOutlet weak var p1Amount: UILabel!
    @IBOutlet weak var p2QntyOutlet: UILabel!
}
