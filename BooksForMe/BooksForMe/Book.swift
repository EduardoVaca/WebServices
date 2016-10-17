//
//  Book.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

class Book {
    
    let goodReadsID: String
    let title: String
    let author: String
    let year: String
    let rating: String
    let imageURL: URL
    
    init(goodReadsID: String, title: String, author: String, year: String, rating: String, imageURL: URL) {
        self.goodReadsID = goodReadsID
        self.title = title
        self.author = author
        self.year = year
        self.rating = rating
        self.imageURL = imageURL
    }
}
