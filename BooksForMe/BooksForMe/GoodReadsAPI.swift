//
//  GoodReadsAPI.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

enum Method: String {
    case SearchBooks = "/search/index.xml"
    case ShowBookISBN = "/book/show.json"
}

enum BooksResult {
    case Success([Book])
    case Failure(Error)
}

enum GoodReadsError: Error {
    case NoBooksRetrieved
    case NoISBNFound
    case InvalidJSON
}

enum ISBNResult {
    case Success(String)
    case Failure(Error)
}

/* Struct that contains all the knowledge of GoodReads API */
struct GoodReadsAPI {
    
    private static let baseURLString = "http://www.goodreads.com"
    private static let apiKey = "uv1J3LcJ7zGuhzCXwaCcUQ"
    
    private static func goodReadsURL(method: Method, parameters: [String: String]?) -> URL {
        
        let methodURL = baseURLString + method.rawValue
        
        var components = URLComponents(string: methodURL)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParameters = ["key": apiKey]
        
        for (key, value) in baseParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func searchBooksURL(bookName: String) -> URL {
        return goodReadsURL(method: .SearchBooks, parameters: ["q": bookName])
    }
    
    static func bookISBNURL(bookID: String) -> URL {
        return goodReadsURL(method: .ShowBookISBN, parameters: ["id": bookID])
    }

    static func booksFromTempDictionary(dictionary: [[String: String]]) -> BooksResult {
        if dictionary.count > 0 {
            var finalBooks = [Book]()
            for item in dictionary {
                if let book = bookFromDictionaryItem(item: item) {
                    finalBooks.append(book)
                }
            }
            
            if finalBooks.count == 0 {
                return .Failure(GoodReadsError.NoBooksRetrieved)
            }
            
            return .Success(finalBooks)
        }
        return .Failure(GoodReadsError.NoBooksRetrieved)
    }
    
    private static func bookFromDictionaryItem(item: [String: String]) -> Book? {
        guard let bookId = item["id"],
            let bookTitle = item["title"],
            let bookAuthor = item["name"],
            let bookYear = item["original_publication_year"],
            let bookRating = item["average_rating"],
            let bookImage = item["image_url"],
            let bookImageURL = URL(string: bookImage) else {
                //Dont have enough info to create Book
                return nil
        }
        return Book(goodReadsID: bookId, title: bookTitle, author: bookAuthor, year: bookYear, rating: bookRating, imageURL: bookImageURL)
    }
    
    /* 
        IMPORTANT: The way of getting the ISBN from JSON Data in the following function is BAD.
        GoodReads returns a wrong constructed JSON from their API. So I had no other choice than
        work directly with the String returned.
    */
    static func isbnFromJSONData(data: Data) -> ISBNResult{
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String: String] else {                
                return .Failure(GoodReadsError.InvalidJSON)
            }
            for (_,value) in jsonDictionary {
                let lines = value.characters.split(separator: ";")
                for line in lines {
                    let lineStr = String(line)
                    if lineStr.hasPrefix("isbn="),
                        let firstEquals = lineStr.characters.index(of: "="),
                        let firstAmperson = lineStr.characters.index(of: "&"){
                        var isbn = String(lineStr.characters.prefix(upTo: firstAmperson).suffix(from: firstEquals))
                        isbn.remove(at: isbn.startIndex)
                        return .Success(isbn)
                    }
                }
            }
            
            return .Failure(GoodReadsError.NoISBNFound)
            
        } catch let error {
            return .Failure(error)
        }
    }
    
}
