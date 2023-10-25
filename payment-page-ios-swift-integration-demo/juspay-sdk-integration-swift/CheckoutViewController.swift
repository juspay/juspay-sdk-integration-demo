//
//  CheckoutViewController.swift
//  juspay-sdk-integration-swift
//
//  Created by Arbinda Kumar Prasad on 08/06/23.
//

import UIKit

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
                if hyperInstance.isInitialised() {
                    hyperInstance.baseViewController = self
                    // Calling process on hyperService to open the Hypercheckout screen
                    // block:start:process-sdk
                    hyperInstance.process(sdkProcessPayload)
                    // block:end:process-sdk
                }
            }
        }
    }

    
    
    // This create order call should be made on the merchants server
    func createOrder(completion: @escaping ([String: Any]?) -> Void) {
        // This function return the sdk_payload
        // To get the sdk_payload you need to hit your backend API which will again hit the Create Order API 
        // and the sdk_response from the Create Order API need to be passed here

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
