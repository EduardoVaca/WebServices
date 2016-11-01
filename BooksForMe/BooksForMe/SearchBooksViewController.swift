//
//  SearchBooksViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class SearchBooksViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    var bookStore: BookStore!
    let bookDataSource = BookDataSource()
    var searchText = String()
    var selectedBook: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isTranslucent = false
        tableView.dataSource = bookDataSource
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.separatorColor = UIColor.brown
        tableView.separatorStyle = .singleLine
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().backgroundColor = UIColor.brown        
        loader.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let book = bookDataSource.books[indexPath.row]
        
        // Download the imageData...
        bookStore.fetchImageForBook(book: book) { (imageResult) in
            OperationQueue.main.addOperation({ 
                //The index path for the book might have changed. Find the most recent one
                let bookIndex = self.bookDataSource.books.index(of: book)!
                let bookIndexPath = IndexPath(row: bookIndex, section: 0)
                
                // When the request finishes, only update the cell if its visible
                if let cell = self.tableView.cellForRow(at: bookIndexPath) as? BookTableViewCell {
                    cell.updateWithImage(image: book.image)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = self.bookDataSource.books[indexPath.row]
        self.performSegue(withIdentifier: "ShowBookOffers", sender: self)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loader.isHidden = false
        loader.startAnimating()
        
        bookStore.fetchBookByName(name: searchText) { (booksResult) in
            
            OperationQueue.main.addOperation({
                self.loader.stopAnimating()
                self.loader.isHidden = true
                switch booksResult {
                case let .Success(books):
                    print("Successfully found: \(books.count) books")
                    self.bookDataSource.books = books
                case let .Failure(error):
                    print("Error fetching photot: \(error)")
                }
                self.tableView.isHidden = false
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookOffers" {
            let destinationVc = segue.destination as! BookOffersViewController
            destinationVc.book = selectedBook
            destinationVc.isbnStore = ISBNStore()
            destinationVc.offerStore = OfferStore()
        }
    }
    
}
