//
//  SearchBooksViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class SearchBooksViewController: UIViewController {
    
    var bookStore: BookStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookStore.fetchBookByName(name: "Harry") { (booksResult) in
            switch booksResult {
            case let .Success(books):
                print("Successfully found: \(books.count) books")
            case let .Failure(error):
                print("Error fetching photot: \(error)")
            }
        }
    }
}
