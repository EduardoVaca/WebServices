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
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isbnStore.fetchISBNById(id: book.goodReadsID) { (isbnResult) in
            if case let .Success(isbn) = isbnResult {
                print(EBayAPI.getSOAPEnvelopeWithISBN(method: .FindOffers, isbn: isbn))
            }
        }
    }
}
