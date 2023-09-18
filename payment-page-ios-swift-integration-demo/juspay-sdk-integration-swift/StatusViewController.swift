//
//  StatusViewController.swift
//  juspay-sdk-integration-swift
//
//  Created by Arbinda Kumar Prasad on 08/06/23.
//

import UIKit

class StatusViewController: UIViewController {
    var txnStatus: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)

        if txnStatus! == "charged" {
            statusImage.image = UIImage.init(systemName: "checkmark.seal.fill")
            statusImage.tintColor = UIColor.systemBlue
            statusMessage.text = "Payment Successfull!"
            statusMessage.textColor = UIColor.systemBlue
            
        } else if txnStatus! == "pending_vbv" || txnStatus! == "authorizing" {
            statusImage.image = UIImage.init(systemName: "clock.badge.exclamationmark.fill")
            statusImage.tintColor = UIColor.systemOrange
            statusMessage.text = "Payment Pending..."
            statusMessage.textColor = UIColor.systemOrange

        } else {
            statusImage.image = UIImage.init(systemName: "exclamationmark.triangle.fill")
            statusImage.tintColor = UIColor.red
            statusMessage.text = "Payment Failed."
            statusMessage.textColor = UIColor.red
        }

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var statusCode: UILabel!
    
    @IBOutlet weak var statusMessage: UILabel!
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
