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

/* Class that contains all the knowledge of GoodReads API */
class GoodReadsAPI: NSObject, XMLParserDelegate {
    
    private static let baseURLString = "http://www.goodreads.com"
    private static let apiKey = "YOUR KEY HERE"
    
    private var parser = XMLParser()
    private var currentElement = String()
    private var passData = false
    private var passBook = false
    private var currentBook = [String: String]()
    private var books = [Book]()
    
    enum Fields: String {
        case workItem = "work"
        case bookItem = "best_book"
        case id = "id"
        case author = "name"
        case year = "original_publication_year"
        case rating = "average_rating"
        case title = "title"
        case image = "image_url"
    }

    
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
    
    func booksFromXMLData(data: Data) -> BooksResult {
        books.removeAll()
        self.parser = XMLParser(data: data)
        self.parser.delegate = self
        
        self.parser.parse()
        
        if books.count > 0 {
            return .Success(books)
        }
        else {
            return .Failure(GoodReadsError.NoBooksRetrieved)
        }
        
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
    
    /*
     XML Parser functions
     Implementation depends on the data returned and the interested fields.
     */
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName;
        if currentElement == Fields.workItem.rawValue {
            passData = true
        }
        else if currentElement == Fields.bookItem.rawValue {
            passBook = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if passData && elementName == Fields.workItem.rawValue {
            passData = false
            
            if let book = GoodReadsAPI.bookFromDictionaryItem(item: currentBook) {
                books.append(book)
            }
            
            currentBook.removeAll()
            currentElement = ""
        }
        if passBook && elementName == Fields.bookItem.rawValue {
            passBook = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if passData {
            switch currentElement {
            case Fields.rating.rawValue:
                if currentBook[Fields.rating.rawValue] == nil {
                    currentBook[Fields.rating.rawValue] = string
                }
            case Fields.year.rawValue:
                if currentBook[Fields.year.rawValue] == nil {
                    currentBook[Fields.year.rawValue] = string
                }
            default: break
            }
        }
        if passBook {
            switch currentElement {
            case Fields.id.rawValue:
                if currentBook[Fields.id.rawValue] == nil {
                    currentBook[Fields.id.rawValue] = string
                }
            case Fields.author.rawValue:
                if currentBook[Fields.author.rawValue] == nil {
                    currentBook[Fields.author.rawValue] = string
                }
            case Fields.title.rawValue:
                if currentBook[Fields.title.rawValue] == nil {
                    currentBook[Fields.title.rawValue] = string
                }
            case Fields.image.rawValue:
                if currentBook[Fields.image.rawValue] == nil {
                    currentBook[Fields.image.rawValue] = string
                }
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }

    
}
