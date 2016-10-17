//
//  BookStore.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

/* 
    Class responsible for initializing the request to Good Reads server.
    Fetch books and download the photo of each book
 */

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum BookError: Error {
    case ImageCreationError
}

class BookStore: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var currentElement = String()
    var passData = false
    var passBook = false
    var currentBook = [String: String]()
    var booksDictionary = [[String: String]]()
    
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
    
    func processBookSearchRequest(dictionary: [[String: String]], error: Error?) -> BooksResult {
        if let error = error {
            return .Failure(error)
        }
        return GoodReadsAPI.booksFromTempDictionary(dictionary: dictionary)
    }
    
    func fetchBookByName(name: String, completion: @escaping (BooksResult) -> ()) {
        
        let url = GoodReadsAPI.searchBooksURL(bookName: name)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            var result: BooksResult
            if let xmlData = data {
                
                self.parser = XMLParser(data: xmlData)
                self.parser.delegate = self
                
                self.parser.parse()
                
                result = self.processBookSearchRequest(dictionary: self.booksDictionary, error: error)
                completion(result)
            }
            else if let requestError = error {
                result = self.processBookSearchRequest(dictionary: self.booksDictionary, error: requestError)
                completion(result)
            }
        }
        // By default the task is in 'suspend' mode.
        task.resume()        
    }
    
    func fetchImageForBook(book: Book, completion: @escaping (ImageResult) -> Void) {
        
        // If the image was already downloaded just return it
        if let image = book.image {
            completion(.Success(image))
            return
        }
        
        let bookURL = book.imageURL
        let request = URLRequest(url: bookURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                book.image = image
            }
            
            completion(result)
            
        }
        
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                // Couldnt create image
                if data == nil {
                    return .Failure(error!)
                }
                else {
                    return .Failure(BookError.ImageCreationError)
                }
        }
        
        return .Success(image)
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

            booksDictionary.append(currentBook)
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
