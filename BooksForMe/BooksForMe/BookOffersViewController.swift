//
//  BookOffersViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class BookOffersViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var yearLaber: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var pictureImage: UIImageView!
    @IBOutlet var offersTable: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    var isbnStore: ISBNStore!
    var offerStore: OfferStore!
    var book: Book!
    var offerDataSource = OfferDataSource()
    var currentOffer: Offer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersTable.isHidden = true
        loader.startAnimating()
        offersTable.dataSource = offerDataSource
        offersTable.delegate = self
        offersTable.separatorColor = UIColor.brown
        offersTable.separatorStyle = .singleLine
        fillBookInfo()
        
        isbnStore.fetchISBNById(id: book.goodReadsID) { (isbnResult) in
            if case let .Success(isbn) = isbnResult {
                self.offerStore.fetchOffersByISBN(isbn: isbn, completion: { (offerResults) in
                    if case let .Success(offers) = offerResults {
                        OperationQueue.main.addOperation({
                            self.offerDataSource.offers = offers
                            self.loader.stopAnimating()
                            self.loader.isHidden = true
                            self.offersTable.isHidden = false
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentOffer = self.offerDataSource.offers[indexPath.row]
        self.performSegue(withIdentifier: "ShowPayment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPayment" {
            let destinationVc = segue.destination as! PaymentViewController
            destinationVc.localBankPayment = BankRESTPayment()
            destinationVc.externalBankPayment = ExternalBankRESTPayment()
            destinationVc.offer = currentOffer
        }
    }
    
}
