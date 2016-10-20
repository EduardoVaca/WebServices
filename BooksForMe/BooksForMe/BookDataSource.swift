//
//  BookDataSource.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit


class BookDataSource: NSObject, UITableViewDataSource {
    
    var books = [Book]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "BookCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BookTableViewCell
        cell.selectionStyle = .none
        let book = books[indexPath.row]
        cell.bookName.text = book.title
        cell.authorName.text = book.author
        cell.rating.text = book.rating
        cell.year.text = book.year
        cell.updateWithImage(image: book.image)
        
        return cell
    }
}
