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
        
        if let url = EBayAPI.getEbaySandBoxURL() {
            let soapMessage = EBayAPI.getSOAPEnvelopeWithISBN(method: .FindOffers, isbn: isbn)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = EBayAPI.getSOAPEnvelopeWithISBN(method: .FindOffers, isbn: isbn).data(using: .utf8)
            request.addValue("FindingService", forHTTPHeaderField: "X-EBAY-SOA-SERVICE-NAME")
            request.addValue("findItemsByProductRequest", forHTTPHeaderField: "X-EBAY-SOA-OPERATION-NAME")
            request.addValue("1.13.0", forHTTPHeaderField: "X-EBAY-SOA-SERVICE-VERSION")
            request.addValue("AaltoUni-ws-SBX-3e6eb0ea5-11d466dd", forHTTPHeaderField: "X-EBAY-SOA-SECURITY-APPNAME")
            request.addValue("SOAP", forHTTPHeaderField: "X-EBAY-SOA-REQUEST-DATA-FORMAT")
            request.addValue("SOAP12", forHTTPHeaderField: "X-EBAY-SOA-MESSAGE-PROTOCOL")
            let msgLength = soapMessage.characters.count
            request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
            
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
