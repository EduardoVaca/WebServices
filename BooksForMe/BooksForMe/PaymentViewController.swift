//
//  PaymentViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 20/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var expireTextField: UITextField!
    @IBOutlet var csvTextField: UITextField!
    @IBOutlet var priceLabel: UILabel!
    
    var localBankPayment: BankRESTPayment!
    var offer: Offer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = String(offer.price!)
        // Looks for single or multiple taps anywhere on screen.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaymentViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Hide keyboard
        view.endEditing(true)
    }
    
    
    @IBAction func payWithLocalBank(_ sender: AnyObject) {
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let cardNumber = cardNumberTextField.text,
            let expireDate = expireTextField.text,
            let securityNumber = csvTextField.text {
            
                localBankPayment.requestPayment(firstName: firstName, lastName: lastName, cardNumber: cardNumber, expireDate: expireDate, securityNumber: securityNumber, amount: String(offer.price!), completion: { (bankResult) in
                    
                    var messageAlert = String()
                    var titleAlert = String()
                    
                    switch bankResult {
                    case let .Success(message):
                        messageAlert = message
                        titleAlert = "Transaction Info"
                    case .Failure(_):
                        messageAlert = "Error in transaction"
                        titleAlert = "Sorry"
                    }
                    
                    OperationQueue.main.addOperation({
                        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                            
                        })
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    })
                })
        }
        
    }
    
    
    @IBAction func payWithExternalBank(_ sender: AnyObject) {
    }
    
    
}
