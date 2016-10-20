//
//  PaymentViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 20/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var localBankPayment: BankRESTPayment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Looks for single or multiple taps anywhere on screen.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaymentViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Hide keyboard
        view.endEditing(true)
    }
    
}
