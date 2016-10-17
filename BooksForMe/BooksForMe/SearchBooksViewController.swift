//
//  SearchBooksViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class SearchBooksViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var bookStore: BookStore!
    let bookDataSource = BookDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = bookDataSource
        
        bookStore.fetchBookByName(name: "Harry") { (booksResult) in
            
            OperationQueue.main.addOperation({ 
                switch booksResult {
                case let .Success(books):
                    print("Successfully found: \(books.count) books")
                    self.bookDataSource.books = books
                case let .Failure(error):
                    print("Error fetching photot: \(error)")
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
            
            
        }
    }
}
