//
//  BookOffersViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class BookOffersViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var yearLaber: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var pictureImage: UIImageView!
    @IBOutlet var offersTable: UITableView!
    
    var isbnStore: ISBNStore!
    var offerStore: OfferStore!
    var book: Book!
    var offerDataSource = OfferDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offersTable.dataSource = offerDataSource
        fillBookInfo()
        
        isbnStore.fetchISBNById(id: book.goodReadsID) { (isbnResult) in
            if case let .Success(isbn) = isbnResult {
                self.offerStore.fetchOffersByISBN(isbn: isbn, completion: { (offerResults) in
                    if case let .Success(offers) = offerResults {
                        OperationQueue.main.addOperation({
                            self.offerDataSource.offers = offers
                            self.offersTable.reloadSections(IndexSet(integer: 0), with: .automatic)
                        })                        
                    }
                })
            }
        }
    }
    
    func fillBookInfo() {
        titleLabel.text = book.title
        authorLabel.text = book.author
        yearLaber.text = book.year
        ratingLabel.text = book.rating
        pictureImage.image = book.image
    }
    
    @IBAction func pay(_ sender: AnyObject) {
        performSegue(withIdentifier: "ShowPayment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPayment" {
            let destinationVc = segue.destination as! PaymentViewController
            destinationVc.localBankPayment = BankRESTPayment()
            destinationVc.amount = "34"
        }
    }
    
}
