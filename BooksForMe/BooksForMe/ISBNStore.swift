//
//  ISBNStore.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation


class ISBNStore {
    
    // Factory of URL Tasks
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchISBNById(id: String, completion: @escaping (ISBNResult) -> ()) {
        let url = GoodReadsAPI.bookISBNURL(bookID: id)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = self.processISBNRequest(data: data, error: error)
            
            completion(result)
        }
        task.resume()
    }
    
    func processISBNRequest(data: Data?, error: Error?) -> ISBNResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return GoodReadsAPI.isbnFromJSONData(data: jsonData)
    }
}
