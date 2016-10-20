//
//  OfferStore.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

class OfferStore {
    
    let session: URLSession = {
       let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchOffersByISBN(isbn: String) {
        
        if let url = EBayAPI.getEbaySandBoxURL(method: MethodEBay.FindOffers) {
            let soapMessage = EBayAPI.getSOAPEnvelopeWithISBN(method: .FindOffers, isbn: isbn, results: 10)
            print("MESSAGE: \(soapMessage)")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = soapMessage.data(using: .utf8)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                print("Response: \(response)")
                if let data = data {
                    print("Data \(data)")
                }
                else if let error = error {
                    print("Error \(error)")
                }
                else {
                    print("Response: \(response)")
                }                
            })
            
            task.resume()
        }
        
    }
}
