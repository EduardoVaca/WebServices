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
    
}
