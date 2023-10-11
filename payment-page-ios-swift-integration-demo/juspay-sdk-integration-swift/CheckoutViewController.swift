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

    
    
    // Note: Session API should only be called from merchant's server. Don't call it from client app
    // -----------------------------------------------------------------
    func createOrder(completion: @escaping ([String: Any]?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        let orderId = String(Int.random(in: 10000000...99999999))

        let parameters = """
        {
            "order_id": "\(orderId)",
            "amount": "\(totalpayable)",
            "customer_id": "9876543201",
            "customer_email": "test@mail.com",
            "customer_phone": "9876543201",
            "payment_page_client_id": "<CLIENT_ID>",
            "action": "paymentPage",
            "return_url": "https://shop.merchant.com",
            "description": "OrderDescription",
            "first_name": "John",
            "last_name": "wick"
        }
        """ 
        
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.juspay.in/session")!, timeoutInterval: Double.infinity)
        request.addValue("Basic \(Data("<YOUR_API_KEY>".utf8).base64EncodedString())", forHTTPHeaderField: "Authorization")
        request.addValue("<MERCHANT_ID>", forHTTPHeaderField: "x-merchantid")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                semaphore.signal()
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let sdkPayload = json["sdk_payload"] as? [String: Any] {
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

    // -----------------------------------------------------------------
    

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
