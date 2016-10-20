//
//  OfferStore.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

class OfferStore: NSObject, XMLParserDelegate {
    
    enum Fields: String {
        case Offer = "item"
        case Name = "title"
        case Category = "categoryName"
        case Country = "country"
        case Price = "currentPrice"
    }
    
    var parser = XMLParser()
    var currentElement = String()
    var passOffer = false
    var offersDictionary = [[String: String]]()
    var currentOffer = [String: String]()
    
    let eBayAPI = EBayAPI()
    
    let session: URLSession = {
       let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchOffersByISBN(isbn: String, completion: @escaping (OfferResults) -> Void) {
        
        if let url = EBayAPI.getEbaySandBoxURL(method: MethodEBay.FindOffers) {
            let soapMessage = EBayAPI.getSOAPEnvelopeWithISBN(method: .FindOffers, isbn: isbn, results: 10)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = soapMessage.data(using: .utf8)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                let result = self.processOfferDataRequest(data: data, error: error)
                completion(result)
            })
            
            task.resume()
        }
    }
    
    func processOfferDataRequest(data: Data?, error: Error?) -> OfferResults {
        guard let xmlData = data else {
            return .Failure(error!)
        }
        
        return self.eBayAPI.offersFromXMLData(data: xmlData)
    }
}
