//
//  ExternalBankRESTPayment.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 20/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

class ExternalBankRESTPayment {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func requestPayment(amount: Float, name: String, card: String, year: String, month: String, csv: String, completion: @escaping (ExternalBankResult) -> Void) {
        
        let url = ExternalBankRESTAPI.externalBankURL(method: .CardPayment)
        if let body = ExternalBankRESTAPI.createJSONBody(amount: amount, owner: name, cardNumber: card, expireYear: year, expireMonth: month, csvString: csv) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: .utf8)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                let result = self.proccessData(data: data, error: error)
                completion(result)
            })
            
            task.resume()
        }
    }
    
    func proccessData(data: Data?, error: Error?) -> ExternalBankResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return ExternalBankRESTAPI.messageFromJSONData(data: jsonData)
    }
}
