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
    
    let goodReadsAPI = GoodReadsAPI()
    
    // Factory of URL Tasks
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func processBookSearchRequest(data: Data?, error: Error?) -> BooksResult {
        guard let data = data else {
            return .Failure(error!)
        }
        return goodReadsAPI.booksFromXMLData(data: data)
    }
    
    func fetchBookByName(name: String, completion: @escaping (BooksResult) -> ()) {
        let url = GoodReadsAPI.searchBooksURL(bookName: name)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processBookSearchRequest(data: data, error: error)
            completion(result)
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
    
    
}
