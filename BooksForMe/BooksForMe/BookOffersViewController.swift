//
//  BookOffersViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class BookOffersViewController: UIViewController {
    
    var isbnStore: ISBNStore!
    var offerStore: OfferStore!
    var book: Book!        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*isbnStore.fetchISBNById(id: book.goodReadsID) { (isbnResult) in
            if case let .Success(isbn) = isbnResult {
                self.offerStore.fetchOffersByISBN(isbn: isbn)
            }
        }*/
        
    }
    
    @IBAction func pay(_ sender: AnyObject) {
        performSegue(withIdentifier: "ShowPayment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPayment" {
            let destinationVc = segue.destination as! PaymentViewController
            destinationVc.localBankPayment = BankRESTPayment()
        }
    }
    
}
