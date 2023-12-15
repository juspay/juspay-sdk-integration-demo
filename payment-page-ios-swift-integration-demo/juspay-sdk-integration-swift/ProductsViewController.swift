//
//  ProductsViewController.swift
//  juspay-sdk-integration-swift
//
//  Created by Arbinda Kumar Prasad on 08/06/23.
//

import UIKit

var p1Price = 1
var p2Price = 2
var p1Qnty = 3
var p2Qnty = 4

class ProductsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        p1Outlet.text = "\(p1Qnty)"
        p2Outlet.text = "\(p2Qnty)"
    }
    
    @IBOutlet weak var p1Outlet: UITextView!
    
    
    @IBOutlet weak var p2Outlet: UITextView!
    
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

}
