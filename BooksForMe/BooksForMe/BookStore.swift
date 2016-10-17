//
//  BookStore.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

/* 
    Class responsible for initializing the request to Good Reads server.
    Fetch books and download the photo of each book
 */

class BookStore: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var xmlStringData = String()
    var currentElement = String()
    var passData = false
    var passBook = false
    var currentBook = [String: String]()
    
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
    
    // Factory of URL Tasks
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchBookByName(name: String) {
        
        let url = GoodReadsAPI.searchBooksURL(bookName: name)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let xmlData = data {
                
                self.parser = XMLParser(data: xmlData)
                self.parser.delegate = self
                
                let success = self.parser.parse()
                
                if success {
                    print("SUCCESS")
                    
                }
                else {
                    print("Failure in Parser")
                }
            }
            else if let requestError = error {
                print("Error fetching book: \(requestError)")
            }
            else {
                print("Unexcpeted error")
            }
        }
        // By default the task is in 'suspend' mode.
        task.resume()        
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
            // Create book
            print(currentBook)
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
