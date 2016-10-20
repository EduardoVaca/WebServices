//
//  BankRESTPayment.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

class BankRESTPayment {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func requestPayment(firstName: String, lastName: String, cardNumber: String, expireDate: String, securityNumber: String, amount: String, completion: @escaping (BankResult) -> Void) {
        
        let parameters = ["first_name": firstName,
                          "last_name": lastName,
                          "credit_card_number": cardNumber,
                          "expiration_date": expireDate,
                          "security_number": securityNumber,
                          "amount": amount]
        
        let url = BankRESTAPI.bankRESTURL(method: .ProcessPayment)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = BankRESTAPI.createBodyPOST(parameters: parameters)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = BankRESTAPI.messageFromData(data: data, error: error)
            
            completion(result)
        }
        
        task.resume()        
    }
}
